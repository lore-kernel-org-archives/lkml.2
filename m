Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1CCBFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:05:08 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35805 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab1CCBFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:05:07 -0500
Subject: Re: [PATCH] zlib: Slim down zlib_deflate workspace when possible
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20110301163026.f1b5fa56.akpm@linux-foundation.org>
References: <20110228210420.15417.41430.stgit@localhost.localdomain>
	 <20110301163026.f1b5fa56.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 17:05:02 -0800
Message-ID: <1299114303.3627.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 16:30 -0800, Andrew Morton wrote:
> On Mon, 28 Feb 2011 13:04:20 -0800
> Jim Keniston <jkenisto@us.ibm.com> wrote:
> 
...
> > 
> > I've verified that this patch works with all accepted values of
> > windowBits (positive and negative), memLevel, and compression level;
> > and also via the existing zlib_deflate_workspacesize() /
> > zlib_deflateInit() interface.
> 
> zlib_deflate_workspacesize() has seven callsites.  Rather than creating
> the new zlib_deflate_workspacesize2() I suggest that you just add the
> two new args to zlib_deflate_workspacesize() and then adjust the
> existing callers.

Done.  In each case where they subsequently called zlib_deflateInit2(),
I used the window-bits and memory-level values from that call in my call
to zlib_deflate_workspacesize().

I also added a BUG_ON() call in zlib_deflate_workspacesize().
Previously it was returning -1 (which callers passed unchecked to
vmalloc()) on bad input.

See updated patch below.

> 
> > 
> > diff --git a/include/linux/zlib.h b/include/linux/zlib.h
> > index 40c49cb..3f15036 100644
> > --- a/include/linux/zlib.h
> > +++ b/include/linux/zlib.h
> > @@ -179,11 +179,21 @@ typedef z_stream *z_streamp;
> >  
> >                          /* basic functions */
> >  
> > +extern int zlib_deflate_workspacesize2 (int windowBits, int memLevel);
> > +/*
> > +   Returns the number of bytes that needs to be allocated for a per-
> > +   stream workspace with the specified parameters.  A pointer to this
> > +   number of bytes should be returned in stream->workspace before
> > +   calling zlib_deflateInit2(); and the windowBits and memLevel
> > +   parameters passed to zlib_deflateInit2() must not exceed those
> > +   passed here.
> > +*/
> 
> Wait.  The (unspeakably poxy) zlib code puts comments *after* the thing
> which they're commenting on?

Yes.

> Who did that

  Jean-loup Gailly        Mark Adler
  jloup@gzip.org          madler@alumni.caltech.edu

> and is he bigger than me?

Maybe not, but there are two of them. :-)

Thanks.
Jim
=====
Instead of always creating a huge (268K) deflate_workspace with the
maximum compression parameters (windowBits=15, memLevel=8), allow the
caller to obtain a smaller workspace by specifying smaller parameter
values.

For example, when capturing oops and panic reports to a medium with
limited capacity, such as NVRAM, compression may be the only way to
capture the whole report. In this case, a small workspace (24K works
fine) is a win, whether you allocate the workspace when you need it
(i.e., during an oops or panic) or at boot time.

I've verified that this patch works with all accepted values of
windowBits (positive and negative), memLevel, and compression level.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---

 crypto/deflate.c           |    3 ++-
 crypto/zlib.c              |   18 +++++++++++-------
 drivers/net/ppp_deflate.c  |    2 +-
 fs/btrfs/zlib.c            |    3 ++-
 fs/jffs2/compr_zlib.c      |    7 ++++---
 fs/logfs/compr.c           |    2 +-
 include/linux/zlib.h       |   11 ++++++++---
 lib/zlib_deflate/deflate.c |   31 +++++++++++++++++++++++++++++--
 lib/zlib_deflate/defutil.h |   17 +++++++++++++----
 9 files changed, 71 insertions(+), 23 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index cbc7a33..b5ccae2 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -48,7 +48,8 @@ static int deflate_comp_init(struct deflate_ctx *ctx)
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->comp_stream;
 
-	stream->workspace = vzalloc(zlib_deflate_workspacesize());
+	stream->workspace = vzalloc(zlib_deflate_workspacesize(
+				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL));
 	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/crypto/zlib.c b/crypto/zlib.c
index 739b8fc..d11d761 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -85,6 +85,7 @@ static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
 	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
 	struct z_stream_s *stream = &ctx->comp_stream;
 	struct nlattr *tb[ZLIB_COMP_MAX + 1];
+	int window_bits, mem_level;
 	size_t workspacesize;
 	int ret;
 
@@ -94,7 +95,14 @@ static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
 
 	zlib_comp_exit(ctx);
 
