Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab1LOVM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:12:29 -0500
Received: from mx2.parallels.com ([64.131.90.16]:39434 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab1LOVM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:12:28 -0500
Message-ID: <4EEA6288.1080405@parallels.com>
Date: Fri, 16 Dec 2011 01:11:36 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <eric.dumazet@gmail.com>, <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/2] Explicitly call tcp creation and init from memcontrol.c
References: <1323941672-14324-1-git-send-email-glommer@parallels.com> <1323941672-14324-3-git-send-email-glommer@parallels.com> <20111215.120028.532844419499092747.davem@davemloft.net>
In-Reply-To: <20111215.120028.532844419499092747.davem@davemloft.net>
Content-Type: multipart/mixed;
	boundary="------------090403050008060201020709"
X-Originating-IP: [83.149.8.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------090403050008060201020709
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/2011 09:00 PM, David Miller wrote:
> From: Glauber Costa<glommer@parallels.com>
> Date: Thu, 15 Dec 2011 13:34:32 +0400
>
>> Walking the proto_list holds a read_lock, which prevents us from doing
>> allocations. Splitting the tcp create function into create + init is
>> good, but it is not enough since create_files will do allocations as well
>> (dentry ones, mostly).
>>
>> Since this does not involve any protocol state, I propose we call the tcp
>> functions explicitly from memcontrol.c
>>
>> With this, we lose by now the ability of doing cgroup memcontrol for
>> protocols that are loaded as modules. But at least the ones I have in mind
>> won't really need it (tcp_ipv6 being the only one, but it uses the same data
>> structures as tcp_ipv4). So I believe this to be the simpler solution to this
>> problem.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>
> This is an unnecessary limitation, please fix this properly otherwise
> DCCP, SCTP, etc. won't be supportable with this stuff.

How about the following patch then ? I am keeping protocols that has the 
cgroup stuff on in a separate list, that can be protected by a mutex. 
Therefore we can allocate without going into troubles.

Let me know if you still have objections, I'll be happy to address them.

--------------090403050008060201020709
Content-Type: text/plain;
	name="0001-fix-sleeping-while-atomic-problem-in-sock-mem_cgroup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-fix-sleeping-while-atomic-problem-in-sock-mem_cgroup.pa";
	filename*1="tch"

>From c8fe669a9cbc7c7cbd87ce48d7eb91ed6c96cbde Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@parallels.com>
Date: Thu, 15 Dec 2011 23:47:06 +0300
Subject: [PATCH] fix sleeping while atomic problem in sock mem_cgroup.

Since we can't scan the proto_list to initialize sock cgroups, as it
holds a rwlock, and we also want to keep the code generic enough to
avoid calling the initialization functions of protocols directly,
I propose we keep the interested parties in a separate list. This list
is protected by a mutex so we can sleep and do the necessary allocations.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/memcontrol.h   |    4 +++
 include/net/sock.h           |    5 +---
 include/net/tcp_memcontrol.h |    2 +
 mm/memcontrol.c              |   52 ++++++++++++++++++++++++++++++++++++++++++
 net/core/sock.c              |   48 +++++++++-----------------------------
 5 files changed, 70 insertions(+), 41 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9b296ea..1edd0e3 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -390,6 +390,10 @@ enum {
 	OVER_LIMIT,
 };
 
+struct proto;
+void register_sock_cgroup(struct proto *prot);
+void unregister_sock_cgroup(struct proto *prot);
+
 #ifdef CONFIG_INET
 struct sock;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
diff --git a/include/net/sock.h b/include/net/sock.h
index 6fe0dae..f8237a3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -64,10 +64,6 @@
 #include <net/dst.h>
 #include <net/checksum.h>
 
