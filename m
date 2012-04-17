Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2DQLSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2DQLR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:17:58 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/16] uaccess: Add new copy_from_user_gup API
Date: Tue, 17 Apr 2012 13:17:06 +0200
Message-Id: <1334661441-4420-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings a get_user_page_fast() based copy_from_user() that can
do a best effort copy from any context.

In order to support user stack dump safely in perf samples from
generic code, rename x86 copy_from_user_nmi to copy_from_user_gup
and make it generally available. If the arch doesn't provide an
implementation it will map to copy_from_user_inatomic.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/include/asm/uaccess.h             |    7 +++++--
 arch/x86/kernel/cpu/perf_event.c           |    4 ++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |    3 ++-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    2 +-
 arch/x86/lib/usercopy.c                    |    4 ++--
 arch/x86/oprofile/backtrace.c              |    4 ++--
 include/asm-generic/uaccess.h              |    4 ++++
 7 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e054459..b8724e9 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -228,6 +228,11 @@ extern void __put_user_2(void);
 extern void __put_user_4(void);
 extern void __put_user_8(void);
 
+extern unsigned long
+__copy_from_user_gup(void *to, const void __user *from, unsigned long n);
+
+#define copy_from_user_gup(to, from, n) __copy_from_user_gup(to, from, n)
+
 #ifdef CONFIG_X86_WP_WORKS_OK
 
 /**
@@ -555,8 +560,6 @@ struct __large_struct { unsigned long buf[100]; };
 
 #endif /* CONFIG_X86_WP_WORKS_OK */
 
-extern unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
 extern __must_check long
 strncpy_from_user(char *dst, const char __user *src, long count);
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bb8e034..294ad68 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1781,7 +1781,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		frame.next_frame     = 0;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		bytes = copy_from_user_gup(&frame, fp, sizeof(frame));
 		if (bytes != sizeof(frame))
 			break;
 
@@ -1827,7 +1827,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		bytes = copy_from_user_gup(&frame, fp, sizeof(frame));
 		if (bytes != sizeof(frame))
 			break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 7f64df1..77053af 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -520,7 +520,8 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		if (!kernel_ip(ip)) {
 			int bytes, size = MAX_INSN_SIZE;
 
-			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
+			bytes = copy_from_user_gup(buf, (void __user *)to,
+						   size);
 			if (bytes != size)
 				return 0;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..8f0b9ce 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -437,7 +437,7 @@ static int branch_type(unsigned long from, unsigned long to)
 			return X86_BR_NONE;
 
 		/* may fail if text not present */
-		bytes = copy_from_user_nmi(buf, (void __user *)from, size);
+		bytes = copy_from_user_gup(buf, (void __user *)from, size);
 		if (bytes != size)
 			return X86_BR_NONE;
 
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index d6ae30b..e797d6e 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -13,7 +13,7 @@
  * best effort, GUP based copy_from_user() that is NMI-safe
  */
 unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+__copy_from_user_gup(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
 	unsigned long size, len = 0;
@@ -42,7 +42,7 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 
 	return len;
 }
-EXPORT_SYMBOL_GPL(copy_from_user_nmi);
+EXPORT_SYMBOL_GPL(__copy_from_user_gup);
 
 static inline unsigned long count_bytes(unsigned long mask)
 {
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index d6aa6e8..42511b0 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -46,7 +46,7 @@ dump_user_backtrace_32(struct stack_frame_ia32 *head)
 	struct stack_frame_ia32 *fp;
 	unsigned long bytes;
 
-	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	bytes = copy_from_user_gup(bufhead, head, sizeof(bufhead));
 	if (bytes != sizeof(bufhead))
 		return NULL;
 
@@ -92,7 +92,7 @@ static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
 	struct stack_frame bufhead[2];
 	unsigned long bytes;
 
-	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
+	bytes = copy_from_user_gup(bufhead, head, sizeof(bufhead));
 	if (bytes != sizeof(bufhead))
 		return NULL;
 
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index 9788568..759339b 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -240,6 +240,10 @@ extern int __get_user_bad(void) __attribute__((noreturn));
 #define __copy_to_user_inatomic __copy_to_user
 #endif
 
+#ifndef copy_from_user_gup
+#define copy_from_user_gup __copy_from_user_inatomic
+#endif
+
 static inline long copy_from_user(void *to,
 		const void __user * from, unsigned long n)
 {
-- 
1.7.7.6

