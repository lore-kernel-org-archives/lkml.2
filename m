Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2ACWtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:49:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319Ab2ACWle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:23 2012
Message-Id: <20120103223323.351738994@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        James Morris <jmorris@namei.org>
Subject: [28/75] SELinux: Fix RCU deref check warning in sel_netport_insert()
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 50345f1ea9cda4618d9c26e590a97ecd4bc7ac75 upstream.

Fix the following bug in sel_netport_insert() where rcu_dereference() should
be rcu_dereference_protected() as sel_netport_lock is held.

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
security/selinux/netport.c:127 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by ossec-rootcheck/3323:
 #0:  (sel_netport_lock){+.....}, at: [<ffffffff8117d775>] sel_netport_sid+0xbb/0x226

stack backtrace:
Pid: 3323, comm: ossec-rootcheck Not tainted 3.1.0-rc8-fsdevel+ #1095
Call Trace:
 [<ffffffff8105cfb7>] lockdep_rcu_dereference+0xa7/0xb0
 [<ffffffff8117d871>] sel_netport_sid+0x1b7/0x226
 [<ffffffff8117d6ba>] ? sel_netport_avc_callback+0xbc/0xbc
 [<ffffffff8117556c>] selinux_socket_bind+0x115/0x230
 [<ffffffff810a5388>] ? might_fault+0x4e/0x9e
 [<ffffffff810a53d1>] ? might_fault+0x97/0x9e
 [<ffffffff81171cf4>] security_socket_bind+0x11/0x13
 [<ffffffff812ba967>] sys_bind+0x56/0x95
 [<ffffffff81380dac>] ? sysret_check+0x27/0x62
 [<ffffffff8105b767>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffff81076fcd>] ? audit_syscall_entry+0x17b/0x1ae
 [<ffffffff811b5eae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81380d7b>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/netport.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -123,7 +123,9 @@ static void sel_netport_insert(struct se
 	if (sel_netport_hash[idx].size == SEL_NETPORT_HASH_BKT_LIMIT) {
 		struct sel_netport *tail;
 		tail = list_entry(
-			rcu_dereference(sel_netport_hash[idx].list.prev),
+			rcu_dereference_protected(
+				sel_netport_hash[idx].list.prev,
+				lockdep_is_held(&sel_netport_lock)),
 			struct sel_netport, list);
 		list_del_rcu(&tail->list);
 		kfree_rcu(tail, rcu);