-	workspacesize = zlib_deflate_workspacesize();
+	window_bits = tb[ZLIB_COMP_WINDOWBITS]
+					? nla_get_u32(tb[ZLIB_COMP_WINDOWBITS])
+					: MAX_WBITS;
+	mem_level = tb[ZLIB_COMP_MEMLEVEL]
+					? nla_get_u32(tb[ZLIB_COMP_MEMLEVEL])
+					: DEF_MEM_LEVEL;
+
+	workspacesize = zlib_deflate_workspacesize(window_bits, mem_level);
 	stream->workspace = vzalloc(workspacesize);
 	if (!stream->workspace)
 		return -ENOMEM;
@@ -106,12 +114,8 @@ static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
 				tb[ZLIB_COMP_METHOD]
 					? nla_get_u32(tb[ZLIB_COMP_METHOD])
 					: Z_DEFLATED,
-				tb[ZLIB_COMP_WINDOWBITS]
-					? nla_get_u32(tb[ZLIB_COMP_WINDOWBITS])
-					: MAX_WBITS,
-				tb[ZLIB_COMP_MEMLEVEL]
-					? nla_get_u32(tb[ZLIB_COMP_MEMLEVEL])
-					: DEF_MEM_LEVEL,
+				window_bits,
+				mem_level,
 				tb[ZLIB_COMP_STRATEGY]
 					? nla_get_u32(tb[ZLIB_COMP_STRATEGY])
 					: Z_DEFAULT_STRATEGY);
diff --git a/drivers/net/ppp_deflate.c b/drivers/net/ppp_deflate.c
index 4358330..31e9407 100644
--- a/drivers/net/ppp_deflate.c
+++ b/drivers/net/ppp_deflate.c
@@ -129,7 +129,7 @@ static void *z_comp_alloc(unsigned char *options, int opt_len)
 
 	state->strm.next_in   = NULL;
 	state->w_size         = w_size;
-	state->strm.workspace = vmalloc(zlib_deflate_workspacesize());
+	state->strm.workspace = vmalloc(zlib_deflate_workspacesize(-w_size, 8));
 	if (state->strm.workspace == NULL)
 		goto out_free;
 
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index f5ec2d4..faccd47 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -57,7 +57,8 @@ static struct list_head *zlib_alloc_workspace(void)
 	if (!workspace)
 		return ERR_PTR(-ENOMEM);
 
