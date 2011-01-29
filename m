Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1A2A1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:27:05 -0500
Received: from claw.goop.org ([74.207.240.146]:40204 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab1A2A1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:27:02 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/2] xen: add CPU microcode update driver
Date: Fri, 28 Jan 2011 16:26:54 -0800
Message-Id: <0a49ceea0d032864a72a8744c82c3786a01f34f4.1296260656.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1296260656.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1296260656.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Xen does all the hard work for us, including choosing the right update
method for this cpu type and actually doing it for all cpus.  We just
need to supply it with the firmware blob.

Because Xen updates all CPUs (and the kernel's virtual cpu numbers have
no fixed relationship with the underlying physical cpus), we only bother
doing anything for cpu "0".

[ Impact: allow CPU microcode update in Xen dom0 ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/microcode.h |    9 ++
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/microcode_core.c |    5 +-
 arch/x86/kernel/microcode_xen.c  |  198 ++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/Kconfig             |    4 +
 5 files changed, 216 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/microcode_xen.c

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 2421507..22677d6 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -61,4 +61,13 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
 }
 #endif
 
+#ifdef CONFIG_MICROCODE_XEN
+extern struct microcode_ops * __init init_xen_microcode(void);
+#else
+static inline struct microcode_ops * __init init_xen_microcode(void)
+{
+	return NULL;
+}
+#endif
+
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34244b2..8fd7a4e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
+microcode-$(CONFIG_MICROCODE_XEN)	+= microcode_xen.o
 obj-$(CONFIG_MICROCODE)			+= microcode.o
 
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 1cca374..6550539 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -83,6 +83,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 
+#include <xen/xen.h>
 #include <asm/microcode.h>
 #include <asm/processor.h>
 
@@ -506,7 +507,9 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
-	if (c->x86_vendor == X86_VENDOR_INTEL)
+	if (xen_pv_domain())
+		microcode_ops = init_xen_microcode();
+	else if (c->x86_vendor == X86_VENDOR_INTEL)
 		microcode_ops = init_intel_microcode();
 	else if (c->x86_vendor == X86_VENDOR_AMD)
 		microcode_ops = init_amd_microcode();
