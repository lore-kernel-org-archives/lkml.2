Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab0I2OrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:47:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab0I2OrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:47:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
        oleg@redhat.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 1/2] oprofile, x86: using struct stack_frame for 64bit processes dump
Date: Wed, 29 Sep 2010 16:46:46 +0200
Message-Id: <1285771607-12089-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1285771607-12089-1-git-send-email-jolsa@redhat.com>
References: <1285771607-12089-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing unnecessary struct frame_head and replacing it with
struct stack_frame.

The struct stack_frame is already defined and used in other places
in kernel, so there's no reason to define new structure.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/oprofile/backtrace.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 3855096..d640a86 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -48,35 +48,30 @@ static struct stacktrace_ops backtrace_ops = {
 	.walk_stack	= print_context_stack,
 };
 
-struct frame_head {
-	struct frame_head *bp;
-	unsigned long ret;
-} __attribute__((packed));
-
-static struct frame_head *dump_user_backtrace(struct frame_head *head)
+static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 {
-	struct frame_head bufhead[2];
+	struct stack_frame bufhead[2];
 
-	/* Also check accessibility of one struct frame_head beyond */
+	/* Also check accessibility of one struct stack_frame beyond */
 	if (!access_ok(VERIFY_READ, head, sizeof(bufhead)))
 		return NULL;
 	if (__copy_from_user_inatomic(bufhead, head, sizeof(bufhead)))
 		return NULL;
 
-	oprofile_add_trace(bufhead[0].ret);
+	oprofile_add_trace(bufhead[0].return_address);
 
 	/* frame pointers should strictly progress back up the stack
 	 * (towards higher addresses) */
-	if (head >= bufhead[0].bp)
+	if (head >= bufhead[0].next_frame)
 		return NULL;
 
-	return bufhead[0].bp;
+	return bufhead[0].next_frame;
 }
 
 void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
-	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
+	struct stack_frame *head = (struct stack_frame *)frame_pointer(regs);
 
 	if (!user_mode_vm(regs)) {
 		unsigned long stack = kernel_stack_pointer(regs);
-- 
1.7.1

