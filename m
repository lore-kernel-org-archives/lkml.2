Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1EJDJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:09:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:8135 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab1EJDJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,344,1301900400"; 
   d="scan'208";a="136299"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, dzickus@redhat.com
Subject: [RFC] ACPI, APEI, Generic Hardware Error Source (GHES) injecting support
Date: Tue, 10 May 2011 11:08:41 +0800
Message-Id: <1304996921-24881-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The testing of Generic Hardware Error Source (GHES) is quite
difficult, because special hardware is needed to trigger the hardware
error. So a software based hardware error injector for GHES is
implemented.

Error notification is not provided in this patch.  So you still need
some NMI/SCI/IRQ injecting support to make it work.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/Kconfig         |   10 ++
 drivers/acpi/apei/Makefile        |    1 
 drivers/acpi/apei/apei-internal.h |    8 ++
 drivers/acpi/apei/ghes-inj.c      |  132 ++++++++++++++++++++++++++++++++++++++
 drivers/acpi/apei/ghes.c          |   15 ++++
 5 files changed, 165 insertions(+), 1 deletion(-)
 create mode 100644 drivers/acpi/apei/ghes-inj.c

--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -54,3 +54,13 @@ config ACPI_APEI_ERST_DEBUG
 	  error information to and from a persistent store. Enable this
 	  if you want to debugging and testing the ERST kernel support
 	  and firmware implementation.
+
+config ACPI_APEI_GHES_INJ
+	tristate "APEI Generic Hardware Error Source (GHES) Injecting Support"
+	depends on ACPI_APEI_GHES
+	help
+	  GHES provides a way to report platform hardware errors (such
+	  as that from chipset).
+
+	  The injector can inject fake hardware error record. This is
+	  used for GHES debugging/testing.
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -2,5 +2,6 @@ obj-$(CONFIG_ACPI_APEI)		+= apei.o
 obj-$(CONFIG_ACPI_APEI_GHES)	+= ghes.o
 obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
 obj-$(CONFIG_ACPI_APEI_ERST_DEBUG) += erst-dbg.o
+obj-$(CONFIG_ACPI_APEI_GHES_INJ) += ghes-inj.o
 
 apei-y := apei-base.o hest.o cper.o erst.o
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -33,6 +33,14 @@ struct apei_exec_context {
 	u32 entries;
 };
 
