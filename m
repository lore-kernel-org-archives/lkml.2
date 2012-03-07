Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2CGWAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:00:49 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56872 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab2CGV6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:41 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 07/13] android: persistent_ram: refactor ecc support
Date: Wed,  7 Mar 2012 13:58:17 -0800
Message-Id: <1331157503-3413-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-6148-0000-0000-000004138DCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Remove CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION and related
 #ifdefs.  Also allow persistent ram zones without ecc enabled.
For some use cases, like the data portion of the upcoming
persistent_vars patches, or a persistent ftrace ringbuffer,
ecc on every update is too expensive.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: Ia710344b6c54fe252e0a87353955e063b3c054ab
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig          |   37 +-----
 drivers/staging/android/persistent_ram.c |  239 ++++++++++++++++--------------
 drivers/staging/android/persistent_ram.h |   12 +-
 drivers/staging/android/ram_console.c    |    2 +-
 4 files changed, 143 insertions(+), 147 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 3f7dbc5..08a3b11 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -27,6 +27,9 @@ config ANDROID_LOGGER
 
 config ANDROID_PERSISTENT_RAM
 	bool
+	select REED_SOLOMON
+	select REED_SOLOMON_ENC8
+	select REED_SOLOMON_DEC8
 
 config ANDROID_RAM_CONSOLE
 	bool "Android RAM buffer console"
@@ -34,40 +37,6 @@ config ANDROID_RAM_CONSOLE
 	select ANDROID_PERSISTENT_RAM
 	default n
 
-menuconfig ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	bool "Android RAM Console Enable error correction"
-	default n
-	depends on ANDROID_PERSISTENT_RAM
-	select REED_SOLOMON
-	select REED_SOLOMON_ENC8
-	select REED_SOLOMON_DEC8
-
-if ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-
-config ANDROID_RAM_CONSOLE_ERROR_CORRECTION_DATA_SIZE
-	int "Android RAM Console Data data size"
-	default 128
-	help
-	  Must be a power of 2.
-
-config ANDROID_RAM_CONSOLE_ERROR_CORRECTION_ECC_SIZE
-	int "Android RAM Console ECC size"
-	default 16
-
-config ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE
-	int "Android RAM Console Symbol size"
-	default 8
-
-config ANDROID_RAM_CONSOLE_ERROR_CORRECTION_POLYNOMIAL
-	hex "Android RAM Console Polynomial"
-	default 0x19 if (ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE = 4)
-	default 0x29 if (ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE = 5)
-	default 0x61 if (ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE = 6)
-	default 0x89 if (ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE = 7)
-	default 0x11d if (ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE = 8)
-
-endif # ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-
 config ANDROID_TIMED_OUTPUT
 	bool "Timed output class driver"
 	default y
diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index d0f4666..35c57a0 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -16,13 +16,10 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/rslib.h>
 #include <linux/slab.h>
 #include "persistent_ram.h"
 
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-#include <linux/rslib.h>
-#endif
-
 struct persistent_ram_buffer {
 	uint32_t    sig;
 	uint32_t    start;
@@ -34,21 +31,16 @@ struct persistent_ram_buffer {
 
 static LIST_HEAD(zone_list);
 
-#define ECC_BLOCK_SIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_DATA_SIZE
-#define ECC_SIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_ECC_SIZE
-#define ECC_SYMSIZE CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_SYMBOL_SIZE
-#define ECC_POLY CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION_POLYNOMIAL
-
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 static void persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
 	uint8_t *data, size_t len, uint8_t *ecc)
 {
 	int i;
-	uint16_t par[ECC_SIZE];
+	uint16_t par[prz->ecc_size];
+
 	/* Initialize the parity buffer */
 	memset(par, 0, sizeof(par));
 	encode_rs8(prz->rs_decoder, data, len, par, 0);
-	for (i = 0; i < ECC_SIZE; i++)
+	for (i = 0; i < prz->ecc_size; i++)
 		ecc[i] = par[i];
 }
 
@@ -56,84 +48,167 @@ static int persistent_ram_decode_rs8(struct persistent_ram_zone *prz,
 	void *data, size_t len, uint8_t *ecc)
 {
 	int i;
-	uint16_t par[ECC_SIZE];
-	for (i = 0; i < ECC_SIZE; i++)
+	uint16_t par[prz->ecc_size];
+
+	for (i = 0; i < prz->ecc_size; i++)
 		par[i] = ecc[i];
 	return decode_rs8(prz->rs_decoder, data, par, len,
 				NULL, 0, NULL, 0, NULL);
 }
-#endif
 
-static void persistent_ram_update(struct persistent_ram_zone *prz,
-	const void *s, unsigned int count)
+static void persistent_ram_update_ecc(struct persistent_ram_zone *prz,
+	unsigned int count)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	uint8_t *buffer_end = buffer->data + prz->buffer_size;
 	uint8_t *block;
 	uint8_t *par;
-	int size = ECC_BLOCK_SIZE;
-#endif
-	memcpy(buffer->data + buffer->start, s, count);
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	block = buffer->data + (buffer->start & ~(ECC_BLOCK_SIZE - 1));
+	int ecc_block_size = prz->ecc_block_size;
+	int ecc_size = prz->ecc_size;
+	int size = prz->ecc_block_size;
+
+	if (!prz->ecc)
+		return;
+
+	block = buffer->data + (buffer->start & ~(ecc_block_size - 1));
 	par = prz->par_buffer +
-	      (buffer->start / ECC_BLOCK_SIZE) * ECC_SIZE;
+	      (buffer->start / ecc_block_size) * prz->ecc_size;
 	do {
-		if (block + ECC_BLOCK_SIZE > buffer_end)
+		if (block + ecc_block_size > buffer_end)
 			size = buffer_end - block;
 		persistent_ram_encode_rs8(prz, block, size, par);
-		block += ECC_BLOCK_SIZE;
-		par += ECC_SIZE;
+		block += ecc_block_size;
+		par += ecc_size;
 	} while (block < buffer->data + buffer->start + count);
-#endif
 }
 
-static void persistent_ram_update_header(struct persistent_ram_zone *prz)
+static void persistent_ram_update_header_ecc(struct persistent_ram_zone *prz)
 {
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	struct persistent_ram_buffer *buffer = prz->buffer;
 
+	if (!prz->ecc)
+		return;
+
 	persistent_ram_encode_rs8(prz, (uint8_t *)buffer, sizeof(*buffer),
 				  prz->par_header);
-#endif
 }
 
-static void __init
-persistent_ram_save_old(struct persistent_ram_zone *prz)
+static void persistent_ram_ecc_old(struct persistent_ram_zone *prz)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
-	size_t old_log_size = buffer->size;
-	char *dest;
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	uint8_t *block;
 	uint8_t *par;
 
