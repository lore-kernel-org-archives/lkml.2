Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1KDWY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:24:56 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:45294 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab1KDWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:24:10 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: oleg@redhat.com, richard@nod.at, akpm@linux-foundation.org,
        ebiederm@xmission.com, serge@hallyn.com, dhowells@redhat.com,
        eparis@redhat.com, "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH 5/6] user namespace: make each net (net_ns) belong to a user_ns
Date: Fri,  4 Nov 2011 22:24:41 +0000
Message-Id: <1320445482-8459-6-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320445482-8459-1-git-send-email-serge@hallyn.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serge.hallyn@canonical.com>

The user namespace which creates a new network namespace owns that
namespace and all resources created in it.  This way we can target
capability checks for privileged operations against network resources to
the user_ns which created the network namespace in which the resource
lives.  Privilege to the user namespace which owns the network
namespace, or any parent user namespace thereof, provides the same
privilege to the network resource.

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
index 3bb6fa0..d91fe5f 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -29,6 +29,7 @@ struct ctl_table_header;
 struct net_generic;
 struct sock;
 struct netns_ipvs;
+struct user_namespace;
 
 
 #define NETDEV_HASHBITS    8
@@ -101,6 +102,7 @@ struct net {
 	struct netns_xfrm	xfrm;
 #endif
 	struct netns_ipvs	*ipvs;
+	struct user_namespace	*user_ns;
 };
 
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 9aeab4b..0d5bf8d 100644
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
index 5bbdbf0..791c19c 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -10,6 +10,7 @@
 #include <linux/nsproxy.h>
 #include <linux/proc_fs.h>
 #include <linux/file.h>
+#include <linux/user_namespace.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
@@ -209,6 +210,7 @@ static void net_free(struct net *net)
 	}
 #endif
 	kfree(net->gen);
+	put_user_ns(net->user_ns);
 	kmem_cache_free(net_cachep, net);
 }
 
@@ -389,6 +391,7 @@ static int __init net_ns_init(void)
 	rcu_assign_pointer(init_net.gen, ng);
 
 	mutex_lock(&net_mutex);
+	init_net.user_ns = &init_user_ns;
 	if (setup_net(&init_net))
 		panic("Could not setup the initial network namespace");
 
-- 
1.7.0.4

