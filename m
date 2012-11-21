Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2KULHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:07:38 -0500
Received: from tundra.namei.org ([65.99.196.166]:34273 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab2KULHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:07:36 -0500
Date: Wed, 21 Nov 2012 22:08:27 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Fix SELinux RCU bug
Message-ID: <alpine.LRH.2.02.1211212207150.17450@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.


The following changes since commit 99b6e1e7233073a23a20824db8c5260a723ed192:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Dave Jones (1):
      selinux: fix sel_netnode_insert() suspicious rcu dereference

 security/selinux/netnode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

commit 88a693b5c1287be4da937699cb82068ce9db0135
Author: Dave Jones <davej@redhat.com>
Date:   Thu Nov 8 16:09:27 2012 -0800

    selinux: fix sel_netnode_insert() suspicious rcu dereference
    
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
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

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
