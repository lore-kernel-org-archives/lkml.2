Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2KHUsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:48:41 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:33782 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab2KHUsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:48:39 -0500
Message-ID: <509C1A92.9080407@ahsoftware.de>
Date: Thu, 08 Nov 2012 21:48:18 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
Subject: [RFC] arm: memtest
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've recently discovered the lack of the command line parameter memtest 
for ARM. So I've made a patch.

But I have some questions:

1. arch/x86/mm/memtest.c looks platform independ.
The only thing why I don't use it for arm, is because it uses 64bit 
pointers. Maybe it could be moved to mm/memtest.c. If so, the 
memtest32.c I'm using (basically a copy of memtest.c) could be moved 
there too.

2. Because the below memtest32.c is basically a copy of 
arch/x86/mm/memtest.c, I'm not sure if the mapping from physical to 
virtual locations there does fit (always) for ARM too. I know almost as 
much about the in-kernel memory organization on x86 as on ARM, which is 
not really that much (some theory about TLBs, some source code 
explorations, ..., but I'm working on it). ;)

3. I've just implemented a test for all the memory which is marked as 
free, leaving all reserved memory untested. But even if a full memory 
test could only be done in the boot-loader, I think at least some of the 
memory the kernel reserves for itself (e.g. for modules) could be tested 
too. I just haven't searched how/where this could be done. Maybe someone 
else has a hint or even a patch for the below patch.

4. I don't have an ARM box with bad memory. So my tests are a bit 
limited. Maybe someone else could do a test with real bad memory.

Anyway, I would still prefer to have at least the possibility to test 
some of the memory using the kernel instead of none at all. So if nobody 
offers a better solution, I would be glad if the below patch would find 
some friends. ;)

Regards,

Alexander


Here is how dmesg does look like (memtest=4):

--------- no error ---------
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] early_memtest: # of tests: 4
[    0.000000]   0000000000 - 0000004000 pattern 00000000
[    0.000000]   0000000000 - 0000004000 pattern ffffffff
[    0.000000]   0000000000 - 0000004000 pattern 55555555
[    0.000000]   0000000000 - 0000004000 pattern aaaaaaaa
[    0.000000] early_memtest: wipe out test pattern from memory
[    0.000000]   0000000000 - 0000004000 pattern 00000000
[    0.000000] early_memtest: # of tests: 4
[    0.000000]   000054c000 - 0007ffb000 pattern 00000000
[    0.000000]   000054c000 - 0007ffb000 pattern ffffffff
[    0.000000]   000054c000 - 0007ffb000 pattern 55555555
[    0.000000]   000054c000 - 0007ffb000 pattern aaaaaaaa
[    0.000000] early_memtest: wipe out test pattern from memory
[    0.000000]   000054c000 - 0007ffb000 pattern 00000000
[    0.000000] Memory: 128MB = 128MB total
[    0.000000] Memory: 125648k/125648k available, 5424k reserved, 0K highmem
--------- no error ---------

--------- error inected (by sw) ---------
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] early_memtest: # of tests: 4
[    0.000000]   0000000000 - 0000004000 pattern 00000000
[    0.000000]   0000000000 - 0000004000 pattern ffffffff
[    0.000000]   0000000000 - 0000004000 pattern 55555555
[    0.000000]   0000000000 - 0000004000 pattern aaaaaaaa
[    0.000000] early_memtest: wipe out test pattern from memory
[    0.000000]   0000000000 - 0000004000 pattern 00000000
[    0.000000] early_memtest: # of tests: 4
[    0.000000]   000054c000 - 0007ffb000 pattern 00000000
[    0.000000]   00000000 bad mem addr 0000600000 - 0000600014 reserved
[    0.000000]   0000600014 - 0007ffb000 pattern 00000000
[    0.000000]   000054c000 - 0000600000 pattern ffffffff
[    0.000000]   0000600014 - 0007ffb000 pattern ffffffff
[    0.000000]   000054c000 - 0000600000 pattern 55555555
[    0.000000]   0000600014 - 0007ffb000 pattern 55555555
[    0.000000]   000054c000 - 0000600000 pattern aaaaaaaa
[    0.000000]   0000600014 - 0007ffb000 pattern aaaaaaaa
[    0.000000] early_memtest: wipe out test pattern from memory
[    0.000000]   000054c000 - 0000600000 pattern 00000000
[    0.000000]   0000600014 - 0007ffb000 pattern 00000000
[    0.000000] Memory: 128MB = 128MB total
[    0.000000] Memory: 125648k/125648k available, 5424k reserved, 0K highmem
--------- error inected (by sw) ---------

