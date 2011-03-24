Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab1CXSNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:13:24 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:44076 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1CXSNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:13:21 -0400
Date: Thu, 24 Mar 2011 20:13:18 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Ingo Molnar <mingo@elte.hu>
cc: Christoph Lameter <cl@linux.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <20110324172653.GA28507@elte.hu>
Message-ID: <alpine.DEB.2.00.1103242011540.4990@tiger>
References: <alpine.DEB.2.00.1103221635400.4521@tiger> <20110324142146.GA11682@elte.hu> <alpine.DEB.2.00.1103240940570.32226@router.home> <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com> <20110324172653.GA28507@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1280347503-1300990398=:4990"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1280347503-1300990398=:4990
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Ingo,

On Thu, 24 Mar 2011, Ingo Molnar wrote:
> * Pekka Enberg <penberg@kernel.org> wrote:
>
>> On Thu, Mar 24, 2011 at 4:41 PM, Christoph Lameter <cl@linux.com> wrote:
>>> On Thu, 24 Mar 2011, Ingo Molnar wrote:
>>>
>>>> FYI, some sort of boot crash has snuck upstream in the last 24 hours:
>>>>
>>>>  BUG: unable to handle kernel paging request at ffff87ffc147e020
>>>>  IP: [<ffffffff811aa762>] this_cpu_cmpxchg16b_emu+0x2/0x1c
>>>
>>> Hmmm.. This is the fallback code for the case that the processor does not
>>> support cmpxchg16b.
>>
>> How does alternative_io() work? Does it require
>> alternative_instructions() to be executed. If so, the fallback code
>> won't be active when we enter kmem_cache_init(). Is there any reason
>> check_bugs() is called so late during boot? Can we do something like
>> the totally untested attached patch?
>
> Does the config i sent you boot on your box? I think the bug is pretty generic
> and should trigger on any box.

Here's a patch that reorganizes the alternatives fixup to happen earlier 
so that the fallback should work. It boots on my machine so please give it 
a spin if possible.

I'll try out your .config next.

 			Pekka

>From dd1534455196d2a8f6c9c912db614e59986c9f0e Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@kernel.org>
Date: Thu, 24 Mar 2011 19:59:35 +0200
Subject: [PATCH] x86: Early boot alternative instructions

