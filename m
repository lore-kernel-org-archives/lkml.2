Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2CMOGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:06:18 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41392 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab2CMOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:06:17 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 13 Mar 2012 19:33:03 +0530
Message-Id: <20120313140303.17134.1401.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 1/2] x86: Move is_ia32_task to asm/thread_info.h from asm/compat.h
x-cbid: 12031314-5564-0000-0000-000001C7BA07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

is_ia32_task is useful even in !CONFIG_COMPAT cases. Hence move it
to a more generic file asm/thread_info.h

Also now is_ia32_task returns true if CONFIG_X86_32 is defined.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/include/asm/compat.h      |    9 ---------
 arch/x86/include/asm/thread_info.h |   12 ++++++++++++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 355edc0..d680579 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -235,15 +235,6 @@ static inline void __user *arch_compat_alloc_user_space(long len)
 	return (void __user *)round_down(sp - len, 16);
 }
 
-static inline bool is_ia32_task(void)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (current_thread_info()->status & TS_COMPAT)
-		return true;
-#endif
-	return false;
-}
-
 static inline bool is_x32_task(void)
 {
 #ifdef CONFIG_X86_X32_ABI
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index af1db7e..130fd4e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -266,6 +266,18 @@ static inline void set_restore_sigmask(void)
 	ti->status |= TS_RESTORE_SIGMASK;
 	set_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags);
 }
+
+static inline bool is_ia32_task(void)
+{
+#ifdef CONFIG_X86_32
+	return true;
+#endif
+#if defined CONFIG_X86_64 && defined CONFIG_IA32_EMULATION
+	if (current_thread_info()->status & TS_COMPAT)
+		return true;
+#endif
+	return false;
+}
 #endif	/* !__ASSEMBLY__ */
 
 #ifndef __ASSEMBLY__


