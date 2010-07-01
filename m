Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab0GAWO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:14:26 -0400
Received: from kroah.org ([198.145.64.141]:47350 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610Ab0GAUt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:59 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:30 2010
Message-Id: <20100701173430.801671902@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 047/164] mac80211: fix handling of 4-address-mode in ieee80211_change_iface
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit f7917af92024d43bc20bc1afc92de27b0bd0f50b upstream.

A misplaced interface type check bails out too early if the interface
is not in monitor mode. This patch moves it to the right place, so that
it only covers changes to the monitor flags.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/cfg.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -98,9 +98,6 @@ static int ieee80211_change_iface(struct
 					    params->mesh_id_len,
 					    params->mesh_id);
 
-	if (sdata->vif.type != NL80211_IFTYPE_MONITOR || !flags)
-		return 0;
-
 	if (type == NL80211_IFTYPE_AP_VLAN &&
 	    params && params->use_4addr == 0)
 		rcu_assign_pointer(sdata->u.vlan.sta, NULL);
@@ -108,7 +105,9 @@ static int ieee80211_change_iface(struct
 		 params && params->use_4addr >= 0)
 		sdata->u.mgd.use_4addr = params->use_4addr;
 
-	sdata->u.mntr_flags = *flags;
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags)
+		sdata->u.mntr_flags = *flags;
+
 	return 0;
 }
 


