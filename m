Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1IGE0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 00:26:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43092 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1IGEZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 00:25:59 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, containers@lists.osdl.org, netdev@vger.kernel.org,
        xemul@parallels.com, Glauber Costa <glommer@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH v2 8/9] Display current tcp memory allocation in kmem cgroup
Date: Wed,  7 Sep 2011 01:23:18 -0300
Message-Id: <1315369399-3073-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315369399-3073-1-git-send-email-glommer@parallels.com>
References: <1315369399-3073-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces kmem.tcp_current_memory file, living in the
kmem_cgroup filesystem. It is a simple read-only file that displays the
amount of kernel memory currently consumed by the cgroup.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: David S. Miller <davem@davemloft.net>
CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
---
 net/ipv4/tcp.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e1918fa..ff5c0e0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -365,12 +365,29 @@ static u64 tcp_read_maxmem(struct cgroup *cgrp, struct cftype *cft)
 	return ret;
 }
 
+static u64 tcp_read_curmem(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct kmem_cgroup *sg = kcg_from_cgroup(cgrp);
+	u64 ret;
+
+	if (!cgroup_lock_live_group(cgrp))
+		return -ENODEV;
+	ret = atomic_long_read(&sg->tcp_memory_allocated);
+
+	cgroup_unlock();
+	return ret;
+}
+
 static struct cftype tcp_files[] = {
 	{
 		.name = "tcp_maxmem",
 		.write_u64 = tcp_write_maxmem,
 		.read_u64 = tcp_read_maxmem,
 	},
+	{
+		.name = "tcp_current_memory",
+		.read_u64 = tcp_read_curmem,
+	},
 };
 
 int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
-- 
1.7.6

