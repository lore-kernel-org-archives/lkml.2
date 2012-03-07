Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242Ab2CGWAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:00:42 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51064 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758495Ab2CGV6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:42 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 09/13] android: persistent_ram: make persistent_ram_write atomic
Date: Wed,  7 Mar 2012 13:58:19 -0800
Message-Id: <1331157503-3413-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-7182-0000-0000-000000FDF951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Allow persistent_ram_write to be called on multiple cpus at
the same time, as long as ecc is not in use.  Uses atomics
for the buffer->start and buffer->size counters.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: I49b70ec3bc7a651e6ed8e54b6f8f530babde680a
Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: Fix up some pr_info casting issues on 64bit]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/persistent_ram.c |  140 +++++++++++++++++++++--------
 1 files changed, 101 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index 81950e6..3eb2fb4 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -27,8 +27,8 @@
 
 struct persistent_ram_buffer {
 	uint32_t    sig;
-	uint32_t    start;
-	uint32_t    size;
+	atomic_t    start;
+	atomic_t    size;
 	uint8_t     data[0];
 };
 
@@ -36,6 +36,66 @@ struct persistent_ram_buffer {
 
 static __initdata LIST_HEAD(persistent_ram_list);
 
+static inline size_t buffer_size(struct persistent_ram_zone *prz)
+{
+	return atomic_read(&prz->buffer->size);
+}
+
+static inline size_t buffer_start(struct persistent_ram_zone *prz)
+{
+	return atomic_read(&prz->buffer->start);
+}
+
+/* increase and wrap the start pointer, returning the old value */
+static inline size_t buffer_start_add(struct persistent_ram_zone *prz, size_t a)
+{
+	int old;
+	int new;
+
+	do {
+		old = atomic_read(&prz->buffer->start);
+		new = old + a;
+		while (unlikely(new > prz->buffer_size))
+			new -= prz->buffer_size;
+	} while (atomic_cmpxchg(&prz->buffer->start, old, new) != old);
+
+	return old;
+}
+
+/* increase the size counter until it hits the max size */
+static inline void buffer_size_add(struct persistent_ram_zone *prz, size_t a)
+{
+	size_t old;
+	size_t new;
+
+	if (atomic_read(&prz->buffer->size) == prz->buffer_size)
+		return;
+
+	do {
+		old = atomic_read(&prz->buffer->size);
+		new = old + a;
+		if (new > prz->buffer_size)
+			new = prz->buffer_size;
+	} while (atomic_cmpxchg(&prz->buffer->size, old, new) != old);
+}
+
+/* increase the size counter, retuning an error if it hits the max size */
+static inline ssize_t buffer_size_add_clamp(struct persistent_ram_zone *prz,
+	size_t a)
+{
+	size_t old;
+	size_t new;
+
+	do {
+		old = atomic_read(&prz->buffer->size);
+		new = old + a;
+		if (new > prz->buffer_size)
+			return -ENOMEM;
+	} while (atomic_cmpxchg(&prz->buffer->size, old, new) != old);
+
+	return 0;
+}
+
 static void persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
 	uint8_t *data, size_t len, uint8_t *ecc)
 {
@@ -62,7 +122,7 @@ static int persistent_ram_decode_rs8(struct persistent_ram_zone *prz,
 }
 
 static void persistent_ram_update_ecc(struct persistent_ram_zone *prz,
-	unsigned int count)
+	unsigned int start, unsigned int count)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
 	uint8_t *buffer_end = buffer->data + prz->buffer_size;
@@ -75,16 +135,16 @@ static void persistent_ram_update_ecc(struct persistent_ram_zone *prz,
 	if (!prz->ecc)
 		return;
 
-	block = buffer->data + (buffer->start & ~(ecc_block_size - 1));
-	par = prz->par_buffer +
-	      (buffer->start / ecc_block_size) * prz->ecc_size;
+	block = buffer->data + (start & ~(ecc_block_size - 1));
+	par = prz->par_buffer + (start / ecc_block_size) * prz->ecc_size;
+
 	do {
 		if (block + ecc_block_size > buffer_end)
 			size = buffer_end - block;
 		persistent_ram_encode_rs8(prz, block, size, par);
 		block += ecc_block_size;
 		par += ecc_size;
-	} while (block < buffer->data + buffer->start + count);
+	} while (block < buffer->data + start + count);
 }
 
 static void persistent_ram_update_header_ecc(struct persistent_ram_zone *prz)
@@ -109,7 +169,7 @@ static void persistent_ram_ecc_old(struct persistent_ram_zone *prz)
 
 	block = buffer->data;
 	par = prz->par_buffer;
