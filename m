Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946556Ab2CPXxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:53:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946192Ab2CPXjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:15 -0400
Message-Id: <20120316233450.214169591@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 33/38] sfc: Fix assignment of ip_summed for pre-allocated skbs
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit ff3bc1e7527504a93710535611b2f812f3bb89bf upstream.

When pre-allocating skbs for received packets, we set ip_summed =
CHECKSUM_UNNCESSARY.  We used to change it back to CHECKSUM_NONE when
the received packet had an incorrect checksum or unhandled protocol.

Commit bc8acf2c8c3e43fcc192762a9f964b3e9a17748b ('drivers/net: avoid
some skb->ip_summed initializations') mistakenly replaced the latter
assignment with a DEBUG-only assertion that ip_summed ==
CHECKSUM_NONE.  This assertion is always false, but it seems no-one
has exercised this code path in a DEBUG build.

Fix this by moving our assignment of CHECKSUM_UNNECESSARY into
efx_rx_packet_gro().

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sfc/rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/sfc/rx.c
+++ b/drivers/net/sfc/rx.c
@@ -155,11 +155,10 @@ static int efx_init_rx_buffers_skb(struc
 		if (unlikely(!skb))
 			return -ENOMEM;
 
-		/* Adjust the SKB for padding and checksum */
+		/* Adjust the SKB for padding */
 		skb_reserve(skb, NET_IP_ALIGN);
 		rx_buf->len = skb_len - NET_IP_ALIGN;
 		rx_buf->is_page = false;
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 		rx_buf->dma_addr = pci_map_single(efx->pci_dev,
 						  skb->data, rx_buf->len,
@@ -498,6 +497,7 @@ static void efx_rx_packet_gro(struct efx
 
 		EFX_BUG_ON_PARANOID(!checksummed);
 		rx_buf->u.skb = NULL;
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 		gro_result = napi_gro_receive(napi, skb);
 	}


