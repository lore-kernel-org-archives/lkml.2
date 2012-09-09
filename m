Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2IIXQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51294 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756061Ab2IIXQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:33 -0400
Message-Id: <20120909224200.923992454@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: [ 75/95] rapidio/tsi721: fix inbound doorbell interrupt handling
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Bounine <alexandre.bounine@idt.com>

commit 3670e7e12e582c6d67761275d148171feb7a9004 upstream.

Make sure that there is no doorbell messages left behind due to disabled
interrupts during inbound doorbell processing.

The most common case for this bug is loss of rionet JOIN messages in
systems with three or more rionet participants and MSI or MSI-X enabled.
As result, requests for packet transfers may finish with "destination
unreachable" error message.

This patch is applicable to kernel versions starting from v3.2.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rapidio/devices/tsi721.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 722246c..c0d6a04 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -435,6 +435,9 @@ static void tsi721_db_dpc(struct work_struct *work)
 				" info %4.4x\n", DBELL_SID(idb.bytes),
 				DBELL_TID(idb.bytes), DBELL_INF(idb.bytes));
 		}
+
+		wr_ptr = ioread32(priv->regs +
+				  TSI721_IDQ_WP(IDB_QUEUE)) % IDB_QSIZE;
 	}
 
 	iowrite32(rd_ptr & (IDB_QSIZE - 1),
@@ -445,6 +448,10 @@ static void tsi721_db_dpc(struct work_struct *work)
 	regval |= TSI721_SR_CHINT_IDBQRCV;
 	iowrite32(regval,
 		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
+
+	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE)) % IDB_QSIZE;
+	if (wr_ptr != rd_ptr)
+		schedule_work(&priv->idb_work);
 }
 
 /**


