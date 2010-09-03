Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0ICCYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:24:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:33701 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab0ICCYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:24:54 -0400
Date: Fri, 3 Sep 2010 11:23:53 +0900
To: masa-korg@dsn.okisemi.com
Cc: shemminger@vyatta.com, sam@ravnborg.org, joe@perches.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        gregory.v.rose@intel.com, mbizon@freebox.fr, kristoffer@gaisler.com,
        ralf@linux-mips.org, john.linn@xilinx.com, randy.dunlap@oracle.com,
        davem@davemloft.net, meego-dev@meego.com, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, margie.foster@intel.com,
        okada533@dsn.okisemi.com, morinaga526@dsn.okisemi.com,
        shimizu394@dsn.okisemi.com
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C7D0E7A.5060309@dsn.okisemi.com>
References: <4C763A67.5040107@dsn.okisemi.com>
	<4C7D0E7A.5060309@dsn.okisemi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100903112248Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Sep 2010 11:23:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010 23:15:22 +0900
Masayuki Ohtake <masa-korg@dsn.okisemi.com> wrote:

> Gigabit Ethernet driver of Topcliff PCH
> Patch created against 2.6.35
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. 
> Topcliff PCH has Gigabit Ethernet I/F. Using this I/F, it is able to 
> access system devices connected to Gigabit Ethernet.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---
>  drivers/net/Kconfig                   |   10 +
>  drivers/net/Makefile                  |    1 +
>  drivers/net/pch_gbe/Makefile          |    4 +
>  drivers/net/pch_gbe/pch_gbe.h         |  683 +++++++++
>  drivers/net/pch_gbe/pch_gbe_api.c     |  246 ++++
>  drivers/net/pch_gbe/pch_gbe_api.h     |   34 +
>  drivers/net/pch_gbe/pch_gbe_ethtool.c |  618 ++++++++
>  drivers/net/pch_gbe/pch_gbe_main.c    | 2591 +++++++++++++++++++++++++++++++++
>  drivers/net/pch_gbe/pch_gbe_param.c   |  519 +++++++
>  drivers/net/pch_gbe/pch_gbe_phy.c     |  276 ++++
>  drivers/net/pch_gbe/pch_gbe_phy.h     |   35 +
>  11 files changed, 5017 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/pch_gbe/Makefile
>  create mode 100644 drivers/net/pch_gbe/pch_gbe.h
>  create mode 100644 drivers/net/pch_gbe/pch_gbe_api.c
>  create mode 100644 drivers/net/pch_gbe/pch_gbe_api.h
>  create mode 100644 drivers/net/pch_gbe/pch_gbe_ethtool.c
>  create mode 100644 drivers/net/pch_gbe/pch_gbe_main.c
>  create mode 100644 drivers/net/pch_gbe/pch_gbe_param.c
>  create mode 100644 drivers/net/pch_gbe/pch_gbe_phy.c
>  create mode 100644 drivers/net/pch_gbe/pch_gbe_phy.h

(snip)

> +/**
> + * pch_gbe_unmap_and_free_rx_resource - Unmap and free rx socket buffer
> + * @adapter:      Board private structure
> + * @buffer_info:  Buffer information structure
> + */
> +static void pch_gbe_unmap_and_free_rx_resource(
> +					struct pch_gbe_adapter *adapter,
> +					struct pch_gbe_buffer *buffer_info)
> +{
> +	if (buffer_info->dma) {
> +		pci_unmap_single(adapter->pdev, buffer_info->dma,
> +				 buffer_info->length, PCI_DMA_FROMDEVICE);
> +		buffer_info->dma = 0;

Probably, this trick doesn't work because zero could be a valid DMA
address on some architctures.


> +	/*-- Set Buffer infomation --*/
> +	buffer_info->length = skb->len;
> +	buffer_info->dma =
> +	    pci_map_single(adapter->pdev, skb->data, buffer_info->length,
> +			   PCI_DMA_TODEVICE);

Needs to handle mapping failure (dma_mapping_errro)?

I found the same problems in other places.


Can you use dma_map_* API instead of pci_map_*? Please read:

Documentation/DMA-API.txt
Documentation/DMA-API-HOWTO.txt


Thanks,
