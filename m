Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2CXJY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 05:24:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38047 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2CXJY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:24:56 -0400
Date: Sat, 24 Mar 2012 10:24:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        tglx@linutronix.de, jhbird.choi@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] alarmtimer: Make sure we initialize the
 rtctimer
Message-ID: <20120324092452.GA29081@gmail.com>
References: <tip-ad30dfa94c5cc23931c822922a50bd163ab293a5@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-ad30dfa94c5cc23931c822922a50bd163ab293a5@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for John Stultz <john.stultz@linaro.org> wrote:

> Commit-ID:  ad30dfa94c5cc23931c822922a50bd163ab293a5
> Gitweb:     http://git.kernel.org/tip/ad30dfa94c5cc23931c822922a50bd163ab293a5
> Author:     John Stultz <john.stultz@linaro.org>
> AuthorDate: Fri, 23 Mar 2012 15:52:25 -0700
> Committer:  John Stultz <john.stultz@linaro.org>
> CommitDate: Fri, 23 Mar 2012 16:23:12 -0700
> 
> alarmtimer: Make sure we initialize the rtctimer
> 
> jonghwan Choi reported seeing warnings with the alarmtimer
> code at suspend/resume time, and pointed out that the
> rtctimer isn't being properly initialized.
> 
> This patch corrects this issue.
> 
> Reported-by: jonghwan Choi <jhbird.choi@gmail.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/alarmtimer.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index 8a46f5d..c165488 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -46,9 +46,10 @@ static struct alarm_base {
>  static ktime_t freezer_delta;
>  static DEFINE_SPINLOCK(freezer_delta_lock);
>  
> +static struct rtc_timer		rtctimer;
> +
>  #ifdef CONFIG_RTC_CLASS
>  /* rtc timer and device for setting alarm wakeups at suspend */
> -static struct rtc_timer		rtctimer;
>  static struct rtc_device	*rtcdev;
>  static DEFINE_SPINLOCK(rtcdev_lock);
>  
> @@ -783,6 +784,8 @@ static int __init alarmtimer_init(void)
>  		.nsleep		= alarm_timer_nsleep,
>  	};
>  
> +	rtc_timer_init(&rtctimer, NULL, NULL);
> +
>  	posix_timers_register_clock(CLOCK_REALTIME_ALARM, &alarm_clock);
>  	posix_timers_register_clock(CLOCK_BOOTTIME_ALARM, &alarm_clock);

This commit breaks every build that has CONFIG_RTC_LIB disabled:

 alarmtimer.c:(.init.text+0x1cc7): undefined reference to `rtc_timer_init'

Thanks,

	Ingo
