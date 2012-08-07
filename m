Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774Ab2HGXfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:35:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab2HGW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 047/122] b43: fix crash with OpenFWWF
Date: Tue,  7 Aug 2012 15:25:35 -0700
Message-Id: <20120807221952.440334699@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 097b0e1bf18a00195cd89bb13565ddbc9b0df942 upstream.

b43 with open firmware crashes mac80211 because
it changes the number of queues at runtime which,
while it was never really supported, now crashes
mac80211 due to the new hardware queue logic.

Fix this by detecting open vs. proprietary fw
earlier and registering with mac80211 with the
right number of queues.

Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/b43/b43.h  |    7 -------
 drivers/net/wireless/b43/main.c |   32 ++++++++++----------------------
 2 files changed, 10 insertions(+), 29 deletions(-)

--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -870,13 +870,6 @@ struct b43_wl {
 	 * handler, only. This basically is just the IRQ mask register. */
 	spinlock_t hardirq_lock;
 
-	/* The number of queues that were registered with the mac80211 subsystem
-	 * initially. This is a backup copy of hw->queues in case hw->queues has
-	 * to be dynamically lowered at runtime (Firmware does not support QoS).
-	 * hw->queues has to be restored to the original value before unregistering
-	 * from the mac80211 subsystem. */
-	u16 mac80211_initially_registered_queues;
-
 	/* Set this if we call ieee80211_register_hw() and check if we call
 	 * ieee80211_unregister_hw(). */
 	bool hw_registred;
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2359,6 +2359,8 @@ static int b43_try_request_fw(struct b43
 	if (err)
 		goto err_load;
 
+	fw->opensource = (ctx->req_type == B43_FWTYPE_OPENSOURCE);
+
 	return 0;
 
 err_no_ucode:
@@ -2434,6 +2436,10 @@ static void b43_request_firmware(struct
 	goto out;
 
 start_ieee80211:
+	wl->hw->queues = B43_QOS_QUEUE_NUM;
+	if (!modparam_qos || dev->fw.opensource)
+		wl->hw->queues = 1;
+
 	err = ieee80211_register_hw(wl->hw);
 	if (err)
 		goto err_one_core_detach;
@@ -2537,11 +2543,9 @@ static int b43_upload_microcode(struct b
 		dev->fw.hdr_format = B43_FW_HDR_410;
 	else
 		dev->fw.hdr_format = B43_FW_HDR_351;
-	dev->fw.opensource = (fwdate == 0xFFFF);
+	WARN_ON(dev->fw.opensource != (fwdate == 0xFFFF));
 
-	/* Default to use-all-queues. */
-	dev->wl->hw->queues = dev->wl->mac80211_initially_registered_queues;
-	dev->qos_enabled = !!modparam_qos;
+	dev->qos_enabled = dev->wl->hw->queues > 1;
 	/* Default to firmware/hardware crypto acceleration. */
 	dev->hwcrypto_enabled = true;
 
@@ -2559,14 +2563,8 @@ static int b43_upload_microcode(struct b
 			/* Disable hardware crypto and fall back to software crypto. */
 			dev->hwcrypto_enabled = false;
 		}
-		if (!(fwcapa & B43_FWCAPA_QOS)) {
-			b43info(dev->wl, "QoS not supported by firmware\n");
-			/* Disable QoS. Tweak hw->queues to 1. It will be restored before
-			 * ieee80211_unregister to make sure the networking core can
-			 * properly free possible resources. */
-			dev->wl->hw->queues = 1;
-			dev->qos_enabled = false;
-		}
+		/* adding QoS support should use an offline discovery mechanism */
+		WARN(fwcapa & B43_FWCAPA_QOS, "QoS in OpenFW not supported\n");
 	} else {
 		b43info(dev->wl, "Loading firmware version %u.%u "
 			"(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
@@ -5298,8 +5296,6 @@ static struct b43_wl *b43_wireless_init(
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
-	hw->queues = modparam_qos ? B43_QOS_QUEUE_NUM : 1;
-	wl->mac80211_initially_registered_queues = hw->queues;
 	wl->hw_registred = false;
 	hw->max_rates = 2;
 	SET_IEEE80211_DEV(hw, dev->dev);
@@ -5374,10 +5370,6 @@ static void b43_bcma_remove(struct bcma_
 
 	B43_WARN_ON(!wl);
 	if (wl->current_dev == wldev && wl->hw_registred) {
-		/* Restore the queues count before unregistering, because firmware detect
-		 * might have modified it. Restoring is important, so the networking
-		 * stack can properly free resources. */
-		wl->hw->queues = wl->mac80211_initially_registered_queues;
 		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);
 	}
@@ -5452,10 +5444,6 @@ static void b43_ssb_remove(struct ssb_de
 
 	B43_WARN_ON(!wl);
 	if (wl->current_dev == wldev && wl->hw_registred) {
-		/* Restore the queues count before unregistering, because firmware detect
-		 * might have modified it. Restoring is important, so the networking
-		 * stack can properly free resources. */
-		wl->hw->queues = wl->mac80211_initially_registered_queues;
 		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);
 	}


