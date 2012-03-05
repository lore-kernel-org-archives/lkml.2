Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2CEHQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:16:03 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:56827 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2CEHQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:16:01 -0500
From: Barry Song <Barry.Song@csr.com>
To: <mina86@mina86.com>, <m.szyprowski@samsung.com>
CC: <workgroup.linux@csr.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH v2] MM: CMA: add a simple kernel module as the helper to test CMA
Date: Mon, 5 Mar 2012 15:13:46 +0800
Message-ID: <1330931626-30855-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

Any write request to /dev/cma_test will let the module to allocate memory from
CMA, for example:

1st time
$ echo 1024 > /dev/cma_test
will require cma_test to request 1MB(1024KB)
2nd time
$ echo 2048 > /dev/cma_test
will require cma_test to request 2MB(2048KB)

Any read request to /dev/cma_test will let the module to free the 1st valid
memory from CMA, for example:

1st time
$ cat /dev/cma_test
will require cma_test to free the 1MB allocated in the first write request
2nd time
$ cat /dev/cma_test
will require cma_test to free the 2MB allocated in the second write request

Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 -v2:
 move to support multiple allocation and permit users to set alloc size
 (pointed out by Michal Nazarewicz)

 tools/cma/Makefile   |   13 +++++
 tools/cma/cma_test.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+), 0 deletions(-)
 create mode 100644 tools/cma/Makefile
 create mode 100644 tools/cma/cma_test.c

diff --git a/tools/cma/Makefile b/tools/cma/Makefile
new file mode 100644
index 0000000..d15c2c0
--- /dev/null
+++ b/tools/cma/Makefile
@@ -0,0 +1,13 @@
+# Kernel modules
+#
+# To compile for ARM:
+# make ARCH=arm CC=arm-none-linux-gnueabi-gcc
+#
+obj-m	+= cma_test.o
+
+build: kernel_modules
+
+kernel_modules:
+	${MAKE} -C $(CURDIR)/../.. M=$(CURDIR)
+clean:
+	${MAKE} -C $(CURDIR)/../.. M=$(CURDIR) clean
diff --git a/tools/cma/cma_test.c b/tools/cma/cma_test.c
new file mode 100644
index 0000000..46af250
--- /dev/null
+++ b/tools/cma/cma_test.c
@@ -0,0 +1,140 @@
+/*
+ * kernel module helper for testing CMA
+ *
+ * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+struct cma_allocation {
+	struct list_head list;
+	unsigned long size;
+	dma_addr_t dma;
+	void *virt;
+};
+
+static struct device *cma_dev;
+static LIST_HEAD(cma_allocations);
+static DEFINE_SPINLOCK(cma_lock);
+
+/*
+ * any read request will free the 1st allocated coherent memory, eg.
+ * cat /dev/cma_test
+ */
+static ssize_t
+cma_test_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct cma_allocation *alloc = NULL;
+
+	spin_lock(&cma_lock);
+	if (!list_empty(&cma_allocations)) {
+		alloc = list_first_entry(&cma_allocations,
+			struct cma_allocation, list);
+		list_del(&alloc->list);
+	}
+	spin_unlock(&cma_lock);
+
+	if (alloc) {
+		dma_free_coherent(cma_dev, alloc->size, alloc->virt,
+			alloc->dma);
+
+		_dev_info(cma_dev, "free CM at virtual address: 0x%p dma address: 0x%p size:%luKiB\n",
+			alloc->virt, (void *)alloc->dma, alloc->size / SZ_1K);
+		kfree(alloc);
+	}
+
+	return 0;
+}
+
+/*
+ * any write request will alloc a new coherent memory, eg.
+ * echo 1024 > /dev/cma_test
+ * will request 1024KiB by CMA
+ */
+static ssize_t
+cma_test_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+{
+	struct cma_allocation *alloc;
+	int ret;
+
+	alloc = kmalloc(sizeof *alloc, GFP_KERNEL);
+	if (!alloc)
+		return -ENOMEM;
+
+	ret = kstrtoul_from_user(buf, count, 0, &alloc->size);
+	if (ret)
+		return ret;
+
+	if (!alloc->size)
+		return -EINVAL;
+
+	if (alloc->size > (ULONG_MAX << PAGE_SHIFT))
+		return -EOVERFLOW;
+
+	alloc->size *= SZ_1K;
+	alloc->virt = dma_alloc_coherent(cma_dev, alloc->size,
+		&alloc->dma, GFP_KERNEL);
+
+	if (alloc->virt) {
+		_dev_info(cma_dev, "allocate CM at virtual address: 0x%p"
+			"address: 0x%p size:%luKiB\n", alloc->virt,
+			(void *)alloc->dma, alloc->size / SZ_1K);
+
+		spin_lock(&cma_lock);
+		list_add_tail(&alloc->list, &cma_allocations);
+		spin_unlock(&cma_lock);
+
+		return count;
+	} else {
+		dev_err(cma_dev, "no mem in CMA area\n");
+		kfree(alloc);
+		return -ENOSPC;
+	}
+}
+
+static const struct file_operations cma_test_fops = {
+	.owner =    THIS_MODULE,
+	.read  =    cma_test_read,
+	.write =    cma_test_write,
+};
+
+static struct miscdevice cma_test_misc = {
+	.name = "cma_test",
+	.fops = &cma_test_fops,
+};
+
+static int __init cma_test_init(void)
+{
+	int ret = 0;
+
+	ret = misc_register(&cma_test_misc);
+	if (unlikely(ret)) {
+		pr_err("failed to register cma test misc device!\n");
+		return ret;
+	}
+	cma_dev = cma_test_misc.this_device;
+	cma_dev->coherent_dma_mask = ~0;
+	_dev_info(cma_dev, "registered.\n");
+
+	return ret;
+}
+module_init(cma_test_init);
+
+static void __exit cma_test_exit(void)
+{
+	misc_deregister(&cma_test_misc);
+}
+module_exit(cma_test_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Barry Song <Baohua.Song@csr.com>");
+MODULE_DESCRIPTION("kernel module to help the test of CMA");
+MODULE_ALIAS("CMA test");
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
