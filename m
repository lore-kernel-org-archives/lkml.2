Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1GLXiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:38:01 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58737 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754126Ab1GLXhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:37:45 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: dhowells@redhat.com, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [RFC PATCH 06/14] user namespace: make each net (net_ns) belong to a user_ns
Date: Tue, 12 Jul 2011 23:30:44 +0000
Message-Id: <1310513452-13397-7-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310513452-13397-1-git-send-email-serge@hallyn.com>
References: <1310513452-13397-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serge.hallyn@canonical.com>

This way we can target capabilites at the user_ns which created the
net ns.

Changelog:
   jul 8: nsproxy: don't assign netns->userns if not cloning.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/net_namespace.h |    2 ++
 kernel/nsproxy.c            |    2 ++
 net/core/net_namespace.c    |    3 +++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index aef430d..0664fff 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -29,6 +29,7 @@ struct ctl_table_header;
 struct net_generic;
 struct sock;
 struct netns_ipvs;
+struct user_namespace;
 
 
 #define NETDEV_HASHBITS    8
@@ -100,6 +101,7 @@ struct net {
 	struct netns_xfrm	xfrm;
 #endif
 	struct netns_ipvs	*ipvs;
+	struct user_namespace	*user_ns;
 };
 
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index a687405..d3e5b7e 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -95,6 +95,8 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		err = PTR_ERR(new_nsp->net_ns);
 		goto out_net;
 	}
+	if (flags & CLONE_NEWNET)
+		new_nsp->net_ns->user_ns = get_user_ns(task_cred_xxx(tsk, user_ns));
 
 	return new_nsp;
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index ea489db..2b5a4cb 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -10,6 +10,7 @@
 #include <linux/nsproxy.h>
 #include <linux/proc_fs.h>
 #include <linux/file.h>
+#include <linux/user_namespace.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
@@ -208,6 +209,7 @@ static void net_free(struct net *net)
 	}
 #endif
 	kfree(net->gen);
+	put_user_ns(net->user_ns);
 	kmem_cache_free(net_cachep, net);
 }
 
@@ -388,6 +390,7 @@ static int __init net_ns_init(void)
 	rcu_assign_pointer(init_net.gen, ng);
 
 	mutex_lock(&net_mutex);
+	init_net.user_ns = &init_user_ns;
 	if (setup_net(&init_net))
 		panic("Could not setup the initial network namespace");
 
-- 
1.7.4.1

