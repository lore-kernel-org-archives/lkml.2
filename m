Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0IFAvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:51:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab0IFAvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:51:48 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:29 +1000
Subject: [PATCH 06/10] ovl: rename ovl_fill_cache to ovl_dir_read
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005029.20775.41664.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ovl_fill_cache isn't only used for filling the cache - it is also used
to remove all whiteout files.  This can be a bit confusing.
So rename it to a more generic "ovl_dir_read" and rename the data
structure that is passed to it to "ovl_readdir_data".

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/overlayfs/overlayfs.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index f9eea96..656cad7 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -88,7 +88,7 @@ struct ovl_cache_entry {
 	bool is_whiteout;
 };
 
-struct ovl_cache_callback {
+struct ovl_readdir_data {
 	struct ovl_cache_entry *list;
 	struct ovl_cache_entry **endp;
 	struct path path;
@@ -102,7 +102,7 @@ struct ovl_dir_file {
 	struct file *realfile;
 };
 
-static int ovl_cache_add_entry(struct ovl_cache_callback *cb,
+static int ovl_cache_add_entry(struct ovl_readdir_data *cb,
 				 const char *name, int namelen, u64 ino,
 				 unsigned int d_type, bool is_whiteout)
 {
@@ -161,7 +161,7 @@ static int ovl_cache_find_entry(struct ovl_cache_entry *start,
 static int ovl_fill_lower(void *buf, const char *name, int namlen,
 			    loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct ovl_cache_callback *cb = buf;
+	struct ovl_readdir_data *cb = buf;
 
 	cb->count++;
 	if (!ovl_cache_find_entry(cb->list, name, namlen))
@@ -173,7 +173,7 @@ static int ovl_fill_lower(void *buf, const char *name, int namlen,
 static int ovl_fill_upper(void *buf, const char *name, int namlen,
 			  loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct ovl_cache_callback *cb = buf;
+	struct ovl_readdir_data *cb = buf;
 	bool is_whiteout = false;
 
 	cb->count++;
@@ -195,7 +195,7 @@ out:
 	return cb->err;
 }
 
-static int ovl_fill_cache(struct path *realpath, struct ovl_cache_callback *cb,
+static int ovl_dir_read(struct path *realpath, struct ovl_readdir_data *cb,
 			  filldir_t filler)
 {
 	const struct cred *old_cred;
@@ -270,15 +270,15 @@ static int ovl_readdir(struct file *file, void *buf, filldir_t filler)
 	}
 
 	if (!od->cache) {
-		struct ovl_cache_callback cb = {
+		struct ovl_readdir_data cb = {
 			.list = NULL,
 			.endp = &cb.list,
 			.path = ue->upperpath,
 		};
 
-		res = ovl_fill_cache(&ue->upperpath, &cb, ovl_fill_upper);
+		res = ovl_dir_read(&ue->upperpath, &cb, ovl_fill_upper);
 		if (!res) {
-			res = ovl_fill_cache(&ue->lowerpath, &cb,
+			res = ovl_dir_read(&ue->lowerpath, &cb,
 					     ovl_fill_lower);
 		}
 		if (res)
@@ -1292,18 +1292,18 @@ static int ovl_check_empty_dir(struct dentry *dentry)
 	int err;
 	struct ovl_entry *ue = dentry->d_fsdata;
 	struct ovl_cache_entry *p;
-	struct ovl_cache_callback cb = {
+	struct ovl_readdir_data cb = {
 		.list = NULL,
 		.endp = &cb.list,
 		.path = ue->upperpath,
 	};
 
 	if (ue->upperpath.dentry) {
-		err = ovl_fill_cache(&ue->upperpath, &cb, ovl_fill_upper);
+		err = ovl_dir_read(&ue->upperpath, &cb, ovl_fill_upper);
 		if (err)
 			return err;
 	}
-	err = ovl_fill_cache(&ue->lowerpath, &cb, ovl_fill_lower);
+	err = ovl_dir_read(&ue->lowerpath, &cb, ovl_fill_lower);
 	if (err)
 		return err;
 
@@ -1330,7 +1330,7 @@ static int ovl_check_empty_dir(struct dentry *dentry)
 static int ovl_unlink_whiteout(void *buf, const char *name, int namlen,
 				 loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct ovl_cache_callback *cb = buf;
+	struct ovl_readdir_data *cb = buf;
 
 	cb->count++;
 	/* check d_type to filter out "." and ".." */
@@ -1352,7 +1352,7 @@ static int ovl_unlink_whiteout(void *buf, const char *name, int namlen,
 static int ovl_remove_whiteouts(struct dentry *dentry)
 {
 	struct ovl_entry *ue = dentry->d_fsdata;
-	struct ovl_cache_callback cb = {
+	struct ovl_readdir_data cb = {
 		.list = NULL,
 		.path = ue->upperpath,
 	};
@@ -1360,7 +1360,7 @@ static int ovl_remove_whiteouts(struct dentry *dentry)
 	if (!ue->upperpath.dentry)
 		return 0;
 
-	return ovl_fill_cache(&ue->upperpath, &cb, ovl_unlink_whiteout);
+	return ovl_dir_read(&ue->upperpath, &cb, ovl_unlink_whiteout);
 }
 
 static int ovl_rmdir(struct inode *dir, struct dentry *dentry)


