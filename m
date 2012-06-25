Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab2FYKvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:51:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40057 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2FYKvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:51:04 -0400
Date: Mon, 25 Jun 2012 12:50:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH, v2] bug.h: Fix up x86 build regression
Message-ID: <20120625105059.GA28848@gmail.com>
References: <20120618045417.GB19803@linux-sh.org>
 <20120625094215.GA25847@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120625094215.GA25847@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > The asm-generic/bug.h __ASSEMBLY__ guarding is completely bogus, which
> > tripped up the powerpc build when the kernel.h include was added:
> > 
> > 	In file included from include/asm-generic/bug.h:5:0,
> > 			 from arch/powerpc/include/asm/bug.h:127,
> > 			 from arch/powerpc/kernel/head_64.S:31:
> > 	include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by default]
> > 	include/linux/linkage.h:57:0: note: this is the location of the previous definition
> > 	include/linux/sysinfo.h: Assembler messages:
> > 	include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
> > 	include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long_t'
> > 
> > Moving the __ASSEMBLY__ guard up and stashing the kernel.h include under
> > it fixes this up, as well as covering the case the original fix was
> > attempting to handle.
> > 
> > Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> This commit broke most x86 !CONFIG_BUG builds in -rc4:
> 
> In file included from /home/mingo/tip/arch/x86/include/asm/cpumask.h:4:0,
>                  from /home/mingo/tip/arch/x86/include/asm/msr.h:18,
>                  from /home/mingo/tip/arch/x86/include/asm/processor.h:20,
>                  from /home/mingo/tip/arch/x86/include/asm/atomic.h:6,
>                  from include/linux/atomic.h:4,
>                  from include/linux/crypto.h:20,
>                  from arch/x86/kernel/asm-offsets.c:8:
> include/linux/cpumask.h: In function ‘cpumask_check’:
> include/linux/cpumask.h:108:2: error: implicit declaration of function ‘WARN_ON_ONCE’ [-Werror=implicit-function-declaration]
> In file included from include/linux/thread_info.h:54:0,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/mmzone.h:7,
>                  from include/linux/gfp.h:4,
>                  from include/linux/slab.h:12,
>                  from include/linux/crypto.h:24,
>                  from arch/x86/kernel/asm-offsets.c:8:
> /home/mingo/tip/arch/x86/include/asm/thread_info.h: In function ‘set_restore_sigmask’:
> /home/mingo/tip/arch/x86/include/asm/thread_info.h:251:2: error: implicit declaration of function ‘WARN_ON’ [-Werror=implicit-function-declaration]
> In file included from /home/mingo/tip/arch/x86/include/asm/apic.h:12:0,
>                  from /home/mingo/tip/arch/x86/include/asm/smp.h:13,
>                  from include/linux/smp.h:38,
>                  from include/linux/topology.h:33,
>                  from include/linux/gfp.h:7,
>                  from include/linux/slab.h:12,
>                  from include/linux/crypto.h:24,
>                  from arch/x86/kernel/asm-offsets.c:8:
> /home/mingo/tip/arch/x86/include/asm/fixmap.h: In function ‘virt_to_fix’:
> /home/mingo/tip/arch/x86/include/asm/fixmap.h:219:2: error: implicit declaration of function ‘BUG_ON’ [-Werror=implicit-function-declaration]
> In file included from include/linux/slab.h:185:0,
>                  from include/linux/crypto.h:24,
>                  from arch/x86/kernel/asm-offsets.c:8:
> include/linux/slub_def.h: In function ‘kmalloc_index’:
> include/linux/slub_def.h:192:2: error: implicit declaration of function ‘BUG’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 
> The commit mis-placed the !ASSEMBLY block, mixing it with the 
> CONFIG_BUG section.
> 
> Hiding an #include <kernel.h> deep inside a generic header is in 
> pretty bad taste anyway, it creates kconfig dependent breakages 
> and makes it harder to untangle header files.
> 
> The patch below fixes most of the bad effects for me on x86, but 
> I have not tested the PowerPC cross-build yet.

I did a PowerPC cross-build and it was not quite there yet, but 
the second version below does the trick and fixes x86 and 
powerpc as well.

Linus, if there are no objections to the patch then I can push 
this fix to you via tip:core/urgent (where it's queued up 
currently), or you could apply it via email as well.

Thanks,

	Ingo

------------->
>From 7b37393f13d511fa076d4527e35e86cc45d974c5 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Mon, 25 Jun 2012 11:42:15 +0200
Subject: [PATCH] bug.h: Fix x86 !CONFIG_BUG build regression
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 2603efa31a03 ("bug.h: Fix up powerpc build regression.")
broke most x86 !CONFIG_BUG builds in -rc4:

  include/linux/cpumask.h: In function ‘cpumask_check’:
  include/linux/cpumask.h:108:2: error: implicit declaration of function ‘WARN_ON_ONCE’
  [...]

The commit mis-placed the !ASSEMBLY block, mixing it with the
CONFIG_BUG section.

Hiding an #include <kernel.h> deep inside a generic header is in
pretty bad taste anyway, it creates kconfig dependent breakages
and makes it harder to untangle header files.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/20120625094215.GA25847@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/asm-generic/bug.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 506ec19..53f3eb1 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -3,6 +3,10 @@
 
 #include <linux/compiler.h>
 
+#ifndef __ASSEMBLY__
+# include <linux/kernel.h>
+#endif
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
@@ -63,6 +64,8 @@ struct bug_entry {
  * to provide better diagnostics.
  */
 #ifndef __WARN_TAINT
+
+#ifndef __ASSEMBLY__
 extern __printf(3, 4)
 void warn_slowpath_fmt(const char *file, const int line,
 		       const char *fmt, ...);
@@ -70,6 +73,8 @@ extern __printf(4, 5)
 void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 			     const char *fmt, ...);
 extern void warn_slowpath_null(const char *file, const int line);
+#endif /* __ASSEMBLY__ */
+
 #define WANT_WARN_ON_SLOWPATH
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
@@ -108,6 +113,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 })
 
 #else /* !CONFIG_BUG */
+
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
 #endif
@@ -203,6 +209,4 @@ extern void warn_slowpath_null(const char *file, const int line);
 # define WARN_ON_SMP(x)			({0;})
 #endif
 
-#endif /* __ASSEMBLY__ */
-
 #endif
