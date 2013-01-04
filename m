Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3ADAuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:50:52 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30566 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3ADAus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:50:48 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Rob Landley <rob@landley.net>
Subject: [PATCH v7u1 28/31] x86: add Crash kernel low reservation
Date: Thu,  3 Jan 2013 16:48:48 -0800
Message-Id: <1357260531-11115-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
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

Try to reserve some under 4G if the normal "Crash kernel" is above 4G.

User could specify the size with crashkernel_low=XX[KMG].

-v2: fix warning that is found by Fengguang's test robot.
-v3: move out get_mem_size change to another patch, to solve compiling
     warning that is found by Borislav Petkov <bp@alien8.de>
-v4: user must specify crashkernel_low if system does not support
     intel or amd iommu.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Rob Landley <rob@landley.net>
---
 Documentation/kernel-parameters.txt |    3 +++
 arch/x86/kernel/setup.c             |   42 +++++++++++++++++++++++++++++++++--
 include/linux/kexec.h               |    3 +++
 kernel/kexec.c                      |   34 +++++++++++++++++++++++-----
 4 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 363e348..da0e077 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -594,6 +594,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			is selected automatically. Check
 			Documentation/kdump/kdump.txt for further details.
 
+	crashkernel_low=size[KMG]
+			[KNL, x86] parts under 4G.
+
 	crashkernel=range1:size1[,range2:size2,...][@offset]
 			[KNL] Same as above, but depends on the memory
 			in the running system. The syntax of range is
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6adbc45..2203dd6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -508,8 +508,44 @@ static void __init memblock_x86_reserve_range_setup_data(void)
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
+	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
+	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
+						&low_size, &base);
+	if (ret != 0 || low_size <= 0)
+		return;
+
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
@@ -523,8 +559,6 @@ static void __init reserve_crashkernel(void)
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
-		const unsigned long long alignment = 16<<20;	/* 16M */
-
 		/*
 		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
@@ -535,6 +569,7 @@ static void __init reserve_crashkernel(void)
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
+
 	} else {
 		unsigned long long start;
 
@@ -556,6 +591,9 @@ static void __init reserve_crashkernel(void)
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

