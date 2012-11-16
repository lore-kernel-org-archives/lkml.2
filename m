Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2KPRJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:09:54 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:35105 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab2KPRJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:09:52 -0500
Subject: [PATCH 09/14] fuse: Implement writepages and write_begin/write_end
 callbacks
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        xemul@openvz.org
Date: Fri, 16 Nov 2012 21:09:39 +0400
Message-ID: <20121116170931.3196.41872.stgit@maximpc.sw.ru>
In-Reply-To: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .writepages one is required to make each writeback request carry more than
one page on it.

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |  251 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 250 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index de9726a..3274708 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -718,7 +718,10 @@ static void fuse_send_readpages(struct fuse_req *req, struct file *file)
 
 struct fuse_fill_data {
 	struct fuse_req *req;
-	struct file *file;
+	union {
+		struct file *file;
+		struct fuse_file *ff;
+	};
 	struct inode *inode;
 };
 
@@ -1427,6 +1430,249 @@ static int fuse_writepage(struct page *page, struct writeback_control *wbc)
 	return err;
 }
 
+static int fuse_send_writepages(struct fuse_fill_data *data)
+{
+	int i, all_ok = 1;
+	struct fuse_req *req = data->req;
+	struct inode *inode = data->inode;
+	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	loff_t off = -1;
+
+	if (!data->ff)
+		data->ff = fuse_write_file(fc, fi);
+
+	if (!data->ff) {
+		for (i = 0; i < req->num_pages; i++)
+			end_page_writeback(req->pages[i]);
+		return -EIO;
+	}
+
+	req->inode = inode;
+	req->misc.write.in.offset = page_offset(req->pages[0]);
+
+	spin_lock(&fc->lock);
+	list_add(&req->writepages_entry, &fi->writepages);
+	spin_unlock(&fc->lock);
+
+	for (i = 0; i < req->num_pages; i++) {
+		struct page *page = req->pages[i];
+		struct page *tmp_page;
+
+		tmp_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+		if (tmp_page) {
+			copy_highpage(tmp_page, page);
+			inc_bdi_stat(bdi, BDI_WRITEBACK);
+			inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
+		} else
+			all_ok = 0;
+		req->pages[i] = tmp_page;
+		if (i == 0)
+			off = page_offset(page);
+
+		end_page_writeback(page);
+	}
+
+	if (!all_ok) {
+		for (i = 0; i < req->num_pages; i++) {
+			struct page *page = req->pages[i];
+			if (page) {
+				dec_bdi_stat(bdi, BDI_WRITEBACK);
+				dec_zone_page_state(page, NR_WRITEBACK_TEMP);
+				__free_page(page);
+				req->pages[i] = NULL;
+			}
+		}
+
+		spin_lock(&fc->lock);
+		list_del(&req->writepages_entry);
+		wake_up(&fi->page_waitq);
+		spin_unlock(&fc->lock);
+		return -ENOMEM;
+	}
+
+	req->ff = fuse_file_get(data->ff);
+	fuse_write_fill(req, data->ff, off, 0);
+
+	req->misc.write.in.write_flags |= FUSE_WRITE_CACHE;
+	req->in.argpages = 1;
+	req->page_offset = 0;
+	req->end = fuse_writepage_end;
+
+	spin_lock(&fc->lock);
+	list_add_tail(&req->list, &fi->queued_writes);
+	fuse_flush_writepages(data->inode);
+	spin_unlock(&fc->lock);
+
+	return 0;
+}
+
+static int fuse_writepages_fill(struct page *page,
+		struct writeback_control *wbc, void *_data)
+{
+	struct fuse_fill_data *data = _data;
+	struct fuse_req *req = data->req;
+	struct inode *inode = data->inode;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	if (fuse_page_is_writeback(inode, page->index)) {
+		if (wbc->sync_mode != WB_SYNC_ALL) {
+			redirty_page_for_writepage(wbc, page);
+			unlock_page(page);
+			return 0;
+		}
+		fuse_wait_on_page_writeback(inode, page->index);
+	}
+
+	if (req->num_pages &&
+	    (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
+	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_write ||
+	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
+		int err;
+
+		err = fuse_send_writepages(data);
+		if (err) {
+			unlock_page(page);
+			return err;
+		}
+
+		data->req = req = fuse_request_alloc_nofs();
+		if (!req) {
+			unlock_page(page);
+			return -ENOMEM;
+		}
+	}
+
+	req->pages[req->num_pages] = page;
+	req->num_pages++;
+
+	if (test_set_page_writeback(page))
+		BUG();
+
+	unlock_page(page);
+
+	return 0;
+}
+
+static int fuse_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_fill_data data;
+	int err;
+
+	if (!fc->writeback_cache)
+		return generic_writepages(mapping, wbc);
+
+	err = -EIO;
+	if (is_bad_inode(inode))
+		goto out;
+
+	data.ff = NULL;
+	data.inode = inode;
+	data.req = fuse_request_alloc_nofs();
+	err = -ENOMEM;
+	if (!data.req)
+		goto out_put;
+
+	err = write_cache_pages(mapping, wbc, fuse_writepages_fill, &data);
+	if (data.req) {
+		if (!err && data.req->num_pages) {
+			err = fuse_send_writepages(&data);
+			if (err)
+				fuse_put_request(fc, data.req);
+		} else
+			fuse_put_request(fc, data.req);
+	}
+out_put:
+	if (data.ff)
+		fuse_file_put(data.ff, false);
+out:
+	return err;
+}
+
+static int fuse_prepare_write(struct fuse_conn *fc, struct file *file,
+		struct page *page, loff_t pos, unsigned len)
+{
+	struct fuse_req *req;
+	int err;
+
+	if (PageUptodate(page) || (len == PAGE_CACHE_SIZE))
+		return 0;
+
+	/*
+	 * Page writeback can extend beyond the lifetime of the
+	 * page-cache page, so make sure we read a properly synced
+	 * page.
+	 */
+	fuse_wait_on_page_writeback(page->mapping->host, page->index);
+
+	req = fuse_get_req(fc);
+	err = PTR_ERR(req);
+	if (IS_ERR(req))
+		goto out;
+
+	req->out.page_zeroing = 1;
+	req->out.argpages = 1;
+	req->num_pages = 1;
+	req->pages[0] = page;
+	fuse_send_read(req, file, page_offset(page), PAGE_CACHE_SIZE, NULL);
+	err = req->out.h.error;
+	fuse_put_request(fc, req);
+out:
+	if (err) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	return err;
+}
+
+static int fuse_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
+{
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	struct fuse_conn *fc = get_fuse_conn(file->f_dentry->d_inode);
+
+	BUG_ON(!fc->writeback_cache);
+
+	*pagep = grab_cache_page_write_begin(mapping, index, flags);
+	if (!*pagep)
+		return -ENOMEM;
+
+	return fuse_prepare_write(fc, file, *pagep, pos, len);
+}
+
+static int fuse_commit_write(struct file *file, struct page *page,
+		unsigned from, unsigned to)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
+
+	fuse_write_update_size(inode, pos);
+	set_page_dirty(page);
+	return 0;
+}
+
+static int fuse_write_end(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned copied,
+		struct page *page, void *fsdata)
+{
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+
+	fuse_commit_write(file, page, from, from+copied);
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	return copied;
+}
+
 static int fuse_launder_page(struct page *page)
 {
 	int err = 0;
@@ -2364,11 +2610,14 @@ static const struct file_operations fuse_direct_io_file_operations = {
 static const struct address_space_operations fuse_file_aops  = {
 	.readpage	= fuse_readpage,
 	.writepage	= fuse_writepage,
+	.writepages	= fuse_writepages,
 	.launder_page	= fuse_launder_page,
 	.readpages	= fuse_readpages,
 	.set_page_dirty	= __set_page_dirty_nobuffers,
 	.bmap		= fuse_bmap,
 	.direct_IO	= fuse_direct_IO,
+	.write_begin	= fuse_write_begin,
+	.write_end	= fuse_write_end,
 };
 
 void fuse_init_file_inode(struct inode *inode)

