Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702Ab2FAWMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:12:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51127 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965557Ab2FAWMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:12:33 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Dionne <marc.c.dionne@gmail.com>
Subject: [PATCH] hid: logitech: don't use stack based dj_report structures
Date: Fri,  1 Jun 2012 18:12:14 -0400
Message-Id: <1338588734-2902-1-git-send-email-marc.c.dionne@gmail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a system with a logitech wireless keyboard/mouse and DMA-API debugging
enabled, this warning appears at boot:

kernel: WARNING: at lib/dma-debug.c:929 check_for_stack.part.12+0x70/0xa7()
kernel: Hardware name: MS-7593
kernel: uhci_hcd 0000:00:1d.1: DMA-API: device driver maps memory fromstack [addr=ffff8801b0079c29]

Make logi_dj_recv_query_paired_devices and logi_dj_recv_switch_to_dj_mode
use a structure allocated with kzalloc rather than a stack based one.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
---
 drivers/hid/hid-logitech-dj.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 5e8a7ed..0f9c146 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -436,27 +436,37 @@ static int logi_dj_recv_send_report(struct dj_receiver_dev *djrcv_dev,
 
 static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
 {
-	struct dj_report dj_report;
+	struct dj_report *dj_report;
+	int retval;
 
-	memset(&dj_report, 0, sizeof(dj_report));
-	dj_report.report_id = REPORT_ID_DJ_SHORT;
-	dj_report.device_index = 0xFF;
-	dj_report.report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
-	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
+	dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
+	if (!dj_report)
+		return -ENOMEM;
+	dj_report->report_id = REPORT_ID_DJ_SHORT;
+	dj_report->device_index = 0xFF;
+	dj_report->report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
+	retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
+	kfree(dj_report);
+	return retval;
 }
 
 static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 					  unsigned timeout)
 {
-	struct dj_report dj_report;
+	struct dj_report *dj_report;
+	int retval;
 
-	memset(&dj_report, 0, sizeof(dj_report));
-	dj_report.report_id = REPORT_ID_DJ_SHORT;
-	dj_report.device_index = 0xFF;
-	dj_report.report_type = REPORT_TYPE_CMD_SWITCH;
-	dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
-	dj_report.report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
-	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
+	dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
+	if (!dj_report)
+		return -ENOMEM;
+	dj_report->report_id = REPORT_ID_DJ_SHORT;
+	dj_report->device_index = 0xFF;
+	dj_report->report_type = REPORT_TYPE_CMD_SWITCH;
+	dj_report->report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
+	dj_report->report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
+	retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
+	kfree(dj_report);
+	return retval;
 }
 
 
-- 
1.7.10.2

