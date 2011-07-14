Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1GNOr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab1GNOr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:47:26 -0400
Date: Thu, 14 Jul 2011 10:47:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 08/17] ACPI, APEI, GHES, Support disable GHES at boot time
Message-ID: <20110714144716.GA3080@redhat.com>
References: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
 <1310534068-30547-9-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310534068-30547-9-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 01:14:19PM +0800, Huang Ying wrote:
> Some machine may have broken firmware so that GHES and firmware first
> mode should be disabled.  This patch adds support to that.

Does this still work if you have disabled ghes module support in the
previous patch?

Cheers,
Don

> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Reviewed-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/acpi/apei/ghes.c |    8 ++++++++
>  drivers/acpi/apei/hest.c |   17 +++++++++--------
>  include/acpi/apei.h      |    1 +
>  3 files changed, 18 insertions(+), 8 deletions(-)
> 
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -77,6 +77,9 @@ struct ghes {
>  	};
>  };
>  
> +int ghes_disable;
> +module_param_named(disable, ghes_disable, bool, 0);
> +
>  static int ghes_panic_timeout	__read_mostly = 30;
>  
>  /*
> @@ -665,6 +668,11 @@ static int __init ghes_init(void)
>  		return -EINVAL;
>  	}
>  
> +	if (ghes_disable) {
> +		pr_info(GHES_PFX "GHES is not enabled!\n");
> +		return -EINVAL;
> +	}
> +
>  	rc = ghes_ioremap_init();
>  	if (rc)
>  		goto err;
> --- a/drivers/acpi/apei/hest.c
> +++ b/drivers/acpi/apei/hest.c
> @@ -231,16 +231,17 @@ void __init acpi_hest_init(void)
>  		goto err;
>  	}
>  
> -	rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
> -	if (rc)
> -		goto err;
> -
> -	rc = hest_ghes_dev_register(ghes_count);
> -	if (!rc) {
> -		pr_info(HEST_PFX "Table parsing has been initialized.\n");
> -		return;
> +	if (!ghes_disable) {
> +		rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
> +		if (rc)
> +			goto err;
> +		rc = hest_ghes_dev_register(ghes_count);
> +		if (rc)
> +			goto err;
>  	}
>  
> +	pr_info(HEST_PFX "Table parsing has been initialized.\n");
> +	return;
>  err:
>  	hest_disable = 1;
>  }
> --- a/include/acpi/apei.h
> +++ b/include/acpi/apei.h
> @@ -18,6 +18,7 @@
>  
>  extern int hest_disable;
>  extern int erst_disable;
> +extern int ghes_disable;
>  
>  #ifdef CONFIG_ACPI_APEI
>  void __init acpi_hest_init(void);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
