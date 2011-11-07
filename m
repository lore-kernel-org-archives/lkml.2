Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab1KGQZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:25:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab1KGQZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:25:41 -0500
Date: Mon, 7 Nov 2011 11:25:32 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>
Subject: suspicious RCU usage in security/selinux/netport.c:127
Message-ID: <20111107162531.GA28795@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	James Morris <jmorris@namei.org>,
	Eric Paris <eparis@parisplace.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I reported this a while ago. Turns out it's still a problem.
This patch I think made the warning go away, but it might be a bit too 'big hammer' ?

	Dave

===============================
[ INFO: suspicious RCU usage. ]
-------------------------------
security/selinux/netport.c:127 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
1 lock held by named/1687:
 #0:  (sel_netport_lock){+.....}, at: [<ffffffff812e3799>] sel_netport_sid+0xd9/0x260

stack backtrace:
Pid: 1687, comm: named Not tainted 3.1.0+ #1
Call Trace:
 [<ffffffff810bcc37>] lockdep_rcu_suspicious+0xd7/0xe0
 [<ffffffff812e3917>] sel_netport_sid+0x257/0x260
 [<ffffffff812e36c0>] ? sel_netport_find+0xe0/0xe0
 [<ffffffff812dd8ba>] selinux_socket_bind+0x22a/0x300
 [<ffffffff8116ceb3>] ? might_fault+0x53/0xb0
 [<ffffffff8116cefc>] ? might_fault+0x9c/0xb0
 [<ffffffff8116ceb3>] ? might_fault+0x53/0xb0
 [<ffffffff812d3fb6>] security_socket_bind+0x16/0x20
 [<ffffffff81539b4a>] sys_bind+0x7a/0x100
 [<ffffffff816572ba>] ? sysret_check+0x2e/0x69
 [<ffffffff810c18dd>] ? trace_hardirqs_on_caller+0x11d/0x1b0
 [<ffffffff8133c65e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81657282>] system_call_fastpath+0x16/0x1b

diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index 0b62bd1..69f6928 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -119,6 +119,7 @@ static void sel_netport_insert(struct sel_netport *port)
 	/* we need to impose a limit on the growth of the hash table so check
 	 * this bucket to make sure it is within the specified bounds */
 	idx = sel_netport_hashfn(port->psec.port);
+	rcu_read_lock();
 	list_add_rcu(&port->list, &sel_netport_hash[idx].list);
 	if (sel_netport_hash[idx].size == SEL_NETPORT_HASH_BKT_LIMIT) {
 		struct sel_netport *tail;
@@ -129,6 +130,7 @@ static void sel_netport_insert(struct sel_netport *port)
 		kfree_rcu(tail, rcu);
 	} else
 		sel_netport_hash[idx].size++;
+	rcu_read_unlock();
 }
 
 /**
