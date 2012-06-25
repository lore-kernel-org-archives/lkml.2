Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2FYGLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:11:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:27904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab2FYGLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162133068"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, alex.shi@intel.com, luto@mit.edu, yinghai@kernel.org,
        riel@redhat.com, avi@redhat.com, len.brown@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, cl@gentwo.org, borislav.petkov@amd.com,
        ak@linux.intel.com, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, vapier@gentoo.org, cpw@sgi.com,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v9 5/9] x86/tlb: add tlb_flushall_shift knob into debugfs
Date: Mon, 25 Jun 2012 14:08:23 +0800
Message-Id: <1340604507-11214-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel will replace cr3 rewrite with invlpg when
  tlb_flush_entries <= active_tlb_entries / 2^tlb_flushall_factor
if tlb_flushall_factor is -1, kernel won't do this replacement.

User can modify its value according to specific CPU/applications.

Thanks for Borislav providing the help message of
CONFIG_DEBUG_TLBFLUSH.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/Kconfig.debug |   19 +++++++++++++++++
 arch/x86/mm/tlb.c      |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index e46c214..b322f12 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -129,6 +129,25 @@ config DOUBLEFAULT
 	  option saves about 4k and might cause you much additional grey
 	  hair.
 
+config DEBUG_TLBFLUSH
+	bool "Set upper limit of TLB entries to flush one-by-one"
+	depends on DEBUG_KERNEL && (X86_64 || X86_INVLPG)
+	---help---
+
+	X86-only for now.
+
+	This option allows the user to tune the amount of TLB entries the
+	kernel flushes one-by-one instead of doing a full TLB flush. In
+	certain situations, the former is cheaper. This is controlled by the
+	tlb_flushall_shift knob under /sys/kernel/debug/x86. If you set it
+	to -1, the code flushes the whole TLB unconditionally. Otherwise,
+	for positive values of it, the kernel will use single TLB entry
+	invalidating instructions according to the following formula:
+
+	flush_entries <= active_tlb_entries / 2^tlb_flushall_shift
+
+	If in doubt, say "N".
+
 config IOMMU_DEBUG
 	bool "Enable IOMMU debugging"
 	depends on GART_IOMMU && DEBUG_KERNEL
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 2939f2f..5911f61 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -12,6 +12,7 @@
 #include <asm/cache.h>
 #include <asm/apic.h>
 #include <asm/uv/uv.h>
+#include <linux/debugfs.h>
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
 			= { &init_mm, 0, };
@@ -430,3 +431,53 @@ void flush_tlb_all(void)
 {
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
+
+#ifdef CONFIG_DEBUG_TLBFLUSH
+static ssize_t tlbflush_read_file(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%hd\n", tlb_flushall_shift);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t tlbflush_write_file(struct file *file,
+		 const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	ssize_t len;
+	s8 shift;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtos8(buf, 0, &shift))
+		return -EINVAL;
+
+	if (shift > 64)
+		return -EINVAL;
+
+	tlb_flushall_shift = shift;
+	return count;
+}
+
+static const struct file_operations fops_tlbflush = {
+	.read = tlbflush_read_file,
+	.write = tlbflush_write_file,
+	.llseek = default_llseek,
+};
+
+static int __cpuinit create_tlb_flushall_shift(void)
+{
+	if (cpu_has_invlpg) {
+		debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
+			arch_debugfs_dir, NULL, &fops_tlbflush);
+	}
+	return 0;
+}
+late_initcall(create_tlb_flushall_shift);
+#endif
-- 
1.7.5.4

