Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2JGX3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:29:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38629 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307Ab2JGXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:16 -0400
Message-Id: <20121007225840.112005040@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marc Dionne <marc.c.dionne@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 039/108] HID: logitech: dont use stack based dj_report structures
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Dionne <marc.c.dionne@gmail.com>

commit d8dc3494f77a5cc3b274bae36f7e74e85cf8a407 upstream.

On a system with a logitech wireless keyboard/mouse and DMA-API debugging
enabled, this warning appears at boot:

kernel: WARNING: at lib/dma-debug.c:929 check_for_stack.part.12+0x70/0xa7()
kernel: Hardware name: MS-7593
kernel: uhci_hcd 0000:00:1d.1: DMA-API: device driver maps memory fromstack [addr=ffff8801b0079c29]

Make logi_dj_recv_query_paired_devices and logi_dj_recv_switch_to_dj_mode
use a structure allocated with kzalloc rather than a stack based one.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 
 


