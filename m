Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab1D2X2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:28:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40985 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab1D2X2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <tip-304529b1b6f8612ccbb4582e997051b48b94f4a4@git.kernel.org>
References: <tip-304529b1b6f8612ccbb4582e997051b48b94f4a4@git.kernel.org>
Date: Fri, 29 Apr 2011 16:28:19 -0700
Message-ID: <BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
Subject: Re: [tip:timers/core] time: Add timekeeping_inject_sleeptime
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        john.stultz@linaro.org, arve@android.com, arnd@arndb.de,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:31 AM, tip-bot for John Stultz
<john.stultz@linaro.org> wrote:
...
>
> time: Add timekeeping_inject_sleeptime
>
> Some platforms cannot implement read_persistent_clock, as
> their RTC devices are only accessible when interrupts are enabled.
> This keeps them from being used by the timekeeping code on resume
> to measure the time in suspend.
>
> The RTC layer tries to work around this, by calling do_settimeofday
> on resume after irqs are reenabled to set the time properly. However,
> this only corrects CLOCK_REALTIME, and does not properly adjust
> the sleep time value. This causes btime in /proc/stat to be incorrect
> as well as making the new CLOCK_BOTTTIME inaccurate.
>
> This patch resolves the issue by introducing a new timekeeping hook
> to allow the RTC layer to inject the sleep time on resume.
>
> The code also checks to make sure that read_persistent_clock is
> nonfunctional before setting the sleep time, so that should the RTC's
> HCTOSYS option be configured in on a system that does support
> read_persistent_clock we will not increase the total_sleep_time twice.
>
> CC: Arve Hjønnevåg <arve@android.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/rtc/class.c       |   23 +++++++-----------
>  include/linux/time.h      |    1 +
>  kernel/time/timekeeping.c |   56 ++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 63 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 3901386..4194e59 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -41,26 +41,21 @@ static void rtc_device_release(struct device *dev)
>  * system's wall clock; restore it on resume().
>  */
>
> -static struct timespec delta;
>  static time_t          oldtime;
> +static struct timespec oldts;
>
>  static int rtc_suspend(struct device *dev, pm_message_t mesg)
>  {
>        struct rtc_device       *rtc = to_rtc_device(dev);
>        struct rtc_time         tm;
> -       struct timespec         ts = current_kernel_time();
>
>        if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
>                return 0;
>
>        rtc_read_time(rtc, &tm);
> +       ktime_get_ts(&oldts);
>        rtc_tm_to_time(&tm, &oldtime);
>
> -       /* RTC precision is 1 second; adjust delta for avg 1/2 sec err */
> -       set_normalized_timespec(&delta,
> -                               ts.tv_sec - oldtime,
> -                               ts.tv_nsec - (NSEC_PER_SEC >> 1));
> -
>        return 0;
>  }
>
> @@ -70,10 +65,12 @@ static int rtc_resume(struct device *dev)
>        struct rtc_time         tm;
>        time_t                  newtime;
>        struct timespec         time;
> +       struct timespec         newts;
>
>        if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
>                return 0;
>
> +       ktime_get_ts(&newts);
>        rtc_read_time(rtc, &tm);
>        if (rtc_valid_tm(&tm) != 0) {
>                pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
> @@ -85,15 +82,13 @@ static int rtc_resume(struct device *dev)
>                        pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
>                return 0;
>        }
> +       /* calculate the RTC time delta */
> +       set_normalized_timespec(&time, newtime - oldtime, 0);
>
> -       /* restore wall clock using delta against this RTC;
> -        * adjust again for avg 1/2 second RTC sampling error
> -        */
> -       set_normalized_timespec(&time,
> -                               newtime + delta.tv_sec,
> -                               (NSEC_PER_SEC >> 1) + delta.tv_nsec);
> -       do_settimeofday(&time);
> +       /* subtract kernel time between rtc_suspend to rtc_resume */
> +       time = timespec_sub(time, timespec_sub(newts, oldts));

The delta you got from the rtc can be almost a second to long or
short. Do you do anything to prevent these errors from accumulating?

>
> +       timekeeping_inject_sleeptime(&time);
>        return 0;
>  }
>
...

-- 
Arve Hjønnevåg
