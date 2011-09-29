Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1I2Sdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:33:37 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35845
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755199Ab1I2ScT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:32:19 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 21/24] Staging: hv: mousevsc: Get rid of mousevsc_on_receive_input_report() by inlining
Date: Thu, 29 Sep 2011 11:55:01 -0700
Message-Id: <1317322504-9788-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317322504-9788-1-git-send-email-kys@microsoft.com>
References: <1317322456-9747-1-git-send-email-kys@microsoft.com>
 <1317322504-9788-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of mousevsc_on_receive_input_report() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   27 ++++++++-------------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 6621326..a526ba5 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -270,28 +270,13 @@ cleanup:
 	complete(&input_device->wait_event);
 }
 
-static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
-				struct synthhid_input_report *input_report)
-{
-	struct hv_driver *input_drv;
-
-	if (!input_device->init_complete)
-		return;
-
-	input_drv = drv_to_hv_drv(input_device->device->device.driver);
-
-
-	hid_input_report(input_device->hid_device,
-			      HID_INPUT_REPORT, input_report->buffer, input_report->header.size, 1);
-
-}
-
 static void mousevsc_on_receive(struct hv_device *device,
 				struct vmpacket_descriptor *packet)
 {
 	struct pipe_prt_msg *pipe_msg;
 	struct synthhid_msg *hid_msg;
 	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
+	struct synthhid_input_report *input_report;
 
 	pipe_msg = (struct pipe_prt_msg *)((unsigned long)packet +
 						(packet->offset8 << 3));
@@ -320,9 +305,13 @@ static void mousevsc_on_receive(struct hv_device *device,
 			(struct synthhid_device_info *)&pipe_msg->data[0]);
 		break;
 	case SYNTH_HID_INPUT_REPORT:
-		mousevsc_on_receive_input_report(input_dev,
-			(struct synthhid_input_report *)&pipe_msg->data[0]);
-
+		input_report =
+			(struct synthhid_input_report *)&pipe_msg->data[0];
+		if (!input_dev->init_complete)
+			break;
+		hid_input_report(input_dev->hid_device,
+				HID_INPUT_REPORT, input_report->buffer,
+				input_report->header.size, 1);
 		break;
 	default:
 		pr_err("unsupported hid msg type - type %d len %d",
-- 
1.7.4.1

