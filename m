Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162395Ab2GLWwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:52:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52765 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162257Ab2GLWo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:44:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Manschwetus <manschwetus@googlemail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 161/187] mac80211: fix queues stuck issue with HT bandwidth change
Date: Thu, 12 Jul 2012 15:35:17 -0700
Message-Id: <20120712191538.273855024@linuxfoundation.org>
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


From: Johannes Berg <johannes.berg@intel.com>

No upstream commit, the buggy code was removed in 3.5 in commit
7213cf2cb0dfbb4d6b55a1da000d34338f76c0e3 and others.

Rajkumar changed code for handling channel switching in
mac80211 to stop the queues in

  commit 7cc44ed48d0ec0937c1f098642540b6c9ca38de5
  Author: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
  Date:   Fri Sep 16 15:32:34 2011 +0530

      mac80211: Fix regression on queue stop during 2040 bss change

which went into 3.2. In the 3.4 cycle, Paul's change

  commit 3117bbdb7899d43927c8ce4fe885ab7c1231c121
  Author: Paul Stewart <pstew@chromium.org>
  Date:   Tue Mar 13 07:46:18 2012 -0700

      mac80211: Don't let regulatory make us deaf

went in and changed the TX/RX enable logic, but now
the conditions for stopping and restarting the queues
were different so that now, if the AP changes between
20/40 MHz bandwidth, it can happen that we stop but
never restart the queues. This breaks the connection
and the module actually has to be reloaded to get it
back to work.

Fix this by making sure the queues are always started
when they were stopped.

Reported-by: Florian Manschwetus <manschwetus@googlemail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -187,7 +187,7 @@ static u32 ieee80211_enable_ht(struct ie
 	u32 changed = 0;
 	int hti_cfreq;
 	u16 ht_opmode;
-	bool enable_ht = true;
+	bool enable_ht = true, queues_stopped = false;
 	enum nl80211_channel_type prev_chantype;
 	enum nl80211_channel_type rx_channel_type = NL80211_CHAN_NO_HT;
 	enum nl80211_channel_type tx_channel_type;
@@ -254,6 +254,7 @@ static u32 ieee80211_enable_ht(struct ie
 		 */
 		ieee80211_stop_queues_by_reason(&sdata->local->hw,
 				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
+		queues_stopped = true;
 
 		/* flush out all packets */
 		synchronize_net();
@@ -272,12 +273,12 @@ static u32 ieee80211_enable_ht(struct ie
 						 IEEE80211_RC_HT_CHANGED,
 						 tx_channel_type);
 		rcu_read_unlock();
-
-		if (beacon_htcap_ie)
-			ieee80211_wake_queues_by_reason(&sdata->local->hw,
-				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
 	}
 
+	if (queues_stopped)
+		ieee80211_wake_queues_by_reason(&sdata->local->hw,
+			IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
+
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */


