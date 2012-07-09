Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2GIOiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38236 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302Ab2GIOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:15 -0400
Message-Id: <20120709143121.743971024@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 35/48] dummy: fix rcu_sched self-detected stalls
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 16b0dc29c1af9df341428f4c49ada4f626258082 ]

Trying to "modprobe dummy numdummies=30000" triggers :

INFO: rcu_sched self-detected stall on CPU { 8} (t=60000 jiffies)

After this splat, RTNL is locked and reboot is needed.

We must call cond_resched() to avoid this, even holding RTNL.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/dummy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index eeac9ca..87e4632 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -186,8 +186,10 @@ static int __init dummy_init_module(void)
 	rtnl_lock();
 	err = __rtnl_link_register(&dummy_link_ops);
 
-	for (i = 0; i < numdummies && !err; i++)
+	for (i = 0; i < numdummies && !err; i++) {
 		err = dummy_init_one();
+		cond_resched();
+	}
 	if (err < 0)
 		__rtnl_link_unregister(&dummy_link_ops);
 	rtnl_unlock();


