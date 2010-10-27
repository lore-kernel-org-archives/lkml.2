Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0J0IHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:07:10 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:57155 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752642Ab0J0IHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:07:04 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h)
X-WSS-ID: 0LAXVVG-01-2DE-02
X-M-MSG: 
Date: Wed, 27 Oct 2010 10:06:51 +0200
From: Robert Richter <robert.richter@amd.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sricharan <r.sricharan@ti.com>
Subject: Re: [PATCH] oprofile: Fix the hang while offline the cpu
Message-ID: <20101027080651.GV5969@erda.amd.com>
References: <1287835926-1957-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287835926-1957-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.10.10 08:12:06, Santosh Shilimkar wrote:
> The kernel build with CONFIG_OPROFILE and CPU_HOTPLUG enabled.
> The oprofile is initialised using system timer in absence of hardware
> counters supports. Oprofile isn't started from userland.
> 
> In this setup while doing a CPU offline the kernel hangs in infinite
> for loop inside lock_hrtimer_base() function
> 
> This happens because as part of oprofile_cpu_notify(, it tries to
> stop an hrtimer which was never started. These per-cpu hrtimers
> are started when the oprfile is started.
> 	echo 1	> /dev/oprofile/enable

Indeed, this is true.

There is also the case vice versa, the cpu is booted with maxcpus
parameter set. When bringing the remaining cpus online the timers are
started even if oprofile is not yet enabled.

> 
> This patch fix this issue by adding a state variable so that
> these hrtimer start/stop is only attempted when oprofile is
> started
> 
> Reported-by: Jan Sebastien <s-jan@ti.com>
> Signed-off-by: sricharan <r.sricharan@ti.com>
> Tested-by: sricharan <r.sricharan@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Cc: Robert Richter <robert.richter@amd.com>
> ---
>  drivers/oprofile/timer_int.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
> index dc0ae4d..de487ba 100644
> --- a/drivers/oprofile/timer_int.c
> +++ b/drivers/oprofile/timer_int.c
> @@ -21,6 +21,7 @@
>  #include "oprof.h"
>  
>  static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
> +static int oprofile_hrtimer_started;

Maybe we rename this in ctr_running. This is similar to the arch/x86
implementation. We don't need the oprofile_ prefix as this is static.
'started' is a bit irritating as we start the timer if the timer is
started.

>  
>  static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
>  {
> @@ -33,6 +34,9 @@ static void __oprofile_hrtimer_start(void *unused)
>  {
>  	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
>  
> +	if (!oprofile_hrtimer_started)
> +		return;
> +
>  	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	hrtimer->function = oprofile_hrtimer_notify;
>  
> @@ -42,6 +46,7 @@ static void __oprofile_hrtimer_start(void *unused)
>  
>  static int oprofile_hrtimer_start(void)
>  {
> +	oprofile_hrtimer_started = 1;
>  	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);

We must protect on_each_cpu() and the variable assignment with
get/put_online_cpus(). See also implementation in
arch/x86/oprofile/nmi_int.c.

>  	return 0;
>  }
> @@ -50,6 +55,9 @@ static void __oprofile_hrtimer_stop(int cpu)
>  {
>  	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
>  
> +	if (!oprofile_hrtimer_started)
> +		return;
> +
>  	hrtimer_cancel(hrtimer);
>  }
>  
> @@ -59,6 +67,7 @@ static void oprofile_hrtimer_stop(void)
>  
>  	for_each_online_cpu(cpu)
>  		__oprofile_hrtimer_stop(cpu);
> +	oprofile_hrtimer_started = 0;

Same here, protect this with get/put_online_cpus().

-Robert

>  }
>  
>  static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
> -- 
> 1.6.0.4
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

