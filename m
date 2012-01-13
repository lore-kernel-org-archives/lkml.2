Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2AMPMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:12:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56661 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab2AMPMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:12:15 -0500
Date: Fri, 13 Jan 2012 19:12:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] sysctl: Make kernel.ns_last_pid control being
 CHECKPOINT_RESTORE dependent
Message-ID: <20120113151210.GN28196@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those who doesn't need C/R functionality there is no need
to control last pid, ie the pid for the next fork() call.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---

Since there only two places where CONFIG_ is needed, I think
plain #ifdef better than some helper function with bare body
and unconditional call.

 kernel/pid_namespace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.git/kernel/pid_namespace.c
===================================================================
--- linux-2.6.git.orig/kernel/pid_namespace.c
+++ linux-2.6.git/kernel/pid_namespace.c
@@ -191,6 +191,7 @@ void zap_pid_ns_processes(struct pid_nam
 	return;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -218,13 +219,16 @@ static struct ctl_table pid_ns_ctl_table
 	},
 	{ }
 };
-
 static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
+#endif /* CONFIG_CHECKPOINT_RESTORE */
 
 static __init int pid_namespaces_init(void)
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
+
+#ifdef CONFIG_CHECKPOINT_RESTORE
 	register_sysctl_paths(kern_path, pid_ns_ctl_table);
+#endif
 	return 0;
 }
 
