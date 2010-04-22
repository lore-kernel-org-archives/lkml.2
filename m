Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab0DVUYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:24:52 -0400
Received: from kroah.org ([198.145.64.141]:59646 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970Ab0DVUAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:12 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:09 2010
Message-Id: <20100422195409.382551496@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Javier Cardona <javier@cozybit.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [046/139] mac80211: Handle mesh action frames in ieee80211_rx_h_action
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit 1cb561f83793191cf86a2db3948d28f5f42df9ff upstream.

This fixes the problem introduced in commit
8404080568613d93ad7cf0a16dfb68 which broke mesh peer link establishment.

changes:
v2 	Added missing break (Johannes)
v3 	Broke original patch into two (Johannes)

Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/mesh.c |    3 ---
 net/mac80211/rx.c   |    5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -749,9 +749,6 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_ACTION:
-		if (skb->len < IEEE80211_MIN_ACTION_SIZE)
-			return RX_DROP_MONITOR;
-		/* fall through */
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
 		skb_queue_tail(&ifmsh->skb_queue, skb);
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2355,6 +2355,11 @@ static int prepare_for_handlers(struct i
 		/* should never get here */
 		WARN_ON(1);
 		break;
+	case MESH_PLINK_CATEGORY:
+	case MESH_PATH_SEL_CATEGORY:
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
+		break;
 	}
 
 	return 1;


