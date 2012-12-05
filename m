Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2LECYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:24:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58889 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2LECYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:24:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Dudley Du <dudl@cypress.com>, David Solda <dso@cypress.com>,
        Troy Abercrombia <ta@cypress.com>, Kamal Mostafa <kamal@canonical.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH v4 4/4] input: Cypress PS/2 Trackpad simulated multitouch (disabled)
Date: Tue,  4 Dec 2012 18:24:05 -0800
Message-Id: <1354674245-25768-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354674245-25768-1-git-send-email-kamal@canonical.com>
References: <1354674245-25768-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature is disabled by default; enable with CYPRESS_SIMULATED_MT.

Instead of SEMI_MT, present a full mt interface with simulated contact
positions for >=3 fingers.  Enables e.g. multi-finger tap and drag for
old userspace applications which only count the contact positions.

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/cypress_ps2.c |   18 ++++++++++++++++++
 drivers/input/mouse/cypress_ps2.h |   16 ++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index fab4d18..088cdb8 100644
--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -408,7 +408,9 @@ static int cypress_set_input_params(struct input_dev *input,
 		if (ret < 0)
 			return ret;
 
+#if ( CYPRESS_SIMULATED_MT != 1 )
 		__set_bit(INPUT_PROP_SEMI_MT, input->propbit);
+#endif
 
 		if (cytp->tp_res_x && cytp->tp_res_y) {
 			input_abs_set_res(input, ABS_X, cytp->tp_res_x);
@@ -531,6 +533,22 @@ static int cypress_parse_packet(struct psmouse *psmouse,
 				((packet[5] & 0x0f) << 8) | packet[7];
 			if (cytp->mode & CYTP_BIT_ABS_PRESSURE)
 				report_data->contacts[1].z = report_data->contacts[0].z;
+#if ( CYPRESS_SIMULATED_MT == 1 )
+			/* simulate contact positions for >2 fingers */
+			if ( report_data->contact_cnt >= 3 ) {
+				int i;
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
+			}
+#endif
 		}
 
 		report_data->left = (header_byte & BTN_LEFT_BIT) ? 1 : 0;
diff --git a/drivers/input/mouse/cypress_ps2.h b/drivers/input/mouse/cypress_ps2.h
index a74f985..c38cb6f 100644
--- a/drivers/input/mouse/cypress_ps2.h
+++ b/drivers/input/mouse/cypress_ps2.h
@@ -133,8 +133,20 @@
 #define RESP_REMOTE_BIT     0x40
 #define RESP_SMBUS_BIT      0x80
 
-#define CYTP_MAX_CONTACTS 2
-#define CYTP_MAX_MT_SLOTS 2
+/*
+ * CYPRESS_SIMULATED_MT
+ *   set to 1 for simulated multitouch (up to CTYP_MAX_CONTACTS fingers)
+ *   set to 0 for SEMI_MT (2 fingers only)
+ */
+#define CYPRESS_SIMULATED_MT 0
+
+#if ( CYPRESS_SIMULATED_MT == 1 )
+# define CYTP_MAX_CONTACTS 5
+# define CYTP_MAX_MT_SLOTS 16
+#else
+# define CYTP_MAX_CONTACTS 2
+# define CYTP_MAX_MT_SLOTS 2
+#endif
 
 enum cytp_type {
 	CYTP_STG,
-- 
1.7.10.4

