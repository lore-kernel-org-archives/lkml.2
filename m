Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab1JOVKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:10:33 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50047 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab1JOVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:10:31 -0400
X-Sasl-enc: wCgrkjr6MlUvrlptTlklF8W1sFX0ejyoEqDt+U+Rmljk 1318713029
Message-ID: <4E99F69F.1080701@ladisch.de>
Date: Sat, 15 Oct 2011 23:09:51 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dma-mapping: fix sync_single_range_* DMA debugging
References: <4DC960B2.40406@ladisch.de>	<20110510203826.17d1ad91@stein>	<4DCAAEFF.8060907@ladisch.de>	<20110517223618.43633eee@stein>	<4DD36B16.6040802@ladisch.de>	<4E920ABE.8070100@ladisch.de>	<20111015171523.434f47c8@stein> <4E99E92B.6020408@ladisch.de>
In-Reply-To: <4E99E92B.6020408@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5fd75a7850b5 (dma-mapping: remove unnecessary sync_single_range_*
in dma_map_ops) unified not only the dma_map_ops but also the
corresponding debug_dma_sync_* calls.  This led to spurious WARN()ings
like the following because the DMA debug code was no longer able to
detect the DMA buffer base address without the separate offset parameter:

WARNING: at lib/dma-debug.c:911 check_sync+0xce/0x446()
firewire_ohci 0000:04:00.0: DMA-API: device driver tries to sync DMA memory it has not allocated [device address=0x00000000cedaa400] [size=1024 bytes]
Call Trace: ...
 [<ffffffff811326a5>] check_sync+0xce/0x446
 [<ffffffff81132ad9>] debug_dma_sync_single_for_device+0x39/0x3b
 [<ffffffffa01d6e6a>] ohci_queue_iso+0x4f3/0x77d [firewire_ohci]
 ...

To fix this, unshare the sync_single_* and sync_single_range_*
implementations so that we are able to call the correct debug_dma_sync_*
functions.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 include/asm-generic/dma-mapping-common.h |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 0c80bb3..9e31514 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -123,7 +123,12 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	dma_sync_single_for_cpu(dev, addr + offset, size, dir);
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_single_for_cpu)
+		ops->sync_single_for_cpu(dev, addr + offset, size, dir);
+	debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 }

 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -132,7 +137,12 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 						    size_t size,
 						    enum dma_data_direction dir)
 {
-	dma_sync_single_for_device(dev, addr + offset, size, dir);
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_single_for_device)
+		ops->sync_single_for_device(dev, addr + offset, size, dir);
+	debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 }

 static inline void
