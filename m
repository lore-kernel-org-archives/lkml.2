Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0IMMPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:15:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab0IMMPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:15:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
        tdm.rhbz@gmail.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] oprofile, x86: allow backtrace for 32bit apps under 64bit kernel
Date: Mon, 13 Sep 2010 14:15:17 +0200
Message-Id: <1284380117-6857-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

adding support for backtrace of ia32 applications under 64bit kernels.

wbr,
jirka



Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Tom Marshall <tdm.rhbz@gmail.com>
---
 arch/x86/oprofile/backtrace.c |   42 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 3855096..3e443ad 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -73,6 +73,38 @@ static struct frame_head *dump_user_backtrace(struct frame_head *head)
 	return bufhead[0].bp;
 }
 
+#ifdef CONFIG_X86_64
+struct frame_head_32 {
+	__u32 ebp;
+	__u32 ret;
+} __attribute__((packed));
+
+static struct frame_head *
+dump_user_backtrace_32(struct frame_head *head)
+{
+	struct frame_head_32 bufhead_32[2];
+	unsigned long bp, ret;
+
+	/* Also check accessibility of one struct frame_head beyond */
+	if (!access_ok(VERIFY_READ, head, sizeof(bufhead_32)))
+		return NULL;
+	if (__copy_from_user_inatomic(bufhead_32, head, sizeof(bufhead_32)))
+		return NULL;
+
+	bp  = bufhead_32[0].ebp;
+	ret = bufhead_32[0].ret;
+
+	oprofile_add_trace(ret);
+
+	/* frame pointers should strictly progress back up the stack
+	* (towards higher addresses) */
+	if (head >= (struct frame_head *) bp)
+		return NULL;
+
+	return (struct frame_head *) bp;
+}
+#endif
+
 void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
@@ -86,6 +118,16 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 		return;
 	}
 
+#ifdef CONFIG_X86_64
+	if (current && test_thread_flag(TIF_IA32)) {
+		/* User process is 32-bit */
+		head = (struct frame_head *)(regs->bp & 0xffffffff);
+		while (depth-- && head)
+			head = dump_user_backtrace_32(head);
+		return;
+	}
+#endif
+
 	while (depth-- && head)
 		head = dump_user_backtrace(head);
 }
-- 
1.7.1

