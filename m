Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab0C3XXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:23:16 -0400
Received: from kroah.org ([198.145.64.141]:46852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712Ab0C3XWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:20 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:59 2010
Message-Id: <20100330224859.009190883@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:43:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [152/156] b43: Workaround circular locking in hw-tkip key update callback
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

commit 96869a39399269a776a94812e9fff3d38b47d838 upstream

The TKIP key update callback is called from the RX path, where the driver
mutex is already locked. This results in a circular locking bug.
Avoid this by removing the lock.

Johannes noted that there is a separate bug: The callback still breaks on SDIO
hardware, because SDIO hardware access needs to sleep, but we are not allowed
to sleep in the callback due to mac80211's RCU locking.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: kecsa@kutfo.hit.bme.hu
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -852,19 +852,16 @@ static void b43_op_update_tkip_key(struc
 	if (B43_WARN_ON(!modparam_hwtkip))
 		return;
 
-	mutex_lock(&wl->mutex);
-
+	/* This is only called from the RX path through mac80211, where
+	 * our mutex is already locked. */
+	B43_WARN_ON(!mutex_is_locked(&wl->mutex));
 	dev = wl->current_dev;
-	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
-		goto out_unlock;
+	B43_WARN_ON(!dev || b43_status(dev) < B43_STAT_INITIALIZED);
 
 	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
 
 	rx_tkip_phase1_write(dev, index, iv32, phase1key);
 	keymac_write(dev, index, addr);
-
-out_unlock:
-	mutex_unlock(&wl->mutex);
 }
 
 static void do_key_write(struct b43_wldev *dev,


