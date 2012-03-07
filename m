Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030540Ab2CGV65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:58:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56955 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030466Ab2CGV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:51 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 06/13] android: ram_console: split out persistent ram
Date: Wed,  7 Mar 2012 13:58:16 -0800
Message-Id: <1331157503-3413-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-6148-0000-0000-000004138E0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Split ram_console into two halves.

persistent_ram is a set of apis that handle a block of memory
that does not get erased across a reboot.  It provides functions
to fill it as a single buffer or a ring buffer, and to extract
the old data after a reboot.  It handles ecc on the data to
correct bit errors introduced during reboot.

ram_console is now a small wrapper around persistent_ram that
feeds console data into the ringbuffer, and exports the old
data to /proc/last_kmsg after a reboot.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: I8c7495e3a6a3dd7cdf3cb067e1afceb3b6aaef3c
Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: Moved persistent_ram.h to staging dir]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig          |    6 +-
 drivers/staging/android/Makefile         |    1 +
 drivers/staging/android/persistent_ram.c |  302 +++++++++++++++++++++++++++++
 drivers/staging/android/persistent_ram.h |   52 +++++
 drivers/staging/android/ram_console.c    |  309 ++++--------------------------
 5 files changed, 396 insertions(+), 274 deletions(-)
 create mode 100644 drivers/staging/android/persistent_ram.c
 create mode 100644 drivers/staging/android/persistent_ram.h

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 3144ddb..3f7dbc5 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -25,15 +25,19 @@ config ANDROID_LOGGER
 	tristate "Android log driver"
 	default n
 
+config ANDROID_PERSISTENT_RAM
+	bool
+
 config ANDROID_RAM_CONSOLE
 	bool "Android RAM buffer console"
 	depends on !S390 && !UML
+	select ANDROID_PERSISTENT_RAM
 	default n
 
 menuconfig ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	bool "Android RAM Console Enable error correction"
 	default n
-	depends on ANDROID_RAM_CONSOLE
+	depends on ANDROID_PERSISTENT_RAM
 	select REED_SOLOMON
 	select REED_SOLOMON_ENC8
 	select REED_SOLOMON_DEC8
diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 785f269..9b6c9ed 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_ANDROID_BINDER_IPC)	+= binder.o
 obj-$(CONFIG_ASHMEM)			+= ashmem.o
 obj-$(CONFIG_ANDROID_LOGGER)		+= logger.o
+obj-$(CONFIG_ANDROID_PERSISTENT_RAM)	+= persistent_ram.o
 obj-$(CONFIG_ANDROID_RAM_CONSOLE)	+= ram_console.o
 obj-$(CONFIG_ANDROID_TIMED_OUTPUT)	+= timed_output.o
 obj-$(CONFIG_ANDROID_TIMED_GPIO)	+= timed_gpio.o
diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
new file mode 100644
index 0000000..d0f4666
--- /dev/null
+++ b/drivers/staging/android/persistent_ram.c
@@ -0,0 +1,302 @@
+/*
+ * Copyright (C) 2012 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include "persistent_ram.h"
+
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+#include <linux/rslib.h>
+#endif
+
+struct persistent_ram_buffer {
+	uint32_t    sig;
+	uint32_t    start;
+	uint32_t    size;
+	uint8_t     data[0];
+};
+
+#define PERSISTENT_RAM_SIG (0x43474244) /* DBGC */
+
+static LIST_HEAD(zone_list);
+
+#define ECC_BLOCK_SIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_DATA_SIZE
+#define ECC_SIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_ECC_SIZE
+#define ECC_SYMSIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE
+#define ECC_POLY CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_POLYNOMIAL
+
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+static void persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
+	uint8_t *data, size_t len, uint8_t *ecc)
+{
+	int i;
+	uint16_t par[ECC_SIZE];
+	/* Initialize the parity buffer */
+	memset(par, 0, sizeof(par));
+	encode_rs8(prz->rs_decoder, data, len, par, 0);
+	for (i = 0; i < ECC_SIZE; i++)
+		ecc[i] = par[i];
+}
+
+static int persistent_ram_decode_rs8(struct persistent_ram_zone *prz,
+	void *data, size_t len, uint8_t *ecc)
+{
+	int i;
+	uint16_t par[ECC_SIZE];
+	for (i = 0; i < ECC_SIZE; i++)
+		par[i] = ecc[i];
+	return decode_rs8(prz->rs_decoder, data, par, len,
+				NULL, 0, NULL, 0, NULL);
+}
+#endif
+
+static void persistent_ram_update(struct persistent_ram_zone *prz,
+	const void *s, unsigned int count)
+{
+	struct persistent_ram_buffer *buffer = prz->buffer;
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	uint8_t *buffer_end = buffer->data + prz->buffer_size;
+	uint8_t *block;
+	uint8_t *par;
+	int size = ECC_BLOCK_SIZE;
+#endif
+	memcpy(buffer->data + buffer->start, s, count);
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	block = buffer->data + (buffer->start & ~(ECC_BLOCK_SIZE - 1));
+	par = prz->par_buffer +
+	      (buffer->start / ECC_BLOCK_SIZE) * ECC_SIZE;
+	do {
+		if (block + ECC_BLOCK_SIZE > buffer_end)
+			size = buffer_end - block;
+		persistent_ram_encode_rs8(prz, block, size, par);
+		block += ECC_BLOCK_SIZE;
+		par += ECC_SIZE;
+	} while (block < buffer->data + buffer->start + count);
+#endif
+}
+
+static void persistent_ram_update_header(struct persistent_ram_zone *prz)
+{
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	struct persistent_ram_buffer *buffer = prz->buffer;
+
+	persistent_ram_encode_rs8(prz, (uint8_t *)buffer, sizeof(*buffer),
+				  prz->par_header);
+#endif
+}
+
+static void __init
+persistent_ram_save_old(struct persistent_ram_zone *prz)
+{
+	struct persistent_ram_buffer *buffer = prz->buffer;
+	size_t old_log_size = buffer->size;
+	char *dest;
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	uint8_t *block;
+	uint8_t *par;
+
+	block = buffer->data;
+	par = prz->par_buffer;
+	while (block < buffer->data + buffer->size) {
+		int numerr;
+		int size = ECC_BLOCK_SIZE;
+		if (block + size > buffer->data + prz->buffer_size)
+			size = buffer->data + prz->buffer_size - block;
+		numerr = persistent_ram_decode_rs8(prz, block, size, par);
+		if (numerr > 0) {
+#if 0
+			pr_info("persistent_ram: error in block %p, %d\n",
+			       block, numerr);
+#endif
+			prz->corrected_bytes += numerr;
+		} else if (numerr < 0) {
+#if 0
+			pr_info("persistent_ram: uncorrectable error in block %p\n",
+				block);
+#endif
+			prz->bad_blocks++;
+		}
+		block += ECC_BLOCK_SIZE;
+		par += ECC_SIZE;
+	}
+#endif
+
+	dest = kmalloc(old_log_size, GFP_KERNEL);
+	if (dest == NULL) {
+		pr_err("persistent_ram: failed to allocate buffer\n");
+		return;
+	}
+
+	prz->old_log = dest;
+	prz->old_log_size = old_log_size;
+	memcpy(prz->old_log,
+	       &buffer->data[buffer->start], buffer->size - buffer->start);
+	memcpy(prz->old_log + buffer->size - buffer->start,
+	       &buffer->data[0], buffer->start);
+}
+
+int persistent_ram_write(struct persistent_ram_zone *prz,
+	const void *s, unsigned int count)
+{
+	int rem;
+	int c = count;
+	struct persistent_ram_buffer *buffer = prz->buffer;
+
+	if (c > prz->buffer_size) {
+		s += c - prz->buffer_size;
+		c = prz->buffer_size;
+	}
+	rem = prz->buffer_size - buffer->start;
+	if (rem < c) {
+		persistent_ram_update(prz, s, rem);
+		s += rem;
+		c -= rem;
+		buffer->start = 0;
+		buffer->size = prz->buffer_size;
+	}
+	persistent_ram_update(prz, s, c);
+
+	buffer->start += c;
+	if (buffer->size < prz->buffer_size)
+		buffer->size += c;
+	persistent_ram_update_header(prz);
+
+	return count;
+}
+
+ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
+	char *str, size_t len)
+{
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	ssize_t ret;
+
+	if (prz->corrected_bytes || prz->bad_blocks)
+		ret = snprintf(str, len, ""
+			"\n%d Corrected bytes, %d unrecoverable blocks\n",
+			prz->corrected_bytes, prz->bad_blocks);
+	else
+		ret = snprintf(str, len, "\nNo errors detected\n");
+
+	return ret;
+#else
+	return 0;
+#endif
+}
+
+size_t persistent_ram_old_size(struct persistent_ram_zone *prz)
+{
+	return prz->old_log_size;
+}
+
+void *persistent_ram_old(struct persistent_ram_zone *prz)
+{
+	return prz->old_log;
+}
+
+void persistent_ram_free_old(struct persistent_ram_zone *prz)
+{
+	kfree(prz->old_log);
+	prz->old_log = NULL;
+	prz->old_log_size = 0;
+}
+
+static int __init __persistent_ram_init(struct persistent_ram_zone *prz,
+			       void __iomem *mem, size_t buffer_size)
+{
+	struct persistent_ram_buffer *buffer = mem;
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	int numerr;
+#endif
+
+	INIT_LIST_HEAD(&prz->node);
+
+	prz->buffer = buffer;
+	prz->buffer_size = buffer_size - sizeof(struct persistent_ram_buffer);
+
+	if (prz->buffer_size > buffer_size) {
+		pr_err("persistent_ram: buffer %p, invalid size %zu, datasize %zu\n",
+		       buffer, buffer_size, prz->buffer_size);
+		return -EINVAL;
+	}
+
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	prz->buffer_size -= (DIV_ROUND_UP(prz->buffer_size,
+						ECC_BLOCK_SIZE) + 1) * ECC_SIZE;
+
+	if (prz->buffer_size > buffer_size) {
+		pr_err("persistent_ram: buffer %p, invalid size %zu, non-ecc datasize %zu\n",
+		       buffer, buffer_size, prz->buffer_size);
+		return -EINVAL;
+	}
+
+	prz->par_buffer = buffer->data + prz->buffer_size;
+	prz->par_header = prz->par_buffer +
+		DIV_ROUND_UP(prz->buffer_size, ECC_BLOCK_SIZE) * ECC_SIZE;
+
+
+	/* first consecutive root is 0
+	 * primitive element to generate roots = 1
+	 */
+	prz->rs_decoder = init_rs(ECC_SYMSIZE, ECC_POLY, 0, 1, ECC_SIZE);
+	if (prz->rs_decoder == NULL) {
+		pr_info("persistent_ram: init_rs failed\n");
+		return -EINVAL;
+	}
+
+	prz->corrected_bytes = 0;
+	prz->bad_blocks = 0;
+
+	numerr = persistent_ram_decode_rs8(prz, buffer, sizeof(*buffer),
+					   prz->par_header);
+	if (numerr > 0) {
+		pr_info("persistent_ram: error in header, %d\n", numerr);
+		prz->corrected_bytes += numerr;
+	} else if (numerr < 0) {
+		pr_info("persistent_ram: uncorrectable error in header\n");
+		prz->bad_blocks++;
+	}
+#endif
+
+	if (buffer->sig == PERSISTENT_RAM_SIG) {
+		if (buffer->size > prz->buffer_size
+		    || buffer->start > buffer->size)
+			pr_info("persistent_ram: found existing invalid buffer, size %d, start %d\n",
+			       buffer->size, buffer->start);
+		else {
+			pr_info("persistent_ram: found existing buffer, size %d, start %d\n",
+			       buffer->size, buffer->start);
+			persistent_ram_save_old(prz);
+		}
+	} else {
+		pr_info("persistent_ram: no valid data in buffer (sig = 0x%08x)\n",
+			buffer->sig);
+	}
+
+	buffer->sig = PERSISTENT_RAM_SIG;
+	buffer->start = 0;
+	buffer->size = 0;
+
+	list_add_tail(&prz->node, &zone_list);
+
+	return 0;
+}
+
+int __init persistent_ram_init_ringbuffer(struct persistent_ram_zone *prz,
+			       void __iomem *mem, size_t buffer_size)
+{
+	return __persistent_ram_init(prz, mem, buffer_size);
+}
diff --git a/drivers/staging/android/persistent_ram.h b/drivers/staging/android/persistent_ram.h
new file mode 100644
index 0000000..f73fb08
--- /dev/null
+++ b/drivers/staging/android/persistent_ram.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __LINUX_PERSISTENT_RAM_H__
+#define __LINUX_PERSISTENT_RAM_H__
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+struct persistent_ram_buffer;
+
+struct persistent_ram_zone {
+	struct list_head node;
+	struct persistent_ram_buffer *buffer;
+	size_t buffer_size;
+#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+	char *par_buffer;
+	char *par_header;
+	struct rs_control *rs_decoder;
+	int corrected_bytes;
+	int bad_blocks;
+#endif
+	char *old_log;
+	size_t old_log_size;
+	size_t old_log_footer_size;
+	bool early;
+};
+
+int persistent_ram_init_ringbuffer(struct persistent_ram_zone *prz,
+	void __iomem *buffer, size_t buffer_size);
+
+int persistent_ram_write(struct persistent_ram_zone *prz, const void *s,
+	unsigned int count);
+
+size_t persistent_ram_old_size(struct persistent_ram_zone *prz);
+void *persistent_ram_old(struct persistent_ram_zone *prz);
+void persistent_ram_free_old(struct persistent_ram_zone *prz);
+ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
+	char *str, size_t len);
+
+#endif
diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index 73215e2..689c3dc 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -21,121 +21,18 @@
 #include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include "persistent_ram.h"
 #include "ram_console.h"
 
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-#include <linux/rslib.h>
-#endif
-
-struct ram_console_buffer {
-	uint32_t    sig;
-	uint32_t    start;
-	uint32_t    size;
-	uint8_t     data[0];
-};
-
-#define RAM_CONSOLE_SIG (0x43474244) /* DBGC */
-
-static char *ram_console_old_log;
-static size_t ram_console_old_log_size;
+static struct persistent_ram_zone ram_console_zone;
 static const char *bootinfo;
 static size_t bootinfo_size;
 
