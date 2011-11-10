Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab1KJPr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:47:56 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32118 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705Ab1KJPrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:47:55 -0500
From: Andrew Vagin <avagin@openvz.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, devel@openvz.org,
        avagin@openvz.org
Subject: [PATCH] bridge: Fix potential deadlock on br->multicast_lock
Date: Thu, 10 Nov 2011 18:48:03 +0300
Message-Id: <1320940083-3719823-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

multicast_lock is taken in softirq context, so we should use
spin_lock_bh() in userspace.

call-chain in softirq context:
run_timer_softirq()
	br_multicast_query_expired()

call-chain in userspace:
sysfs_write_file()
	store_multicast_snooping()
		br_multicast_toggle()

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 net/bridge/br_multicast.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 995cbe0..2eefe27 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1770,7 +1770,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 	int err = 0;
 	struct net_bridge_mdb_htable *mdb;
 
-	spin_lock(&br->multicast_lock);
+	spin_lock_bh(&br->multicast_lock);
 	if (br->multicast_disabled == !val)
 		goto unlock;
 
@@ -1806,7 +1806,7 @@ rollback:
 	}
 
 unlock:
-	spin_unlock(&br->multicast_lock);
+	spin_unlock_bh(&br->multicast_lock);
 
 	return err;
 }
-- 
1.7.1

