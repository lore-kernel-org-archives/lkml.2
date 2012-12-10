Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2LJTO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:14:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55676 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024Ab2LJTM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:12:57 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
        james.hogan@imgtec.com, Matthew Leach <matthew@mattleach.net>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 06/10] net: 8390: use io{read,write}*_rep accessors
Date: Mon, 10 Dec 2012 19:12:38 +0000
Message-Id: <1355166762-15133-7-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
References: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew@mattleach.net>

The {read,write}s{b,w,l} operations are not defined by all
architectures and are being removed from the asm-generic/io.h
interface.

This patch replaces the usage of these string functions in the 8390
accessors with io{read,write}{8,16,32}_rep calls instead.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Matthew Leach <matthew@mattleach.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/net/ethernet/8390/ax88796.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index 203ff9d..0338352 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -191,11 +191,11 @@ static void ax_get_8390_hdr(struct net_device *dev, struct e8390_pkt_hdr *hdr,
 	ei_outb(E8390_RREAD+E8390_START, nic_base + NE_CMD);
 
 	if (ei_local->word16)
-		readsw(nic_base + NE_DATAPORT, hdr,
-		       sizeof(struct e8390_pkt_hdr) >> 1);
+		ioread16_rep(nic_base + NE_DATAPORT, hdr,
+			     sizeof(struct e8390_pkt_hdr) >> 1);
 	else
-		readsb(nic_base + NE_DATAPORT, hdr,
-		       sizeof(struct e8390_pkt_hdr));
+		ioread8_rep(nic_base + NE_DATAPORT, hdr,
+			    sizeof(struct e8390_pkt_hdr));
 
 	ei_outb(ENISR_RDC, nic_base + EN0_ISR);	/* Ack intr. */
 	ei_local->dmaing &= ~0x01;
@@ -237,12 +237,12 @@ static void ax_block_input(struct net_device *dev, int count,
 	ei_outb(E8390_RREAD+E8390_START, nic_base + NE_CMD);
 
 	if (ei_local->word16) {
-		readsw(nic_base + NE_DATAPORT, buf, count >> 1);
+		ioread16_rep(nic_base + NE_DATAPORT, buf, count >> 1);
 		if (count & 0x01)
 			buf[count-1] = ei_inb(nic_base + NE_DATAPORT);
 
 	} else {
-		readsb(nic_base + NE_DATAPORT, buf, count);
+		ioread8_rep(nic_base + NE_DATAPORT, buf, count);
 	}
 
 	ei_local->dmaing &= ~1;
@@ -286,9 +286,9 @@ static void ax_block_output(struct net_device *dev, int count,
 
 	ei_outb(E8390_RWRITE+E8390_START, nic_base + NE_CMD);
 	if (ei_local->word16)
-		writesw(nic_base + NE_DATAPORT, buf, count >> 1);
+		iowrite16_rep(nic_base + NE_DATAPORT, buf, count >> 1);
 	else
-		writesb(nic_base + NE_DATAPORT, buf, count);
+		iowrite8_rep(nic_base + NE_DATAPORT, buf, count);
 
 	dma_start = jiffies;
 
-- 
1.8.0

