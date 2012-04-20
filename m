Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2DTU6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:58:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab2DTU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:56:27 -0400
From: mathieu.poirier@linaro.org
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 3/8] caif: include linux/io.h
Date: Fri, 20 Apr 2012 14:56:11 -0600
Message-Id: <1334955376-17793-4-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334955376-17793-1-git-send-email-mathieu.poirier@linaro.org>
References: <1334955376-17793-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The caif_shmcore requires io.h in order to use ioremap, so include that
explicitly to compile in all configurations.

Also add a note about the use of ioremap(), which is not a proper way
to map a DMA buffer into kernel space. It's not completely clear what
the intention is for using ioremap, but it is clear that the result
of ioremap must not simply be accessed using kernel pointers but
should use readl/writel or memcopy_{to,from}io. Assigning the result
of ioremap to a regular pointer that can also be set to something
else is not ok.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/net/caif/caif_shmcore.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/caif/caif_shmcore.c b/drivers/net/caif/caif_shmcore.c
index 5b20413..bc497d7 100644
--- a/drivers/net/caif/caif_shmcore.c
+++ b/drivers/net/caif/caif_shmcore.c
@@ -13,6 +13,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
+#include <linux/io.h>
 
 #include <net/caif/caif_device.h>
 #include <net/caif/caif_shm.h>
@@ -647,6 +648,9 @@ int caif_shmcore_probe(struct shmdev_layer *pshm_dev)
 		if (pshm_dev->shm_loopback)
 			tx_buf->desc_vptr = (unsigned char *)tx_buf->phy_addr;
 		else
+			/*
+			 * FIXME: the result of ioremap is not a pointer - arnd
+			 */
 			tx_buf->desc_vptr =
 					ioremap(tx_buf->phy_addr, TX_BUF_SZ);
 
-- 
1.7.5.4

