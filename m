Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1FHHqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:46:53 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:48634 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab1FHHqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:46:51 -0400
Message-Id: <20110608074648.287491002@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 08 Jun 2011 09:45:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 1/1] [PATCH] include storage keys in hibernation image.
References: <20110608074523.211912903@de.ibm.com>
Content-Disposition: inline; filename=201-hibernate-storage-keys.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

For s390 there is one additional byte associated with each page,
the storage key. This byte contains the referenced and changed
bits and needs to be included into the hibernation image.
If the storage keys are not restored to their previous state all
original pages would appear to be dirty. This can cause
inconsistencies e.g. with read-only filesystems.

Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/swsusp_asm64.S |    3 
 kernel/power/snapshot.c         |  148 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+)

diff -urpN linux-2.6/arch/s390/kernel/swsusp_asm64.S linux-2.6-patched/arch/s390/kernel/swsusp_asm64.S
--- linux-2.6/arch/s390/kernel/swsusp_asm64.S	2011-05-19 06:06:34.000000000 +0200
+++ linux-2.6-patched/arch/s390/kernel/swsusp_asm64.S	2011-06-06 11:14:43.000000000 +0200
@@ -138,11 +138,14 @@ swsusp_arch_resume:
 0:
 	lg	%r2,8(%r1)
 	lg	%r4,0(%r1)
+	iske	%r0,%r4
 	lghi	%r3,PAGE_SIZE
 	lghi	%r5,PAGE_SIZE
 1:
 	mvcle	%r2,%r4,0
 	jo	1b
+	lg	%r2,8(%r1)
+	sske	%r0,%r2
 	lg	%r1,16(%r1)
 	ltgr	%r1,%r1
 	jnz	0b
diff -urpN linux-2.6/kernel/power/snapshot.c linux-2.6-patched/kernel/power/snapshot.c
--- linux-2.6/kernel/power/snapshot.c	2011-06-06 11:14:39.000000000 +0200
+++ linux-2.6-patched/kernel/power/snapshot.c	2011-06-06 11:14:43.000000000 +0200
@@ -1022,6 +1022,137 @@ static inline void copy_data_page(unsign
 }
 #endif /* CONFIG_HIGHMEM */
 
