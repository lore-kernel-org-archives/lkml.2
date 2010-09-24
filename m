Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab0IXQ2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:22 -0400
Received: from kroah.org ([198.145.64.141]:38294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab0IXQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:17 2010
Message-Id: <20100924162617.600326431@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Helsley <matthltc@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will.deacon@arm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [31/80] hw breakpoints: Fix pid namespace bug
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Helsley <matthltc@us.ibm.com>

commit 068e35eee9ef98eb4cab55181977e24995d273be upstream.

Hardware breakpoints can't be registered within pid namespaces
because tsk->pid is passed rather than the pid in the current
namespace.

(See https://bugzilla.kernel.org/show_bug.cgi?id=17281 )

This is a quick fix demonstrating the problem but is not the
best method of solving the problem since passing pids internally
is not the best way to avoid pid namespace bugs. Subsequent patches
will show a better solution.

Much thanks to Frederic Weisbecker <fweisbec@gmail.com> for doing
the bulk of the work finding this bug.

Reported-by: Robin Green <greenrd@greenrd.org>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
LKML-Reference: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hw_breakpoint.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -417,7 +417,8 @@ register_user_hw_breakpoint(struct perf_
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
+	return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk),
+						triggered);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 


