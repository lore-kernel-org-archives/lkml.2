Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1GFXbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:31:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51175 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1GFXbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:31:20 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] char drivers: ramoops debugfs entry
Date: Wed,  6 Jul 2011 16:29:50 -0700
Message-Id: <1309994990-4729-4-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While ramoops writes to ram, accessing the dump requires using /dev/mem
and knowing the memory location (or a similar solution). This patch
provides a debugfs interface through which the respective memory
area can be easily accessed.

The entry added is /sys/kernel/debug/ramoops/next

The entry returns a dump of size record_size each time, skipping invalid
dumps. When it reaches the end of the memory area reserved for dumps it
returns an empty record and resets the current record count.

Change-Id: Ifbab9af833be9ee0bc1c33bc9871f2fc0eb9d228
Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
 drivers/char/ramoops.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index bd9b94b..791084c 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -30,9 +30,13 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/ramoops.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
+#define RAMOOPS_DIR "ramoops"
+#define RAMOOPS_NEXT "next"
 
 static ulong record_size = MIN_MEM_SIZE;
 module_param(record_size, ulong, 0400);
@@ -61,12 +65,81 @@ static struct ramoops_context {
 	unsigned long size;
 	unsigned long record_size;
 	int dump_oops;
+	int current_entry;
 	int count;
 	int max_count;
 } oops_cxt;
 
 static struct platform_device *dummy;
 static struct ramoops_platform_data *dummy_data;
+static DEFINE_MUTEX(ramoops_mutex);
+
+/* Debugfs entries for ramoops */
+static struct dentry *ramoops_dir, *ramoops_next_entry;
+
+/*
+ * Entry to have access to the memory logged by ramoops. The way the data
+ * is returned is as follows:
+ * Data records are checked one by one for the existence of the header.
+ * If a valid record is found data is returned from it, otherwise it is
+ * skipped.
+ * Once all the records are checked the next call after the last record
+ * will return an empty buffer and the counter is reset.
+ */
+static ssize_t ramoops_read_next(struct file *file, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct ramoops_context *cxt = &oops_cxt;
+
+	mutex_lock(&ramoops_mutex);
+
+	/* Do this check here so it returns an empty file once it resets */
+	if (cxt->current_entry >= cxt->max_count) {
+		cxt->current_entry = 0;
+		count = 0;
+		goto out;
+	}
+
+	/* Check to see if the current dump is valid */
+	while (cxt->current_entry < cxt->max_count
+		&& memcmp(cxt->virt_addr + cxt->record_size *
+			  cxt->current_entry, RAMOOPS_KERNMSG_HDR,
+			  strlen(RAMOOPS_KERNMSG_HDR)))
+		cxt->current_entry++;
+
+	/* In case a dump was not found return 0 */
+	if (cxt->current_entry >= cxt->max_count) {
+		count = 0;
+		goto out;
+	}
+
+	/* Otherwise proceed as normal to return the data */
+	if (*ppos + count > cxt->record_size)
+		count = cxt->record_size - *ppos;
+	if (*ppos > cxt->record_size) {
+		count = 0;
+		cxt->current_entry++;
+		goto out;
+	}
+	if (copy_to_user(buf, cxt->virt_addr + cxt->record_size *
+			 cxt->current_entry + *ppos, count)) {
+		count = -EFAULT;
+		goto out;
+	}
+	*ppos += count;
+
+	/* completed reading this part, go to the next one */
+	if (*ppos == cxt->record_size)
+		cxt->current_entry++;
+
+out:
+	mutex_unlock(&ramoops_mutex);
+	return count;
+}
+
+static const struct file_operations ramoops_next_fops = {
+	.read = ramoops_read_next,
+};
 
 static void ramoops_do_dump(struct kmsg_dumper *dumper,
 		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
@@ -89,6 +162,7 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
 		return;
 
+	mutex_lock(&ramoops_mutex);
 	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
 	buf_orig = buf;
 
@@ -110,6 +184,7 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
 
 	cxt->count = (cxt->count + 1) % cxt->max_count;
+	mutex_unlock(&ramoops_mutex);
 }
 
 static int __init ramoops_probe(struct platform_device *pdev)
@@ -128,8 +203,8 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	rounddown_pow_of_two(pdata->record_size);
 
 	/* Check for the minimum memory size */
-	if (pdata->mem_size < MIN_MEM_SIZE &&
-			pdata->record_size < MIN_MEM_SIZE) {
+	if (pdata->mem_size < MIN_MEM_SIZE
+	    && pdata->record_size < MIN_MEM_SIZE) {
 		pr_err("memory size too small, minium is %lu\n", MIN_MEM_SIZE);
 		goto fail3;
 	}
@@ -145,6 +220,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
+	cxt->current_entry = 0;
 	cxt->dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
@@ -166,6 +242,30 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		goto fail1;
 	}
 
+	/* Initialize debugfs entry so the memory can be easily accessed */
+	ramoops_dir = debugfs_create_dir(RAMOOPS_DIR, NULL);
+	if (ramoops_dir == NULL) {
+		err = -ENOMEM;
+		pr_err("debugfs directory entry creation failed\n");
+		goto out;
+	}
+
+	/*
+	 * This interface exposes the next valid entry from ramoops, starting
+	 * from the start of memory area. Once there are no more entries it
+	 * returns an empty buffer. Reading the entry again afterwards starts
+	 * from the begining.
+	 */
+	ramoops_next_entry = debugfs_create_file(RAMOOPS_NEXT, 0444,
+					ramoops_dir, NULL, &ramoops_next_fops);
+
+	if (ramoops_next_entry == NULL) {
+		err = -ENOMEM;
+		pr_err("debugfs next entry creation failed\n");
+		goto no_ramoops_next;
+	}
+
+
 	return 0;
 
 fail1:
@@ -174,6 +274,11 @@ fail2:
 	release_mem_region(cxt->phys_addr, cxt->size);
 fail3:
 	return err;
+
+no_ramoops_next:
+	debugfs_remove(ramoops_dir);
+out:
+	return err;
 }
 
 static int __exit ramoops_remove(struct platform_device *pdev)
@@ -231,6 +336,10 @@ static void __exit ramoops_exit(void)
 {
 	platform_driver_unregister(&ramoops_driver);
 	kfree(dummy_data);
+
+	/* Clean up debugfs entries */
+	debugfs_remove(ramoops_next_entry);
+	debugfs_remove(ramoops_dir);
 }
 
 module_init(ramoops_init);
-- 
1.7.3.1

