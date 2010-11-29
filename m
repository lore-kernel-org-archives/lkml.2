Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0K2Ns7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:48:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:57885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab0K2Ns6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:48:58 -0500
Message-ID: <4CF3AF35.4050108@kernel.org>
Date: Mon, 29 Nov 2010 14:48:37 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "@sisk.plpavel@ucw.cz"@htj.dyndns.org,
        "Jan Kratochvil \"" <jan.kratochvil@redhat.com>
Subject: Re: [PATCH 09/14] ptrace: clean transitions between TASK_STOPPED
 and TRACED
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-10-git-send-email-tj@kernel.org> <20101128202535.GC12896@redhat.com>
In-Reply-To: <20101128202535.GC12896@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Nov 2010 13:48:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On 11/28/2010 09:25 PM, Oleg Nesterov wrote:
> This adds another user-visible change, this time it is more serious.
> Again, I do not claim it breaks ptrace, just I do not know.
> 
>> @@ -204,6 +202,19 @@ int ptrace_attach(struct task_struct *task)
>>  	__ptrace_link(task, current);
>>  	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
>>
>> +	/*
>> +	 * If the task is already STOPPED, set GROUP_STOP_PENDING and
>> +	 * kick it so that it transits to TRACED.  This is safe as
>> +	 * both transitions in and out of STOPPED are protected by
>> +	 * siglock.
>> +	 */
>> +	spin_lock(&task->sighand->siglock);
>> +	if (task_is_stopped(task)) {
>> +		task->group_stop |= GROUP_STOP_PENDING;
>> +		signal_wake_up(task, 1);
> 
> OK. Now we have a window if the tracer attaches to the stopped task.
> 
> Say,
> 
> 	child = fork()
> 
> 	if (!child)
> 		return child_do_something();
> 
> 	kill(child, SIGSTOP);
> 	wait();			// <--- ensures it is stopped
> 
> 	ptrace(PTRACE_ATTACH, child);
> 
> 	assert(ptrace(PTRACE_WHATEVER, child) == 0);
> 
> Currently this code is correct. With this patch the assertion above
> can fail, the child may be running, changing its state from STOPPED
> to TRACED.

Hmmm... rather convoluted, but yeap.  I can update the code to wait
for stopped -> traced transition to complete, so that the transition
is hidden from userland.  How does that sound to you?

>> @@ -1812,7 +1817,13 @@ static int do_signal_stop(int signr)
>>
>>  		spin_lock_irq(&current->sighand->siglock);
>>  	} else
>> -		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
>> +		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
>> +			    CLD_STOPPED, 0, NULL);
>> +
>> +	if (current->group_stop & GROUP_STOP_PENDING) {
>> +		WARN_ON_ONCE(!(current->group_stop & GROUP_STOP_SIGMASK));
>> +		goto retry;
> 
> This doesn't look right even without ptrace.
> 
> Suppose we have to threads, T1 and T2, both stopped, SIGNAL_STOP_STOPPED
> is set.
> 
> SIGCONT wakes them up.
> 
> To simplify the discussion, suppose that T1 takes a long preemption
> when it returns from schedule(), right before it takes ->siglock again.
> 
> T2 sends CLD_CONTINUED to parent and dequeues another SIGSTOP. It
> initiates another group stop, sees T1 as running,  and stops with
> ->group_stop_count == 1. Now we are waiting for T1 which should
> participate.
> 
> Finally T1 resumes and sees GROUP_STOP_PENDING. It goes to 'retry:'
> and stops, but nobody notifies the parent ang ->group_stop_count is
> still non-zero.

Good point.  I'll think about how the problem can be solved.  Maybe
the retry and pending states need to be separated.

Thanks.

-- 
tejun
