Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1L3Crp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 21:47:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1L3Cro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 21:47:44 -0500
From: NeilBrown <neilb@suse.de>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Dec 2011 11:58:49 +1100
Subject: [PATCH 2/5] omap_hdq: Fix some error/debug handling.
Message-ID: <20111230005849.11559.60004.stgit@notabene.brown>
In-Reply-To: <20111230004947.11559.81184.stgit@notabene.brown>
References: <20111230004947.11559.81184.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- some debug messages missed spaces
- sometimes no error was returned when it should have been
- sometimes a message is printed when there is no error, rather
  than when there is one.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/w1/masters/omap_hdq.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 5ef385b..3036b61 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -180,6 +180,7 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
 		hdq_data->hdq_irqstatus, OMAP_HDQ_TIMEOUT);
 	if (ret == 0) {
 		dev_dbg(hdq_data->dev, "TX wait elapsed\n");
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 
@@ -187,7 +188,7 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
 	/* check irqstatus */
 	if (!(*status & OMAP_HDQ_INT_STATUS_TXCOMPLETE)) {
 		dev_dbg(hdq_data->dev, "timeout waiting for"
-			"TXCOMPLETE/RXCOMPLETE, %x", *status);
+			" TXCOMPLETE/RXCOMPLETE, %x", *status);
 		ret = -ETIMEDOUT;
 		goto out;
 	}
@@ -198,7 +199,7 @@ static int hdq_write_byte(struct hdq_data *hdq_data, u8 val, u8 *status)
 			OMAP_HDQ_FLAG_CLEAR, &tmp_status);
 	if (ret) {
 		dev_dbg(hdq_data->dev, "timeout waiting GO bit"
-			"return to zero, %x", tmp_status);
+			" return to zero, %x", tmp_status);
 	}
 
 out:
@@ -341,7 +342,7 @@ static int omap_hdq_break(struct hdq_data *hdq_data)
 			&tmp_status);
 	if (ret)
 		dev_dbg(hdq_data->dev, "timeout waiting INIT&GO bits"
-			"return to zero, %x", tmp_status);
+			" return to zero, %x", tmp_status);
 
 out:
 	mutex_unlock(&hdq_data->hdq_mutex);
@@ -386,7 +387,7 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 *val)
 		/* check irqstatus */
 		if (!(status & OMAP_HDQ_INT_STATUS_RXCOMPLETE)) {
 			dev_dbg(hdq_data->dev, "timeout waiting for"
-				"RXCOMPLETE, %x", status);
+				" RXCOMPLETE, %x", status);
 			ret = -ETIMEDOUT;
 			goto out;
 		}
@@ -396,7 +397,7 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 *val)
 out:
 	mutex_unlock(&hdq_data->hdq_mutex);
 rtn:
-	return 0;
+	return ret;
 
 }
 
@@ -470,7 +471,7 @@ static int omap_hdq_put(struct hdq_data *hdq_data)
 
 	if (0 == hdq_data->hdq_usecount) {
 		dev_dbg(hdq_data->dev, "attempt to decrement use count"
-			"when it is zero");
+			" when it is zero");
 		ret = -EINVAL;
 	} else {
 		hdq_data->hdq_usecount--;
@@ -540,7 +541,7 @@ static void omap_w1_write_byte(void *_hdq, u8 byte)
 	mutex_unlock(&hdq_data->hdq_mutex);
 
 	ret = hdq_write_byte(hdq_data, byte, &status);
-	if (ret == 0) {
+	if (ret < 0) {
 		dev_dbg(hdq_data->dev, "TX failure:Ctrl status %x\n", status);
 		return;
 	}


