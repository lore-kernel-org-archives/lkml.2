Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1BQPru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:47:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:52801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab1BQPrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:47:47 -0500
Date: Thu, 17 Feb 2011 16:47:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arvind R <arvino55@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37 3/4] edac: correct i82975x error-info reported to
 edac-core
In-Reply-To: <AANLkTimA+mnX0MLcwVkeRfbrJfx9T+O8CxrZQ=wFef+u@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1102171647050.2160@pobox.suse.cz>
References: <AANLkTimA+mnX0MLcwVkeRfbrJfx9T+O8CxrZQ=wFef+u@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Arvind R wrote:

> Subject: [PATCH 2.6.37 3/4] edac: correct i82975x error-info reported
> to edac-core
> 
> fix the totally wrong info w.r.t page,row,dimm-label previously reported to
> edac-core by i82975x driver
> 
> Signed-off-by: Arvind R. <arvino55@gmail.com>
> ---
>  i82975x_edac.c |   53 +++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 37 insertions(+), 16 deletions(-)
> ---
> diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
> --- a/drivers/edac/i82975x_edac.c
> +++ b/drivers/edac/i82975x_edac.c
> @@ -278,6 +278,7 @@ static int i82975x_process_error_info(st
>  		struct i82975x_error_info *info, int handle_errors)
>  {
>  	int row, multi_chan, chan;
> +	unsigned long offst, page;
> 
>  	multi_chan = mci->csrows[0].nr_channels - 1;
> 
> @@ -292,17 +293,19 @@ static int i82975x_process_error_info(st
>  		info->errsts = info->errsts2;
>  	}
> 
> -	chan = info->eap & 1;
> -	info->eap >>= 1;
> -	if (info->xeap )
> -		info->eap |= 0x80000000;
> -	info->eap >>= PAGE_SHIFT;
> -	row = edac_mc_find_csrow_by_page(mci, info->eap);
> +	page = (unsigned long) info->eap;
> +	if (info->xeap & 1)
> +		page |= 0x100000000ul;
> +	chan = page & 1;
> +	page >>= 1;
> +	offst = page & ((1 << PAGE_SHIFT) - 1);
> +	page >>= PAGE_SHIFT;
> +	row = edac_mc_find_csrow_by_page(mci, page);
> 
>  	if (info->errsts & 0x0002)
> -		edac_mc_handle_ue(mci, info->eap, 0, row, "i82975x UE");
> +		edac_mc_handle_ue(mci, page, offst , row, "i82975x UE");
>  	else
> -		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row,
> +		edac_mc_handle_ce(mci, page, offst, info->derrsyn, row,
>  				multi_chan ? chan : 0,
>  				"i82975x CE");
> 
> @@ -352,11 +355,15 @@ static enum dev_type i82975x_dram_type(v
>  static void i82975x_init_csrows(struct mem_ctl_info *mci,
>  		struct pci_dev *pdev, void __iomem *mch_window)
>  {
> +	static const char *labels[4] = {
> +							"DIMM A1", "DIMM A2",
> +							"DIMM B1", "DIMM B2"
> +						};
>  	struct csrow_info *csrow;
>  	unsigned long last_cumul_size;
>  	u8 value;
>  	u32 cumul_size;
> -	int index;
> +	int index, chan;
> 
>  	last_cumul_size = 0;
> 
> @@ -365,11 +372,7 @@ static void i82975x_init_csrows(struct m
>  	 * The dram row boundary (DRB) reg values are boundary address
>  	 * for each DRAM row with a granularity of 32 or 64MB (single/dual
>  	 * channel operation).  DRB regs are cumulative; therefore DRB7 will
> -	 * contain the total memory contained in all eight rows.
> -	 *
> -	 * FIXME:
> -	 *  EDAC currently works for Dual-channel Interleaved configuration.
> -	 *  Other configurations, which the chip supports, need fixing/testing.
> +	 * contain the total memory contained in all rows.
>  	 *
>  	 */
> 
> @@ -380,8 +383,26 @@ static void i82975x_init_csrows(struct m
>  					((index >= 4) ? 0x80 : 0));
>  		cumul_size = value;
>  		cumul_size <<= (I82975X_DRB_SHIFT - PAGE_SHIFT);
> +		/*
> +		 * Adjust cumul_size w.r.t number of channels
> +		 *
> +		 */
> +		if (csrow->nr_channels > 1)
> +			cumul_size <<= 1;
>  		debugf3("%s(): (%d) cumul_size 0x%x\n", __func__, index,
>  			cumul_size);
> +
> +		/*
> +		 * Initialise dram labels
> +		 * index values:
> +		 *   [0-7] for single-channel; i.e. csrow->nr_channels = 1
> +		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
> +		 */
> +		for (chan = 0; chan < csrow->nr_channels; chan++)
> +			strncpy(csrow->channels[chan].label,
> +					labels[(index >> 1) + (chan * 2)],
> +					EDAC_MC_LABEL_LEN);
> +
>  		if (cumul_size == last_cumul_size)
>  			continue;	/* not populated */
> 
> @@ -389,8 +410,8 @@ static void i82975x_init_csrows(struct m
>  		csrow->last_page = cumul_size - 1;
>  		csrow->nr_pages = cumul_size - last_cumul_size;
>  		last_cumul_size = cumul_size;
> -		csrow->grain = 1 << 7;	/* I82975X_EAP has 128B resolution */
> -		csrow->mtype = MEM_DDR; /* i82975x supports only DDR2 */
> +		csrow->grain = 1 << 6;	/* I82975X_EAP has 64B resolution */
> +		csrow->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
>  		csrow->dtype = i82975x_dram_type(mch_window, index);
>  		csrow->edac_mode = EDAC_SECDED; /* only supported */
>  	}

Applied, thanks Arvind.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
