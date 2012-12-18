Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2LRHRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:17:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22856 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab2LRHQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:16:39 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7 26/27] x86: add Crash kernel low reservation
Date: Mon, 17 Dec 2012 23:15:58 -0800
Message-Id: <1355814959-10573-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During kdump kernel's booting stage, it need to find low ram for
swiotlb buffer when system does not support intel iommu/dmar remapping.

kexed-tools is appending memmap=exactmap and range from /proc/iomem
with "Crash kernel", and that range is above 4G for 64bit after boot
protocol 2.12.

We need to add another range in /proc/iomem like "Crash kernel low",
so kexec-tools could find that info and append to kdump kernel
command line.

Try to reserve some under 4G if the normal "Crash kernel" is above
4G.

User could specify the size with crashkernel_low=XX[KMG].
If the user does not specify that, will use 72M instead.

-v2: fix warning that is found by Fengguang's test robot.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 Documentation/kernel-parameters.txt |    3 ++
 arch/x86/kernel/setup.c             |   70 +++++++++++++++++++++++++++--------
 include/linux/kexec.h               |    3 ++
 kernel/kexec.c                      |   34 ++++++++++++++---
 4 files changed, 89 insertions(+), 21 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2b37020..e8c48e9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -600,6 +600,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			is selected automatically. Check
 			Documentation/kdump/kdump.txt for further details.
 
+	crashkernel_low=size[KMG]
+			[KNL, x86] parts under 4G.
+
 	crashkernel=range1:size1[,range2:size2,...][@offset]
 			[KNL] Same as above, but depends on the memory
 			in the running system. The syntax of range is
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2631008..5373a71 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -292,6 +292,21 @@ static void __init reserve_brk(void)
 	_brk_start = 0;
 }
 
+static u64 __init get_mem_size(unsigned long limit_pfn)
+{
+	int i;
+	u64 pages = 0;
+	unsigned long start_pfn, end_pfn;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
+		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
+		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
+		pages += end_pfn - start_pfn;
+	}
+
+	return pages << PAGE_SHIFT;
+}
+
 #ifdef CONFIG_BLK_DEV_INITRD
 
 static u64 __init get_ramdisk_image(void)
@@ -363,20 +378,6 @@ static void __init relocate_initrd(void)
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
 
-static u64 __init get_mem_size(unsigned long limit_pfn)
-{
-	int i;
-	u64 mapped_pages = 0;
-	unsigned long start_pfn, end_pfn;
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
-		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
-		mapped_pages += end_pfn - start_pfn;
-	}
-
-	return mapped_pages << PAGE_SHIFT;
-}
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
@@ -522,8 +523,43 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 # define CRASH_KERNEL_ADDR_MAX	MAXMEM
 #endif
 
