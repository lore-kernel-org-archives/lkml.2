Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab2CIAHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:07:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2CIAHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:07:33 -0500
Date: Thu, 8 Mar 2012 16:07:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Phil Carmody'" <ext-phil.2.carmody@nokia.com>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@suse.de>,
        "'Sameer Nanda'" <snanda@chromium.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] init: check printed flag to skip printing message
Message-Id: <20120308160731.90cc9985.akpm@linux-foundation.org>
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE4665237994F30F4@HQMAIL04.nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
	<1328024684.2446.234.camel@twins>
	<1DD7BFEDD3147247B1355BEFEFE466523791832BE9@HQMAIL04.nvidia.com>
	<1328040137.2446.242.camel@twins>
	<1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
	<1DD7BFEDD3147247B1355BEFEFE4665237994F30F4@HQMAIL04.nvidia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 15:44:16 -0800
Diwakar Tundlam <dtundlam@nvidia.com> wrote:

> Otherwise the 'Calibration skipped' message gets printed everytime a CPU is
> hotplugged in, cluttering console for systems that frequently hotplug CPUs.
> 
> Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
> ---
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/init/calibrate.c b/init/calibrate.c
> index 5f117ca..fda0a7b 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -267,7 +267,8 @@ void __cpuinit calibrate_delay(void)
>  
> 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
> 		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
> -		pr_info("Calibrating delay loop (skipped) "
> +		if (!printed)
> +			pr_info("Calibrating delay loop (skipped) "
>  			"already calibrated this CPU");
> 	} else if (preset_lpj) {
> 		lpj = preset_lpj;

oops, yes.



Looking at that code, I think Mike broke it in 2009 with feae3203d71
("timers, init: Limit the number of per cpu calibration bootup
messages"):


: diff --git a/init/calibrate.c b/init/calibrate.c
: index a379c90..6eb48e5 100644
: --- a/init/calibrate.c
: +++ b/init/calibrate.c
: @@ -123,23 +123,26 @@ void __cpuinit calibrate_delay(void)
:  {
:  	unsigned long ticks, loopbit;
:  	int lps_precision = LPS_PREC;
: +	static bool printed;
:  
:  	if (preset_lpj) {
:  		loops_per_jiffy = preset_lpj;
: -		printk(KERN_INFO
: -			"Calibrating delay loop (skipped) preset value.. ");
: -	} else if ((smp_processor_id() == 0) && lpj_fine) {
: +		if (!printed)
: +			pr_info("Calibrating delay loop (skipped) "
: +				"preset value.. ");
: +	} else if ((!printed) && lpj_fine) {
:  		loops_per_jiffy = lpj_fine;

What's going on here?  Why should the value of `printed' affect the
value of loops_per_jiffy?

(lpj_fine is set only in x86 tsc code, under late_time_init(), and
late_time_init() is called before calibrate_delay(), so we got that
part right).

:  		loops_per_jiffy = lpj_fine;
: -		printk(KERN_INFO
: -			"Calibrating delay loop (skipped), "
: +		pr_info("Calibrating delay loop (skipped), "
:  			"value calculated using timer frequency.. ");
:  	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
: -		printk(KERN_INFO
: -			"Calibrating delay using timer specific routine.. ");
: +		if (!printed)
: +			pr_info("Calibrating delay using timer "
: +				"specific routine.. ");
:  	} else {
:  		loops_per_jiffy = (1<<12);
:  
: -		printk(KERN_INFO "Calibrating delay loop... ");
: +		if (!printed)
: +			pr_info("Calibrating delay loop... ");
:  		while ((loops_per_jiffy <<= 1) != 0) {
:  			/* wait for "start of" clock tick */
:  			ticks = jiffies;
: @@ -170,7 +173,10 @@ void __cpuinit calibrate_delay(void)
:  				loops_per_jiffy &= ~loopbit;
:  		}
:  	}
: -	printk(KERN_CONT "%lu.%02lu BogoMIPS (lpj=%lu)\n",
: +	if (!printed)
: +		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
:  			loops_per_jiffy/(500000/HZ),
:  			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
: +
: +	printed = true;
:  }
: diff --git a/kernel/cpu.c b/kernel/cpu.c
: index 6ba0f1e..7c4e271 100644
: --- a/kernel/cpu.c
: +++ b/kernel/cpu.c
: @@ -392,10 +392,9 @@ int disable_nonboot_cpus(void)
:  		if (cpu == first_cpu)
:  			continue;
:  		error = _cpu_down(cpu, 1);
: -		if (!error) {
: +		if (!error)
:  			cpumask_set_cpu(cpu, frozen_cpus);
: -			printk("CPU%d is down\n", cpu);
: -		} else {
: +		else {
:  			printk(KERN_ERR "Error taking CPU%d down: %d\n",
:  				cpu, error);
:  			break;

