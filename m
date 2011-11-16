Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1KPV0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:26:02 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58084 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1KPV0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:26:00 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ben Gardner <bgardner@wabtec.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/2] ramoops: use pstore interface
Date: Wed, 16 Nov 2011 13:25:38 -0800
Message-Id: <1321478739-8978-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321478739-8978-1-git-send-email-keescook@chromium.org>
References: <1321478739-8978-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using /dev/mem directly, use the common pstore infrastructure
to handle Oops gathering and extraction.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/char/Kconfig   |    1 +
 drivers/char/ramoops.c |  195 +++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 152 insertions(+), 44 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 4364303..f166499 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -603,6 +603,7 @@ source "drivers/s390/char/Kconfig"
 config RAMOOPS
 	tristate "Log panic/oops to a RAM buffer"
 	depends on HAS_IOMEM
+	depends on PSTORE
 	default n
 	help
 	  This enables panic and oops messages to be logged to a circular
diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 7c7f42a..129d79a 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -2,6 +2,7 @@
  * RAM Oops/Panic logger
  *
  * Copyright (C) 2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright (C) 2011 Kees Cook <keescook@chromium.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -24,7 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/kmsg_dump.h>
+#include <linux/pstore.h>
 #include <linux/time.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -51,67 +52,150 @@ module_param(mem_size, ulong, 0400);
 MODULE_PARM_DESC(mem_size,
 		"size of reserved RAM used to store oops/panic logs");
 
-static int dump_oops = 1;
-module_param(dump_oops, int, 0600);
-MODULE_PARM_DESC(dump_oops,
-		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
-
-static struct ramoops_context {
-	struct kmsg_dumper dump;
+static int ramoops_pstore_open(struct pstore_info *psi);
+static int ramoops_pstore_close(struct pstore_info *psi);
+static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
+				   struct timespec *time,
+				   char **buf,
+				   struct pstore_info *psi);
+static int ramoops_pstore_write(enum pstore_type_id type,
+				enum kmsg_dump_reason reason, u64 *id,
+				unsigned int part,
+				size_t size, struct pstore_info *psi);
+static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
+				struct pstore_info *psi);
+
+struct ramoops_context {
 	void *virt_addr;
 	phys_addr_t phys_addr;
 	unsigned long size;
-	unsigned long record_size;
-	int dump_oops;
-	int count;
-	int max_count;
-} oops_cxt;
+	size_t record_size;
+	unsigned int count;
+	unsigned int max_count;
+	unsigned int read_count;
+	struct pstore_info pstore;
+};
 
 static struct platform_device *dummy;
 static struct ramoops_platform_data *dummy_data;
 
-static void ramoops_do_dump(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
-		const char *s2, unsigned long l2)
+static struct ramoops_context oops_cxt = {
+	.pstore = {
+		.owner	= THIS_MODULE,
+		.name	= "ramoops",
+		.open	= ramoops_pstore_open,
+		.close	= ramoops_pstore_close,
+		.read	= ramoops_pstore_read,
+		.write	= ramoops_pstore_write,
+		.erase	= ramoops_pstore_erase,
+	},
+};
+
+static int ramoops_pstore_open(struct pstore_info *psi)
 {
-	struct ramoops_context *cxt = container_of(dumper,
-			struct ramoops_context, dump);
-	unsigned long s1_start, s2_start;
-	unsigned long l1_cpy, l2_cpy;
-	int res, hdr_size;
-	char *buf, *buf_orig;
+	struct ramoops_context *cxt = &oops_cxt;
+
+	cxt->read_count = 0;
+	return 0;
+}
+
+static int ramoops_pstore_close(struct pstore_info *psi)
+{
+	return 0;
+}
+
+static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
+				   struct timespec *time,
+				   char **buf,
+				   struct pstore_info *psi)
+{
+	ssize_t size;
+	char *rambuf;
+	struct ramoops_context *cxt = &oops_cxt;
+
+	if (cxt->read_count >= cxt->max_count)
+		return -EINVAL;
+	*id = cxt->read_count++;
+	/* Only supports dmesg output so far. */
+	*type = PSTORE_TYPE_DMESG;
+	/* TODO(kees): Bogus time for the moment. */
+	time->tv_sec = 0;
+	time->tv_nsec = 0;
+
+	rambuf = cxt->virt_addr + (*id * cxt->record_size);
+	size = strnlen(rambuf, cxt->record_size);
+	*buf = kmalloc(size, GFP_KERNEL);
+	if (*buf == NULL)
+		return -ENOMEM;
+	memcpy(*buf, rambuf, size);
+
+	return size;
+}
+
+static int ramoops_pstore_write(enum pstore_type_id type,
+				enum kmsg_dump_reason reason,
+				u64 *id,
+				unsigned int part,
+				size_t size, struct pstore_info *psi)
+{
+	char *buf;
+	size_t res;
 	struct timeval timestamp;
+	struct ramoops_context *cxt = &oops_cxt;
+	size_t available = cxt->record_size;
 
+	/* Only store dmesg dumps. */
+	if (type != PSTORE_TYPE_DMESG)
+		return -EINVAL;
+
+	/* Only store crash dumps. */
 	if (reason != KMSG_DUMP_OOPS &&
 	    reason != KMSG_DUMP_PANIC &&
 	    reason != KMSG_DUMP_KEXEC)
-		return;
+		return -EINVAL;
 
-	/* Only dump oopses if dump_oops is set */
-	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
-		return;
+	/* Explicitly only take the first part of any new crash.
+	 * If our buffer is larger than kmsg_bytes, this can never happen,
+	 * and if our buffer is smaller than kmsg_bytes, we don't want the
+	 * report split across multiple records. */
+	if (part != 1)
+		return -ENOSPC;
 
 	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
-	buf_orig = buf;
 
-	memset(buf, '\0', cxt->record_size);
 	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
 	buf += res;
+	available -= res;
+
 	do_gettimeofday(&timestamp);
 	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
 	buf += res;
+	available -= res;
 
-	hdr_size = buf - buf_orig;
-	l2_cpy = min(l2, cxt->record_size - hdr_size);
-	l1_cpy = min(l1, cxt->record_size - hdr_size - l2_cpy);
+	if (size > available)
+		size = available;
 
-	s2_start = l2 - l2_cpy;
-	s1_start = l1 - l1_cpy;
-
-	memcpy(buf, s1 + s1_start, l1_cpy);
-	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
+	memcpy(buf, cxt->pstore.buf, size);
+	memset(buf + size, '\0', available - size);
 
 	cxt->count = (cxt->count + 1) % cxt->max_count;
+
+	return 0;
+}
+
+static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
+				struct pstore_info *psi)
+{
+	char *buf;
+	struct ramoops_context *cxt = &oops_cxt;
+
+	if (id >= cxt->max_count)
+		return -EINVAL;
+
+	buf = cxt->virt_addr + (id * cxt->record_size);
+	memset(buf, '\0', cxt->record_size);
+
+	return 0;
 }
 
 static int __init ramoops_probe(struct platform_device *pdev)
