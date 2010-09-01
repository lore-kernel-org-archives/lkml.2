Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab0IAGd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:33:57 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:63471 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751269Ab0IAGdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:33:54 -0400
Message-ID: <4C7DF3B7.7010305@snapgear.com>
Date: Wed, 1 Sep 2010 16:33:27 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/22] Fix M68K irqflags
References: <4C7B59E1.6010904@snapgear.com> <20100827015905.27277.39167.stgit@warthog.procyon.org.uk> <20100827020038.27277.27239.stgit@warthog.procyon.org.uk> <26799.1283201411@redhat.com>
In-Reply-To: <26799.1283201411@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2010 06:33:38.0945 (UTC) FILETIME=[9CCC3F10:01CB499F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/10 06:50, David Howells wrote:
> Greg Ungerer<gerg@snapgear.com>  wrote:
>
>> I have no problem with the changes as such. But I would rather
>> not have separate mm and no headers if we can avoid it.
>
> Well, I can roll the headers into one, but then it'll be much more #ifdef'd if
> you're okay with that.  The IRQ handling seems sufficiently different to
> warrant that.

Here is a spin of the same patch, only with a single irqflags.h.
It is closely modeled on the mm version, merging (and cleaning)
the non-mmu bits as needed. There is a fair bit of common code
in here.

It does refactor arch_local_irq_save() but I am pretty sure that
makes no impact (performance or code size). I have left
arch_irq_enable as-is for all, it is not clear to me why it is
the way it is for the mm case (Geert?)

This is not run or compile tested...

Regards
Greg



  arch/m68k/include/asm/irqflags.h  |   88 
+++++++++++++++++++++++++++++++++++++
  arch/m68k/include/asm/system_mm.h |   25 +----------
  arch/m68k/include/asm/system_no.h |   49 +--------------------
  3 files changed, 90 insertions(+), 72 deletions(-)
  create mode 100644 arch/m68k/include/asm/irqflags.h

diff --git a/arch/m68k/include/asm/irqflags.h 
b/arch/m68k/include/asm/irqflags.h
new file mode 100644
index 0000000..b61edcc
--- /dev/null
+++ b/arch/m68k/include/asm/irqflags.h
@@ -0,0 +1,88 @@
+#ifndef _M68K_IRQFLAGS_MM_H
+#define _M68K_IRQFLAGS_MM_H
+
+#include <linux/types.h>
+#include <linux/hardirq.h>
+#include <asm/thread_info.h>
+#include <asm/entry.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile ("movew %%sr,%0": "=d" (flags) : : "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+#ifdef CONFIG_COLDFIRE
+	asm volatile (
+		"move	%/sr,%%d0	\n\t"
+		"ori.l	#0x0700,%%d0	\n\t"
+		"move	%%d0,%/sr	\n"
+		: /* no outputs */
+		:
+		: "cc", "%d0", "memory");
+#else
+	asm volatile ("oriw  #0x0700,%%sr" : : : "memory");
+#endif
+}
+
+#ifdef CONFIG_MMU
+#if 0
+static inline void arch_local_irq_enable(void)
+{
+		asm volatile ("andiw %0,%%sr" : : "i" (ALLOWINT) : "memory");
+}
+#else
+#define arch_local_irq_enable()						\
+	do {								\
+		if (MACH_IS_Q40 || !hardirq_count())			\
+			asm volatile ("andiw %0,%%sr"			\
+				      : : "i" (ALLOWINT) : "memory");	\
+	} while (0)
+#endif
+#else
+static inline void arch_local_irq_enable(void)
+{
+#ifdef CONFIG_COLDFIRE
+	asm volatile (
+		"move	%/sr,%%d0	\n\t"
+		"andi.l	#0xf8ff,%%d0	\n\t"
+		"move	%%d0,%/sr	\n"
+		: /* no outputs */
+		:
+		: "cc", "%d0", "memory");
+#else
+	asm volatile (
+		"andiw %0,%%sr"
+		:
+		: "i" (ALLOWINT)
+		: "memory")
+#endif
+}
+#endif
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	arch_local_irq_disable();
+	return flags;
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile ("movew %0,%%sr": : "d" (flags) : "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & ~ALLOWINT) != 0;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* _M68K_IRQFLAGS_MM_H */
diff --git a/arch/m68k/include/asm/system_mm.h 
b/arch/m68k/include/asm/system_mm.h
index 485daec..47b01f4 100644
--- a/arch/m68k/include/asm/system_mm.h
+++ b/arch/m68k/include/asm/system_mm.h
@@ -3,6 +3,7 @@

  #include <linux/linkage.h>
  #include <linux/kernel.h>
+#include <linux/irqflags.h>
  #include <asm/segment.h>
  #include <asm/entry.h>

@@ -62,30 +63,6 @@ asmlinkage void resume(void);
  #define smp_wmb()	barrier()
  #define smp_read_barrier_depends()	((void)0)

-/* interrupt control.. */
-#if 0
-#define local_irq_enable() asm volatile ("andiw %0,%%sr": : "i" 
(ALLOWINT) : "memory")
-#else
-#include <linux/hardirq.h>
-#define local_irq_enable() ({							\
-	if (MACH_IS_Q40 || !hardirq_count())					\
-		asm volatile ("andiw %0,%%sr": : "i" (ALLOWINT) : "memory");	\
-})
-#endif
-#define local_irq_disable() asm volatile ("oriw  #0x0700,%%sr": : : 
"memory")
-#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : 
"memory")
-#define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) : 
"memory")
-
-static inline int irqs_disabled(void)
-{
-	unsigned long flags;
-	local_save_flags(flags);
-	return flags & ~ALLOWINT;
-}
-
-/* For spinlocks etc */
-#define local_irq_save(x)	({ local_save_flags(x); local_irq_disable(); })
-
  #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned 
