Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2JZASK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:18:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:53848 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab2JZAIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 63/85] netlink: add reference of module in netlink_dump_start
Date: Thu, 25 Oct 2012 17:06:21 -0700
Message-Id: <20121026000037.452678502@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 6dc878a8ca39e93f70c42f3dd7260bde10c1e0f1 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netlink.h  |   21 +++++++++++++++++----
 net/netlink/af_netlink.c |   29 +++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 12 deletions(-)

--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -153,6 +153,7 @@ struct nlattr {
 
 #include <linux/capability.h>
 #include <linux/skbuff.h>
+#include <linux/export.h>
 
 struct net;
 
@@ -232,6 +233,8 @@ struct netlink_callback {
 					struct netlink_callback *cb);
 	int			(*done)(struct netlink_callback *cb);
 	void			*data;
+	/* the module that dump function belong to */
+	struct module		*module;
 	u16			family;
 	u16			min_dump_alloc;
 	unsigned int		prev_seq, seq;
@@ -249,14 +252,24 @@ __nlmsg_put(struct sk_buff *skb, u32 pid
 
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
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -169,6 +169,8 @@ static void netlink_sock_destruct(struct
 	if (nlk->cb) {
 		if (nlk->cb->done)
 			nlk->cb->done(nlk->cb);
+
+		module_put(nlk->cb->module);
 		netlink_destroy_callback(nlk->cb);
 	}
 
@@ -1760,6 +1762,7 @@ static int netlink_dump(struct sock *sk)
 	nlk->cb = NULL;
 	mutex_unlock(nlk->cb_mutex);
 
+	module_put(cb->module);
 	netlink_consume_callback(cb);
 	return 0;
 
@@ -1769,9 +1772,9 @@ errout_skb:
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
@@ -1786,6 +1789,7 @@ int netlink_dump_start(struct sock *ssk,
 	cb->done = control->done;
 	cb->nlh = nlh;
 	cb->data = control->data;
+	cb->module = control->module;
 	cb->min_dump_alloc = control->min_dump_alloc;
 	atomic_inc(&skb->users);
 	cb->skb = skb;
@@ -1796,19 +1800,28 @@ int netlink_dump_start(struct sock *ssk,
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
@@ -1819,7 +1832,7 @@ int netlink_dump_start(struct sock *ssk,
 	 */
 	return -EINTR;
 }
-EXPORT_SYMBOL(netlink_dump_start);
+EXPORT_SYMBOL(__netlink_dump_start);
 
 void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err)
 {


