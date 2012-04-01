Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2DAVic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2DAVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:38:31 -0400
Date: Sun, 1 Apr 2012 23:38:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing: syscall_regfunc() should not skip kernel
	threads
Message-ID: <20120401213819.GC17795@redhat.com>
References: <20120330183104.GA12927@redhat.com> <1333134131.23924.191.camel@gandalf.stny.rr.com> <20120330201550.GA16628@redhat.com> <1333152806.23924.196.camel@gandalf.stny.rr.com> <20120331204501.GA18572@redhat.com> <1333229859.23924.200.camel@gandalf.stny.rr.com> <20120401213748.GA17795@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401213748.GA17795@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscall_regfunc() ignores the kernel thread because "it has
no effect", see cc3b13c1 "Don't trace kernel thread syscalls".

However, this means that a user-space task spawned by
call_usermodehelper() won't report the system calls if
kernel_execve() is called when sys_tracepoint_refcount != 0.

Remove this check. Hopefully the unnecessary report from
ret_from_fork path mentioned by cc3b13c1 is fine. In fact
"this is the only case" is not true. Say, kernel_execve()
itself does "int 80" on X86_32. Hopefully fine too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/tracepoint.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index e2a4523..2403e60 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -739,9 +739,7 @@ void syscall_regfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock(&tasklist_lock);
 		do_each_thread(g, t) {
-			/* Skip kernel threads. */
-			if (!(t->flags & PF_KTHREAD))
-				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
 		read_unlock(&tasklist_lock);
 	}
-- 
1.5.5.1


