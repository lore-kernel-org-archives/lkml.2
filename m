Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2FNNJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:09:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9112 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab2FNNJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:09:28 -0400
Message-id: <4FD9E27C.9030109@samsung.com>
Date: Thu, 14 Jun 2012 15:09:16 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
Cc: paul.gortmaker@windriver.com,
        =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
        amwang@redhat.com, dri-devel@lists.freedesktop.org,
        "'???/Mobile S/W Platform Lab.(???)/E3(??)/????'" 
	<inki.dae@samsung.com>,
        prashanth.g@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <rob@ti.com>, Dave Airlie <airlied@redhat.com>,
        "'???/Mobile S/W Platform Lab.(???)/E3(??)/????'" 
	<inki.dae@samsung.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4] scatterlist: add sg_alloc_table_from_pages function
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new constructor for an sg table. The table is constructed
from an array of struct pages. All contiguous chunks of the pages are merged
into a single sg nodes. A user may provide an offset and a size of a buffer if
the buffer is not page-aligned.

The function is dedicated for DMABUF exporters which often perform conversion
from an page array to a scatterlist. Moreover the scatterlist should be
squashed in order to save memory and to speed-up the process of DMA mapping
using dma_map_sg.

The code is based on the patch 'v4l: vb2-dma-contig: add support for
scatterlist in userptr mode' and hints from Laurent Pinchart.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- fix typos
- add Changelog

v3:
- use PFNs instead of page pointers to check contiguity

v2:
- rename sg_table_alloc_by_pages to sg_table_alloc_from_pages
- add some comments about error value

v1:
- initial version

---
 include/linux/scatterlist.h |    4 +++
 lib/scatterlist.c           |   64 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index ac9586d..7b600da 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -214,6 +214,10 @@ void sg_free_table(struct sg_table *);
 int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
 		     sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
+int sg_alloc_table_from_pages(struct sg_table *sgt,
+	struct page **pages, unsigned int n_pages,
+	unsigned long offset, unsigned long size,
+	gfp_t gfp_mask);

 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   void *buf, size_t buflen);
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 6096e89..e719adf 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -319,6 +319,70 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 EXPORT_SYMBOL(sg_alloc_table);

 /**
+ * sg_alloc_table_from_pages - Allocate and initialize an sg table from
+ *			       an array of pages
+ * @sgt:	The sg table header to use
+ * @pages:	Pointer to an array of page pointers
+ * @n_pages:	Number of pages in the pages array
+ * @offset:     Offset from start of the first page to the start of a buffer
+ * @size:       Number of valid bytes in the buffer (after offset)
+ * @gfp_mask:	GFP allocation mask
+ *
+ *  Description:
+ *    Allocate and initialize an sg table from a list of pages. Contiguous
+ *    ranges of the pages are squashed into a single scatterlist node. A user
+ *    may provide an offset at a start and a size of valid data in a buffer
+ *    specified by the page array. The returned sg table is released by
+ *    sg_free_table.
+ *
+ * Returns:
+ *   0 on success, negative error on failure
+ */
+int sg_alloc_table_from_pages(struct sg_table *sgt,
+	struct page **pages, unsigned int n_pages,
+	unsigned long offset, unsigned long size,
+	gfp_t gfp_mask)
+{
+	unsigned int chunks;
+	unsigned int i;
+	unsigned int cur_page;
+	int ret;
+	struct scatterlist *s;
+
+	/* compute number of contiguous chunks */
+	chunks = 1;
+	for (i = 1; i < n_pages; ++i)
+		if (page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1)
+			++chunks;
+
+	ret = sg_alloc_table(sgt, chunks, gfp_mask);
+	if (unlikely(ret))
+		return ret;
+
+	/* merging chunks and putting them into the scatterlist */
+	cur_page = 0;
+	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
+		unsigned long chunk_size;
+		unsigned int j;
+
+		/* look for the end of the current chunk */
+		for (j = cur_page + 1; j < n_pages; ++j)
+			if (page_to_pfn(pages[j]) !=
+			    page_to_pfn(pages[j - 1]) + 1)
+				break;
+
+		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
+		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
+		size -= chunk_size;
+		offset = 0;
+		cur_page = j;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(sg_alloc_table_from_pages);
+
+/**
  * sg_miter_start - start mapping iteration over a sg list
  * @miter: sg mapping iter to be started
  * @sgl: sg list to iterate over
-- 
1.7.9.5
