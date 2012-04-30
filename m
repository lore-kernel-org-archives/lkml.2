Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2D3Czr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 22:55:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59917 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2D3Cz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 22:55:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
Date: Sun, 29 Apr 2012 19:59:36 -0700
In-Reply-To: <20120429165846.GA19054@redhat.com> (Oleg Nesterov's message of
	"Sun, 29 Apr 2012 18:58:46 +0200")
Message-ID: <m11un5zzzb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX198ommAZVCgRwszDsOPbW5dLuOtWP3vW0M=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/29, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>
>> > But this particular one looks simple iirc.
>> >
>> >> @@ -216,6 +216,14 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
>> >>  	rcu_assign_pointer(p->nsproxy, new);
>> >>
>> >>  	if (ns && atomic_dec_and_test(&ns->count)) {
>> >> +		/* Handle fork() failure, unmount proc before proceeding */
>> >> +		if (unlikely(!new && !((p->flags & PF_EXITING)))) {
>> >> +			struct pid_namespace *pid_ns = ns->pid_ns;
>> >> +
>> >> +			if (pid_ns && pid_ns != &init_pid_ns)
>> >> +				pid_ns_release_proc(pid_ns);
>> >> +		}
>> >> +
>> >>  		/*
>> >>  		 * wait for others to get what they want from this nsproxy.
>> >>  		 *
>> >
>> > At first glance this looks correct. But the PF_EXITING check doesn't
>> > look very nice imho. It is needed to detect the case when the caller
>> > is copy_process()->bad_fork_cleanup_namespaces and p is not current.
>>
>> Mike's proposed change to switch_task_namespace is most definitely not
>> correct.  This will potentially get called on unshare
>
> Yes, but please note that this change also checks "new == NULL", so I
> still think the patch is correct.

Sort of.  It is correct in the sense that it performs magic checks on
it's arguments to see that it's caller is exit_task_namespaces called
from the fork failure path.

It is incorrect in the case that it doesn't handle weird cases like
daemonize() which also call switch_namespaces.  So it is no better and
much more confusing and much less maintainable than your two line patch
below.

> But,
>
>> > 	 bad_fork_cleanup_namespaces:
>> > 	+	if (unlikely(clone_flags & CLONE_NEWPID))
>> > 	+		pid_ns_release_proc(...);
>> > 		exit_task_namespaces(p);
>> > 		
>> > 		
>> > code into this error path in copy_process?
>>
>> For now Oleg your minimal patch looks good.
>
> Good.
>
> Mike, could you please re-send the patch to akpm? Feel free to add my ack.
> I guess Eric will ack this fix too.

I will.

>> There are crazy code paths like daemonize()
>
> Forget. It has no callers anymore, should be killed. A user-space process
> should never use kernel_thread() and thus daemonize() is not needed.

Good point.  Oleg do you think you can send in the patches to kill
daemonize.  I make it a lot easier to sleep at night and review patches
if I did not have to think about that scary code path.

Eric



