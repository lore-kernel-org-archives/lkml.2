Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1JPQ6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 12:58:35 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:43948 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab1JPQ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 12:58:34 -0400
Date: Sun, 16 Oct 2011 18:55:40 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: et131x: Convert rest of pci memory management to dma api
Message-ID: <20111016165540.GA8761@electric-eye.fr.zoreil.com>
References: <1318766775-2517-1-git-send-email-mark.einon@gmail.com> <1318766775-2517-3-git-send-email-mark.einon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318766775-2517-3-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Einon <mark.einon@gmail.com> :
> Replaced pci map/unmap and set_mask calls with their dma equivalents.
> Also updated comments to reflect this.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> ---
>  drivers/staging/et131x/et131x.c |   56 +++++++++++++++++++-------------------
>  1 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index 993f93a..1c11dfd 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
> @@ -3202,59 +3202,59 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
[...]
>  				desc[frag++].addr_lo =
> -				    pci_map_single(adapter->pdev,
> +				    dma_map_single(&adapter->pdev->dev,
>  						   skb->data,
>  						   skb->len -
>  						   skb->data_len,
> -						   PCI_DMA_TODEVICE);
> +						   DMA_TO_DEVICE);
>  			} else {

- Some dma_mapping_error() would be welcome.

- (nit) If you keep repeating &adapter->pdev->dev, you may consider adding
  some local variable

- could you rework the Tx path as well so that despite the cascade of
  method the code does not end fighting for the right end of the screen ?
  et131x_tx is almost empty. It could make some sense to merge it with
  its callee (and rename it et131x_start_xmit ?).

- nic_send_packet
        for (i = 0; i < nr_frags; i++) {
		[...comment..]
                if (i == 0) {

  Lovely...

			[big block]
		} else {
			[small block]
		}

  ... really, really lovely.

	}

[...]
>  				/* NOTE: Here, the dma_addr_t returned from
> -				 * pci_map_single() is implicitly cast as a
> +				 * dma_map_single() is implicitly cast as a
>  				 * u32. Although dma_addr_t can be
>  				 * 64-bit, the address returned by
> -				 * pci_map_single() is always 32-bit
> +				 * dma_map_single() is always 32-bit
>  				 * addressable (as defined by the pci/dma
>  				 * subsystem)
>  				 */
>  				desc[frag++].addr_lo =
[...]
>  				desc[frag].addr_hi = 0;

- The NOTE seems a bit outdated. Afaiks the driver tries to set a 64 bits
  wide DMA mask. Both addr_lo and addr_hi should be set with the returned
  mapping and/or even replaced with a single 64 bits addr field in tx_desc.

- Speaking of it, tx_desc probably lacks some __leXY annotations.

- (nic_send_packet)
  {
        u32 i;
        struct tx_desc desc[24];        /* 24 x 16 byte */

  384 bytes. :o/

-- 
Ueimor
