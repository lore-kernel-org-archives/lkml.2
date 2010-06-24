Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0FXHKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:10:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:24359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0FXHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=j0Tyiwq5BU2/7vNW0OIWLlsS5f5d+2d2+OVu+7P7rezqexxLLWrFRqEBHOYhbVJSud
         Tjx8rCVQKvjtxZiBLT9Mzuu7wy7VtipO1Ro5fv9n1V3leTK1TyctV7E3GdcaMrSGu5KP
         9hcSnXLf4KmreXo8t87RGUOF5qoeDLsJOBhUY=
From: =?UTF-8?q?Henri=20H=C3=A4kkinen?= <henuxd@gmail.com>
To: gregkh@suse.de, ossama.othman@intel.com, henuxd@gmail.com,
       alan@linux.intel.com, mattij.lammi@gmail.com, randy.dunlap@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: memrar: Moved memrar_allocator struct to memrar_allocator.c
Date: Thu, 24 Jun 2010 10:09:45 +0300
Message-Id: <1277363386-4817-1-git-send-email-henuxd@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward declared memrar_allocator structure in memrar_allocator.h and
moved the definition to memrar_allocator.c. Implemented
memrar_allocator_capacity() and memrar_allocator_largest_free_area().

Signed-off-by: Henri Häkkinen <henuxd@gmail.com>
---
 drivers/staging/memrar/memrar_allocator.c |   43 ++++++++++++++++++++++++++
 drivers/staging/memrar/memrar_allocator.h |   48 ++++++++++++-----------------
 2 files changed, 63 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/memrar/memrar_allocator.c b/drivers/staging/memrar/memrar_allocator.c
index a4f8c58..cb74e3c 100644
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
@@ -423,6 +453,19 @@ exit_memrar_free:
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
 
 
 /*
diff --git a/drivers/staging/memrar/memrar_allocator.h b/drivers/staging/memrar/memrar_allocator.h
index 0b80dea..49dbc6e 100644
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
@@ -139,6 +115,22 @@ unsigned long memrar_allocator_alloc(struct memrar_allocator *allocator,
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
+ * memrar_allocator_capacity() - size of the allocator memory
+ * @allocator:  The allocator instance the capicity is returned for.
+ *
+ * Return the size of the allocator memory space in bytes.
+ */
+size_t memrar_allocator_capacity(struct memrar_allocator *allocator);
+
 #endif  /* MEMRAR_ALLOCATOR_H */
 
 
-- 
1.7.1

