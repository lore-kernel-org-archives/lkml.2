Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab1CDERL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 23:17:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54273 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab1CDERF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 23:17:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B6ozNERWpsF97GgVEI0oFVref7myP9jKeYYW9NCdbk7k9yirzDZcizs3qa53Kx/hCx
         zUe9MzEIKoxDsoAufgPvbHyZUO+SoSNbnhvBk0lB4bNNf7D0keRYHgGdo36kDRd4YEIZ
         SFVuDx2JJP6Urc62IcrIoHKkVPdnr2Lq0pRUw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/4] scatterlist: new helper functions
Date: Fri,  4 Mar 2011 06:16:50 +0200
Message-Id: <1299212213-4255-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While developing memstick driver for legacy memsticks
I found the need in few helpers that I think should be
in common scatterlist library

The functions that were added:

* sg_nents/sg_total_len - iterate over scatterlist to figure
out total length of memory it covers / number of entries.

Usefull for small sg lists where there is no prefomance advantage of
storing this info in a special variable.

* sg_copy/sg_truncate - Allow to break scatterlists apart into smaller chunks.
sg_copy creates smaller scatterlist, spanning first 'len' bytes, while
sg_truncate edits the scatterlist in such way that it skips over 'len' bytes.


* sg_compare_to_buffer - another function to hide gory details of access
to sg list by CPU.
Allows to transparently compare contents of the sg list to given linear
buffer.
If needed later, a function that compares two sgs can be added.

All of this code is used by my ms_block.c driver.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 include/linux/scatterlist.h |    8 ++
 lib/scatterlist.c           |  152 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 0 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 9aaf5bf..88fc7a5 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -199,6 +199,12 @@ static inline void *sg_virt(struct scatterlist *sg)
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+struct scatterlist *sg_truncate(struct scatterlist *sg, int consumed);
+int sg_nents(struct scatterlist *sg);
+int sg_total_len(struct scatterlist *sg);
+int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to,
+							int to_nents, int len);
+
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
@@ -217,6 +223,8 @@ size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen);
+bool sg_compare_to_buffer(struct scatterlist *sg, unsigned int nents,
+							u8 *buffer, size_t len);
 
 /*
  * Maximum number of entries that will be allocated in one piece, if
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 4ceb05d..941195d 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -39,6 +39,76 @@ struct scatterlist *sg_next(struct scatterlist *sg)
 EXPORT_SYMBOL(sg_next);
 
 /**
+ * sg_truncate - remove 'consumed' bytes from head of a scatterlist
+ * @sg:		The current sg entry
+ * @consumed:	How much bytes to remove
+ */
+struct scatterlist *sg_truncate(struct scatterlist *sg, int consumed)
+{
+	while (consumed >= sg->length) {
+		consumed -= sg->length;
+
+		sg = sg_next(sg);
+		if (!sg)
+			break;
+	}
+
+	WARN_ON(!sg && consumed);
+
+	if (!sg)
+		return NULL;
+
+	sg->offset += consumed;
+	sg->length -= consumed;
+
+	if (sg->offset >= PAGE_SIZE) {
+		struct page *page =
+			nth_page(sg_page(sg), sg->offset / PAGE_SIZE);
+		sg_set_page(sg, page, sg->length, sg->offset % PAGE_SIZE);
+	}
+
+	return sg;
+}
+EXPORT_SYMBOL(sg_truncate);
+
+/**
+ * sg_nents - calculate number of sg entries in sg list
+ * @sg:		The current sg entry
+ *
+ * Allows to calculate dynamically the length of the sg table, based on
+ * assumption that last entry is correctly marked by sg_mark_end
+ */
+int sg_nents(struct scatterlist *sg)
+{
+	int nents = 0;
+	while (sg) {
+		nents++;
+		sg = sg_next(sg);
+	}
+
+	return nents;
+}
+EXPORT_SYMBOL(sg_nents);
+
+/**
+ * sg_total_len - calculate total length of scatterlist
+ * @sg:		The current sg entry
+ *
+ * Dynamically calculate total number of bytes in an scatterlist
+ * based on assumption that last entry is correctly marked by sg_mark_end
+ */
+int sg_total_len(struct scatterlist *sg)
+{
+	int len = 0;
+	while (sg) {
+		len += sg->length;
+		sg = sg_next(sg);
+	}
+	return len;
+}
+EXPORT_SYMBOL(sg_total_len);
+
+/**
  * sg_last - return the last scatterlist entry in a list
  * @sgl:	First entry in the scatterlist
  * @nents:	Number of entries in the scatterlist
@@ -110,6 +180,47 @@ void sg_init_one(struct scatterlist *sg, const void *buf, unsigned int buflen)
 }
 EXPORT_SYMBOL(sg_init_one);
 
+/**
+ * sg_copy - copies sg entries from sg_from to sg_to, such
+ * as sg_to covers first 'len' bytes from sg_from.
+ * @sg_from:	SG list to copy entries from
+ * @sg_to:	SG list to write entries to
+ * @to_nents:	number of usable entries in 'sg_to'
+ * @len:	maximum number of bytes the 'sg_to' will cover
+ *
+ * Returns actual number of bytes covered by sg_to
+ */
+int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to,
+							int to_nents, int len)
+{
+	int copied = 0;
+
+	while (len > sg_from->length && to_nents--) {
+
+		len -= sg_from->length;
+		copied += sg_from->length;
+
+		sg_set_page(sg_to, sg_page(sg_from),
+				sg_from->length, sg_from->offset);
+
+		if (sg_is_last(sg_from) || !len) {
+			sg_mark_end(sg_to);
+			return copied;
+		}
+
+		sg_from = sg_next(sg_from);
+		sg_to = sg_next(sg_to);
+	}
+
+	if (to_nents) {
+		sg_set_page(sg_to, sg_page(sg_from), len, sg_from->offset);
+		sg_mark_end(sg_to);
+	}
+
+	return copied;
+}
+EXPORT_SYMBOL(sg_copy);
+
 /*
  * The default behaviour of sg_alloc_table() is to use these kmalloc/kfree
  * helpers.
@@ -517,3 +628,44 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
+
+
+/**
+ * sg_compare_to_buffer - compare contents of the data pointed by sg table
+ * to a kernel ram buffer
+ *
+ * @sg:		The current sg entry
+ * @buffer:	Linear kernel buffer to compare with
+ * @len:	Length of that buffer
+ *
+ * Returns 0 if equal and memcmp compliant result otherwise
+ */
+bool sg_compare_to_buffer(struct scatterlist *sg, unsigned int nents,
+							u8 *buffer, size_t len)
+{
+	unsigned long flags;
+	int retval = 0;
+	struct sg_mapping_iter miter;
+
+	local_irq_save(flags);
+	sg_miter_start(&miter, sg, nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+
+	while (sg_miter_next(&miter) && len > 0) {
+
+		int cmplen = min(miter.length, len);
+		retval = memcmp(miter.addr, buffer, cmplen);
+		if (retval)
+			break;
+
+		buffer += cmplen;
+		len -= cmplen;
+	}
+
+	if (!retval && len)
+		retval = -1;
+
+	sg_miter_stop(&miter);
+	local_irq_restore(flags);
+	return retval;
+}
+EXPORT_SYMBOL(sg_compare_to_buffer);
-- 
1.7.1