--------- with hole (mem=99M@0x0 mem=28M@0x6400000) ---------
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] early_memtest: # of tests: 4
[    0.000000]   0000000000 - 0000004000 pattern 00000000
[    0.000000]   0000000000 - 0000004000 pattern ffffffff
[    0.000000]   0000000000 - 0000004000 pattern 55555555
[    0.000000]   0000000000 - 0000004000 pattern aaaaaaaa
[    0.000000] early_memtest: wipe out test pattern from memory
[    0.000000]   0000000000 - 0000004000 pattern 00000000
[    0.000000] early_memtest: # of tests: 4
[    0.000000]   000054c000 - 0006300000 pattern 00000000
[    0.000000]   000054c000 - 0006300000 pattern ffffffff
[    0.000000]   000054c000 - 0006300000 pattern 55555555
[    0.000000]   000054c000 - 0006300000 pattern aaaaaaaa
[    0.000000] early_memtest: wipe out test pattern from memory
[    0.000000]   000054c000 - 0006300000 pattern 00000000
[    0.000000] early_memtest: # of tests: 4
[    0.000000]   0006400000 - 0007ffb000 pattern 00000000
[    0.000000]   0006400000 - 0007ffb000 pattern ffffffff
[    0.000000]   0006400000 - 0007ffb000 pattern 55555555
[    0.000000]   0006400000 - 0007ffb000 pattern aaaaaaaa
[    0.000000] early_memtest: wipe out test pattern from memory
[    0.000000]   0006400000 - 0007ffb000 pattern 00000000
[    0.000000] Memory: 99MB 28MB = 127MB total
[    0.000000] Memory: 124624k/124624k available, 5424k reserved, 0K highmem
--------- with hole (mem=99M@0x0 mem=28M@0x6400000) ---------


 From 3034a0d2fc71c8edef43d0d04b3be0ffad484fca Mon Sep 17 00:00:00 2001
From: Alexander Holler <holler@ahsoftware.de>
Date: Wed, 31 Oct 2012 22:24:04 +0100
Subject: [PATCH] arm: add memtest

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
  arch/arm/mm/Kconfig     |   11 ++++
  arch/arm/mm/Makefile    |    2 +
  arch/arm/mm/init.c      |   36 +++++++++++++-
  arch/arm/mm/memtest32.c |  126 
+++++++++++++++++++++++++++++++++++++++++++++++
  4 files changed, 173 insertions(+), 2 deletions(-)
  create mode 100644 arch/arm/mm/memtest32.c

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 101b968..b14941f 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -874,3 +874,14 @@ config ARCH_HAS_BARRIERS
  	help
  	  This option allows the use of custom mandatory barriers
  	  included via the mach/barriers.h file.
+
+config MEMTEST
+	bool "Memtest"
+	---help---
+	  This option adds a kernel parameter 'memtest', which allows memtest
+	  to be set.
+	        memtest=0, mean disabled; -- default
+	        memtest=1, mean do 1 test pattern;
+	        ...
+	        memtest=4, mean do 4 test patterns.
+	  If you are unsure how to answer this question, answer N.
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 8a9c4cb..8cbfda1 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -96,3 +96,5 @@ obj-$(CONFIG_CACHE_FEROCEON_L2)	+= cache-feroceon-l2.o
  obj-$(CONFIG_CACHE_L2X0)	+= cache-l2x0.o
  obj-$(CONFIG_CACHE_XSC3L2)	+= cache-xsc3l2.o
  obj-$(CONFIG_CACHE_TAUROS2)	+= cache-tauros2.o
+
+obj-$(CONFIG_MEMTEST)		+= memtest32.o
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 9aec41f..0941946 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -584,6 +584,10 @@ static void __init free_highpages(void)
  #endif
  }

+#ifdef CONFIG_MEMTEST
+extern void early_memtest32(unsigned long start, unsigned long end);
+#endif
+
  /*
   * mem_init() marks the free areas in the mem_map and tells us how much
   * memory is free.  This is done after various parts of the system have
@@ -618,6 +622,9 @@ void __init mem_init(void)
  	reserved_pages = free_pages = 0;

  	for_each_bank(i, &meminfo) {
+#ifdef CONFIG_MEMTEST
+		phys_addr_t memtest_start = 0xffffffff, memtest_end;
+#endif
  		struct membank *bank = &meminfo.bank[i];
  		unsigned int pfn1, pfn2;
  		struct page *page, *end;
@@ -629,12 +636,37 @@ void __init mem_init(void)
  		end  = pfn_to_page(pfn2 - 1) + 1;

  		do {
-			if (PageReserved(page))
+			if (PageReserved(page)) {
  				reserved_pages++;
-			else if (!page_count(page))
+#ifdef CONFIG_MEMTEST
+				/* something has cut a hole */
+				if (memtest_start != 0xffffffff) {
+					early_memtest32(memtest_start,  memtest_end);
+					memtest_start = 0xffffffff;
+				}
+#endif
+			} else if (!page_count(page)) {
  				free_pages++;
+#ifdef CONFIG_MEMTEST
+				if (memtest_start == 0xffffffff) {
+					/* start of a block for memtest */
+					memtest_start = page_to_phys(page);
+				} else if (memtest_end != page_to_phys(page)) {
+					/* hole detected, call memtest */
+					early_memtest32(memtest_start,  memtest_end);
+					/* and start with new values */
+					memtest_start = page_to_phys(page);
+				}
+				memtest_end = page_to_phys(page)+PAGE_SIZE;
+#endif
+			}
  			page++;
  		} while (page < end);
