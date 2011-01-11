Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab1AKXoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:44:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45245 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab1AKXoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hD3PnYTuBO6aJRsLFzAYVNHS+e2mYiyF/9rKPaEBjC/eLg9K5hxKWpNs7coLAE/Ck3
         xsNN2cxs7fcicVJVi1w3ruuxBZHPS2AvQRxcO1XIyOgfi2TzoDTKSsSuRtxg/DNZSFg4
         gitrqkJOVTAIR4+tuhZ0eoa20nfwpYYGqy8Ys=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Alex Dubov <oakad@yahoo.com>, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/4] scatterlist: new helper functions
Date: Wed, 12 Jan 2011 01:36:12 +0200
Message-Id: <1294788975-19584-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294788975-19584-1-git-send-email-maximlevitsky@gmail.com>
References: <1294788975-19584-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While developing memstick driver for legacy memsticks
I found the need in few helpers that I think should be
in common scatterlist library

The functions that were added:

* sg_nents/sg_total_len - iterate over scatterlist to figure
out total length of memory it covers / number of entries.
Useful for not keeping that information in side channels.

* sg_copy/sg_advance - Allow to break scatterlists apart into smaller chunks.
sg_copy creates smaller scatterlist, spanning first 'len' bytes, while
sg_advance edits the scatterlist in such way that it skips over 'len' bytes.


* sg_compare_to_buffer - another function to hide gory details of access
to sg list by CPU.
Allows to transparently compare contents of the sg list to given linear
buffer.
If needed later, a function that compares two sgs can be added.

All of this code is used by my ms_block.c driver.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 include/linux/scatterlist.h |    6 ++
 lib/scatterlist.c           |  137 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 0 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 9aaf5bf..6305589 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -199,6 +199,11 @@ static inline void *sg_virt(struct scatterlist *sg)
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+struct scatterlist *sg_advance(struct scatterlist *sg, int consumed);
+int sg_nents(struct scatterlist *sg);
+int sg_total_len(struct scatterlist *sg);
+int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len);
+
 struct scatterlist *sg_next(struct scatterlist *);
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
@@ -217,6 +222,7 @@ size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen);
+bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len);
 
 /*
  * Maximum number of entries that will be allocated in one piece, if
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 4ceb05d..2f18938 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -39,6 +39,77 @@ struct scatterlist *sg_next(struct scatterlist *sg)
 EXPORT_SYMBOL(sg_next);
 
 /**
+ * sg_advance - advance scatterlist by 'consumed' bytes
+ * @sg - the current sg entry
+ * @consumed - how much bytes to advance
+ *
+ */
+struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
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
+EXPORT_SYMBOL(sg_advance);
+
+/**
+ * sg_nents - calculate number of sg entries in sg list
+ * @sg - the current sg entry
+ *
+ * Allows to calculate dynamicly the lenght of the sg table, based on
+ * assumption that last entry is NULL
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
+ * sg_total_len - calculate total lenght of scatterlist
+ * @sg - the current sg entry
+ *
+ * Dynamicly calculate total number of bytes in a sg list
+ * based on assumption that list ends with a NULL entry
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
@@ -110,6 +181,33 @@ void sg_init_one(struct scatterlist *sg, const void *buf, unsigned int buflen)
 }
 EXPORT_SYMBOL(sg_init_one);
 
+/**
+ * sg_copy - copies sg entries from sg_from to sg_to, such
+ * as sg_to covers first 'len' bytes from sg_from.
+ */
+int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len)
+{
+	while (len > sg_from->length) {
+		len -= sg_from->length;
+
+		sg_set_page(sg_to, sg_page(sg_from),
+				sg_from->length, sg_from->offset);
+
+		sg_to = sg_next(sg_to);
+		sg_from = sg_next(sg_from);
+
+		if (len && (!sg_from || !sg_to))
+			return -ENOMEM;
+	}
+
+	if (len)
+		sg_set_page(sg_to, sg_page(sg_from),
+				len, sg_from->offset);
+	sg_mark_end(sg_to);
+	return 0;
+}
+EXPORT_SYMBOL(sg_copy);
+
 /*
  * The default behaviour of sg_alloc_table() is to use these kmalloc/kfree
  * helpers.
@@ -517,3 +615,42 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
+
+
+/**
+ * sg_compare_to_buffer - compare contents of the data pointeted by sg table
+ * to a kernel ram buffer
+ * @sg - the current sg entry
+ * @buffer - linear buffer to compare with
+ * @len - lenght of that buffer
+ */
+bool sg_compare_to_buffer(struct scatterlist *sg, u8 *buffer, size_t len)
+{
+	unsigned long flags;
+	int retval = 0;
+	struct sg_mapping_iter miter;
+
+	if (sg_total_len(sg) < len)
+		return 1;
+
+	local_irq_save(flags);
+	sg_miter_start(&miter, sg, sg_nents(sg),
+				SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+
+	while (sg_miter_next(&miter) && len > 0) {
+
+		int cmplen = min(miter.length, len);
+		if (memcmp(miter.addr, buffer, cmplen)) {
+			retval = 1;
+			break;
+		}
+
+		buffer += cmplen;
+		len -= cmplen;
+	}
+
+	sg_miter_stop(&miter);
+	local_irq_restore(flags);
+	return retval;
+}
+EXPORT_SYMBOL(sg_compare_to_buffer);
-- 
1.7.1

