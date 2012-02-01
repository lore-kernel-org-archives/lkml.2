Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2BAVNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:13:47 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40019 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932585Ab2BAVKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:41 -0500
X-Sasl-enc: A3W2RVUZsH844bYOCC7iMLR46w8hKl0LLSGK0vzbTZnp 1328130640
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:50 2012
Message-Id: <20120201210049.944253743@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Sjur=20Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [69/89] netns: fix net_alloc_generic()
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 073862ba5d249c20bd5c49fc6d904ff0e1f6a672 ]

When a new net namespace is created, we should attach to it a "struct
net_generic" with enough slots (even empty), or we can hit the following
BUG_ON() :

[  200.752016] kernel BUG at include/net/netns/generic.h:40!
...
[  200.752016]  [<ffffffff825c3cea>] ? get_cfcnfg+0x3a/0x180
[  200.752016]  [<ffffffff821cf0b0>] ? lockdep_rtnl_is_held+0x10/0x20
[  200.752016]  [<ffffffff825c41be>] caif_device_notify+0x2e/0x530
[  200.752016]  [<ffffffff810d61b7>] notifier_call_chain+0x67/0x110
[  200.752016]  [<ffffffff810d67c1>] raw_notifier_call_chain+0x11/0x20
[  200.752016]  [<ffffffff821bae82>] call_netdevice_notifiers+0x32/0x60
[  200.752016]  [<ffffffff821c2b26>] register_netdevice+0x196/0x300
[  200.752016]  [<ffffffff821c2ca9>] register_netdev+0x19/0x30
[  200.752016]  [<ffffffff81c1c67a>] loopback_net_init+0x4a/0xa0
[  200.752016]  [<ffffffff821b5e62>] ops_init+0x42/0x180
[  200.752016]  [<ffffffff821b600b>] setup_net+0x6b/0x100
[  200.752016]  [<ffffffff821b6466>] copy_net_ns+0x86/0x110
[  200.752016]  [<ffffffff810d5789>] create_new_namespaces+0xd9/0x190

net_alloc_generic() should take into account the maximum index into the
ptr array, as a subsystem might use net_generic() anytime.

This also reduces number of reallocations in net_assign_generic()

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sjur Brændeland <sjur.brandeland@stericsson.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net_namespace.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -30,6 +30,20 @@ EXPORT_SYMBOL(init_net);
 
 #define INITIAL_NET_GEN_PTRS	13 /* +1 for len +2 for rcu_head */
 
+static unsigned int max_gen_ptrs = INITIAL_NET_GEN_PTRS;
+
+static struct net_generic *net_alloc_generic(void)
+{
+	struct net_generic *ng;
+	size_t generic_size = offsetof(struct net_generic, ptr[max_gen_ptrs]);
+
+	ng = kzalloc(generic_size, GFP_KERNEL);
+	if (ng)
+		ng->len = max_gen_ptrs;
+
+	return ng;
+}
+
 static int net_assign_generic(struct net *net, int id, void *data)
 {
 	struct net_generic *ng, *old_ng;
@@ -43,8 +57,7 @@ static int net_assign_generic(struct net
 	if (old_ng->len >= id)
 		goto assign;
 
-	ng = kzalloc(sizeof(struct net_generic) +
-			id * sizeof(void *), GFP_KERNEL);
+	ng = net_alloc_generic();
 	if (ng == NULL)
 		return -ENOMEM;
 
@@ -59,7 +72,6 @@ static int net_assign_generic(struct net
 	 * the old copy for kfree after a grace period.
 	 */
 
-	ng->len = id;
 	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
 
 	rcu_assign_pointer(net->gen, ng);
@@ -161,18 +173,6 @@ out_undo:
 	goto out;
 }
 
-static struct net_generic *net_alloc_generic(void)
-{
-	struct net_generic *ng;
-	size_t generic_size = sizeof(struct net_generic) +
-		INITIAL_NET_GEN_PTRS * sizeof(void *);
-
-	ng = kzalloc(generic_size, GFP_KERNEL);
-	if (ng)
-		ng->len = INITIAL_NET_GEN_PTRS;
-
-	return ng;
-}
 
 #ifdef CONFIG_NET_NS
 static struct kmem_cache *net_cachep;
@@ -483,6 +483,7 @@ again:
 			}
 			return error;
 		}
+		max_gen_ptrs = max_t(unsigned int, max_gen_ptrs, *ops->id);
 	}
 	error = __register_pernet_operations(list, ops);
 	if (error) {


