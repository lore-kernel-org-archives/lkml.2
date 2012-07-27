Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2G0PjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab2G0PjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:39:17 -0400
From: Cong Wang <amwang@redhat.com>
To: netdev@vger.kernel.org
Cc: Cong Wang <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] netpoll: use GFP_ATOMIC in slave_enable_netpoll() and __netpoll_setup()
Date: Fri, 27 Jul 2012 23:37:58 +0800
Message-Id: <1343403484-29347-2-git-send-email-amwang@redhat.com>
In-Reply-To: <1343403484-29347-1-git-send-email-amwang@redhat.com>
References: <1343403484-29347-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slave_enable_netpoll() and __netpoll_setup() may be called
with read_lock() held, so should use GFP_ATOMIC to allocate
memory.

Cc: "David S. Miller" <davem@davemloft.net>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/net/bonding/bond_main.c |    2 +-
 net/core/netpoll.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6fae5f3..ab773d4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1235,7 +1235,7 @@ static inline int slave_enable_netpoll(struct slave *slave)
 	struct netpoll *np;
 	int err = 0;
 
-	np = kzalloc(sizeof(*np), GFP_KERNEL);
+	np = kzalloc(sizeof(*np), GFP_ATOMIC);
 	err = -ENOMEM;
 	if (!np)
 		goto out;
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index b4c90e4..c78a966 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -734,7 +734,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 	}
 
 	if (!ndev->npinfo) {
-		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
+		npinfo = kmalloc(sizeof(*npinfo), GFP_ATOMIC);
 		if (!npinfo) {
 			err = -ENOMEM;
 			goto out;
-- 
1.7.7.6

