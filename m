Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab1LPUBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:01:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab1LPTv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:10 2011
Message-Id: <20111216194210.397825100@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <greg@kroah.com>,
        Nikolay Martynov <mar.kolya@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [22/45] mac80211: fix race condition caused by late addBA response
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Nikolay Martynov <mar.kolya@gmail.com>

Upstream commit d305a6557b2c4dca0110f05ffe745b1ef94adb80.

If addBA responses comes in just after addba_resp_timer has
expired mac80211 will still accept it and try to open the
aggregation session. This causes drivers to be confused and
in some cases even crash.

This patch fixes the race condition and makes sure that if
addba_resp_timer has expired addBA response is not longer
accepted and we do not try to open half-closed session.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
[some adjustments]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/agg-tx.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -792,12 +792,27 @@ void ieee80211_process_addba_resp(struct
 		goto out;
 	}
 
-	del_timer(&tid_tx->addba_resp_timer);
+	del_timer_sync(&tid_tx->addba_resp_timer);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
 #endif
 
+	/*
+	 * addba_resp_timer may have fired before we got here, and
+	 * caused WANT_STOP to be set. If the stop then was already
+	 * processed further, STOPPING might be set.
+	 */
+	if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state) ||
+	    test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG
+		       "got addBA resp for tid %d but we already gave up\n",
+		       tid);
+#endif
+		goto out;
+	}
+
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
 			== WLAN_STATUS_SUCCESS) {
 		/*


