Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0ERUuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:50:52 -0400
Received: from www.tglx.de ([62.245.132.106]:40200 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab0ERUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:50:50 -0400
Date: Tue, 18 May 2010 22:50:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 2/2] v4 x86/mrst: add more timer config options
In-Reply-To: <1274184166-17242-3-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005182240480.3368@localhost.localdomain>
References: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com> <1274184166-17242-3-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Jacob Pan wrote:
> Always-on local APIC timer (ARAT) has been introduced to Medfield, along
> with the platform APB timers we have more timer configuration options
> between Moorestown and Medfield.
>  
> +/**

  Do not use kerneldoc /** opener from plain comments. Randy
  complained about that yesterday already

>  void __init mrst_time_init(void)
>  {
> +	switch (mrst_timer_options) {
> +	case MRST_TIMER_APBT_ONLY:
> +		pr_info("Use APB timer option on Moorestown\n");

  Do we really need all this pr_info spew ? /proc/timer_list will tell
  you if you're interested

> +		break;
> +	case MRST_TIMER_LAPIC_APBT:
> +		pr_info("Use LAPIC and APB timer option on Moorestown\n");
> +		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
> +		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
> +		break;
> +	default:
> +		pr_info("Use default timer option on Moorestown\n");

  And this printk is completely useless. It'd be way more interesting
  to see which timer gets selected as a default. but see above

> +		if (mrst_identify_cpu() == MRST_CPU_CHIP_PENWELL) {

  Why do you want to pin that on PENWELL and not on ARAT ? If you
  check ARAT, you have coverd all next gen cpus as well.

> +			x86_init.timers.setup_percpu_clockev =
> +				setup_boot_APIC_clock;
> +			x86_cpuinit.setup_percpu_clockev =
> +				setup_secondary_APIC_clock;
> +			return;
> +		}

  You can avoid that line splits by doing:

      	    	if (!has(ARAT))
			break:

		x86_init.timers. ...
		...
		return;

  Way easier to read.

Thanks,

	tglx