Commit 8a5ec0ba42c4919e2d8f4c3138cc8b987fdb0b79 ("Lockless (and preemptless)
fastpaths for slub") added use of cmpxchg16b in kmem_cache_init() which happens
early on during the boot. As cmpxchg16b is not supported on some older AMD
CPUs, there's a alternative_io() fallback for cmpxchg16b emulation.

Unfortunately alternative_instructions() happens late in the boot sequence so
the fallback code is not patched into kernel text which causes the following oops:

  BUG: unable to handle kernel paging request at ffff87ffc147e020
  IP: [<ffffffff811aa762>] this_cpu_cmpxchg16b_emu+0x2/0x1c

     [<ffffffff810d9cbc>] ? kmem_cache_alloc+0x4c/0x110
     [<ffffffff8151cf06>] kmem_cache_init+0xeb/0x2b0
     [<ffffffff81504a06>] start_kernel+0x1de/0x49b
     [<ffffffff8150432b>] x86_64_start_reservations+0x132/0x136
     [<ffffffff81504140>] ? early_idt_handlers+0x140/0x140

This patch reorganizes the code so that alternative_io() tagged fallbacks are
patched to the kernel before kmem_cache_init() is called.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
  arch/x86/include/asm/alternative.h |    1 +
  arch/x86/kernel/alternative.c      |   12 +++++++++++-
  arch/x86/kernel/cpu/bugs.c         |    2 --
  arch/x86/kernel/cpu/bugs_64.c      |    2 --
  include/asm-generic/alternative.h  |   19 +++++++++++++++++++
  init/main.c                        |    3 +++
  6 files changed, 34 insertions(+), 5 deletions(-)
  create mode 100644 include/asm-generic/alternative.h

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 13009d1..ca819c6 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -54,6 +54,7 @@ struct alt_instr {
  #endif
  };

+extern void alternative_instructions_early(void);
  extern void alternative_instructions(void);
  extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4a23467..32e96dd 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -453,7 +453,7 @@ extern struct paravirt_patch_site __start_parainstructions[],
  	__stop_parainstructions[];
  #endif	/* CONFIG_PARAVIRT */

-void __init alternative_instructions(void)
+void __init alternative_instructions_early(void)
  {
  	/* The patching is not fully atomic, so try to avoid local interruptions
  	   that might execute the to be patched code.
@@ -473,6 +473,16 @@ void __init alternative_instructions(void)

  	apply_alternatives(__alt_instructions, __alt_instructions_end);

+	restart_nmi();
+}
+
+void __init alternative_instructions(void)
+{
+	/* The patching is not fully atomic, so try to avoid local interruptions
+	   that might execute the to be patched code.
+	   Other CPUs are not running. */
+	stop_nmi();
+
  	/* switch to patch-once-at-boottime-only mode and free the
  	 * tables in case we know the number of CPUs will never ever
  	 * change */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c39576c..3854e58 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -15,7 +15,6 @@
  #include <asm/i387.h>
  #include <asm/msr.h>
  #include <asm/paravirt.h>
-#include <asm/alternative.h>

  static int __init no_halt(char *s)
  {
@@ -165,5 +164,4 @@ void __init check_bugs(void)
  	check_popad();
  	init_utsname()->machine[1] =
  		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
-	alternative_instructions();
  }
diff --git a/arch/x86/kernel/cpu/bugs_64.c b/arch/x86/kernel/cpu/bugs_64.c
index 04f0fe5..1064db5 100644
--- a/arch/x86/kernel/cpu/bugs_64.c
+++ b/arch/x86/kernel/cpu/bugs_64.c
@@ -5,7 +5,6 @@

  #include <linux/kernel.h>
  #include <linux/init.h>
-#include <asm/alternative.h>
  #include <asm/bugs.h>
  #include <asm/processor.h>
  #include <asm/mtrr.h>
@@ -18,7 +17,6 @@ void __init check_bugs(void)
  	printk(KERN_INFO "CPU: ");
  	print_cpu_info(&boot_cpu_data);
  #endif
-	alternative_instructions();

  	/*
  	 * Make sure the first 2MB area is not mapped by huge pages
diff --git a/include/asm-generic/alternative.h b/include/asm-generic/alternative.h
new file mode 100644
index 0000000..893a070
--- /dev/null
+++ b/include/asm-generic/alternative.h
@@ -0,0 +1,19 @@
+/*
+ * linux/include/asm-generic/alternative.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_GENERIC_ALTERNATIVE_H__
+#define __ASM_GENERIC_ALTERNATIVE_H__
+
+static inline void alternative_instructions_early(void)
+{
+}
+
+static inline void alternative_instructions(void)
+{
+}
+
+#endif /* __ASM_GENERIC_ALTERNATIVE_H__ */
diff --git a/init/main.c b/init/main.c
index 4a9479e..0bb3c52 100644
--- a/init/main.c
+++ b/init/main.c
@@ -74,6 +74,7 @@
  #include <asm/setup.h>
  #include <asm/sections.h>
  #include <asm/cacheflush.h>
+#include <asm/alternative.h>

  #ifdef CONFIG_X86_LOCAL_APIC
  #include <asm/smp.h>
@@ -508,6 +509,7 @@ asmlinkage void __init start_kernel(void)
  	vfs_caches_init_early();
  	sort_main_extable();
  	trap_init();
+	alternative_instructions_early();
  	mm_init();
  	/*
  	 * Set up the scheduler prior starting any interrupts (such as the
@@ -614,6 +616,7 @@ asmlinkage void __init start_kernel(void)
  	taskstats_init_early();
  	delayacct_init();

+	alternative_instructions();
  	check_bugs();

  	acpi_early_init(); /* before LAPIC and SMP init */
-- 
1.7.0.4

--8323329-1280347503-1300990398=:4990--
