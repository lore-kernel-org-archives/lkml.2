Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2FOAAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab2FNX76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:58 -0400
Message-Id: <20120614235625.864991902@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eyal Shapira <eyal@wizery.com>,
        Arik Nemtsov <arik@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 22/42] mac80211: fix non RCU-safe sta_list manipulation
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arik Nemtsov <arik@wizery.com>

commit 794454ce72a298de6f4536ade597bdcc7dcde7c7 upstream.

sta_info_cleanup locks the sta_list using rcu_read_lock however
the delete operation isn't rcu safe. A race between sta_info_cleanup
timer being called and a STA being removed can occur which leads
to a panic while traversing sta_list. Fix this by switching to the
RCU-safe versions.

Reported-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/sta_info.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -378,7 +378,7 @@ static int sta_info_insert_finish(struct
 	/* make the station visible */
 	sta_info_hash_add(local, sta);
 
-	list_add(&sta->list, &local->sta_list);
+	list_add_rcu(&sta->list, &local->sta_list);
 
 	set_sta_flag(sta, WLAN_STA_INSERTED);
 
@@ -688,7 +688,7 @@ int __must_check __sta_info_destroy(stru
 	if (ret)
 		return ret;
 
-	list_del(&sta->list);
+	list_del_rcu(&sta->list);
 
 	mutex_lock(&local->key_mtx);
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++)


