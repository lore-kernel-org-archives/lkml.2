Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab1DNSD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:03:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:42308 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965052Ab1DNR7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 198/209] x25: Do not reference freed memory.
Date: Thu, 14 Apr 2011 13:55:56 -0400
Message-Id: <1302803767-9715-85-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 96642d42f076101ba98866363d908cab706d156c upstream.

In x25_link_free(), we destroy 'nb' before dereferencing
'nb->dev'.  Don't do this, because 'nb' might be freed
by then.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/x25/x25_link.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index b25c646..88048b6 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -392,9 +392,12 @@ void __exit x25_link_free(void)
 	write_lock_bh(&x25_neigh_list_lock);
 
 	list_for_each_safe(entry, tmp, &x25_neigh_list) {
+		struct net_device *dev;
+
 		nb = list_entry(entry, struct x25_neigh, node);
+		dev = nb->dev;
 		__x25_remove_neigh(nb);
-		dev_put(nb->dev);
+		dev_put(dev);
 	}
 	write_unlock_bh(&x25_neigh_list_lock);
 }
-- 
1.7.4.4

