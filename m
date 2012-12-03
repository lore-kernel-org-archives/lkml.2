Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2LCOsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:48:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43768 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233Ab2LCOgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:22 -0500
Message-Id: <20121203143157.939764243@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:00 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 74/89] selinux: fix sel_netnode_insert() suspicious rcu dereference
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit 88a693b5c1287be4da937699cb82068ce9db0135 upstream.

===============================
[ INFO: suspicious RCU usage. ]
3.5.0-rc1+ #63 Not tainted
-------------------------------
security/selinux/netnode.c:178 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by trinity-child1/8750:
 #0:  (sel_netnode_lock){+.....}, at: [<ffffffff812d8f8a>] sel_netnode_sid+0x16a/0x3e0

stack backtrace:
Pid: 8750, comm: trinity-child1 Not tainted 3.5.0-rc1+ #63
Call Trace:
 [<ffffffff810cec2d>] lockdep_rcu_suspicious+0xfd/0x130
 [<ffffffff812d91d1>] sel_netnode_sid+0x3b1/0x3e0
 [<ffffffff812d8e20>] ? sel_netnode_find+0x1a0/0x1a0
 [<ffffffff812d24a6>] selinux_socket_bind+0xf6/0x2c0
 [<ffffffff810cd1dd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810cdb55>] ? lock_release_holdtime.part.9+0x15/0x1a0
 [<ffffffff81093841>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffff812c9536>] security_socket_bind+0x16/0x20
 [<ffffffff815550ca>] sys_bind+0x7a/0x100
 [<ffffffff816c03d5>] ? sysret_check+0x22/0x5d
 [<ffffffff810d392d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
 [<ffffffff8133b09e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816c03a9>] system_call_fastpath+0x16/0x1b

This patch below does what Paul McKenney suggested in the previous thread.

Signed-off-by: Dave Jones <davej@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/netnode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 28f911c..c5454c0 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -174,7 +174,8 @@ static void sel_netnode_insert(struct sel_netnode *node)
 	if (sel_netnode_hash[idx].size == SEL_NETNODE_HASH_BKT_LIMIT) {
 		struct sel_netnode *tail;
 		tail = list_entry(
-			rcu_dereference(sel_netnode_hash[idx].list.prev),
+			rcu_dereference_protected(sel_netnode_hash[idx].list.prev,
+						  lockdep_is_held(&sel_netnode_lock)),
 			struct sel_netnode, list);
 		list_del_rcu(&tail->list);
 		kfree_rcu(tail, rcu);