-struct cgroup;
-struct cgroup_subsys;
-int mem_cgroup_sockets_init(struct cgroup *cgrp, struct cgroup_subsys *ss);
-void mem_cgroup_sockets_destroy(struct cgroup *cgrp, struct cgroup_subsys *ss);
 /*
  * This structure really needs to be cleaned up.
  * Most of it is for TCP, and not used by any of
@@ -858,6 +854,7 @@ struct proto {
 	void			(*destroy_cgroup)(struct cgroup *cgrp,
 						  struct cgroup_subsys *ss);
 	struct cg_proto		*(*proto_cgroup)(struct mem_cgroup *memcg);
+	struct list_head	cgroup_node;
 #endif
 };
 
diff --git a/include/net/tcp_memcontrol.h b/include/net/tcp_memcontrol.h
index 3512082..5aa7c4b 100644
--- a/include/net/tcp_memcontrol.h
+++ b/include/net/tcp_memcontrol.h
@@ -11,6 +11,8 @@ struct tcp_memcontrol {
 	int tcp_memory_pressure;
 };
 
+struct cgroup;
+struct cgroup_subsys;
 struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg);
 int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss);
 void tcp_destroy_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7266202..6ee250d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4742,6 +4742,58 @@ static struct cftype kmem_cgroup_files[] = {
 	},
 };
 
+static DEFINE_MUTEX(cgroup_proto_list_lock);
+static LIST_HEAD(cgroup_proto_list);
+
+static int mem_cgroup_sockets_init(struct cgroup *cgrp, struct cgroup_subsys *ss)
+{
+	struct proto *proto;
+	int ret = 0;
+
+	mutex_lock(&cgroup_proto_list_lock);
+	list_for_each_entry(proto, &cgroup_proto_list, cgroup_node) {
+		if (proto->init_cgroup) {
+			ret = proto->init_cgroup(cgrp, ss);
+			if (ret)
+				goto out;
+		}
+	}
+
+	mutex_unlock(&cgroup_proto_list_lock);
+	return ret;
+out:
+	list_for_each_entry_continue_reverse(proto, &cgroup_proto_list, cgroup_node)
+		if (proto->destroy_cgroup)
+			proto->destroy_cgroup(cgrp, ss);
+	mutex_unlock(&cgroup_proto_list_lock);
+	return ret;
+}
+
+static void mem_cgroup_sockets_destroy(struct cgroup *cgrp, struct cgroup_subsys *ss)
+{
+	struct proto *proto;
+
+	mutex_lock(&cgroup_proto_list_lock);
+	list_for_each_entry_reverse(proto, &cgroup_proto_list, cgroup_node)
+		if (proto->destroy_cgroup)
+			proto->destroy_cgroup(cgrp, ss);
+	mutex_unlock(&cgroup_proto_list_lock);
+}
+
+void register_sock_cgroup(struct proto *prot)
+{
+	mutex_lock(&cgroup_proto_list_lock);
+	list_add(&prot->cgroup_node, &cgroup_proto_list);
+	mutex_unlock(&cgroup_proto_list_lock);
+}
+
+void unregister_sock_cgroup(struct proto *prot)
+{
+	mutex_lock(&cgroup_proto_list_lock);
+	list_del(&prot->cgroup_node);
+	mutex_unlock(&cgroup_proto_list_lock);
+}
+
 static int register_kmem_files(struct cgroup *cont, struct cgroup_subsys *ss)
 {
 	int ret = 0;
diff --git a/net/core/sock.c b/net/core/sock.c
index 5a6a906..3728b50 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -139,43 +139,6 @@
 static DEFINE_RWLOCK(proto_list_lock);
 static LIST_HEAD(proto_list);
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
-int mem_cgroup_sockets_init(struct cgroup *cgrp, struct cgroup_subsys *ss)
-{
-	struct proto *proto;
-	int ret = 0;
-
-	read_lock(&proto_list_lock);
-	list_for_each_entry(proto, &proto_list, node) {
-		if (proto->init_cgroup) {
-			ret = proto->init_cgroup(cgrp, ss);
-			if (ret)
-				goto out;
-		}
-	}
-
-	read_unlock(&proto_list_lock);
-	return ret;
-out:
-	list_for_each_entry_continue_reverse(proto, &proto_list, node)
-		if (proto->destroy_cgroup)
-			proto->destroy_cgroup(cgrp, ss);
-	read_unlock(&proto_list_lock);
-	return ret;
-}
-
-void mem_cgroup_sockets_destroy(struct cgroup *cgrp, struct cgroup_subsys *ss)
-{
-	struct proto *proto;
-
-	read_lock(&proto_list_lock);
-	list_for_each_entry_reverse(proto, &proto_list, node)
-		if (proto->destroy_cgroup)
-			proto->destroy_cgroup(cgrp, ss);
-	read_unlock(&proto_list_lock);
-}
-#endif
-
 /*
  * Each address family might have different locking rules, so we have
  * one slock key per address family:
@@ -2483,6 +2446,12 @@ int proto_register(struct proto *prot, int alloc_slab)
 	list_add(&prot->node, &proto_list);
 	assign_proto_idx(prot);
 	write_unlock(&proto_list_lock);
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+	if (prot->proto_cgroup)
+		register_sock_cgroup(prot);
+#endif
+
 	return 0;
 
 out_free_timewait_sock_slab_name:
@@ -2510,6 +2479,11 @@ void proto_unregister(struct proto *prot)
 	list_del(&prot->node);
 	write_unlock(&proto_list_lock);
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
+	if (prot->proto_cgroup != NULL)
+		unregister_sock_cgroup(prot);
+#endif
+
 	if (prot->slab != NULL) {
 		kmem_cache_destroy(prot->slab);
 		prot->slab = NULL;
-- 
1.7.6.4


--------------090403050008060201020709--
