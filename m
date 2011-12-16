Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253Ab1LPJbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:31:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59596 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876Ab1LPJbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:31:14 -0500
Message-ID: <1324027869.2273.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH v2] net: fix sleeping while atomic problem in sock
 mem_cgroup.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Fri, 16 Dec 2011 10:31:09 +0100
In-Reply-To: <1324026582-5214-1-git-send-email-glommer@parallels.com>
References: <1324026582-5214-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 13:09 +0400, Glauber Costa a écrit :
> Since we can't scan the proto_list to initialize sock cgroups, as it
> holds a rwlock, and we also want to keep the code generic enough to
> avoid calling the initialization functions of protocols directly,
> I propose we keep the interested parties in a separate list. This list
> is protected by a mutex so we can sleep and do the necessary allocations.
> 
> Also fixes a reference problem found by Randy Dunlap's randconfig.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Stephen Rothwell <sfr@canb.auug.org.au>
> CC: Randy Dunlap <rdunlap@xenotime.net>
> ---

Sorry to come late, but why dont we convert proto_list_lock to a mutex ?

 net/core/sock.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5a6a906..0c67fac 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -136,7 +136,7 @@
 #include <net/tcp.h>
 #endif
 
-static DEFINE_RWLOCK(proto_list_lock);
+static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
@@ -145,7 +145,7 @@ int mem_cgroup_sockets_init(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	struct proto *proto;
 	int ret = 0;
 
-	read_lock(&proto_list_lock);
+	mutex_lock(&proto_list_mutex);
 	list_for_each_entry(proto, &proto_list, node) {
 		if (proto->init_cgroup) {
 			ret = proto->init_cgroup(cgrp, ss);
@@ -154,13 +154,13 @@ int mem_cgroup_sockets_init(struct cgroup *cgrp, struct cgroup_subsys *ss)
 		}
 	}
 
-	read_unlock(&proto_list_lock);
+	mutex_unlock(&proto_list_mutex);
 	return ret;
 out:
 	list_for_each_entry_continue_reverse(proto, &proto_list, node)
 		if (proto->destroy_cgroup)
 			proto->destroy_cgroup(cgrp, ss);
-	read_unlock(&proto_list_lock);
+	mutex_unlock(&proto_list_mutex);
 	return ret;
 }
 
@@ -168,11 +168,11 @@ void mem_cgroup_sockets_destroy(struct cgroup *cgrp, struct cgroup_subsys *ss)
 {
 	struct proto *proto;
 
-	read_lock(&proto_list_lock);
+	mutex_lock(&proto_list_mutex);
 	list_for_each_entry_reverse(proto, &proto_list, node)
 		if (proto->destroy_cgroup)
 			proto->destroy_cgroup(cgrp, ss);
-	read_unlock(&proto_list_lock);
+	mutex_unlock(&proto_list_mutex);
 }
 #endif
 
@@ -2479,10 +2479,10 @@ int proto_register(struct proto *prot, int alloc_slab)
 		}
 	}
 
-	write_lock(&proto_list_lock);
+	mutex_lock(&proto_list_mutex);
 	list_add(&prot->node, &proto_list);
 	assign_proto_idx(prot);
-	write_unlock(&proto_list_lock);
+	mutex_unlock(&proto_list_mutex);
 	return 0;
 
 out_free_timewait_sock_slab_name:
@@ -2505,10 +2505,10 @@ EXPORT_SYMBOL(proto_register);
 
 void proto_unregister(struct proto *prot)
 {
-	write_lock(&proto_list_lock);
+	mutex_lock(&proto_list_mutex);
 	release_proto_idx(prot);
 	list_del(&prot->node);
-	write_unlock(&proto_list_lock);
+	mutex_unlock(&proto_list_mutex);
 
 	if (prot->slab != NULL) {
 		kmem_cache_destroy(prot->slab);
@@ -2531,9 +2531,9 @@ EXPORT_SYMBOL(proto_unregister);
 
 #ifdef CONFIG_PROC_FS
 static void *proto_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(proto_list_lock)
+	__acquires(proto_list_mutex)
 {
-	read_lock(&proto_list_lock);
+	mutex_lock(&proto_list_mutex);
 	return seq_list_start_head(&proto_list, *pos);
 }
 
@@ -2543,9 +2543,9 @@ static void *proto_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void proto_seq_stop(struct seq_file *seq, void *v)
-	__releases(proto_list_lock)
+	__releases(proto_list_mutex)
 {
-	read_unlock(&proto_list_lock);
+	mutex_unlock(&proto_list_mutex);
 }
 
 static char proto_method_implemented(const void *method)


