Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2FYJmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:42:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43318 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2FYJmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:42:22 -0400
Date: Mon, 25 Jun 2012 11:42:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] bug.h: Fix up x86 build regression
Message-ID: <20120625094215.GA25847@gmail.com>
References: <20120618045417.GB19803@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120618045417.GB19803@linux-sh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mundt <lethal@linux-sh.org> wrote:

> The asm-generic/bug.h __ASSEMBLY__ guarding is completely bogus, which
> tripped up the powerpc build when the kernel.h include was added:
> 
> 	In file included from include/asm-generic/bug.h:5:0,
> 			 from arch/powerpc/include/asm/bug.h:127,
> 			 from arch/powerpc/kernel/head_64.S:31:
> 	include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by default]
> 	include/linux/linkage.h:57:0: note: this is the location of the previous definition
> 	include/linux/sysinfo.h: Assembler messages:
> 	include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
> 	include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long_t'
> 
> Moving the __ASSEMBLY__ guard up and stashing the kernel.h include under
> it fixes this up, as well as covering the case the original fix was
> attempting to handle.
> 
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

This commit broke most x86 !CONFIG_BUG builds in -rc4:

In file included from /home/mingo/tip/arch/x86/include/asm/cpumask.h:4:0,
                 from /home/mingo/tip/arch/x86/include/asm/msr.h:18,
                 from /home/mingo/tip/arch/x86/include/asm/processor.h:20,
                 from /home/mingo/tip/arch/x86/include/asm/atomic.h:6,
                 from include/linux/atomic.h:4,
                 from include/linux/crypto.h:20,
                 from arch/x86/kernel/asm-offsets.c:8:
include/linux/cpumask.h: In function ‘cpumask_check’:
include/linux/cpumask.h:108:2: error: implicit declaration of function ‘WARN_ON_ONCE’ [-Werror=implicit-function-declaration]
In file included from include/linux/thread_info.h:54:0,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:12,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets.c:8:
/home/mingo/tip/arch/x86/include/asm/thread_info.h: In function ‘set_restore_sigmask’:
/home/mingo/tip/arch/x86/include/asm/thread_info.h:251:2: error: implicit declaration of function ‘WARN_ON’ [-Werror=implicit-function-declaration]
In file included from /home/mingo/tip/arch/x86/include/asm/apic.h:12:0,
                 from /home/mingo/tip/arch/x86/include/asm/smp.h:13,
                 from include/linux/smp.h:38,
                 from include/linux/topology.h:33,
                 from include/linux/gfp.h:7,
                 from include/linux/slab.h:12,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets.c:8:
/home/mingo/tip/arch/x86/include/asm/fixmap.h: In function ‘virt_to_fix’:
/home/mingo/tip/arch/x86/include/asm/fixmap.h:219:2: error: implicit declaration of function ‘BUG_ON’ [-Werror=implicit-function-declaration]
In file included from include/linux/slab.h:185:0,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets.c:8:
include/linux/slub_def.h: In function ‘kmalloc_index’:
include/linux/slub_def.h:192:2: error: implicit declaration of function ‘BUG’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

The commit mis-placed the !ASSEMBLY block, mixing it with the 
CONFIG_BUG section.

Hiding an #include <kernel.h> deep inside a generic header is in 
pretty bad taste anyway, it creates kconfig dependent breakages 
and makes it harder to untangle header files.

The patch below fixes most of the bad effects for me on x86, but 
I have not tested the PowerPC cross-build yet.

Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 506ec19..25565b7 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -3,6 +3,10 @@
 
 #include <linux/compiler.h>
 
+#ifndef __ASSEMBLY__
+#include <linux/kernel.h>
+#endif /* __ASSEMBLY__ */
+
 #ifdef CONFIG_BUG
 
 #ifdef CONFIG_GENERIC_BUG
@@ -31,9 +35,6 @@ struct bug_entry {
 
 #endif	/* CONFIG_GENERIC_BUG */
 
-#ifndef __ASSEMBLY__
-#include <linux/kernel.h>
-
 /*
  * Don't use BUG() or BUG_ON() unless there's really no way out; one
  * example might be detecting data structure corruption in the middle
@@ -108,6 +109,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 })
 
 #else /* !CONFIG_BUG */
+
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
 #endif
@@ -203,6 +205,4 @@ extern void warn_slowpath_null(const char *file, const int line);
 # define WARN_ON_SMP(x)			({0;})
 #endif
 
-#endif /* __ASSEMBLY__ */
-
 #endif