diff --git a/arch/x86/kernel/microcode_xen.c b/arch/x86/kernel/microcode_xen.c
new file mode 100644
index 0000000..9d2a06b
--- /dev/null
+++ b/arch/x86/kernel/microcode_xen.c
@@ -0,0 +1,198 @@
+/*
+ * Xen microcode update driver
+ *
+ * Xen does most of the work here.  We just pass the whole blob into
+ * Xen, and it will apply it to all CPUs as appropriate.  Xen will
+ * worry about how different CPU models are actually updated.
+ */
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/vmalloc.h>
+#include <linux/uaccess.h>
+
+#include <asm/microcode.h>
+
+#include <xen/xen.h>
+#include <xen/interface/platform.h>
+#include <xen/interface/xen.h>
+
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
+
+MODULE_DESCRIPTION("Xen microcode update driver");
+MODULE_LICENSE("GPL");
+
+struct xen_microcode {
+	size_t len;
+	char data[0];
+};
+
+static int xen_microcode_update(int cpu)
+{
+	int err;
+	struct xen_platform_op op;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct xen_microcode *uc = uci->mc;
+
+	if (uc == NULL || uc->len == 0) {
+		/*
+		 * We do all cpus at once, so we don't need to do
+		 * other cpus explicitly (besides, these vcpu numbers
+		 * have no relationship to underlying physical cpus).
+		 */
+		return 0;
+	}
+
+	op.cmd = XENPF_microcode_update;
+	set_xen_guest_handle(op.u.microcode.data, uc->data);
+	op.u.microcode.length = uc->len;
+
+	err = HYPERVISOR_dom0_op(&op);
+
+	if (err != 0)
+		printk(KERN_WARNING "microcode_xen: microcode update failed: %d\n", err);
+
+	return err;
+}
+
+static enum ucode_state xen_request_microcode_fw(int cpu, struct device *device)
+{
+	char name[30];
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	const struct firmware *firmware;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	enum ucode_state ret;
+	struct xen_microcode *uc;
+	size_t size;
+	int err;
+
+	switch (c->x86_vendor) {
+	case X86_VENDOR_INTEL:
+		snprintf(name, sizeof(name), "intel-ucode/%02x-%02x-%02x",
+			 c->x86, c->x86_model, c->x86_mask);
+		break;
+
+	case X86_VENDOR_AMD:
+		snprintf(name, sizeof(name), "amd-ucode/microcode_amd.bin");
+		break;
+
+	default:
+		return UCODE_NFOUND;
+	}
+
+	err = request_firmware(&firmware, name, device);
+	if (err) {
+		pr_debug("microcode: data file %s load failed\n", name);
+		return UCODE_NFOUND;
+	}
+
+	/*
+	 * Only bother getting real firmware for cpu 0; the others get
+	 * dummy placeholders.
+	 */
+	if (cpu == 0)
+		size = firmware->size;
+	else
+		size = 0;
+
+	if (uci->mc != NULL) {
+		vfree(uci->mc);
+		uci->mc = NULL;
+	}
+
+	ret = UCODE_ERROR;
+	uc = vmalloc(sizeof(*uc) + size);
+	if (uc == NULL)
+		goto out;
+
+	ret = UCODE_OK;
+	uc->len = size;
+	memcpy(uc->data, firmware->data, uc->len);
+
+	uci->mc = uc;
+
+out:
+	release_firmware(firmware);
+
+	return ret;
+}
+
+static enum ucode_state xen_request_microcode_user(int cpu,
+						   const void __user *buf, size_t size)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct xen_microcode *uc;
+	enum ucode_state ret;
+	size_t unread;
+
+	if (cpu != 0) {
+		/* No real firmware for non-zero cpus; just store a
+		   placeholder */
+		size = 0;
+	}
+
+	if (uci->mc != NULL) {
+		vfree(uci->mc);
+		uci->mc = NULL;
+	}
+
+	ret = UCODE_ERROR;
+	uc = vmalloc(sizeof(*uc) + size);
+	if (uc == NULL)
+		goto out;
+
+	uc->len = size;
+
+	ret = UCODE_NFOUND;
+
+	unread = copy_from_user(uc->data, buf, size);
+
+	if (unread != 0) {
+		printk(KERN_WARNING "failed to read %zd of %zd bytes at %p -> %p\n",
+		       unread, size, buf, uc->data);
+		goto out;
+	}
+
+	ret = UCODE_OK;
+
+out:
+	if (ret == 0)
+		uci->mc = uc;
+	else
+		vfree(uc);
+
+	return ret;
+}
+
+static void xen_microcode_fini_cpu(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	vfree(uci->mc);
+	uci->mc = NULL;
+}
+
+static int xen_collect_cpu_info(int cpu, struct cpu_signature *sig)
+{
+	sig->sig = 0;
+	sig->pf = 0;
+	sig->rev = 0;
+
+	return 0;
+}
+
+static struct microcode_ops microcode_xen_ops = {
+	.request_microcode_user		  = xen_request_microcode_user,
+	.request_microcode_fw             = xen_request_microcode_fw,
+	.collect_cpu_info                 = xen_collect_cpu_info,
+	.apply_microcode                  = xen_microcode_update,
+	.microcode_fini_cpu               = xen_microcode_fini_cpu,
+};
+
+struct microcode_ops * __init init_xen_microcode(void)
+{
+	if (!xen_initial_domain())
+		return NULL;
+	return &microcode_xen_ops;
+}
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 5b54892..384e0a5 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -48,3 +48,7 @@ config XEN_DEBUG_FS
 	help
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
+
+config MICROCODE_XEN
+       def_bool y
+       depends on XEN_DOM0 && MICROCODE
\ No newline at end of file
-- 
1.7.3.5

