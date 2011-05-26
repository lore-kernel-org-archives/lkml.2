Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab1EZR4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:56:15 -0400
Received: from mail.solarflare.com ([216.237.3.220]:53023 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab1EZR4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:56:13 -0400
Subject: Re: [PATCH 2/6] unicore32: add pkunity-v3 mac/net driver (umal)
From: Ben Hutchings <bhutchings@solarflare.com>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        greg@kroah.com, netdev@vger.kernel.org
In-Reply-To: <556924396ee34f4af94a2f03767973f1cec35e22.1306408804.git.gxt@mprc.pku.edu.cn>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
	 <556924396ee34f4af94a2f03767973f1cec35e22.1306408804.git.gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Thu, 26 May 2011 10:56:09 -0700
Message-ID: <1306432569.17233.123.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2011 17:56:13.0264 (UTC) FILETIME=[33C4A500:01CC1BCE]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18160.004
X-TM-AS-Result: No--16.709500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 11:36 +0000, GuanXuetao wrote:
[...]
> --- /dev/null
> +++ b/drivers/net/mac-puv3.c
[...]
> +/**********************************************************************
> + *  Simple types
> + ********************************************************************* */
> +enum umal_speed {
> +	umal_speed_none = 0,
> +	umal_speed_10 = SPEED_10,
> +	umal_speed_100 = SPEED_100,
> +	umal_speed_1000 = SPEED_1000,
> +};

Just use the numbers directly: 0, 10, 100, 1000.

[...]
> +#define ETHER_ADDR_LEN		6

This is already called ETH_ALEN.

[...]
> +/**********************************************************************
> + *  DMA Descriptor structure
> + ********************************************************************* */
> +struct umaldmadscr {
> +	dma_addr_t   PacketStartAddr;
> +	int          PacketSize;
> +	dma_addr_t   NextDescriptor;
> +	struct umaldmadscr *NextDescriptor_Virt;
> +};

Linux naming convention for structure fields is words_with_underscores
not TitleCase.

[...]
> +/**********************************************************************
> + *  UMAL_MII_RESET(bus)
> + *
> + *  Reset MII bus.
> + *
> + *  Input parameters:
> + *	   bus     - MDIO bus handle
> + *
> + *  Return value:
> + *	   0 if ok
> + ********************************************************************* */

Function documentation comments must follow the kernel-doc format.

[...]
> +static int umaldma_add_rcvbuffer(struct umal_softc *sc, struct umaldma *d,
> +		struct sk_buff *sb)
> +{
[...]
> +	/*
> +	 * Allocate a sk_buff if we don't already have one.
> +	 * If we do have an sk_buff, reset it so that it's empty.
> +	 *
> +	 * Note: sk_buffs don't seem to be guaranteed to have any sort
> +	 * of alignment when they are allocated.  Therefore, allocate enough
> +	 * extra space to make sure that:
> +	 *
> +	 *    1. the data does not start in the middle of a cache line.
> +	 *    2. The data does not end in the middle of a cache line
> +	 *    3. The buffer can be aligned such that the IP addresses are
> +	 *       naturally aligned.
> +	 *
> +	 *  Remember, the SOCs MAC writes whole cache lines at a time,
> +	 *  without reading the old contents first.  So, if the sk_buff's
> +	 *  data portion starts in the middle of a cache line, the SOC
> +	 *  DMA will trash the beginning (and ending) portions.
> +	 */
> +	if (sb == NULL) {
> +		sb_new = netdev_alloc_skb(dev, ENET_PACKET_SIZE +
> +		       SMP_CACHE_BYTES * 2 + NET_IP_ALIGN);
> +		if (sb_new == NULL) {
> +			pr_info("%s: sk_buff allocation failed\n",
> +			       d->umaldma_eth->umal_dev->name);
> +			return -ENOBUFS;

Surely -ENOMEM.

> +		}
> +		skb_reserve(sb_new, 2);

This presumably needs to be:

		skb_reserve(sb_new, SMP_CACHE_BYTES + NET_IP_ALIGN);

unless you assume that the skb allocator will always ensure cache line
alignment (in which case, why use padding of SMP_CACHE_BYTES * 2?).

[...]
> +static void umaldma_tx_process(struct umal_softc *sc, struct umaldma *d,
> +		int poll)
> +{
> +	struct net_device *dev = sc->umal_dev;
> +	int curidx;
> +	int hwidx;
> +	struct umaldmadscr *dsc;
> +	struct sk_buff *sb;
> +	unsigned long flags;
> +	int packets_handled = 0;
> +	unsigned int int_status;
> +
> +	spin_lock_irqsave(&(sc->umal_lock), flags);
> +
> +	if (!netif_device_present(dev))
> +		return;
[...]

This returns with the lock held!

(This is not by any means a thorough review.)

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

