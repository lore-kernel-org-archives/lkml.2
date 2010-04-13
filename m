Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0DMXw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:52:29 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:59389 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0DMXwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=fiyoshpNbzUn8firVRNSAOnU6XRp+MoQM
	T0Qkz8Q//oDCd+nNxPj/U8qrATqK4PNEhYtJ8iqvmHUAfYEhTivAXe2RD7Bx0HtO
	+2SBJgCcuus/BQK0zWXUG15R4CtL1/GA7kRi8w7ZYaHft3ZFgosCZdRzduc6V2xb
	6qooQtgUMY=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, yehudasa@gmail.com, sage@newdream.net,
       axboe@kernel.dk, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 5/6] ceph: refactor mount related functions, add helpers
Date: Tue, 13 Apr 2010 16:29:14 -0700
Message-Id: <b29a49e98a5186f83094b7a7a5dbc74647921e10.1271198630.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
References: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
In-Reply-To: <6b8320ea22e059baaac6e4cdd3a0a687646de168.1271198630.git.yehuda@hq.newdream.net>
References: <6b8320ea22e059baaac6e4cdd3a0a687646de168.1271198630.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed some functions' static declarations, separated mount
operation to __open_session and open_root_dentry for clients
that don't need the latter (rbd). Added other helper functions
that will be used later in the rbd.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/file.c       |   46 ++++++++++++++++
 fs/ceph/osd_client.h |    1 +
 fs/ceph/super.c      |  142 ++++++++++++++++++++++++++++++++++++++-----------
 fs/ceph/super.h      |   29 +++++++++--
 4 files changed, 182 insertions(+), 36 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ef8f9e9..bf7d002 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -362,6 +362,52 @@ static int copy_user_to_page_vector(struct page **pages,
 	return len;
 }
 
