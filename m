Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2K2V6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:58:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2K2V6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:58:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Dudley Du <dudl@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH v3 4/4] input: Cypress PS/2 Trackpad simulated multitouch
Date: Thu, 29 Nov 2012 13:58:01 -0800
Message-Id: <1354226281-3476-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354226281-3476-1-git-send-email-kamal@canonical.com>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of SEMI_MT, present a full mt interface with simulated contact
positions for >=3 fingers.  Enables e.g. multi-finger tap and drag.

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/cypress_ps2.c |   16 ++++++++++++++++
 drivers/input/mouse/cypress_ps2.h |   14 +++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index 472342a..bbaa9b9 100644
--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -408,7 +408,9 @@ static int cypress_set_input_params(struct input_dev *input,
 			return ret;
 		}
 
+#if ( CYPRESS_SIMULATED_MT != 1 )
 		__set_bit(INPUT_PROP_SEMI_MT, input->propbit);
+#endif
 
 		if (cytp->tp_res_x && cytp->tp_res_x) {
 			input_abs_set_res(input, ABS_X, cytp->tp_res_x);
@@ -531,6 +533,20 @@ static int cypress_parse_packet(struct psmouse *psmouse,
 				((packet[5] & 0x0f) << 8) | packet[7];
 			if (cytp->mode & CYTP_BIT_ABS_PRESSURE)
 				report_data->contacts[1].z = report_data->contacts[0].z;
+#if ( CYPRESS_SIMULATED_MT == 1 )
+			/* simulate contact positions for >2 fingers */
+			if ( report_data->contact_cnt >= 3 )
+				for ( i=1; i<report_data->contact_cnt; i++ ) {
+				    report_data->contacts[i].x =
+						    report_data->contacts[0].x
+						    + 100*(i)*((i%2)?-1:1);
+				    report_data->contacts[i].y =
+						    report_data->contacts[0].y;
+				    if (cytp->mode & CYTP_BIT_ABS_PRESSURE)
+					    report_data->contacts[i].z =
+						    report_data->contacts[0].z;
+				}
+#endif
 		}
 
 		report_data->left = (header_byte & BTN_LEFT_BIT) ? 1 : 0;
diff --git a/drivers/input/mouse/cypress_ps2.h b/drivers/input/mouse/cypress_ps2.h
index ce70462..4b903a9 100644
--- a/drivers/input/mouse/cypress_ps2.h
+++ b/drivers/input/mouse/cypress_ps2.h
@@ -134,7 +134,19 @@
 #define RESP_SMBUS_BIT      0x80
 
 #define CYTP_MAX_CONTACTS 5
-#define CYTP_MAX_MT_SLOTS 2
+
+/*
+ * CYPRESS_SIMULATED_MT
+ *   set to 1 for simulated multitouch (up to CTYP_MAX_CONTACTS fingers)
+ *   set to 0 for SEMI_MT (2 fingers only)
+ */
+#define CYPRESS_SIMULATED_MT 1
+
+#if ( CYPRESS_SIMULATED_MT == 1 )
+# define CYTP_MAX_MT_SLOTS 16
+#else
+# define CYTP_MAX_MT_SLOTS 2
+#endif
 
 enum cytp_type {
 	CYTP_STG,
-- 
1.7.10.4

