Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab2CBP0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:26:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43794 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2CBP0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:26:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mnazarewicz@gmail.com designates 10.14.99.2 as permitted sender) smtp.mail=mnazarewicz@gmail.com; dkim=pass header.i=mnazarewicz@gmail.com
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: m.szyprowski@samsung.com, "Barry Song" <Barry.Song@csr.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, "Barry Song" <Baohua.Song@csr.com>
Subject: Re: [PATCH] MM: CMA: add a simple kernel module as the helper to test
 CMA
References: <1330656742-5233-1-git-send-email-Barry.Song@csr.com>
Date: Fri, 02 Mar 2012 16:26:39 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wajuip2a3l0zgt@mpn-glaptop>
In-Reply-To: <1330656742-5233-1-git-send-email-Barry.Song@csr.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2012 03:52:22 +0100, Barry Song <Barry.Song@csr.com> wrote:

> From: Barry Song <Baohua.Song@csr.com>
>
> Any write request to /dev/cma_test will let the module to allocate memory from
> CMA, for example:
>
> 1st time
> $ echo 0 > /dev/cma_test
> will require cma_test to request 1MB
> 2nd time
> $ echo 0 > /dev/cma_test
> will require cma_test to request 2MB
>
> Any read request to /dev/cma_test will let the module to free memory from CMA,
> for example:
>
> 1st time
> $ cat /dev/cma_test
> will require cma_test to free the 1MB allocated in the first write request
> 2nd time
> $ echo 0 > /dev/cma_test
> will require cma_test to free the 2MB allocated in the second write request

Looks quite all right.  It has a race condition but I guess for a test device it's
not that big of a deal (I think the race cannot cause panic).  Either way, would be
nice if one could specify how much memory device should allocate.  How about those
changes:

diff --git a/tools/cma/cma_test.c b/tools/cma/cma_test.c
index 3ee89f3..3d3b074 100644
--- a/tools/cma/cma_test.c
+++ b/tools/cma/cma_test.c
@@ -6,66 +6,96 @@
   * Licensed under GPLv2 or later.
   */

-#include <linux/module.h>
  #include <linux/device.h>
+#include <linux/dma-mapping.h>
  #include <linux/fs.h>
+#include <linux/list.h>
  #include <linux/miscdevice.h>
-#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+
+struct cma_allocation {
+	struct list_head list;
+	unsigned long size;
+	dma_addr_t dma;
+	void *virt;
+};

-#define CMA_NUM  10
  static struct device *cma_dev;
-static dma_addr_t dma_phys[CMA_NUM];
-static void *dma_virt[CMA_NUM];
+static LIST_HEAD(cma_allocations);
+static DEFINE_SPINLOCK(cma_lock);

