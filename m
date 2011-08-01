Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1HAHKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 03:10:17 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:46650
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751681Ab1HAHKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 03:10:13 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz4015L1432N98dKzz1202hzz8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP8MGX-02-3PU-02
X-M-MSG: 
Date: Mon, 1 Aug 2011 09:07:42 +0200
From: Robert Richter <robert.richter@amd.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2] oprofile, x86: Move memory allocation for ppro out of
 per cpu
Message-ID: <20110801070742.GA11795@erda.amd.com>
References: <4E35A14E.90702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E35A14E.90702@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.11 14:39:10, Maarten Lankhorst wrote:
> ppro_setup_ctrs is called on all cpu's, while init is only called once.

Can you please describe the root problem more precisely. Why can't you
run it on -rt? What is broken?

> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> 
> ---
> Oprofile shutdown is still broken. Doing kfree in the shutdown call gave

Do you mean it is broken and your patch fixes it, or is it still
broken even with your path applied?

> me a warning of in_atomic, so I moved to exit. This also allowed me to
> remove the null pointer checks, by zeroing reset_value on shutdown. But
> even with shutdown being broken on -rt at least I can run oprofile now. :)

If there is a problem I tend to fix it by using a hard coded array:

 static unsigned long reset_value[OP_MAX_COUNTER];

See arch/x86/oprofile/op_model_amd.c.

But still can't see the problem you want to fix.

Please cc Andi.

Thanks,

-Robert

> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 96646b3..fef08b2 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -790,5 +790,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  
>  void op_nmi_exit(void)
>  {
> +	if (model->exit)
> +		model->exit();
>  	exit_suspend_resume();
>  }
> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> index 94b7450..aefefcc 100644
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -30,6 +30,20 @@ static int counter_width = 32;
>  
>  static u64 *reset_value;
>  
> +static int ppro_init(struct oprofile_operations *ignore)
> +{
> +	reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
> +				GFP_KERNEL);
> +	if (!reset_value)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void ppro_exit(void)
> +{
> +	kfree(reset_value);
> +}
> +
>  static void ppro_shutdown(struct op_msrs const * const msrs)
>  {
>  	int i;
> @@ -39,10 +53,7 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
>  			continue;
>  		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
>  		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
> -	}
> -	if (reset_value) {
> -		kfree(reset_value);
> -		reset_value = NULL;
> +		reset_value[i] = 0;
>  	}
>  }
>  
> @@ -79,13 +90,6 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
>  	u64 val;
>  	int i;
>  
> -	if (!reset_value) {
> -		reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
> -					GFP_ATOMIC);
> -		if (!reset_value)
> -			return;
> -	}
> -
>  	if (cpu_has_arch_perfmon) {
>  		union cpuid10_eax eax;
>  		eax.full = cpuid_eax(0xa);
> @@ -141,13 +145,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
>  	u64 val;
>  	int i;
>  
> -	/*
> -	 * This can happen if perf counters are in use when
> -	 * we steal the die notifier NMI.
> -	 */
> -	if (unlikely(!reset_value))
> -		goto out;
> -
>  	for (i = 0; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
> @@ -158,7 +155,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
>  		wrmsrl(msrs->counters[i].addr, -reset_value[i]);
>  	}
>  
> -out:
>  	/* Only P6 based Pentium M need to re-unmask the apic vector but it
>  	 * doesn't hurt other P6 variant */
>  	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> @@ -179,8 +175,6 @@ static void ppro_start(struct op_msrs const * const msrs)
>  	u64 val;
>  	int i;
>  
> -	if (!reset_value)
> -		return;
>  	for (i = 0; i < num_counters; ++i) {
>  		if (reset_value[i]) {
>  			rdmsrl(msrs->controls[i].addr, val);
> @@ -196,8 +190,6 @@ static void ppro_stop(struct op_msrs const * const msrs)
>  	u64 val;
>  	int i;
>  
> -	if (!reset_value)
> -		return;
>  	for (i = 0; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
> @@ -211,6 +203,8 @@ struct op_x86_model_spec op_ppro_spec = {
>  	.num_counters		= 2,
>  	.num_controls		= 2,
>  	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
> +	.init			= &ppro_init,
> +	.exit			= &ppro_exit,
>  	.fill_in_addresses	= &ppro_fill_in_addresses,
>  	.setup_ctrs		= &ppro_setup_ctrs,
>  	.check_ctrs		= &ppro_check_ctrs,
> @@ -251,12 +245,13 @@ static void arch_perfmon_setup_counters(void)
>  static int arch_perfmon_init(struct oprofile_operations *ignore)
>  {
>  	arch_perfmon_setup_counters();
> -	return 0;
> +	return ppro_init(ignore);
>  }
>  
>  struct op_x86_model_spec op_arch_perfmon_spec = {
>  	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
>  	.init			= &arch_perfmon_init,
> +	.exit			= &ppro_exit,
>  	/* num_counters/num_controls filled in at runtime */
>  	.fill_in_addresses	= &ppro_fill_in_addresses,
>  	/* user space does the cpuid check for available events */
> diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
> index 89017fa..e77fd91 100644
> --- a/arch/x86/oprofile/op_x86_model.h
> +++ b/arch/x86/oprofile/op_x86_model.h
> @@ -40,6 +40,7 @@ struct op_x86_model_spec {
>  	u64		reserved;
>  	u16		event_mask;
>  	int		(*init)(struct oprofile_operations *ops);
> +	void		(*exit)(void);
>  	int		(*fill_in_addresses)(struct op_msrs * const msrs);
>  	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
>  				      struct op_msrs const * const msrs);
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

