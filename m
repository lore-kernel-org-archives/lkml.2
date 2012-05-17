Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727Ab2EQVrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:47:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57673 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761138Ab2EQVrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:47:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20120517170015.GA12436@redhat.com> (Oleg Nesterov's message of
	"Thu, 17 May 2012 19:00:15 +0200")
References: <20120428142605.GA20248@redhat.com>
	<m14ns355ru.fsf@fess.ebiederm.org> <20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com>
	<20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com>
	<20120517170015.GA12436@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 17 May 2012 15:46:53 -0600
Message-ID: <87d3628oqa.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18Zqw4JkCQvCLmBGlzWL2wTVC5EB11dp5g=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0232]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the last pidns process reaped.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 05/16, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > Hmm. I don't think the patch is 100% correct. Afaics, this needs more
>> > delay_pidns_leader() checks.
>> >
>> > For example. Suppose we have a CLONE_NEWPID zombie I, it has an
>> > EXIT_DEAD child D so delay_pidns_leader(I) == T.
>> >
>> > Now suppose that I->real_parent exits, lets denote this task as P.
>> >
>> > Suppose that P->real_parent ignores SIGCHLD.
>> >
>> > In this case P will do release_task(I) prematurely. And worse, when
>> > D finally does realease_task(D) it will do realease_task(I) again.
>>
>> Good point.  I will fix that and post a patch shortly.  It doesn't
>> need a full delay_pidns_leader test just a test for children.
>
> This will add more complications. And even this is not enough, I guess.
> For example __ptrace_detach()...

Agreed.  I am having to step back and think about this a bit more.

I don't like doing things two different ways but delay_thread_group
leader and all of that is pretty horrible from a maintenance point
of view and extending that just makes things worse.

> I agree, the idea to "hack" release_task() so that it switches to
> init is clever, but imho this is too clever ;)
>
> Seriously, what do you think about the patch below? Or something
> like this. It is still based on your suggestion to check ->children,
> but it is much, much more simple and understandable.
>
> Just in case... Even with the PF_EXITING check __wake_up_parent()
> can be wrong, but this is very unlikely and harmless.
>
> What do you think?

I think there is something very compelling about your solution,
we do need my bit about making the init process ignore SIGCHLD
so all of init's children self reap.

Before I go farther I am going to play with the code more.

In part I think the current code for waiting for processes to
die etc is pretty horrible maintenance wise and it might just
be worth cleaning up before we extending it with yet another
strange and bizarre case, if for no other reason than to make
it clear what we are doing.


>> In looking for any other weird corner case bugs I am noticing that
>> I don't think I handled the case of a ptraced init quite right.
>> I don't understand the change signaling semantics when the
>> ptracer is our parent.
>
> Do you mean the "if (tsk->ptrace)" code in exit_notify() ? Nobody
> understand it ;) Last time this code was modified by me (iirc), but
> I simply tried to preserve the previous behaviour.

Yes.  It is some pretty strange code.  Especially where we are reading
a return result which is always false.  I think there is a bug somewhere
between that code and ptrace detach but I don't know that I could tell
you what it is.

Hopefully I have a follow-on patch in another couple of hours.

Eric


> Oleg.
>
> --- x/kernel/exit.c
> +++ x/kernel/exit.c
> @@ -63,6 +63,13 @@ static void exit_mm(struct task_struct *
>  
>  static void __unhash_process(struct task_struct *p, bool group_dead)
>  {
> +	struct task_struct *parent = p->parent;
> +	bool parent_is_init = false;
> +
> +#ifdef CONFIG_PID_NS
> +	parent_is_init = (task_active_pid_ns(p)->child_reaper == parent);
> +#endif
> +
>  	nr_threads--;
>  	detach_pid(p, PIDTYPE_PID);
>  	if (group_dead) {
> @@ -72,6 +79,11 @@ static void __unhash_process(struct task
>  		list_del_rcu(&p->tasks);
>  		list_del_init(&p->sibling);
>  		__this_cpu_dec(process_counts);
> +
> +		if (parent_is_init && (parent->flags & PF_EXITING)) {
> +			if (list_empty(&parent->children))
> +				__wake_up_parent(p, parent);
> +		}
>  	}
>  	list_del_rcu(&p->thread_group); 
>  }
> --- x/kernel/pid_namespace.c
> +++ x/kernel/pid_namespace.c
> @@ -184,6 +184,9 @@ void zap_pid_ns_processes(struct pid_nam
>  		rc = sys_wait4(-1, NULL, __WALL, NULL);
>  	} while (rc != -ECHILD);
>  
> +	wait_event(&current->signal->wait_chldexit,
> +			list_empty(&current->children));
> +
>  	if (pid_ns->reboot)
>  		current->signal->group_exit_code = pid_ns->reboot;
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
