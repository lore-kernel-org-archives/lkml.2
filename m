Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0FWHqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:46:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52773 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0FWHqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=kvZlFh0EjxCm21T0o/uJrpdQYiM8Lzx5ZxBG+8vN8fcQVnz26I1kMHJ8uY3Unj/SuX
         cQ8qUMvyuJDPssBoCNBQ+V7M/Cky3WtZv9hDivGECiAc6pxcLNSXABwggaMYuD31PtE6
         +VfUfcTYcWpths0aq6IDUbFqAGWYpo2pr938o=
From: =?UTF-8?q?Henri=20H=C3=A4kkinen?= <henuxd@gmail.com>
To: gregkh@suse.de, ossama.othman@intel.com, henuxd@gmail.com,
       randy.dunlap@oracle.com, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: memrar: Moved memrar_allocator struct into memrar_allocator.c
Date: Mon, 14 Jun 2010 15:40:27 +0300
Message-Id: <1276519227-4987-1-git-send-email-henuxd@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward declared memrar_allocator in memrar_allocator.h and moved it
to memrar_allocator.c file.  Implemented memrar_allocator_capacity(),
memrar_allocator_largest_free_area(), memrar_allocoator_lock() and
memrar_allocator_unlock().

Signed-off-by: Henri Häkkinen <henuxd@gmail.com>
---
 drivers/staging/memrar/memrar_allocator.c |   56 ++++++++++++++++++++++++
 drivers/staging/memrar/memrar_allocator.h |   66 ++++++++++++++++------------
 drivers/staging/memrar/memrar_handler.c   |   11 +++--
 3 files changed, 100 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/memrar/memrar_allocator.c b/drivers/staging/memrar/memrar_allocator.c
index a4f8c58..955d1eb 100644
--- a/drivers/staging/memrar/memrar_allocator.c
+++ b/drivers/staging/memrar/memrar_allocator.c
@@ -41,6 +41,36 @@
 #include <linux/kernel.h>
 
 
+/**
+ * struct memrar_allocator - encapsulation of the memory allocator state
+ * @lock:		Lock used to synchronize access to the memory
+ *			allocator state.
+ * @base:		Base (start) address of the allocator memory
+ *			space.
+ * @capacity:		Size of the allocator memory space in bytes.
+ * @block_size:		The size in bytes of individual blocks within
+ *			the allocator memory space.
+ * @largest_free_area:	Largest free area of memory in the allocator
+ *			in bytes.
+ * @allocated_list:	List of allocated memory block address
+ *			ranges.
+ * @free_list:		List of free address ranges.
+ *
+ * This structure contains all memory allocator state, including the
+ * base address, capacity, free list, lock, etc.
+ */
+struct memrar_allocator {
+/* private: internal use only */
+	struct mutex lock;
+	unsigned long base;
+	size_t capacity;
+	size_t block_size;
+	size_t largest_free_area;
+	struct memrar_address_ranges allocated_list;
+	struct memrar_address_ranges free_list;
+};
+
+
 struct memrar_allocator *memrar_create_allocator(unsigned long base,
 						 size_t capacity,
 						 size_t block_size)
@@ -423,7 +453,33 @@ exit_memrar_free:
 	return 0;
 }
 
+size_t memrar_allocator_largest_free_area(struct memrar_allocator *allocator)
+{
+	if (allocator == NULL)
+		return 0;
+	return allocator->largest_free_area;
+}
+
+size_t memrar_allocator_capacity(struct memrar_allocator *allocator)
+{
+	if (allocator == NULL)
+		return 0;
+	return allocator->capacity;
+}
+
+void memrar_allocator_lock(struct memrar_allocator *allocator)
+{
+	if (allocator == NULL)
+		return;
+	mutex_lock(&allocator->lock);
+}
 
