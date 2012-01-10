Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab2AJRXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:23:42 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:32769 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2AJRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:23:41 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: mikekrufky@gmail.com, linux-media@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/4] DVB: dib0700, move Nova-TD Stick to a separate set
Date: Tue, 10 Jan 2012 18:11:22 +0100
Message-Id: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To properly support the three LEDs which are on the stick, we need
a special handling in the ->frontend_attach function. Thus let's have
a separate ->frontend_attach instead of ifs in the common one.

The hadnling itself will be added in further patches.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   57 ++++++++++++++++++++++++--
 1 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 81ef4b4..3c6ee54 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -3892,7 +3892,58 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.num_device_descs = 6,
+		.num_device_descs = 1,
+		.devices = {
+			{   "Hauppauge Nova-TD Stick (52009)",
+				{ &dib0700_usb_id_table[35], NULL },
+				{ NULL },
+			},
+		},
+
+		.rc.core = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
+			.change_protocol = dib0700_change_protocol,
+		},
+	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+
+		.num_adapters = 2,
+		.adapter = {
+			{
+			.num_frontends = 1,
+			.fe = {{
+				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+				.pid_filter_count = 32,
+				.pid_filter       = stk70x0p_pid_filter,
+				.pid_filter_ctrl  = stk70x0p_pid_filter_ctrl,
+				.frontend_attach  = stk7070pd_frontend_attach0,
+				.tuner_attach     = dib7070p_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+			}},
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
+			}, {
+			.num_frontends = 1,
+			.fe = {{
+				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+				.pid_filter_count = 32,
+				.pid_filter       = stk70x0p_pid_filter,
+				.pid_filter_ctrl  = stk70x0p_pid_filter_ctrl,
+				.frontend_attach  = stk7070pd_frontend_attach1,
+				.tuner_attach     = dib7070p_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
+			}},
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
+			}
+		},
+
+		.num_device_descs = 5,
 		.devices = {
 			{   "DiBcom STK7070PD reference design",
 				{ &dib0700_usb_id_table[17], NULL },
@@ -3902,10 +3953,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ &dib0700_usb_id_table[18], NULL },
 				{ NULL },
 			},
-			{   "Hauppauge Nova-TD Stick (52009)",
-				{ &dib0700_usb_id_table[35], NULL },
-				{ NULL },
-			},
 			{   "Hauppauge Nova-TD-500 (84xxx)",
 				{ &dib0700_usb_id_table[36], NULL },
 				{ NULL },
-- 
1.7.8


