Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2BPLQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:16:13 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:58298 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2BPLQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:16:10 -0500
Subject: [RFC PATCH v7 08/10] fadump: Invalidate registration and release
 reserved memory for general use.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>, Kexec-ml <kexec@lists.infradead.org>,
        Milton Miller <miltonm@bga.com>, Haren Myneni <hbabu@us.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mackerras <paulus@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ananth Narayan <ananth@in.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Anton Blanchard <anton@samba.org>
Date: Thu, 16 Feb 2012 16:45:08 +0530
Message-ID: <20120216111507.4733.83863.stgit@mars>
In-Reply-To: <20120216111050.4733.38034.stgit@mars>
References: <20120216111050.4733.38034.stgit@mars>
User-Agent: StGit/0.15-4-g042f-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12021611-5564-0000-0000-00000164EDE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

This patch introduces an sysfs interface '/sys/kernel/fadump_release_mem' to
invalidate the last fadump registration, invalidate '/proc/vmcore', release
the reserved memory for general use and re-register for future kernel dump.
Once the dump is copied to the disk, unlike phyp dump, the userspace tool
can release all the memory reserved for dump with one single operation of
echo 1 to '/sys/kernel/fadump_release_mem'.

Release the reserved memory region excluding the size of the memory required
for future kernel dump registration. And therefore, unlike kdump, Fadump
doesn't need a 2nd reboot to get back the system to the production
configuration.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/fadump.h |    3 +
 arch/powerpc/kernel/fadump.c      |  158 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 157 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/fadump.h b/arch/powerpc/include/asm/fadump.h
index 6768195..88dbf96 100644
--- a/arch/powerpc/include/asm/fadump.h
+++ b/arch/powerpc/include/asm/fadump.h
@@ -208,6 +208,9 @@ extern int fadump_reserve_mem(void);
 extern int setup_fadump(void);
 extern int is_fadump_active(void);
 extern void crash_fadump(struct pt_regs *, const char *);
+extern void fadump_cleanup(void);
+
+extern void vmcore_cleanup(void);
 #else	/* CONFIG_FA_DUMP */
 static inline int is_fadump_active(void) { return 0; }
 static inline void crash_fadump(struct pt_regs *regs, const char *str) { }
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 5689954..8874d6b 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -33,6 +33,8 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/crash_dump.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 
 #include <asm/page.h>
 #include <asm/prom.h>
@@ -984,6 +986,132 @@ static int fadump_unregister_dump(struct fadump_mem_struct *fdm)
 	return 0;
 }
 
+static int fadump_invalidate_dump(struct fadump_mem_struct *fdm)
+{
+	int rc = 0;
+	unsigned int wait_time;
+
+	pr_debug("Invalidating firmware-assisted dump registration\n");
+
+	/* TODO: Add upper time limit for the delay */
+	do {
+		rc = rtas_call(fw_dump.ibm_configure_kernel_dump, 3, 1, NULL,
+			FADUMP_INVALIDATE, fdm,
+			sizeof(struct fadump_mem_struct));
+
+		wait_time = rtas_busy_delay_time(rc);
+		if (wait_time)
+			mdelay(wait_time);
+	} while (wait_time);
+
+	if (rc) {
+		printk(KERN_ERR "Failed to invalidate firmware-assisted dump "
+			"rgistration. unexpected error(%d).\n", rc);
+		return rc;
+	}
+	fw_dump.dump_active = 0;
+	fdm_active = NULL;
+	return 0;
+}
+
+void fadump_cleanup(void)
+{
+	/* Invalidate the registration only if dump is active. */
+	if (fw_dump.dump_active) {
+		init_fadump_mem_struct(&fdm,
+			fdm_active->cpu_state_data.destination_address);
+		fadump_invalidate_dump(&fdm);
+	}
+}
+
+/*
+ * Release the memory that was reserved in early boot to preserve the memory
+ * contents. The released memory will be available for general use.
+ */
+static void fadump_release_memory(unsigned long begin, unsigned long end)
+{
+	unsigned long addr;
+	unsigned long ra_start, ra_end;
+
+	ra_start = fw_dump.reserve_dump_area_start;
+	ra_end = ra_start + fw_dump.reserve_dump_area_size;
+
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+		/*
+		 * exclude the dump reserve area. Will reuse it for next
+		 * fadump registration.
+		 */
+		if (addr <= ra_end && ((addr + PAGE_SIZE) > ra_start))
+			continue;
+
+		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
+		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
+		free_page((unsigned long)__va(addr));
+		totalram_pages++;
+	}
+}
+
+static void fadump_invalidate_release_mem(void)
+{
+	unsigned long reserved_area_start, reserved_area_end;
+	unsigned long destination_address;
+
+	mutex_lock(&fadump_mutex);
+	if (!fw_dump.dump_active) {
+		mutex_unlock(&fadump_mutex);
+		return;
+	}
+
+	destination_address = fdm_active->cpu_state_data.destination_address;
+	fadump_cleanup();
+	mutex_unlock(&fadump_mutex);
+
+	/*
+	 * Save the current reserved memory bounds we will require them
+	 * later for releasing the memory for general use.
+	 */
+	reserved_area_start = fw_dump.reserve_dump_area_start;
+	reserved_area_end = reserved_area_start +
+			fw_dump.reserve_dump_area_size;
+	/*
+	 * Setup reserve_dump_area_start and its size so that we can
+	 * reuse this reserved memory for Re-registration.
+	 */
+	fw_dump.reserve_dump_area_start = destination_address;
+	fw_dump.reserve_dump_area_size = get_fadump_area_size();
+
+	fadump_release_memory(reserved_area_start, reserved_area_end);
+	if (fw_dump.cpu_notes_buf) {
+		fadump_cpu_notes_buf_free(
+				(unsigned long)__va(fw_dump.cpu_notes_buf),
+				fw_dump.cpu_notes_buf_size);
+		fw_dump.cpu_notes_buf = 0;
+		fw_dump.cpu_notes_buf_size = 0;
+	}
+	/* Initialize the kernel dump memory structure for FAD registration. */
+	init_fadump_mem_struct(&fdm, fw_dump.reserve_dump_area_start);
+}
+
+static ssize_t fadump_release_memory_store(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					const char *buf, size_t count)
+{
+	if (!fw_dump.dump_active)
+		return -EPERM;
+
+	if (buf[0] == '1') {
+		/*
+		 * Take away the '/proc/vmcore'. We are releasing the dump
+		 * memory, hence it will not be valid anymore.
+		 */
+		vmcore_cleanup();
+		fadump_invalidate_release_mem();
+
+	} else
+		return -EINVAL;
+	return count;
+}
+
 static ssize_t fadump_enabled_show(struct kobject *kobj,
 					struct kobj_attribute *attr,
 					char *buf)
