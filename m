Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab0JVTQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:16:52 -0400
Received: from kroah.org ([198.145.64.141]:34100 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322Ab0JVS4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:22 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:31 2010
Message-Id: <20101022185230.933239751@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [040/103] mac80211: fix use-after-free
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit cd87a2d3a33d75a646f1aa1aa2ee5bf712d6f963 upstream.

commit 8c0c709eea5cbab97fb464cd68b06f24acc58ee1
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Nov 25 17:46:15 2009 +0100

    mac80211: move cmntr flag out of rx flags

moved the CMTR flag into the skb's status, and
in doing so introduced a use-after-free -- when
the skb has been handed to cooked monitors the
status setting will touch now invalid memory.

Additionally, moving it there has effectively
discarded the optimisation -- since the bit is
only ever set on freed SKBs, and those were a
copy, it could never be checked.

For the current release, fixing this properly
is a bit too involved, so let's just remove the
problematic code and leave userspace with one
copy of each frame for each virtual interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2156,9 +2156,6 @@ static void ieee80211_rx_cooked_monitor(
 	struct net_device *prev_dev = NULL;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	if (status->flag & RX_FLAG_INTERNAL_CMTR)
-		goto out_free_skb;
-
 	if (skb_headroom(skb) < sizeof(*rthdr) &&
 	    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC))
 		goto out_free_skb;
@@ -2217,7 +2214,6 @@ static void ieee80211_rx_cooked_monitor(
 	} else
 		goto out_free_skb;
 
-	status->flag |= RX_FLAG_INTERNAL_CMTR;
 	return;
 
  out_free_skb:


