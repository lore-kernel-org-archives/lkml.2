Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1AHQuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 11:50:07 -0500
Received: from mx2.netapp.com ([216.240.18.37]:14404 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1AHQuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 11:50:04 -0500
X-IronPort-AV: E=Sophos;i="4.60,293,1291622400"; 
   d="scan'208";a="503069957"
Subject: Re: still nfs problems [Was: Linux 2.6.37-rc8]
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Marc Kleine-Budde <m.kleine-budde@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Parisc List <linux-parisc@vger.kernel.org>, linux-arch@vger.kernel.org
In-Reply-To: <1294427467.4895.66.camel@mulgrave.site>
References: <20110105210448.GM8638@n2100.arm.linux.org.uk>
	 <AANLkTi=EXXBTW7oWHq3D+PHsx=thF1CpkRjn0ax2p5rm@mail.gmail.com>
	 <1294262208.2952.4.camel@heimdal.trondhjem.org>
	 <AANLkTi=3Gu-rz=-OdNtUXn4qw60Df6=YePnzvB=s-+Ov@mail.gmail.com>
	 <1294268808.2952.18.camel@heimdal.trondhjem.org>
	 <1294270104.16957.73.camel@mulgrave.site>
	 <1294335614.22825.154.camel@mulgrave.site>
	 <1294336054.2905.1.camel@heimdal.trondhjem.org>
	 <AANLkTimusF4KCJ4vHPn+T1dUiKxapXaT0QTtFvh8Ykdd@mail.gmail.com>
	 <1294426405.2929.23.camel@heimdal.trondhjem.org>
	 <20110107190229.GX31708@n2100.arm.linux.org.uk>
	 <1294427467.4895.66.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Sat, 08 Jan 2011 11:49:44 -0500
Message-ID: <1294505384.4181.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 08 Jan 2011 16:49:46.0175 (UTC) FILETIME=[0E45A4F0:01CBAF54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 13:11 -0600, James Bottomley wrote: 
> On the other hand, the xdr routines, since they take the pages anyway,
> could use a scatterlist approach to writing through the kernel mapping
> instead of using vmap ... we have all the machinery for this in
> lib/scatterlist.c ... it's not designed for this case, since it's
> designed to allow arbitrary linear reads and writes on a block
> scatterlist, but the principle is the same ... it looks like it would be
> rather a big patch, though ... 

The following alternative seems to work for me, but has only been
lightly tested so far. It's a bit large for a stable patch, but not too
ungainly.

It modifies xdr_stream, adding the ability to iterate through page data.
To avoid kmap()/kunmap(), it does require that pages be allocated in
lowmem, but since the only use case here is when using page arrays as
temporary buffers, that seems like an acceptable compromise.

Cheers
  Trond

--------------------------------------------------------------------------------- 
>From f87f13e3198ec536c1b9cfe19ad47df4fb922382 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Fri, 7 Jan 2011 18:51:33 -0500
Subject: [PATCH] NFS: Don't use vm_map_ram() in readdir

vm_map_ram() is not available on NOMMU platforms, and causes trouble
on incoherrent architectures such as ARM when we access the page data
through both the direct and the virtual mapping.

The alternative is to use the direct mapping to access page data
for the case when we are not crossing a page boundary, but to copy
the data into a linear scratch buffer when we are accessing data
that spans page boundaries.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/dir.c               |   45 ++++++++---------
 fs/nfs/nfs2xdr.c           |    6 --
 fs/nfs/nfs3xdr.c           |    6 --
 fs/nfs/nfs4xdr.c           |    6 --
 include/linux/sunrpc/xdr.h |    4 +-
 net/sunrpc/xdr.c           |  115 ++++++++++++++++++++++++++++++++++++--------
 6 files changed, 120 insertions(+), 62 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 996dd89..ad9e5e0 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -33,7 +33,6 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
-#include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
 
 #include "delegation.h"
@@ -459,25 +458,27 @@ out:
 /* Perform conversion from xdr to cache array */
 static
 int nfs_readdir_page_filler(nfs_readdir_descriptor_t *desc, struct nfs_entry *entry,
-				void *xdr_page, struct page *page, unsigned int buflen)
+				struct page **xdr_pages, struct page *page, unsigned int buflen)
 {
 	struct xdr_stream stream;
-	struct xdr_buf buf;
-	__be32 *ptr = xdr_page;
+	struct xdr_buf buf = {
+		.pages = xdr_pages,
+		.page_len = buflen,
+		.buflen = buflen,
+		.len = buflen,
+	};
 	struct nfs_cache_array *array;
 	unsigned int count = 0;
+	struct page *scratch;
 	int status;
 
-	buf.head->iov_base = xdr_page;
-	buf.head->iov_len = buflen;
-	buf.tail->iov_len = 0;
-	buf.page_base = 0;
-	buf.page_len = 0;
-	buf.buflen = buf.head->iov_len;
-	buf.len = buf.head->iov_len;
-
-	xdr_init_decode(&stream, &buf, ptr);
+	scratch = alloc_page(GFP_KERNEL);
+	if (scratch == NULL)
+		return -ENOMEM;
 
+	xdr_init_decode(&stream, &buf, NULL);
+	xdr_set_scratch_buffer(&stream, page_address(scratch), PAGE_SIZE);
+	xdr_enter_page(&stream, buflen);
 
 	do {
 		status = xdr_decode(desc, entry, &stream);
@@ -506,6 +507,8 @@ int nfs_readdir_page_filler(nfs_readdir_descriptor_t *desc, struct nfs_entry *en
 		} else
 			status = PTR_ERR(array);
 	}
+
+	put_page(scratch);
 	return status;
 }
 
@@ -521,7 +524,6 @@ static
 void nfs_readdir_free_large_page(void *ptr, struct page **pages,
 		unsigned int npages)
 {
-	vm_unmap_ram(ptr, npages);
 	nfs_readdir_free_pagearray(pages, npages);
 }
 
@@ -530,9 +532,8 @@ void nfs_readdir_free_large_page(void *ptr, struct page **pages,
  * to nfs_readdir_free_large_page
  */
 static
-void *nfs_readdir_large_page(struct page **pages, unsigned int npages)
+int nfs_readdir_large_page(struct page **pages, unsigned int npages)
 {
-	void *ptr;
 	unsigned int i;
 
 	for (i = 0; i < npages; i++) {
@@ -541,13 +542,11 @@ void *nfs_readdir_large_page(struct page **pages, unsigned int npages)
 			goto out_freepages;
 		pages[i] = page;
 	}
+	return 0;
 
-	ptr = vm_map_ram(pages, npages, 0, PAGE_KERNEL);
-	if (!IS_ERR_OR_NULL(ptr))
-		return ptr;
 out_freepages:
 	nfs_readdir_free_pagearray(pages, i);
-	return NULL;
+	return -ENOMEM;
 }
 
 static
@@ -577,8 +576,8 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 	memset(array, 0, sizeof(struct nfs_cache_array));
 	array->eof_index = -1;
 
-	pages_ptr = nfs_readdir_large_page(pages, array_size);
-	if (!pages_ptr)
+	status = nfs_readdir_large_page(pages, array_size);
+	if (status < 0)
 		goto out_release_array;
 	do {
 		unsigned int pglen;
@@ -587,7 +586,7 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 		if (status < 0)
 			break;
 		pglen = status;
-		status = nfs_readdir_page_filler(desc, &entry, pages_ptr, page, pglen);
+		status = nfs_readdir_page_filler(desc, &entry, pages, page, pglen);
 		if (status < 0) {
 			if (status == -ENOSPC)
 				status = 0;
diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index 5914a19..b382a1b 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -487,12 +487,6 @@ nfs_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry, struct nfs_se
 
 	entry->d_type = DT_UNKNOWN;
 
-	p = xdr_inline_peek(xdr, 8);
-	if (p != NULL)
-		entry->eof = !p[0] && p[1];
-	else
-		entry->eof = 0;
-
 	return p;
 
 out_overflow:
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index f6cc60f..ba91236 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -647,12 +647,6 @@ nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry, struct nfs_s
 			memset((u8*)(entry->fh), 0, sizeof(*entry->fh));
 	}
 
-	p = xdr_inline_peek(xdr, 8);
-	if (p != NULL)
-		entry->eof = !p[0] && p[1];
-	else
-		entry->eof = 0;
-
 	return p;
 
 out_overflow:
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 9f1826b..0662a98 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -6215,12 +6215,6 @@ __be32 *nfs4_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 	if (verify_attr_len(xdr, p, len) < 0)
 		goto out_overflow;
 
-	p = xdr_inline_peek(xdr, 8);
-	if (p != NULL)
-		entry->eof = !p[0] && p[1];
-	else
-		entry->eof = 0;
-
 	return p;
 
 out_overflow:
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 498ab93..7783c68 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -201,6 +201,8 @@ struct xdr_stream {
 
 	__be32 *end;		/* end of available buffer space */
 	struct kvec *iov;	/* pointer to the current kvec */
+	struct kvec scratch;	/* Scratch buffer */
+	struct page **page_ptr;	/* pointer to the current page */
 };
 
 extern void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p);
@@ -208,7 +210,7 @@ extern __be32 *xdr_reserve_space(struct xdr_stream *xdr, size_t nbytes);
 extern void xdr_write_pages(struct xdr_stream *xdr, struct page **pages,
 		unsigned int base, unsigned int len);
 extern void xdr_init_decode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p);
-extern __be32 *xdr_inline_peek(struct xdr_stream *xdr, size_t nbytes);
+extern void xdr_set_scratch_buffer(struct xdr_stream *xdr, void *buf, size_t buflen);
 extern __be32 *xdr_inline_decode(struct xdr_stream *xdr, size_t nbytes);
 extern void xdr_read_pages(struct xdr_stream *xdr, unsigned int len);
 extern void xdr_enter_page(struct xdr_stream *xdr, unsigned int len);
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index cd9e841..cff0974 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -569,29 +569,112 @@ void xdr_init_decode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p)
 	xdr->iov = iov;
 	xdr->p = p;
 	xdr->end = (__be32 *)((char *)iov->iov_base + len);
+	xdr->page_ptr = NULL;
+	xdr->scratch.iov_base = NULL;
+	xdr->scratch.iov_len = 0;
 }
 EXPORT_SYMBOL_GPL(xdr_init_decode);
 
 /**
- * xdr_inline_peek - Allow read-ahead in the XDR data stream
+ * xdr_set_scratch_buffer - Attach a scratch buffer for decoding data.
  * @xdr: pointer to xdr_stream struct
- * @nbytes: number of bytes of data to decode
+ * @buf: pointer to an empty buffer
+ * @buflen: size of 'buf'
  *
- * Check if the input buffer is long enough to enable us to decode
- * 'nbytes' more bytes of data starting at the current position.
- * If so return the current pointer without updating the current
- * pointer position.
+ * The scratch buffer is used when decoding from an array of pages.
+ * If an xdr_inline_decode() call spans across page boundaries, then
+ * we copy the data into the scratch buffer in order to allow linear
+ * access.
  */
-__be32 * xdr_inline_peek(struct xdr_stream *xdr, size_t nbytes)
+void xdr_set_scratch_buffer(struct xdr_stream *xdr, void *buf, size_t buflen)
+{
+	xdr->scratch.iov_base = buf;
+	xdr->scratch.iov_len = buflen;
+}
+EXPORT_SYMBOL_GPL(xdr_set_scratch_buffer);
+
+static int xdr_set_page_base(struct xdr_stream *xdr,
+		unsigned int base, unsigned int len)
+{
+	unsigned int pgnr;
+	unsigned int maxlen;
+	unsigned int pgoff;
+	unsigned int pgend;
+	void *kaddr;
+
+	maxlen = xdr->buf->page_len;
+	if (base >= maxlen)
+		return -EINVAL;
+	maxlen -= base;
+
+	if (len > maxlen)
+		len = maxlen;
+
+	base += xdr->buf->page_base;
+
+	pgnr = base >> PAGE_SHIFT;
+	xdr->page_ptr = &xdr->buf->pages[pgnr];
+	kaddr = page_address(*xdr->page_ptr);
+
+	pgoff = base & ~PAGE_MASK;
+	xdr->p = (__be32*)(kaddr + pgoff);
+
+	pgend = pgoff + len;
+	if (pgend > PAGE_SIZE)
+		pgend = PAGE_SIZE;
+	xdr->end = (__be32*)(kaddr + pgend);
+	return 0;
+}
+
+static int xdr_set_next_page(struct xdr_stream *xdr)
+{
+	unsigned int newbase;
+
+	newbase = (1 + xdr->page_ptr - xdr->buf->pages) << PAGE_SHIFT;
+	newbase -= xdr->buf->page_base;
+
+	return xdr_set_page_base(xdr, newbase, PAGE_SIZE);
+}
+
+static __be32 * __xdr_inline_decode(struct xdr_stream *xdr, size_t nbytes)
 {
 	__be32 *p = xdr->p;
 	__be32 *q = p + XDR_QUADLEN(nbytes);
 
 	if (unlikely(q > xdr->end || q < p))
 		return NULL;
+	xdr->p = q;
 	return p;
 }
