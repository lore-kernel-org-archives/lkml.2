Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0CQItn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:49:43 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54081 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab0CQItm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=I/TV+466VH9mpaccrtOvIgykk0aaTfiv3/J24GQC1cmSzSOPe89sAwtbA6eZINr2qZ
         88NnE1fecQpLFVewGANk36U99G2ds+3uK0P02iuVnOWzaMHAIQfLuFgzw3zU47Xj7Eje
         QCzDAsq+HXqJ3/biVp1Bzs2tTyrPLIlopygEM=
From: =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] perf: x86: fix callgraphs of 32-bit processes on 64-bit kernels V3.
Date: Wed, 17 Mar 2010 10:49:36 +0200
Message-Id: <1268815776-29501-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <4BA09776.4020205@gmail.com>
References: <4BA09776.4020205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When profiling a 32-bit process on a 64-bit kernel, callgraph tracing
stopped after the first function, because it has seen a garbage memory address
(tried to interpret the frame pointer, and return address as a 64-bit pointer).

Fix this by using a struct stack_frame with 32-bit pointers when the TIF_IA32 flag is set.

Note that TIF_IA32 flag must be used, and not is_compat_task(), because the
latter is only set when the 32-bit process is executing a syscall,
which may not always be the case (when tracing page fault events for example).

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c |   38 +++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/dumpstack.h      |    5 +++++
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8c1c070..51f72f7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -26,6 +26,7 @@
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
+#include <asm/compat.h>
 
 static u64 perf_event_mask __read_mostly;
 
@@ -2392,14 +2393,32 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	return len;
 }
 
-static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
+#ifdef CONFIG_COMPAT
+
+static inline void
+perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
-	unsigned long bytes;
+	/* 32-bit process in 64-bit kernel. */
+	struct stack_frame_ia32 frame;
+	const void __user *fp = compat_ptr(regs->bp);
+
+	while (entry->nr < PERF_MAX_STACK_DEPTH) {
+		unsigned long bytes;
+		frame.next_frame     = 0;
+		frame.return_address = 0;
+
+		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		if (bytes != sizeof(frame))
+			break;
 
-	bytes = copy_from_user_nmi(frame, fp, sizeof(*frame));
+		if (fp < compat_ptr(regs->sp))
+			break;
 
-	return bytes == sizeof(*frame);
+		callchain_store(entry, frame.return_address);
+		fp = compat_ptr(frame.next_frame);
+	}
 }
+#endif
 
 static void
 perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
@@ -2415,11 +2434,20 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	callchain_store(entry, PERF_CONTEXT_USER);
 	callchain_store(entry, regs->ip);
 
+#ifdef CONFIG_COMPAT
+	if (test_thread_flag(TIF_IA32)) {
+		perf_callchain_user32(regs, entry);
+		return;
+	}
+#endif
+
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
+		unsigned long bytes;
 		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
-		if (!copy_stack_frame(fp, &frame))
+		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		if (bytes != sizeof(frame))
 			break;
 
 		if ((unsigned long)fp < regs->sp)
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index 4fd1420..3f0a242 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -29,4 +29,9 @@ struct stack_frame {
 	struct stack_frame *next_frame;
 	unsigned long return_address;
 };
+
+struct stack_frame_ia32 {
+    u32 next_frame;
+    u32 return_address;
+};
 #endif
-- 
1.7.0

