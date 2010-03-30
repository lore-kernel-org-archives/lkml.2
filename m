Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0C3XpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:45:04 -0400
Received: from kroah.org ([198.145.64.141]:46106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0C3XUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:10 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:00 2010
Message-Id: <20100330224759.456100384@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [060/156] NFS: Avoid a deadlock in nfs_release_page
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit bb6fbc4548b9ae7ebbd06ef72f00229df259d217 upstream.

J.R. Okajima reports the following deadlock:

INFO: task kswapd0:305 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kswapd0       D 0000000000000001     0   305      2 0x00000000
 ffff88001f21d4f0 0000000000000046 ffff88001fdea680 ffff88001f21c000
 ffff88001f21dfd8 ffff88001f21c000 ffff88001f21dfd8 ffff88001f21dfd8
 ffff88001fdea040 0000000000014c00 0000000000000001 ffff88001fdea040
Call Trace:
 [<ffffffff8146155d>] io_schedule+0x4d/0x70
 [<ffffffff810d2be5>] sync_page+0x65/0xa0
 [<ffffffff81461b12>] __wait_on_bit_lock+0x52/0xb0
 [<ffffffff810d2b80>] ? sync_page+0x0/0xa0
 [<ffffffff810d2b64>] __lock_page+0x64/0x70
 [<ffffffff81070ce0>] ? wake_bit_function+0x0/0x40
 [<ffffffff810df1d4>] truncate_inode_pages_range+0x344/0x4a0
 [<ffffffff810df340>] truncate_inode_pages+0x10/0x20
 [<ffffffff8112cbfe>] generic_delete_inode+0x15e/0x190
 [<ffffffff8112cc8d>] generic_drop_inode+0x5d/0x80
 [<ffffffff8112bb88>] iput+0x78/0x80
 [<ffffffff811bc908>] nfs_dentry_iput+0x38/0x50
 [<ffffffff811285f4>] dentry_iput+0x84/0x110
 [<ffffffff811286ae>] d_kill+0x2e/0x60
 [<ffffffff8112912a>] dput+0x7a/0x170
 [<ffffffff8111e925>] path_put+0x15/0x40
 [<ffffffff811c3a44>] __put_nfs_open_context+0xa4/0xb0
 [<ffffffff811cb5d0>] ? nfs_free_request+0x0/0x50
 [<ffffffff811c3b0b>] put_nfs_open_context+0xb/0x10
 [<ffffffff811cb5f9>] nfs_free_request+0x29/0x50
 [<ffffffff81234b7e>] kref_put+0x8e/0xe0
 [<ffffffff811cb594>] nfs_release_request+0x14/0x20
 [<ffffffff811cf769>] nfs_find_and_lock_request+0x89/0xa0
 [<ffffffff811d1180>] nfs_wb_page+0x80/0x110
 [<ffffffff811c0770>] nfs_release_page+0x70/0x90
 [<ffffffff810d18ee>] try_to_release_page+0x5e/0x80
 [<ffffffff810e1178>] shrink_page_list+0x638/0x860
 [<ffffffff810e19de>] shrink_zone+0x63e/0xc40

We can fix this by making the call to put_nfs_open_context() happen when we
actually remove the write request from the inode (which is done by the
nfsiod thread in this case).

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/pagelist.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -112,12 +112,10 @@ void nfs_unlock_request(struct nfs_page
  */
 int nfs_set_page_tag_locked(struct nfs_page *req)
 {
-	struct nfs_inode *nfsi = NFS_I(req->wb_context->path.dentry->d_inode);
-
 	if (!nfs_lock_request_dontget(req))
 		return 0;
 	if (req->wb_page != NULL)
-		radix_tree_tag_set(&nfsi->nfs_page_tree, req->wb_index, NFS_PAGE_TAG_LOCKED);
+		radix_tree_tag_set(&NFS_I(req->wb_context->path.dentry->d_inode)->nfs_page_tree, req->wb_index, NFS_PAGE_TAG_LOCKED);
 	return 1;
 }
 
@@ -126,10 +124,10 @@ int nfs_set_page_tag_locked(struct nfs_p
  */
 void nfs_clear_page_tag_locked(struct nfs_page *req)
 {
-	struct inode *inode = req->wb_context->path.dentry->d_inode;
-	struct nfs_inode *nfsi = NFS_I(inode);
-
 	if (req->wb_page != NULL) {
+		struct inode *inode = req->wb_context->path.dentry->d_inode;
+		struct nfs_inode *nfsi = NFS_I(inode);
+
 		spin_lock(&inode->i_lock);
 		radix_tree_tag_clear(&nfsi->nfs_page_tree, req->wb_index, NFS_PAGE_TAG_LOCKED);
 		nfs_unlock_request(req);
@@ -142,16 +140,22 @@ void nfs_clear_page_tag_locked(struct nf
  * nfs_clear_request - Free up all resources allocated to the request
  * @req:
  *
- * Release page resources associated with a write request after it
- * has completed.
+ * Release page and open context resources associated with a read/write
+ * request after it has completed.
  */
 void nfs_clear_request(struct nfs_page *req)
 {
 	struct page *page = req->wb_page;
+	struct nfs_open_context *ctx = req->wb_context;
+
 	if (page != NULL) {
 		page_cache_release(page);
 		req->wb_page = NULL;
 	}
+	if (ctx != NULL) {
+		put_nfs_open_context(ctx);
+		req->wb_context = NULL;
+	}
 }
 
 
@@ -165,9 +169,8 @@ static void nfs_free_request(struct kref
 {
 	struct nfs_page *req = container_of(kref, struct nfs_page, wb_kref);
 
-	/* Release struct file or cached credential */
+	/* Release struct file and open context */
 	nfs_clear_request(req);
-	put_nfs_open_context(req->wb_context);
 	nfs_page_free(req);
 }
 


