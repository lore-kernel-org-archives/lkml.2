Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab2BLJdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 04:33:15 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45311 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2BLJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 04:33:11 -0500
Message-ID: <4F37874F.4010107@gmail.com>
Date: Sun, 12 Feb 2012 17:33:03 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>, Chen Gong <gong.chen@linux.intel.com>
CC: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] acpi/apei/einj: Add extensions to EINJ from rev 5.0 of
 acpi spec
References: <1e89d444cd527f11ff9c24ccca741a25cfab3962.1326831060.git.tony.luck@intel.com>
In-Reply-To: <1e89d444cd527f11ff9c24ccca741a25cfab3962.1326831060.git.tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony and Gong,
	Should we remove the target memory address from the resource list of 
ACPI5 trigger too? Otherwise we may also encounter resource conflict with ACPI5
trigger table.

@@ -365,7 +365,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
         * This will cause resource conflict with regular memory.  So
         * remove it from trigger table resources.
         */
-       if (param_extension && (type & 0x0038) && param2) {
+       if ((param_extension || acpi5) && (type & 0x0038) && param2) {
                struct apei_resources addr_resources;
                apei_resources_init(&addr_resources);
                trigger_param_region = einj_get_trigger_parameter_region(
	
On 01/18/2012 04:10 AM, Tony Luck wrote:
> @@ -293,12 +386,56 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
>  	if (rc)
>  		return rc;
>  	apei_exec_ctx_set_input(&ctx, type);
> -	rc = apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE);
> -	if (rc)
> -		return rc;
> -	if (einj_param) {
> -		writeq(param1, &einj_param->param1);
> -		writeq(param2, &einj_param->param2);
> +	if (acpi5) {
> +		struct set_error_type_with_address *v5param = einj_param;
> +
> +		writel(type, &v5param->type);
> +		if (type & 0x80000000) {
> +			switch (vendor_flags) {
> +			case SETWA_FLAGS_APICID:
> +				writel(param1, &v5param->apicid);
> +				break;
> +			case SETWA_FLAGS_MEM:
> +				writeq(param1, &v5param->memory_address);
> +				writeq(param2, &v5param->memory_address_range);
> +				break;
> +			case SETWA_FLAGS_PCIE_SBDF:
> +				writel(param1, &v5param->pcie_sbdf);
> +				break;
> +			}
> +			writel(vendor_flags, &v5param->flags);
> +		} else {
> +			switch (type) {
> +			case ACPI_EINJ_PROCESSOR_CORRECTABLE:
> +			case ACPI_EINJ_PROCESSOR_UNCORRECTABLE:
> +			case ACPI_EINJ_PROCESSOR_FATAL:
> +				writel(param1, &v5param->apicid);
> +				writel(SETWA_FLAGS_APICID, &v5param->flags);
> +				break;
> +			case ACPI_EINJ_MEMORY_CORRECTABLE:
> +			case ACPI_EINJ_MEMORY_UNCORRECTABLE:
> +			case ACPI_EINJ_MEMORY_FATAL:
> +				writeq(param1, &v5param->memory_address);
> +				writeq(param2, &v5param->memory_address_range);
> +				writel(SETWA_FLAGS_MEM, &v5param->flags);
> +				break;
> +			case ACPI_EINJ_PCIX_CORRECTABLE:
> +			case ACPI_EINJ_PCIX_UNCORRECTABLE:
> +			case ACPI_EINJ_PCIX_FATAL:
> +				writel(param1, &v5param->pcie_sbdf);
> +				writel(SETWA_FLAGS_PCIE_SBDF, &v5param->flags);
> +				break;
> +			}
> +		}
I'm a little confused about the ACPI_EINJ_SET_ERROR_TYPE_WITH_ADDRESS command in ACPI5.
The above code seems like a hard-coded version of 
apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE_WITH_ADDRESS).
Hi Gong, could you please share the ACPI5 version of EINJ table with me? So I could
get better understanding of the ACPI_EINJ_SET_ERROR_TYPE_WITH_ADDRESS command.

> +	} else {
> +		rc = apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE);
> +		if (rc)
> +			return rc;
> +		if (einj_param) {
> +			struct einj_parameter *v4param = einj_param;
> +			writeq(param1, &v4param->param1);
> +			writeq(param2, &v4param->param2);
> +		}
>  	}
>  	rc = apei_exec_run(&ctx, ACPI_EINJ_EXECUTE_OPERATION);
>  	if (rc)
> @@ -408,15 +545,25 @@ static int error_type_set(void *data, u64 val)
>  {
>  	int rc;
>  	u32 available_error_type = 0;
> +	u32 tval, vendor;
> +
> +	/*
> +	 * Vendor defined types have 0x80000000 bit set, and
> +	 * are not enumerated by ACPI_EINJ_GET_ERROR_TYPE
> +	 */
> +	vendor = val & 0x80000000;
> +	tval = val & 0x7fffffff;
>  
>  	/* Only one error type can be specified */
> -	if (val & (val - 1))
> -		return -EINVAL;
> -	rc = einj_get_available_error_type(&available_error_type);
> -	if (rc)
> -		return rc;
> -	if (!(val & available_error_type))
> +	if (tval & (tval - 1))
The ACPI5 spec doesn't specify the format of vendor specific error type, so would it
be better to check above condition only if it's a standard error type?

>  		return -EINVAL;
> +	if (!vendor) {
> +		rc = einj_get_available_error_type(&available_error_type);
> +		if (rc)
> +			return rc;
> +		if (!(val & available_error_type))
> +			return -EINVAL;
> +	}
>  	error_type = val;
>  
>  	return 0;
