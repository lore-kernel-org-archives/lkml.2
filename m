Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1EQRgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:36:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40901 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab1EQRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:36:12 -0400
Date: Tue, 17 May 2011 19:35:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "Langsdorf, Mark" <mark.langsdorf@amd.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH 1/5] acpi-cpufreq: Add support for modern AMD CPUs
Message-ID: <20110517173536.GI30053@aftab>
References: <1305651819-25660-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305651819-25660-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 01:03:35PM -0400, Matthew Garrett wrote:
> The programming model for P-states on modern AMD CPUs is very similar to
> that of Intel and VIA. It makes sense to consolidate this support into one
> driver rather than duplicating functionality between two of them. This
> patch adds support for AMDs with hardware P-state control to acpi-cpufreq.

Ok, I'm a bit confused here but maybe because I don't know the whole
cpufreq subsystem that well. Is the purpose here to add hw pstates
support to acpi-cpufreq so that it is used on AMD but leave the old
Fid/Vid method to powernow-k8, thus phasing it out...?

Hmm.

Some nitpicks below.

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/include/asm/cpufeature.h          |    1 +
>  arch/x86/include/asm/msr-index.h           |    2 +
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   43 ++++++++++++++++++++++++----
>  arch/x86/kernel/cpu/scattered.c            |    1 +
>  4 files changed, 41 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 91f3e087..fee7089 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -174,6 +174,7 @@
>  #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
>  #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
>  #define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
> +#define X86_FEATURE_POWERNOW	(7*32+ 8) /* AMD frequency scaling */
>  
>  /* Virtualization flags: Linux defined, word 8 */
>  #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 3cce714..d6f3e1f 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -233,6 +233,8 @@
>  
>  #define MSR_IA32_PERF_STATUS		0x00000198
>  #define MSR_IA32_PERF_CTL		0x00000199
> +#define MSR_AMD_PERF_STATUS		0xc0010063
> +#define MSR_AMD_PERF_CTL		0xc0010062

Yeah, there are defines for those in
<arch/x86/kernel/cpu/cpufreq/powernow-k8.h>:

#define MSR_PSTATE_STATUS       0xc0010063 /* Pstate Status MSR */
#define MSR_PSTATE_CTRL         0xc0010062 /* Pstate control MSR */

can you remove them from there for consistency so that we can use only
the msr-index.h definitions.

>  
>  #define MSR_IA32_MPERF			0x000000e7
>  #define MSR_IA32_APERF			0x000000e8
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index a2baafb..f3dd3b1 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -57,10 +57,12 @@ MODULE_LICENSE("GPL");
>  enum {
>  	UNDEFINED_CAPABLE = 0,
>  	SYSTEM_INTEL_MSR_CAPABLE,
> +	SYSTEM_AMD_MSR_CAPABLE,
>  	SYSTEM_IO_CAPABLE,
>  };
>  
>  #define INTEL_MSR_RANGE		(0xffff)
> +#define AMD_MSR_RANGE		(0x7)
>  
>  struct acpi_cpufreq_data {
>  	struct acpi_processor_performance *acpi_data;
> @@ -85,6 +87,13 @@ static int check_est_cpu(unsigned int cpuid)
>  	return cpu_has(cpu, X86_FEATURE_EST);
>  }
>  
> +static int check_powernow_cpu(unsigned int cpuid)
> +{
> +	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
> +
> +	return cpu_has(cpu, X86_FEATURE_POWERNOW);
> +}

This could be static_cpu_has() since all the CPUs, including the boot
CPU, will have the HwPstate thing set. Thus, you can ignore the "cpuid"
parameter.