+static void __init reserve_crashkernel_low(void)
+{
+#ifdef CONFIG_X86_64
+	const unsigned long long alignment = 16<<20;	/* 16M */
+	unsigned long long low_base = 0, low_size = 0;
+	unsigned long total_low_mem;
+	unsigned long long base;
+	int ret;
+
+	total_low_mem = get_mem_size(1UL<<(32-PAGE_SHIFT));
+	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
+						&low_size, &base);
+	if (ret != 0 || low_size <= 0)
+		low_size = (72UL<<20);  /* 72M */
+	low_base = memblock_find_in_range(low_size, (1ULL<<32),
+					low_size, alignment);
+
+	if (!low_base) {
+		pr_info("crashkernel low reservation failed - No suitable area found.\n");
+
+		return;
+	}
+
+	memblock_reserve(low_base, low_size);
+	pr_info("Reserving %ldMB of low memory at %ldMB for crashkernel (System low RAM: %ldMB)\n",
+			(unsigned long)(low_size >> 20),
+			(unsigned long)(low_base >> 20),
+			(unsigned long)(total_low_mem >> 20));
+	crashk_low_res.start = low_base;
+	crashk_low_res.end   = low_base + low_size - 1;
+	insert_resource(&iomem_resource, &crashk_low_res);
+#endif
+}
+
 static void __init reserve_crashkernel(void)
 {
+	const unsigned long long alignment = 16<<20;	/* 16M */
 	unsigned long long total_mem;
 	unsigned long long crash_size, crash_base;
 	int ret;
@@ -537,8 +573,6 @@ static void __init reserve_crashkernel(void)
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
-		const unsigned long long alignment = 16<<20;	/* 16M */
-
 		/*
 		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
@@ -549,6 +583,7 @@ static void __init reserve_crashkernel(void)
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
+
 	} else {
 		unsigned long long start;
 
@@ -570,6 +605,9 @@ static void __init reserve_crashkernel(void)
 	crashk_res.start = crash_base;
 	crashk_res.end   = crash_base + crash_size - 1;
 	insert_resource(&iomem_resource, &crashk_res);
+
+	if (crash_base >= (1ULL<<32))
+		reserve_crashkernel_low();
 }
 #else
 static void __init reserve_crashkernel(void)
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d0b8458..d2e6927 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -191,6 +191,7 @@ extern struct kimage *kexec_crash_image;
 /* Location of a reserved region to hold the crash kernel.
  */
 extern struct resource crashk_res;
+extern struct resource crashk_low_res;
 typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
 extern note_buf_t __percpu *crash_notes;
 extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
@@ -199,6 +200,8 @@ extern size_t vmcoreinfo_max_size;
 
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
+int parse_crashkernel_low(char *cmdline, unsigned long long system_ram,
+		unsigned long long *crash_size, unsigned long long *crash_base);
 int crash_shrink_memory(unsigned long new_size);
 size_t crash_get_memory_size(void);
 void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 5e4bd78..2436ffc 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -54,6 +54,12 @@ struct resource crashk_res = {
 	.end   = 0,
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
 };
+struct resource crashk_low_res = {
+	.name  = "Crash kernel low",
+	.start = 0,
+	.end   = 0,
+	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
+};
 
 int kexec_should_crash(struct task_struct *p)
 {
@@ -1369,10 +1375,11 @@ static int __init parse_crashkernel_simple(char 		*cmdline,
  * That function is the entry point for command line parsing and should be
  * called from the arch-specific code.
  */
-int __init parse_crashkernel(char 		 *cmdline,
+static int __init __parse_crashkernel(char *cmdline,
 			     unsigned long long system_ram,
 			     unsigned long long *crash_size,
-			     unsigned long long *crash_base)
+			     unsigned long long *crash_base,
+				const char *name)
 {
 	char 	*p = cmdline, *ck_cmdline = NULL;
 	char	*first_colon, *first_space;
@@ -1382,16 +1389,16 @@ int __init parse_crashkernel(char 		 *cmdline,
 	*crash_base = 0;
 
 	/* find crashkernel and use the last one if there are more */
-	p = strstr(p, "crashkernel=");
+	p = strstr(p, name);
 	while (p) {
 		ck_cmdline = p;
-		p = strstr(p+1, "crashkernel=");
+		p = strstr(p+1, name);
 	}
 
 	if (!ck_cmdline)
 		return -EINVAL;
 
-	ck_cmdline += 12; /* strlen("crashkernel=") */
+	ck_cmdline += strlen(name);
 
 	/*
 	 * if the commandline contains a ':', then that's the extended
@@ -1409,6 +1416,23 @@ int __init parse_crashkernel(char 		 *cmdline,
 	return 0;
 }
 
+int __init parse_crashkernel(char *cmdline,
+			     unsigned long long system_ram,
+			     unsigned long long *crash_size,
+			     unsigned long long *crash_base)
+{
+	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
+					"crashkernel=");
+}
+
+int __init parse_crashkernel_low(char *cmdline,
+			     unsigned long long system_ram,
+			     unsigned long long *crash_size,
+			     unsigned long long *crash_base)
+{
+	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
+					"crashkernel_low=");
+}
 
 static void update_vmcoreinfo_note(void)
 {
-- 
1.7.10.4

