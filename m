Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab0ELAS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:18:57 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:58048 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752733Ab0ELASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:18:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 21078
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: fercerpav@gmail.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/4] MFD: pcf50633-adc: Fix potential race pcf50633_adc_sync_read
Date: Wed, 12 May 2010 02:10:54 +0200
Message-Id: <1273623056-1243-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273623056-1243-2-git-send-email-lars@metafoo.de>
References: <1273623056-1243-1-git-send-email-lars@metafoo.de>
 <1273623056-1243-2-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it's not guaranteed that request struct is not already freed when
reading from it. Fix this by moving synced request related fields from the
pcf50633_adc_request struct to its own struct and store it on the functions
stack.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/pcf50633-adc.c |   39 +++++++++++++++------------------------
 1 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index fe8f922..aed0d2a 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -30,13 +30,13 @@
 struct pcf50633_adc_request {
 	int mux;
 	int avg;
-	int result;
 	void (*callback)(struct pcf50633 *, void *, int);
 	void *callback_param;
+};
 
-	/* Used in case of sync requests */
+struct pcf50633_adc_sync_request {
+	int result;
 	struct completion completion;
-
 };
 
 #define PCF50633_MAX_ADC_FIFO_DEPTH 8
@@ -109,10 +109,10 @@ adc_enqueue_request(struct pcf50633 *pcf, struct pcf50633_adc_request *req)
 	return 0;
 }
 
-static void
-pcf50633_adc_sync_read_callback(struct pcf50633 *pcf, void *param, int result)
+static void pcf50633_adc_sync_read_callback(struct pcf50633 *pcf, void *param,
+	int result)
 {
-	struct pcf50633_adc_request *req = param;
+	struct pcf50633_adc_sync_request *req = param;
 
 	req->result = result;
 	complete(&req->completion);
@@ -120,28 +120,19 @@ pcf50633_adc_sync_read_callback(struct pcf50633 *pcf, void *param, int result)
 
 int pcf50633_adc_sync_read(struct pcf50633 *pcf, int mux, int avg)
 {
-	struct pcf50633_adc_request *req;
-	int err;
+	struct pcf50633_adc_sync_request req;
+	int ret;
 
-	/* req is freed when the result is ready, in interrupt handler */
-	req = kzalloc(sizeof(*req), GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
-
-	req->mux = mux;
-	req->avg = avg;
-	req->callback =  pcf50633_adc_sync_read_callback;
-	req->callback_param = req;
+	init_completion(&req.completion);
 
-	init_completion(&req->completion);
-	err = adc_enqueue_request(pcf, req);
-	if (err)
-		return err;
+	ret = pcf50633_adc_async_read(pcf, mux, avg,
+		pcf50633_adc_sync_read_callback, &req);
+	if (ret)
+		return ret;
 
-	wait_for_completion(&req->completion);
+	wait_for_completion(&req.completion);
 
-	/* FIXME by this time req might be already freed */
-	return req->result;
+	return req.result;
 }
 EXPORT_SYMBOL_GPL(pcf50633_adc_sync_read);
 
-- 
1.5.6.5

