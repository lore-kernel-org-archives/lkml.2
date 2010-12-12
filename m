Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0LLXpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44589 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0LLXpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: johannes.berg@intel.com, hkwynn@candelatech.com, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [10/223] cfg80211: fix BSS double-unlinking
Message-Id: <20101212234505.4E1B8B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Johannes Berg <johannes.berg@intel.com>

commit 3207390a8b58bfc1335750f91cf6783c48ca19ca upstream.

When multiple interfaces are actively trying
to associate with the same BSS, they may both
find that the BSS isn't there and then try to
unlink it. This can cause errors since the
unlinking code can't currently deal with items
that have already been unlinked.

Normally this doesn't happen as most people
don't try to use multiple station interfaces
that associate at the same time too.

Fix this by using the list entry as a flag to
see if the item is still on a list.

Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Hun-Kyi Wynn <hkwynn@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/wireless/scan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/net/wireless/scan.c
===================================================================
--- linux.orig/net/wireless/scan.c
+++ linux/net/wireless/scan.c
@@ -650,14 +650,14 @@ void cfg80211_unlink_bss(struct wiphy *w
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
 	spin_lock_bh(&dev->bss_lock);
+	if (!list_empty(&bss->list)) {
+		list_del_init(&bss->list);
+		dev->bss_generation++;
+		rb_erase(&bss->rbn, &dev->bss_tree);
 
-	list_del(&bss->list);
-	dev->bss_generation++;
-	rb_erase(&bss->rbn, &dev->bss_tree);
-
+		kref_put(&bss->ref, bss_release);
+	}
 	spin_unlock_bh(&dev->bss_lock);
-
-	kref_put(&bss->ref, bss_release);
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 
