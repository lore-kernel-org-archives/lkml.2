Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0LHBvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:51:49 -0500
Received: from kroah.org ([198.145.64.141]:48618 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab0LHA7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:50 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:27 2010
Message-Id: <20101208005726.926831115@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes@sipsolutions.net>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [056/289] mac80211: clear txflags for ps-filtered frames
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit eb7d3066cf864342e8ae6a5c1126a1602c4d06c0 upstream.

This patch fixes stale mac80211_tx_control_flags for
filtered / retried frames.

Because ieee80211_handle_filtered_frame feeds skbs back
into the tx path, they have to be stripped of some tx
flags so they won't confuse the stack, driver or device.

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/mac80211.h |   16 ++++++++++++++++
 net/mac80211/status.c  |    1 +
 2 files changed, 17 insertions(+)

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -315,6 +315,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
  * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
  *	frame and selects the maximum number of streams that it can use.
+ *
+ * Note: If you have to add new flags to the enumeration, then don't
+ *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -344,6 +347,19 @@ enum mac80211_tx_control_flags {
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
 
+/*
+ * This definition is used as a mask to clear all temporary flags, which are
+ * set by the tx handlers for each transmission attempt by the mac80211 stack.
+ */
+#define IEEE80211_TX_TEMPORARY_FLAGS (IEEE80211_TX_CTL_NO_ACK |		      \
+	IEEE80211_TX_CTL_CLEAR_PS_FILT | IEEE80211_TX_CTL_FIRST_FRAGMENT |    \
+	IEEE80211_TX_CTL_SEND_AFTER_DTIM | IEEE80211_TX_CTL_AMPDU |	      \
+	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
+	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
+	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_PSPOLL_RESPONSE | \
+	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
+	IEEE80211_TX_CTL_STBC)
+
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
  *	Rate Control algorithm.
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -58,6 +58,7 @@ static void ieee80211_handle_filtered_fr
 	info->control.vif = &sta->sdata->vif;
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING |
 		       IEEE80211_TX_INTFL_RETRANSMISSION;
+	info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
 
 	sta->tx_filtered_count++;
 


