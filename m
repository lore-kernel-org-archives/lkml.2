Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0I0Jlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:41:49 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:33341
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932420Ab0I0Jls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:41:48 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9EG9C-01-7OZ-02
X-M-MSG: 
Date: Mon, 27 Sep 2010 11:41:36 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 4/7] x86, NMI, Rewrite NMI handler
Message-ID: <20100927094136.GB32222@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285549026-5008-4-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.09.10 20:57:03, Huang Ying wrote:
> The original NMI handler is quite outdated in many aspects. This patch
> try to fix it.
> 
> The order to process the NMI sources are changed as follow:
> 
> notify_die(DIE_NMI_IPI);
> notify_die(DIE_NMI);
> /* process io port 0x61 */
> nmi_watchdog_touch();
> notify_die(DIE_NMIUNKNOWN);
> unknown_nmi();
> 
> DIE_NMI_IPI is used to process CPU specific NMI sources, such as perf
> event, oprofile, crash IPI, etc. While DIE_NMI is used to process
> non-CPU-specific NMI sources, such as APEI (ACPI Platform Error
> Interface) GHES (Generic Hardware Error Source), etc. Non-CPU-specific
> NMI sources can be processed on any CPU,
> 
> DIE_NMI_IPI must be processed before DIE_NMI. For example, perf event
> trigger a NMI on CPU 1, at the same time, APEI GHES trigger another
> NMI on CPU 0. If DIE_NMI is processed before DIE_NMI_IPI, it is
> possible that APEI GHES is processed on CPU 1, while unknown NMI is
> gotten on CPU 0.

I think macro names DIE_NMI_IPI and DIE_NMI should be swapped as
e.g. the perf nmi is actually local and non-IPI.

We might consider to rework the IPI thing completly, but may be in a
follow-on patch.

> 
> In this new order of processing, performance sensitive NMI sources
> such as oprofile or perf event will have better performance because
> the time consuming IO port reading is done after them.
> 
> Only one NMI is eaten for each NMI handler call, even for PCI SERR and
> IOCHK NMIs. Because one NMI should be raised for each of them, eating
> too many NMI will cause unnecessary unknown NMI.
> 
> The die value used in NMI sources are fixed accordingly.
> 
> The NMI handler in the patch is designed by Andi Kleen.
> 
> 
> v2:
> 
> - Split process NMI reason (0x61) on non-BSP into another patch
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c  |    1 
>  arch/x86/kernel/traps.c           |   80 +++++++++++++++++++-------------------
>  arch/x86/oprofile/nmi_int.c       |    1 
>  arch/x86/oprofile/nmi_timer_int.c |    2 
>  drivers/char/ipmi/ipmi_watchdog.c |    2 
>  drivers/watchdog/hpwdt.c          |    2 
>  6 files changed, 43 insertions(+), 45 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1247,7 +1247,6 @@ perf_event_nmi_handler(struct notifier_b
>  		return NOTIFY_DONE;
>  
>  	switch (cmd) {
> -	case DIE_NMI:
>  	case DIE_NMI_IPI:

See my comment above. Same is true for oprofile and some other
handlers below. It isn't an IPI and should be case DIE_NMI: instead.

>  		break;
>  	case DIE_NMIUNKNOWN:
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -354,9 +354,6 @@ io_check_error(unsigned char reason, str
>  static notrace __kprobes void
>  unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  {
> -	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
> -			NOTIFY_STOP)
> -		return;
>  #ifdef CONFIG_MCA
>  	/*
>  	 * Might actually be able to figure out what the guilty party
> @@ -385,51 +382,54 @@ static notrace __kprobes void default_do
>  
>  	cpu = smp_processor_id();

This should go to if (!cpu) and maybe we drop variable cpu completly.

>  
> -	/* Only the BSP gets external NMIs from the system. */
> -	if (!cpu)
> -		reason = get_nmi_reason();
> +	/*
> +	 * CPU-specific NMI must be processed before non-CPU-specific
> +	 * NMI, otherwise we may lose it, because the CPU-specific
> +	 * NMI can not be detected/processed on other CPUs.
> +	 */
>  
> -	if (!(reason & NMI_REASON_MASK)) {
> -		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
> -								== NOTIFY_STOP)
> -			return;
> +	/*
> +	 * CPU-specific NMI: send to specific CPU or NMI sources must
> +	 * be processed on specific CPU
> +	 */
> +	if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, 0, 2, SIGINT)
> +	    == NOTIFY_STOP)
> +		return;
>  
> -#ifdef CONFIG_X86_LOCAL_APIC

Are you sure we may drop this option?

> -		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> -							== NOTIFY_STOP)
> -			return;
> +	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
> +	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
> +		return;

As said, IPI and non-IPI are mixed up.

>  
> -#ifndef CONFIG_LOCKUP_DETECTOR
> -		/*
> -		 * Ok, so this is none of the documented NMI sources,
> -		 * so it must be the NMI watchdog.
> -		 */
> -		if (nmi_watchdog_tick(regs, reason))
> -			return;
> -		if (!do_nmi_callback(regs, cpu))
> -#endif /* !CONFIG_LOCKUP_DETECTOR */
> -			unknown_nmi_error(reason, regs);
> -#else
> -		unknown_nmi_error(reason, regs);
> +	if (!cpu) {
> +		reason = get_nmi_reason();
> +		if (reason & NMI_REASON_MASK) {
> +			if (reason & NMI_REASON_SERR)
> +				pci_serr_error(reason, regs);
> +			else if (reason & NMI_REASON_IOCHK)
> +				io_check_error(reason, regs);
> +#ifdef CONFIG_X86_32
> +			/*
> +			 * Reassert NMI in case it became active
> +			 * meanwhile as it's edge-triggered:
> +			 */
> +			reassert_nmi();
>  #endif
> +			return;
> +		}
> +	}
>  
> +#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
> +	if (nmi_watchdog_tick(regs, reason))
>  		return;
> -	}
> -	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
> +	if (do_nmi_callback(regs, smp_processor_id()))
>  		return;
> -
> -	/* AK: following checks seem to be broken on modern chipsets. FIXME */
> -	if (reason & NMI_REASON_SERR)
> -		pci_serr_error(reason, regs);
> -	if (reason & NMI_REASON_IOCHK)
> -		io_check_error(reason, regs);
> -#ifdef CONFIG_X86_32
> -	/*
> -	 * Reassert NMI in case it became active meanwhile
> -	 * as it's edge-triggered:
> -	 */
> -	reassert_nmi();
>  #endif
> +
> +	if (notify_die(DIE_NMIUNKNOWN, "nmi_unknown", regs, reason, 2, SIGINT)
> +	    == NOTIFY_STOP)
> +		return;
> +
> +	unknown_nmi_error(reason, regs);
>  }
>  
>  dotraplinkage notrace __kprobes void
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -64,7 +64,6 @@ static int profile_exceptions_notify(str
>  	int ret = NOTIFY_DONE;
>  
>  	switch (val) {
> -	case DIE_NMI:
>  	case DIE_NMI_IPI:
>  		if (ctr_running)
>  			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
> --- a/arch/x86/oprofile/nmi_timer_int.c
> +++ b/arch/x86/oprofile/nmi_timer_int.c
> @@ -25,7 +25,7 @@ static int profile_timer_exceptions_noti
>  	int ret = NOTIFY_DONE;
>  
>  	switch (val) {
> -	case DIE_NMI:
> +	case DIE_NMI_IPI:
>  		oprofile_add_sample(args->regs, 0);
>  		ret = NOTIFY_STOP;
>  		break;
> --- a/drivers/char/ipmi/ipmi_watchdog.c
> +++ b/drivers/char/ipmi/ipmi_watchdog.c
> @@ -1080,7 +1080,7 @@ ipmi_nmi(struct notifier_block *self, un
>  {
>  	struct die_args *args = data;
>  
> -	if (val != DIE_NMI)
> +	if (val != DIE_NMIUNKNOWN)

As this function handles an nmi and not an unknown nmi, we should keep
DIE_NMI here and better modify priorities in ipmi_nmi_handler.

>  		return NOTIFY_OK;
>  
>  	/* Hack, if it's a memory or I/O error, ignore it. */
> --- a/drivers/watchdog/hpwdt.c
> +++ b/drivers/watchdog/hpwdt.c
> @@ -469,7 +469,7 @@ static int hpwdt_pretimeout(struct notif
>  	unsigned long rom_pl;
>  	static int die_nmi_called;
>  
> -	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
> +	if (ulReason != DIE_NMIUNKNOWN)

Same here, but dropping DIE_NMI_IPI.

-Robert

>  		goto out;
>  
>  	if (!hpwdt_nmi_decoding)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

