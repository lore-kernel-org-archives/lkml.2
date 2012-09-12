Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab2ILXj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:39:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab2ILXjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:39:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 51/85] rapidio/tsi721: fix inbound doorbell interrupt handling
Date: Wed, 12 Sep 2012 16:36:34 -0700
Message-Id: <20120912233547.083807018@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rapidio/devices/tsi721.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -439,6 +439,9 @@ static void tsi721_db_dpc(struct work_st
 				" info %4.4x\n", DBELL_SID(idb.bytes),
 				DBELL_TID(idb.bytes), DBELL_INF(idb.bytes));
 		}
+
+		wr_ptr = ioread32(priv->regs +
+				  TSI721_IDQ_WP(IDB_QUEUE)) % IDB_QSIZE;
 	}
 
 	iowrite32(rd_ptr & (IDB_QSIZE - 1),
@@ -449,6 +452,10 @@ static void tsi721_db_dpc(struct work_st
 	regval |= TSI721_SR_CHINT_IDBQRCV;
 	iowrite32(regval,
 		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
+
+	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE)) % IDB_QSIZE;
+	if (wr_ptr != rd_ptr)
+		schedule_work(&priv->idb_work);
 }
 
 /**


