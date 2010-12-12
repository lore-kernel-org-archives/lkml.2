Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0LLXpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44620 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0LLXpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:11 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: j@w1.fi, linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [15/223] mac80211: Fix signal strength average initialization for CQM events
Message-Id: <20101212234510.9478EB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jouni Malinen <j@w1.fi>

commit 3ba06c6fbd651ed3377e584026d1c112b492cc8b upstream.

The ave_beacon_signal value uses 1/16 dB unit and as such, must be
initialized with the signal level of the first Beacon frame multiplied
by 16. This fixes an issue where the initial CQM events are reported
incorrectly with a burst of events while the running average
approaches the correct value after the incorrect initialization. This
could cause user space -based roaming decision process to get quite
confused at the moment when we would like to go through authentication
and DHCP.

Signed-off-by: Jouni Malinen <j@w1.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/net/mac80211/mlme.c
===================================================================
--- linux.orig/net/mac80211/mlme.c
+++ linux/net/mac80211/mlme.c
@@ -1488,7 +1488,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	ifmgd->last_beacon_signal = rx_status->signal;
 	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
 		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
-		ifmgd->ave_beacon_signal = rx_status->signal;
+		ifmgd->ave_beacon_signal = rx_status->signal * 16;
 		ifmgd->last_cqm_event_signal = 0;
 	} else {
 		ifmgd->ave_beacon_signal =
