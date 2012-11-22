Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2KVSkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:49639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab2KVSkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 80/83] selinux: fix sel_netnode_insert() suspicious rcu dereference
Date: Wed, 21 Nov 2012 16:42:42 -0800
Message-Id: <20121122004221.197149857@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/netnode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -174,7 +174,8 @@ static void sel_netnode_insert(struct se
 	if (sel_netnode_hash[idx].size == SEL_NETNODE_HASH_BKT_LIMIT) {
 		struct sel_netnode *tail;
 		tail = list_entry(
-			rcu_dereference(sel_netnode_hash[idx].list.prev),
+			rcu_dereference_protected(sel_netnode_hash[idx].list.prev,
+						  lockdep_is_held(&sel_netnode_lock)),
 			struct sel_netnode, list);
 		list_del_rcu(&tail->list);
 		kfree_rcu(tail, rcu);


