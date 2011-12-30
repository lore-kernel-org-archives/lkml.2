Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1L3CsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 21:48:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab1L3CsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 21:48:04 -0500
From: NeilBrown <neilb@suse.de>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Dec 2011 11:58:49 +1100
Subject: [PATCH 3/5] omap_hdq: use wait_event_timeout to wait for read to
 complete.
Message-ID: <20111230005849.11559.44661.stgit@notabene.brown>
In-Reply-To: <20111230004947.11559.81184.stgit@notabene.brown>
References: <20111230004947.11559.81184.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no gain in having a loop - there is no risk of missing the
interrupt with wait_event_timeout.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/w1/masters/omap_hdq.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 3036b61..848399b 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -354,7 +354,6 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 *val)
 {
 	int ret = 0;
 	u8 status;
-	unsigned long timeout = jiffies + OMAP_HDQ_TIMEOUT;
 
 	ret = mutex_lock_interruptible(&hdq_data->hdq_mutex);
 	if (ret < 0) {
@@ -372,15 +371,13 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 *val)
 			OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO,
 			OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO);
 		/*
-		 * The RX comes immediately after TX. It
-		 * triggers another interrupt before we
-		 * sleep. So we have to wait for RXCOMPLETE bit.
+		 * The RX comes immediately after TX.
 		 */
-		while (!(hdq_data->hdq_irqstatus
-			& OMAP_HDQ_INT_STATUS_RXCOMPLETE)
-			&& time_before(jiffies, timeout)) {
-			schedule_timeout_uninterruptible(1);
-		}
+		wait_event_timeout(hdq_wait_queue,
+				   (hdq_data->hdq_irqstatus
+				    & OMAP_HDQ_INT_STATUS_RXCOMPLETE),
+				   OMAP_HDQ_TIMEOUT);
+
 		hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS, 0,
 			OMAP_HDQ_CTRL_STATUS_DIR);
 		status = hdq_data->hdq_irqstatus;


