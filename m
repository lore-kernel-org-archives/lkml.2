Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032076Ab2I1UXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:23:35 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46787 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032036Ab2I1UX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francesco Ruggeri <fruggeri@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 029/218] net: ipv4: ipmr_expire_timer causes crash when removing net namespace
Date: Fri, 28 Sep 2012 13:14:06 -0700
Message-Id: <20120928201504.718848714@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Francesco Ruggeri <fruggeri@aristanetworks.com>

[ Upstream commit acbb219d5f53821b2d0080d047800410c0420ea1 ]

When tearing down a net namespace, ipv4 mr_table structures are freed
without first deactivating their timers. This can result in a crash in
run_timer_softirq.
This patch mimics the corresponding behaviour in ipv6.
Locking and synchronization seem to be adequate.
We are about to kfree mrt, so existing code should already make sure that
no other references to mrt are pending or can be created by incoming traffic.
The functions invoked here do not cause new references to mrt or other
race conditions to be created.
Invoking del_timer_sync guarantees that ipmr_expire_timer is inactive.
Both ipmr_expire_process (whose completion we may have to wait in
del_timer_sync) and mroute_clean_tables internally use mfc_unres_lock
or other synchronizations when needed, and they both only modify mrt.

Tested in Linux 3.4.8.

Signed-off-by: Francesco Ruggeri <fruggeri@aristanetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ipmr.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -124,6 +124,8 @@ static DEFINE_SPINLOCK(mfc_unres_lock);
 static struct kmem_cache *mrt_cachep __read_mostly;
 
 static struct mr_table *ipmr_new_table(struct net *net, u32 id);
+static void ipmr_free_table(struct mr_table *mrt);
+
 static int ip_mr_forward(struct net *net, struct mr_table *mrt,
 			 struct sk_buff *skb, struct mfc_cache *cache,
 			 int local);
@@ -131,6 +133,7 @@ static int ipmr_cache_report(struct mr_t
 			     struct sk_buff *pkt, vifi_t vifi, int assert);
 static int __ipmr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
 			      struct mfc_cache *c, struct rtmsg *rtm);
+static void mroute_clean_tables(struct mr_table *mrt);
 static void ipmr_expire_process(unsigned long arg);
 
 #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
@@ -271,7 +274,7 @@ static void __net_exit ipmr_rules_exit(s
 
 	list_for_each_entry_safe(mrt, next, &net->ipv4.mr_tables, list) {
 		list_del(&mrt->list);
-		kfree(mrt);
+		ipmr_free_table(mrt);
 	}
 	fib_rules_unregister(net->ipv4.mr_rules_ops);
 }
@@ -299,7 +302,7 @@ static int __net_init ipmr_rules_init(st
 
 static void __net_exit ipmr_rules_exit(struct net *net)
 {
-	kfree(net->ipv4.mrt);
+	ipmr_free_table(net->ipv4.mrt);
 }
 #endif
 
@@ -336,6 +339,13 @@ static struct mr_table *ipmr_new_table(s
 	return mrt;
 }
 
+static void ipmr_free_table(struct mr_table *mrt)
+{
+	del_timer_sync(&mrt->ipmr_expire_timer);
+	mroute_clean_tables(mrt);
+	kfree(mrt);
+}
+
 /* Service routines creating virtual interfaces: DVMRP tunnels and PIMREG */
 
 static void ipmr_del_tunnel(struct net_device *dev, struct vifctl *v)


