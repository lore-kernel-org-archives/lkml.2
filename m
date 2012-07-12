Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162431Ab2GLWsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:48:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162367Ab2GLWqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:46:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [ 171/187] rtl8187: ->brightness_set can not sleep
Date: Thu, 12 Jul 2012 15:35:27 -0700
Message-Id: <20120712191539.152446807@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 0fde0a8cfd0ede7f310d6a681c8e5a7cb3e32406 upstream.

Fix:

BUG: sleeping function called from invalid context at kernel/workqueue.c:2547
in_atomic(): 1, irqs_disabled(): 0, pid: 629, name: wpa_supplicant
2 locks held by wpa_supplicant/629:
 #0:  (rtnl_mutex){+.+.+.}, at: [<c08b2b84>] rtnl_lock+0x14/0x20
 #1:  (&trigger->leddev_list_lock){.+.?..}, at: [<c0867f41>] led_trigger_event+0x21/0x80
Pid: 629, comm: wpa_supplicant Not tainted 3.3.0-0.rc3.git5.1.fc17.i686
Call Trace:
 [<c046a9f6>] __might_sleep+0x126/0x1d0
 [<c0457d6c>] wait_on_work+0x2c/0x1d0
 [<c045a09a>] __cancel_work_timer+0x6a/0x120
 [<c045a160>] cancel_delayed_work_sync+0x10/0x20
 [<f7dd3c22>] rtl8187_led_brightness_set+0x82/0xf0 [rtl8187]
 [<c0867f7c>] led_trigger_event+0x5c/0x80
 [<f7ff5e6d>] ieee80211_led_radio+0x1d/0x40 [mac80211]
 [<f7ff3583>] ieee80211_stop_device+0x13/0x230 [mac80211]

Removing _sync is ok, because if led_on work is currently running
it will be finished before led_off work start to perform, since
they are always queued on the same mac80211 local->workqueue.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=795176

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtl818x/rtl8187/leds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rtl818x/rtl8187/leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/leds.c
@@ -117,7 +117,7 @@ static void rtl8187_led_brightness_set(s
 			radio_on = true;
 		} else if (radio_on) {
 			radio_on = false;
-			cancel_delayed_work_sync(&priv->led_on);
+			cancel_delayed_work(&priv->led_on);
 			ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
 		}
 	} else if (radio_on) {


