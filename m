Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab2EUXob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:44:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2EUXo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:44:28 -0400
From: NeilBrown <neilb@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 22 May 2012 09:43:02 +1000
Subject: [PATCH 2/2] omap_hdq: use wait_event_timeout to wait for read to
 complete.
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Message-ID: <20120521234302.13661.65956.stgit@notabene.brown>
In-Reply-To: <20120521234241.13661.59150.stgit@notabene.brown>
References: <20120521234241.13661.59150.stgit@notabene.brown>
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
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---

 drivers/w1/masters/omap_hdq.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

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