@@ -1043,10 +1171,13 @@ static int fadump_region_show(struct seq_file *m, void *private)
 	if (!fw_dump.fadump_enabled)
 		return 0;
 
+	mutex_lock(&fadump_mutex);
 	if (fdm_active)
 		fdm_ptr = fdm_active;
-	else
+	else {
+		mutex_unlock(&fadump_mutex);
 		fdm_ptr = &fdm;
+	}
 
 	seq_printf(m,
 			"CPU : [%#016llx-%#016llx] %#llx bytes, "
@@ -1076,7 +1207,7 @@ static int fadump_region_show(struct seq_file *m, void *private)
 	if (!fdm_active ||
 		(fw_dump.reserve_dump_area_start ==
 		fdm_ptr->cpu_state_data.destination_address))
-		return 0;
+		goto out;
 
 	/* Dump is active. Show reserved memory region. */
 	seq_printf(m,
@@ -1088,9 +1219,15 @@ static int fadump_region_show(struct seq_file *m, void *private)
 			fw_dump.reserve_dump_area_start,
 			fdm_ptr->cpu_state_data.destination_address -
 			fw_dump.reserve_dump_area_start);
+out:
+	if (fdm_active)
+		mutex_unlock(&fadump_mutex);
 	return 0;
 }
 
+static struct kobj_attribute fadump_release_attr = __ATTR(fadump_release_mem,
+						0200, NULL,
+						fadump_release_memory_store);
 static struct kobj_attribute fadump_attr = __ATTR(fadump_enabled,
 						0444, fadump_enabled_show,
 						NULL);
@@ -1131,6 +1268,13 @@ static void fadump_init_files(void)
 	if (!debugfs_file)
 		printk(KERN_ERR "fadump: unable to create debugfs file"
 				" fadump_region\n");
+
+	if (fw_dump.dump_active) {
+		rc = sysfs_create_file(kernel_kobj, &fadump_release_attr.attr);
+		if (rc)
+			printk(KERN_ERR "fadump: unable to create sysfs file"
+				" fadump_release_mem (%d)\n", rc);
+	}
 	return;
 }
 
@@ -1150,8 +1294,14 @@ int __init setup_fadump(void)
 	 * If dump data is available then see if it is valid and prepare for
 	 * saving it to the disk.
 	 */
-	if (fw_dump.dump_active)
-		process_fadump(fdm_active);
+	if (fw_dump.dump_active) {
+		/*
+		 * if dump process fails then invalidate the registration
+		 * and release memory before proceeding for re-registration.
+		 */
+		if (process_fadump(fdm_active) < 0)
+			fadump_invalidate_release_mem();
+	}
 	/* Initialize the kernel dump memory structure for FAD registration. */
 	else if (fw_dump.reserve_dump_area_size)
 		init_fadump_mem_struct(&fdm, fw_dump.reserve_dump_area_start);