+#ifdef CONFIG_MEMTEST
+		if (memtest_start != 0xffffffff)
+			early_memtest32(memtest_start,  memtest_end);
+		/* if bad memory was found, reserved_pages is wrong (without bad mem) */
+#endif
  	}

  	/*
diff --git a/arch/arm/mm/memtest32.c b/arch/arm/mm/memtest32.c
new file mode 100644
index 0000000..1564b5b
--- /dev/null
+++ b/arch/arm/mm/memtest32.c
@@ -0,0 +1,126 @@
+/* This is just a checkpatch'ed copy of arch/x86/mm/memtest.c modified 
to use 32bit */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/pfn.h>
+#include <linux/memblock.h>
+
+static u32 patterns[] __initdata = {
+	0,
+	0xffffffffUL,
+	0x55555555UL,
+	0xaaaaaaaaUL,
+	0x11111111UL,
+	0x22222222UL,
+	0x44444444UL,
+	0x88888888UL,
+	0x33333333UL,
+	0x66666666UL,
+	0x99999999UL,
+	0xccccccccUL,
+	0x77777777UL,
+	0xbbbbbbbbUL,
+	0xddddddddUL,
+	0xeeeeeeeeUL,
+	0x7a6c7258UL, /* yeah ;-) */
+};
+
+static void __init reserve_bad_mem(u32 pattern, u32 start_bad, u32 end_bad)
+{
+	pr_info("  %08lx bad mem addr %010lx - %010lx reserved\n",
+	       (unsigned long) pattern,
+	       (unsigned long) start_bad,
+	       (unsigned long) end_bad);
+	memblock_reserve(start_bad, end_bad - start_bad);
+}
+
+static void __init memtest(u32 pattern, u32 start_phys, u32 size)
+{
+	u32 *p, *start, *end;
+	u32 start_bad, last_bad;
+	u32 start_phys_aligned;
+	const size_t incr = sizeof(pattern);
+
+	start_phys_aligned = ALIGN(start_phys, incr);
+	start = __va(start_phys_aligned);
+	end = start + (size - (start_phys_aligned - start_phys)) / incr;
+	start_bad = 0;
+	last_bad = 0;
+
+	for (p = start; p < end; p++)
+		*p = pattern;
+
+	for (p = start; p < end; p++, start_phys_aligned += incr) {
+		if (*p == pattern)
+			continue;
+		if (start_phys_aligned == last_bad + incr) {
+			last_bad += incr;
+			continue;
+		}
+		if (start_bad)
+			reserve_bad_mem(pattern, start_bad, last_bad + incr);
+		start_bad = last_bad = start_phys_aligned;
+	}
+	if (start_bad)
+		reserve_bad_mem(pattern, start_bad, last_bad + incr);
+}
+
+static void __init do_one_pass(u32 pattern, u32 start, u32 end)
+{
+	u64 i;
+	phys_addr_t this_start, this_end;
+
+	for_each_free_mem_range(i, MAX_NUMNODES, &this_start, &this_end, NULL) {
+		this_start = clamp_t(phys_addr_t, this_start, start, end);
+		this_end = clamp_t(phys_addr_t, this_end, start, end);
+		if (this_start < this_end) {
+			pr_info("  %010lx - %010lx pattern %08lx\n",
+			       (unsigned long)this_start,
+			       (unsigned long)this_end,
+			       (unsigned long)cpu_to_be32(pattern));
+			memtest(pattern, this_start, this_end - this_start);
+		}
+	}
+}
+
+/* default is disabled */
+static int memtest_pattern __initdata;
+
+static int __init parse_memtest(char *arg)
+{
+	ssize_t ret __always_unused;
+
+	if (arg)
+		ret = kstrtoint(arg, 0, &memtest_pattern);
+	else
+		memtest_pattern = ARRAY_SIZE(patterns);
+
+	return 0;
+}
+
+early_param("memtest", parse_memtest);
+
+void __init early_memtest32(unsigned long start, unsigned long end)
+{
+	unsigned int i;
+	unsigned int idx = 0;
+
+	if (!memtest_pattern)
+		return;
+
+	pr_info("early_memtest: # of tests: %d\n", memtest_pattern);
+	for (i = 0; i < memtest_pattern; i++) {
+		idx = i % ARRAY_SIZE(patterns);
+		do_one_pass(patterns[idx], start, end);
+	}
+
+	if (idx > 0) {
+		pr_info("early_memtest: wipe out test pattern from memory\n");
+		/* additional test with pattern 0 will do this */
+		do_one_pass(0, start, end);
+	}
+}
-- 
1.7.8.6


