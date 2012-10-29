Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab2J2VhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:37:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:47335 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab2J2Vg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>
Subject: [ 027/101] staging: zram: Fix handling of incompressible pages
Date: Mon, 29 Oct 2012 14:34:40 -0700
Message-Id: <20121029213243.230097797@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gupta <ngupta@vflare.org>

commit c8f2f0db1d0294aaf37e8a85bea9bbc4aaf5c0fe upstream.

Change 130f315a (staging: zram: remove special handle of uncompressed page)
introduced a bug in the handling of incompressible pages which resulted in
memory allocation failure for such pages.

When a page expands on compression, say from 4K to 4K+30, we were trying to
do zsmalloc(pool, 4K+30). However, the maximum size which zsmalloc can
allocate is PAGE_SIZE (for obvious reasons), so such allocation requests
always return failure (0).

For a page that has compressed size larger than the original size (this may
happen with already compressed or random data), there is no point storing
the compressed version as that would take more space and would also require
time for decompression when needed again. So, the fix is to store any page,
whose compressed size exceeds a threshold (max_zpage_size), as-it-is i.e.
without compression.  Memory required for storing this uncompressed page can
then be requested from zsmalloc which supports PAGE_SIZE sized allocations.

Lastly, the fix checks that we do not attempt to "decompress" the page which
we stored in the uncompressed form -- we just memcpy() out such pages.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reported-by: viechweg@gmail.com
Reported-by: paerley@gmail.com
Reported-by: wu.tommy@gmail.com
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -223,8 +223,13 @@ static int zram_bvec_read(struct zram *z
 	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle,
 				ZS_MM_RO);
 
-	ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
+	if (zram->table[index].size == PAGE_SIZE) {
+		memcpy(uncmem, cmem, PAGE_SIZE);
+		ret = LZO_E_OK;
+	} else {
+		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
 				    uncmem, &clen);
+	}
 
 	if (is_partial_io(bvec)) {
 		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
@@ -342,8 +347,11 @@ static int zram_bvec_write(struct zram *
 		goto out;
 	}
 
-	if (unlikely(clen > max_zpage_size))
+	if (unlikely(clen > max_zpage_size)) {
 		zram_stat_inc(&zram->stats.bad_compress);
+		src = uncmem;
+		clen = PAGE_SIZE;
+	}
 
 	handle = zs_malloc(zram->mem_pool, clen);
 	if (!handle) {


