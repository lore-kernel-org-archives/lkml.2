Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1L3CsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 21:48:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab1L3CsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 21:48:11 -0500
From: NeilBrown <neilb@suse.de>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Dec 2011 11:58:49 +1100
Subject: [PATCH 4/5] omap_hdq: handle case where isr sees a 0 status byte.
Message-ID: <20111230005849.11559.50437.stgit@notabene.brown>
In-Reply-To: <20111230004947.11559.81184.stgit@notabene.brown>
References: <20111230004947.11559.81184.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation, when an isr happens one of the
3 bits in INT_STATUS must be set to say why.
But I sometimes see a value of zero.

The only explanation I can think of is that someone else reads the
register and so clears the bits.  But I cannot find that someone.

So until we do, intuit what must have caused the interrupt.
If we were trying to write, assume it completed.
If we were trying to read and go something other than 0xFF,
assume the read completed.
If we read 0xFF, assume the read timed-out.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/w1/masters/omap_hdq.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 848399b..6b82469 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -211,9 +211,33 @@ static irqreturn_t hdq_isr(int irq, void *_hdq)
 {
 	struct hdq_data *hdq_data = _hdq;
 	unsigned long irqflags;
+	u8 status;
 
 	spin_lock_irqsave(&hdq_data->hdq_spinlock, irqflags);
-	hdq_data->hdq_irqstatus = hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
+	status = hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
+	if (!status) {
+		/* I sometimes see a zero status even though the read
+		 * seems to have been successful.  Very strange.
+		 * But we did get an interrupt, so figure out what
+		 * must have happened.
+		 */
+		u8 ctrl = hdq_reg_in(hdq_data, OMAP_HDQ_CTRL_STATUS);
+		dev_dbg(hdq_data->dev, "hdr_isr: INT=0!  CTRL=0x%02x\n", ctrl);
+		if (!(ctrl & OMAP_HDQ_CTRL_STATUS_GO)) {
+			/* It has definitely finished.. */
+			if (ctrl & OMAP_HDQ_CTRL_STATUS_DIR) {
+				/* A read finished or timed-out */
+				u8 data = hdq_reg_in(hdq_data,
+						      OMAP_HDQ_RX_DATA);
+				if (data == 0xFF)
+					status = OMAP_HDQ_INT_STATUS_TIMEOUT;
+				else
+					status = OMAP_HDQ_INT_STATUS_RXCOMPLETE;
+			} else
+				status = OMAP_HDQ_INT_STATUS_TXCOMPLETE;
+		}
+	}
+	hdq_data->hdq_irqstatus = status;
 	spin_unlock_irqrestore(&hdq_data->hdq_spinlock, irqflags);
 	dev_dbg(hdq_data->dev, "hdq_isr: %x", hdq_data->hdq_irqstatus);
 


