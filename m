Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030700Ab2CITrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:47:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030680Ab2CITrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:40 -0500
Message-Id: <20120309190205.565991711@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Chul Kim <chul.kim@idt.com>, Matt Porter <mporter@kernel.crashing.org>
Subject: [ 40/95] rapidio/tsi721: fix queue wrapping bug in inbound doorbell handler
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Bounine <alexandre.bounine@idt.com>

commit b24823e61bfd93d0e72088e4f5245287582ed289 upstream.

Fix a bug that causes a kernel panic when the number of received doorbells
is larger than number of entries in the inbound doorbell queue (current
default value = 512).

Another possible indication for this bug is large number of spurious
doorbells reported by tsi721 driver after reaching the queue size maximum.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rapidio/devices/tsi721.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -410,13 +410,14 @@ static void tsi721_db_dpc(struct work_st
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
 


