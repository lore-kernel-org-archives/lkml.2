Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab2LMOLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab2LMOLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gao feng <gaofeng@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 173/241] netlink: add reference of module in netlink_dump_start
Date: Thu, 13 Dec 2012 11:58:58 -0200
Message-Id: <1355407206-17100-174-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

commit 6dc878a8ca39e93f70c42f3dd7260bde10c1e0f1 upstream.

I get a panic when I use ss -a and rmmod inet_diag at the
same time.

It's because netlink_dump uses inet_diag_dump which belongs to module
inet_diag.

I search the codes and find many modules have the same problem.  We
need to add a reference to the module which the cb->dump belongs to.

Thanks for all help from Stephen,Jan,Eric,Steffen and Pablo.

Change From v3:
change netlink_dump_start to inline,suggestion from Pablo and
Eric.

Change From v2:
delete netlink_dump_done,and call module_put in netlink_dump
and netlink_sock_destruct.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/netlink.h  |   21 +++++++++++++++++----
 net/netlink/af_netlink.c |   29 +++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 0f628ff..6f393c2 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -153,6 +153,7 @@ struct nlattr {
 
 #include <linux/capability.h>
 #include <linux/skbuff.h>
+#include <linux/export.h>
 
 struct net;
 
@@ -226,6 +227,8 @@ struct netlink_callback {
 					struct netlink_callback *cb);
 	int			(*done)(struct netlink_callback *cb);
 	void			*data;
+	/* the module that dump function belong to */
+	struct module		*module;
 	u16			family;
 	u16			min_dump_alloc;
 	unsigned int		prev_seq, seq;
@@ -251,14 +254,24 @@ __nlmsg_put(struct sk_buff *skb, u32 pid, u32 seq, int type, int len, int flags)
 
 struct netlink_dump_control {
 	int (*dump)(struct sk_buff *skb, struct netlink_callback *);
-	int (*done)(struct netlink_callback*);
+	int (*done)(struct netlink_callback *);
 	void *data;
+	struct module *module;
 	u16 min_dump_alloc;
 };
 
-extern int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
-			      const struct nlmsghdr *nlh,
-			      struct netlink_dump_control *control);
+extern int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
+				const struct nlmsghdr *nlh,
+				struct netlink_dump_control *control);
+static inline int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
+				     const struct nlmsghdr *nlh,
+				     struct netlink_dump_control *control)
+{
+	if (!control->module)
+		control->module = THIS_MODULE;
+
+	return __netlink_dump_start(ssk, skb, nlh, control);
+}
 
 
 #define NL_NONROOT_RECV 0x1
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 20b32fd..efffdfc 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -167,6 +167,8 @@ static void netlink_sock_destruct(struct sock *sk)
 	if (nlk->cb) {
 		if (nlk->cb->done)
 			nlk->cb->done(nlk->cb);
+
+		module_put(nlk->cb->module);
 		netlink_destroy_callback(nlk->cb);
 	}
 
@@ -1737,6 +1739,7 @@ static int netlink_dump(struct sock *sk)
 	nlk->cb = NULL;
 	mutex_unlock(nlk->cb_mutex);
 
+	module_put(cb->module);
 	netlink_consume_callback(cb);
 	return 0;
 
@@ -1746,9 +1749,9 @@ errout_skb:
 	return err;
 }
 
-int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
-		       const struct nlmsghdr *nlh,
-		       struct netlink_dump_control *control)
+int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
+			 const struct nlmsghdr *nlh,
+			 struct netlink_dump_control *control)
 {
 	struct netlink_callback *cb;
 	struct sock *sk;
@@ -1763,6 +1766,7 @@ int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	cb->done = control->done;
 	cb->nlh = nlh;
 	cb->data = control->data;
+	cb->module = control->module;
 	cb->min_dump_alloc = control->min_dump_alloc;
 	atomic_inc(&skb->users);
 	cb->skb = skb;
@@ -1773,19 +1777,28 @@ int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 		return -ECONNREFUSED;
 	}
 	nlk = nlk_sk(sk);
-	/* A dump is in progress... */
+
 	mutex_lock(nlk->cb_mutex);
+	/* A dump is in progress... */
 	if (nlk->cb) {
 		mutex_unlock(nlk->cb_mutex);
 		netlink_destroy_callback(cb);
-		sock_put(sk);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
+	/* add reference of module which cb->dump belongs to */
+	if (!try_module_get(cb->module)) {
+		mutex_unlock(nlk->cb_mutex);
+		netlink_destroy_callback(cb);
+		ret = -EPROTONOSUPPORT;
+		goto out;
+	}
+
 	nlk->cb = cb;
 	mutex_unlock(nlk->cb_mutex);
 
 	ret = netlink_dump(sk);
-
+out:
 	sock_put(sk);
 
 	if (ret)
@@ -1796,7 +1809,7 @@ int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	 */
 	return -EINTR;
 }
-EXPORT_SYMBOL(netlink_dump_start);
+EXPORT_SYMBOL(__netlink_dump_start);
 
 void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err)
 {
-- 
1.7.9.5

