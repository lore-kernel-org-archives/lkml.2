Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab0KXTyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:54:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48622 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756364Ab0KXTyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:54:12 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 03/12] sep: handle the memrar stuff in the headers
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:33:55 +0000
Message-ID: <20101124193353.16425.26546.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/memrar/memrar.h         |   19 ++++
 drivers/staging/sep/sep_driver.c        |    2 
 drivers/staging/sep/sep_driver_config.h |  133 -------------------------------
 3 files changed, 21 insertions(+), 133 deletions(-)


diff --git a/drivers/staging/memrar/memrar.h b/drivers/staging/memrar/memrar.h
index 0b735b8..0feb73b 100644
--- a/drivers/staging/memrar/memrar.h
+++ b/drivers/staging/memrar/memrar.h
@@ -95,6 +95,7 @@ struct RAR_buffer {
 	dma_addr_t bus_address;
 };
 
+#if defined(CONFIG_MRST_RAR_HANDLER)
 /**
  * rar_reserve() - reserve RAR buffers
  * @buffers:	array of RAR_buffers where type and size of buffers to
@@ -149,7 +150,25 @@ extern size_t rar_release(struct RAR_buffer *buffers,
 extern size_t rar_handle_to_bus(struct RAR_buffer *buffers,
 				size_t count);
 
+#else
 
+extern inline size_t rar_reserve(struct RAR_buffer *buffers, size_t count)
+{
+	return 0;
+}
+
+extern inline size_t rar_release(struct RAR_buffer *buffers, size_t count)
+{
+	return 0;
+}
+
+extern inline size_t rar_handle_to_bus(struct RAR_buffer *buffers,
+				size_t count)
+{
+	return 0;
+}
+
+#endif  /* MRST_RAR_HANDLER */
 #endif  /* __KERNEL__ */
 
 #endif  /* _MEMRAR_H */
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 8a1ff86..b2cf553 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -59,6 +59,8 @@
 #include <linux/connector.h>
 #include <linux/cn_proc.h>
 
+#include "../memrar/memrar.h"
+
 #include "sep_driver_hw_defs.h"
 #include "sep_driver_config.h"
 #include "sep_driver_api.h"
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index cfda86f..b96045f 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -230,138 +230,5 @@ held by the proccess (struct file) */
 /* the token that defines the data pool pointers address */
 #define SEP_EXT_CACHE_ADDR_VAL_TOKEN                          0xBABABABA
 
-/* rar handler */
-#ifndef CONFIG_MRST_RAR_HANDLER
-
-/* This stub header is for non Moorestown driver only */
-
-/*
- * @struct RAR_stat
- *
- * @brief This structure is used for @c RAR_HANDLER_STAT ioctl and for
- *	@c RAR_get_stat() user space wrapper function.
- */
-struct RAR_stat {
-	/* Type of RAR memory (e.g., audio vs. video) */
-	__u32 type;
-
-	/*
-	* Total size of RAR memory region.
-	*/
-	__u32 capacity;
-
-	/* Size of the largest reservable block. */
-	__u32 largest_block_size;
-};
-
-
-/*
- * @struct RAR_block_info
- *
- * @brief The argument for the @c RAR_HANDLER_RESERVE @c ioctl.
- *
- */
-struct RAR_block_info {
-	/* Type of RAR memory (e.g., audio vs. video) */
-	__u32 type;
-
-	/* Requested size of a block to be reserved in RAR. */
-	__u32 size;
-
-	/* Handle that can be used to refer to reserved block. */
-	__u32 handle;
-};
-
-/*
- * @struct RAR_buffer
- *
- * Structure that contains all information related to a given block of
- * memory in RAR.  It is generally only used when retrieving bus
- * addresses.
- *
- * @note This structure is used only by RAR-enabled drivers, and is
- *	 not intended to be exposed to the user space.
- */
-struct RAR_buffer {
-	/* Structure containing base RAR buffer information */
-	struct RAR_block_info info;
-
-	/* Buffer bus address */
-	__u32 bus_address;
-};
-
-
-#define RAR_IOCTL_BASE 0xE0
-
-/* Reserve RAR block. */
-#define RAR_HANDLER_RESERVE _IOWR(RAR_IOCTL_BASE, 0x00, struct RAR_block_info)
-
-/* Release previously reserved RAR block. */
-#define RAR_HANDLER_RELEASE _IOW(RAR_IOCTL_BASE, 0x01, __u32)
-
-/* Get RAR stats. */
-#define RAR_HANDLER_STAT    _IOWR(RAR_IOCTL_BASE, 0x02, struct RAR_stat)
-
-
-/* -------------------------------------------------------------- */
-/*		 Kernel Side RAR Handler Interface		*/
-/* -------------------------------------------------------------- */
-
-/*
- * @function rar_reserve
- *
- * @brief Reserve RAR buffers.
- *
- * This function will reserve buffers in the restricted access regions
- * of given types.
- *
- * @return Number of successfully reserved buffers.
- *	 Successful buffer reservations will have the corresponding
- *	 @c bus_address field set to a non-zero value in the
- *	 given @a buffers vector.
- */
-#define rar_reserve(a, b) ((size_t)NULL)
-
-/*
- * @function rar_release
- *
- * @brief Release RAR buffers retrieved through call to
- *	@c rar_reserve() or @c rar_handle_to_bus().
- *
- * This function will release RAR buffers that were retrieved through
- * a call to @c rar_reserve() or @c rar_handle_to_bus() by
- * decrementing the reference count.  The RAR buffer will be reclaimed
- * when the reference count drops to zero.
- *
- * @return Number of successfully released buffers.
- *	 Successful releases will have their handle field set to
- *	 zero in the given @a buffers vector.
- */
-#define rar_release(a, b) ((size_t)NULL)
-
-/*
- * @function rar_handle_to_bus
- *
- * @brief Convert a vector of RAR handles to bus addresses.
- *
- * This function will retrieve the RAR buffer bus addresses, type and
- * size corresponding to the RAR handles provided in the @a buffers
- * vector.
- *
- * @return Number of successfully converted buffers.
- *	 The bus address will be set to @c 0 for unrecognized
- *	 handles.
- *
- * @note The reference count for each corresponding buffer in RAR will
- *	 be incremented.  Call @c rar_release() when done with the
- *	 buffers.
- */
-#define rar_handle_to_bus(a, b) ((size_t)NULL)
-
-#else /* using rear memrar */
-
-#include "../memrar/memrar.h"
-
-#endif  /* MEMRAR */
 
 #endif /* SEP DRIVER CONFIG */

