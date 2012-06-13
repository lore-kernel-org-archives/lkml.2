Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2FMWRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:17:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51443 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2FMWRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:17:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
References: <20120530175745.GA19327@redhat.com>
	<20120530181429.GA19989@redhat.com>
	<20120530181500.GA20130@redhat.com>
	<20120613145248.f5caab7e.akpm@linux-foundation.org>
Date: Wed, 13 Jun 2012 15:17:34 -0700
In-Reply-To: <20120613145248.f5caab7e.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 13 Jun 2012 14:52:48 -0700")
Message-ID: <87bokmoo01.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX186nFTqnPfV2kxqqzDzRcIiRXkUS6LB9jE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0214]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] pidns: guarantee that the pidns init will be the last pidns process reaped
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> --- a/kernel/exit.c
>> +++ b/kernel/exit.c
>> @@ -64,7 +64,6 @@ static void exit_mm(struct task_struct * tsk);
>>  static void __unhash_process(struct task_struct *p, bool group_dead)
>>  {
>>  	nr_threads--;
>> -	detach_pid(p, PIDTYPE_PID);
>>  	if (group_dead) {
>>  		detach_pid(p, PIDTYPE_PGID);
>>  		detach_pid(p, PIDTYPE_SID);
>> @@ -72,7 +71,20 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>>  		list_del_rcu(&p->tasks);
>>  		list_del_init(&p->sibling);
>>  		__this_cpu_dec(process_counts);
>> +		/*
>> +		 * If we are the last child process in a pid namespace to be
>> +		 * reaped, notify the reaper sleeping zap_pid_ns_processes().
>> +		 */
>> +		if (IS_ENABLED(CONFIG_PID_NS)) {
>> +			struct task_struct *parent = p->real_parent;
>> +
>> +			if ((task_active_pid_ns(p)->child_reaper == parent) &&
>> +			    list_empty(&parent->children) &&
>> +			    (parent->flags & PF_EXITING))
>> +				wake_up_process(parent);
>> +		}
>>  	}
>> +	detach_pid(p, PIDTYPE_PID);
>>  	list_del_rcu(&p->thread_group);
>>  }
>>  
>> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
>> index 57bc1fd..41ed867 100644
>> --- a/kernel/pid_namespace.c
>> +++ b/kernel/pid_namespace.c
>> @@ -179,11 +179,31 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>>  	}
>>  	read_unlock(&tasklist_lock);
>>  
>> +	/* Firstly reap the EXIT_ZOMBIE children we may have. */
>>  	do {
>>  		clear_thread_flag(TIF_SIGPENDING);
>>  		rc = sys_wait4(-1, NULL, __WALL, NULL);
>>  	} while (rc != -ECHILD);
>>  
>> +	/*
>> +	 * sys_wait4() above can't reap the TASK_DEAD children.
>> +	 * Make sure they all go away, see __unhash_process().
>> +	 */
>> +	for (;;) {
>> +		bool need_wait = false;
>> +
>> +		read_lock(&tasklist_lock);
>> +		if (!list_empty(&current->children)) {
>> +			__set_current_state(TASK_UNINTERRUPTIBLE);
>> +			need_wait = true;
>> +		}
>> +		read_unlock(&tasklist_lock);
>> +
>> +		if (!need_wait)
>> +			break;
>> +		schedule();
>
> This sleep is terminated by the above wake_up_process(), yes?

Yes.

> But that wake_up_process() only happens if CONFIG_PID_NS.  It's
> unobvious (to me) that we can't get stuck in D state if
> CONFIG_PID_NS=n.  If bug, please fix.  If not bug, please make obvious
> to me ;)

The file pid_namespace.c that holds zap_pid_ns_processes is only
compiled with CONFIG_PID_NS set.  So we can't possibly get stuck with
CONFIG_PID_NS=n.

> <looks at the locking a bit>
>
> <gets distracted>
>
> That tty_kref_put() in __exit_signal() is running with tasklist_lock
> held, yes?  It does a ton of work and calls out to random drivers and
> none of this needs tasklist_lock.  Seems risky.

Interesting.  That tty_kref_put does sound like an area where the
locking can be simplified.  At the same time tty_kref_put does make
sense from exit signal.  As ttys and signals are intimately intertwined.

Thank you for taking the time looking at this and applying this change.

I have to agree that the tasklist_lock is pretty horrible, and that if
we can somehow figure out how to remove it we would be in a much better
situation with lock contention.  Unfortunately that is an alligator and
I am working to drain the swamp.

Eric

