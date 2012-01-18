Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2ARLVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:21:36 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:44450 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2ARLVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:21:35 -0500
Date: Wed, 18 Jan 2012 09:19:46 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-pm@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] tpm: fix (ACPI S3) suspend regression
Message-ID: <20120118111946.GA3772@hardened-box.br.ibm.com>
References: <1326856050.32259.4.camel@d941e-10>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326856050.32259.4.camel@d941e-10>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011811-8936-0000-0000-000005A8A39F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stefan,

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

On Tue, 17 Jan 2012, Stefan Berger wrote:

> This patch fixes an (ACPI S3) suspend regression introduced in commit
> 68d6e6713fcb2ea6278661aaaf5f1c9c821b3751 and occurring with an Infineon
> TPM and tpm_tis and tpm_infineon drivers active. Further, the suspend problem
> occurred if the TPM was disabled and/or deactivated and therefore the
> TPM_PCRRead checking the result of the (asynchronous) self test returned
> an error code which then caused the tpm_tis driver to become inactive and
> this then seemed to have negatively influenced the suspend support by the
> tpm_infineon driver...
> Besides that the tpm_tis drive may stay active even if the TPM is disabled
> and/or deactivated.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ---
>  drivers/char/tpm/tpm.c |    9 +++++++++
>  drivers/char/tpm/tpm.h |    3 +++
>  2 files changed, 12 insertions(+)
> 
> Index: linux-2.6/drivers/char/tpm/tpm.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm.c
> +++ linux-2.6/drivers/char/tpm/tpm.c
> @@ -846,6 +846,15 @@ int tpm_do_selftest(struct tpm_chip *chi
> 
>  	do {
>  		rc = __tpm_pcr_read(chip, 0, digest);
> +		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
> +			dev_info(chip->dev,
> +				 "TPM is disabled/deactivated (0x%X)\n", rc);
> +			/* TPM is disabled and/or deactivated; driver can
> +			 * proceed and TPM does handle commands for
> +			 * suspend/resume correctly
> +			 */
> +			return 0;
> +		}
>  		if (rc != TPM_WARN_DOING_SELFTEST)
>  			return rc;
>  		msleep(delay_msec);
> Index: linux-2.6/drivers/char/tpm/tpm.h
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm.h
> +++ linux-2.6/drivers/char/tpm/tpm.h
> @@ -39,6 +39,9 @@ enum tpm_addr {
>  };
> 
>  #define TPM_WARN_DOING_SELFTEST 0x802
> +#define TPM_ERR_DEACTIVATED     0x6
> +#define TPM_ERR_DISABLED        0x7
> +
>  #define TPM_HEADER_SIZE		10
>  extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
>  				char *);
> 
> 

-- 
Rajiv Andrade
Security Development
IBM Linux Technology Center

