Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2CEUeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:34:09 -0500
Received: from mxout1.idt.com ([157.165.5.25]:44620 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab2CEUeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:34:05 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, Chul Kim <chul.kim@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH] rapidio/tsi721: fix bug in inbound doorbell handler
Date: Mon,  5 Mar 2012 15:33:05 -0500
Message-Id: <1330979585-29429-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes queue wrapping bug in Inbound Doorbell handling routine.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
---
 This patch is applicable to kernel version 3.2 and after.

 drivers/rapidio/devices/tsi721.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index babbede..c746e26 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -406,13 +406,14 @@ static void tsi721_db_dpc(struct work_struct *work)
 	 */
 	mport = priv->mport;
 
-	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE));
-	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE));
+	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE)) % IDB_QSIZE;
+	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE)) % IDB_QSIZE;
 
 	while (wr_ptr != rd_ptr) {
 		idb_entry = (u64 *)(priv->idb_base +
 					(TSI721_IDB_ENTRY_SIZE * rd_ptr));
 		rd_ptr++;
+		rd_ptr %= IDB_QSIZE;
 		idb.msg = *idb_entry;
 		*idb_entry = 0;
 
-- 
1.7.8.4

