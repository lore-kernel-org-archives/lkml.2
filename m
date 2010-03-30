Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0C3XNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:13:06 -0400
Received: from kroah.org ([198.145.64.141]:49174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab0C3XMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:52 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:50 2010
Message-Id: <20100330225849.712434447@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [66/89] b43: Fix throughput regression
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit b6c3f5be7c6ac3375f44de4545c1ffe216b34022 upstream.

Commit c7ab5ef9bcd281135c21b4732c9be779585181be entitled "b43: implement
short slot and basic rate handling" reduced the transmit throughput for
my BCM4311 device from 18 Mb/s to 0.7 Mb/s. The basic rate handling
portion is OK, the problem is in the short slot handling.

Prior to this change, the short slot enable/disable routines were never
called. Experimentation showed that the critical part was changing the
value at offset 0x0010 in the shared memory. This is supposed to contain
the 802.11 Slot Time in usec, but if it is changed from its initial value
of zero, performance is destroyed. On the other hand, changing the value
in the MMIO register corresponding to the Interframe Slot Time increased
performance from 18 to 22 Mb/s. A BCM4306/3 also shows dramatic
improvement of the transmit rate from 5.3 to 19.0 Mb/s.

Other changes in the patch include removal of the magic number for the
MMIO register, and allowing the slot time to be set for any PHY operating
in the 2.4 GHz band. Previously, the routine was executed only for G PHYs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/b43.h  |    1 +
 drivers/net/wireless/b43/main.c |   13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -117,6 +117,7 @@
 #define B43_MMIO_TSF_2			0x636	/* core rev < 3 only */
 #define B43_MMIO_TSF_3			0x638	/* core rev < 3 only */
 #define B43_MMIO_RNG			0x65A
+#define B43_MMIO_IFSSLOT		0x684	/* Interframe slot time */
 #define B43_MMIO_IFSCTL			0x688 /* Interframe space control */
 #define  B43_MMIO_IFSCTL_USE_EDCF	0x0004
 #define B43_MMIO_POWERUP_DELAY		0x6A8
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -664,10 +664,17 @@ static void b43_upload_card_macaddress(s
 static void b43_set_slot_time(struct b43_wldev *dev, u16 slot_time)
 {
 	/* slot_time is in usec. */
-	if (dev->phy.type != B43_PHYTYPE_G)
+	/* This test used to exit for all but a G PHY. */
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
 		return;
-	b43_write16(dev, 0x684, 510 + slot_time);
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x0010, slot_time);
+	b43_write16(dev, B43_MMIO_IFSSLOT, 510 + slot_time);
+	/* Shared memory location 0x0010 is the slot time and should be
+	 * set to slot_time; however, this register is initially 0 and changing
+	 * the value adversely affects the transmit rate for BCM4311
+	 * devices. Until this behavior is unterstood, delete this step
+	 *
+	 * b43_shm_write16(dev, B43_SHM_SHARED, 0x0010, slot_time);
+	 */
 }
 
 static void b43_short_slot_timing_enable(struct b43_wldev *dev)


