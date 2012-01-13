Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab2AMRHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 12:07:14 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59884 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab2AMRHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 12:07:00 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, htejun@gmail.com,
        david.henningsson@canonical.com, smcnam@gmail.com,
        gmane@colin.guthr.ie, jamescaldwell1@gmail.com,
        s.maddox@lantizia.me.uk, mszeredi@suse.cz
Subject: [PATCH 1/2] fuse: create fuse_conn_operations
Date: Fri, 13 Jan 2012 18:06:38 +0100
Message-Id: <1326474399-27278-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1326474399-27278-1-git-send-email-miklos@szeredi.hu>
References: <1326474399-27278-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Create a fuse_conn_operations structure that lets cuse implement its
own notify_store and notify_retrieve operations.

The "release" operation is also moved to this structure.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/cuse.c   |    6 ++-
 fs/fuse/dev.c    |  153 +++-----------------------------------------------
 fs/fuse/fuse_i.h |   28 ++++++++-
 fs/fuse/inode.c  |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 202 insertions(+), 151 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 3426521..53df9fe 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -461,6 +461,10 @@ static void cuse_fc_release(struct fuse_conn *fc)
 	kfree(cc);
 }
 
+static const struct fuse_conn_operations cuse_ops = {
+	.release = cuse_fc_release,
+};
+
 /**
  * cuse_channel_open - open method for /dev/cuse
  * @inode: inode for /dev/cuse
@@ -489,7 +493,7 @@ static int cuse_channel_open(struct inode *inode, struct file *file)
 	fuse_conn_init(&cc->fc);
 
 	INIT_LIST_HEAD(&cc->list);
-	cc->fc.release = cuse_fc_release;
+	cc->fc.ops = &cuse_ops;
 
 	cc->fc.connected = 1;
 	cc->fc.blocked = 0;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5f3368a..f1f5994 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -201,6 +201,7 @@ struct fuse_req *fuse_get_req_nofail(struct fuse_conn *fc, struct file *file)
 	req->waiting = 1;
 	return req;
 }
+EXPORT_SYMBOL_GPL(fuse_get_req_nofail);
 
 void fuse_put_request(struct fuse_conn *fc, struct fuse_req *req)
 {
@@ -463,8 +464,8 @@ void fuse_request_send_background(struct fuse_conn *fc, struct fuse_req *req)
 }
 EXPORT_SYMBOL_GPL(fuse_request_send_background);
 
-static int fuse_request_send_notify_reply(struct fuse_conn *fc,
-					  struct fuse_req *req, u64 unique)
+int fuse_request_send_notify_reply(struct fuse_conn *fc,
+				   struct fuse_req *req, u64 unique)
 {
 	int err = -ENODEV;
 
@@ -813,8 +814,8 @@ static int fuse_ref_page(struct fuse_copy_state *cs, struct page *page,
  * Copy a page in the request to/from the userspace buffer.  Must be
  * done atomically
  */
