Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2HGLJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:09:50 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:59282 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2HGLJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:09:49 -0400
Date: Tue, 7 Aug 2012 20:09:05 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: bhutchings@solarflare.com, grundler@parisc-linux.org, arnd@arndb.de,
        benh@kernel.crashing.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 1/5] sfc: Use standard __{clear,set}_bit_le() functions
Message-Id: <20120807200905.b66b712b.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120807200759.26ca8faa.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120807200759.26ca8faa.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

There are now standard functions for dealing with little-endian bit
arrays, so use them instead of our own implementations.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 drivers/net/ethernet/sfc/efx.c        |    4 ++--
 drivers/net/ethernet/sfc/net_driver.h |   12 ------------
 drivers/net/ethernet/sfc/nic.c        |    4 ++--
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 65a8d49..7ceac47 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1981,14 +1981,14 @@ static void efx_set_rx_mode(struct net_device *net_dev)
 		netdev_for_each_mc_addr(ha, net_dev) {
 			crc = ether_crc_le(ETH_ALEN, ha->addr);
 			bit = crc & (EFX_MCAST_HASH_ENTRIES - 1);
-			set_bit_le(bit, mc_hash->byte);
+			__set_bit_le(bit, mc_hash);
 		}
 
 		/* Broadcast packets go through the multicast hash filter.
 		 * ether_crc_le() of the broadcast address is 0xbe2612ff
 		 * so we always add bit 0xff to the mask.
 		 */
-		set_bit_le(0xff, mc_hash->byte);
+		__set_bit_le(0xff, mc_hash);
 	}
 
 	if (efx->port_enabled)
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index cd9c0a9..406ea85 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1083,18 +1083,6 @@ static inline struct efx_rx_buffer *efx_rx_buffer(struct efx_rx_queue *rx_queue,
 	return &rx_queue->buffer[index];
 }
 
-/* Set bit in a little-endian bitfield */
-static inline void set_bit_le(unsigned nr, unsigned char *addr)
-{
-	addr[nr / 8] |= (1 << (nr % 8));
-}
-
-/* Clear bit in a little-endian bitfield */
-static inline void clear_bit_le(unsigned nr, unsigned char *addr)
-{
-	addr[nr / 8] &= ~(1 << (nr % 8));
-}
-
 
 /**
  * EFX_MAX_FRAME_LEN - calculate maximum frame length
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index 326d799..d358966 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -470,9 +470,9 @@ void efx_nic_init_tx(struct efx_tx_queue *tx_queue)
 
 		efx_reado(efx, &reg, FR_AA_TX_CHKSM_CFG);
 		if (tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD)
-			clear_bit_le(tx_queue->queue, (void *)&reg);
+			__clear_bit_le(tx_queue->queue, &reg);
 		else
-			set_bit_le(tx_queue->queue, (void *)&reg);
+			__set_bit_le(tx_queue->queue, &reg);
 		efx_writeo(efx, &reg, FR_AA_TX_CHKSM_CFG);
 	}
 
-- 
1.7.5.4