> +
>  static unsigned extract_io(u32 value, struct acpi_cpufreq_data *data)
>  {
>  	struct acpi_processor_performance *perf;
> @@ -104,7 +113,11 @@ static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
>  	int i;
>  	struct acpi_processor_performance *perf;
>  
> -	msr &= INTEL_MSR_RANGE;
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
> +		msr &= AMD_MSR_RANGE;
> +	else
> +		msr &= INTEL_MSR_RANGE;
> +
>  	perf = data->acpi_data;
>  
>  	for (i = 0; data->freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
> @@ -118,6 +131,7 @@ static unsigned extract_freq(u32 val, struct acpi_cpufreq_data *data)
>  {
>  	switch (data->cpu_feature) {
>  	case SYSTEM_INTEL_MSR_CAPABLE:
> +	case SYSTEM_AMD_MSR_CAPABLE:
>  		return extract_msr(val, data);
>  	case SYSTEM_IO_CAPABLE:
>  		return extract_io(val, data);
> @@ -153,6 +167,7 @@ static void do_drv_read(void *_cmd)
>  
>  	switch (cmd->type) {
>  	case SYSTEM_INTEL_MSR_CAPABLE:
> +	case SYSTEM_AMD_MSR_CAPABLE:
>  		rdmsr(cmd->addr.msr.reg, cmd->val, h);
>  		break;
>  	case SYSTEM_IO_CAPABLE:
> @@ -177,6 +192,9 @@ static void do_drv_write(void *_cmd)
>  		lo = (lo & ~INTEL_MSR_RANGE) | (cmd->val & INTEL_MSR_RANGE);
>  		wrmsr(cmd->addr.msr.reg, lo, hi);
>  		break;
> +	case SYSTEM_AMD_MSR_CAPABLE:
> +		wrmsr(cmd->addr.msr.reg, cmd->val, 0);
> +		break;
>  	case SYSTEM_IO_CAPABLE:
>  		acpi_os_write_port((acpi_io_address)cmd->addr.io.port,
>  				cmd->val,
> @@ -220,6 +238,10 @@ static u32 get_cur_val(const struct cpumask *mask)
>  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
>  		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
>  		break;
> +	case SYSTEM_AMD_MSR_CAPABLE:
> +		cmd.type = SYSTEM_AMD_MSR_CAPABLE;
> +		cmd.addr.msr.reg = MSR_AMD_PERF_STATUS;
> +		break;
>  	case SYSTEM_IO_CAPABLE:
>  		cmd.type = SYSTEM_IO_CAPABLE;
>  		perf = per_cpu(acfreq_data, cpumask_first(mask))->acpi_data;
> @@ -329,6 +351,11 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
>  		cmd.addr.msr.reg = MSR_IA32_PERF_CTL;
>  		cmd.val = (u32) perf->states[next_perf_state].control;
>  		break;
> +	case SYSTEM_AMD_MSR_CAPABLE:
> +		cmd.type = SYSTEM_AMD_MSR_CAPABLE;
> +		cmd.addr.msr.reg = MSR_AMD_PERF_CTL;
> +		cmd.val = (u32) perf->states[next_perf_state].control;
> +		break;
>  	case SYSTEM_IO_CAPABLE:
>  		cmd.type = SYSTEM_IO_CAPABLE;
>  		cmd.addr.io.port = perf->control_register.address;
> @@ -583,12 +610,16 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  		break;
>  	case ACPI_ADR_SPACE_FIXED_HARDWARE:
>  		dprintk("HARDWARE addr space\n");
> -		if (!check_est_cpu(cpu)) {
> -			result = -ENODEV;
> -			goto err_unreg;
> +		if (check_est_cpu(cpu)) {
> +			data->cpu_feature = SYSTEM_INTEL_MSR_CAPABLE;
> +			break;
>  		}
> -		data->cpu_feature = SYSTEM_INTEL_MSR_CAPABLE;
> -		break;
> +		if (check_powernow_cpu(cpu)) {
> +			data->cpu_feature = SYSTEM_AMD_MSR_CAPABLE;
> +			break;
> +		}
> +		result = -ENODEV;
> +		goto err_unreg;
>  	default:
>  		dprintk("Unknown addr space %d\n",
>  			(u32) (perf->control_register.space_id));
> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
> index c7f64e6..d5086af 100644
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -39,6 +39,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
>  		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
>  		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
>  		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
> +		{ X86_FEATURE_POWERNOW,		CR_EDX, 7, 0x80000007, 0 },
>  		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
>  		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
>  		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },

It might make sense to split out the cpuid changes to a different patch,
IMHO.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
