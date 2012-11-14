Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423509Ab2KNWTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:19:05 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50041 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945910Ab2KNWTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:19:01 -0500
Date: Wed, 14 Nov 2012 16:18:26 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] char/tpm: simplify duration calculation and
 eliminate sparse warning.
Message-ID: <20121114221826.GC533@ennui.austin.ibm.com>
References: <1352759838-27175-1-git-send-email-peterhuewe@gmx.de>
 <1352759838-27175-2-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352759838-27175-2-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111422-5112-0000-0000-00000E929420
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 11:37:18PM +0100, Peter Huewe wrote:
> This patch changes the semantics of the duration calculation for an
> ordinal, by masking out the higher bits of a tpm command, which specify
> whether it's an TPM_PROTECTED_COMMAND, TPM_UNPROTECTED_COMMAND,
> TPM_CONNECTION_COMMAND, TPM_CONNECTION_COMMAND, TPM_VENDOR_COMMAND.
> (See TPM Main Spec Part 2 Section 17 for details).
> 
> For all TPM_PROTECTED and TPM_CONNECTION commands the results are
> unchanged.
> The TPM_UNPROTECTED commands are TSS commands and thus irrelevant as
> they are not sent to the tpm.
> For vendor commands the semantics change for ordinals 10 and 11 but
> they were probably wrong anyway.
> 
> For everything else which has the ordinal set to 10 or 11 the semantics
> change as it now uses TPM_UNDEFINED instead of TPM_SHORT which was
> probably wrong anyway (but irrelevant as not defined by the standard).
> 
> This patch also gets rid of the (false positive) sparse warning:
>  drivers/char/tpm/tpm.c:360 tpm_calc_ordinal_duration() error: buffer
>  overflow 'tpm_protected_ordinal_duration' 12 <= 243

  I'm not seeing this sparse warning, how did you get it?

Thanks,
Kent

> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/char/tpm/tpm.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 9e3c529..a455d11 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -40,8 +40,9 @@ enum tpm_duration {
>  };
> 
>  #define TPM_MAX_ORDINAL 243
> -#define TPM_MAX_PROTECTED_ORDINAL 12
> -#define TPM_PROTECTED_ORDINAL_MASK 0xFF
> +#define TCS_MAX_ORDINAL 12
> +#define TPM_PROTECTED_COMMAND 0x00
> +#define TPM_CONNECTION_COMMAND 0x40
> 
>  /*
>   * Bug workaround - some TPM's don't flush the most
> @@ -336,13 +337,11 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
>  {
>  	int duration_idx = TPM_UNDEFINED;
>  	int duration = 0;
> +	u8 category = (ordinal >> 24) & 0xFF;
> 
> -	if (ordinal < TPM_MAX_ORDINAL)
> +	if ((category == TPM_PROTECTED_COMMAND && ordinal < TPM_MAX_ORDINAL) ||
> +	    (category == TPM_CONNECTION_COMMAND && ordinal < TCS_MAX_ORDINAL))
>  		duration_idx = tpm_ordinal_duration[ordinal];
> -	else if ((ordinal & TPM_PROTECTED_ORDINAL_MASK) <
> -		 TPM_MAX_PROTECTED_ORDINAL)
> -		duration_idx =
> -		    tpm_ordinal_duration[ordinal & TPM_PROTECTED_ORDINAL_MASK];
> 
>  	if (duration_idx != TPM_UNDEFINED)
>  		duration = chip->vendor.duration[duration_idx];
> -- 
> 1.7.8.6
> 

