Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1FNI2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:28:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59260 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab1FNI2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:28:37 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
        Dmitry Torohov <dmitry.torokhov@gmail.com>
Subject: [PATCH] ideapad: let Fn+F5 also trigger KEY_BLUETOOTH
Date: Tue, 14 Jun 2011 16:28:29 +0800
Message-Id: <1308040109-12038-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The design for ideapad Fn-F5 key is not only for wifi but for all
radio device including wifi, bluetooth and wwan. Idealy it shall
acts like this:

    wifi on          wifi off         wifi on         wifi off
     bt on   ----->   bt on   ----->   bt off  ----->  bt off

This patch will switch wifi mode every key-push and switch
bluetooth mode every two key-push.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index bfdda33..e92ab14 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -328,6 +328,7 @@ static void ideapad_platform_exit(struct ideapad_private *priv)
 static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY, 0x06, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0x0D, { KEY_WLAN } },
+	{ KE_KEY, 0x0D, { KEY_BLUETOOTH } },
 	{ KE_END, 0 },
 };
 
@@ -379,7 +380,22 @@ static void __devexit ideapad_input_exit(struct ideapad_private *priv)
 static void ideapad_input_report(struct ideapad_private *priv,
 				 unsigned long scancode)
 {
-	sparse_keymap_report_event(priv->inputdev, scancode, 1, true);
+	static int bt_event_round;
+
+	if (scancode == 0x0D) {
+		bt_event_round++;
+		if (bt_event_round & 1) {
+			input_report_key(priv->inputdev, KEY_BLUETOOTH, 1);
+			input_sync(priv->inputdev);
+			input_report_key(priv->inputdev, KEY_BLUETOOTH, 0);
+			input_sync(priv->inputdev);
+		}
+		input_report_key(priv->inputdev, KEY_WLAN, 1);
+		input_sync(priv->inputdev);
+		input_report_key(priv->inputdev, KEY_WLAN, 0);
+		input_sync(priv->inputdev);
+	} else
+		sparse_keymap_report_event(priv->inputdev, scancode, 1, true);
 }
 
 /*
-- 
1.7.4.1

