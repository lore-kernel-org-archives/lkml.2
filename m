Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2CBCxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 21:53:21 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:58624 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab2CBCxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 21:53:19 -0500
From: Barry Song <Barry.Song@csr.com>
To: <mina86@mina86.com>, <m.szyprowski@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <workgroup.linux@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] MM: CMA: add a simple kernel module as the helper to test CMA
Date: Fri, 2 Mar 2012 10:52:22 +0800
Message-ID: <1330656742-5233-1-git-send-email-Barry.Song@csr.com>
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
$ echo 0 > /dev/cma_test
will require cma_test to request 1MB
2nd time
$ echo 0 > /dev/cma_test
will require cma_test to request 2MB

Any read request to /dev/cma_test will let the module to free memory from CMA,
for example:

1st time
$ cat /dev/cma_test
will require cma_test to free the 1MB allocated in the first write request
2nd time
$ echo 0 > /dev/cma_test
will require cma_test to free the 2MB allocated in the second write request

Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 tools/cma/Makefile   |   13 ++++++
 tools/cma/cma_test.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 0 deletions(-)
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
index 0000000..3ee89f3
--- /dev/null
+++ b/tools/cma/cma_test.c
@@ -0,0 +1,108 @@
+/*
+ * kernel module helper for testing CMA
+ *
+ * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/dma-mapping.h>
+
+#define CMA_NUM  10
+static struct device *cma_dev;
+static dma_addr_t dma_phys[CMA_NUM];
+static void *dma_virt[CMA_NUM];
+
+/* any read request will free coherent memory, eg.
+ * cat /dev/cma_test
+ */
+static ssize_t
+cma_test_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	int i;
+
+	for (i = 0; i < CMA_NUM; i++) {
+		if (dma_virt[i]) {
+			dma_free_coherent(cma_dev, (i + 1) * SZ_1M, dma_virt[i], dma_phys[i]);
+			_dev_info(cma_dev, "free virt: %p phys: %p\n", dma_virt[i], (void *)dma_phys[i]);
+			dma_virt[i] = NULL;
+			break;
+		}
+	}
+	return 0;
+}
+
+/*
+ * any write request will alloc coherent memory, eg.
+ * echo 0 > /dev/cma_test
+ */
+static ssize_t
+cma_test_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < CMA_NUM; i++) {
+		if (!dma_virt[i]) {
+			dma_virt[i] = dma_alloc_coherent(cma_dev, (i + 1) * SZ_1M, &dma_phys[i], GFP_KERNEL);
+
+			if (dma_virt[i]) {
+				void *p;
+				/* touch every page in the allocated memory */
+				for (p = dma_virt[i]; p <  dma_virt[i] + (i + 1) * SZ_1M; p += PAGE_SIZE)
+					*(u32 *)p = 0;
+
+				_dev_info(cma_dev, "alloc virt: %p phys: %p\n", dma_virt[i], (void *)dma_phys[i]);
+			} else {
+				dev_err(cma_dev, "no mem in CMA area\n");
+				ret = -ENOMEM;
+			}
+			break;
+		}
+	}
+
+	return count;
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