-static struct ram_console_buffer *ram_console_buffer;
-static size_t ram_console_buffer_size;
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-static char *ram_console_par_buffer;
-static struct rs_control *ram_console_rs_decoder;
-static int ram_console_corrected_bytes;
-static int ram_console_bad_blocks;
-#define ECC_BLOCK_SIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_DATA_SIZE
-#define ECC_SIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_ECC_SIZE
-#define ECC_SYMSIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE
-#define ECC_POLY CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_POLYNOMIAL
-#endif
-
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-static void ram_console_encode_rs8(uint8_t *data, size_t len, uint8_t *ecc)
-{
-	int i;
-	uint16_t par[ECC_SIZE];
-	/* Initialize the parity buffer */
-	memset(par, 0, sizeof(par));
-	encode_rs8(ram_console_rs_decoder, data, len, par, 0);
-	for (i = 0; i < ECC_SIZE; i++)
-		ecc[i] = par[i];
-}
-
-static int ram_console_decode_rs8(void *data, size_t len, uint8_t *ecc)
-{
-	int i;
-	uint16_t par[ECC_SIZE];
-	for (i = 0; i < ECC_SIZE; i++)
-		par[i] = ecc[i];
-	return decode_rs8(ram_console_rs_decoder, data, par, len,
-				NULL, 0, NULL, 0, NULL);
-}
-#endif
-
-static void ram_console_update(const char *s, unsigned int count)
-{
-	struct ram_console_buffer *buffer = ram_console_buffer;
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	uint8_t *buffer_end = buffer->data + ram_console_buffer_size;
-	uint8_t *block;
-	uint8_t *par;
-	int size = ECC_BLOCK_SIZE;
-#endif
-	memcpy(buffer->data + buffer->start, s, count);
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	block = buffer->data + (buffer->start & ~(ECC_BLOCK_SIZE - 1));
-	par = ram_console_par_buffer +
-	      (buffer->start / ECC_BLOCK_SIZE) * ECC_SIZE;
-	do {
-		if (block + ECC_BLOCK_SIZE > buffer_end)
-			size = buffer_end - block;
-		ram_console_encode_rs8(block, size, par);
-		block += ECC_BLOCK_SIZE;
-		par += ECC_SIZE;
-	} while (block < buffer->data + buffer->start + count);
-#endif
-}
-
-static void ram_console_update_header(void)
-{
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	struct ram_console_buffer *buffer = ram_console_buffer;
-	uint8_t *par;
-	par = ram_console_par_buffer +
-	      DIV_ROUND_UP(ram_console_buffer_size, ECC_BLOCK_SIZE) * ECC_SIZE;
-	ram_console_encode_rs8((uint8_t *)buffer, sizeof(*buffer), par);
-#endif
-}
-
 static void
 ram_console_write(struct console *console, const char *s, unsigned int count)
 {
-	int rem;
-	struct ram_console_buffer *buffer = ram_console_buffer;
-
-	if (count > ram_console_buffer_size) {
-		s += count - ram_console_buffer_size;
-		count = ram_console_buffer_size;
-	}
-	rem = ram_console_buffer_size - buffer->start;
-	if (rem < count) {
-		ram_console_update(s, rem);
-		s += rem;
-		count -= rem;
-		buffer->start = 0;
-		buffer->size = ram_console_buffer_size;
-	}
-	ram_console_update(s, count);
-
-	buffer->start += count;
-	if (buffer->size < ram_console_buffer_size)
-		buffer->size += count;
-	ram_console_update_header();
+	struct persistent_ram_zone *prz = console->data;
+	persistent_ram_write(prz, s, count);
 }
 
 static struct console ram_console = {
@@ -153,159 +50,6 @@ void ram_console_enable_console(int enabled)
 		ram_console.flags &= ~CON_ENABLED;
 }
 
