Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0ELQ6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:58:37 -0400
Received: from kroah.org ([198.145.64.141]:59316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab0ELQ6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:58:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: mjg@redhat.com
Cc: mzxreary@0pointer.de, rpurdie@linux.intel.com, jlee@novell.com,
       linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
       greg@kroah.com, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/4] msi-laptop: Add i8042 filter to sync sw state with BIOS when function key pressed
Date: Wed, 12 May 2010 09:58:10 -0700
Message-Id: <1273683490-27090-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100512141149.GB20564@kroah.com>
References: <20100512141149.GB20564@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <jlee@novell.com>

There have some MSI netbook change devices state by EC when user press
wlan/bluetooth/wwan function keys. So, add a i8042 filter to sync sw
state with BIOS when function keys pressed.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/msi-laptop.c |   59 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 34bec2e..3c6e160 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -59,6 +59,7 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
+#include <linux/i8042.h>
 
 #define MSI_DRIVER_VERSION "0.5"
 
@@ -581,6 +582,46 @@ static void rfkill_cleanup(void)
 	}
 }
 
+static void msi_update_rfkill(struct work_struct *ignored)
+{
+	get_wireless_state_ec_standard();
+
+	if (rfk_wlan)
+		rfkill_set_sw_state(rfk_wlan, !wlan_s);
+	if (rfk_bluetooth)
+		rfkill_set_sw_state(rfk_bluetooth, !bluetooth_s);
+	if (rfk_threeg)
+		rfkill_set_sw_state(rfk_threeg, !threeg_s);
+}
+static DECLARE_DELAYED_WORK(msi_rfkill_work, msi_update_rfkill);
+
+bool msi_laptop_i8042_filter(unsigned char data, unsigned char str,
+				struct serio *port)
+{
+	static bool extended;
+
+	if (str & 0x20)
+		return false;
+
+	/* 0x54 wwan, 0x62 bluetooth, 0x76 wlan*/
+	if (unlikely(data == 0xe0)) {
+		extended = true;
+		return false;
+	} else if (unlikely(extended)) {
+		switch (data) {
+		case 0x54:
+		case 0x62:
+		case 0x76:
+			schedule_delayed_work(&msi_rfkill_work,
+				round_jiffies_relative(0.5 * HZ));
+			break;
+		}
+		extended = false;
+	}
+
+	return false;
+}
+
 static void msi_init_rfkill(struct work_struct *ignored)
 {
 	if (rfk_wlan) {
@@ -706,9 +747,24 @@ static int load_scm_model_init(struct platform_device *sdev)
 	/* initial rfkill */
 	result = rfkill_init(sdev);
 	if (result < 0)
-		return result;
+		goto fail_rfkill;
+
+	result = i8042_install_filter(msi_laptop_i8042_filter);
+	if (result) {
+		printk(KERN_WARNING
+			"msi-laptop: Unable to install key filter\n");
+		goto fail_filter;
+	}
 
 	return 0;
+
+fail_filter:
+	rfkill_cleanup();
+
+fail_rfkill:
+
+	return result;
+
 }
 
 static int __init msi_init(void)
@@ -819,6 +875,7 @@ static void __exit msi_cleanup(void)
 	platform_driver_unregister(&msipf_driver);
 	backlight_device_unregister(msibl_device);
 
+	i8042_remove_filter(msi_laptop_i8042_filter);
 	rfkill_cleanup();
 
 	/* Enable automatic brightness control again */
-- 
1.7.1

