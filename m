Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0LHByt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:54:49 -0500
Received: from kroah.org ([198.145.64.141]:48541 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915Ab0LHA7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:36 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005725.539596499@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [042/289] cfg80211: fix BSS double-unlinking
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/wireless/scan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
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
 