-static void __init
-ram_console_save_old(struct ram_console_buffer *buffer, char *dest)
-{
-	size_t old_log_size = buffer->size;
-
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	uint8_t *block;
-	uint8_t *par;
-
-	block = buffer->data;
-	par = ram_console_par_buffer;
-	while (block < buffer->data + buffer->size) {
-		int numerr;
-		int size = ECC_BLOCK_SIZE;
-		if (block + size > buffer->data + ram_console_buffer_size)
-			size = buffer->data + ram_console_buffer_size - block;
-		numerr = ram_console_decode_rs8(block, size, par);
-		if (numerr > 0) {
-#if 0
-			printk(KERN_INFO "ram_console: error in block %p, %d\n",
-			       block, numerr);
-#endif
-			ram_console_corrected_bytes += numerr;
-		} else if (numerr < 0) {
-#if 0
-			printk(KERN_INFO "ram_console: uncorrectable error in "
-			       "block %p\n", block);
-#endif
-			ram_console_bad_blocks++;
-		}
-		block += ECC_BLOCK_SIZE;
-		par += ECC_SIZE;
-	}
-#endif
-
-	if (dest == NULL) {
-		dest = kmalloc(old_log_size, GFP_KERNEL);
-		if (dest == NULL) {
-			printk(KERN_ERR
-			       "ram_console: failed to allocate buffer\n");
-			return;
-		}
-	}
-
-	ram_console_old_log = dest;
-	ram_console_old_log_size = old_log_size;
-	memcpy(ram_console_old_log,
-	       &buffer->data[buffer->start], buffer->size - buffer->start);
-	memcpy(ram_console_old_log + buffer->size - buffer->start,
-	       &buffer->data[0], buffer->start);
-}
-
-static int __init ram_console_init(struct ram_console_buffer *buffer,
-				   size_t buffer_size, char *old_buf)
-{
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	int numerr;
-	uint8_t *par;
-#endif
-	ram_console_buffer = buffer;
-	ram_console_buffer_size =
-		buffer_size - sizeof(struct ram_console_buffer);
-
-	if (ram_console_buffer_size > buffer_size) {
-		pr_err("ram_console: buffer %p, invalid size %zu, "
-		       "datasize %zu\n", buffer, buffer_size,
-		       ram_console_buffer_size);
-		return 0;
-	}
-
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	ram_console_buffer_size -= (DIV_ROUND_UP(ram_console_buffer_size,
-						ECC_BLOCK_SIZE) + 1) * ECC_SIZE;
-
-	if (ram_console_buffer_size > buffer_size) {
-		pr_err("ram_console: buffer %p, invalid size %zu, "
-		       "non-ecc datasize %zu\n",
-		       buffer, buffer_size, ram_console_buffer_size);
-		return 0;
-	}
-
-	ram_console_par_buffer = buffer->data + ram_console_buffer_size;
-
-
-	/* first consecutive root is 0
-	 * primitive element to generate roots = 1
-	 */
-	ram_console_rs_decoder = init_rs(ECC_SYMSIZE, ECC_POLY, 0, 1, ECC_SIZE);
-	if (ram_console_rs_decoder == NULL) {
-		printk(KERN_INFO "ram_console: init_rs failed\n");
-		return 0;
-	}
-
-	ram_console_corrected_bytes = 0;
-	ram_console_bad_blocks = 0;
-
-	par = ram_console_par_buffer +
-	      DIV_ROUND_UP(ram_console_buffer_size, ECC_BLOCK_SIZE) * ECC_SIZE;
-
-	numerr = ram_console_decode_rs8(buffer, sizeof(*buffer), par);
-	if (numerr > 0) {
-		printk(KERN_INFO "ram_console: error in header, %d\n", numerr);
-		ram_console_corrected_bytes += numerr;
-	} else if (numerr < 0) {
-		printk(KERN_INFO
-		       "ram_console: uncorrectable error in header\n");
-		ram_console_bad_blocks++;
-	}
-#endif
-
-	if (buffer->sig == RAM_CONSOLE_SIG) {
-		if (buffer->size > ram_console_buffer_size
-		    || buffer->start > buffer->size)
-			printk(KERN_INFO "ram_console: found existing invalid "
-			       "buffer, size %d, start %d\n",
-			       buffer->size, buffer->start);
-		else {
-			printk(KERN_INFO "ram_console: found existing buffer, "
-			       "size %d, start %d\n",
-			       buffer->size, buffer->start);
-			ram_console_save_old(buffer, old_buf);
-		}
-	} else {
-		printk(KERN_INFO "ram_console: no valid data in buffer "
-		       "(sig = 0x%08x)\n", buffer->sig);
-	}
-
-	buffer->sig = RAM_CONSOLE_SIG;
-	buffer->start = 0;
-	buffer->size = 0;
-
-	register_console(&ram_console);
-	return 0;
-}
-
-static ssize_t ram_console_ecc_string(char *str, size_t len)
-{
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	ssize_t ret;
-
-	if (ram_console_corrected_bytes || ram_console_bad_blocks)
-		ret = snprintf(str, len, ""
-			"\n%d Corrected bytes, %d unrecoverable blocks\n",
-			ram_console_corrected_bytes, ram_console_bad_blocks);
-	else
-		ret = snprintf(str, len, "\nNo errors detected\n");
-
-	return ret;
-#else
-	return 0;
-#endif
-}
-
 static int ram_console_driver_probe(struct platform_device *pdev)
 {
 	struct resource *res = pdev->resource;
@@ -313,6 +57,7 @@ static int ram_console_driver_probe(struct platform_device *pdev)
 	size_t buffer_size;
 	void *buffer;
 	struct ram_console_platform_data *pdata = pdev->dev.platform_data;
+	int ret;
 
 	if (res == NULL || pdev->num_resources != 1 ||
 	    !(res->flags & IORESOURCE_MEM)) {
@@ -330,13 +75,25 @@ static int ram_console_driver_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	ret = persistent_ram_init_ringbuffer(&ram_console_zone, buffer,
+					     buffer_size);
+	if (ret)
+		goto err;
+
 	if (pdata) {
 		bootinfo = kstrdup(pdata->bootinfo, GFP_KERNEL);
 		if (bootinfo)
 			bootinfo_size = strlen(bootinfo);
 	}
 
-	return ram_console_init(buffer, buffer_size, NULL/* allocate */);
+	ram_console.data = &ram_console_zone;
+
+	register_console(&ram_console);
+	return 0;
+
+err:
+	iounmap(buffer);
+	return ret;
 }
 
 static struct platform_driver ram_console_driver = {
@@ -358,25 +115,28 @@ static ssize_t ram_console_read_old(struct file *file, char __user *buf,
 {
 	loff_t pos = *offset;
 	ssize_t count;
+	struct persistent_ram_zone *prz = &ram_console_zone;
+	size_t old_log_size = persistent_ram_old_size(prz);
+	const char *old_log = persistent_ram_old(prz);
 	char *str;
 	int ret;
 
 	/* Main last_kmsg log */
-	if (pos < ram_console_old_log_size) {
-		count = min(len, (size_t)(ram_console_old_log_size - pos));
-		if (copy_to_user(buf, ram_console_old_log + pos, count))
+	if (pos < old_log_size) {
+		count = min(len, (size_t)(old_log_size - pos));
+		if (copy_to_user(buf, old_log + pos, count))
 			return -EFAULT;
 		goto out;
 	}
 
 	/* ECC correction notice */
-	pos -= ram_console_old_log_size;
-	count = ram_console_ecc_string(NULL, 0);
+	pos -= old_log_size;
+	count = persistent_ram_ecc_string(prz, NULL, 0);
 	if (pos < count) {
 		str = kmalloc(count, GFP_KERNEL);
 		if (!str)
 			return -ENOMEM;
-		ram_console_ecc_string(str, count + 1);
+		persistent_ram_ecc_string(prz, str, count + 1);
 		count = min(len, (size_t)(count - pos));
 		ret = copy_to_user(buf, str + pos, count);
 		kfree(str);
@@ -410,22 +170,25 @@ static const struct file_operations ram_console_file_ops = {
 static int __init ram_console_late_init(void)
 {
 	struct proc_dir_entry *entry;
+	struct persistent_ram_zone *prz = &ram_console_zone;
 
-	if (ram_console_old_log == NULL)
+	if (persistent_ram_old_size(prz) == 0)
 		return 0;
+
 	entry = create_proc_entry("last_kmsg", S_IFREG | S_IRUGO, NULL);
 	if (!entry) {
 		printk(KERN_ERR "ram_console: failed to create proc entry\n");
-		kfree(ram_console_old_log);
-		ram_console_old_log = NULL;
+		persistent_ram_free_old(prz);
 		return 0;
 	}
 
 	entry->proc_fops = &ram_console_file_ops;
-	entry->size = ram_console_old_log_size;
+	entry->size = persistent_ram_old_size(prz) +
+		persistent_ram_ecc_string(prz, NULL, 0) +
+		bootinfo_size;
+
 	return 0;
 }
 
-postcore_initcall(ram_console_module_init);
 late_initcall(ram_console_late_init);
-
+postcore_initcall(ram_console_module_init);
-- 
1.7.3.2.146.gca209