+#ifdef CONFIG_S390
+/*
+ * For s390 there is one additional byte associated with each page,
+ * the storage key. The key consists of the access-control bits
+ * (alias the key), the fetch-protection bit, the referenced bit
+ * and the change bit (alias dirty bit). Linux uses only the
+ * referenced bit and the change bit for pages in the page cache.
+ * Any modification of a page will set the change bit, any access
+ * sets the referenced bit. Overindication of the referenced bits
+ * after a hibernation cycle does not cause any harm but the
+ * overindication of the change bits would cause trouble.
+ * Therefore it is necessary to include the storage keys in the
+ * hibernation image. The storage keys are saved to the most
+ * significant byte of each page frame number in the list of pfns
+ * in the hibernation image.
+ */
+
+/*
+ * Key storage is allocated as a linked list of pages.
+ * The size of the keys array is (PAGE_SIZE - sizeof(long))
+ */
+struct page_key_data {
+	struct page_key_data *next;
+	unsigned char data[];
+};
+
+#define PAGE_KEY_DATA_SIZE	(PAGE_SIZE - sizeof(struct page_key_data *))
+
+static struct page_key_data *page_key_data;
+static struct page_key_data *page_key_rp, *page_key_wp;
+static unsigned long page_key_rx, page_key_wx;
+
+/*
+ * For each page in the hibernation image one additional byte is
+ * stored in the most significant byte of the page frame number.
+ * On suspend no additional memory is required but on resume the
+ * keys need to be memorized until the page data has been restored.
+ * Only then can the storage keys be set to their old state.
+ */
+static inline unsigned long page_key_additional_pages(unsigned long pages)
+{
+	return DIV_ROUND_UP(pages, PAGE_KEY_DATA_SIZE);
+}
+
+/*
+ * Free page_key_data list of arrays.
+ */
+static void page_key_free(void)
+{
+	struct page_key_data *pkd;
+
+	while (page_key_data) {
+		pkd = page_key_data;
+		page_key_data = pkd->next;
+		free_page((unsigned long) pkd);
+	}
+}
+
+/*
+ * Allocate page_key_data list of arrays with enough room to store
+ * one byte for each page in the hibernation image.
+ */
+static int page_key_alloc(unsigned long pages)
+{
+	struct page_key_data *pk;
+	unsigned long size;
+
+	size = DIV_ROUND_UP(pages, PAGE_KEY_DATA_SIZE);
+	while (size--) {
+		pk = (struct page_key_data *) get_zeroed_page(GFP_KERNEL);
+		if (!pk) {
+			page_key_free();
+			return -ENOMEM;
+		}
+		pk->next = page_key_data;
+		page_key_data = pk;
+	}
+	page_key_rp = page_key_wp = page_key_data;
+	page_key_rx = page_key_wx = 0;
+	return 0;
+}
+
+/*
+ * Save the storage key into the upper 8 bits of the page frame number.
+ */
+static inline void page_key_read(unsigned long *pfn)
+{
+	unsigned long addr;
+
+	addr = (unsigned long) page_address(pfn_to_page(*pfn));
+	*(unsigned char *) pfn = (unsigned char) page_get_storage_key(addr);
+}
+
+/*
+ * Extract the storage key from the upper 8 bits of the page frame number
+ * and store it in the page_key_data list of arrays.
+ */
+static inline void page_key_memorize(unsigned long *pfn)
+{
+	page_key_wp->data[page_key_wx] = *(unsigned char *) pfn;
+	*(unsigned char *) pfn = 0;
+	if (++page_key_wx < PAGE_KEY_DATA_SIZE)
+		return;
+	page_key_wp = page_key_wp->next;
+	page_key_wx = 0;
+}
+
+/*
+ * Get the next key from the page_key_data list of arrays and set the
+ * storage key of the page referred by @address. If @address refers to
+ * a "safe" page the swsusp_arch_resume code will transfer the storage
+ * key from the buffer page to the original page.
+ */
+static void page_key_write(void *address)
+{
+	page_set_storage_key((unsigned long) address,
+			     page_key_rp->data[page_key_rx], 0);
+	if (++page_key_rx >= PAGE_KEY_DATA_SIZE)
+		return;
+	page_key_rp = page_key_rp->next;
+	page_key_rx = 0;
+}
+#else
+static unsigned long page_key_additional_pages(unsigned long pages) { return 0; }
+static inline int  page_key_alloc(unsigned long pages) { return 0; }
+static inline void page_key_free(void) { }
+static inline void page_key_read(unsigned long *pfn) { }
+static inline void page_key_memorize(unsigned long *pfn) { }
+static inline void page_key_write(void *address) { }
+#endif
+
 static void
 copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 {
@@ -1335,6 +1466,9 @@ int hibernate_preallocate_memory(void)
 	count += highmem;
 	count -= totalreserve_pages;
 
+	/* Add number of pages required for storage keys (s390 only). */
+	size += page_key_additional_pages(saveable);
+
 	/* Compute the maximum number of saveable pages to leave in memory. */
 	max_size = (count - (size + PAGES_FOR_IO)) / 2
 			- 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
@@ -1658,6 +1792,8 @@ pack_pfns(unsigned long *buf, struct mem
 		buf[j] = memory_bm_next_pfn(bm);
 		if (unlikely(buf[j] == BM_END_OF_MAP))
 			break;
+		/* Save storage key for data page (s390 only). */
+		page_key_read(buf + j);
 	}
 }
 
@@ -1817,6 +1953,9 @@ static int unpack_orig_pfns(unsigned lon
 		if (unlikely(buf[j] == BM_END_OF_MAP))
 			break;
 
+		/* Extract and buffer storage key for data page (s390 only). */
+		page_key_memorize(buf + j);
+
 		if (memory_bm_pfn_present(bm, buf[j]))
 			memory_bm_set_bit(bm, buf[j]);
 		else
@@ -2219,6 +2358,10 @@ int snapshot_write_next(struct snapshot_
 		if (error)
 			return error;
 
+		error = page_key_alloc(nr_copy_pages);
+		if (error)
+			return error;
+
 	} else if (handle->cur <= nr_meta_pages + 1) {
 		error = unpack_orig_pfns(buffer, &copy_bm);
 		if (error)
@@ -2239,6 +2382,8 @@ int snapshot_write_next(struct snapshot_
 		}
 	} else {
 		copy_last_highmem_page();
+		/* Restore storage key for data page (s390 only). */
+		page_key_write(handle->buffer);
 		handle->buffer = get_buffer(&orig_bm, &ca);
 		if (IS_ERR(handle->buffer))
 			return PTR_ERR(handle->buffer);
@@ -2260,6 +2405,9 @@ int snapshot_write_next(struct snapshot_
 void snapshot_write_finalize(struct snapshot_handle *handle)
 {
 	copy_last_highmem_page();
+	/* Restore storage key for data page (s390 only). */
+	page_key_write(handle->buffer);
+	page_key_free();
 	/* Free only if we have loaded the image entirely */
 	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages) {
 		memory_bm_free(&orig_bm, PG_UNSAFE_CLEAR);