-	workspace->def_strm.workspace = vmalloc(zlib_deflate_workspacesize());
+	workspace->def_strm.workspace = vmalloc(zlib_deflate_workspacesize(
+						MAX_WBITS, MAX_MEM_LEVEL));
 	workspace->inf_strm.workspace = vmalloc(zlib_inflate_workspacesize());
 	workspace->buf = kmalloc(PAGE_CACHE_SIZE, GFP_NOFS);
 	if (!workspace->def_strm.workspace ||
diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index fd05a0b..5a00102 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -40,12 +40,13 @@ static z_stream inf_strm, def_strm;
 
 static int __init alloc_workspaces(void)
 {
-	def_strm.workspace = vmalloc(zlib_deflate_workspacesize());
+	def_strm.workspace = vmalloc(zlib_deflate_workspacesize(MAX_WBITS,
+							MAX_MEM_LEVEL));
 	if (!def_strm.workspace) {
-		printk(KERN_WARNING "Failed to allocate %d bytes for deflate workspace\n", zlib_deflate_workspacesize());
+		printk(KERN_WARNING "Failed to allocate %d bytes for deflate workspace\n", zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL));
 		return -ENOMEM;
 	}
-	D1(printk(KERN_DEBUG "Allocated %d bytes for deflate workspace\n", zlib_deflate_workspacesize()));
+	D1(printk(KERN_DEBUG "Allocated %d bytes for deflate workspace\n", zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL)));
 	inf_strm.workspace = vmalloc(zlib_inflate_workspacesize());
 	if (!inf_strm.workspace) {
 		printk(KERN_WARNING "Failed to allocate %d bytes for inflate workspace\n", zlib_inflate_workspacesize());
diff --git a/fs/logfs/compr.c b/fs/logfs/compr.c
index 44bbfd2..961f02b 100644
--- a/fs/logfs/compr.c
+++ b/fs/logfs/compr.c
@@ -81,7 +81,7 @@ error:
 
 int __init logfs_compr_init(void)
 {
-	size_t size = max(zlib_deflate_workspacesize(),
+	size_t size = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
 			zlib_inflate_workspacesize());
 	stream.workspace = vmalloc(size);
 	if (!stream.workspace)
diff --git a/include/linux/zlib.h b/include/linux/zlib.h
index 40c49cb..9c5a6b4 100644
--- a/include/linux/zlib.h
+++ b/include/linux/zlib.h
@@ -179,11 +179,16 @@ typedef z_stream *z_streamp;
 
                         /* basic functions */
 
-extern int zlib_deflate_workspacesize (void);
+extern int zlib_deflate_workspacesize (int windowBits, int memLevel);
 /*
    Returns the number of bytes that needs to be allocated for a per-
-   stream workspace.  A pointer to this number of bytes should be
-   returned in stream->workspace before calling zlib_deflateInit().
+   stream workspace with the specified parameters.  A pointer to this
+   number of bytes should be returned in stream->workspace before
+   you call zlib_deflateInit() or zlib_deflateInit2().  If you call
+   zlib_deflateInit(), specify windowBits = MAX_WBITS and memLevel =
+   MAX_MEM_LEVEL here.  If you call zlib_deflateInit2(), the windowBits
+   and memLevel parameters passed to zlib_deflateInit2() must not
+   exceed those passed here.
 */
 
 /* 
diff --git a/lib/zlib_deflate/deflate.c b/lib/zlib_deflate/deflate.c
index 46a31e5..eeb5cb2 100644
--- a/lib/zlib_deflate/deflate.c
+++ b/lib/zlib_deflate/deflate.c
@@ -176,6 +176,7 @@ int zlib_deflateInit2(
     deflate_state *s;
     int noheader = 0;
     deflate_workspace *mem;
+    char *next;
 
     ush *overlay;
     /* We overlay pending_buf and d_buf+l_buf. This works since the average
@@ -199,6 +200,21 @@ int zlib_deflateInit2(
 	strategy < 0 || strategy > Z_HUFFMAN_ONLY) {
         return Z_STREAM_ERROR;
     }
+
+    /*
+     * Direct the workspace's pointers to the chunks that were allocated
+     * along with the deflate_workspace struct.
+     */
+    next = (char *) mem;
+    next += sizeof(*mem);
+    mem->window_memory = (Byte *) next;
+    next += zlib_deflate_window_memsize(windowBits);
+    mem->prev_memory = (Pos *) next;
+    next += zlib_deflate_prev_memsize(windowBits);
+    mem->head_memory = (Pos *) next;
+    next += zlib_deflate_head_memsize(memLevel);
+    mem->overlay_memory = next;
+
     s = (deflate_state *) &(mem->deflate_memory);
     strm->state = (struct internal_state *)s;
     s->strm = strm;
@@ -1247,7 +1263,18 @@ static block_state deflate_slow(
     return flush == Z_FINISH ? finish_done : block_done;
 }
 
-int zlib_deflate_workspacesize(void)
+int zlib_deflate_workspacesize(int windowBits, int memLevel)
 {
-    return sizeof(deflate_workspace);
+    if (windowBits < 0) /* undocumented feature: suppress zlib header */
+        windowBits = -windowBits;
+
+    /* Since the return value is typically passed to vmalloc() unchecked... */
+    BUG_ON(memLevel < 1 || memLevel > MAX_MEM_LEVEL || windowBits < 9 ||
+    							windowBits > 15);
+
+    return sizeof(deflate_workspace)
+        + zlib_deflate_window_memsize(windowBits)
+        + zlib_deflate_prev_memsize(windowBits)
+        + zlib_deflate_head_memsize(memLevel)
+        + zlib_deflate_overlay_memsize(memLevel);
 }
diff --git a/lib/zlib_deflate/defutil.h b/lib/zlib_deflate/defutil.h
index 6b15a90..b640b64 100644
--- a/lib/zlib_deflate/defutil.h
+++ b/lib/zlib_deflate/defutil.h
@@ -241,12 +241,21 @@ typedef struct deflate_state {
 typedef struct deflate_workspace {
     /* State memory for the deflator */
     deflate_state deflate_memory;
-    Byte window_memory[2 * (1 << MAX_WBITS)];
-    Pos prev_memory[1 << MAX_WBITS];
-    Pos head_memory[1 << (MAX_MEM_LEVEL + 7)];
-    char overlay_memory[(1 << (MAX_MEM_LEVEL + 6)) * (sizeof(ush)+2)];
+    Byte *window_memory;
+    Pos *prev_memory;
+    Pos *head_memory;
+    char *overlay_memory;
 } deflate_workspace;
 
+#define zlib_deflate_window_memsize(windowBits) \
+	(2 * (1 << (windowBits)) * sizeof(Byte))
+#define zlib_deflate_prev_memsize(windowBits) \
+	((1 << (windowBits)) * sizeof(Pos))
+#define zlib_deflate_head_memsize(memLevel) \
+	((1 << ((memLevel)+7)) * sizeof(Pos))
+#define zlib_deflate_overlay_memsize(memLevel) \
+	((1 << ((memLevel)+6)) * (sizeof(ush)+2))
+
 /* Output a byte on the stream.
  * IN assertion: there is enough room in pending_buf.
  */


