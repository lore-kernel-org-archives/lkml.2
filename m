Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0DVTrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:47:14 -0400
Received: from kroah.org ([198.145.64.141]:41125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab0DVT3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:06 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:18 2010
Message-Id: <20100422190918.093756020@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [120/197] x86-64: support native xadd rwsem implementation
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit bafaecd11df15ad5b1e598adc7736afcd38ee13d upstream.

This one is much faster than the spinlock based fallback rwsem code,
with certain artifical benchmarks having shown 300%+ improvement on
threaded page faults etc.

Again, note the 32767-thread limit here. So this really does need that
whole "make rwsem_count_t be 64-bit and fix the BIAS values to match"
extension on top of it, but that is conceptually a totally independent
issue.

NOT TESTED! The original patch that this all was based on were tested by
KAMEZAWA Hiroyuki, but maybe I screwed up something when I created the
cleaned-up series, so caveat emptor..

Also note that it _may_ be a good idea to mark some more registers
clobbered on x86-64 in the inline asms instead of saving/restoring them.
They are inline functions, but they are only used in places where there
are not a lot of live registers _anyway_, so doing for example the
clobbers of %r8-%r11 in the asm wouldn't make the fast-path code any
worse, and would make the slow-path code smaller.

(Not that the slow-path really matters to that degree. Saving a few
unnecessary registers is the _least_ of our problems when we hit the slow
path. The instruction/cycle counting really only matters in the fast
path).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <alpine.LFD.2.00.1001121810410.17145@localhost.localdomain>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig.cpu    |    2 -
 arch/x86/lib/Makefile   |    1 
 arch/x86/lib/rwsem_64.S |   81 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -323,7 +323,7 @@ config X86_L1_CACHE_SHIFT
 
 config X86_XADD
 	def_bool y
-	depends on X86_32 && !M386
+	depends on X86_64 || !M386
 
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -26,4 +26,5 @@ else
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
+	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
 endif
--- /dev/null
+++ b/arch/x86/lib/rwsem_64.S
@@ -0,0 +1,81 @@
+/*
+ * x86-64 rwsem wrappers
+ *
+ * This interfaces the inline asm code to the slow-path
+ * C routines. We need to save the call-clobbered regs
+ * that the asm does not mark as clobbered, and move the
+ * argument from %rax to %rdi.
+ *
+ * NOTE! We don't need to save %rax, because the functions
+ * will always return the semaphore pointer in %rax (which
+ * is also the input argument to these helpers)
+ *
+ * The following can clobber %rdx because the asm clobbers it:
+ *   call_rwsem_down_write_failed
+ *   call_rwsem_wake
+ * but %rdi, %rsi, %rcx, %r8-r11 always need saving.
+ */
+
+#include <linux/linkage.h>
+#include <asm/rwlock.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+#define save_common_regs \
+	pushq %rdi; \
+	pushq %rsi; \
+	pushq %rcx; \
+	pushq %r8; \
+	pushq %r9; \
+	pushq %r10; \
+	pushq %r11
+
+#define restore_common_regs \
+	popq %r11; \
+	popq %r10; \
+	popq %r9; \
+	popq %r8; \
+	popq %rcx; \
+	popq %rsi; \
+	popq %rdi
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_down_read_failed)
+	save_common_regs
+	pushq %rdx
+	movq %rax,%rdi
+	call rwsem_down_read_failed
+	popq %rdx
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_down_read_failed)
+
+ENTRY(call_rwsem_down_write_failed)
+	save_common_regs
+	movq %rax,%rdi
+	call rwsem_down_write_failed
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_down_write_failed)
+
+ENTRY(call_rwsem_wake)
+	decw %dx    /* do nothing if still outstanding active readers */
+	jnz 1f
+	save_common_regs
+	movq %rax,%rdi
+	call rwsem_wake
+	restore_common_regs
+1:	ret
+	ENDPROC(call_rwsem_wake)
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_downgrade_wake)
+	save_common_regs
+	pushq %rdx
+	movq %rax,%rdi
+	call rwsem_downgrade_wake
+	popq %rdx
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_downgrade_wake)


