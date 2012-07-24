Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2GXGnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:43:50 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59312 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2GXGnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:43:49 -0400
MIME-Version: 1.0
In-Reply-To: <1342567672-29071-1-git-send-email-ccross@android.com>
References: <1342567672-29071-1-git-send-email-ccross@android.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 24 Jul 2012 14:43:28 +0800
Message-ID: <CAGsJ_4z_tF3LKy-vygr=kwah7q7U03Y2K2XKAkZTB1QC2pSYmw@mail.gmail.com>
Subject: Re: [RFC] ARM: sched_clock: update epoch_cyc on resume
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/18 Colin Cross <ccross@android.com>:
> Many clocks that are used to provide sched_clock will reset during
> suspend.  If read_sched_clock returns 0 after suspend, sched_clock will
> appear to jump forward.  This patch resets cd.epoch_cyc to the current
> value of read_sched_clock during resume, which causes sched_clock() just
> after suspend to return the same value as sched_clock() just before
> suspend.
>
> In addition, during the window where epoch_ns has been updated before
> suspend, but epoch_cyc has not been updated after suspend, it is unknown
> whether the clock has reset or not, and sched_clock() could return a
> bogus value.  Add a suspended flag, and return the pre-suspend epoch_ns
> value during this period.

Acked-by: Barry Song <21cnbao@gmail.com>

this patch should also fix the issue that:
1. launch some rt threads, rt threads sleep before suspend
2. repeat to suspend/resume
3. after resuming, waking up rt threads

repeat 1-3 again and again, sometimes all rt threads will hang after
resuming due to wrong sched_clock will make sched_rt think rt_time is
much more than rt_runtime (default 950ms in 1s). then rt threads will
lost cpu timeslot to run since the 95% threshold is there.

>
> This will have a side effect of causing SoCs that have clocks that
> continue to count in suspend to appear to stop counting, reporting the
> same sched_clock() value before and after suspend.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/kernel/sched_clock.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
> index 27d186a..46c7d32 100644
> --- a/arch/arm/kernel/sched_clock.c
> +++ b/arch/arm/kernel/sched_clock.c
> @@ -21,6 +21,7 @@ struct clock_data {
>         u32 epoch_cyc_copy;
>         u32 mult;
>         u32 shift;
> +       bool suspended;
>  };
>
>  static void sched_clock_poll(unsigned long wrap_ticks);
> @@ -49,6 +50,9 @@ static unsigned long long cyc_to_sched_clock(u32 cyc, u32 mask)
>         u64 epoch_ns;
>         u32 epoch_cyc;
>
> +       if (cd.suspended)
> +               return cd.epoch_ns;
> +
>         /*
>          * Load the epoch_cyc and epoch_ns atomically.  We do this by
>          * ensuring that we always write epoch_cyc, epoch_ns and
> @@ -169,11 +173,20 @@ void __init sched_clock_postinit(void)
>  static int sched_clock_suspend(void)
>  {
>         sched_clock_poll(sched_clock_timer.data);
> +       cd.suspended = true;
>         return 0;
>  }
>
> +static void sched_clock_resume(void)
> +{
> +       cd.epoch_cyc = read_sched_clock();
> +       cd.epoch_cyc_copy = cd.epoch_cyc;
> +       cd.suspended = false;
> +}
> +
>  static struct syscore_ops sched_clock_ops = {
>         .suspend = sched_clock_suspend,
> +       .resume = sched_clock_resume,
>  };
>
>  static int __init sched_clock_syscore_init(void)


-barry