-static int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
-			  unsigned offset, unsigned count, int zeroing)
+int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
+		   unsigned offset, unsigned count, int zeroing)
 {
 	int err;
 	struct page *page = *pagep;
@@ -1445,15 +1446,7 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 			     struct fuse_copy_state *cs)
 {
 	struct fuse_notify_store_out outarg;
-	struct inode *inode;
-	struct address_space *mapping;
-	u64 nodeid;
 	int err;
-	pgoff_t index;
-	unsigned int offset;
-	unsigned int num;
-	loff_t file_size;
-	loff_t end;
 
 	err = -EINVAL;
 	if (size < sizeof(outarg))
@@ -1467,137 +1460,18 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 	if (size - sizeof(outarg) != outarg.size)
 		goto out_finish;
 
-	nodeid = outarg.nodeid;
-
-	down_read(&fc->killsb);
-
-	err = -ENOENT;
-	if (!fc->sb)
-		goto out_up_killsb;
-
-	inode = ilookup5(fc->sb, nodeid, fuse_inode_eq, &nodeid);
-	if (!inode)
-		goto out_up_killsb;
+	err = fc->ops->notify_store(fc, cs, outarg.nodeid, outarg.size,
+				       outarg.offset);
 
-	mapping = inode->i_mapping;
-	index = outarg.offset >> PAGE_CACHE_SHIFT;
-	offset = outarg.offset & ~PAGE_CACHE_MASK;
-	file_size = i_size_read(inode);
-	end = outarg.offset + outarg.size;
-	if (end > file_size) {
-		file_size = end;
-		fuse_write_update_size(inode, file_size);
-	}
-
-	num = outarg.size;
-	while (num) {
-		struct page *page;
-		unsigned int this_num;
-
-		err = -ENOMEM;
-		page = find_or_create_page(mapping, index,
-					   mapping_gfp_mask(mapping));
-		if (!page)
-			goto out_iput;
-
-		this_num = min_t(unsigned, num, PAGE_CACHE_SIZE - offset);
-		err = fuse_copy_page(cs, &page, offset, this_num, 0);
-		if (!err && offset == 0 && (num != 0 || file_size == end))
-			SetPageUptodate(page);
-		unlock_page(page);
-		page_cache_release(page);
-
-		if (err)
-			goto out_iput;
-
-		num -= this_num;
-		offset = 0;
-		index++;
-	}
-
-	err = 0;
-
-out_iput:
-	iput(inode);
-out_up_killsb:
-	up_read(&fc->killsb);
 out_finish:
 	fuse_copy_finish(cs);
 	return err;
 }
 
