Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1FRL2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 07:28:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36097 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab1FRL23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 07:28:29 -0400
Date: Sat, 18 Jun 2011 13:28:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com, davej@redhat.com,
        mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
        andreas.herrmann3@amd.com
Subject: Re: [PATCH V2 4/6] ACPI: Add fixups for AMD P-state figures
Message-ID: <20110618112825.GC7445@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
	borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
	cpufreq@vger.kernel.org, andreas.herrmann3@amd.com
References: <1308340257-10117-1-git-send-email-mjg@redhat.com>
 <1308340257-10117-4-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1308340257-10117-4-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 03:50:55PM -0400, Matthew Garrett wrote:
> Some AMD systems may round the frequencies in ACPI tables to 100MHz
> boundaries. We can obtain the real frequencies from MSRs, so add a quirk
> to fix these frequencies up on AMD systems.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/acpi/processor_perflib.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> index 85b3237..9e18173 100644
> --- a/drivers/acpi/processor_perflib.c
> +++ b/drivers/acpi/processor_perflib.c
> @@ -302,6 +302,34 @@ static int acpi_processor_get_performance_control(struct acpi_processor *pr)
>  	return result;
>  }
>  
> +#ifdef CONFIG_X86
> +/*
> + * Some AMDs have 50MHz frequency multiples, but only provide 100MHz rounding
> + * in their ACPI data. Calculate the real values and fix up the _PSS data.
> + */
> +static void amd_fixup_frequency(struct acpi_processor_px *px, int i)
> +{
> +	u32 hi, lo, fid, did;
> +	int index = px->control & 0x00000007;
> +
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> +		return;
> +
> +	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
> +	    || boot_cpu_data.x86 == 0x11) {
> +		rdmsr(0xc0010064 + index, lo, hi);

		      MSR_PSTATE_DEF_BASE

> +		fid = lo & 0x3f;
> +		did = (lo >> 6) & 7;
> +		if (boot_cpu_data.x86 == 0x10)
> +			px->core_frequency = (100 * (fid + 0x10)) >> did;
> +		else
> +			px->core_frequency = (100 * (fid + 8)) >> did;
> +	}
> +}
> +#else
> +static void amd_fixup_frequency(struct acpi_processor_px *px, int i) {};
> +#endif
> +
>  static int acpi_processor_get_performance_states(struct acpi_processor *pr)
>  {
>  	int result = 0;
> @@ -356,6 +384,8 @@ static int acpi_processor_get_performance_states(struct acpi_processor *pr)
>  			goto end;
>  		}
>  
> +		amd_fixup_frequency(px, i);
> +
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  				  "State [%d]: core_frequency[%d] power[%d] transition_latency[%d] bus_master_latency[%d] control[0x%x] status[0x%x]\n",
>  				  i,
> -- 
> 1.7.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
