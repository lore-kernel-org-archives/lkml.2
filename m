Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1GNOuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:50:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab1GNOuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:50:08 -0400
Date: Thu, 14 Jul 2011 10:50:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 10/17] ACPI, APEI, Add WHEA _OSC support
Message-ID: <20110714145002.GC3080@redhat.com>
References: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
 <1310534068-30547-11-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310534068-30547-11-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 01:14:21PM +0800, Huang Ying wrote:
> APEI firmware first mode must be turned on explicitly on some
> machines, otherwise there may be no GHES hardware error record for
> hardware error notification.  APEI bit in generic _OSC call can be
> used to do that, but on some machine, a special WHEA _OSC call must be
> used.  This patch adds the support to that WHEA _OSC call.

Without this patch APEI can't do anything.  I have been using this for a
few weeks to do some internal APEI testing on various machines with no
issues (at least with regards to this patch).

Tested-and-reviewed-by: Don Zickus <dzickus@redhat.com>

> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Reviewed-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/acpi/apei/apei-base.c     |   26 ++++++++++++++++++++++++++
>  drivers/acpi/apei/apei-internal.h |    2 ++
>  drivers/acpi/apei/ghes.c          |   10 ++++++++++
>  3 files changed, 38 insertions(+)
> 
> --- a/drivers/acpi/apei/apei-base.c
> +++ b/drivers/acpi/apei/apei-base.c
> @@ -604,3 +604,29 @@ struct dentry *apei_get_debugfs_dir(void
>  	return dapei;
>  }
>  EXPORT_SYMBOL_GPL(apei_get_debugfs_dir);
> +
> +int apei_osc_setup(void)
> +{
> +	static u8 whea_uuid_str[] = "ed855e0c-6c90-47bf-a62a-26de0fc5ad5c";
> +	acpi_handle handle;
> +	u32 capbuf[3];
> +	struct acpi_osc_context context = {
> +		.uuid_str	= whea_uuid_str,
> +		.rev		= 1,
> +		.cap.length	= sizeof(capbuf),
> +		.cap.pointer	= capbuf,
> +	};
> +
> +	capbuf[OSC_QUERY_TYPE] = OSC_QUERY_ENABLE;
> +	capbuf[OSC_SUPPORT_TYPE] = 0;
> +	capbuf[OSC_CONTROL_TYPE] = 0;
> +
> +	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle))
> +	    || ACPI_FAILURE(acpi_run_osc(handle, &context)))
> +		return -EIO;
> +	else {
> +		kfree(context.ret.pointer);
> +		return 0;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(apei_osc_setup);
> --- a/drivers/acpi/apei/apei-internal.h
> +++ b/drivers/acpi/apei/apei-internal.h
> @@ -124,4 +124,6 @@ void apei_estatus_print(const char *pfx,
>  			const struct acpi_hest_generic_status *estatus);
>  int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus);
>  int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
> +
> +int apei_osc_setup(void);
>  #endif
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -681,6 +681,16 @@ static int __init ghes_init(void)
>  	if (rc)
>  		goto err_ioremap_exit;
>  
> +	rc = apei_osc_setup();
> +	if (rc == 0 && osc_sb_apei_support_acked)
> +		pr_info(GHES_PFX "APEI firmware first mode is enabled by APEI bit and WHEA _OSC.\n");
> +	else if (rc == 0 && !osc_sb_apei_support_acked)
> +		pr_info(GHES_PFX "APEI firmware first mode is enabled by WHEA _OSC.\n");
> +	else if (rc && osc_sb_apei_support_acked)
> +		pr_info(GHES_PFX "APEI firmware first mode is enabled by APEI bit.\n");
> +	else
> +		pr_info(GHES_PFX "Failed to enable APEI firmware first mode.\n");
> +
>  	return 0;
>  err_ioremap_exit:
>  	ghes_ioremap_exit();
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
