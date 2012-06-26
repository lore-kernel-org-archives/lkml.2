Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab2FZPQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:16:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2FZPQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:16:41 -0400
Date: Tue, 26 Jun 2012 08:16:29 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-126abdc40ba5257c5ba1e6e04b809c3626034ee9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1340604507-11214-6-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-6-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/tlb: add tlb_flushall_shift knob into debugfs
Git-Commit-ID: 126abdc40ba5257c5ba1e6e04b809c3626034ee9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 26 Jun 2012 08:16:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  126abdc40ba5257c5ba1e6e04b809c3626034ee9
Gitweb:     http://git.kernel.org/tip/126abdc40ba5257c5ba1e6e04b809c3626034ee9
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Mon, 25 Jun 2012 14:08:23 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 25 Jun 2012 20:53:18 -0700

x86/tlb: add tlb_flushall_shift knob into debugfs

kernel will replace cr3 rewrite with invlpg when
  tlb_flush_entries <= active_tlb_entries / 2^tlb_flushall_factor
if tlb_flushall_factor is -1, kernel won't do this replacement.

User can modify its value according to specific CPU/applications.

Thanks for Borislav providing the help message of
CONFIG_DEBUG_TLBFLUSH.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/r/1340604507-11214-6-git-send-email-alex.shi@intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
