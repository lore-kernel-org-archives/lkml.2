Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767638Ab2KOESi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:18:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:49962 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993340Ab2KOEM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jonathan Kliegman <kliegs@google.com>,
        Eric Dumazet <edumazet@google.com>,
        =?ISO-8859-15?q?St=C3=A9phane=20Marchesin?= <marcheu@google.com>,
        Sam Leffler <sleffler@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=2038/57=5D=20netlink=3A=20use=20kfree=5Frcu=28=29=20in=20netlink=5Frelease=28=29?=
Date: Wed, 14 Nov 2012 20:11:46 -0800
Message-Id: <20121115040935.557738948@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6d772ac5578f711d1ce7b03535d1c95bffb21dff ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -137,6 +137,8 @@ static void netlink_destroy_callback(str
 static DEFINE_RWLOCK(nl_table_lock);
 static atomic_t nl_table_users = ATOMIC_INIT(0);
 
+#define nl_deref_protected(X) rcu_dereference_protected(X, lockdep_is_held(&nl_table_lock));
+
 static ATOMIC_NOTIFIER_HEAD(netlink_chain);
 
 static inline u32 netlink_group_mask(u32 group)
@@ -332,6 +334,11 @@ netlink_update_listeners(struct sock *sk
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
@@ -339,7 +346,7 @@ netlink_update_listeners(struct sock *sk
 			if (i < NLGRPLONGS(nlk_sk(sk)->ngroups))
 				mask |= nlk_sk(sk)->groups[i];
 		}
-		tbl->listeners->masks[i] = mask;
+		listeners->masks[i] = mask;
 	}
 	/* this function is only called with the netlink table "grabbed", which
 	 * makes sure updates are visible before bind or setsockopt return. */
@@ -520,7 +527,11 @@ static int netlink_release(struct socket
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
@@ -950,7 +961,7 @@ int netlink_has_listeners(struct sock *s
 	rcu_read_lock();
 	listeners = rcu_dereference(nl_table[sk->sk_protocol].listeners);
 
-	if (group - 1 < nl_table[sk->sk_protocol].groups)
+	if (listeners && group - 1 < nl_table[sk->sk_protocol].groups)
 		res = test_bit(group - 1, listeners->masks);
 
 	rcu_read_unlock();
@@ -1582,7 +1593,7 @@ int __netlink_change_ngroups(struct sock
 		new = kzalloc(sizeof(*new) + NLGRPSZ(groups), GFP_ATOMIC);
 		if (!new)
 			return -ENOMEM;
-		old = rcu_dereference_protected(tbl->listeners, 1);
+		old = nl_deref_protected(tbl->listeners);
 		memcpy(new->masks, old->masks, NLGRPSZ(tbl->groups));
 		rcu_assign_pointer(tbl->listeners, new);
 


