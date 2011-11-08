Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab1KHAGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:06:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:19273 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1KHAGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:06:33 -0500
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, msb@chromium.org, marco.stornelli@gmail.com,
        seiji.aguchi@hds.com, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH] ramoops: Add a device file for ramoops buffer access.
Date: Mon,  7 Nov 2011 16:06:00 -0800
Message-Id: <1320710760-2734-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a /dev/ramoops device file that gives direct access to ramoops buffers.
This interface is cleaner than using /dev/mem to access the buffers because
we no longer need to lseek() or (for ARM) mmap() to an address specified in
the sysfs mem_address file.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/char/ramoops.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 7c7f42a1f8..eac273a 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -32,6 +32,9 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/ramoops.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
@@ -65,11 +68,39 @@ static struct ramoops_context {
 	int dump_oops;
 	int count;
 	int max_count;
+	struct miscdevice misc_dev;
 } oops_cxt;
 
 static struct platform_device *dummy;
 static struct ramoops_platform_data *dummy_data;
 
+static int ramoops_open(struct inode *inode, struct file *file)
+{
+	file->private_data = &oops_cxt;
+	return 0;
+}
+
+static ssize_t
+ramoops_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct ramoops_context *cxt = file->private_data;
+	void *from = cxt->virt_addr + *ppos;
+
+	if (*ppos + count > cxt->size)
+		count = cxt->size - *ppos;
+	if (copy_to_user(buf, from, count))
+		count = -EFAULT;
+	else
+		*ppos += count;
+
+	return count;
+}
+
+static const struct file_operations ramoops_fops = {
+	.open = ramoops_open,
+	.read = ramoops_read,
+};
+
 static void ramoops_do_dump(struct kmsg_dumper *dumper,
 		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
 		const char *s2, unsigned long l2)
@@ -169,15 +200,24 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		goto fail2;
 	}
 
+	cxt->misc_dev.minor = MISC_DYNAMIC_MINOR;
+	cxt->misc_dev.name = "ramoops";
+	cxt->misc_dev.fops = &ramoops_fops;
+	err = misc_register(&cxt->misc_dev);
+	if (err)
+		goto fail1;
+
 	cxt->dump.dump = ramoops_do_dump;
 	err = kmsg_dump_register(&cxt->dump);
 	if (err) {
 		pr_err("registering kmsg dumper failed\n");
-		goto fail1;
+		goto clean_misc;
 	}
 
 	return 0;
 
+clean_misc:
+	misc_deregister(&cxt->misc_dev);
 fail1:
 	iounmap(cxt->virt_addr);
 fail2:
@@ -193,6 +233,7 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 	if (kmsg_dump_unregister(&cxt->dump) < 0)
 		pr_warn("could not unregister kmsg_dumper\n");
 
+	misc_deregister(&cxt->misc_dev);
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
 	return 0;
-- 
1.7.3.1

