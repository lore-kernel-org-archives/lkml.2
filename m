Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2HUDiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 23:38:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35241 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2HUDiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 23:38:11 -0400
Message-ID: <5033029A.2030201@linaro.org>
Date: Mon, 20 Aug 2012 20:38:02 -0700
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
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org> <1342156917-25092-5-git-send-email-john.stultz@linaro.org> <m2fw7ilhnm.fsf@igel.home> <503288ED.10306@linaro.org> <m2fw7h4ab5.fsf@igel.home> <503296C1.4070906@linaro.org> <m2boi549ed.fsf@igel.home>
In-Reply-To: <m2boi549ed.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082103-2356-0000-0000-00000173D4E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 01:04 PM, Andreas Schwab wrote:
> John Stultz <john.stultz@linaro.org> writes:
>
>> Huh.  Yea, that looks fine.  And without the
>> __timekeeping_inject_sleeptime() call, the system resumed ok?
> Yes, it does.

So I'm mostly still stumped on this. But I did find one possible related 
bugfix that maybe you can try?

Let me know if the patch below dodges the problem, and if not, please 
send me the JDB printk output.
(if the resume hangs without any output, add a "return;" before the 
tk_xtime_add() call between the JDB printks).

thanks
-john



diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e16af19..1a9b9c5 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -115,6 +115,7 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
  {
  	tk->xtime_sec += ts->tv_sec;
  	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
+	tk_normalize_xtime(tk);
  }
  
  static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
@@ -695,9 +696,22 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
  					"sleep delta value!\n");
  		return;
  	}
+
+	printk("JDB: pre xt %ld:%ld  wtm: %ld:%ld st: %ld:%ld\n",
+		tk_xtime(tk).tv_sec, tk_xtime(tk).tv_nsec,
+		tk->wall_to_monotonic.tv_sec,tk->wall_to_monotonic.tv_nsec,
+		tk->total_sleep_time.tv_sec, tk->total_sleep_time.tv_nsec);
+	printk("JDB: Adding %ld:%ld\n", delta->tv_sec, delta->tv_nsec);
+
  	tk_xtime_add(tk, delta);
  	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *delta));
  	tk_set_sleep_time(tk, timespec_add(tk->total_sleep_time, *delta));
+
+	printk("JDB: post xt %ld:%ld  wtm: %ld:%ld st: %ld:%ld\n",
+		tk_xtime(tk).tv_sec, tk_xtime(tk).tv_nsec,
+		tk->wall_to_monotonic.tv_sec,tk->wall_to_monotonic.tv_nsec,
+		tk->total_sleep_time.tv_sec, tk->total_sleep_time.tv_nsec);
+
  }
  
  /**