@@ -120,6 +204,12 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
 
+	/* Only a single ramoops area allowed at a time, so fail extra
+	 * probes.
+	 */
+	if (cxt->max_count)
+		goto fail3;
+
 	if (!pdata->mem_size || !pdata->record_size) {
 		pr_err("The memory size and the record size must be "
 			"non-zero\n");
@@ -147,7 +237,6 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
-	cxt->dump_oops = pdata->dump_oops;
 	/*
 	 * Update the module parameter variables as well so they are visible
 	 * through /sys/module/ramoops/parameters/
@@ -155,7 +244,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	mem_size = pdata->mem_size;
 	mem_address = pdata->mem_address;
 	record_size = pdata->record_size;
-	dump_oops = pdata->dump_oops;
+
+	cxt->pstore.bufsize = cxt->record_size;
+	cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
+	spin_lock_init(&cxt->pstore.buf_lock);
+	if (!cxt->pstore.buf) {
+		pr_err("cannot allocate pstore buffer\n");
+		goto fail4;
+	}
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region failed\n");
@@ -169,10 +265,9 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		goto fail2;
 	}
 
-	cxt->dump.dump = ramoops_do_dump;
-	err = kmsg_dump_register(&cxt->dump);
+	err = pstore_register(&cxt->pstore);
 	if (err) {
-		pr_err("registering kmsg dumper failed\n");
+		pr_err("registering with pstore failed\n");
 		goto fail1;
 	}
 
@@ -182,7 +277,11 @@ fail1:
 	iounmap(cxt->virt_addr);
 fail2:
 	release_mem_region(cxt->phys_addr, cxt->size);
+	cxt->max_count = 0;
 fail3:
+	kfree(cxt->pstore.buf);
+fail4:
+	cxt->pstore.bufsize = 0;
 	return err;
 }
 
@@ -190,11 +289,20 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 {
 	struct ramoops_context *cxt = &oops_cxt;
 
-	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		pr_warn("could not unregister kmsg_dumper\n");
+	/* TODO(kees): It shouldn't be possible to remove ramoops since
+	 * pstore doesn't support unregistering yet. When it does, remove
+	 * this early return and add the unregister where noted below.
+	 */
+	return -EBUSY;
 
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
+	cxt->max_count = 0;
+
+	/* TODO(kees): When pstore supports unregistering, call it here. */
+	kfree(cxt->pstore.buf);
+	cxt->pstore.bufsize = 0;
+
 	return 0;
 }
 
@@ -223,7 +331,6 @@ static int __init ramoops_init(void)
 		dummy_data->mem_size = mem_size;
 		dummy_data->mem_address = mem_address;
 		dummy_data->record_size = record_size;
-		dummy_data->dump_oops = dump_oops;
 		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
 			NULL, 0, dummy_data,
 			sizeof(struct ramoops_platform_data));
-- 
1.7.0.4

