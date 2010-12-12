Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab0LMAbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:31:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44663 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab0LLXpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:20 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: lrodriguez@atheros.com, pstew@google.com, amod.bodas@atheros.com,
        linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [23/223] mac80211: reset probe send counter upon connection timer reset
Message-Id: <20101212234519.11D3EB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 0c699c3a75d4e8d0d2c317f83048d8fd3ffe692a upstream.

Upon beacon loss we send probe requests after 30 seconds of idle
time and we wait for each probe response 1/2 second. We send a
total of 3 probe requests before giving up on the AP. In the case
that we reset the connection idle monitor we should reset the probe
requests count to 0. Right now this won't help in any way but
the next patch will.

This patch has fixes for stable kernel [2.6.35+].

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/mlme.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/net/mac80211/mlme.c
===================================================================
--- linux.orig/net/mac80211/mlme.c
+++ linux/net/mac80211/mlme.c
@@ -120,11 +120,15 @@ void ieee80211_sta_reset_beacon_monitor(
 
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
 		return;
 
 	mod_timer(&sdata->u.mgd.conn_mon_timer,
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
+
+	ifmgd->probe_send_count = 0;
 }
 
 static int ecw2cw(int ecw)
