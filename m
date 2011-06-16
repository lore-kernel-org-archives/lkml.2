Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1FPHEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:04:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42246 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929Ab1FPHBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:43 -0400
X-Sasl-enc: LIshzJ1DVyUewtMmYo9FVQEcuZQrJK0krSLVY8y+F02J 1308207702
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:36 2011
Message-Id: <20110616000236.734683352@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [79/89] mac80211: fix IBSS teardown race
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit f3209bea110cade12e2b133da8b8499689cb0e2e upstream.

Ignacy reports that sometimes after leaving an IBSS
joining a new one didn't work because there still
were stations on the list. He fixed it by flushing
stations when attempting to join a new IBSS, but
this shouldn't be happening in the first case. When
I looked into it I saw a race condition in teardown
that could cause stations to be added after flush,
and thus cause this situation. Ignacy confirms that
after applying my patch he hasn't seen this happen
again.

Reported-by: Ignacy Gawedzki <i@lri.fr>
Debugged-by: Ignacy Gawedzki <i@lri.fr>
Tested-by: Ignacy Gawedzki <i@lri.fr>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ibss.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -967,6 +967,10 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
+	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
+	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
+	sdata->u.ibss.ssid_len = 0;
+
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -1000,8 +1004,6 @@ int ieee80211_ibss_leave(struct ieee8021
 	kfree_skb(skb);
 
 	skb_queue_purge(&sdata->skb_queue);
-	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
-	sdata->u.ibss.ssid_len = 0;
 
 	del_timer_sync(&sdata->u.ibss.timer);
 


