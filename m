Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2FRTTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:19:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2FRTTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:19:01 -0400
Date: Mon, 18 Jun 2012 16:18:53 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 39/69] iwlwifi: disable the buggy chain extension feature in HW
Message-ID: <20120618191853.GB3263@herton-Z68MA-D2H-B3>
References: <20120617175941.281333656@decadent.org.uk>
 <20120617175946.829354534@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120617175946.829354534@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 07:00:20PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> commit d012d04e4d6312ea157b6cf19e9689af934f5aa7 upstream.
> 
> This feature has been reported to be buggy and enabled by
> default. We therefore need to disable it manually.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/wireless/iwlwifi/iwl-prph.h       |    1 +
>  drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 +++++
>  2 files changed, 6 insertions(+)
> 
> --- a/drivers/net/wireless/iwlwifi/iwl-prph.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
> @@ -228,6 +228,7 @@
>  #define SCD_TXFACT		(SCD_BASE + 0x10)
>  #define SCD_ACTIVE		(SCD_BASE + 0x14)
>  #define SCD_QUEUECHAIN_SEL	(SCD_BASE + 0xe8)
> +#define SCD_CHAINEXT_EN		(SCD_BASE + 0x244)
>  #define SCD_AGGR_SEL		(SCD_BASE + 0x248)
>  #define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
>  
> --- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
> @@ -868,6 +868,11 @@
>  	iwl_write_prph(bus(trans), SCD_DRAM_BASE_ADDR,
>  		       trans_pcie->scd_bc_tbls.dma >> 10);
>  
> +	/* The chain extension of the SCD doesn't work well. This feature is
> +	 * enabled by default by the HW, so we need to disable it manually.
> +	 */
> +	iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
> +

Hi, this triggers the following build warning:
linux-stable/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c: In function 'iwl_trans_pcie_tx_start':
linux-stable/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:874:2: warning: passing argument 1 of 'iwl_write_prph' from incompatible pointer type [enabled by default]
linux-stable/drivers/net/wireless/iwlwifi/iwl-io.h:72:6: note: expected 'struct iwl_bus *' but argument is of type 'struct iwl_trans *'

For 3.2, it should be passed as bus(trans) as other invocations.

>  	/* Enable DMA channel */
>  	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
>  		iwl_write_direct32(bus(trans), FH_TCSR_CHNL_TX_CONFIG_REG(chan),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
