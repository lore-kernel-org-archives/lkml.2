Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0KZQEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:04:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:40510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0KZQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:04:10 -0500
Message-ID: <4CEFDA69.7040303@kernel.org>
Date: Fri, 26 Nov 2010 17:03:53 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/14] signal: fix premature completion of group stop
 when interfered by ptrace
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-6-git-send-email-tj@kernel.org> <20101126154009.GC28177@redhat.com>
In-Reply-To: <20101126154009.GC28177@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 16:03:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On 11/26/2010 04:40 PM, Oleg Nesterov wrote:
>> task->signal->group_stop_count is used to tracke the progress of group
>> stop.  It's initialized to the number of tasks which need to stop for
>> group stop to finish and each stopping or trapping task decrements.
>> However, each task doesn't keep track of whether it decremented the
>> counter or not and if woken up before the group stop is complete and
>> stops again, it can decrement the counter multiple times.
> 
> Everything is fine without ptrace, I hope.

AFAICS, w/o ptrace it should function correctly.

> (ignoring the deprecated CLONE_STOPPED)
> 
>> Please consider the following example code.
> 
> I didn't even read the test-case ;)
> 
> Yes, known problems. ptrace is very wrong when it comes to
> group_stop_count/SIGNAL_STOP_STOPPED/etc. Almost everything
> is wrong.
> 
> Cough, this is fixed in utrace ;) It doesn't use ptrace_stop/
> ptrace_resume/etc at all.

Yeah, I read about utrace in your previous posts but git grepping it
gave me nothing.  Ah, okay, it's out of tree patchset.  Are you
planning on merging it?  Why not just fix up and extend ptrace?  Is
there some fundamental problem?

I was thinking about adding PTRACE_SEIZE operation after this patchset
which allows nesting and transparent operation (without the nasty
implied SIGSTOP).  As long as I can get that, I don't really mind
whether it's p or utrace, but still am curious why we need something
completely new.

>> This patch adds a new field task->group_stop which is protected by
>> siglock and uses GROUP_STOP_CONSUME flag to track which task is still
>> to consume group_stop_count to fix this bug.
> 
> Yes, currently the tracee never knows how it should react to
> ->group_stop_count.
> 
>> @@ -1645,7 +1658,7 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
>>  	 * we must participate in the bookkeeping.
>>  	 */
>>  	if (current->signal->group_stop_count > 0)
>> -		--current->signal->group_stop_count;
>> +		consume_group_stop();
> 
> This doesn't look exactly right. If we participate (decrement the
> counter), we should stop even if we race with ptrace_detach().
> 
> And what if consume_group_stop() returns true? We should set
> SIGNAL_STOP_STOPPED and notify ->parent.

Yeah, exactly, both issues are dealt with later.  I'm just fixing
things one by one.

> Otherwise looks correct at first glance...
> 
> Of course, there are more problems. To me, even
> ptrace_resume()->wake_up_process() is very wrt jctl.

Yeah, that one too.  :-)

> Cosmetic nit,
> 
>> +static bool consume_group_stop(void)
>> +{
>> +	if (!(current->group_stop & GROUP_STOP_CONSUME))
>> +		return false;
>> +
>> +	current->group_stop &= ~GROUP_STOP_CONSUME;
>> +
>> +	if (!WARN_ON_ONCE(current->signal->group_stop_count == 0))
>> +		current->signal->group_stop_count--;
> 
> Every caller should check ->group_stop_count != 0. do_signal_stop()
> does this too in fact. May be it would be cleaner to move this
> check into consume_group_stop() and remove WARN_ON_ONCE().
> 
> This way it is more clear why prepare_signal(SIGCONT) do not
> reset task->group_stop, it has no effect unless ->group_stop_count
> is set by do_signal_stop() which updates ->group_stop for every
> thread.
> 
> Probably consume_group_stop() should also set SIGNAL_STOP_STOPPED
> if it returns true.
> 
> But, I didn't read the next patches yet...

Yeap, it changes later.

Thanks a lot for reviewing.

-- 
tejun
