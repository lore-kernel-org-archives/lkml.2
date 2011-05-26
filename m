Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab1EZSSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:18:40 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:41194 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758234Ab1EZSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 4CIh6noVM1mT0yLCQIEwRPxGDMwlcZrcvw3juH0K2LAsZ63
 iRmrxIWAwkg662MAk4v6UqNB1Zx0H.q45nIIj_ICekUhYKzeu0.ff20Vl_Nm
 3oAtWHdi9WJp5UH774tqp4cU_.oSzRXKPl_P3y.YWKKHkniLwcPc82OWTvvf
 CcDkV4RuVHIy9HVjWGSESfkRWCp9uQ.xe35_tJQTYFb7ieZDd0_u417nP2VB
 JkCb_Gl.b2315sVGWsp_1_X_rLVLUiJDV2PlTqipotb1BDmuNvRFkUWuaYpe
 xJRCzc8mVeFFbL0cVsP5QU5kxhYorSvm9CkOdJlrAXaGaf7GK9Mau3_ywyc1
 QnUCe5xhVwg9.wp9rxKEtu3rx
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181504.288002296@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:47 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 05/17] mm: Rearrange struct page
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=resort_struct_page
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to be able to use cmpxchg_double on the freelist and object count
field in struct page. Rearrange the fields in struct page according to
doubleword entities so that the freelist pointer comes before the counters.
Do the rearranging with a future in mind where we use more doubleword
atomics to avoid locking of updates to flags/mapping or lru pointers.

Create another union to allow access to counters in struct page as a
single unsigned long value.

The doublewords must be properly aligned for cmpxchg_double to work.
Sadly this increases the size of page struct by one word on some architectures.
But as a resultpage structs are now cacheline aligned on x86_64.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/mm_types.h |   89 +++++++++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 29 deletions(-)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2011-05-06 12:03:46.000000000 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-05-06 12:50:40.000000000 -0500
@@ -30,52 +30,74 @@ struct address_space;
  * moment. Note that we have no way to track which tasks are using
  * a page, though if it is a pagecache page, rmap structures can tell us
  * who is mapping it.
+ *
+ * The objects in struct page are organized in double word blocks in
+ * order to allows us to use atomic double word operations on portions
+ * of struct page. That is currently only used by slub but the arrangement
+ * allows the use of atomic double word operations on the flags/mapping
+ * and lru list pointers also.
  */
 struct page {
+	/* First double word block */
 	unsigned long flags;		/* Atomic flags, some possibly
 					 * updated asynchronously */
-	atomic_t _count;		/* Usage count, see below. */
+	struct address_space *mapping;	/* If low bit clear, points to
+					 * inode address_space, or NULL.
+					 * If page mapped as anonymous
+					 * memory, low bit is set, and
+					 * it points to anon_vma object:
+					 * see PAGE_MAPPING_ANON below.
+					 */
+	/* Second double word */
 	union {
-		atomic_t _mapcount;	/* Count of ptes mapped in mms,
-					 * to show when page is mapped
-					 * & limit reverse map searches.
+		struct {
+			pgoff_t index;		/* Our offset within mapping. */
+			atomic_t _mapcount;	/* Count of ptes mapped in mms,
+							 * to show when page is mapped
+							 * & limit reverse map searches.
+							 */
+			atomic_t _count;		/* Usage count, see below. */
+		};
+
+		struct {			/* SLUB cmpxchg_double area */
+			void *freelist;
+			union {
+				unsigned long counters;
+				struct {
+					unsigned inuse:16;
+					unsigned objects:15;
+					unsigned frozen:1;
+					/*
+					 * Kernel may make use of this field even when slub
+					 * uses the rest of the double word!
 					 */
-		struct {		/* SLUB */
-			unsigned inuse:16;
-			unsigned objects:15;
-			unsigned frozen:1;
+					atomic_t _count;
+				};
+			};
 		};
 	};
+
+	/* Third double word block */
+	struct list_head lru;		/* Pageout list, eg. active_list
+					 * protected by zone->lru_lock !
+					 */
+
+	/* Remainder is not double word aligned */
 	union {
-	    struct {
-		unsigned long private;		/* Mapping-private opaque data:
+	 	unsigned long private;		/* Mapping-private opaque data:
 					 	 * usually used for buffer_heads
 						 * if PagePrivate set; used for
 						 * swp_entry_t if PageSwapCache;
 						 * indicates order in the buddy
 						 * system if PG_buddy is set.
 						 */
-		struct address_space *mapping;	/* If low bit clear, points to
-						 * inode address_space, or NULL.
-						 * If page mapped as anonymous
-						 * memory, low bit is set, and
-						 * it points to anon_vma object:
-						 * see PAGE_MAPPING_ANON below.
-						 */
-	    };
 #if USE_SPLIT_PTLOCKS
-	    spinlock_t ptl;
+		spinlock_t ptl;
 #endif
-	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
-	    struct page *first_page;	/* Compound tail pages */
+		struct kmem_cache *slab;	/* SLUB: Pointer to slab */
+		struct page *first_page;	/* Compound tail pages */
 	};
-	union {
-		pgoff_t index;		/* Our offset within mapping. */
-		void *freelist;		/* SLUB: freelist req. slab lock */
-	};
-	struct list_head lru;		/* Pageout list, eg. active_list
-					 * protected by zone->lru_lock !
-					 */
+
 	/*
 	 * On machines where all RAM is mapped into kernel address space,
 	 * we can simply calculate the virtual address. On machines with
@@ -101,7 +123,16 @@ struct page {
 	 */
 	void *shadow;
 #endif
-};
+}
+/*
+ * If another subsystem starts using the double word pairing for atomic
+ * operations on struct page then it must change the #if to ensure
+ * proper alignment of the page struct.
+ */
+#if defined(CONFIG_SLUB) && defined(CONFIG_CMPXCHG_LOCAL)
+	__attribute__((__aligned__(2*sizeof(unsigned long))))
+#endif
+;
 
 /*
  * A region containing a mapping of a non-memory backed file under NOMMU

