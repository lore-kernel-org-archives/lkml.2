Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0LLXpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44615 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0LLXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:10 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: lrodriguez@atheros.com, amod.bodas@atheros.com,
        vasanth.thiagarajan@atheros.com, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [14/223] mac80211: fix offchannel assumption upon association
Message-Id: <20101212234509.86FD6B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 8d4780eb1ece4e8109b4f6b2e5e61f7fc593c3f4 upstream.

Association is dealt with as an atomic offchannel operation,
we do this because we don't know we are associated until we
get the associatin response from the AP. When we do get the
associatin response though we were never clearing the offchannel
state. This has a few implications, we told drivers we were
still offchannel, and the first configured TX power for the
channel does not take into account any power constraints.

For ath9k this meant ANI calibration would not start upon
association, and we'd have to wait until the first bgscan
to be triggered. There may be other issues this resolves
but I'm too lazy to comb the code to check.

Cc: Amod Bodas <amod.bodas@atheros.com>
Cc: Vasanth Thiagarajan <vasanth.thiagarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/net/mac80211/main.c
===================================================================
--- linux.orig/net/mac80211/main.c
+++ linux/net/mac80211/main.c
@@ -106,7 +106,8 @@ int ieee80211_hw_config(struct ieee80211
 	if (scan_chan) {
 		chan = scan_chan;
 		channel_type = NL80211_CHAN_NO_HT;
-	} else if (local->tmp_channel) {
+	} else if (local->tmp_channel &&
+		   local->oper_channel != local->tmp_channel) {
 		chan = scan_chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
 	} else {
