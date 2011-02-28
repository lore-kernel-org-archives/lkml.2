Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1B1VEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:04:25 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47113 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1B1VEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:04:24 -0500
From: Jim Keniston <jkenisto@us.ibm.com>
Subject: [PATCH] zlib: Slim down zlib_deflate workspace when possible
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Mon, 28 Feb 2011 13:04:20 -0800
Message-ID: <20110228210420.15417.41430.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of always creating a huge (268K) deflate_workspace with the
maximum compression parameters (windowBits=15, memLevel=8), allow the
caller to obtain a smaller workspace by specifying smaller parameter
values -- via zlib_deflate_workspacesize2().

For example, when capturing oops and panic reports to a medium with
limited capacity, such as NVRAM, compression may be the only way to
capture the whole report.  In this case, a small workspace (24K works
fine) is a win, whether you allocate the workspace when you need it
(i.e., during an oops or panic) or at boot time.

I've verified that this patch works with all accepted values of
windowBits (positive and negative), memLevel, and compression level;
and also via the existing zlib_deflate_workspacesize() /
zlib_deflateInit() interface.

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---

 include/linux/zlib.h            |   14 ++++++++++++--
 lib/zlib_deflate/deflate.c      |   33 ++++++++++++++++++++++++++++++++-
 lib/zlib_deflate/deflate_syms.c |    1 +
 lib/zlib_deflate/defutil.h      |   17 +++++++++++++----
 4 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/include/linux/zlib.h b/include/linux/zlib.h
index 40c49cb..3f15036 100644
--- a/include/linux/zlib.h
+++ b/include/linux/zlib.h
@@ -179,11 +179,21 @@ typedef z_stream *z_streamp;
 
                         /* basic functions */
 
+extern int zlib_deflate_workspacesize2 (int windowBits, int memLevel);
+/*
+   Returns the number of bytes that needs to be allocated for a per-
+   stream workspace with the specified parameters.  A pointer to this
+   number of bytes should be returned in stream->workspace before
+   calling zlib_deflateInit2(); and the windowBits and memLevel
+   parameters passed to zlib_deflateInit2() must not exceed those
+   passed here.
+*/
+
 extern int zlib_deflate_workspacesize (void);
 /*
    Returns the number of bytes that needs to be allocated for a per-
-   stream workspace.  A pointer to this number of bytes should be
-   returned in stream->workspace before calling zlib_deflateInit().
+   stream workspace with the default (large) windowBits and memLevel
+   parameters.
 */
 
 /* 
diff --git a/lib/zlib_deflate/deflate.c b/lib/zlib_deflate/deflate.c
index 46a31e5..cdb207a 100644
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
@@ -1249,5 +1265,20 @@ static block_state deflate_slow(
 
 int zlib_deflate_workspacesize(void)
 {
-    return sizeof(deflate_workspace);
+    return zlib_deflate_workspacesize2(MAX_WBITS, MAX_MEM_LEVEL);
+}
+
+int zlib_deflate_workspacesize2(int windowBits, int memLevel)
+{
+    if (windowBits < 0) /* undocumented feature: suppress zlib header */
+        windowBits = -windowBits;
+    if (memLevel < 1 || memLevel > MAX_MEM_LEVEL ||
+        windowBits < 9 || windowBits > 15)
+        return -1;
+
+    return sizeof(deflate_workspace)
+        + zlib_deflate_window_memsize(windowBits)
+        + zlib_deflate_prev_memsize(windowBits)
+        + zlib_deflate_head_memsize(memLevel)
+        + zlib_deflate_overlay_memsize(memLevel);
 }
diff --git a/lib/zlib_deflate/deflate_syms.c b/lib/zlib_deflate/deflate_syms.c
index ccfe25f..cdf1cdd 100644
--- a/lib/zlib_deflate/deflate_syms.c
+++ b/lib/zlib_deflate/deflate_syms.c
@@ -11,6 +11,7 @@
 #include <linux/zlib.h>
 
 EXPORT_SYMBOL(zlib_deflate_workspacesize);
+EXPORT_SYMBOL(zlib_deflate_workspacesize2);
 EXPORT_SYMBOL(zlib_deflate);
 EXPORT_SYMBOL(zlib_deflateInit2);
 EXPORT_SYMBOL(zlib_deflateEnd);
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

