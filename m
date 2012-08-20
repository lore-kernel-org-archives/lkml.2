Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2HTS7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:59:22 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49561 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2HTS7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:59:20 -0400
Message-ID: <503288ED.10306@linaro.org>
Date: Mon, 20 Aug 2012 11:58:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 4/8] time: Condense timekeeper.xtime into xtime_sec
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org> <1342156917-25092-5-git-send-email-john.stultz@linaro.org> <m2fw7ilhnm.fsf@igel.home>
In-Reply-To: <m2fw7ilhnm.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082018-5518-0000-0000-000006FA804B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2012 02:02 PM, Andreas Schwab wrote:
> John Stultz <john.stultz@linaro.org> writes:
>
>> The timekeeper struct has a xtime_nsec, which keeps the
>> sub-nanosecond remainder.  This ends up being somewhat
>> duplicative of the timekeeper.xtime.tv_nsec value, and we
>> have to do extra work to keep them apart, copying the full
>> nsec portion out and back in over and over.
>>
>> This patch simplifies some of the logic by taking the timekeeper
>> xtime value and splitting it into timekeeper.xtime_sec and
>> reuses the timekeeper.xtime_nsec for the sub-second portion
>> (stored in higher res shifted nanoseconds).
>>
>> This simplifies some of the accumulation logic. And will
>> allow for more accurate timekeeping once the vsyscall code
>> is updated to use the shifted nanosecond remainder.
> This (together with b44d50d "time: Fix casting issue in tk_set_xtime and
> tk_xtime_add") is causing resume to hang on the iBook (PowerBook6,7).
> The fact that the add-on commit is needed to uncover the bug might give
> a hint, but I'm unable to decipher it.

Thanks for the bug report and narrowing this down.

I'm not very familiar w/ the iBook hardware, but does it use a 
clocksource, or does it use arch_gettimeoffset()?

I suspect that the casting has avoided clipping some strange values from 
the persistent clock.

Could you try with the following patch against Linus' HEAD? I suspect it 
will let the box resume (although it will seem as though no time was 
spent in resume) and then let me know what the JDB lines print out?

thanks
-john

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e16af19..03f5a82 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -753,10 +753,14 @@ static void timekeeping_resume(void)
  	clocksource_resume();
  
  	write_seqlock_irqsave(&tk->lock, flags);
+	printk("JDB: suspend_time: %ld:%ld  resume_time: %ld:%ld\n",
+		timekeeping_suspend_time.tv_sec, timekeeping_suspend_time.tv_nsec,
+		ts.tv_sec, ts.tv_nsec);
  
  	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
  		ts = timespec_sub(ts, timekeeping_suspend_time);
-		__timekeeping_inject_sleeptime(tk, &ts);
+		printk("JDB: Trying to add: %ld:%ld\n", ts.tv_sec, ts.tv_nsec);
+		//__timekeeping_inject_sleeptime(tk, &ts);
  	}
  	/* re-base the last cycle value */
  	tk->clock->cycle_last = tk->clock->read(tk->clock);

