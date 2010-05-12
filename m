Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0ELQ64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:58:56 -0400
Received: from kroah.org ([198.145.64.141]:59308 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0ELQ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:58:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: mjg@redhat.com
Cc: mzxreary@0pointer.de, rpurdie@linux.intel.com, jlee@novell.com,
       linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
       greg@kroah.com, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/4] msi-laptop: Set rfkill init state when msi-laptop intiial
Date: Wed, 12 May 2010 09:58:09 -0700
Message-Id: <1273683490-27090-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100512141149.GB20564@kroah.com>
References: <20100512141149.GB20564@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <jlee@novell.com>

Setup Wlan/Bluetooth/3G rfkill initial state to sync with the hardware
state from EC 0x2e address.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/msi-laptop.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 45197d7..34bec2e 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -581,11 +581,31 @@ static void rfkill_cleanup(void)
 	}
 }
 
+static void msi_init_rfkill(struct work_struct *ignored)
+{
+	if (rfk_wlan) {
+		rfkill_set_sw_state(rfk_wlan, !wlan_s);
+		rfkill_wlan_set(NULL, !wlan_s);
+	}
+	if (rfk_bluetooth) {
+		rfkill_set_sw_state(rfk_bluetooth, !bluetooth_s);
+		rfkill_bluetooth_set(NULL, !bluetooth_s);
+	}
+	if (rfk_threeg) {
+		rfkill_set_sw_state(rfk_threeg, !threeg_s);
+		rfkill_threeg_set(NULL, !threeg_s);
+	}
+}
+static DECLARE_DELAYED_WORK(msi_rfkill_init, msi_init_rfkill);
+
 static int rfkill_init(struct platform_device *sdev)
 {
 	/* add rfkill */
 	int retval;
 
+	/* keep the hardware wireless state */
+	get_wireless_state_ec_standard();
+
 	rfk_bluetooth = rfkill_alloc("msi-bluetooth", &sdev->dev,
 				RFKILL_TYPE_BLUETOOTH,
 				&rfkill_bluetooth_ops, NULL);
@@ -619,6 +639,10 @@ static int rfkill_init(struct platform_device *sdev)
 			goto err_threeg;
 	}
 
+	/* schedule to run rfkill state initial */
+	schedule_delayed_work(&msi_rfkill_init,
+				round_jiffies_relative(1 * HZ));
+
 	return 0;
 
 err_threeg:
-- 
1.7.1

