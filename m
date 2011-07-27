Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1G0TCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:02:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56047 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1G0TCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:02:21 -0400
Date: Wed, 27 Jul 2011 14:49:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: wireless-next-2.6 2011-07-27
Message-ID: <20110727184920.GB16431@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here is a handful of fixes intended for 3.1.  This includes a
user-visible typo fix, a fix for a user after free in the new pn533
NFC driver, a cfg80211 fix for a possible NULL pointer dereference,
a fix for an invalid memory access in b43, and another b43 fix for
a memory corruption problem.

On top of that b43 memory corruption fix, there is a patch to remove
BROKEN from the B43_BCMA Kconfig entry, which is key to enabling
support for some of the more modern Broadcom wireless hardware.
I'm sure the Rafał (and a number of others) would love to see that
merged while the 3.1 merge window is still open as well.

Please let me know if there are problems...

Thanks!

John

---

The following changes since commit 41bf37117b47fc5ce2aae91f6a108e7e42e0b046:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6 into for-davem (2011-07-22 17:51:16 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git for-davem

Dan Carpenter (1):
      NFC: pn533: use after free in pn533_disconnect()

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Mihai Moldovan (1):
      wireless: fix a typo in ignore_reg_update

Pavel Roskin (1):
      b43: fix invalid memory access in b43_ssb_remove()

Rafał Miłecki (2):
      b43: bus: fix memory corruption when setting driver's data
      b43: bcma: drop BROKEN

Sven Neumann (1):
      cfg80211: really ignore the regulatory request

 drivers/net/wireless/b43/Kconfig |    2 +-
 drivers/net/wireless/b43/bus.c   |    2 ++
 drivers/net/wireless/b43/main.c  |    5 +++--
 drivers/nfc/pn533.c              |    2 +-
 net/wireless/reg.c               |    7 ++++---
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index d2293dc..3cab843 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -28,7 +28,7 @@ config B43
 
 config B43_BCMA
 	bool "Support for BCMA bus"
-	depends on B43 && BCMA && BROKEN
+	depends on B43 && BCMA
 	default y
 
 config B43_SSB
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 64c3f65..05f6c7b 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -244,10 +244,12 @@ void b43_bus_set_wldev(struct b43_bus_dev *dev, void *wldev)
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
 		bcma_set_drvdata(dev->bdev, wldev);
+		break;
 #endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		ssb_set_drvdata(dev->sdev, wldev);
+		break;
 #endif
 	}
 }
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 73fbf03..a92cde8 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5350,6 +5350,7 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 {
 	struct b43_wl *wl = ssb_get_devtypedata(sdev);
 	struct b43_wldev *wldev = ssb_get_drvdata(sdev);
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5365,14 +5366,14 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-	b43_one_core_detach(wldev->dev);
+	b43_one_core_detach(dev);
 
 	if (list_empty(&wl->devlist)) {
 		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
 		 * We can destroy common struct b43_wl.
 		 */
-		b43_wireless_exit(wldev->dev, wl);
+		b43_wireless_exit(dev, wl);
 	}
 }
 
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 0372315..c77e054 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1596,7 +1596,7 @@ static void pn533_disconnect(struct usb_interface *interface)
 	usb_free_urb(dev->out_urb);
 	kfree(dev);
 
-	nfc_dev_info(&dev->interface->dev, "NXP PN533 NFC device disconnected");
+	nfc_dev_info(&interface->dev, "NXP PN533 NFC device disconnected");
 }
 
 static struct usb_driver pn533_driver = {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ad0f39..02751db 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -903,7 +903,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    !is_world_regdom(last_request->alpha2)) {
 		REG_DBG_PRINT("Ignoring regulatory request %s "
-			      "since the driver requires its own regulaotry "
+			      "since the driver requires its own regulatory "
 			      "domain to be set first",
 			      reg_initiator_name(initiator));
 		return true;
@@ -1125,12 +1125,13 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
 	enum ieee80211_band band;
 
 	if (ignore_reg_update(wiphy, initiator))
-		goto out;
+		return;
+
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band, initiator);
 	}
-out:
+
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
 	if (wiphy->reg_notifier)
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