-	while (block < buffer->data + buffer->size) {
+	while (block < buffer->data + buffer_size(prz)) {
 		int numerr;
 		int size = prz->ecc_block_size;
 		if (block + size > buffer->data + prz->buffer_size)
@@ -199,34 +259,33 @@ ssize_t persistent_ram_ecc_string(struct persistent_ram_zone *prz,
 }
 
 static void persistent_ram_update(struct persistent_ram_zone *prz,
-	const void *s, unsigned int count)
+	const void *s, unsigned int start, unsigned int count)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
-	memcpy(buffer->data + buffer->start, s, count);
-	persistent_ram_update_ecc(prz, count);
+	memcpy(buffer->data + start, s, count);
+	persistent_ram_update_ecc(prz, start, count);
 }
 
 static void __init
 persistent_ram_save_old(struct persistent_ram_zone *prz)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
-	size_t old_log_size = buffer->size;
+	size_t size = buffer_size(prz);
+	size_t start = buffer_start(prz);
 	char *dest;
 
 	persistent_ram_ecc_old(prz);
 
-	dest = kmalloc(old_log_size, GFP_KERNEL);
+	dest = kmalloc(size, GFP_KERNEL);
 	if (dest == NULL) {
 		pr_err("persistent_ram: failed to allocate buffer\n");
 		return;
 	}
 
 	prz->old_log = dest;
-	prz->old_log_size = old_log_size;
-	memcpy(prz->old_log,
-	       &buffer->data[buffer->start], buffer->size - buffer->start);
-	memcpy(prz->old_log + buffer->size - buffer->start,
-	       &buffer->data[0], buffer->start);
+	prz->old_log_size = size;
+	memcpy(prz->old_log, &buffer->data[start], size - start);
+	memcpy(prz->old_log + size - start, &buffer->data[0], start);
 }
 
 int persistent_ram_write(struct persistent_ram_zone *prz,
@@ -234,25 +293,26 @@ int persistent_ram_write(struct persistent_ram_zone *prz,
 {
 	int rem;
 	int c = count;
-	struct persistent_ram_buffer *buffer = prz->buffer;
+	size_t start;
 
-	if (c > prz->buffer_size) {
+	if (unlikely(c > prz->buffer_size)) {
 		s += c - prz->buffer_size;
 		c = prz->buffer_size;
 	}
-	rem = prz->buffer_size - buffer->start;
-	if (rem < c) {
-		persistent_ram_update(prz, s, rem);
+
+	buffer_size_add_clamp(prz, c);
+
+	start = buffer_start_add(prz, c);
+
+	rem = prz->buffer_size - start;
+	if (unlikely(rem < c)) {
+		persistent_ram_update(prz, s, start, rem);
 		s += rem;
 		c -= rem;
-		buffer->start = 0;
-		buffer->size = prz->buffer_size;
+		start = 0;
 	}
-	persistent_ram_update(prz, s, c);
+	persistent_ram_update(prz, s, start, c);
 
-	buffer->start += c;
-	if (buffer->size < prz->buffer_size)
-		buffer->size += c;
 	persistent_ram_update_header_ecc(prz);
 
 	return count;
@@ -361,23 +421,25 @@ struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
 		return ERR_PTR(ret);
 
 	if (prz->buffer->sig == PERSISTENT_RAM_SIG) {
-		if (prz->buffer->size > prz->buffer_size
-		    || prz->buffer->start > prz->buffer->size)
-			pr_info("persistent_ram: found existing invalid buffer, size %d, start %d\n",
-			       prz->buffer->size, prz->buffer->start);
+		if (buffer_size(prz) > prz->buffer_size ||
+		    buffer_start(prz) > buffer_size(prz))
+			pr_info("persistent_ram: found existing invalid buffer,"
+				" size %ld, start %ld\n",
+			       buffer_size(prz), buffer_start(prz));
 		else {
-			pr_info("persistent_ram: found existing buffer, size %d, start %d\n",
-			       prz->buffer->size, prz->buffer->start);
+			pr_info("persistent_ram: found existing buffer,"
+				" size %ld, start %ld\n",
+			       buffer_size(prz), buffer_start(prz));
 			persistent_ram_save_old(prz);
 		}
 	} else {
-		pr_info("persistent_ram: no valid data in buffer (sig = 0x%08x)\n",
-			prz->buffer->sig);
+		pr_info("persistent_ram: no valid data in buffer"
+			" (sig = 0x%08x)\n", prz->buffer->sig);
 	}
 
 	prz->buffer->sig = PERSISTENT_RAM_SIG;
-	prz->buffer->start = 0;
-	prz->buffer->size = 0;
+	atomic_set(&prz->buffer->start, 0);
+	atomic_set(&prz->buffer->size, 0);
 
 	return prz;
 }
-- 
1.7.3.2.146.gca209

