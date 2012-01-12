Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2ALMQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 07:16:15 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:3387 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab2ALMQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 07:16:14 -0500
From: Glauber Costa <glommer@parallels.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>
Subject: [PATCH] net: decrement memcg jump label when limit, not usage, is changed
Date: Thu, 12 Jan 2012 16:16:06 +0400
Message-Id: <1326370566-4286-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic of the current code is that whenever we destroy
a cgroup that had its limit set (set meaning different than
maximum), we should decrement the jump_label counter.
Otherwise we assume it was never incremented.

But what the code actually does is test for RES_USAGE
instead of RES_LIMIT. Usage being different than maximum
is likely to be true most of the time.

The effect of this is that the key must become negative,
and since the jump_label test says:

        !!atomic_read(&key->enabled);

we'll have jump_labels still on when no one else is
using this functionality.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index 7fed04f..4997878 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -108,7 +108,7 @@ void tcp_destroy_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	tcp = tcp_from_cgproto(cg_proto);
 	percpu_counter_destroy(&tcp->tcp_sockets_allocated);
 
-	val = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_USAGE);
+	val = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_LIMIT);
 
 	if (val != RESOURCE_MAX)
 		jump_label_dec(&memcg_socket_limit_enabled);
-- 
1.7.7.4

