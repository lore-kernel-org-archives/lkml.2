Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0ELPov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:44:51 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:40280 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780Ab0ELPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:44:49 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net E21D1107BDC
Subject: [PATCH 4/5] HID: refactored special event handling in Roccat Kone
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 17:44:46 +0200
Message-ID: <1273679086.2927.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From e550163af2c39c4e7490cd5bf02e44c5dec72d2b Mon Sep 17 00:00:00 2001
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Date: Sat, 8 May 2010 17:30:27 +0200
Subject: [PATCH 4/5] HID: refactored special event handling in Roccat
Kone

As special events are reported along with hid event information all
events are now processed further by standard handler.
Also cleaned up this code.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |   54
+++++++++++++++-------------------------
 1 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c
b/drivers/hid/hid-roccat-kone.c
index 0b1db24..66e6940 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -912,6 +912,24 @@ static void kone_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 }
 
+/* handle special events and keep actual profile and dpi values up to
date */
+static void kone_keep_values_up_to_date(struct kone_device *kone,
+		struct kone_mouse_event const *event)
+{
+	switch (event->event) {
+	case kone_mouse_event_switch_profile:
+	case kone_mouse_event_osd_profile:
+		kone->actual_profile = event->value;
+		kone->actual_dpi = kone->profiles[kone->actual_profile - 1].
+				startup_dpi;
+		break;
+	case kone_mouse_event_switch_dpi:
+	case kone_mouse_event_osd_dpi:
+		kone->actual_dpi = event->value;
+		break;
+	}
+}
+
 /*
  * Is called for keyboard- and mousepart.
  * Only mousepart gets informations about special events in its
extended event
@@ -938,41 +956,9 @@ static int kone_raw_event(struct hid_device *hdev,
struct hid_report *report,
 	else
 		memset(&event->tilt, 0, 5);
 
-	/*
-	 * handle special events and keep actual profile and dpi values
-	 * up to date
-	 */
-	switch (event->event) {
-	case kone_mouse_event_osd_dpi:
-		dev_dbg(&hdev->dev, "osd dpi event. actual dpi %d\n",
-				event->value);
-		return 1; /* return 1 if event was handled */
-	case kone_mouse_event_switch_dpi:
-		kone->actual_dpi = event->value;
-		dev_dbg(&hdev->dev, "switched dpi to %d\n", event->value);
-		return 1;
-	case kone_mouse_event_osd_profile:
-		dev_dbg(&hdev->dev, "osd profile event. actual profile %d\n",
-				event->value);
-		return 1;
-	case kone_mouse_event_switch_profile:
-		kone->actual_profile = event->value;
-		kone->actual_dpi = kone->profiles[kone->actual_profile - 1].
-				startup_dpi;
-		dev_dbg(&hdev->dev, "switched profile to %d\n", event->value);
-		return 1;
-	case kone_mouse_event_call_overlong_macro:
-		dev_dbg(&hdev->dev, "overlong macro called, button %d %s/%s\n",
-				event->macro_key,
-				kone->profiles[kone->actual_profile - 1].
-				button_infos[event->macro_key].macro_set_name,
-				kone->profiles[kone->actual_profile - 1].
-				button_infos[event->macro_key].macro_name
-				);
-		return 1;
-	}
+	kone_keep_values_up_to_date(kone, event);
 
-	return 0; /* do further processing */
+	return 0; /* always do further processing */
 }
 
 static const struct hid_device_id kone_devices[] = {
-- 
1.6.6.1



