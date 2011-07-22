Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1GVOlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:41:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39381 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab1GVOly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:41:54 -0400
Date: Fri, 22 Jul 2011 16:41:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Langsdorf, Mark" <mark.langsdorf@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 3/7] acpi-cpufreq: Add support for disabling dynamic
 overclocking
Message-ID: <20110722144143.GA26010@aftab>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
 <1311007062-2050-4-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311007062-2050-4-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 12:37:38PM -0400, Matthew Garrett wrote:
> One feature present in powernow-k8 that isn't present in acpi-cpufreq is
> support for enabling or disabling AMD's core performance boost technology.
> This patch adds that support to acpi-cpufreq, but also extends it to allow
> Intel's dynamic acceleration to be disabled via the same interface. The
> sysfs entry retains the cpb name for compatibility purposes.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/cpufreq/acpi-cpufreq.c |  191 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 191 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index 298d451..0a92277 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -76,6 +76,107 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
>  static struct cpufreq_driver acpi_cpufreq_driver;
>  
>  static unsigned int acpi_pstate_strict;
> +static bool cpb_enabled, cpb_supported;
> +static struct msr __percpu *msrs;
> +
> +static bool cpb_state(unsigned int cpu)
> +{
> +	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
> +	u32 lo, hi;
> +	u64 msr;
> +
> +	switch (data->cpu_feature) {
> +	case SYSTEM_INTEL_MSR_CAPABLE:
> +		rdmsr_on_cpu(cpu, MSR_IA32_MISC_ENABLE, &lo, &hi);
> +		msr = lo | ((u64)hi << 32);
> +		return !(msr & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);
> +	case SYSTEM_AMD_MSR_CAPABLE:
> +		rdmsr_on_cpu(cpu, MSR_K7_HWCR, &lo, &hi);
> +		msr = lo | ((u64)hi << 32);
> +		return !(msr & BIT(25));
> +	}
> +	return false;
> +}

You need to handle the case where boosting is not even supported by the
CPU. For example, a Barcelona CPU does not boost but I get

$ cat /sys/devices/system/cpu/cpu0/cpufreq/boost
1

This is because this bit in the register is simply reserved and it
countains some random value (0 in this case).

What you need to do is look at the cpu_enabled variable which is caching
the current boost state. Besides, you don't want to do a MSR read
everytime you 'cat' the sysfs entry. See how powernow-k8 does it. I'm
guessing with Intel it should be similar.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