+void memrar_allocator_unlock(struct memrar_allocator *allocator)
+{
+	if (allocator == NULL)
+		return;
+	mutex_unlock(&allocator->lock);
+}
 
 /*
   Local Variables:
diff --git a/drivers/staging/memrar/memrar_allocator.h b/drivers/staging/memrar/memrar_allocator.h
index 0b80dea..0417072 100644
--- a/drivers/staging/memrar/memrar_allocator.h
+++ b/drivers/staging/memrar/memrar_allocator.h
@@ -50,34 +50,10 @@ struct memrar_address_ranges {
 	struct memrar_address_range range;
 };
 
-/**
- * struct memrar_allocator - encapsulation of the memory allocator state
- * @lock:		Lock used to synchronize access to the memory
- *			allocator state.
- * @base:		Base (start) address of the allocator memory
- *			space.
- * @capacity:		Size of the allocator memory space in bytes.
- * @block_size:		The size in bytes of individual blocks within
- *			the allocator memory space.
- * @largest_free_area:	Largest free area of memory in the allocator
- *			in bytes.
- * @allocated_list:	List of allocated memory block address
- *			ranges.
- * @free_list:		List of free address ranges.
- *
- * This structure contains all memory allocator state, including the
- * base address, capacity, free list, lock, etc.
- */
-struct memrar_allocator {
-/* private: internal use only */
-	struct mutex lock;
-	unsigned long base;
-	size_t capacity;
-	size_t block_size;
-	size_t largest_free_area;
-	struct memrar_address_ranges allocated_list;
-	struct memrar_address_ranges free_list;
-};
+
+/* Forward declaration */
+struct memrar_allocator;
+
 
 /**
  * memrar_create_allocator() - create a memory allocator
@@ -139,6 +115,40 @@ unsigned long memrar_allocator_alloc(struct memrar_allocator *allocator,
 long memrar_allocator_free(struct memrar_allocator *allocator,
 			   unsigned long address);
 
+/**
+ * memrar_allocator_largest_area() - largest free area of memory
+ * @allocator:  The allocator instance the free area is returned for.
+ *
+ * Return the largest free area of memory in the allocator in bytes.
+ */
+size_t memrar_allocator_largest_free_area(struct memrar_allocator *allocator);
+
+/**
+ * memrar_allocator_capacity - size of the allocator memory
+ * @allocator:  The allocator instance the capicity is returned for.
+ *
+ * Return the size of the allocator memory space in bytes.
+ */
+size_t memrar_allocator_capacity(struct memrar_allocator *allocator);
+
+
+/**
+ * memrar_allocator_lock - lock the allocator's mutex
+ * @allocator:  The allocator instance to lock the mutex for.
+ *
+ * Lock the mutex associated with the allocator.
+ */
+void memrar_allocator_lock(struct memrar_allocator *allocator);
+
+
+/**
+ * memrar_allocator_unlock - unlock the allocator's mutex
+ * @allocator:  The allocator instance to unlock the mutex for.
+ *
+ * Unlock the mutex associated with the allocator.
+ */
+void memrar_allocator_unlock(struct memrar_allocator *allocator);
+
 #endif  /* MEMRAR_ALLOCATOR_H */
 
 
diff --git a/drivers/staging/memrar/memrar_handler.c b/drivers/staging/memrar/memrar_handler.c
index efa7fd6..6a4628c 100644
--- a/drivers/staging/memrar/memrar_handler.c
+++ b/drivers/staging/memrar/memrar_handler.c
@@ -350,7 +350,8 @@ static int memrar_init_rar_resources(int rarnum, char const *devname)
 			devname, rarnum, (unsigned long) low, (unsigned long) high);
 
 	pr_info("%s: BRAR[%d] size = %zu KiB\n",
-			devname, rarnum, rar->allocator->capacity / 1024);
+			devname, rarnum,
+			memrar_allocator_capacity(rar->allocator) / 1024);
 
 	rar->allocated = 1;
 	return 0;
@@ -545,11 +546,11 @@ static long memrar_get_stat(struct RAR_stat *r)
 	 * Allocator capacity doesn't change over time.  No
 	 * need to synchronize.
 	 */
-	r->capacity = allocator->capacity;
+	r->capacity = memrar_allocator_capacity(allocator);
 
-	mutex_lock(&allocator->lock);
-	r->largest_block_size = allocator->largest_free_area;
-	mutex_unlock(&allocator->lock);
+	memrar_allocator_lock(allocator);
+	r->largest_block_size = memrar_allocator_largest_free_area(allocator);
+	memrar_allocator_unlock(allocator);
 	return 0;
 }
 
-- 
1.7.1

