Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1IEScU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:32:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab1IEScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:32:12 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/5] ideapad: add event for Novo key
Date: Tue,  6 Sep 2011 02:32:10 +0800
Message-Id: <1315247530-9022-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315247467-8812-1-git-send-email-ike.pan@canonical.com>
References: <1315247467-8812-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Novo key is the Lenovo define key on every ideapads, which has two
definition. Long press and short click. Driver will report
KEY_PROG1 on short click and KEY_PROG2 when long press.

On pre-install OS for ideapads there are application waiting for
the event and there is no such application for Linux yet, so I
think to report KEY_PROG is fine in anyway.

Also change the scancode from hex to decimal because they are
related to vpc bit in notify function which is in decimal.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index ab3add3..39a72a8 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -386,8 +386,10 @@ static void ideapad_platform_exit(struct ideapad_private *priv)
  * input device
  */
 static const struct key_entry ideapad_keymap[] = {
-	{ KE_KEY, 0x06, { KEY_SWITCHVIDEOMODE } },
-	{ KE_KEY, 0x0D, { KEY_WLAN } },
+	{ KE_KEY, 6,  { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 13, { KEY_WLAN } },
+	{ KE_KEY, 16, { KEY_PROG1 } },
+	{ KE_KEY, 17, { KEY_PROG2 } },
 	{ KE_END, 0 },
 };
 
@@ -442,6 +444,18 @@ static void ideapad_input_report(struct ideapad_private *priv,
 	sparse_keymap_report_event(priv->inputdev, scancode, 1, true);
 }
 
+static void ideapad_input_novokey(struct ideapad_private *priv)
+{
+	unsigned long long_pressed;
+
+	if (read_ec_data(ideapad_handle, VPCCMD_R_NOVO, &long_pressed))
+		return;
+	if (long_pressed)
+		ideapad_input_report(priv, 17);
+	else
+		ideapad_input_report(priv, 16);
+}
+
 /*
  * backlight
  */
@@ -634,6 +648,9 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 			case 4:
 				ideapad_backlight_notify_brightness(priv);
 				break;
+			case 3:
+				ideapad_input_novokey(priv);
+				break;
 			case 2:
 				ideapad_backlight_notify_power(priv);
 				break;
-- 
1.7.5.4