-static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_req *req)
-{
-	release_pages(req->pages, req->num_pages, 0);
-}
-
-static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
-			 struct fuse_notify_retrieve_out *outarg)
-{
-	int err;
-	struct address_space *mapping = inode->i_mapping;
-	struct fuse_req *req;
-	pgoff_t index;
-	loff_t file_size;
-	unsigned int num;
-	unsigned int offset;
-	size_t total_len = 0;
-
-	req = fuse_get_req(fc);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	offset = outarg->offset & ~PAGE_CACHE_MASK;
-
-	req->in.h.opcode = FUSE_NOTIFY_REPLY;
-	req->in.h.nodeid = outarg->nodeid;
-	req->in.numargs = 2;
-	req->in.argpages = 1;
-	req->page_offset = offset;
-	req->end = fuse_retrieve_end;
-
-	index = outarg->offset >> PAGE_CACHE_SHIFT;
-	file_size = i_size_read(inode);
-	num = outarg->size;
-	if (outarg->offset > file_size)
-		num = 0;
-	else if (outarg->offset + num > file_size)
-		num = file_size - outarg->offset;
-
-	while (num && req->num_pages < FUSE_MAX_PAGES_PER_REQ) {
-		struct page *page;
-		unsigned int this_num;
-
-		page = find_get_page(mapping, index);
-		if (!page)
-			break;
-
-		this_num = min_t(unsigned, num, PAGE_CACHE_SIZE - offset);
-		req->pages[req->num_pages] = page;
-		req->num_pages++;
-
-		num -= this_num;
-		total_len += this_num;
-		index++;
-	}
-	req->misc.retrieve_in.offset = outarg->offset;
-	req->misc.retrieve_in.size = total_len;
-	req->in.args[0].size = sizeof(req->misc.retrieve_in);
-	req->in.args[0].value = &req->misc.retrieve_in;
-	req->in.args[1].size = total_len;
-
-	err = fuse_request_send_notify_reply(fc, req, outarg->notify_unique);
-	if (err)
-		fuse_retrieve_end(fc, req);
-
-	return err;
-}
-
 static int fuse_notify_retrieve(struct fuse_conn *fc, unsigned int size,
 				struct fuse_copy_state *cs)
 {
 	struct fuse_notify_retrieve_out outarg;
-	struct inode *inode;
 	int err;
 
 	err = -EINVAL;
@@ -1610,18 +1484,7 @@ static int fuse_notify_retrieve(struct fuse_conn *fc, unsigned int size,
 
 	fuse_copy_finish(cs);
 
-	down_read(&fc->killsb);
-	err = -ENOENT;
-	if (fc->sb) {
-		u64 nodeid = outarg.nodeid;
-
-		inode = ilookup5(fc->sb, nodeid, fuse_inode_eq, &nodeid);
-		if (inode) {
-			err = fuse_retrieve(fc, inode, &outarg);
-			iput(inode);
-		}
-	}
-	up_read(&fc->killsb);
+	err = fc->ops->notify_retrieve(fc, &outarg);
 
 	return err;
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a571584..9542f5b 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -312,6 +312,21 @@ struct fuse_req {
 	struct file *stolen_file;
 };
 
+struct fuse_copy_state;
+
+struct fuse_conn_operations {
+	/** Called on final put */
+	void (*release)(struct fuse_conn *);
+
+	/** Called to store data into a mapping */
+	int (*notify_store)(struct fuse_conn *, struct fuse_copy_state *,
+			    u64 nodeid, u32 size, u64 pos);
+
+	/** Called to retrieve data from a mapping */
+	int (*notify_retrieve)(struct fuse_conn *,
+			       struct fuse_notify_retrieve_out *);
+};
+
 /**
  * A Fuse connection.
  *
@@ -511,14 +526,14 @@ struct fuse_conn {
 	/** Version counter for attribute changes */
 	u64 attr_version;
 
-	/** Called on final put */
-	void (*release)(struct fuse_conn *);
-
 	/** Super block for this connection. */
 	struct super_block *sb;
 
 	/** Read/write semaphore to hold when accessing sb. */
 	struct rw_semaphore killsb;
+
+	/** Operations that fuse and cuse can implement differently */
+	const struct fuse_conn_operations *ops;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
@@ -778,4 +793,11 @@ int fuse_dev_release(struct inode *inode, struct file *file);
 
 void fuse_write_update_size(struct inode *inode, loff_t pos);
 
+int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
+		   unsigned offset, unsigned count, int zeroing);
+
+int fuse_request_send_notify_reply(struct fuse_conn *fc,
+				   struct fuse_req *req, u64 unique);
+
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 3e6d727..4bf887f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -551,7 +551,7 @@ void fuse_conn_put(struct fuse_conn *fc)
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
 		mutex_destroy(&fc->inst_mutex);
-		fc->release(fc);
+		fc->ops->release(fc);
 	}
 }
 EXPORT_SYMBOL_GPL(fuse_conn_put);
@@ -915,6 +915,168 @@ static int fuse_bdi_init(struct fuse_conn *fc, struct super_block *sb)
 	return 0;
 }
 
