Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab1LFIWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 03:22:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:35215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988Ab1LFIWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 03:22:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,304,1320652800"; 
   d="scan'208";a="99079765"
Message-ID: <4EDDD0B5.3010702@linux.intel.com>
Date: Tue, 06 Dec 2011 16:22:13 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] acpi-apei-einj: add extensions to EINJ from rev 5.0 of
 acpi spec
References: <4ed5352d208477d14@agluck-desktop.sc.intel.com>
In-Reply-To: <4ed5352d208477d14@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/11/30 3:40, Luck, Tony 写道:
> ACPI 5.0 provides extensions to the EINJ mechanism to specify the
> target for the error injection - by APICID for cpu related errors,
> by address for memory related errors, and by segment/bus/device/function
> for PCIe related errors. Also extensions for vendor specific error
> injections.
>
> Signed-off-by: Tony Luck<tony.luck@intel.com>
> ---
>   drivers/acpi/apei/einj.c |  217 ++++++++++++++++++++++++++++++++++++++--------
>   include/acpi/actbl1.h    |    3 +-
>   2 files changed, 183 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index 589b96c..b65d80d 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -43,6 +43,42 @@
>   #define FIRMWARE_TIMEOUT	(1 * NSEC_PER_MSEC)
>
>   /*
> + * ACPI version 5 provides a SET_ERROR_TYPE_WITH_ADDRESS action.
> + */
> +static int acpi5;
> +
> +struct set_error_type_with_address {
> +	u32	type;
> +	u32	vendor_extension;
> +	u32	flags;
> +	u32	apicid;
> +	u64	memory_address;
> +	u64	memory_address_range;
> +	u32	pcie_sbdf;
> +};
> +enum {
> +	SETWA_FLAGS_APICID = 1,
> +	SETWA_FLAGS_MEM = 2,
> +	SETWA_FLAGS_PCIE_SBDF = 4,
> +};
> +
> +/*
> + * Vendor extensions for platform specific operations
> + */
> +struct vendor_error_type_extension {
> +	u32	length;
> +	u32	pcie_sbdf;
> +	u16	vendor_id;
> +	u16	device_id;
> +	u8	rev_id;
> +	u8	reserved[3];
> +};
> +
> +static u32 vendor_flags;
> +static struct debugfs_blob_wrapper vendor_blob;
> +static char vendor_dev[64];
> +
> +/*
>    * Some BIOSes allow parameters to the SET_ERROR_TYPE entries in the
>    * EINJ table through an unpublished extension. Use with caution as
>    * most will ignore the parameter and make their own choice of address
> @@ -103,7 +139,7 @@ static struct apei_exec_ins_type einj_ins_type[] = {
>    */
>   static DEFINE_MUTEX(einj_mutex);
>
> -static struct einj_parameter *einj_param;
> +static void *einj_param;
>
>   #ifndef writeq
>   static inline void writeq(__u64 val, volatile void __iomem *addr)
> @@ -158,10 +194,31 @@ static int einj_timedout(u64 *t)
>   	return 0;
>   }
>
> -static u64 einj_get_parameter_address(void)
> +static void check_vendor_extension(u64 paddr,
> +				   struct set_error_type_with_address *v5param)
> +{
> +	int	offset = readl(&v5param->vendor_extension);
> +	struct	vendor_error_type_extension *v;
> +	u32	sbdf;
> +
> +	if (!offset)
> +		return;
> +	v = ioremap(paddr + offset, sizeof(*v));
> +	if (!v)
> +		return;
> +	sbdf = readl(&v->pcie_sbdf);
> +	sprintf(vendor_dev, "%x:%x:%x.%x vendor_id=%x device_id=%x rev_id=%x\n",
> +		sbdf>>  24, (sbdf>>  16)&  0xff, (sbdf>>  11)&  0x1f, (sbdf>>  8)&  0x7,
> +		 readw(&v->vendor_id), readw(&v->device_id),
> +		readb(&v->rev_id));
> +	iounmap(v);
> +}
> +
> +static void *einj_get_parameter_address(void)
>   {
>   	int i;
> -	u64 paddr = 0;
> +	u64 paddrv4 = 0, paddrv5 = 0;
> +	void *param;
>   	struct acpi_whea_header *entry;
>
>   	entry = EINJ_TAB_ENTRY(einj_tab);
> @@ -170,12 +227,40 @@ static u64 einj_get_parameter_address(void)
>   		    entry->instruction == ACPI_EINJ_WRITE_REGISTER&&
>   		entry->register_region.space_id ==
>   		    ACPI_ADR_SPACE_SYSTEM_MEMORY)
> -			memcpy(&paddr,&entry->register_region.address,
> -			       sizeof(paddr));
> +			memcpy(&paddrv4,&entry->register_region.address,
> +			       sizeof(paddrv4));
> +		if (entry->action == ACPI_EINJ_SET_ERROR_TYPE_WITH_ADDRESS&&
> +		    entry->instruction == ACPI_EINJ_WRITE_REGISTER&&
> +		    entry->register_region.space_id ==
> +		    ACPI_ADR_SPACE_SYSTEM_MEMORY)
> +			memcpy(&paddrv5,&entry->register_region.address,
> +			       sizeof(paddrv5));
>   		entry++;
>   	}
> +	if (paddrv5) {
> +		struct set_error_type_with_address *v5param;
> +
> +		v5param = ioremap(paddrv5, sizeof(*v5param));
> +		if (v5param) {
> +			acpi5 = 1;
> +			check_vendor_extension(paddrv5, v5param);
> +			return v5param;
> +		}
> +	}
> +	if (paddrv4) {
> +		struct einj_parameter *v4param;
> +
> +		v4param = ioremap(paddrv4, sizeof(*v4param));
> +		if (!v4param)
> +			return 0;
> +		if (readq(&v4param->reserved1) || readq(&v4param->reserved2)) {
> +			iounmap(param);
> +			return 0;
> +		}
> +		return v4param;
> +	}
>
> -	return paddr;
> +	return 0;
>   }
>
>   /* do sanity check to trigger table */
> @@ -293,12 +378,56 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
>   	if (rc)
>   		return rc;
>   	apei_exec_ctx_set_input(&ctx, type);
> -	rc = apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE);
> -	if (rc)
> -		return rc;
> -	if (einj_param) {
> -		writeq(param1,&einj_param->param1);
> -		writeq(param2,&einj_param->param2);
> +	if (acpi5) {
> +		struct set_error_type_with_address *v5param = einj_param;
> +
> +		writel(type,&v5param->type);
> +		if (type&  0x80000000) {
> +			switch (vendor_flags) {
> +			case SETWA_FLAGS_APICID:
> +				writel(param1,&v5param->apicid);
> +				break;
> +			case SETWA_FLAGS_MEM:
> +				writeq(param1,&v5param->memory_address);
> +				writeq(param2,&v5param->memory_address_range);
> +				break;
> +			case SETWA_FLAGS_PCIE_SBDF:
> +				writel(param1,&v5param->pcie_sbdf);
> +				break;
> +			}
> +			writel(vendor_flags,&v5param->flags);

I don't think one knows how to set *vendor_flags* correctly if no any
instructions.

> +		} else {
> +			switch (type) {
> +			case ACPI_EINJ_PROCESSOR_CORRECTABLE:
> +			case ACPI_EINJ_PROCESSOR_UNCORRECTABLE:
> +			case ACPI_EINJ_PROCESSOR_FATAL:
> +				writel(param1,&v5param->apicid);
> +				writel(SETWA_FLAGS_APICID,&v5param->flags);
> +				break;
> +			case ACPI_EINJ_MEMORY_CORRECTABLE:
> +			case ACPI_EINJ_MEMORY_UNCORRECTABLE:
> +			case ACPI_EINJ_MEMORY_FATAL:
> +				writeq(param1,&v5param->memory_address);
> +				writeq(param2,&v5param->memory_address_range);
> +				writel(SETWA_FLAGS_MEM,&v5param->flags);
> +				break;
> +			case ACPI_EINJ_PCIX_CORRECTABLE:
> +			case ACPI_EINJ_PCIX_UNCORRECTABLE:
> +			case ACPI_EINJ_PCIX_FATAL:
> +				writel(param1,&v5param->pcie_sbdf);
> +				writel(SETWA_FLAGS_PCIE_SBDF,&v5param->flags);
> +				break;
> +			}
> +		}
> +	} else {
> +		rc = apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE);
> +		if (rc)
> +			return rc;
> +		if (einj_param) {
> +			struct einj_parameter *v4param = einj_param;
> +			writeq(param1,&v4param->param1);
> +			writeq(param2,&v4param->param2);
> +		}
>   	}
>   	rc = apei_exec_run(&ctx, ACPI_EINJ_EXECUTE_OPERATION);
>   	if (rc)
> @@ -408,15 +537,25 @@ static int error_type_set(void *data, u64 val)
>   {
>   	int rc;
>   	u32 available_error_type = 0;
> +	u32 tval, vendor;
> +
> +	/*
> +	 * Vendor defined types have 0x80000000 bit set, and
> +	 * are not enumerated by ACPI_EINJ_GET_ERROR_TYPE
> +	 */
> +	vendor = val&  0x80000000;

need explanation in the document how to set error type in ACPI 5.0.

In the spec it doesn't say this bit field is filled by the user, from
the codes I have following conclusion: one can set error type as 0x2,
0x4, 0x8 etc. or 0x80000002, 0x80000004, 0x80000008 etc, right?

> +	tval = val&  0x7fffffff;
>
>   	/* Only one error type can be specified */
> -	if (val&  (val - 1))
> -		return -EINVAL;
> -	rc = einj_get_available_error_type(&available_error_type);
> -	if (rc)
> -		return rc;
> -	if (!(val&  available_error_type))
> +	if (tval&  (tval - 1))
>   		return -EINVAL;
> +	if (!vendor) {

Why checking input parameter *val* only when *vendor* is assigned?
I think any time input parameter should be checked.

> +		rc = einj_get_available_error_type(&available_error_type);
> +		if (rc)
> +			return rc;
> +		if (!(val&  available_error_type))
> +			return -EINVAL;
> +	}
>   	error_type = val;
>
>   	return 0;
> @@ -455,7 +594,6 @@ static int einj_check_table(struct acpi_table_einj *einj_tab)
>   static int __init einj_init(void)
>   {
>   	int rc;
> -	u64 param_paddr;
>   	acpi_status status;
>   	struct dentry *fentry;
>   	struct apei_exec_context ctx;
> @@ -509,23 +647,30 @@ static int __init einj_init(void)
>   	rc = apei_exec_pre_map_gars(&ctx);
>   	if (rc)
>   		goto err_release;
> -	if (param_extension) {
> -		param_paddr = einj_get_parameter_address();
> -		if (param_paddr) {
> -			einj_param = ioremap(param_paddr, sizeof(*einj_param));
> -			rc = -ENOMEM;
> -			if (!einj_param)
> -				goto err_unmap;
> -			fentry = debugfs_create_x64("param1", S_IRUSR | S_IWUSR,
> -						    einj_debug_dir,&error_param1);
> -			if (!fentry)
> -				goto err_unmap;
> -			fentry = debugfs_create_x64("param2", S_IRUSR | S_IWUSR,
> -						    einj_debug_dir,&error_param2);
> -			if (!fentry)
> -				goto err_unmap;
> -		} else
> -			pr_warn(EINJ_PFX "Parameter extension is not supported.\n");
> +
> +	einj_param = einj_get_parameter_address();
> +	if ((param_extension || acpi5)&&  einj_param) {
> +		fentry = debugfs_create_x64("param1", S_IRUSR | S_IWUSR,
> +					    einj_debug_dir,&error_param1);
> +		if (!fentry)
> +			goto err_unmap;
> +		fentry = debugfs_create_x64("param2", S_IRUSR | S_IWUSR,
> +					    einj_debug_dir,&error_param2);
> +		if (!fentry)
> +			goto err_unmap;
> +	}
> +
> +	if (vendor_dev[0]) {
> +		vendor_blob.data = vendor_dev;
> +		vendor_blob.size = strlen(vendor_dev);
> +		fentry = debugfs_create_blob("vendor", S_IRUSR,
> +					     einj_debug_dir,&vendor_blob);
> +		if (!fentry)
> +			goto err_unmap;
> +		fentry = debugfs_create_x32("vendor_flags", S_IRUSR | S_IWUSR,
> +					    einj_debug_dir,&vendor_flags);
> +		if (!fentry)
> +			goto err_unmap;
>   	}
>
>   	pr_info(EINJ_PFX "Error INJection is initialized.\n");
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 7504bc9..f25d7ef 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -228,7 +228,8 @@ enum acpi_einj_actions {
>   	ACPI_EINJ_EXECUTE_OPERATION = 5,
>   	ACPI_EINJ_CHECK_BUSY_STATUS = 6,
>   	ACPI_EINJ_GET_COMMAND_STATUS = 7,
> -	ACPI_EINJ_ACTION_RESERVED = 8,	/* 8 and greater are reserved */
> +	ACPI_EINJ_SET_ERROR_TYPE_WITH_ADDRESS = 8,
> +	ACPI_EINJ_ACTION_RESERVED = 9,	/* 9 and greater are reserved */
>   	ACPI_EINJ_TRIGGER_ERROR = 0xFF	/* Except for this value */
>   };
>

