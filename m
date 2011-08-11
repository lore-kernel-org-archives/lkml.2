Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1HKVat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:30:49 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:45834 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1HKVas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:30:48 -0400
Message-ID: <4E444A04.3070403@free.fr>
Date: Thu, 11 Aug 2011 23:30:44 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        bonbons@linux-vserver.org, oleg@tv-sign.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Notify container-init parent a 'reboot' occured
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <1313094241-3674-3-git-send-email-daniel.lezcano@free.fr> <20110811210951.GA17349@peqn>
In-Reply-To: <20110811210951.GA17349@peqn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 11:09 PM, Serge Hallyn wrote:
> Quoting Daniel Lezcano (daniel.lezcano@free.fr):
>> When the reboot syscall is called and the pid namespace where the calling
>> process belongs to is not from the init pidns, we send a SIGCHLD with CLD_REBOOTED
>> to the parent of this pid namespace.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
> ...
>
>> +void do_notify_parent_cldreboot(struct task_struct *tsk, int why, char *buffer)
>> +{
>> +	struct siginfo info = { };
>> +	struct task_struct *parent;
>> +	struct sighand_struct *sighand;
>> +	unsigned long flags;
>> +
>> +	if (tsk->ptrace)
>> +		parent = tsk->parent;
>> +	else {
>> +		tsk = tsk->group_leader;
>> +		parent = tsk->real_parent;
>> +	}
>> +
>> +	info.si_signo = SIGCHLD;
>> +	info.si_errno = 0;
>> +	info.si_status = why;
>> +
>> +	rcu_read_lock();
>> +	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
>> +	info.si_uid = __task_cred(tsk)->uid;
> 	
> 	This eventually should become:
>
> 	info.si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
> 	                              current_cred(), current_uid());
>
> 	I've got a first-stab patch at converting the rest of
> 	kernel/signal.c in http://kernel.ubuntu.com/git?p=serge/userns-2.6.git

Ok, thanks.

>> +	rcu_read_unlock();
>> +
>> +	info.si_utime = cputime_to_clock_t(tsk->utime);
>> +	info.si_stime = cputime_to_clock_t(tsk->stime);
>> +
>> +	info.si_code = CLD_REBOOTED;
>> +
>> +	sighand = parent->sighand;
>> +	spin_lock_irqsave(&sighand->siglock, flags);
>> +	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
>> +	    sighand->action[SIGCHLD-1].sa.sa_flags & SA_CLDREBOOT)
>> +		__group_send_sig_info(SIGCHLD, &info, parent);
>> +	/*
>> +	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.
>> +	 */
>> +	__wake_up_parent(tsk, parent);
>> +	spin_unlock_irqrestore(&sighand->siglock, flags);
>> +}
> ...
>
>> @@ -426,10 +434,18 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>>  {
>>  	char buffer[256];
>>  	int ret = 0;
>> +	struct pid_namespace *pid_ns = current->nsproxy->pid_ns;
>> +
>> +        /* We only trust the superuser with rebooting the system. */
>> +	if (!capable(CAP_SYS_BOOT)) {
> Doesn't this mean that an unprivileged task in a container can shut
> down the container?

Ha ha ! Right, good catch :)

Yes, rethinking about it, we can do what initially proposed Bruno by
just preventing to reboot when we are not in the init_pid_ns. Actually, 
the sys_reboot occurs after the services shutdown and "kill -1 SIGTERM"
and "kill -1 SIGKILL", and would not make sense to do that in a child
pid namespace, except if we are in a container where we don't want to
reboot :)

So IMO, it is safe to do:

	if (!ns_capable(current_pid_ns()->user_ns, CAP_SYS_BOOT))
 		return -EPERM;
	
	if (pid_ns != &init_pid_ns)
		return pid_namespace_reboot(pid_ns, cmd, buffer);


> The pidns->user_ns patch I sent earlier today gives you what you need
> so that you can add
>
> 		if (!ns_capable(current_pid_ns()->user_ns, CAP_SYS_BOOT)
> 			return -EPERM;
>
> right here to prevent that.
>
>> +		/* If we are not in the initial pid namespace, we send a signal
>> +		 * to the parent of this init pid namespace, notifying a shutdown
>> +		 * occured */
>> +		if (pid_ns != &init_pid_ns)
>> +			pid_namespace_reboot(pid_ns, cmd, buffer);
>>  
>> -	/* We only trust the superuser with rebooting the system. */
>> -	if (!capable(CAP_SYS_BOOT))
>>  		return -EPERM;
>> +	}
>>  
>>  	/* For safety, we require "magic" arguments. */
>>  	if (magic1 != LINUX_REBOOT_MAGIC1 ||
>> -- 
>> 1.7.4.1
>>
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/containers

