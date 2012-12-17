Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2LQPiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:38:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab2LQPix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:38:53 -0500
Date: Mon, 17 Dec 2012 12:50:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Arvind R <arvino55@gmail.com>
Cc: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH 3.7.0 8/9] i82975x_edac: fix wrong offset reported
Message-ID: <20121217125001.2a886526@redhat.com>
In-Reply-To: <CAA_L+UPOe-2JQzXy7yCqnaoaQ3OQLSEDxV_6YgFGFkO_8SM3xg@mail.gmail.com>
References: <CAA_L+UPOe-2JQzXy7yCqnaoaQ3OQLSEDxV_6YgFGFkO_8SM3xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 16 Dec 2012 02:15:30 +0530
Arvind R <arvino55@gmail.com> escreveu:

> Subject: [PATCH 3.7.0 8/9] i82975x_edac: fix wrong offset reported
> 
> Cleanup error reporting function. This also corrects the wrong
> calculation of the offset mask.
> Signed-off-by: Arvind R. <arvino55@gmail.com>
> ---
>  i82975x_edac.c |   59 +++++++++++++++++-------------------------
>  1 file changed, 25 insertions(+), 34 deletions(-)
> 
> --- a/drivers/edac/i82975x_edac.c	2012-12-15 23:55:02.000000000 +0530
> +++ b/drivers/edac/i82975x_edac.c	2012-12-15 23:54:00.000000000 +0530
> @@ -34,6 +34,8 @@
>  #define	I82975X_NR_CSROWS_PER_CHANNEL	4
>  #define	I82975X_NR_CSROWS_PER_DIMM	2
> 
> +#define	I82975X_ECC_GRAIN	(1 << 7)
> +
>  /* Intel 82975X register addresses - device 0 function 0 - DRAM Controller */
>  #define I82975X_EAP		0x58	/* Dram Error Address Pointer (32b)
>  					 *
> @@ -205,6 +207,10 @@ NOTE: Only ONE of the three must be enab
>  #define I82975X_DRC_CH0M1		0x124
>  #define I82975X_DRC_CH1M1		0x1A4
> 
> +#define	I82975X_BIT_ERROR_CE	0x01
> +#define	I82975X_BIT_ERROR_UE	0x02
> +#define	I82975X_BITS_ERROR		0x03
> +
>  enum i82975x_chips {
>  	I82975X_chip = 0,
>  };
> @@ -239,7 +245,7 @@ static struct pci_dev *mci_pdev;	/* init
> 
>  static int i82975x_registered = 1;
> 
> -static void i82975x_get_error_info(struct mem_ctl_info *mci,
> +static bool i82975x_get_error_info(struct mem_ctl_info *mci,
>  		struct i82975x_error_info *info)
>  {
>  	struct pci_dev *pdev;
> @@ -258,7 +264,8 @@ static void i82975x_get_error_info(struc
>  	pci_read_config_byte(pdev, I82975X_DERRSYN, &info->derrsyn);
>  	pci_read_config_word(pdev, I82975X_ERRSTS, &info->errsts2);
> 
> -	pci_write_bits16(pdev, I82975X_ERRSTS, 0x0003, 0x0003);
> +	pci_write_bits16(pdev, I82975X_ERRSTS, I82975X_BITS_ERROR,
> +				I82975X_BITS_ERROR);
> 
>  	/*
>  	 * If the error is the same then we can for both reads then
> @@ -266,31 +273,30 @@ static void i82975x_get_error_info(struc
>  	 * there is a CE no info and the second set of reads is valid
>  	 * and should be UE info.
>  	 */
> -	if (!(info->errsts2 & 0x0003))
> -		return;
> +	if (!(info->errsts2 & I82975X_BITS_ERROR))
> +		return false;
> 
> -	if ((info->errsts ^ info->errsts2) & 0x0003) {
> +	if ((info->errsts ^ info->errsts2) & I82975X_BITS_ERROR) {
>  		pci_read_config_dword(pdev, I82975X_EAP, &info->eap);
>  		pci_read_config_byte(pdev, I82975X_XEAP, &info->xeap);
>  		pci_read_config_byte(pdev, I82975X_DES, &info->des);
>  		pci_read_config_byte(pdev, I82975X_DERRSYN,
>  				&info->derrsyn);
>  	}
> +	return true;
>  }
> 
>  static int i82975x_process_error_info(struct mem_ctl_info *mci,
>  		struct i82975x_error_info *info, int handle_errors)
>  {
> +	enum hw_event_mc_err_type err_type;
>  	int row, chan;
>  	unsigned long offst, page;
> 
> -	if (!(info->errsts2 & 0x0003))
> -		return 0;
> -
>  	if (!handle_errors)
>  		return 1;
> 
> -	if ((info->errsts ^ info->errsts2) & 0x0003) {
> +	if ((info->errsts ^ info->errsts2) & I82975X_BITS_ERROR) {
>  		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
>  				     -1, -1, -1, "UE overwrote CE", "");
>  		info->errsts = info->errsts2;
> @@ -302,30 +308,15 @@ static int i82975x_process_error_info(st
>  		page |= 0x80000000;
>  	page >>= (PAGE_SHIFT - 1);
>  	row = edac_mc_find_csrow_by_page(mci, page);
> +	chan = (mci->num_cschannel == 1) ? 0 : info->eap & 1;
> +	offst = info->eap & ((1 << PAGE_SHIFT) - I82975X_ECC_GRAIN);
> 
> -	if (row == -1)	{
> -		i82975x_mc_printk(mci, KERN_ERR, "error processing EAP:\n"
> -			"\tXEAP=%u\n"
> -			"\t EAP=0x%08x\n"
> -			"\tPAGE=0x%08x\n",
> -			(info->xeap & 1) ? 1 : 0, info->eap, (unsigned) page);
> -		return 0;
> -	}
> -	chan = (mci->csrows[row]->nr_channels == 1) ? 0 : info->eap & 1;
> -	offst = info->eap
> -			& ((1 << PAGE_SHIFT) -
> -			(1 << mci->csrows[row]->channels[chan]->dimm->grain));
> -
> -	if (info->errsts & 0x0002)
> -		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
> -				     page, offst, 0,
> -				     row, -1, -1,
> -				     "i82975x UE", "");
> -	else
> -		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
> +	err_type = (info->errsts & I82975X_BIT_ERROR_UE) ?
> +			HW_EVENT_ERR_UNCORRECTED : HW_EVENT_ERR_CORRECTED;
> +	edac_mc_handle_error(err_type, mci, 1,
>  				     page, offst, info->derrsyn,
> -				     row, chan ? chan : 0, -1,
> -				     "i82975x CE", "");
> +				     row, chan, -1,
> +				     "i82975x", "");
> 
>  	return 1;
>  }
> @@ -335,8 +326,8 @@ static void i82975x_check(struct mem_ctl
>  	struct i82975x_error_info info;
> 
>  	edac_dbg(4, "MC%d\n", mci->mc_idx);
> -	i82975x_get_error_info(mci, &info);
> -	i82975x_process_error_info(mci, &info, 1);
> +	if (i82975x_get_error_info(mci, &info))
> +		i82975x_process_error_info(mci, &info, 1);
>  }
> 
>  static void i82975x_init_csrows(struct mem_ctl_info *mci,
> @@ -398,7 +389,7 @@ static void i82975x_init_csrows(struct m
>  					chan) + 'A',
>  				 ((index % I82975X_NR_CSROWS_PER_CHANNEL) /
>  					I82975X_NR_CSROWS_PER_DIMM) + 1);
> -			dimm->grain = 1 << 7;	/* always */
> +			dimm->grain = I82975X_ECC_GRAIN;	/* always */

Hmm... I might be wrong, but on single-channel/dual asymmetric mode, the
grain is 64 instead of 128.

>  			dimm->dtype = DEV_X8;	/* only with ECC */
>  			dimm->mtype = MEM_DDR2; /* only supported */
>  			dimm->edac_mode = EDAC_SECDED; /* only supported */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