-EXPORT_SYMBOL_GPL(xdr_inline_peek);
+
+static __be32 *xdr_page_inline_decode(struct xdr_stream *xdr, size_t nbytes)
+{
+	size_t cplen;
+	void *cpdest;
+	__be32 *p;
+
+	if (xdr->p == xdr->end && xdr_set_next_page(xdr) < 0)
+		return NULL;
+
+	p = __xdr_inline_decode(xdr, nbytes);
+	if (p != NULL)
+		return p;
+
+	if (nbytes > xdr->scratch.iov_len)
+		return NULL;
+	cplen = (char *)xdr->end - (char *)xdr->p;
+	cpdest = xdr->scratch.iov_base;
+	memcpy(cpdest, xdr->p, cplen);
+	cpdest += cplen;
+	nbytes -= cplen;
+	if (xdr_set_next_page(xdr) < 0)
+		return NULL;
+	p = __xdr_inline_decode(xdr, nbytes);
+	if (p == NULL)
+		return NULL;
+	memcpy(cpdest, p, nbytes);
+	return xdr->scratch.iov_base;
+}
 
 /**
  * xdr_inline_decode - Retrieve non-page XDR data to decode
@@ -605,13 +688,9 @@ EXPORT_SYMBOL_GPL(xdr_inline_peek);
  */
 __be32 * xdr_inline_decode(struct xdr_stream *xdr, size_t nbytes)
 {
-	__be32 *p = xdr->p;
-	__be32 *q = p + XDR_QUADLEN(nbytes);
-
-	if (unlikely(q > xdr->end || q < p))
-		return NULL;
-	xdr->p = q;
-	return p;
+	if (xdr->page_ptr == NULL)
+		return __xdr_inline_decode(xdr, nbytes);
+	return xdr_page_inline_decode(xdr, nbytes);
 }
 EXPORT_SYMBOL_GPL(xdr_inline_decode);
 
@@ -671,16 +750,12 @@ EXPORT_SYMBOL_GPL(xdr_read_pages);
  */
 void xdr_enter_page(struct xdr_stream *xdr, unsigned int len)
 {
-	char * kaddr = page_address(xdr->buf->pages[0]);
 	xdr_read_pages(xdr, len);
 	/*
 	 * Position current pointer at beginning of tail, and
 	 * set remaining message length.
 	 */
-	if (len > PAGE_CACHE_SIZE - xdr->buf->page_base)
-		len = PAGE_CACHE_SIZE - xdr->buf->page_base;
-	xdr->p = (__be32 *)(kaddr + xdr->buf->page_base);
-	xdr->end = (__be32 *)((char *)xdr->p + len);
+	xdr_set_page_base(xdr, 0, len);
 }
 EXPORT_SYMBOL_GPL(xdr_enter_page);
 
-- 
1.7.3.4



-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

