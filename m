Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2DTWxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:53:06 -0400
Received: from outmail019.snc4.facebook.com ([66.220.144.153]:48871 "EHLO
	intmgw001.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756376Ab2DTWw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:52:59 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/4] perf, x86: Check if user fp is valid
Date: Fri, 20 Apr 2012 15:41:35 -0700
Message-Id: <1334961696-19580-4-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1334961696-19580-1-git-send-email-asharma@fb.com>
References: <1334961696-19580-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/uaccess.h   |   13 +++++++------
 arch/x86/kernel/cpu/perf_event.c |   12 ++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e054459..997d59b 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -32,9 +32,9 @@
 
 #define segment_eq(a, b)	((a).seg == (b).seg)
 
-#define __addr_ok(addr)					\
-	((unsigned long __force)(addr) <		\
-	 (current_thread_info()->addr_limit.seg))
+#define __cur_addr_limit	(current_thread_info()->addr_limit.seg)
+#define __addr_ok(addr) 	\
+	((unsigned long __force)(addr) < __cur_addr_limit)
 
 /*
  * Test whether a block of memory is a valid user space address.
@@ -46,14 +46,14 @@
  * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
 
-#define __range_not_ok(addr, size)					\
+#define __range_not_ok(addr, size, limit)				\
 ({									\
 	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
 	asm("add %3,%1 ; sbb %0,%0 ; cmp %1,%4 ; sbb $0,%0"		\
 	    : "=&r" (flag), "=r" (roksum)				\
 	    : "1" (addr), "g" ((long)(size)),				\
-	      "rm" (current_thread_info()->addr_limit.seg));		\
+	      "rm" (limit));						\
 	flag;								\
 })
 
@@ -76,7 +76,8 @@
  * checks that the pointer is in the user space range - after calling
  * this function, memory access functions may still return -EFAULT.
  */
-#define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
+#define access_ok(type, addr, size) \
+	(likely(__range_not_ok(addr, size, __cur_addr_limit) == 0))
 
 /*
  * The exception table consists of pairs of addresses: the first is the
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9f98636..3e4be2c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1761,6 +1761,12 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
 }
 
+static inline int
+valid_user_frame(const void __user *fp, unsigned long size)
+{
+	return (__range_not_ok(fp, size, TASK_SIZE) == 0);
+}
+
 #ifdef CONFIG_COMPAT
 
 #include <asm/compat.h>
@@ -1785,6 +1791,9 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		if (bytes != sizeof(frame))
 			break;
 
+		if (!valid_user_frame(fp, sizeof(frame)))
+			break;
+
 		perf_callchain_store(entry, frame.return_address);
 		fp = compat_ptr(frame.next_frame);
 	}
@@ -1828,6 +1837,9 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		if (bytes != sizeof(frame))
 			break;
 
+		if (!valid_user_frame(fp, sizeof(frame)))
+			break;
+
 		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
-- 
1.7.8.4

