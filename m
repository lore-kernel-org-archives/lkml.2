Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2BAGxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:53:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50496 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2BAGxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:53:19 -0500
Message-ID: <4F28E203.10502@cn.fujitsu.com>
Date: Wed, 01 Feb 2012 14:56:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 4/6] netprio_cgroup: use IS_ENABLED() and family
References: <4F28E1D1.900@cn.fujitsu.com>
In-Reply-To: <4F28E1D1.900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 14:51:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 14:51:58,
	Serialize complete at 2012-02-01 14:51:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove unused net_prio_subsys_id and sock->sk_cgrp->prioidx
when CGROUPS=y and NETPRIO_CGROUP=n

- don't use "ifndef CONFIG_NETPRIO_CGROUP" to suggest it's
a module, use IS_MODULE().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/net/netprio_cgroup.h |   23 ++++++-----------------
 include/net/sock.h           |    2 +-
 net/core/netprio_cgroup.c    |    7 +++----
 net/core/sock.c              |    7 +++++--
 4 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/include/net/netprio_cgroup.h b/include/net/netprio_cgroup.h
index d58fdec..8d09944 100644
--- a/include/net/netprio_cgroup.h
+++ b/include/net/netprio_cgroup.h
@@ -24,18 +24,16 @@ struct netprio_map {
 	u32 priomap[];
 };
 
-#ifdef CONFIG_CGROUPS
-
+#if IS_ENABLED(CONFIG_NETPRIO_CGROUP)
 struct cgroup_netprio_state {
 	struct cgroup_subsys_state css;
 	u32 prioidx;
 };
 
-#ifndef CONFIG_NETPRIO_CGROUP
-extern int net_prio_subsys_id;
-#endif
-
 extern void sock_update_netprioidx(struct sock *sk);
+#else
+static inline void sock_update_netprioidx(struct sock *sk) {}
+#endif
 
 #if IS_BUILTIN(CONFIG_NETPRIO_CGROUP)
 
@@ -54,6 +52,8 @@ static inline u32 task_netprioidx(struct task_struct *p)
 
 #elif IS_MODULE(CONFIG_NETPRIO_CGROUP)
 
+extern int net_prio_subsys_id;
+
 static inline u32 task_netprioidx(struct task_struct *p)
 {
 	struct cgroup_netprio_state *state;
@@ -72,17 +72,6 @@ static inline u32 task_netprioidx(struct task_struct *p)
 	return idx;
 }
 
-#else
-
-static inline u32 task_netprioidx(struct task_struct *p)
-{
-	return 0;
-}
-
 #endif /* CONFIG_NETPRIO_CGROUP */
 
-#else
-#define sock_update_netprioidx(sk)
-#endif
-
 #endif  /* _NET_CLS_CGROUP_H */
diff --git a/include/net/sock.h b/include/net/sock.h
index 91c1c8b..b08a44e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -342,7 +342,7 @@ struct sock {
 	unsigned short		sk_ack_backlog;
 	unsigned short		sk_max_ack_backlog;
 	__u32			sk_priority;
-#ifdef CONFIG_CGROUPS
+#if IS_ENABLED(CONFIG_NETPRIO_CGROUP)
 	__u32			sk_cgrp_prioidx;
 #endif
 	struct pid		*sk_peer_pid;
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 2edfa6b..95ab29a 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -33,7 +33,7 @@ struct cgroup_subsys net_prio_subsys = {
 	.create		= cgrp_create,
 	.destroy	= cgrp_destroy,
 	.populate	= cgrp_populate,
-#ifdef CONFIG_NETPRIO_CGROUP
+#if IS_BUILTIN(CONFIG_NETPRIO_CGROUP)
 	.subsys_id	= net_prio_subsys_id,
 #endif
 	.module		= THIS_MODULE
@@ -298,7 +298,7 @@ static int __init init_cgroup_netprio(void)
 	ret = cgroup_load_subsys(&net_prio_subsys);
 	if (ret)
 		goto out;
-#ifndef CONFIG_NETPRIO_CGROUP
+#if IS_MODULE(CONFIG_NETPRIO_CGROUP)
 	smp_wmb();
 	net_prio_subsys_id = net_prio_subsys.subsys_id;
 #endif
@@ -318,11 +318,10 @@ static void __exit exit_cgroup_netprio(void)
 
 	cgroup_unload_subsys(&net_prio_subsys);
 
-#ifndef CONFIG_NETPRIO_CGROUP
+#if IS_MODULE(CONFIG_NETPRIO_CGROUP)
 	net_prio_subsys_id = -1;
 	synchronize_rcu();
 #endif
-
 	rtnl_lock();
 	for_each_netdev(&init_net, dev) {
 		old = rtnl_dereference(dev->priomap);
diff --git a/net/core/sock.c b/net/core/sock.c
index 02f8dfe..76df203 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -272,11 +272,12 @@ EXPORT_SYMBOL(sysctl_optmem_max);
 int net_cls_subsys_id = -1;
 EXPORT_SYMBOL_GPL(net_cls_subsys_id);
 #endif
-#if !defined(CONFIG_NETPRIO_CGROUP)
+#endif
+
+#if IS_MODULE(CONFIG_NETPRIO_CGROUP)
 int net_prio_subsys_id = -1;
 EXPORT_SYMBOL_GPL(net_prio_subsys_id);
 #endif
-#endif
 
 static int sock_set_timeout(long *timeo_p, char __user *optval, int optlen)
 {
@@ -1168,7 +1169,9 @@ void sock_update_classid(struct sock *sk)
 		sk->sk_classid = classid;
 }
 EXPORT_SYMBOL(sock_update_classid);
+#endif
 
+#if IS_ENABLED(CONFIG_NETPRIO_CGROUP)
 void sock_update_netprioidx(struct sock *sk)
 {
 	if (in_interrupt())
-- 
1.7.3.1