+	if (!prz->ecc)
+		return;
+
 	block = buffer->data;
 	par = prz->par_buffer;
 	while (block < buffer->data + buffer->size) {
 		int numerr;
-		int size = ECC_BLOCK_SIZE;
+		int size = prz->ecc_block_size;
 		if (block + size > buffer->data + prz->buffer_size)
 			size = buffer->data + prz->buffer_size - block;
 		numerr = persistent_ram_decode_rs8(prz, block, size, par);
 		if (numerr > 0) {
-#if 0
-			pr_info("persistent_ram: error in block %p, %d\n",
+			pr_devel("persistent_ram: error in block %p, %d\n",
 			       block, numerr);
-#endif
 			prz->corrected_bytes += numerr;
 		} else if (numerr < 0) {
-#if 0
-			pr_info("persistent_ram: uncorrectable error in block %p\n",
+			pr_devel("persistent_ram: uncorrectable error in block %p\n",
 				block);
-#endif
 			prz->bad_blocks++;
 		}
-		block += ECC_BLOCK_SIZE;
-		par += ECC_SIZE;
+		block += prz->ecc_block_size;
+		par += prz->ecc_size;
+	}
+}
+
+static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
+	size_t buffer_size)
+{
+	int numerr;
+	struct persistent_ram_buffer *buffer = prz->buffer;
+	int ecc_blocks;
+
+	if (!prz->ecc)
+		return 0;
+
+	prz->ecc_block_size = 128;
+	prz->ecc_size = 16;
+	prz->ecc_symsize = 8;
+	prz->ecc_poly = 0x11d;
+
+	ecc_blocks = DIV_ROUND_UP(prz->buffer_size, prz->ecc_block_size);
+	prz->buffer_size -= (ecc_blocks + 1) * prz->ecc_size;
+
+	if (prz->buffer_size > buffer_size) {
+		pr_err("persistent_ram: invalid size %zu, non-ecc datasize %zu\n",
+		       buffer_size, prz->buffer_size);
+		return -EINVAL;
+	}
+
+	prz->par_buffer = buffer->data + prz->buffer_size;
+	prz->par_header = prz->par_buffer + ecc_blocks * prz->ecc_size;
+
+	/*
+	 * first consecutive root is 0
+	 * primitive element to generate roots = 1
+	 */
+	prz->rs_decoder = init_rs(prz->ecc_symsize, prz->ecc_poly, 0, 1,
+				  prz->ecc_size);
+	if (prz->rs_decoder == NULL) {
+		pr_info("persistent_ram: init_rs failed\n");
+		return -EINVAL;
 	}
-#endif
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
+
+	return 0;
+}
+
+ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
+	char *str, size_t len)
+{
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
+}
+
+static void persistent_ram_update(struct persistent_ram_zone *prz,
+	const void *s, unsigned int count)
+{
+	struct persistent_ram_buffer *buffer = prz->buffer;
+	memcpy(buffer->data + buffer->start, s, count);
+	persistent_ram_update_ecc(prz, count);
+}
+
+static void __init
+persistent_ram_save_old(struct persistent_ram_zone *prz)
+{
+	struct persistent_ram_buffer *buffer = prz->buffer;
+	size_t old_log_size = buffer->size;
+	char *dest;
+
+	persistent_ram_ecc_old(prz);
 
 	dest = kmalloc(old_log_size, GFP_KERNEL);
 	if (dest == NULL) {
@@ -173,30 +248,11 @@ int persistent_ram_write(struct persistent_ram_zone *prz,
 	buffer->start += c;
 	if (buffer->size < prz->buffer_size)
 		buffer->size += c;
-	persistent_ram_update_header(prz);
+	persistent_ram_update_header_ecc(prz);
 
 	return count;
 }
 
-ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
-	char *str, size_t len)
-{
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	ssize_t ret;
-
-	if (prz->corrected_bytes || prz->bad_blocks)
-		ret = snprintf(str, len, ""
-			"\n%d Corrected bytes, %d unrecoverable blocks\n",
-			prz->corrected_bytes, prz->bad_blocks);
-	else
-		ret = snprintf(str, len, "\nNo errors detected\n");
-
-	return ret;
-#else
-	return 0;
-#endif
-}
-
 size_t persistent_ram_old_size(struct persistent_ram_zone *prz)
 {
 	return prz->old_log_size;
@@ -215,12 +271,10 @@ void persistent_ram_free_old(struct persistent_ram_zone *prz)
 }
 
 static int __init __persistent_ram_init(struct persistent_ram_zone *prz,
-			       void __iomem *mem, size_t buffer_size)
+			       void __iomem *mem, size_t buffer_size, bool ecc)
 {
 	struct persistent_ram_buffer *buffer = mem;
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	int numerr;
-#endif
+	int ret;
 
 	INIT_LIST_HEAD(&prz->node);
 
@@ -233,43 +287,10 @@ static int __init __persistent_ram_init(struct persistent_ram_zone *prz,
 		return -EINVAL;
 	}
 
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
-	prz->buffer_size -= (DIV_ROUND_UP(prz->buffer_size,
-						ECC_BLOCK_SIZE) + 1) * ECC_SIZE;
-
-	if (prz->buffer_size > buffer_size) {
-		pr_err("persistent_ram: buffer %p, invalid size %zu, non-ecc datasize %zu\n",
-		       buffer, buffer_size, prz->buffer_size);
-		return -EINVAL;
-	}
-
-	prz->par_buffer = buffer->data + prz->buffer_size;
-	prz->par_header = prz->par_buffer +
-		DIV_ROUND_UP(prz->buffer_size, ECC_BLOCK_SIZE) * ECC_SIZE;
-
-
-	/* first consecutive root is 0
-	 * primitive element to generate roots = 1
-	 */
-	prz->rs_decoder = init_rs(ECC_SYMSIZE, ECC_POLY, 0, 1, ECC_SIZE);
-	if (prz->rs_decoder == NULL) {
-		pr_info("persistent_ram: init_rs failed\n");
-		return -EINVAL;
-	}
-
-	prz->corrected_bytes = 0;
-	prz->bad_blocks = 0;
-
-	numerr = persistent_ram_decode_rs8(prz, buffer, sizeof(*buffer),
-					   prz->par_header);
-	if (numerr > 0) {
-		pr_info("persistent_ram: error in header, %d\n", numerr);
-		prz->corrected_bytes += numerr;
-	} else if (numerr < 0) {
-		pr_info("persistent_ram: uncorrectable error in header\n");
-		prz->bad_blocks++;
-	}
-#endif
+	prz->ecc = ecc;
+	ret = persistent_ram_init_ecc(prz, buffer_size);
+	if (ret)
+		return ret;
 
 	if (buffer->sig == PERSISTENT_RAM_SIG) {
 		if (buffer->size > prz->buffer_size
@@ -296,7 +317,7 @@ static int __init __persistent_ram_init(struct persistent_ram_zone *prz,
 }
 
 int __init persistent_ram_init_ringbuffer(struct persistent_ram_zone *prz,
-			       void __iomem *mem, size_t buffer_size)
+			       void __iomem *mem, size_t buffer_size, bool ecc)
 {
-	return __persistent_ram_init(prz, mem, buffer_size);
+	return __persistent_ram_init(prz, mem, buffer_size, true);
 }
diff --git a/drivers/staging/android/persistent_ram.h b/drivers/staging/android/persistent_ram.h
index f73fb08..ab3995c 100644
--- a/drivers/staging/android/persistent_ram.h
+++ b/drivers/staging/android/persistent_ram.h
@@ -24,13 +24,19 @@ struct persistent_ram_zone {
 	struct list_head node;
 	struct persistent_ram_buffer *buffer;
 	size_t buffer_size;
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
+
+	/* ECC correction */
+	bool ecc;
 	char *par_buffer;
 	char *par_header;
 	struct rs_control *rs_decoder;
 	int corrected_bytes;
 	int bad_blocks;
-#endif
+	int ecc_block_size;
+	int ecc_size;
+	int ecc_symsize;
+	int ecc_poly;
+
 	char *old_log;
 	size_t old_log_size;
 	size_t old_log_footer_size;
@@ -38,7 +44,7 @@ struct persistent_ram_zone {
 };
 
 int persistent_ram_init_ringbuffer(struct persistent_ram_zone *prz,
-	void __iomem *buffer, size_t buffer_size);
+	void __iomem *buffer, size_t buffer_size, bool ecc);
 
 int persistent_ram_write(struct persistent_ram_zone *prz, const void *s,
 	unsigned int count);
diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index 689c3dc..d920bd7 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -76,7 +76,7 @@ static int ram_console_driver_probe(struct platform_device *pdev)
 	}
 
 	ret = persistent_ram_init_ringbuffer(&ram_console_zone, buffer,
-					     buffer_size);
+					     buffer_size, true);
 	if (ret)
 		goto err;
 
-- 
1.7.3.2.146.gca209