+struct ghes_inject_data {
+	unsigned long error_status_address;
+	u16 source_id;
+	unsigned short valid : 1;
+};
+
+extern struct ghes_inject_data ghes_inject_data;
+
 void apei_exec_ctx_init(struct apei_exec_context *ctx,
 			struct apei_exec_ins_type *ins_table,
 			u32 instructions,
--- /dev/null
+++ b/drivers/acpi/apei/ghes-inj.c
@@ -0,0 +1,132 @@
+/*
+ * APEI Generic Hardware Error Source (GHES) injector support
+ *
+ * Fake hardware error record can be injected. This is used for for
+ * GHES debugging/testing.
+ *
+ * Copyright 2010,2011 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <acpi/apei.h>
+
+#include "apei-internal.h"
+
+#define GHES_INJ_PFX		"GHES-INJ: "
+
+#define GHES_INJ_BUF_LEN_MAX	4096
+
+static void *ghes_inj_buf;
+static unsigned int ghes_inj_buf_len;
+
+/* Prevent erst_inj_buf from being accessed concurrently */
+static DEFINE_MUTEX(ghes_inj_mutex);
+
+static ssize_t ghes_inj_write(struct file *filp, const char __user *ubuf,
+			      size_t usize, loff_t *off)
+{
+	int rc;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (*off != 0)
+		return -EINVAL;
+
+	if (usize > GHES_INJ_BUF_LEN_MAX)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&ghes_inj_mutex))
+		return -EINTR;
+	ghes_inject_data.valid = 0;
+	/* Wait for all consumers finish using the injecting buffer */
+	synchronize_rcu();
+	if (usize > ghes_inj_buf_len) {
+		void *p;
+		rc = -ENOMEM;
+		p = kmalloc(usize, GFP_KERNEL);
+		if (!p)
+			goto out;
+		kfree(ghes_inj_buf);
+		ghes_inj_buf = p;
+		ghes_inj_buf_len = usize;
+	}
+	rc = copy_from_user(ghes_inj_buf, ubuf, usize);
+	if (rc) {
+		rc = -EFAULT;
+		goto out;
+	}
+	ghes_inject_data.error_status_address = __pa(ghes_inj_buf);
+	/*
+	 * ghes_injiect_data.valid must be set after other fields are
+	 * written
+	 */
+	smp_wmb();
+	ghes_inject_data.valid = 1;
+out:
+	mutex_unlock(&ghes_inj_mutex);
+	return rc ? rc : usize;
+}
+
+static const struct file_operations ghes_inj_fops = {
+	.owner		= THIS_MODULE,
+	.write		= ghes_inj_write,
+};
+
+static struct dentry *ghes_debug_dir;
+
+static __init int ghes_inj_init(void)
+{
+	struct dentry *f;
+	int rc = -ENOMEM;
+
+	ghes_debug_dir = debugfs_create_dir("ghes", apei_get_debugfs_dir());
+	if (!ghes_debug_dir)
+		return rc;
+	f = debugfs_create_file("inject", S_IWUSR, ghes_debug_dir,
+				NULL, &ghes_inj_fops);
+	if (!f)
+		goto err_cleanup;
+	f = debugfs_create_u16("inject_source_id", S_IRUSR | S_IWUSR,
+			       ghes_debug_dir, &ghes_inject_data.source_id);
+	if (!f)
+		goto err_cleanup;
+
+	return 0;
+err_cleanup:
+	debugfs_remove_recursive(ghes_debug_dir);
+	return rc;
+}
+
+static __exit void ghes_inj_exit(void)
+{
+	debugfs_remove_recursive(ghes_debug_dir);
+	ghes_inject_data.valid = 0;
+	/* Wait for all consumers finish using the injecting buffer */
+	synchronize_rcu();
+	kfree(ghes_inj_buf);
+}
+
+module_init(ghes_inj_init);
+module_exit(ghes_inj_exit);
+
+MODULE_AUTHOR("Huang Ying");
+MODULE_DESCRIPTION("APEI Generic Hardware Error Source (GHES) injecting support");
+MODULE_LICENSE("GPL");
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -153,6 +153,9 @@ static unsigned long ghes_estatus_pool_s
 static struct llist_head ghes_estatus_llist;
 static struct irq_work ghes_proc_irq_work;
 
+struct ghes_inject_data ghes_inject_data;
+EXPORT_SYMBOL_GPL(ghes_inject_data);
+
 static int ghes_ioremap_init(void)
 {
 	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * GHES_IOREMAP_PAGES,
@@ -371,7 +374,13 @@ static int ghes_read_estatus(struct ghes
 	u32 len;
 	int rc;
 
-	rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
+	if (!ghes_inject_data.valid ||
+	    ghes_inject_data.source_id != g->header.source_id)
+		rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
+	else {
+		buf_paddr = ghes_inject_data.error_status_address;
+		rc = 0;
+	}
 	if (rc) {
 		if (!silent && printk_ratelimit())
 			pr_warning(FW_WARN GHES_PFX
@@ -420,6 +429,10 @@ static void ghes_clear_estatus(struct gh
 	ghes_copy_tofrom_phys(ghes->estatus, ghes->buffer_paddr,
 			      sizeof(ghes->estatus->block_status), 0);
 	ghes->flags &= ~GHES_TO_CLEAR;
+
+	if (ghes_inject_data.valid &&
+	    ghes_inject_data.source_id == ghes->generic->header.source_id)
+		ghes_inject_data.valid = 0;
 }
 
 static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
