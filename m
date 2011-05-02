Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1EBXLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:11:05 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1EBXJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:35 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsRn7030360@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 16:36:48 -0400
Subject: [PATCH] arch/tile: clarify flush_buffer()/finv_buffer() function names
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:27.0565 (UTC) FILETIME=[E3B049D0:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are only applicable for locally-homecached memory ranges, so
change their names to {flush,finv}_buffer_local().  Change inv_buffer()
to just do an mf instead of any kind of fancier barrier, since you're
obviously not going to be waiting for anything once the local homecache
is invalidated.

Fix tilepro.c network driver not to bother calling finv_buffer when
stopping the EPP, but just mf after memset to ensure that it will not
see any packet data after we finish stopping; use finv_buffer_remote()
when doing exit-time cleanup.

This also fixes a (not very interesting) generic Linux build failure
where drivers/scsi/st.c declares its own flush_buffer().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/cacheflush.h |   18 ++++++++++++------
 drivers/net/tile/tilepro.c         |    8 +++-----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
index 12fb0fb..e925f4b 100644
--- a/arch/tile/include/asm/cacheflush.h
+++ b/arch/tile/include/asm/cacheflush.h
@@ -116,22 +116,28 @@ static inline void __finv_buffer(void *buffer, size_t size)
 }
 
 
-/* Invalidate a VA range, then memory fence. */
+/* Invalidate a VA range and wait for it to be complete. */
 static inline void inv_buffer(void *buffer, size_t size)
 {
 	__inv_buffer(buffer, size);
-	mb_incoherent();
+	mb();
 }
 
-/* Flush a VA range, then memory fence. */
-static inline void flush_buffer(void *buffer, size_t size)
+/*
+ * Flush a locally-homecached VA range and wait for the evicted
+ * cachelines to hit memory.
+ */
+static inline void flush_buffer_local(void *buffer, size_t size)
 {
 	__flush_buffer(buffer, size);
 	mb_incoherent();
 }
 
-/* Flush & invalidate a VA range, then memory fence. */
-static inline void finv_buffer(void *buffer, size_t size)
+/*
+ * Flush and invalidate a locally-homecached VA range and wait for the
+ * evicted cachelines to hit memory.
+ */
+static inline void finv_buffer_local(void *buffer, size_t size)
 {
 	__finv_buffer(buffer, size);
 	mb_incoherent();
diff --git a/drivers/net/tile/tilepro.c b/drivers/net/tile/tilepro.c
index 0825db6..314f7e7 100644
--- a/drivers/net/tile/tilepro.c
+++ b/drivers/net/tile/tilepro.c
@@ -1658,11 +1658,9 @@ static int tile_net_stop(struct net_device *dev)
 	while (tile_net_lepp_free_comps(dev, true))
 		/* loop */;
 
-	/* Wipe the EPP queue. */
+	/* Wipe the EPP queue, and wait till the stores hit the EPP. */
 	memset(priv->eq, 0, sizeof(lepp_queue_t));
-
-	/* Evict the EPP queue. */
-	finv_buffer(priv->eq, EQ_SIZE);
+	mb();
 
 	return 0;
 }
@@ -2398,7 +2396,7 @@ static void tile_net_cleanup(void)
 			struct net_device *dev = tile_net_devs[i];
 			struct tile_net_priv *priv = netdev_priv(dev);
 			unregister_netdev(dev);
-			finv_buffer(priv->eq, EQ_SIZE);
+			finv_buffer_remote(priv->eq, EQ_SIZE, 0);
 			__free_pages(priv->eq_pages, EQ_ORDER);
 			free_netdev(dev);
 		}
-- 
1.6.5.2

