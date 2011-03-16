Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1CPV0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:26:14 -0400
Received: from kroah.org ([198.145.64.141]:42652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1CPVL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/50] drivers:misc: ti-st: fix hci-ll on wake_ind collision
Date: Wed, 16 Mar 2011 14:11:04 -0700
Message-Id: <1300309888-5028-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Where file-transfer stops/pauses in between, is
result of a HCI-LL anamoly in ST LL driver.
ST LL did not copy the contents of WaitQ into the TxQ, when a WAKEUP_IND
collision happened.
Make also sure, that the copying mechanism is safe, by wrapping it around
spin locks inside st_int_recv().
This was easily reproduced when the sleep timeout was reduced to 100ms
for HCI-LL.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/st_core.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index dd2c879..f0d24d8 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -236,6 +236,7 @@ void st_int_recv(void *disc_data,
 	int len = 0, type = 0;
 	unsigned char *plen;
 	struct st_data_s *st_gdata = (struct st_data_s *)disc_data;
+	unsigned long flags;
 
 	ptr = (char *)data;
 	/* tty_receive sent null ? */
@@ -248,6 +249,7 @@ void st_int_recv(void *disc_data,
 		   "rx_count %ld", count, st_gdata->rx_state,
 		   st_gdata->rx_count);
 
+	spin_lock_irqsave(&st_gdata->lock, flags);
 	/* Decode received bytes here */
 	while (count) {
 		if (st_gdata->rx_count) {
@@ -308,13 +310,25 @@ void st_int_recv(void *disc_data,
 			 * sleep state received --
 			 */
 			st_ll_sleep_state(st_gdata, *ptr);
+			/* if WAKEUP_IND collides copy from waitq to txq
+			 * and assume chip awake
+			 */
+			spin_unlock_irqrestore(&st_gdata->lock, flags);
+			if (st_ll_getstate(st_gdata) == ST_LL_AWAKE)
+				st_wakeup_ack(st_gdata, LL_WAKE_UP_ACK);
+			spin_lock_irqsave(&st_gdata->lock, flags);
+
 			ptr++;
 			count--;
 			continue;
 		case LL_WAKE_UP_ACK:
 			pr_debug("PM packet");
+
+			spin_unlock_irqrestore(&st_gdata->lock, flags);
 			/* wake up ack received */
 			st_wakeup_ack(st_gdata, *ptr);
+			spin_lock_irqsave(&st_gdata->lock, flags);
+
 			ptr++;
 			count--;
 			continue;
@@ -337,6 +351,7 @@ void st_int_recv(void *disc_data,
 		ptr++;
 		count--;
 	}
+	spin_unlock_irqrestore(&st_gdata->lock, flags);
 	pr_debug("done %s", __func__);
 	return;
 }
-- 
1.7.4.1