-/* any read request will free coherent memory, eg.
+/*
+ * Any read request will free a single coherent memory, eg.
   * cat /dev/cma_test
   */
  static ssize_t
  cma_test_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
  {
-	int i;
-
-	for (i = 0; i < CMA_NUM; i++) {
-		if (dma_virt[i]) {
-			dma_free_coherent(cma_dev, (i + 1) * SZ_1M, dma_virt[i], dma_phys[i]);
-			_dev_info(cma_dev, "free virt: %p phys: %p\n", dma_virt[i], (void *)dma_phys[i]);
-			dma_virt[i] = NULL;
-			break;
-		}
+	struct cma_allocation *alloc = NULL;
+
+	spin_lock(&cma_lock);
+	if (!list_empty(&cma_allocations)) {
+		alloc = list_first_entry(&cma_allocations,
+					 struct cma_allocation, list);
+		list_del(&alloc->list);
  	}
+	spin_unlock(&cma_lock);
+
+	if (alloc) {
+		dma_free_coherent(cma_dev, alloc->size, alloc->virt,
+				  alloc->dma);
+		_dev_info(cma_dev, "free virt: %p phys: %p\n",
+			  alloc->phys, (void *)alloc->dma);
+		kfree(alloc);
+	}
+
  	return 0;
  }

  /*
- * any write request will alloc coherent memory, eg.
- * echo 0 > /dev/cma_test
+ * Writes request specified number of pages, eg.
+ * echo 1024 > /dev/cma_test
   */
  static ssize_t
-cma_test_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+cma_test_write(struct file *file, const char __user *buf, size_t count,
+	       loff_t *ppos)
  {
-	int i;
+	struct cma_allocation *alloc;
  	int ret;

-	for (i = 0; i < CMA_NUM; i++) {
-		if (!dma_virt[i]) {
-			dma_virt[i] = dma_alloc_coherent(cma_dev, (i + 1) * SZ_1M, &dma_phys[i], GFP_KERNEL);
-
-			if (dma_virt[i]) {
-				void *p;
-				/* touch every page in the allocated memory */
-				for (p = dma_virt[i]; p <  dma_virt[i] + (i + 1) * SZ_1M; p += PAGE_SIZE)
-					*(u32 *)p = 0;
-
-				_dev_info(cma_dev, "alloc virt: %p phys: %p\n", dma_virt[i], (void *)dma_phys[i]);
-			} else {
-				dev_err(cma_dev, "no mem in CMA area\n");
-				ret = -ENOMEM;
-			}
-			break;
-		}
-	}
+	alloc = kmalloc(sizeof *alloc, GFP_KERNEL);
+	if (!alloc)
+		return -ENOMEM;
+
+	ret = kstrtouint_from_user(buf, count, 0, &alloc->size);
+	if (ret)
+		return ret;
+
+	if (!alloc->size)
+		return -EINVAL;
+
+	if (alloc->size > (ULONG_MAX << PAGE_SHIFT))
+		return -EOVERFLOW;

-	return count;
+	alloc->size >>= PAGE_SHIFT;
+	alloc->virt = dma_alloc_coherent(cma_dev, alloc->size,
+					 &alloc->dma, GFP_KERNEL);
+
+	if (alloc->virt) {
+		_dev_info(cma_dev, "alloc virt: %p phys: %p\n", alloc->virt,
+			  (void *)alloc->dma);
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
  }

  static const struct file_operations cma_test_fops = {

> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> ---
>  tools/cma/Makefile   |   13 ++++++
>  tools/cma/cma_test.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 121 insertions(+), 0 deletions(-)
>  create mode 100644 tools/cma/Makefile
>  create mode 100644 tools/cma/cma_test.c
>
> diff --git a/tools/cma/Makefile b/tools/cma/Makefile
> new file mode 100644
> index 0000000..d15c2c0
> --- /dev/null
> +++ b/tools/cma/Makefile
> @@ -0,0 +1,13 @@
> +# Kernel modules
> +#
> +# To compile for ARM:
> +# make ARCH=arm CC=arm-none-linux-gnueabi-gcc
> +#
> +obj-m	+= cma_test.o
> +
> +build: kernel_modules
> +
> +kernel_modules:
> +	${MAKE} -C $(CURDIR)/../.. M=$(CURDIR)
> +clean:
> +	${MAKE} -C $(CURDIR)/../.. M=$(CURDIR) clean
> diff --git a/tools/cma/cma_test.c b/tools/cma/cma_test.c
> new file mode 100644
> index 0000000..3ee89f3
> --- /dev/null
> +++ b/tools/cma/cma_test.c
> @@ -0,0 +1,108 @@
> +/*
> + * kernel module helper for testing CMA
> + *
> + * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/dma-mapping.h>
> +
> +#define CMA_NUM  10
> +static struct device *cma_dev;
> +static dma_addr_t dma_phys[CMA_NUM];
> +static void *dma_virt[CMA_NUM];
> +
> +/* any read request will free coherent memory, eg.
> + * cat /dev/cma_test
> + */
> +static ssize_t
> +cma_test_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> +{
> +	int i;
> +
> +	for (i = 0; i < CMA_NUM; i++) {
> +		if (dma_virt[i]) {
> +			dma_free_coherent(cma_dev, (i + 1) * SZ_1M, dma_virt[i], dma_phys[i]);
> +			_dev_info(cma_dev, "free virt: %p phys: %p\n", dma_virt[i], (void *)dma_phys[i]);
> +			dma_virt[i] = NULL;
> +			break;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * any write request will alloc coherent memory, eg.
> + * echo 0 > /dev/cma_test
> + */
> +static ssize_t
> +cma_test_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	int i;
> +	int ret;
> +
> +	for (i = 0; i < CMA_NUM; i++) {
> +		if (!dma_virt[i]) {
> +			dma_virt[i] = dma_alloc_coherent(cma_dev, (i + 1) * SZ_1M, &dma_phys[i], GFP_KERNEL);
> +
> +			if (dma_virt[i]) {
> +				void *p;
> +				/* touch every page in the allocated memory */
> +				for (p = dma_virt[i]; p <  dma_virt[i] + (i + 1) * SZ_1M; p += PAGE_SIZE)
> +					*(u32 *)p = 0;
> +
> +				_dev_info(cma_dev, "alloc virt: %p phys: %p\n", dma_virt[i], (void *)dma_phys[i]);
> +			} else {
> +				dev_err(cma_dev, "no mem in CMA area\n");
> +				ret = -ENOMEM;
> +			}
> +			break;
> +		}
> +	}
> +
> +	return count;
> +}
> +
> +static const struct file_operations cma_test_fops = {
> +	.owner =    THIS_MODULE,
> +	.read  =    cma_test_read,
> +	.write =    cma_test_write,
> +};
> +
> +static struct miscdevice cma_test_misc = {
> +	.name = "cma_test",
> +	.fops = &cma_test_fops,
> +};
> +
> +static int __init cma_test_init(void)
> +{
> +	int ret = 0;
> +
> +	ret = misc_register(&cma_test_misc);
> +	if (unlikely(ret)) {
> +		pr_err("failed to register cma test misc device!\n");
> +		return ret;
> +	}
> +	cma_dev = cma_test_misc.this_device;
> +	cma_dev->coherent_dma_mask = ~0;
> +	_dev_info(cma_dev, "registered.\n");
> +
> +	return ret;
> +}
> +module_init(cma_test_init);
> +
> +static void __exit cma_test_exit(void)
> +{
> +	misc_deregister(&cma_test_misc);
> +}
> +module_exit(cma_test_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Barry Song <Baohua.Song@csr.com>");
> +MODULE_DESCRIPTION("kernel module to help the test of CMA");
> +MODULE_ALIAS("CMA test");


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
