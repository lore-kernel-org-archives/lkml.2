Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0C3XUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:33 -0400
Received: from kroah.org ([198.145.64.141]:45738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab0C3XT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:28 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:32 2010
Message-Id: <20100330224731.837280702@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [018/156] x86/stacktrace: Dont dereference bad frame pointers
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 29044ad1509ecc229f1d5a31aeed7a8dc61a71c4 upstream.

Callers of a stacktrace might pass bad frame pointers. Those
are usually checked for safety in stack walking helpers before
any dereferencing, but this is not the case when we need to go
through one more frame pointer that backlinks the irq stack to
the previous one, as we don't have any reliable address boudaries
to compare this frame pointer against.

This raises crashes when we record callchains for ftrace events
with perf because we don't use the right helpers to capture
registers there. We get wrong frame pointers as we call
task_pt_regs() even on kernel threads, which is a wrong thing
as it gives us the initial state of any kernel threads freshly
created. This is even not what we want for user tasks. What we want
is a hot snapshot of registers when the ftrace event triggers, not
the state before a task entered the kernel.

This requires more thoughts to do it correctly though.
So first put a guardian to ensure the given frame pointer
can be dereferenced to avoid crashes. We'll think about how to fix
the callers in a subsequent patch.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/dumpstack_64.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -125,9 +125,15 @@ fixup_bp_irq_link(unsigned long bp, unsi
 {
 #ifdef CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)bp;
+	unsigned long next;
 
-	if (!in_irq_stack(stack, irq_stack, irq_stack_end))
-		return (unsigned long)frame->next_frame;
+	if (!in_irq_stack(stack, irq_stack, irq_stack_end)) {
+		if (!probe_kernel_address(&frame->next_frame, next))
+			return next;
+		else
+			WARN_ONCE(1, "Perf: bad frame pointer = %p in "
+				  "callchain\n", &frame->next_frame);
+	}
 #endif
 	return bp;
 }


