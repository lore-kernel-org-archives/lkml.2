Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab1KWAlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:41:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759388Ab1KWAlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:05 2011
Message-Id: <20111123002405.450677495@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [09/53] rt2x00: Fix sleep-while-atomic bug in powersaving code.
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit ed66ba472a742cd8df37d7072804b2111cdb1014 upstream.

The generic powersaving code that determines after reception of a frame
whether the device should go back to sleep or whether is could stay
awake was calling rt2x00lib_config directly from RX tasklet context.
On a number of the devices this call can actually sleep, due to having
to confirm that the sleeping commands have been executed successfully.

Fix this by moving the call to rt2x00lib_config to a workqueue call.

This fixes bug https://bugzilla.redhat.com/show_bug.cgi?id=731672

Tested-by: Tomas Trnka <tomastrnka@gmx.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -922,6 +922,7 @@ struct rt2x00_dev {
 	 * Powersaving work
 	 */
 	struct delayed_work autowakeup_work;
+	struct work_struct sleep_work;
 
 	/*
 	 * Data queue arrays for RX, TX, Beacon and ATIM.
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -449,6 +449,23 @@ static u8 *rt2x00lib_find_ie(u8 *data, u
 	return NULL;
 }
 
+static void rt2x00lib_sleep(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, sleep_work);
+
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return;
+
+	/*
+	 * Check again is powersaving is enabled, to prevent races from delayed
+	 * work execution.
+	 */
+	if (!test_bit(CONFIG_POWERSAVING, &rt2x00dev->flags))
+		rt2x00lib_config(rt2x00dev, &rt2x00dev->hw->conf,
+				 IEEE80211_CONF_CHANGE_PS);
+}
+
 static void rt2x00lib_rxdone_check_ps(struct rt2x00_dev *rt2x00dev,
 				      struct sk_buff *skb,
 				      struct rxdone_entry_desc *rxdesc)
@@ -496,8 +513,7 @@ static void rt2x00lib_rxdone_check_ps(st
 	cam |= (tim_ie->bitmap_ctrl & 0x01);
 
 	if (!cam && !test_bit(CONFIG_POWERSAVING, &rt2x00dev->flags))
-		rt2x00lib_config(rt2x00dev, &rt2x00dev->hw->conf,
-				 IEEE80211_CONF_CHANGE_PS);
+		queue_work(rt2x00dev->workqueue, &rt2x00dev->sleep_work);
 }
 
 static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
@@ -1108,6 +1124,7 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
 	INIT_DELAYED_WORK(&rt2x00dev->autowakeup_work, rt2x00lib_autowakeup);
+	INIT_WORK(&rt2x00dev->sleep_work, rt2x00lib_sleep);
 
 	/*
 	 * Let the driver probe the device to detect the capabilities.
@@ -1164,6 +1181,7 @@ void rt2x00lib_remove_dev(struct rt2x00_
 	 */
 	cancel_work_sync(&rt2x00dev->intf_work);
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
+	cancel_work_sync(&rt2x00dev->sleep_work);
 	if (rt2x00_is_usb(rt2x00dev)) {
 		del_timer_sync(&rt2x00dev->txstatus_timer);
 		cancel_work_sync(&rt2x00dev->rxdone_work);


