Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222Ab2ILQIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:08:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58573 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab2ILQI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:08:27 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-c6x-dev@linux-c6x.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linux@openrisc.net>, <linuxppc-dev@lists.ozlabs.org>,
        <microblaze-uclinux@itee.uq.edu.au>
CC: <a-jacquiot@ti.com>, <arnd@arndb.de>, <benh@kernel.crashing.org>,
        <bigeasy@linutronix.de>, <blogic@openwrt.org>,
        <david.daney@cavium.com>, <dhowells@redhat.com>,
        <grant.likely@secretlab.ca>, <hpa@zytor.com>, <jonas@southpole.se>,
        <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <m.szyprowski@samsung.com>, <mahesh@linux.vnet.ibm.com>,
        <mingo@redhat.com>, <monstr@monstr.eu>, <msalter@redhat.com>,
        <nico@linaro.org>, <paul.gortmaker@windriver.com>, <paulus@samba.org>,
        <ralf@linux-mips.org>, <rob.herring@calxeda.com>, <suzuki@in.ibm.com>,
        <tglx@linutronix.de>, <tj@kernel.org>, <x86@kernel.org>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH] of: specify initrd location using 64-bit
Date: Wed, 12 Sep 2012 12:05:37 -0400
Message-ID: <1347465937-7056-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some PAE architectures, the entire range of physical memory could reside
outside the 32-bit limit.  These systems need the ability to specify the
initrd location using 64-bit numbers.

This patch globally modifies the early_init_dt_setup_initrd_arch() function to
use 64-bit numbers instead of the current unsigned long.
---
 arch/arm/mm/init.c            |    2 +-
 arch/c6x/kernel/devicetree.c  |    3 +--
 arch/microblaze/kernel/prom.c |    3 +--
 arch/mips/kernel/prom.c       |    3 +--
 arch/openrisc/kernel/prom.c   |    3 +--
 arch/powerpc/kernel/prom.c    |    3 +--
 arch/x86/kernel/devicetree.c  |    3 +--
 drivers/of/fdt.c              |   10 ++++++----
 include/linux/of_fdt.h        |    3 +--
 9 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index ad722f1..579792c 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -76,7 +76,7 @@ static int __init parse_tag_initrd2(const struct tag *tag)
 __tagtable(ATAG_INITRD2, parse_tag_initrd2);
 
 #ifdef CONFIG_OF_FLATTREE
-void __init early_init_dt_setup_initrd_arch(unsigned long start, unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	phys_initrd_start = start;
 	phys_initrd_size = end - start;
diff --git a/arch/c6x/kernel/devicetree.c b/arch/c6x/kernel/devicetree.c
index bdb56f0..287d0e6 100644
--- a/arch/c6x/kernel/devicetree.c
+++ b/arch/c6x/kernel/devicetree.c
@@ -33,8 +33,7 @@ void __init early_init_devtree(void *params)
 
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 4a764cc..cecd42c 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -136,8 +136,7 @@ void __init early_init_devtree(void *params)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 028f6f8..e37e0dc 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -41,8 +41,7 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index 5869e3f..150215a 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -96,8 +96,7 @@ void __init early_init_devtree(void *params)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 37725e8..ac15f63 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -549,8 +549,7 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-		unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index b158152..2fbad6b 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -52,8 +52,7 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void __init early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end)
+void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
 	initrd_start = (unsigned long)__va(start);
 	initrd_end = (unsigned long)__va(end);
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 91a375f..2ff8b7a 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -554,7 +554,8 @@ int __init of_flat_dt_match(unsigned long node, const char *const *compat)
  */
 void __init early_init_dt_check_for_initrd(unsigned long node)
 {
-	unsigned long start, end, len;
+	u64 start, end;
+	unsigned long len;
 	__be32 *prop;
 
 	pr_debug("Looking for initrd properties... ");
@@ -562,15 +563,16 @@ void __init early_init_dt_check_for_initrd(unsigned long node)
 	prop = of_get_flat_dt_prop(node, "linux,initrd-start", &len);
 	if (!prop)
 		return;
-	start = of_read_ulong(prop, len/4);
+	start = of_read_number(prop, len/4);
 
 	prop = of_get_flat_dt_prop(node, "linux,initrd-end", &len);
 	if (!prop)
 		return;
-	end = of_read_ulong(prop, len/4);
+	end = of_read_number(prop, len/4);
 
 	early_init_dt_setup_initrd_arch(start, end);
-	pr_debug("initrd_start=0x%lx  initrd_end=0x%lx\n", start, end);
+	pr_debug("initrd_start=0x%llx  initrd_end=0x%llx\n",
+		 (unsigned long long)start, (unsigned long long)end);
 }
 #else
 inline void early_init_dt_check_for_initrd(unsigned long node)
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index ed136ad..4a17939 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -106,8 +106,7 @@ extern u64 dt_mem_next_cell(int s, __be32 **cellp);
  * physical addresses.
  */
 #ifdef CONFIG_BLK_DEV_INITRD
-extern void early_init_dt_setup_initrd_arch(unsigned long start,
-					    unsigned long end);
+extern void early_init_dt_setup_initrd_arch(u64 start, u64 end);
 #endif
 
 /* Early flat tree scan hooks */
-- 
1.7.9.5

