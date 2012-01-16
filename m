Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2APIFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:05:04 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:11421 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab2APIFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:05:02 -0500
From: Glauber Costa <glommer@parallels.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] move sock_update_memcg outside of CONFIG_INET
Date: Mon, 16 Jan 2012 12:04:39 +0400
Message-Id: <1326701079-10331-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although only used currently for tcp sockets, this function
is now used in common sock code (for sock_clone())

Commit 475f1b52645a29936b9df1d8fcd45f7e56bd4a9f moved the
declaration of sock_update_clone() to inside sock.c, but
this only fixes the problem when CONFIG_CGROUP_MEM_RES_CTLR_KMEM
is also not defined.

This patch here is verified to fix both problems, although
reverting the previous one is not necessary.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: David S. Miller <davem@davemloft.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 602207b..3dbff4d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -373,7 +373,6 @@ static void mem_cgroup_put(struct mem_cgroup *memcg);
 
 /* Writing them here to avoid exposing memcg's inner layout */
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
-#ifdef CONFIG_INET
 #include <net/sock.h>
 #include <net/ip.h>
 
@@ -420,6 +419,7 @@ void sock_release_memcg(struct sock *sk)
 	}
 }
 
+#ifdef CONFIG_INET
 struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg)
 {
 	if (!memcg || mem_cgroup_is_root(memcg))
-- 
1.7.7.4

