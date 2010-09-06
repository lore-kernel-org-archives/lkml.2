Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0IFAvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:51:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:50953 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab0IFAvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:51:36 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:29 +1000
Subject: [PATCH 04/10] ovl: initialise is_real before use.
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005028.20775.2233.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch can use od->is_real before it is properly
initialised is llseek is called before readdir.
So factor out the initialisation of is_real and call it from both
readdir and llseek when f_pos is 0.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/overlayfs/overlayfs.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 306de45..de854e1 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -240,6 +240,17 @@ static int ovl_fill_cache(struct path *realpath, struct ovl_cache_callback *cb,
 	return 0;
 }
 
+static void ovl_dir_reset(struct file *file)
+{
+	struct ovl_dir_file *od = file->private_data;
+	struct ovl_entry *ue = file->f_path.dentry->d_fsdata;
+
+	ovl_cache_free(od->cache);
+	od->cache = NULL;
+
+	od->is_real = (!ue->lowerpath.dentry || !ue->upperpath.dentry);
+}
+
 static int ovl_readdir(struct file *file, void *buf, filldir_t filler)
 {
 	struct ovl_dir_file *od = file->private_data;
@@ -248,14 +259,10 @@ static int ovl_readdir(struct file *file, void *buf, filldir_t filler)
 	loff_t off;
 	int res = 0;
 
-	if (!file->f_pos) {
-		ovl_cache_free(od->cache);
-		od->cache = NULL;
-		od->is_real = false;
-	}
+	if (!file->f_pos)
+		ovl_dir_reset(file);
 
-	if (od->is_real || !ue->lowerpath.dentry || !ue->upperpath.dentry) {
-		od->is_real = true;
+	if (od->is_real) {
 		res = vfs_readdir(od->realfile, filler, buf);
 		file->f_pos = od->realfile->f_pos;
 
@@ -307,6 +314,9 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 	loff_t res;
 	struct ovl_dir_file *od = file->private_data;
 
+	if (!file->f_pos)
+		ovl_dir_reset(file);
+
 	if (od->is_real) {
 		res = vfs_llseek(od->realfile, offset, origin);
 		file->f_pos = od->realfile->f_pos;