+int ceph_copy_to_page_vector(struct page **pages,
+				    const char *data,
+				    loff_t off, size_t len)
+{
+	int i = 0;
+	int po = off & ~PAGE_CACHE_MASK;
+	int left = len;
+	int l;
+
+	while (left > 0) {
+		l = min_t(int, PAGE_CACHE_SIZE-po, left);
+		memcpy(page_address(pages[i]) + po, data, l);
+		data += l;
+		left -= l;
+		po += l;
+		if (po == PAGE_CACHE_SIZE) {
+			po = 0;
+			i++;
+		}
+	}
+	return len;
+}
+
+int ceph_copy_from_page_vector(struct page **pages,
+				    char *data,
+				    loff_t off, size_t len)
+{
+	int i = 0;
+	int po = off & ~PAGE_CACHE_MASK;
+	int left = len;
+	int l;
+
+	while (left > 0) {
+		l = min_t(int, PAGE_CACHE_SIZE-po, left);
+		memcpy(data, page_address(pages[i]) + po, l);
+		data += l;
+		left -= l;
+		po += l;
+		if (po == PAGE_CACHE_SIZE) {
+			po = 0;
+			i++;
+		}
+	}
+	return len;
+}
+
 /*
  * copy user data from a page vector into a user pointer
  */
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
index 76aa63e..870b323 100644
--- a/fs/ceph/osd_client.h
+++ b/fs/ceph/osd_client.h
@@ -67,6 +67,7 @@ struct ceph_osd_request {
 
 	struct inode *r_inode;         	      /* for use by callbacks */
 	struct writeback_control *r_wbc;      /* ditto */
+	void *r_priv;		 	      /* ditto */
 
 	char              r_oid[40];          /* object name */
 	int               r_oid_len;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 4e7adf9..52e9e86 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -344,14 +344,15 @@ static match_table_t arg_tokens = {
 };
 
 
-static struct ceph_mount_args *parse_mount_args(int flags, char *options,
-						const char *dev_name,
-						const char **path)
+struct ceph_mount_args *parse_mount_args(int flags, char *options,
+					 const char *dev_name,
+					 const char **path)
 {
 	struct ceph_mount_args *args;
 	const char *c;
 	int err = -ENOMEM;
 	substring_t argstr[MAX_OPT_ARGS];
+	const char *end_path;
 
 	args = kzalloc(sizeof(*args), GFP_KERNEL);
 	if (!args)
@@ -382,23 +383,29 @@ static struct ceph_mount_args *parse_mount_args(int flags, char *options,
 	err = -EINVAL;
 	if (!dev_name)
 		goto out;
-	*path = strstr(dev_name, ":/");
-	if (*path == NULL) {
-		pr_err("device name is missing path (no :/ in %s)\n",
-		       dev_name);
-		goto out;
+
+	if (path) {
+		*path = strstr(dev_name, ":/");
+		if (*path == NULL) {
+			pr_err("device name is missing path (no :/ in %s)\n",
+			       dev_name);
+			goto out;
+		}
+		end_path = *path;
+
+		/* path on server */
+		*path += 2;
+		dout("server path '%s'\n", *path);
+	} else {
+		end_path = dev_name + strlen(dev_name);
 	}
 
 	/* get mon ip(s) */
-	err = ceph_parse_ips(dev_name, *path, args->mon_addr,
+	err = ceph_parse_ips(dev_name, end_path, args->mon_addr,
 			     CEPH_MAX_MON, &args->num_mon);
 	if (err < 0)
 		goto out;
 
-	/* path on server */
-	*path += 2;
-	dout("server path '%s'\n", *path);
-
 	/* parse mount options */
 	while ((c = strsep(&options, ",")) != NULL) {
 		int token, intval, ret;
@@ -534,6 +541,51 @@ static void destroy_mount_args(struct ceph_mount_args *args)
 	kfree(args);
 }
 
+static int strcmp_null(const char *s1, const char *s2)
+{
+	if (!s1 && !s2)
+		return 0;
+	if (s1 && !s2)
+		return -1;
+	if (!s1 && s2)
+		return 1;
+	return strcmp(s1, s2);
+}
+
+int ceph_compare_mount_args(struct ceph_mount_args *new_args,
+			    struct ceph_client *client)
+{
+	struct ceph_mount_args *args1 = new_args;
+	struct ceph_mount_args *args2 = client->mount_args;
+	int ofs = offsetof(struct ceph_mount_args, mon_addr);
+	int i;
+	int ret;
+
+	ret = memcmp(args1, args2, ofs);
+	if (ret)
+		return ret;
+
+	ret = strcmp_null(args1->snapdir_name, args2->snapdir_name);
+	if (ret)
+		return ret;
+
+	ret = strcmp_null(args1->name, args2->name);
+	if (ret)
+		return ret;
+
+	ret = strcmp_null(args1->secret, args2->secret);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < args1->num_mon; i++) {
+		if (ceph_monmap_contains(client->monc.monmap,
+				 &args1->mon_addr[i]))
+			return 0;
+	}
+
+	return -1;
+}
+
 /*
  * create a fresh client instance
  */
@@ -621,7 +673,7 @@ fail:
 	return ERR_PTR(err);
 }
 
-static void ceph_destroy_client(struct ceph_client *client)
+void ceph_destroy_client(struct ceph_client *client)
 {
 	dout("destroy_client %p\n", client);
 
@@ -722,17 +774,12 @@ static struct dentry *open_root_dentry(struct ceph_client *client,
 /*
  * mount: join the ceph cluster, and open root directory.
  */
-static int ceph_mount(struct ceph_client *client, struct vfsmount *mnt,
-		      const char *path)
+static int __ceph_open_session(struct ceph_client *client,
+			       unsigned long started)
 {
 	struct ceph_entity_addr *myaddr = NULL;
 	int err;
 	unsigned long timeout = client->mount_args->mount_timeout * HZ;
-	unsigned long started = jiffies;  /* note the start time */
-	struct dentry *root;
-
-	dout("mount start\n");
-	mutex_lock(&client->mount_mutex);
 
 	/* initialize the messenger */
 	if (client->msgr == NULL) {
@@ -740,9 +787,8 @@ static int ceph_mount(struct ceph_client *client, struct vfsmount *mnt,
 			myaddr = &client->mount_args->my_addr;
 		client->msgr = ceph_messenger_create(myaddr);
 		if (IS_ERR(client->msgr)) {
-			err = PTR_ERR(client->msgr);
 			client->msgr = NULL;
-			goto out;
+			return PTR_ERR(client->msgr);
 		}
 		client->msgr->nocrc = ceph_test_opt(client, NOCRC);
 	}
@@ -750,26 +796,58 @@ static int ceph_mount(struct ceph_client *client, struct vfsmount *mnt,
 	/* open session, and wait for mon, mds, and osd maps */
 	err = ceph_monc_open_session(&client->monc);
 	if (err < 0)
-		goto out;
+		return err;
 
 	while (!have_mon_and_osd_map(client)) {
 		err = -EIO;
 		if (timeout && time_after_eq(jiffies, started + timeout))
-			goto out;
+			return err;
 
 		/* wait */
 		dout("mount waiting for mon_map\n");
 		err = wait_event_interruptible_timeout(client->auth_wq,
-		       have_mon_and_osd_map(client) || (client->auth_err < 0),
-		       timeout);
+			have_mon_and_osd_map(client) || (client->auth_err < 0),
+			timeout);
 		if (err == -EINTR || err == -ERESTARTSYS)
-			goto out;
-		if (client->auth_err < 0) {
-			err = client->auth_err;
-			goto out;
-		}
+			return err;
+		if (client->auth_err < 0)
+			return client->auth_err;
 	}
 
+	return 0;
+}
+
+int ceph_open_session(struct ceph_client *client)
+{
+	int ret;
+	unsigned long started = jiffies;  /* note the start time */
+
+	dout("open_session start\n");
+	mutex_lock(&client->mount_mutex);
+
+	ret = __ceph_open_session(client, started);
+
+	mutex_unlock(&client->mount_mutex);
+	return ret;
+}
+
+/*
+ * mount: join the ceph cluster, and open root directory.
+ */
+static int ceph_mount(struct ceph_client *client, struct vfsmount *mnt,
+		      const char *path)
+{
+	int err;
+	unsigned long started = jiffies;  /* note the start time */
+	struct dentry *root;
+
+	dout("mount start\n");
+	mutex_lock(&client->mount_mutex);
+
+	err = __ceph_open_session(client, started);
+	if (err < 0)
+		goto out;
+
 	dout("mount opening root\n");
 	root = open_root_dentry(client, "", started);
 	if (IS_ERR(root)) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 78ee529..9761768 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -47,11 +47,8 @@
 #define ceph_test_opt(client, opt) \
 	(!!((client)->mount_args->flags & CEPH_OPT_##opt))
 
-
 struct ceph_mount_args {
 	int sb_flags;
-	int num_mon;
-	struct ceph_entity_addr *mon_addr;
 	int flags;
 	int mount_timeout;
 	int osd_idle_ttl;
@@ -64,10 +61,18 @@ struct ceph_mount_args {
 	int congestion_kb;      /* max readdir size */
 	int osd_timeout;
 	int osd_keepalive_timeout;
+	int cap_release_safety;
+
+	/* any type that can't be simply compared or doesn't need
+	   need to be compared should go beyond this point,
+	   ceph_compare_mount_args() should be updated accordingly */
+	struct ceph_entity_addr *mon_addr; /* should be the first
+					      pointer type of args */
+	int num_mon;
+
 	char *snapdir_name;   /* default ".snap" */
 	char *name;
 	char *secret;
-	int cap_release_safety;
 };
 
 /*
@@ -736,6 +741,15 @@ extern struct kmem_cache *ceph_file_cachep;
 
 extern const char *ceph_msg_type_name(int type);
 extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
+extern struct ceph_mount_args *parse_mount_args(int flags, char *options,
+						const char *dev_name,
+						const char **path);
+extern int ceph_compare_mount_args(struct ceph_mount_args *new_args,
+			    struct ceph_client *client);
+extern struct ceph_client *ceph_create_client(struct ceph_mount_args *args,
+					      int need_mdsc);
+extern void ceph_destroy_client(struct ceph_client *client);
+extern int ceph_open_session(struct ceph_client *client);
 
 #define FSID_FORMAT "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-" \
 	"%02x%02x%02x%02x%02x%02x"
@@ -846,6 +860,13 @@ extern int ceph_mmap(struct file *file, struct vm_area_struct *vma);
 /* file.c */
 extern const struct file_operations ceph_file_fops;
 extern const struct address_space_operations ceph_aops;
+extern int ceph_copy_to_page_vector(struct page **pages,
+				    const char *data,
+				    loff_t off, size_t len);
+extern int ceph_copy_from_page_vector(struct page **pages,
+				    char *data,
+				    loff_t off, size_t len);
+extern struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags);
 extern int ceph_open(struct inode *inode, struct file *file);
 extern struct dentry *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
 				       struct nameidata *nd, int mode,
-- 
1.5.6.5

