Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab1LIQXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:23:06 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53556 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1LIQXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:23:05 -0500
Date: Fri, 9 Dec 2011 17:22:54 +0100
From: Borislav Petkov <bp@amd64.org>
To: Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>
Cc: lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] edac: i5100 ack error detection register after each read
Message-ID: <20111209162254.GB14900@aftab>
References: <1323447135-25914-1-git-send-email-niklas.soderlund@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1323447135-25914-1-git-send-email-niklas.soderlund@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Tony.

On Fri, Dec 09, 2011 at 05:12:15PM +0100, Niklas Söderlund wrote:
> If I only ack the detection register after a error have been detected
> I'm unable to reliably detect errors. I have verified this behavior
> using both an error injection DIMM and software to inject errors.
> 
> I can't find any documentation supporting this behavior in Intel 5100
> Memory Controller Hub Chipset, see 1. So this is all based on
> experimentation.
> 
> [1] Intel® 5100 Memory Controller Hub Chipset
>     http://www.intel.com/content/dam/doc/datasheet/5100-
> 	memory-controller-hub-chipset-datasheet.pdf
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
> ---
>  drivers/edac/i5100_edac.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
> index bcbdeec..ec728e9 100644
> --- a/drivers/edac/i5100_edac.c
> +++ b/drivers/edac/i5100_edac.c
> @@ -535,23 +535,20 @@ static void i5100_read_log(struct mem_ctl_info *mci, int chan,
>  static void i5100_check_error(struct mem_ctl_info *mci)
>  {
>  	struct i5100_priv *priv = mci->pvt_info;
> -	u32 dw;
> -
> +	u32 dw, dw2;
>  
>  	pci_read_config_dword(priv->mc, I5100_FERR_NF_MEM, &dw);
>  	if (i5100_ferr_nf_mem_any(dw)) {
> -		u32 dw2;
>  
>  		pci_read_config_dword(priv->mc, I5100_NERR_NF_MEM, &dw2);
> -		if (dw2)
> -			pci_write_config_dword(priv->mc, I5100_NERR_NF_MEM,
> -					       dw2);
> -		pci_write_config_dword(priv->mc, I5100_FERR_NF_MEM, dw);
>  
>  		i5100_read_log(mci, i5100_ferr_nf_mem_chan_indx(dw),
>  			       i5100_ferr_nf_mem_any(dw),
>  			       i5100_nerr_nf_mem_any(dw2));
> +
> +		pci_write_config_dword(priv->mc, I5100_NERR_NF_MEM, dw2);
>  	}
> +	pci_write_config_dword(priv->mc, I5100_FERR_NF_MEM, dw);
>  }
>  
>  /* The i5100 chipset will scrub the entire memory once, then
> -- 
> 1.7.7.3
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