long)(x),(ptr),sizeof(*(ptr))))

  struct __xchg_dummy { unsigned long a[100]; };
diff --git a/arch/m68k/include/asm/system_no.h 
b/arch/m68k/include/asm/system_no.h
index 08f31bd..2bf670d 100644
--- a/arch/m68k/include/asm/system_no.h
+++ b/arch/m68k/include/asm/system_no.h
@@ -2,6 +2,7 @@
  #define _M68KNOMMU_SYSTEM_H

  #include <linux/linkage.h>
+#include <linux/irqflags.h>
  #include <asm/segment.h>
  #include <asm/entry.h>

@@ -46,54 +47,6 @@ asmlinkage void resume(void);
    (last) = _last;						\
  }

-#ifdef CONFIG_COLDFIRE
-#define local_irq_enable() __asm__ __volatile__ (		\
-	"move %/sr,%%d0\n\t"					\
-	"andi.l #0xf8ff,%%d0\n\t"				\
-	"move %%d0,%/sr\n"					\
-	: /* no outputs */					\
-	:							\
-        : "cc", "%d0", "memory")
-#define local_irq_disable() __asm__ __volatile__ (		\
-	"move %/sr,%%d0\n\t"					\
-	"ori.l #0x0700,%%d0\n\t"				\
-	"move %%d0,%/sr\n"					\
-	: /* no outputs */					\
-	:							\
-	: "cc", "%d0", "memory")
-/* For spinlocks etc */
-#define local_irq_save(x) __asm__ __volatile__ (		\
-	"movew %%sr,%0\n\t"					\
-	"movew #0x0700,%%d0\n\t"				\
-	"or.l  %0,%%d0\n\t"					\
-	"movew %%d0,%/sr"					\
-	: "=d" (x)						\
-	:							\
-	: "cc", "%d0", "memory")
-#else
-
-/* portable version */ /* FIXME - see entry.h*/
-#define ALLOWINT 0xf8ff
-
-#define local_irq_enable() asm volatile ("andiw %0,%%sr": : "i" 
(ALLOWINT) : "memory")
-#define local_irq_disable() asm volatile ("oriw  #0x0700,%%sr": : : 
"memory")
-#endif
-
-#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : 
"memory")
-#define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) : 
"memory")
-
-/* For spinlocks etc */
-#ifndef local_irq_save
-#define local_irq_save(x) do { local_save_flags(x); 
local_irq_disable(); } while (0)
-#endif
-
-#define	irqs_disabled()			\
-({					\
-	unsigned long flags;		\
-	local_save_flags(flags);	\
-	((flags & 0x0700) == 0x0700);	\
-})
-
  #define iret() __asm__ __volatile__ ("rte": : :"memory", "sp", "cc")

  /*