+static int fuse_notify_store_to_inode(struct fuse_conn *fc,
+				      struct fuse_copy_state *cs,
+				      u64 nodeid, u32 size, u64 pos)
+{
+	struct inode *inode;
+	struct address_space *mapping;
+	pgoff_t index;
+	unsigned int off;
+	loff_t file_size;
+	loff_t end;
+	int err;
+
+	down_read(&fc->killsb);
+
+	err = -ENOENT;
+	if (!fc->sb)
+		goto out_up_killsb;
+
+	inode = ilookup5(fc->sb, nodeid, fuse_inode_eq, &nodeid);
+	if (!inode)
+		goto out_up_killsb;
+
+	mapping = inode->i_mapping;
+	index = pos >> PAGE_CACHE_SHIFT;
+	off = pos & ~PAGE_CACHE_MASK;
+	file_size = i_size_read(inode);
+	end = pos + size;
+	if (end > file_size) {
+		file_size = end;
+		fuse_write_update_size(inode, file_size);
+	}
+
+	while (size) {
+		struct page *page;
+		unsigned int this_num;
+
+		err = -ENOMEM;
+		page = find_or_create_page(mapping, index,
+					   mapping_gfp_mask(mapping));
+		if (!page)
+			goto out_iput;
+
+		this_num = min_t(unsigned, size, PAGE_CACHE_SIZE - off);
+		err = fuse_copy_page(cs, &page, off, this_num, 0);
+		if (!err && off == 0 && (size != 0 || file_size == end))
+			SetPageUptodate(page);
+		unlock_page(page);
+		page_cache_release(page);
+
+		if (err)
+			goto out_iput;
+
+		size -= this_num;
+		off = 0;
+		index++;
+	}
+
+	err = 0;
+
+out_iput:
+	iput(inode);
+out_up_killsb:
+	up_read(&fc->killsb);
+
+	return err;
+}
+
+static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_req *req)
+{
+	release_pages(req->pages, req->num_pages, 0);
+}
+
+static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
+			 struct fuse_notify_retrieve_out *outarg)
+{
+	int err;
+	struct address_space *mapping = inode->i_mapping;
+	struct fuse_req *req;
+	pgoff_t index;
+	loff_t file_size;
+	unsigned int num;
+	unsigned int offset;
+	size_t total_len = 0;
+
+	req = fuse_get_req(fc);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	offset = outarg->offset & ~PAGE_CACHE_MASK;
+
+	req->in.h.opcode = FUSE_NOTIFY_REPLY;
+	req->in.h.nodeid = outarg->nodeid;
+	req->in.numargs = 2;
+	req->in.argpages = 1;
+	req->page_offset = offset;
+	req->end = fuse_retrieve_end;
+
+	index = outarg->offset >> PAGE_CACHE_SHIFT;
+	file_size = i_size_read(inode);
+	num = outarg->size;
+	if (outarg->offset > file_size)
+		num = 0;
+	else if (outarg->offset + num > file_size)
+		num = file_size - outarg->offset;
+
+	while (num && req->num_pages < FUSE_MAX_PAGES_PER_REQ) {
+		struct page *page;
+		unsigned int this_num;
+
+		page = find_get_page(mapping, index);
+		if (!page)
+			break;
+
+		this_num = min_t(unsigned, num, PAGE_CACHE_SIZE - offset);
+		req->pages[req->num_pages] = page;
+		req->num_pages++;
+
+		num -= this_num;
+		total_len += this_num;
+		index++;
+	}
+	req->misc.retrieve_in.offset = outarg->offset;
+	req->misc.retrieve_in.size = total_len;
+	req->in.args[0].size = sizeof(req->misc.retrieve_in);
+	req->in.args[0].value = &req->misc.retrieve_in;
+	req->in.args[1].size = total_len;
+
+	err = fuse_request_send_notify_reply(fc, req, outarg->notify_unique);
+	if (err)
+		fuse_retrieve_end(fc, req);
+
+	return err;
+}
+
+static int fuse_notify_retrieve_from_inode(struct fuse_conn *fc,
+				struct fuse_notify_retrieve_out *outarg)
+{
+	struct inode *inode;
+	int err;
+
+	down_read(&fc->killsb);
+	err = -ENOENT;
+	if (fc->sb) {
+		u64 nodeid = outarg->nodeid;
+
+		inode = ilookup5(fc->sb, nodeid, fuse_inode_eq, &nodeid);
+		if (inode) {
+			err = fuse_retrieve(fc, inode, outarg);
+			iput(inode);
+		}
+	}
+	up_read(&fc->killsb);
+
+	return err;
+}
+
+static const struct fuse_conn_operations fuse_default_ops = {
+	.release = fuse_free_conn,
+	.notify_store = fuse_notify_store_to_inode,
+	.notify_retrieve = fuse_notify_retrieve_from_inode,
+};
+
 static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct fuse_conn *fc;
@@ -978,7 +1140,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 		fc->dont_mask = 1;
 	sb->s_flags |= MS_POSIXACL;
 
-	fc->release = fuse_free_conn;
+	fc->ops = &fuse_default_ops;
 	fc->flags = d.flags;
 	fc->user_id = d.user_id;
 	fc->group_id = d.group_id;
-- 
1.7.7

