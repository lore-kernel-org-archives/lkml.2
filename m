Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1GAJfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:35:54 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:43286 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab1GAJfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:31 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 15/16] asus-wmi: add gps rfkill support
Date: Fri,  1 Jul 2011 11:34:40 +0200
Message-Id: <1309512881-2901-16-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index db4413a..83d4d26 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -194,6 +194,7 @@ struct asus_wmi {
 	struct asus_rfkill bluetooth;
 	struct asus_rfkill wimax;
 	struct asus_rfkill wwan3g;
+	struct asus_rfkill gps;
 
 	struct hotplug_slot *hotplug_slot;
 	struct mutex hotplug_lock;
@@ -835,6 +836,11 @@ static void asus_wmi_rfkill_exit(struct asus_wmi *asus)
 		rfkill_destroy(asus->wwan3g.rfkill);
 		asus->wwan3g.rfkill = NULL;
 	}
+	if (asus->gps.rfkill) {
+		rfkill_unregister(asus->gps.rfkill);
+		rfkill_destroy(asus->gps.rfkill);
+		asus->gps.rfkill = NULL;
+	}
 }
 
 static int asus_wmi_rfkill_init(struct asus_wmi *asus)
@@ -869,6 +875,12 @@ static int asus_wmi_rfkill_init(struct asus_wmi *asus)
 	if (result && result != -ENODEV)
 		goto exit;
 
+	result = asus_new_rfkill(asus, &asus->gps, "asus-gps",
+				 RFKILL_TYPE_GPS, ASUS_WMI_DEVID_GPS);
+
+	if (result && result != -ENODEV)
+		goto exit;
+
 	if (!asus->driver->hotplug_wireless)
 		goto exit;
 
@@ -1721,6 +1733,10 @@ static int asus_hotk_restore(struct device *device)
 		bl = !asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_WWAN3G);
 		rfkill_set_sw_state(asus->wwan3g.rfkill, bl);
 	}
+	if (asus->gps.rfkill) {
+		bl = !asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_GPS);
+		rfkill_set_sw_state(asus->gps.rfkill, bl);
+	}
 
 	return 0;
 }
-- 
1.7.3.4

