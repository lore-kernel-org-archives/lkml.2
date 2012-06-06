Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab2FFQEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:04:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40413 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab2FFQEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:04:10 -0400
Date: Wed, 6 Jun 2012 09:03:55 -0700
From: tip-bot for Arun Sharma <asharma@fb.com>
Message-ID: <tip-bc6ca7b342d5ae15c3ba3081fd40271b8039fb25@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1334961696-19580-4-git-send-email-asharma@fb.com>
References: <1334961696-19580-4-git-send-email-asharma@fb.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Check if user fp is valid
Git-Commit-ID: bc6ca7b342d5ae15c3ba3081fd40271b8039fb25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:04:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc6ca7b342d5ae15c3ba3081fd40271b8039fb25
Gitweb:     http://git.kernel.org/tip/bc6ca7b342d5ae15c3ba3081fd40271b8039fb25
Author:     Arun Sharma <asharma@fb.com>
AuthorDate: Fri, 20 Apr 2012 15:41:35 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:08:01 +0200

perf/x86: Check if user fp is valid

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334961696-19580-4-git-send-email-asharma@fb.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/uaccess.h   |   12 ++++++------
 arch/x86/kernel/cpu/perf_event.c |   12 ++++++++++++
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 04cd688..e1f3a17 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -33,9 +33,8 @@
 #define segment_eq(a, b)	((a).seg == (b).seg)
 
 #define user_addr_max() (current_thread_info()->addr_limit.seg)
-#define __addr_ok(addr)					\
-	((unsigned long __force)(addr) <		\
-	 (current_thread_info()->addr_limit.seg))
+#define __addr_ok(addr) 	\
+	((unsigned long __force)(addr) < user_addr_max())
 
 /*
  * Test whether a block of memory is a valid user space address.
@@ -47,14 +46,14 @@
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
 
@@ -77,7 +76,8 @@
  * checks that the pointer is in the user space range - after calling
  * this function, memory access functions may still return -EFAULT.
  */
-#define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
+#define access_ok(type, addr, size) \
+	(likely(__range_not_ok(addr, size, user_addr_max()) == 0))
 
 /*
  * The exception table consists of pairs of addresses relative to the
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e78bc25..c4706cf 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1757,6 +1757,12 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
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
@@ -1781,6 +1787,9 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		if (bytes != sizeof(frame))
 			break;
 
+		if (!valid_user_frame(fp, sizeof(frame)))
+			break;
+
 		perf_callchain_store(entry, frame.return_address);
 		fp = compat_ptr(frame.next_frame);
 	}
@@ -1824,6 +1833,9 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		if (bytes != sizeof(frame))
 			break;
 
+		if (!valid_user_frame(fp, sizeof(frame)))
+			break;
+
 		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
