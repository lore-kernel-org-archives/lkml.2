Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1GUTcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:32:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:50356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1GUTb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:31:58 -0400
Date: Thu, 21 Jul 2011 19:31:46 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-1ac2e6ca44e13a087eb7438d284f887097ee7e84@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110607172413.GJ20052@erda.amd.com>
References: <20110607172413.GJ20052@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Make copy_from_user_nmi() a library function
Git-Commit-ID: 1ac2e6ca44e13a087eb7438d284f887097ee7e84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 19:31:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ac2e6ca44e13a087eb7438d284f887097ee7e84
Gitweb:     http://git.kernel.org/tip/1ac2e6ca44e13a087eb7438d284f887097ee7e84
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 7 Jun 2011 11:49:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 20:41:57 +0200

x86, perf: Make copy_from_user_nmi() a library function

copy_from_user_nmi() is used in oprofile and perf. Moving it to other
library functions like copy_from_user(). As this is x86 code for 32
and 64 bits, create a new file usercopy.c for unified code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110607172413.GJ20052@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uaccess.h   |    3 ++
 arch/x86/kernel/cpu/perf_event.c |   35 ------------------------------
 arch/x86/lib/Makefile            |    2 +-
 arch/x86/lib/usercopy.c          |   43 ++++++++++++++++++++++++++++++++++++++
 arch/x86/oprofile/backtrace.c    |   39 +---------------------------------
 5 files changed, 48 insertions(+), 74 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 99ddd14..36361bf 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -555,6 +555,9 @@ struct __large_struct { unsigned long buf[100]; };
 
 #endif /* CONFIG_X86_WP_WORKS_OK */
 
+extern unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b7a010f..4ee3abf 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -22,7 +22,6 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
-#include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
 
@@ -67,40 +66,6 @@ enum extra_reg_type {
 	EXTRA_REG_MAX		/* number of entries needed */
 };
 
-/*
- * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
- */
-static unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long offset, addr = (unsigned long)from;
-	unsigned long size, len = 0;
-	struct page *page;
-	void *map;
-	int ret;
-
-	do {
-		ret = __get_user_pages_fast(addr, 1, 0, &page);
-		if (!ret)
-			break;
-
-		offset = addr & (PAGE_SIZE - 1);
-		size = min(PAGE_SIZE - offset, n - len);
-
-		map = kmap_atomic(page);
-		memcpy(to, map+offset, size);
-		kunmap_atomic(map);
-		put_page(page);
-
-		len  += size;
-		to   += size;
-		addr += size;
-
-	} while (len < n);
-
-	return len;
-}
-
 struct event_constraint {
 	union {
 		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f2479f1..6ba4773 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
-lib-y += usercopy_$(BITS).o getuser.o putuser.o
+lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
new file mode 100644
index 0000000..97be9cb
--- /dev/null
+++ b/arch/x86/lib/usercopy.c
@@ -0,0 +1,43 @@
+/*
+ * User address space access functions.
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/highmem.h>
+#include <linux/module.h>
+
+/*
+ * best effort, GUP based copy_from_user() that is NMI-safe
+ */
+unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long offset, addr = (unsigned long)from;
+	unsigned long size, len = 0;
+	struct page *page;
+	void *map;
+	int ret;
+
+	do {
+		ret = __get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret)
+			break;
+
+		offset = addr & (PAGE_SIZE - 1);
+		size = min(PAGE_SIZE - offset, n - len);
+
+		map = kmap_atomic(page);
+		memcpy(to, map+offset, size);
+		kunmap_atomic(map);
+		put_page(page);
+
+		len  += size;
+		to   += size;
+		addr += size;
+
+	} while (len < n);
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(copy_from_user_nmi);
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 32f78eb..bff89df 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -12,10 +12,9 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/compat.h>
-#include <linux/highmem.h>
+#include <linux/uaccess.h>
 
 #include <asm/ptrace.h>
-#include <asm/uaccess.h>
 #include <asm/stacktrace.h>
 
 static int backtrace_stack(void *data, char *name)
@@ -38,42 +37,6 @@ static struct stacktrace_ops backtrace_ops = {
 	.walk_stack	= print_context_stack,
 };
 
-/* from arch/x86/kernel/cpu/perf_event.c: */
-
-/*
- * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
- */
-static unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long offset, addr = (unsigned long)from;
-	unsigned long size, len = 0;
-	struct page *page;
-	void *map;
-	int ret;
-
-	do {
-		ret = __get_user_pages_fast(addr, 1, 0, &page);
-		if (!ret)
-			break;
-
-		offset = addr & (PAGE_SIZE - 1);
-		size = min(PAGE_SIZE - offset, n - len);
-
-		map = kmap_atomic(page);
-		memcpy(to, map+offset, size);
-		kunmap_atomic(map);
-		put_page(page);
-
-		len  += size;
-		to   += size;
-		addr += size;
-
-	} while (len < n);
-
-	return len;
-}
-
 #ifdef CONFIG_COMPAT
 static struct stack_frame_ia32 *
 dump_user_backtrace_32(struct stack_frame_ia32 *head)
