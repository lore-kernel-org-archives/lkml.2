Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0I2OrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:47:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab0I2OrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:47:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
        oleg@redhat.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 2/2] oprofile, x86: adding backtrace dump for 32bit process in compat mode
Date: Wed, 29 Sep 2010 16:46:47 +0200
Message-Id: <1285771607-12089-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1285771607-12089-1-git-send-email-jolsa@redhat.com>
References: <1285771607-12089-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the oprofile backtrace  generation for 32 bit
applications running in the 64bit environment (compat mode).

With this change it's possible to get backtrace for 32bits applications
under the 64bits environment using oprofile's callgraph options.

opcontrol --setup -c ...
opreport -l -cg ...

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/oprofile/backtrace.c |   53 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index d640a86..2d49d4e 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -14,6 +14,7 @@
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
 #include <asm/stacktrace.h>
+#include <linux/compat.h>
 
 static void backtrace_warning_symbol(void *data, char *msg,
 				     unsigned long symbol)
@@ -48,6 +49,55 @@ static struct stacktrace_ops backtrace_ops = {
 	.walk_stack	= print_context_stack,
 };
 
+#ifdef CONFIG_COMPAT
+static struct stack_frame_ia32 *
+dump_user_backtrace_32(struct stack_frame_ia32 *head)
+{
+	struct stack_frame_ia32 bufhead[2];
+	struct stack_frame_ia32 *fp;
+
+	/* Also check accessibility of one struct frame_head beyond */
+	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
+		return NULL;
+	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
+		return NULL;
+
+	fp = (struct stack_frame_ia32 *) compat_ptr(bufhead[0].next_frame);
+
+	oprofile_add_trace(bufhead[0].return_address);
+
+	/* frame pointers should strictly progress back up the stack
+	* (towards higher addresses) */
+	if (head >= fp)
+		return NULL;
+
+	return fp;
+}
+
+static inline int
+x86_backtrace_32(struct pt_regs * const regs, unsigned int depth)
+{
+	struct stack_frame_ia32 *head;
+
+	/* User process is 32-bit */
+	if (!current || !test_thread_flag(TIF_IA32))
+		return 0;
+
+	head = (struct stack_frame_ia32 *) regs->bp;
+	while (depth-- && head)
+		head = dump_user_backtrace_32(head);
+
+	return 1;
+}
+
+#else
+static inline int
+x86_backtrace_32(struct pt_regs * const regs, unsigned int depth)
+{
+	return 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 {
 	struct stack_frame bufhead[2];
@@ -81,6 +131,9 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 		return;
 	}
 
+	if (x86_backtrace_32(regs, depth))
+		return;
+
 	while (depth-- && head)
 		head = dump_user_backtrace(head);
 }
-- 
1.7.1

