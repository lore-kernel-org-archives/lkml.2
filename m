Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0IBMal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:30:41 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:51551 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0IBMak convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Thu, 2 Sep 2010 08:30:40 -0400
Message-Id: <4C7FB50D0200007800013F36@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 13:30:37 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>
Subject: [PATCH] use clear_page()/copy_page() in favor of
	 memset()/memcpy() on whole pages
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After all that's what they are intended for.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 fs/fuse/dev.c           |    2 +-
 kernel/kexec.c          |    2 +-
 kernel/power/snapshot.c |   14 +++++++-------
 kernel/power/swap.c     |    6 +++---
 mm/memory.c             |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

--- linux-2.6.36-rc3/fs/fuse/dev.c
+++ 2.6.36-rc3-use-clear_page/fs/fuse/dev.c
@@ -811,7 +811,7 @@ static int fuse_copy_page(struct fuse_co
 
 	if (page && zeroing && count < PAGE_SIZE) {
 		void *mapaddr = kmap_atomic(page, KM_USER1);
-		memset(mapaddr, 0, PAGE_SIZE);
+		clear_page(mapaddr);
 		kunmap_atomic(mapaddr, KM_USER1);
 	}
 	while (count) {
--- linux-2.6.36-rc3/kernel/kexec.c
+++ 2.6.36-rc3-use-clear_page/kernel/kexec.c
@@ -816,7 +816,7 @@ static int kimage_load_normal_segment(st
 
 		ptr = kmap(page);
 		/* Start with a clear page */
-		memset(ptr, 0, PAGE_SIZE);
+		clear_page(ptr);
 		ptr += maddr & ~PAGE_MASK;
 		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
 		if (mchunk > mbytes)
--- linux-2.6.36-rc3/kernel/power/snapshot.c
+++ 2.6.36-rc3-use-clear_page/kernel/power/snapshot.c
@@ -988,7 +988,7 @@ static void copy_data_page(unsigned long
 			 */
 			safe_copy_page(buffer, s_page);
 			dst = kmap_atomic(d_page, KM_USER0);
-			memcpy(dst, buffer, PAGE_SIZE);
+			copy_page(dst, buffer);
 			kunmap_atomic(dst, KM_USER0);
 		} else {
 			safe_copy_page(page_address(d_page), s_page);
@@ -1636,7 +1636,7 @@ int snapshot_read_next(struct snapshot_h
 		memory_bm_position_reset(&orig_bm);
 		memory_bm_position_reset(&copy_bm);
 	} else if (handle->cur <= nr_meta_pages) {
-		memset(buffer, 0, PAGE_SIZE);
+		clear_page(buffer);
 		pack_pfns(buffer, &orig_bm);
 	} else {
 		struct page *page;
@@ -1650,7 +1650,7 @@ int snapshot_read_next(struct snapshot_h
 			void *kaddr;
 
 			kaddr = kmap_atomic(page, KM_USER0);
-			memcpy(buffer, kaddr, PAGE_SIZE);
+			copy_page(buffer, kaddr);
 			kunmap_atomic(kaddr, KM_USER0);
 			handle->buffer = buffer;
 		} else {
@@ -1933,7 +1933,7 @@ static void copy_last_highmem_page(void)
 		void *dst;
 
 		dst = kmap_atomic(last_highmem_page, KM_USER0);
-		memcpy(dst, buffer, PAGE_SIZE);
+		copy_page(dst, buffer);
 		kunmap_atomic(dst, KM_USER0);
 		last_highmem_page = NULL;
 	}
@@ -2219,9 +2219,9 @@ swap_two_pages_data(struct page *p1, str
 
 	kaddr1 = kmap_atomic(p1, KM_USER0);
 	kaddr2 = kmap_atomic(p2, KM_USER1);
-	memcpy(buf, kaddr1, PAGE_SIZE);
-	memcpy(kaddr1, kaddr2, PAGE_SIZE);
-	memcpy(kaddr2, buf, PAGE_SIZE);
+	copy_page(buf, kaddr1);
+	copy_page(kaddr1, kaddr2);
+	copy_page(kaddr2, buf);
 	kunmap_atomic(kaddr1, KM_USER0);
 	kunmap_atomic(kaddr2, KM_USER1);
 }
--- linux-2.6.36-rc3/kernel/power/swap.c
+++ 2.6.36-rc3-use-clear_page/kernel/power/swap.c
@@ -249,7 +249,7 @@ static int write_page(void *buf, sector_
 	if (bio_chain) {
 		src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
 		if (src) {
-			memcpy(src, buf, PAGE_SIZE);
+			copy_page(src, buf);
 		} else {
 			WARN_ON_ONCE(1);
 			bio_chain = NULL;	/* Go synchronous */
@@ -323,7 +323,7 @@ static int swap_write_page(struct swap_m
 		error = write_page(handle->cur, handle->cur_swap, NULL);
 		if (error)
 			goto out;
-		memset(handle->cur, 0, PAGE_SIZE);
+		clear_page(handle->cur);
 		handle->cur_swap = offset;
 		handle->k = 0;
 	}
@@ -634,7 +634,7 @@ int swsusp_check(void)
 	hib_resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_READ);
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
-		memset(swsusp_header, 0, PAGE_SIZE);
+		clear_page(swsusp_header);
 		error = hib_bio_read_page(swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
--- linux-2.6.36-rc3/mm/memory.c
+++ 2.6.36-rc3-use-clear_page/mm/memory.c
@@ -2079,7 +2079,7 @@ static inline void cow_user_page(struct 
 		 * zeroes.
 		 */
 		if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE))
-			memset(kaddr, 0, PAGE_SIZE);
+			clear_page(kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		flush_dcache_page(dst);
 	} else


