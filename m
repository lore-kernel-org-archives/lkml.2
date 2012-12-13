Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab2LMOM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:12:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44954 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab2LMOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@google.com>,
        Sam Leffler <sleffler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 195/241] netlink: use kfree_rcu() in netlink_release()
Date: Thu, 13 Dec 2012 11:59:20 -0200
Message-Id: <1355407206-17100-196-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 6d772ac5578f711d1ce7b03535d1c95bffb21dff upstream.

On some suspend/resume operations involving wimax device, we have
noticed some intermittent memory corruptions in netlink code.

Stéphane Marchesin tracked this corruption in netlink_update_listeners()
and suggested a patch.

It appears netlink_release() should use kfree_rcu() instead of kfree()
for the listeners structure as it may be used by other cpus using RCU
protection.

netlink_release() must set to NULL the listeners pointer when
it is about to be freed.

Also have to protect netlink_update_listeners() and
netlink_has_listeners() if listeners is NULL.

Add a nl_deref_protected() lockdep helper to properly document which
locks protects us.

Reported-by: Jonathan Kliegman <kliegs@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stéphane Marchesin <marcheu@google.com>
Cc: Sam Leffler <sleffler@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/netlink/af_netlink.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index efffdfc..f4980b6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -136,6 +136,8 @@ static int netlink_dump(struct sock *sk);
 static DEFINE_RWLOCK(nl_table_lock);
 static atomic_t nl_table_users = ATOMIC_INIT(0);
 
+#define nl_deref_protected(X) rcu_dereference_protected(X, lockdep_is_held(&nl_table_lock));
+
 static ATOMIC_NOTIFIER_HEAD(netlink_chain);
 
 static inline u32 netlink_group_mask(u32 group)
@@ -343,6 +345,11 @@ netlink_update_listeners(struct sock *sk)
 	struct hlist_node *node;
 	unsigned long mask;
 	unsigned int i;
+	struct listeners *listeners;
+
+	listeners = nl_deref_protected(tbl->listeners);
+	if (!listeners)
+		return;
 
 	for (i = 0; i < NLGRPLONGS(tbl->groups); i++) {
 		mask = 0;
@@ -350,7 +357,7 @@ netlink_update_listeners(struct sock *sk)
 			if (i < NLGRPLONGS(nlk_sk(sk)->ngroups))
 				mask |= nlk_sk(sk)->groups[i];
 		}
-		tbl->listeners->masks[i] = mask;
+		listeners->masks[i] = mask;
 	}
 	/* this function is only called with the netlink table "grabbed", which
 	 * makes sure updates are visible before bind or setsockopt return. */
@@ -531,7 +538,11 @@ static int netlink_release(struct socket *sock)
 	if (netlink_is_kernel(sk)) {
 		BUG_ON(nl_table[sk->sk_protocol].registered == 0);
 		if (--nl_table[sk->sk_protocol].registered == 0) {
-			kfree(nl_table[sk->sk_protocol].listeners);
+			struct listeners *old;
+
+			old = nl_deref_protected(nl_table[sk->sk_protocol].listeners);
+			RCU_INIT_POINTER(nl_table[sk->sk_protocol].listeners, NULL);
+			kfree_rcu(old, rcu);
 			nl_table[sk->sk_protocol].module = NULL;
 			nl_table[sk->sk_protocol].registered = 0;
 		}
@@ -964,7 +975,7 @@ int netlink_has_listeners(struct sock *sk, unsigned int group)
 	rcu_read_lock();
 	listeners = rcu_dereference(nl_table[sk->sk_protocol].listeners);
 
-	if (group - 1 < nl_table[sk->sk_protocol].groups)
+	if (listeners && group - 1 < nl_table[sk->sk_protocol].groups)
 		res = test_bit(group - 1, listeners->masks);
 
 	rcu_read_unlock();
@@ -1597,7 +1608,7 @@ int __netlink_change_ngroups(struct sock *sk, unsigned int groups)
 		new = kzalloc(sizeof(*new) + NLGRPSZ(groups), GFP_ATOMIC);
 		if (!new)
 			return -ENOMEM;
-		old = rcu_dereference_protected(tbl->listeners, 1);
+		old = nl_deref_protected(tbl->listeners);
 		memcpy(new->masks, old->masks, NLGRPSZ(tbl->groups));
 		rcu_assign_pointer(tbl->listeners, new);
 
-- 
1.7.9.5

