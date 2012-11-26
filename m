Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab2KZRJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:09:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab2KZRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:18 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 151/270] ceph: avoid 32-bit page index overflow
Date: Mon, 26 Nov 2012 14:57:21 -0200
Message-Id: <1353949160-26803-152-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 6285bc231277419255f3498d3eb5ddc9f8e7fe79 upstream.

A pgoff_t is defined (by default) to have type (unsigned long).  On
architectures such as i686 that's a 32-bit type.  The ceph address
space code was attempting to produce 64 bit offsets by shifting a
page's index by PAGE_CACHE_SHIFT, but the result was not what was
desired because the shift occurred before the result got promoted
to 64 bits.

Fix this by converting all uses of page->index used in this way to
use the page_offset() macro, which ensures the 64-bit result has the
intended value.

This fixes http://tracker.newdream.net/issues/3112

Reported-by:  Mohamed Pakkeer <pakkeer.mohideen@realimage.com>
Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ceph/addr.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8b67304..32ee086 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -205,7 +205,7 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 	dout("readpage inode %p file %p page %p index %lu\n",
 	     inode, filp, page, page->index);
 	err = ceph_osdc_readpages(osdc, ceph_vino(inode), &ci->i_layout,
-				  page->index << PAGE_CACHE_SHIFT, &len,
+				  (u64) page_offset(page), &len,
 				  ci->i_truncate_seq, ci->i_truncate_size,
 				  &page, 1, 0);
 	if (err == -ENOENT)
@@ -286,7 +286,7 @@ static int start_read(struct inode *inode, struct list_head *page_list, int max)
 	int nr_pages = 0;
 	int ret;
 
-	off = page->index << PAGE_CACHE_SHIFT;
+	off = (u64) page_offset(page);
 
 	/* count pages */
 	next_index = page->index;
@@ -426,7 +426,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	struct ceph_inode_info *ci;
 	struct ceph_fs_client *fsc;
 	struct ceph_osd_client *osdc;
-	loff_t page_off = page->index << PAGE_CACHE_SHIFT;
+	loff_t page_off = page_offset(page);
 	int len = PAGE_CACHE_SIZE;
 	loff_t i_size;
 	int err = 0;
@@ -817,8 +817,7 @@ get_more_pages:
 			/* ok */
 			if (locked_pages == 0) {
 				/* prepare async write request */
-				offset = (unsigned long long)page->index
-					<< PAGE_CACHE_SHIFT;
+				offset = (u64) page_offset(page);
 				len = wsize;
 				req = ceph_osdc_new_request(&fsc->client->osdc,
 					    &ci->i_layout,
@@ -1180,7 +1179,7 @@ static int ceph_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct inode *inode = vma->vm_file->f_dentry->d_inode;
 	struct page *page = vmf->page;
 	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
-	loff_t off = page->index << PAGE_CACHE_SHIFT;
+	loff_t off = page_offset(page);
 	loff_t size, len;
 	int ret;
 
-- 
1.7.9.5

