Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2BHTje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:39:34 -0500
Received: from corega.com.ru ([195.178.208.66]:51526 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756928Ab2BHTj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:39:29 -0500
Date: Wed, 8 Feb 2012 22:34:13 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: pohmelfs: call for inclusion
Message-ID: <20120208193413.GA22215@ioremap.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi

I'm please to announce new and completely rewritten distributed
filesystem - POHMELFS

It went a long way from parallel NFS design which lived in
drivers/staging/pohmelfs for years effectively without usage case - that
design was dead.

New pohmelfs uses elliptics network [1] as its storage backend, which
was proved as effective distributed system. Elliptics is used in
production in Yandex search company for several years now and clusters
range from small (like 6 nodes in 3 datacenters to host 15 billions of
small files or hundred of nodes to scale to 1 Pb used for streaming).

We start to cook up 2 small clusters for production pohmelfs testing -
one of them is largest in East Europe mirror site, another one is used
for internal package storage.

Pohmelfs is just a POSIX frontend to elliptics. It supports hardlinks,
symlinks, data checksums, multiple copies and so on.
Pohmelfs uses local cache (synced on timely basis) for all operations,
and only sync (or close with sync_on_close mount option) or writeback
will flush data to remote nodes. There is also background work to flush
data to storage like commit in ext3
Directory objects are synced to the storage when they are created on
pohmelfs node, file data is being sent from cache later.

All recovery process is handled by elliptics and is performed without
pohmelfs clients every noticing that. In particular reads are always
directed to the replica with the latest data (determined according to
ellptics metadata checked at file open time).

Writes in pohmelfs can be configured to succeed when quorum commits it
or when specified in 'successful_write_count=' number of writes return
ok. This is useful when you do not care much about number of active
replicas, since you know that your data is safe. Or when you create new
storage and want to copy to single datacenter to save bandwidth.

But that's enough for advertisement. Here is the code.
I do not know whether it is a good idea to ask it for inclusion into
mainline tree right now skipping drivers/staging part. But anyway, I
post patch to remove drivers/staging/pohmelfs and add fs/pohmelfs
If it is not the way to go, I will resubmit.

1. Elliptics network
http://www.ioremap.net/projects/elliptics
http://www.elliptics.ru (russian support forum - we understand english
and will answer pohmelfs questions too)

2. Pohmelfs
http://www.ioremap.net/projects/pohmelfs (old and not yep updated site)
http://www.ioremap.net/taxonomy/term/4 (development blog section)

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov

--gKMricLos+KVdGMg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="pohmelfs.diff"

diff --git a/fs/Kconfig b/fs/Kconfig
index 9fe0b34..7232749 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -259,6 +259,7 @@ config NFS_COMMON
 source "net/sunrpc/Kconfig"
 source "fs/ceph/Kconfig"
 source "fs/cifs/Kconfig"
+source "fs/pohmelfs/Kconfig"
 source "fs/ncpfs/Kconfig"
 source "fs/coda/Kconfig"
 source "fs/afs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index afc1096..36664fe 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -123,3 +123,4 @@ obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_EXOFS_FS)          += exofs/
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
+obj-$(CONFIG_POHMELFS)		+= pohmelfs/
diff --git a/fs/pohmelfs/Kconfig b/fs/pohmelfs/Kconfig
new file mode 100644
index 0000000..b91e56d
--- /dev/null
+++ b/fs/pohmelfs/Kconfig
@@ -0,0 +1,11 @@
+config POHMELFS
+	tristate "POHMELFS distributed filesystem"
+	depends on INET && EXPERIMENTAL
+	select CRYPTO_HASH
+	help
+	  POHMELFS is a POSIX frontend to Elliptics network
+
+	  Elliptics is a key/value storage, which by default imlpements
+	  distributed hash table structure.
+
+	  More information can be found at http://www.ioremap.net/projects/elliptics
diff --git a/fs/pohmelfs/Makefile b/fs/pohmelfs/Makefile
new file mode 100644
index 0000000..ad358d7
--- /dev/null
+++ b/fs/pohmelfs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux ext2-filesystem routines.
+#
+
+obj-$(CONFIG_POHMELFS) += pohmelfs.o
+
+pohmelfs-y := dir.o file.o inode.o net.o route.o super.o trans.o symlink.o
diff --git a/fs/pohmelfs/Module.symvers b/fs/pohmelfs/Module.symvers
new file mode 100644
index 0000000..e69de29
diff --git a/fs/pohmelfs/dir.c b/fs/pohmelfs/dir.c
new file mode 100644
index 0000000..a1594de
--- /dev/null
+++ b/fs/pohmelfs/dir.c
@@ -0,0 +1,844 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/fs.h>
+#include <linux/dcache.h>
+#include <linux/quotaops.h>
+
+#include "pohmelfs.h"
+
+#define POHMELFS_LOOKUP_SCRIPT				"pohmelfs_lookup.py"
+#define POHMELFS_UNLINK_SCRIPT				"pohmelfs_unlink.py"
+#define POHMELFS_DATA_UNLINK_SCRIPT			"pohmelfs_data_unlink.py"
+#define POHMELFS_HARDLINK_SCRIPT			"pohmelfs_hardlink.py"
+#define POHMELFS_RENAME_SCRIPT				"pohmelfs_rename.py"
+#define POHMELFS_INODE_INFO_SCRIPT_INSERT		"pohmelfs_inode_info_insert.py"
+#define POHMELFS_READDIR_SCRIPT				"pohmelfs_readdir.py"
+#define POHMELFS_DENTRY_NAME_SCRIPT			"pohmelfs_dentry_name="
+
+static void pohmelfs_inode_dirty(struct pohmelfs_inode *parent, struct pohmelfs_inode *pi)
+{
+	struct inode *inode = &pi->vfs_inode;
+	struct inode *dir = &parent->vfs_inode;
+
+	pi->parent_id = parent->id;
+	inode_init_owner(inode, dir, inode->i_mode);
+
+	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	dir->i_mtime = CURRENT_TIME;
+
+	mark_inode_dirty(inode);
+	mark_inode_dirty(dir);
+}
+
+static int pohmelfs_send_dentry_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
+	struct pohmelfs_wait *wait = t->priv;
+	struct dnet_cmd *cmd = &recv->cmd;
+	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
+
+	if (cmd->flags & DNET_FLAGS_MORE) {
+		if (cmd->status == 0 && cmd->size != sizeof(struct dnet_attr) + 2)
+			cmd->status = -EINVAL;
+
+		pr_debug("pohmelfs: %s: pohmelfs_send_dentry_complete: %llu, cmd_size: %llu, flags: %x, status: %d\n",
+				pohmelfs_dump_id(pi->id.id), trans, cmd->size, cmd->flags, cmd->status);
+
+		if (!cmd->status)
+			wait->condition = 1;
+		else
+			wait->condition = cmd->status;
+		wake_up(&wait->wq);
+	}
+
+	return 0;
+}
+
+static int pohmelfs_send_inode_info_init(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_wait *wait = t->priv;
+
+	pohmelfs_wait_get(wait);
+	return 0;
+}
+
+static void pohmelfs_send_inode_info_destroy(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_wait *wait = t->priv;
+
+	wake_up(&wait->wq);
+	pohmelfs_wait_put(wait);
+}
+
+static int pohmelfs_lookup_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_inode *parent = pohmelfs_inode(t->inode);
+	struct pohmelfs_wait *wait = t->priv;
+	struct dnet_cmd *cmd = &recv->cmd;
+	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
+	int err = cmd->status;
+
+	if (err)
+		goto err_out_exit;
+
+	if (cmd->flags & DNET_FLAGS_MORE) {
+		struct pohmelfs_sb *psb = pohmelfs_sb(t->inode->i_sb);
+		struct pohmelfs_inode_info *info;
+		struct pohmelfs_inode *pi;
+
+		if (cmd->size != sizeof(struct dnet_attr) + sizeof(struct pohmelfs_inode_info)) {
+			err = -ENOENT;
+			goto err_out_exit;
+		}
+
+		pr_debug("pohmelfs: %s: pohmelfs_lookup_complete: %llu, size: %llu, min size: %zu, flags: %x, status: %d\n",
+				pohmelfs_dump_id(parent->id.id), trans, cmd->size,
+				sizeof(struct dnet_attr) + sizeof(struct pohmelfs_inode_info), cmd->flags, cmd->status);
+
+
+		info = t->recv_data + sizeof(struct dnet_attr);
+		pohmelfs_convert_inode_info(info);
+
+		pi = pohmelfs_existing_inode(psb, info);
+		if (IS_ERR(pi)) {
+			err = PTR_ERR(pi);
+
+			if (err != -EEXIST)
+				goto err_out_exit;
+
+			err = 0;
+			pi = pohmelfs_sb_inode_lookup(psb, &info->id);
+			if (!pi) {
+				err = -ENOENT;
+				goto err_out_exit;
+			}
+
+			pohmelfs_fill_inode(&pi->vfs_inode, info);
+		}
+
+		pi->parent_id = parent->id;
+		wait->ret = pi;
+	}
+
+err_out_exit:
+	if (err)
+		wait->condition = err;
+	else
+		wait->condition = 1;
+	wake_up(&wait->wq);
+
+	return 0;
+}
+
+int pohmelfs_send_script_request(struct pohmelfs_inode *parent, struct pohmelfs_script_req *req)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(parent->vfs_inode.i_sb);
+	struct pohmelfs_wait *wait;
+	struct pohmelfs_io *pio;
+	struct dnet_exec *e;
+	int script_len;
+	long ret;
+	int err;
+
+	/* 2 commas, \n and 0-byte, which is accounted in sizeof(string) */
+	script_len = sizeof(POHMELFS_DENTRY_NAME_SCRIPT) + req->obj_len + 3;
+
+	wait = pohmelfs_wait_alloc(parent);
+	if (!wait) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
+	if (!pio) {
+		err = -ENOMEM;
+		goto err_out_wait_put;
+	}
+
+	e = kmalloc(sizeof(struct dnet_exec) + req->script_namelen + script_len + req->binary_size, GFP_NOIO);
+	if (!e) {
+		err = -ENOMEM;
+		goto err_out_free_pio;
+	}
+
+	memset(e, 0, sizeof(struct dnet_exec));
+
+	snprintf(e->data, req->script_namelen + script_len, "%s%s'%s'\n", req->script_name, POHMELFS_DENTRY_NAME_SCRIPT, req->obj_name);
+	script_len--; /* do not include last 0-byte in the script */
+
+	memcpy(e->data + req->script_namelen + script_len, req->binary, req->binary_size);
+
+	e->type = DNET_EXEC_PYTHON_SCRIPT_NAME;
+	e->name_size = req->script_namelen;
+	e->script_size = script_len;
+	e->binary_size = req->binary_size;
+	dnet_convert_exec(e);
+
+	pio->pi = parent;
+	pio->id = req->id;
+	pio->group_id = req->group_id;
+	pio->cflags = DNET_FLAGS_NEED_ACK;
+	if (req->complete == pohmelfs_lookup_complete)
+		pio->cflags |= DNET_FLAGS_NOLOCK;
+
+	pio->cmd = DNET_CMD_EXEC;
+	pio->size = sizeof(struct dnet_exec) + req->script_namelen + script_len + req->binary_size;
+	pio->data = e;
+	pio->priv = wait;
+	pio->cb.init = pohmelfs_send_inode_info_init;
+	pio->cb.destroy = pohmelfs_send_inode_info_destroy;
+	pio->cb.complete = req->complete;
+
+	if (pio->group_id) {
+		err = pohmelfs_send_buf_single(pio, NULL);
+	} else {
+		err = pohmelfs_send_buf(pio);
+	}
+	if (err)
+		goto err_out_free;
+
+	if (req->sync) {
+		ret = wait_event_interruptible_timeout(wait->wq, wait->condition != 0, msecs_to_jiffies(psb->read_wait_timeout));
+		if (ret <= 0) {
+			err = ret;
+			if (ret == 0)
+				err = -ETIMEDOUT;
+			goto err_out_free;
+		}
+
+		if (wait->condition < 0)
+			err = wait->condition;
+
+		req->ret = wait->ret;
+		req->ret_cond = wait->condition;
+	}
+
+	{
+		int len = 6;
+		char parent_id_str[len*2+1];
+
+		pr_debug("pohmelfs: %.*s: %s: inode->id: %s, ino: %lu, object: %s, binary size: %d, ret: %p, condition: %d\n",
+				req->script_namelen, req->script_name,
+				pohmelfs_dump_id(req->id->id),
+				pohmelfs_dump_id_len_raw(parent->id.id, len, parent_id_str),
+				parent->vfs_inode.i_ino, req->obj_name, req->binary_size,
+				req->ret, req->ret_cond);
+	}
+
+err_out_free:
+	kfree(e);
+err_out_free_pio:
+	kmem_cache_free(pohmelfs_io_cache, pio);
+err_out_wait_put:
+	pohmelfs_wait_put(wait);
+err_out_exit:
+	return err;
+}
+
+int pohmelfs_send_dentry(struct pohmelfs_inode *pi, struct dnet_raw_id *id, const char *sname, int len, int sync)
+{
+	struct inode *inode = &pi->vfs_inode;
+	struct pohmelfs_script_req req;
+	struct pohmelfs_dentry *pd;
+	int err;
+
+	if (!len) {
+		err = -EINVAL;
+		goto err_out_exit;
+	}
+
+	pd = kmem_cache_alloc(pohmelfs_dentry_cache, GFP_NOIO);
+	if (!pd) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	pd->parent_id = *id;
+	pd->disk.id = pi->id;
+	pd->disk.ino = cpu_to_le64(pi->vfs_inode.i_ino);
+	pd->disk.type = (pi->vfs_inode.i_mode >> 12) & 15;
+	pd->disk.len = len;
+
+	req.id = id;
+
+	req.script_name = POHMELFS_INODE_INFO_SCRIPT_INSERT;
+	req.script_namelen = sizeof(POHMELFS_INODE_INFO_SCRIPT_INSERT) - 1; /* not including 0-byte */
+
+	req.obj_name = (char *)sname;
+	req.obj_len = len;
+
+	req.binary = pd;
+	req.binary_size = sizeof(struct pohmelfs_dentry);
+
+	req.group_id = 0;
+	req.id = id;
+
+	req.sync = sync;
+	req.complete = pohmelfs_send_dentry_complete;
+
+	err = pohmelfs_send_script_request(pi, &req);
+	if (err)
+		goto err_out_free;
+
+	err = inode->i_sb->s_op->write_inode(inode, NULL);
+
+err_out_free:
+	kmem_cache_free(pohmelfs_dentry_cache, pd);
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	struct pohmelfs_inode *pi;
+	int err;
+
+	pi = pohmelfs_new_inode(psb, mode);
+	if (IS_ERR(pi)) {
+		err = PTR_ERR(pi);
+		goto err_out_exit;
+	}
+
+	inode_inc_link_count(dir);
+
+	/*
+	 * calling d_instantiate() implies that
+	 * ->lookup() used d_splice_alias() with NULL inode
+	 *  when it failed to find requested object
+	 */
+	d_instantiate(dentry, &pi->vfs_inode);
+	if (psb->http_compat)
+		pohmelfs_http_compat_id(pi);
+	pohmelfs_inode_dirty(parent, pi);
+
+	err = pohmelfs_send_dentry(pi, &pi->parent_id, dentry->d_name.name, dentry->d_name.len, 0);
+	if (err)
+		goto err_out_put;
+
+	pr_debug("pohmelfs: create: %s, ino: %lu, parent dir: %lu, object: %s\n",
+			pohmelfs_dump_id(pi->id.id), pi->vfs_inode.i_ino,
+			dir->i_ino, dentry->d_name.name);
+
+	return 0;
+
+err_out_put:
+	inode_dec_link_count(dir);
+	iput(&pi->vfs_inode);
+	d_instantiate(dentry, NULL);
+err_out_exit:
+	return err;
+}
+
+static struct pohmelfs_inode *pohmelfs_lookup_group(struct inode *dir, struct dentry *dentry, int group_id)
+{
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	struct pohmelfs_script_req req;
+	struct pohmelfs_inode *pi;
+	int err;
+
+	req.script_name = POHMELFS_LOOKUP_SCRIPT;
+	req.script_namelen = sizeof(POHMELFS_LOOKUP_SCRIPT) - 1; /* not including 0-byte */
+
+	req.obj_name = (char *)dentry->d_name.name;
+	req.obj_len = dentry->d_name.len;
+
+	req.binary = &parent->id;
+	req.binary_size = sizeof(struct dnet_raw_id);
+
+	req.id = &parent->id;
+	req.complete = pohmelfs_lookup_complete;
+
+	req.group_id = group_id;
+	req.sync = 1;
+
+	err = pohmelfs_send_script_request(parent, &req);
+	if (err)
+		goto err_out_exit;
+
+	pi = req.ret;
+	if (!pi) {
+		err = -ENOENT;
+		goto err_out_exit;
+	}
+
+	return pi;
+
+err_out_exit:
+	pr_debug("pohmelfs: pohmelfs_lookup_group: %s: group: %d: parent ino: %lu, name: %s: %d\n",
+		pohmelfs_dump_id(parent->id.id), group_id, parent->vfs_inode.i_ino, dentry->d_name.name, err);
+	return ERR_PTR(err);
+}
+
+static struct dentry *pohmelfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct inode *inode = NULL;
+	struct pohmelfs_inode *pi;
+	int i, err = -ENOENT;
+
+	for (i = 0; i < psb->group_num; ++i) {
+		pi = pohmelfs_lookup_group(dir, dentry, psb->groups[i]);
+		if (IS_ERR(pi)) {
+			err = PTR_ERR(pi);
+			continue;
+		}
+
+		inode = &pi->vfs_inode;
+		err = 0;
+		break;
+	}
+
+	if (err && (err != -ENOENT) && (err != -EOPNOTSUPP))
+		return ERR_PTR(err);
+
+	return d_splice_alias(inode, dentry);
+}
+
+static int pohmelfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	struct pohmelfs_inode *pi;
+	int err;
+
+	inode_inc_link_count(dir);
+
+	pi = pohmelfs_new_inode(psb, mode | S_IFDIR);
+	if (IS_ERR(pi)) {
+		err = PTR_ERR(pi);
+		goto err_out_dir;
+	}
+
+	d_instantiate(dentry, &pi->vfs_inode);
+	if (psb->http_compat)
+		pohmelfs_http_compat_id(pi);
+	pohmelfs_inode_dirty(parent, pi);
+
+	err = pohmelfs_send_dentry(pi, &pi->parent_id, dentry->d_name.name, dentry->d_name.len, 0);
+	if (err)
+		goto err_out_put;
+
+	pr_debug("pohmelfs: mkdir: %s, ino: %lu, parent dir: %lu, object: %s, refcnt: %d\n",
+			pohmelfs_dump_id(pi->id.id), pi->vfs_inode.i_ino,
+			dir->i_ino, dentry->d_name.name, dentry->d_count);
+	return 0;
+
+err_out_put:
+	iput(&pi->vfs_inode);
+	d_instantiate(dentry, NULL);
+err_out_dir:
+	inode_dec_link_count(dir);
+	return err;
+}
+
+static int pohmelfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	struct pohmelfs_inode *pi = pohmelfs_inode(dentry->d_inode);
+	struct pohmelfs_script_req req;
+	int err;
+
+	req.script_name = POHMELFS_UNLINK_SCRIPT;
+	req.script_namelen = sizeof(POHMELFS_UNLINK_SCRIPT) - 1; /* not including 0-byte */
+
+	req.obj_name = (char *)dentry->d_name.name;
+	req.obj_len = dentry->d_name.len;
+
+	req.binary = &parent->id;
+	req.binary_size = sizeof(struct dnet_raw_id);
+
+	req.group_id = 0;
+	req.id = &parent->id;
+	req.complete = pohmelfs_send_dentry_complete;
+
+	req.sync = 0;
+
+	err = pohmelfs_send_script_request(parent, &req);
+	if (err)
+		return err;
+
+	req.script_name = POHMELFS_DATA_UNLINK_SCRIPT;
+	req.script_namelen = sizeof(POHMELFS_DATA_UNLINK_SCRIPT) - 1; /* not including 0-byte */
+
+	req.binary = &pi->id;
+	req.binary_size = sizeof(struct dnet_raw_id);
+
+	return pohmelfs_send_script_request(parent, &req);
+}
+
+static int pohmelfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	return pohmelfs_unlink(dir, dentry);
+}
+
+struct pohmelfs_rename_req {
+	struct dnet_raw_id		old_dir_id;
+
+	struct pohmelfs_dentry		dentry;
+} __attribute__ ((packed));
+
+static int pohmelfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct pohmelfs_inode *old_parent = pohmelfs_inode(old_dir);
+	struct inode *inode = old_dentry->d_inode;
+	struct pohmelfs_script_req req;
+	struct pohmelfs_rename_req *r;
+	int size = sizeof(struct pohmelfs_rename_req) + new_dentry->d_name.len;
+	int err;
+
+	if (pohmelfs_sb(inode->i_sb)->http_compat) {
+		err = -ENOTSUPP;
+		goto err_out_exit;
+	}
+
+	r = kzalloc(size, GFP_NOIO);
+	if (!r) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	r->old_dir_id = pohmelfs_inode(old_dir)->id;
+	r->dentry.parent_id = pohmelfs_inode(new_dir)->id;
+	r->dentry.disk.id = pohmelfs_inode(inode)->id;
+	r->dentry.disk.ino = cpu_to_le64(inode->i_ino);
+	r->dentry.disk.type = (inode->i_mode >> 12) & 15;
+	r->dentry.disk.len = new_dentry->d_name.len;
+
+	memcpy(r->dentry.disk.name, new_dentry->d_name.name, new_dentry->d_name.len);
+
+	req.script_name = POHMELFS_RENAME_SCRIPT;
+	req.script_namelen = sizeof(POHMELFS_RENAME_SCRIPT) - 1; /* not including 0-byte */
+
+	req.obj_name = (char *)old_dentry->d_name.name;
+	req.obj_len = old_dentry->d_name.len;
+
+	req.binary = r;
+	req.binary_size = size;
+
+	req.sync = 0;
+	req.group_id = 0;
+	req.id = &old_parent->id;
+	req.complete = pohmelfs_send_dentry_complete;
+
+	err = pohmelfs_send_script_request(old_parent, &req);
+	if (err)
+		goto err_out_free;
+
+err_out_free:
+	kfree(r);
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct pohmelfs_inode *pi;
+	struct inode *inode;
+	unsigned len = strlen(symname)+1;
+	int err = 0;
+
+	pi = pohmelfs_new_inode(psb, S_IFLNK | S_IRWXUGO);
+	if (IS_ERR(pi)) {
+		err = PTR_ERR(pi);
+		goto err_out_exit;
+	}
+
+	inode = &pi->vfs_inode;
+
+	err = page_symlink(inode, symname, len);
+	if (err)
+		goto err_out_put;
+
+	d_instantiate(dentry, inode);
+	if (psb->http_compat)
+		pohmelfs_http_compat_id(pi);
+	pohmelfs_inode_dirty(pohmelfs_inode(dir), pi);
+	err = pohmelfs_send_dentry(pi, &pi->parent_id, dentry->d_name.name, dentry->d_name.len, 0);
+	if (err)
+		goto err_out_put;
+
+	return 0;
+
+err_out_put:
+	iput(inode);
+	d_instantiate(dentry, NULL);
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct pohmelfs_script_req req;
+	int err;
+
+	dquot_initialize(dir);
+
+	inode->i_ctime = CURRENT_TIME_SEC;
+	inode_inc_link_count(inode);
+	ihold(inode);
+
+	pohmelfs_inode_dirty(parent, pi);
+
+	err = pohmelfs_send_dentry(pi, &pi->parent_id, dentry->d_name.name, dentry->d_name.len, 1);
+	if (err) {
+		goto err_out_put;
+	}
+
+	req.script_name = POHMELFS_HARDLINK_SCRIPT;
+	req.script_namelen = sizeof(POHMELFS_HARDLINK_SCRIPT) - 1; /* not including 0-byte */
+
+	req.obj_name = (char *)dentry->d_name.name;
+	req.obj_len = dentry->d_name.len;
+
+	req.binary = &pi->id;
+	req.binary_size = sizeof(struct dnet_raw_id);
+
+	req.group_id = 0;
+	req.id = &pi->id;
+	req.complete = pohmelfs_send_dentry_complete;
+
+	req.sync = 0;
+
+	err = pohmelfs_send_script_request(parent, &req);
+	if (err)
+		goto err_out_unlink;
+
+	d_instantiate(dentry, inode);
+	return 0;
+
+err_out_unlink:
+	req.binary = &parent->id;
+	req.script_name = POHMELFS_UNLINK_SCRIPT;
+	req.script_namelen = sizeof(POHMELFS_UNLINK_SCRIPT) - 1; /* not including 0-byte */
+	pohmelfs_send_script_request(parent, &req);
+
+err_out_put:
+	inode_dec_link_count(inode);
+	iput(inode);
+	return err;
+}
+
+static int pohmelfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct pohmelfs_inode *pi;
+	struct inode *inode;
+	int err;
+
+	if (!new_valid_dev(rdev))
+		return -EINVAL;
+
+	dquot_initialize(dir);
+
+	pi = pohmelfs_new_inode(psb, mode);
+	if (IS_ERR(pi)) {
+		err = PTR_ERR(pi);
+		goto err_out_exit;
+	}
+
+	inode = &pi->vfs_inode;
+
+	init_special_inode(inode, inode->i_mode, rdev);
+	inode->i_op = &pohmelfs_special_inode_operations;
+
+	d_instantiate(dentry, inode);
+	if (psb->http_compat)
+		pohmelfs_http_compat_id(pi);
+	pohmelfs_inode_dirty(pohmelfs_inode(dir), pi);
+
+	err = pohmelfs_send_dentry(pi, &pi->parent_id, dentry->d_name.name, dentry->d_name.len, 0);
+	if (err)
+		goto err_out_put;
+
+	return 0;
+
+err_out_put:
+	iput(inode);
+	d_instantiate(dentry, NULL);
+err_out_exit:
+	return err;
+}
+
+const struct inode_operations pohmelfs_dir_inode_operations = {
+	.create		= pohmelfs_create,
+	.lookup 	= pohmelfs_lookup,
+	.mkdir		= pohmelfs_mkdir,
+	.unlink		= pohmelfs_unlink,
+	.rmdir		= pohmelfs_rmdir,
+	.rename		= pohmelfs_rename,
+	.symlink	= pohmelfs_symlink,
+	.link		= pohmelfs_link,
+	.mknod		= pohmelfs_mknod,
+};
+
+static int pohmelfs_readdir_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
+	struct pohmelfs_wait *wait = t->priv;
+	struct dnet_cmd *cmd = &recv->cmd;
+
+	pr_debug("pohmelfs: %s: readdir comlete: cmd size: %llu, recv offset: %llu, flags: %x\n",
+			pohmelfs_dump_id(pi->id.id), (unsigned long long)cmd->size, t->recv_offset, cmd->flags);
+
+	if (cmd->flags & DNET_FLAGS_MORE) {
+		if (cmd->size > sizeof(struct dnet_attr)) {
+			wait->ret = t->recv_data;
+			wait->condition = cmd->size;
+
+			t->recv_data = NULL;
+		}
+	} else {
+		if (!wait->condition) {
+			wait->condition = cmd->status;
+			if (!wait->condition)
+				wait->condition = 1;
+		}
+	}
+
+	return 0;
+}
+
+static int pohmelfs_readdir_process(void *data, int size, struct file *filp, void *dirent, filldir_t filldir)
+{
+	int err = 0;
+
+	while (size > 0) {
+		struct pohmelfs_dentry_disk *d = data;
+
+		if (size < sizeof(struct pohmelfs_dentry_disk)) {
+			err = -EINVAL;
+			break;
+		}
+
+		if (size < d->len) {
+			err = -EINVAL;
+			break;
+		}
+
+		err = filldir(dirent, d->name, d->len, filp->f_pos, le64_to_cpu(d->ino), d->type);
+		if (err)
+			break;
+
+		filp->f_pos++;
+		size -= sizeof(struct pohmelfs_dentry_disk) + d->len;
+		data += sizeof(struct pohmelfs_dentry_disk) + d->len;
+	}
+
+	return err;
+}
+
+struct pohmelfs_readdir {
+	struct dnet_raw_id			id;
+	int					max_size;
+	int					fpos;
+};
+
+static int pohmelfs_readdir_group(int group_id, struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct dentry *dentry = filp->f_path.dentry;
+	struct inode *dir = dentry->d_inode;
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	struct pohmelfs_readdir rd;
+	struct pohmelfs_script_req req;
+	void *data;
+	int size;
+	int err;
+
+	req.script_name = POHMELFS_READDIR_SCRIPT;
+	req.script_namelen = sizeof(POHMELFS_READDIR_SCRIPT) - 1; /* not including 0-byte */
+
+	req.obj_name = (char *)dentry->d_name.name;
+	req.obj_len = dentry->d_name.len;
+
+	rd.id = parent->id;
+	rd.max_size = psb->readdir_allocation * PAGE_SIZE - sizeof(struct dnet_attr); /* cmd->size should fit one page */
+	rd.fpos = filp->f_pos;
+
+	req.binary = &rd;
+	req.binary_size = sizeof(struct pohmelfs_readdir);
+
+	req.id = &parent->id;
+	req.complete = pohmelfs_readdir_complete;
+
+	req.group_id = group_id;
+	req.sync = 1;
+
+	err = pohmelfs_send_script_request(parent, &req);
+	if (err < 0)
+		goto err_out_exit;
+
+	data = req.ret;
+	size = req.ret_cond;
+	if (!data || !size) {
+		err = -ENOENT;
+		goto err_out_exit;
+	}
+
+	err = pohmelfs_readdir_process(data + sizeof(struct dnet_attr), size - sizeof(struct dnet_attr), filp, dirent, filldir);
+
+	kfree(data);
+
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_dir_open(struct inode *dir, struct file *filp)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct pohmelfs_inode *pi = pohmelfs_inode(dir);
+
+	if (get_seconds() < pi->update + psb->sync_timeout)
+		return dcache_dir_open(dir, filp);
+
+	filp->f_pos = 0;
+	return 0;
+}
+
+static int pohmelfs_dir_close(struct inode *inode, struct file *filp)
+{
+	if (filp->private_data)
+		return dcache_dir_close(inode, filp);
+	return 0;
+}
+
+static int pohmelfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct dentry *dentry = filp->f_path.dentry;
+	struct inode *dir = dentry->d_inode;
+	struct pohmelfs_inode *pi = pohmelfs_inode(dir);
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	int i, err = -ENOENT;
+
+	if (filp->private_data) {
+		return dcache_readdir(filp, dirent, filldir);
+	}
+
+	for (i = 0; i < psb->group_num; ++i) {
+		err = pohmelfs_readdir_group(psb->groups[i], filp, dirent, filldir);
+		if (err)
+			continue;
+
+		pi->update = get_seconds();
+		return 0;
+	}
+
+	return err;
+}
+
+const struct file_operations pohmelfs_dir_fops = {
+	.open		= pohmelfs_dir_open,
+	.release	= pohmelfs_dir_close,
+	.read		= generic_read_dir,
+	.readdir	= pohmelfs_readdir,
+};
diff --git a/fs/pohmelfs/file.c b/fs/pohmelfs/file.c
new file mode 100644
index 0000000..b2085bf
--- /dev/null
+++ b/fs/pohmelfs/file.c
@@ -0,0 +1,470 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/fs.h>
+
+#include "pohmelfs.h"
+
+#define POHMELFS_READ_LATEST_GROUPS_SCRIPT		"pohmelfs_read_latest_groups.py"
+
+static int pohmelfs_write_init(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_wait *wait = t->priv;
+
+	pohmelfs_wait_get(wait);
+	return 0;
+}
+
+static void pohmelfs_write_destroy(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_wait *wait = t->priv;
+
+	wake_up(&wait->wq);
+	pohmelfs_wait_put(wait);
+}
+
+static int pohmelfs_write_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_wait *wait = t->priv;
+	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
+	struct dnet_cmd *cmd = &recv->cmd;
+	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
+
+	pr_debug("pohmelfs: %s: write complete: %llu, flags: %x, status: %d\n",
+			pohmelfs_dump_id(pi->id.id), trans, cmd->flags, cmd->status);
+
+	if (cmd->flags & DNET_FLAGS_MORE)
+		return 0;
+
+	wait->condition = cmd->status;
+	if (!wait->condition)
+		wait->condition = 1;
+
+	return 0;
+}
+
+static int pohmelfs_send_write_metadata(struct pohmelfs_inode *pi, struct pohmelfs_io *pio, struct pohmelfs_wait *wait)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
+	struct timespec ts = CURRENT_TIME;
+	struct dnet_meta_update *mu;
+	struct dnet_meta *m;
+	int err, size;
+	void *data;
+
+	size = sizeof(struct dnet_meta) * 4 +
+			sizeof(struct dnet_meta_check_status) +
+			sizeof(struct dnet_meta_update) +
+			psb->fsid_len +
+			psb->group_num * sizeof(int);
+
+	data = kzalloc(size, GFP_NOIO);
+	if (!data) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	m = data;
+	m->type = DNET_META_GROUPS;
+	m->size = psb->group_num * sizeof(int);
+	memcpy(m->data, psb->groups, m->size);
+	dnet_convert_meta(m);
+
+	m = (struct dnet_meta *)(m->data + le32_to_cpu(m->size));
+	m->type = DNET_META_NAMESPACE;
+	m->size = psb->fsid_len;
+	memcpy(m->data, psb->fsid, psb->fsid_len);
+	dnet_convert_meta(m);
+
+	m = (struct dnet_meta *)(m->data + le32_to_cpu(m->size));
+	m->type = DNET_META_UPDATE;
+	m->size = sizeof(struct dnet_meta_update);
+	mu = (struct dnet_meta_update *)m->data;
+	mu->tm.tsec = ts.tv_sec;
+	mu->tm.tnsec = ts.tv_nsec;
+	dnet_convert_meta_update(mu);
+	dnet_convert_meta(m);
+
+	m = (struct dnet_meta *)(m->data + le32_to_cpu(m->size));
+	m->type = DNET_META_CHECK_STATUS;
+	m->size = sizeof(struct dnet_meta_check_status);
+	/* do not fill, it will be updated on server */
+	dnet_convert_meta(m);
+
+	pio->pi = pi;
+	pio->id = &pi->id;
+	pio->cmd = DNET_CMD_WRITE;
+	pio->ioflags = DNET_IO_FLAGS_OVERWRITE | DNET_IO_FLAGS_META;
+	pio->cflags = DNET_FLAGS_NEED_ACK;
+	pio->type = 1;
+	pio->cb.init = pohmelfs_write_init;
+	pio->cb.destroy = pohmelfs_write_destroy;
+	pio->cb.complete = pohmelfs_write_complete;
+	pio->priv = wait;
+	pio->data = data;
+	pio->size = size;
+
+	err = pohmelfs_send_io(pio);
+	if (err)
+		goto err_out_free;
+
+err_out_free:
+	kfree(data);
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_write_command_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct dnet_cmd *cmd = &recv->cmd;
+	struct pohmelfs_write_ctl *ctl = t->wctl;
+
+	if (cmd->flags & DNET_FLAGS_MORE)
+		return 0;
+
+	if (cmd->status == 0)
+		atomic_inc(&ctl->good_writes);
+	else {
+		struct inode *inode = t->inode;
+		struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+		unsigned long long size = le64_to_cpu(t->cmd.p.io.size);
+		unsigned long long offset = le64_to_cpu(t->cmd.p.io.offset);
+
+		pr_debug("pohmelfs: %s: write failed: ino: %lu, isize: %llu, offset: %llu, size: %llu: %d\n",
+				pohmelfs_dump_id(pi->id.id), inode->i_ino, inode->i_size, offset, size, cmd->status);
+	}
+
+	return 0;
+}
+
+static int pohmelfs_write_command_init(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_write_ctl *ctl = t->wctl;
+
+	kref_get(&ctl->refcnt);
+	return 0;
+}
+
+static void pohmelfs_write_command_destroy(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_write_ctl *ctl = t->wctl;
+
+	kref_put(&ctl->refcnt, pohmelfs_write_ctl_release);
+}
+
+int pohmelfs_write_command(struct pohmelfs_inode *pi, struct pohmelfs_write_ctl *ctl, loff_t offset, size_t len)
+{
+	int err;
+	struct inode *inode = &pi->vfs_inode;
+	struct pohmelfs_io *pio;
+	uint64_t prepare_size = i_size_read(&pi->vfs_inode);
+
+	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
+	if (!pio) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	pio->pi = pi;
+	pio->id = &pi->id;
+	pio->cmd = DNET_CMD_WRITE;
+	pio->offset = offset;
+	pio->size = len;
+	pio->cflags = DNET_FLAGS_NEED_ACK;
+
+	/*
+	 * We always set prepare bit, since elliptics/eblob reuses existing (previously prepared/reserved) area
+	 * But it also allows to 'miss' prepare message (for example if we sent prepare bit when node was offline)
+	 */
+	pio->ioflags = DNET_IO_FLAGS_OVERWRITE | DNET_IO_FLAGS_PLAIN_WRITE | DNET_IO_FLAGS_PREPARE;
+
+	pio->num = prepare_size;
+
+	/* commit when whole inode is written */
+	if (offset + len == prepare_size) {
+		pio->ioflags |= DNET_IO_FLAGS_COMMIT;
+	}
+
+	pio->wctl = ctl;
+	pio->priv = ctl;
+	pio->cb.complete = pohmelfs_write_command_complete;
+	pio->cb.init = pohmelfs_write_command_init;
+	pio->cb.destroy = pohmelfs_write_command_destroy;
+
+	pr_debug("pohmelfs_write_prepare_commit: %s: ino: %lu, offset: %llu, len: %zu, total size: %llu\n",
+			pohmelfs_dump_id(pi->id.id), inode->i_ino, (unsigned long long)offset, len, inode->i_size);
+
+	err = pohmelfs_send_io(pio);
+	if (err)
+		goto err_out_free;
+
+err_out_free:
+	kmem_cache_free(pohmelfs_io_cache, pio);
+err_out_exit:
+	return err;
+}
+
+int pohmelfs_metadata_inode(struct pohmelfs_inode *pi, int sync)
+{
+	struct inode *inode = &pi->vfs_inode;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_io *pio;
+	struct pohmelfs_wait *wait;
+	long ret;
+	int err;
+
+	wait = pohmelfs_wait_alloc(pi);
+	if (!wait) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
+	if (!pio) {
+		err = -ENOMEM;
+		goto err_out_put;
+	}
+
+	err = pohmelfs_send_write_metadata(pi, pio, wait);
+	if (err)
+		goto err_out_free;
+
+	if (sync) {
+		ret = wait_event_interruptible_timeout(wait->wq,
+				wait->condition != 0 && atomic_read(&wait->refcnt.refcount) <= 2,
+				msecs_to_jiffies(psb->write_wait_timeout));
+		if (ret <= 0) {
+			err = ret;
+			if (ret == 0)
+				err = -ETIMEDOUT;
+			goto err_out_free;
+		}
+
+		if (wait->condition < 0) {
+			err = wait->condition;
+			goto err_out_free;
+		}
+	}
+
+err_out_free:
+	kmem_cache_free(pohmelfs_io_cache, pio);
+err_out_put:
+	pohmelfs_wait_put(wait);
+err_out_exit:
+	return err;
+}
+
+static long pohmelfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct pohmelfs_io *pio;
+	int err;
+
+	if (offset + len < i_size_read(inode)) {
+		err = 0;
+		goto err_out_exit;
+	}
+
+	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
+	if (!pio) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	pio->pi = pi;
+	pio->id = &pi->id;
+	pio->cmd = DNET_CMD_WRITE;
+	pio->cflags = DNET_FLAGS_NEED_ACK;
+	pio->ioflags = DNET_IO_FLAGS_PREPARE;
+	pio->num = i_size_read(inode);
+
+	pr_info("pohmelfs_fallocate: %s: ino: %lu, offset: %llu, len: %llu, total size: %llu\n",
+			pohmelfs_dump_id(pi->id.id), inode->i_ino,
+			(unsigned long long)offset, (unsigned long long)len, inode->i_size);
+
+	err = pohmelfs_send_io(pio);
+	if (err)
+		goto err_out_free;
+
+err_out_free:
+	kmem_cache_free(pohmelfs_io_cache, pio);
+err_out_exit:
+	return err;
+}
+
+struct pohmelfs_latest_ctl {
+	struct dnet_id			id;
+	uint64_t			offset;
+	uint64_t			size;
+};
+
+static int pohmelfs_read_latest_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
+	struct pohmelfs_wait *wait = t->priv;
+	struct dnet_cmd *cmd = &recv->cmd;
+	int err = cmd->status;
+
+	if (cmd->status)
+		goto err_out_exit;
+
+	if (cmd->flags & DNET_FLAGS_MORE) {
+		pr_debug("pohmelfs: %s: read-latest: complete: group: %d, attr size: %lld\n",
+				pohmelfs_dump_id(cmd->id.id), cmd->id.group_id, cmd->size - sizeof(struct dnet_attr));
+		if (cmd->size < sizeof(struct dnet_attr) + 4) {
+			err = -ENOENT;
+			goto err_out_exit;
+		}
+
+		mutex_lock(&pi->lock);
+		if (!pi->groups) {
+			pi->groups = kmalloc(cmd->size - sizeof(struct dnet_attr), GFP_NOIO);
+			if (!pi->groups) {
+				err = -ENOMEM;
+				mutex_unlock(&pi->lock);
+				goto err_out_exit;
+			}
+
+			pi->group_num = (cmd->size - sizeof(struct dnet_attr)) / sizeof(int);
+			memcpy(pi->groups, t->recv_data + sizeof(struct dnet_attr), pi->group_num * sizeof(int));
+
+			pr_debug("pohmelfs: %s: read-latest: complete: group: %d, received: %d groups\n",
+					pohmelfs_dump_id(cmd->id.id), cmd->id.group_id, pi->group_num);
+		}
+		mutex_unlock(&pi->lock);
+
+		err = 1; /* setting wait->condition to 'everything is ok' */
+	}
+
+err_out_exit:
+	if (err)
+		wait->condition = err;
+	return 0;
+}
+
+static int pohmelfs_read_latest_group(struct pohmelfs_inode *pi, struct pohmelfs_latest_ctl *r, int group_id)
+{
+	struct pohmelfs_script_req req;
+
+	memset(&req, 0, sizeof(struct pohmelfs_script_req));
+
+	req.script_name = POHMELFS_READ_LATEST_GROUPS_SCRIPT;
+	req.script_namelen = sizeof(POHMELFS_READ_LATEST_GROUPS_SCRIPT) - 1;
+
+	req.obj_name = "noname";
+	req.obj_len = 5;
+
+	req.binary = r;
+	req.binary_size = sizeof(struct pohmelfs_latest_ctl);
+
+	req.id = &pi->id;
+	req.group_id = group_id;
+	req.sync = 1;
+	req.complete = pohmelfs_read_latest_complete;
+
+	return pohmelfs_send_script_request(pi, &req);
+}
+
+static int pohmelfs_read_latest(struct pohmelfs_inode *pi)
+{
+	struct pohmelfs_latest_ctl *r;
+	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
+	int i, err = -ENOENT;
+
+	r = kzalloc(sizeof(struct pohmelfs_latest_ctl), GFP_NOIO);
+	if (!r) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	dnet_setup_id(&r->id, 0, pi->id.id);
+
+	for (i = 0; i < psb->group_num; ++i) {
+		r->id.group_id = psb->groups[i];
+
+		err = pohmelfs_read_latest_group(pi, r, psb->groups[i]);
+		if (err)
+			continue;
+
+		break;
+	}
+
+	kfree(r);
+
+	pr_debug("pohmelfs: %s: read-latest: %d groups\n", pohmelfs_dump_id(pi->id.id), pi->group_num);
+
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_file_open(struct inode *inode, struct file *filp)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+
+	if (!pi->group_num)
+		pohmelfs_read_latest(pi);
+
+	return generic_file_open(inode, filp);
+}
+
+/*
+ * We want fsync() to work on POHMELFS.
+ */
+static int pohmelfs_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
+{
+	struct inode *inode = filp->f_mapping->host;
+	int err = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (!err) {
+		mutex_lock(&inode->i_mutex);
+		err = sync_inode_metadata(inode, 1);
+		mutex_unlock(&inode->i_mutex);
+	}
+	pr_debug("pohmelfs: fsync: %s: start: %lld, end: %lld, nrpages: %ld, dirty: %d: %d\n",
+			pohmelfs_dump_id(pohmelfs_inode(inode)->id.id),
+			(unsigned long long)start, (unsigned long long)end,
+			inode->i_mapping->nrpages, mapping_cap_writeback_dirty(inode->i_mapping), err);
+	return err;
+}
+
+static int pohmelfs_flush(struct file *filp, fl_owner_t id)
+{
+	struct inode *inode = filp->f_mapping->host;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	int err = 0;
+
+	if (psb->sync_on_close)
+		err = pohmelfs_fsync(filp, 0, ~0ULL, 1);
+
+	if (!err && test_bit(AS_EIO, &inode->i_mapping->flags))
+		err = -EIO;
+
+	pr_debug("pohmelfs: flush: %s: %d\n", pohmelfs_dump_id(pohmelfs_inode(inode)->id.id), err);
+	return err;
+}
+
+const struct file_operations pohmelfs_file_ops = {
+	.open		= pohmelfs_file_open,
+
+	.llseek		= generic_file_llseek,
+
+	.read		= do_sync_read,
+	.aio_read	= generic_file_aio_read,
+
+	.mmap		= generic_file_mmap,
+
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
+
+	.write		= do_sync_write,
+	.aio_write	= generic_file_aio_write,
+
+	.fallocate	= pohmelfs_fallocate,
+
+	.fsync		= pohmelfs_fsync,
+	.flush		= pohmelfs_flush,
+};
+
+const struct inode_operations pohmelfs_file_inode_operations = {
+};
diff --git a/fs/pohmelfs/inode.c b/fs/pohmelfs/inode.c
new file mode 100644
index 0000000..85bd011
--- /dev/null
+++ b/fs/pohmelfs/inode.c
@@ -0,0 +1,900 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/cred.h>
+#include <linux/fiemap.h>
+#include <linux/fs.h>
+#include <linux/fs_struct.h>
+#include <linux/mpage.h>
+#include <linux/mount.h>
+#include <linux/mm.h>
+#include <linux/namei.h>
+#include <linux/pagevec.h>
+#include <linux/pagemap.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/writeback.h>
+
+#include "pohmelfs.h"
+
+char *pohmelfs_dump_id_len_raw(const unsigned char *id, unsigned int len, char *dst)
+{
+	unsigned int i;
+
+	if (len > SHA512_DIGEST_SIZE)
+		len = SHA512_DIGEST_SIZE;
+
+	for (i=0; i<len; ++i)
+		sprintf(&dst[2*i], "%02x", id[i]);
+	return dst;
+}
+
+#define pohmelfs_dump_len 6
+typedef struct {
+	char			id_str[pohmelfs_dump_len * 2 + 1];
+} pohmelfs_dump_t;
+static DEFINE_PER_CPU(pohmelfs_dump_t, pohmelfs_dump_per_cpu);
+
+char *pohmelfs_dump_id(const unsigned char *id)
+{
+	pohmelfs_dump_t *ptr;
+
+	ptr = &get_cpu_var(pohmelfs_dump_per_cpu);
+	pohmelfs_dump_id_len_raw(id, pohmelfs_dump_len, ptr->id_str);
+	put_cpu_var(ptr);
+
+	return ptr->id_str;
+}
+
+#define dnet_raw_id_scratch 6
+typedef struct {
+	unsigned long 			rand;
+	struct timespec			ts;
+} dnet_raw_id_scratch_t;
+static DEFINE_PER_CPU(dnet_raw_id_scratch_t, dnet_raw_id_scratch_per_cpu);
+
+static int pohmelfs_gen_id(struct pohmelfs_sb *psb, struct dnet_raw_id *id)
+{
+	dnet_raw_id_scratch_t *sc;
+	int err;
+	long rand;
+
+	get_random_bytes(&rand, sizeof(sc->rand));
+
+	sc = &get_cpu_var(dnet_raw_id_scratch_per_cpu);
+	sc->rand ^= rand;
+	sc->ts = CURRENT_TIME;
+
+	err = pohmelfs_hash(psb, sc, sizeof(dnet_raw_id_scratch_t), id);
+	put_cpu_var(sc);
+
+	return err;
+}
+
+#define UNHASHED_OBSCURE_STRING_SIZE		sizeof(" (deleted)")
+
+/*
+ * Create path from root for given inode.
+ * Path is formed as set of stuctures, containing name of the object
+ * and its inode data (mode, permissions and so on).
+ */
+static int pohmelfs_construct_path_string(struct pohmelfs_inode *pi, void *data, int len)
+{
+	struct path path;
+	struct dentry *d;
+	char *ptr;
+	int err = 0, strlen, reduce = 0;
+
+	d = d_find_alias(&pi->vfs_inode);
+	if (!d) {
+		err = -ENOENT;
+		goto err_out_exit;
+	}
+
+	spin_lock(&current->fs->lock);
+	path.mnt = mntget(current->fs->root.mnt);
+	spin_unlock(&current->fs->lock);
+
+	path.dentry = d;
+
+	if (!IS_ROOT(d) && d_unhashed(d))
+		reduce = 1;
+
+	ptr = d_path(&path, data, len);
+	if (IS_ERR(ptr)) {
+		err = PTR_ERR(ptr);
+		goto err_out_put;
+	}
+
+	if (reduce && len >= UNHASHED_OBSCURE_STRING_SIZE) {
+		char *end = data + len - UNHASHED_OBSCURE_STRING_SIZE;
+		*end = '\0';
+	}
+
+	strlen = len - (ptr - (char *)data);
+	memmove(data, ptr, strlen);
+	ptr = data;
+
+	err = strlen - 1; /* no including 0-byte */
+
+	pr_debug("%s: dname: '%s', len: %u, maxlen: %u, name: '%s', strlen: %d.\n",
+			__func__, d->d_name.name, d->d_name.len, len, ptr, strlen);
+
+err_out_put:
+	dput(d);
+	mntput(path.mnt);
+err_out_exit:
+	return err;
+}
+
+int pohmelfs_http_compat_id(struct pohmelfs_inode *pi)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
+	struct timespec ts = CURRENT_TIME;
+	int idx = ts.tv_nsec % psb->http_compat;
+	struct pohmelfs_path *p = &psb->path[idx];
+	int err;
+
+	mutex_lock(&p->lock);
+	err = pohmelfs_construct_path_string(pi, p->data, PAGE_SIZE);
+	if (err > 0) {
+		pohmelfs_hash(psb, p->data, err, &pi->id);
+	}
+	mutex_unlock(&p->lock);
+
+	return err;
+}
+
+static int pohmelfs_sb_inode_insert(struct pohmelfs_sb *psb, struct pohmelfs_inode *pi)
+{
+	struct rb_node **n = &psb->inode_root.rb_node, *parent = NULL;
+	struct pohmelfs_inode *tmp;
+	int cmp, err = 0;
+
+	spin_lock(&psb->inode_lock);
+	while (*n) {
+		parent = *n;
+
+		tmp = rb_entry(parent, struct pohmelfs_inode, node);
+
+		cmp = dnet_id_cmp_str(tmp->id.id, pi->id.id);
+		if (cmp < 0)
+			n = &parent->rb_left;
+		else if (cmp > 0)
+			n = &parent->rb_right;
+		else {
+			err = -EEXIST;
+			goto err_out_unlock;
+		}
+	}
+
+	rb_link_node(&pi->node, parent, n);
+	rb_insert_color(&pi->node, &psb->inode_root);
+
+err_out_unlock:
+	spin_unlock(&psb->inode_lock);
+
+	return err;
+}
+
+struct pohmelfs_inode *pohmelfs_sb_inode_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id)
+{
+	struct rb_node *n = psb->inode_root.rb_node;
+	struct pohmelfs_inode *pi, *found = NULL;
+	int cmp;
+
+	spin_lock(&psb->inode_lock);
+	while (n) {
+		pi = rb_entry(n, struct pohmelfs_inode, node);
+
+		cmp = dnet_id_cmp_str(pi->id.id, id->id);
+		if (cmp < 0) {
+			n = n->rb_left;
+		} else if (cmp > 0)
+			n = n->rb_right;
+		else {
+			found = pi;
+			break;
+		}
+	}
+	if (found) {
+		if (!igrab(&found->vfs_inode))
+			found = NULL;
+	}
+	spin_unlock(&psb->inode_lock);
+
+	return found;
+}
+
+struct inode *pohmelfs_alloc_inode(struct super_block *sb)
+{
+	struct pohmelfs_inode *pi;
+
+	pi = kmem_cache_zalloc(pohmelfs_inode_cache, GFP_NOIO);
+	if (!pi)
+		goto err_out_exit;
+
+	inode_init_once(&pi->vfs_inode);
+
+	rb_init_node(&pi->node);
+	mutex_init(&pi->lock);
+
+	return &pi->vfs_inode;
+
+err_out_exit:
+	return NULL;
+}
+
+void pohmelfs_destroy_inode(struct inode *inode)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+
+	pr_debug("pohmelfs: %s: destroy: ino: %ld, dirty: %lx\n", pohmelfs_dump_id(pi->id.id), inode->i_ino, inode->i_state & I_DIRTY);
+
+	kfree(pi->groups);
+	kmem_cache_free(pohmelfs_inode_cache, pi);
+}
+
+int pohmelfs_hash(struct pohmelfs_sb *psb, const void *data, const size_t size, struct dnet_raw_id *id)
+{
+	struct scatterlist sg;
+	struct hash_desc desc;
+
+	sg_init_table(&sg, 1);
+	sg_set_buf(&sg, data, size);
+
+	desc.tfm = psb->hash;
+	desc.flags = 0;
+
+	return crypto_hash_digest(&desc, &sg, size, id->id);
+}
+
+static void pohmelfs_readpages_destroy(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_wait *wait = t->priv;
+
+	wake_up(&wait->wq);
+	pohmelfs_wait_put(wait);
+}
+
+static int pohmelfs_readpages_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_wait *wait = t->priv;
+	struct dnet_cmd *cmd = &recv->cmd;
+
+	if (!(cmd->flags & DNET_FLAGS_MORE)) {
+		if (!wait->condition) {
+			wait->condition = cmd->status;
+			if (!wait->condition)
+				wait->condition = 1;
+		}
+	}
+
+	pr_debug("pohmelfs: %d:%s: pohmelfs_readpages_complete: read: %ld, wait: %d\n",
+		cmd->id.group_id, pohmelfs_dump_id(wait->pi->id.id), atomic_long_read(&wait->count), wait->condition);
+
+	return 0;
+}
+
+static int pohmelfs_readpages_init(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_wait *wait = t->priv;
+
+	pohmelfs_wait_get(wait);
+	return 0;
+}
+
+static int pohmelfs_readpages_recv_reply(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_wait *wait = t->priv;
+	struct pohmelfs_inode *pi = wait->pi;
+	struct address_space *mapping = wait->ret;
+	unsigned int asize = sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
+	void *data = &t->cmd.attr; /* overwrite send buffer used for attr/ioattr */
+	struct dnet_cmd *cmd = &recv->cmd;
+	pgoff_t offset;
+	struct page *page;
+	int err, size;
+
+	if (t->recv_offset < asize) {
+		size = asize - t->recv_offset;
+		data += t->recv_offset;
+		err = pohmelfs_recv(t, recv, data, size);
+		if (err < 0)
+			goto err_out_exit;
+
+		dnet_convert_io_attr(&t->cmd.p.io);
+	}
+
+	while (t->recv_offset != cmd->size) {
+		offset = (t->recv_offset - asize) & (PAGE_CACHE_SIZE - 1);
+		size = PAGE_CACHE_SIZE - offset;
+
+		if (size > cmd->size - t->recv_offset)
+			size = cmd->size - t->recv_offset;
+
+		page = find_or_create_page(mapping, (t->recv_offset - asize + t->cmd.p.io.offset) >> PAGE_CACHE_SHIFT, GFP_NOIO);
+		if (!page) {
+			err = -ENOMEM;
+			goto err_out_exit;
+		}
+
+		data = kmap(page);
+		err = pohmelfs_recv(t, recv, data + offset, size);
+		kunmap(page);
+
+		if (err > 0 && ((err + offset == PAGE_CACHE_SIZE) || (t->recv_offset == cmd->size)))  {
+			SetPageUptodate(page);
+		}
+
+		unlock_page(page);
+		page_cache_release(page);
+
+		if (err < 0)
+			goto err_out_exit;
+
+		atomic_long_add(err, &wait->count);
+	}
+
+	err = 0;
+
+err_out_exit:
+	if ((err < 0) && (err != -ENOENT) && (err != -EAGAIN))
+		pr_info("pohmelfs: %d:%s: pohmelfs_readpages_recv_data: offset: %lld, data size: %llu, err: %d\n",
+			cmd->id.group_id, pohmelfs_dump_id(pi->id.id), t->recv_offset - asize + t->cmd.p.io.offset,
+			(unsigned long long)cmd->size - asize, err);
+
+	return err;
+}
+
+static int pohmelfs_readpages_group(struct address_space *mapping, int group_id, pgoff_t offset, size_t size)
+{
+	struct inode *inode = mapping->host;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct pohmelfs_wait *wait;
+	struct pohmelfs_io *io;
+	long ret;
+	int err;
+
+	wait = pohmelfs_wait_alloc(pi);
+	if (!wait) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	io = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
+	if (!io) {
+		err = -ENOMEM;
+		goto err_out_put;
+	}
+
+	io->pi = pi;
+	io->id = &pi->id;
+	io->cmd = DNET_CMD_READ;
+	io->cflags = DNET_FLAGS_NEED_ACK;
+	io->offset = offset;
+	io->size = size;
+	if (psb->no_read_csum)
+		io->ioflags = DNET_IO_FLAGS_NOCSUM;
+	io->cb.init = pohmelfs_readpages_init;
+	io->cb.complete = pohmelfs_readpages_complete;
+	io->cb.destroy = pohmelfs_readpages_destroy;
+	io->cb.recv_reply = pohmelfs_readpages_recv_reply;
+	io->priv = wait;
+
+	/* it is safe, since we hold a reference to corresponding inode in wait->pi */
+	wait->ret = mapping;
+
+	err = pohmelfs_send_io_group(io, group_id);
+	if (err)
+		goto err_out_free;
+
+	ret = wait_event_interruptible_timeout(wait->wq, wait->condition != 0, msecs_to_jiffies(psb->read_wait_timeout));
+	if (ret <= 0) {
+		err = ret;
+		if (ret == 0)
+			err = -ETIMEDOUT;
+		goto err_out_free;
+	}
+
+	if (wait->condition < 0) {
+		err = wait->condition;
+		goto err_out_free;
+	}
+
+	err = atomic_long_read(&wait->count);
+
+err_out_free:
+	kmem_cache_free(pohmelfs_io_cache, io);
+err_out_put:
+	pohmelfs_wait_put(wait);
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_readpages_groups(struct address_space *mapping, pgoff_t offset, size_t size, int *groups, int group_num)
+{
+	int err = -ENOENT;
+	int i;
+
+	for (i = 0; i < group_num; ++i) {
+		err = pohmelfs_readpages_group(mapping, groups[i], offset, size);
+		if (err < 0)
+			continue;
+
+		err = 0;
+		break;
+	}
+
+	return err;
+}
+
+static int pohmelfs_readpages(struct file *filp, struct address_space *mapping,
+			struct list_head *pages, unsigned nr_pages)
+{
+	struct inode *inode = mapping->host;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	int err = -ENOENT;
+	pgoff_t offset = ~0UL;
+	struct page *tmp, *page;
+
+	list_for_each_entry_safe(page, tmp, pages, lru) {
+		list_del(&page->lru);
+
+		if (page_offset(page) < offset)
+			offset = page_offset(page);
+
+		/*
+		 * we do not really care about these pages
+		 * completion callback will try to find it in mapping
+		 * and will allocate new pages if mapping is empty
+		 */
+		if (!add_to_page_cache_lru(page, mapping, page->index, GFP_KERNEL))
+			unlock_page(page);
+		page_cache_release(page);
+	}
+
+	if (pi->group_num) {
+		err = pohmelfs_readpages_groups(mapping, offset, nr_pages * PAGE_CACHE_SIZE, pi->groups, pi->group_num);
+	} else {
+		err = pohmelfs_readpages_groups(mapping, offset, nr_pages * PAGE_CACHE_SIZE, psb->groups, psb->group_num);
+	}
+
+	pr_debug("pohmelfs: %s: readpages: ino: %lu, offset: %lu, pages: %u: %d\n",
+			pohmelfs_dump_id(pi->id.id), inode->i_ino, offset, nr_pages, err);
+
+	return err;
+}
+
+static int pohmelfs_readpage(struct file *file, struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	int i, err = -ENOENT;
+
+	if (inode->i_size <= page->index << PAGE_CACHE_SHIFT) {
+		SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
+
+	unlock_page(page);
+
+	for (i = 0; i < psb->group_num; ++i) {
+		err = pohmelfs_readpages_group(page->mapping, psb->groups[i], page_offset(page), PAGE_CACHE_SIZE);
+		if (err < 0)
+			continue;
+
+		err = 0;
+		break;
+	}
+
+	if ((err < 0) && (err != -ENOENT))
+		pr_err("pohmelfs: %s: readpage: ino: %lu, offset: %lu, uptodate: %d, err: %d\n",
+			pohmelfs_dump_id(pohmelfs_inode(inode)->id.id), inode->i_ino, (long)page_offset(page),
+			PageUptodate(page), err);
+	return err;
+}
+
+void pohmelfs_write_ctl_release(struct kref *kref)
+{
+	struct pohmelfs_write_ctl *ctl = container_of(kref, struct pohmelfs_write_ctl, refcnt);
+	struct address_space *mapping = ctl->pvec.pages[0]->mapping;
+	struct inode *inode = mapping->host;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	int bad_write = atomic_read(&ctl->good_writes) < psb->group_num / 2 + 1;
+	struct page *page;
+	unsigned int i;
+
+	if (psb->successful_write_count && (atomic_read(&ctl->good_writes) >= psb->successful_write_count))
+		bad_write = 0;
+
+	if (bad_write) {
+		struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+		unsigned long long offset = page_offset(ctl->pvec.pages[0]);
+
+		pr_debug("pohmelfs: %s: bad write: ino: %lu, isize: %llu, offset: %llu: writes: %d/%d\n",
+				pohmelfs_dump_id(pi->id.id),
+				inode->i_ino, inode->i_size, offset,
+				atomic_read(&ctl->good_writes), psb->group_num);
+		mapping_set_error(mapping, -EIO);
+	}
+
+	for (i = 0; i < pagevec_count(&ctl->pvec); ++i) {
+		page = ctl->pvec.pages[i];
+
+		if (PageLocked(page)) {
+			end_page_writeback(page);
+
+			if (bad_write) {
+				SetPageError(page);
+				ClearPageUptodate(page);
+				set_page_dirty(page);
+			}
+			unlock_page(page);
+		}
+	}
+
+	pagevec_release(&ctl->pvec);
+	kmem_cache_free(pohmelfs_write_cache, ctl);
+}
+
+static int pohmelfs_writepages_chunk(struct pohmelfs_inode *pi, struct pohmelfs_write_ctl *ctl, struct writeback_control *wbc)
+{
+	struct inode *inode = &pi->vfs_inode;
+	uint64_t offset, size;
+	unsigned i;
+	int err;
+
+	offset = page_offset(ctl->pvec.pages[0]);
+
+	size = 0;
+	/* we will lookup them again when doing actual send */
+	for (i = 0; i< pagevec_count(&ctl->pvec); ++i) {
+		struct page *page = ctl->pvec.pages[i];
+
+		lock_page(page);
+		/* just write all pages even if they were truncated - this is handled by inode info metadata */
+#if 0
+		if (unlikely(page->mapping != mapping)) {
+continue_unlock:
+			unlock_page(page);
+			continue;
+		}
+
+		if (!PageDirty(page))
+			goto continue_unlock;
+
+		if (!clear_page_dirty_for_io(page))
+			goto continue_unlock;
+#else
+		clear_page_dirty_for_io(page);
+#endif
+
+		set_page_writeback(page);
+
+		size += PAGE_CACHE_SIZE;
+		wbc->nr_to_write--;
+	}
+
+	if (offset + size > inode->i_size)
+		size = inode->i_size - offset;
+
+	err = pohmelfs_write_command(pi, ctl, offset, size);
+	if (err)
+		goto err_out_exit;
+
+err_out_exit:
+	kref_put(&ctl->refcnt, pohmelfs_write_ctl_release);
+	return err;
+}
+
+static int pohmelfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct pohmelfs_write_ctl *ctl;
+	pgoff_t index;
+	pgoff_t end;		/* Inclusive */
+	int nr_pages, err = 0;
+
+	index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end = wbc->range_end >> PAGE_CACHE_SHIFT;
+
+	pr_debug("pohmelfs: %s: writepages: ino: %ld, nr: %ld, index: %llu, end: %llu, total_size: %lu, sync: %d\n",
+			pohmelfs_dump_id(pohmelfs_inode(inode)->id.id), inode->i_ino,
+			wbc->nr_to_write, wbc->range_start, wbc->range_end, (unsigned long)inode->i_size, wbc->sync_mode);
+
+	if ((!wbc->range_start && !wbc->range_end) || !inode->i_size) {
+		err = 0;
+		goto err_out_exit;
+	}
+
+	while (index <= end) {
+		ctl = kmem_cache_zalloc(pohmelfs_write_cache, GFP_NOIO);
+		if (!ctl) {
+			err = -ENOMEM;
+			goto err_out_exit;
+		}
+
+		kref_init(&ctl->refcnt);
+		atomic_set(&ctl->good_writes, 0);
+
+		nr_pages = pagevec_lookup_tag(&ctl->pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (!nr_pages) {
+			err = 0;
+			kmem_cache_free(pohmelfs_write_cache, ctl);
+			break;
+		}
+
+		err = pohmelfs_writepages_chunk(pi, ctl, wbc);
+		if (err)
+			goto err_out_exit;
+	}
+
+	err = pohmelfs_metadata_inode(pi, wbc->sync_mode != WB_SYNC_NONE);
+	if (err)
+		goto err_out_exit;
+
+
+	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+		err = -EIO;
+err_out_exit:
+	pr_debug("pohmelfs: %s: metadata write complete: %d\n", pohmelfs_dump_id(pi->id.id), err);
+	return err;
+}
+
+static const struct address_space_operations pohmelfs_aops = {
+	.write_begin		= simple_write_begin,
+	.write_end		= simple_write_end,
+	.writepages		= pohmelfs_writepages,
+	.readpage		= pohmelfs_readpage,
+	.readpages		= pohmelfs_readpages,
+	.set_page_dirty 	= __set_page_dirty_nobuffers,
+};
+
+void pohmelfs_convert_inode_info(struct pohmelfs_inode_info *info)
+{
+	info->ino = cpu_to_le64(info->ino);
+	info->mode = cpu_to_le64(info->mode);
+	info->nlink = cpu_to_le64(info->nlink);
+	info->uid = cpu_to_le32(info->uid);
+	info->gid = cpu_to_le32(info->gid);
+	info->namelen = cpu_to_le32(info->namelen);
+	info->blocks = cpu_to_le64(info->blocks);
+	info->rdev = cpu_to_le64(info->rdev);
+	info->size = cpu_to_le64(info->size);
+	info->version = cpu_to_le64(info->version);
+	info->blocksize = cpu_to_le64(info->blocksize);
+	info->flags = cpu_to_le64(info->flags);
+
+	dnet_convert_time(&info->ctime);
+	dnet_convert_time(&info->mtime);
+	dnet_convert_time(&info->atime);
+}
+
+void pohmelfs_fill_inode_info(struct inode *inode, struct pohmelfs_inode_info *info)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+
+	memcpy(info->id.id, pi->id.id, DNET_ID_SIZE);
+
+	info->ino = inode->i_ino;
+	info->mode = inode->i_mode;
+	info->nlink = inode->i_nlink;
+	info->uid = inode->i_uid;
+	info->gid = inode->i_gid;
+	info->blocks = inode->i_blocks;
+	info->rdev = inode->i_rdev;
+	info->size = inode->i_size;
+	info->version = inode->i_version;
+	info->blocksize = 1 << inode->i_blkbits;
+
+	info->ctime.tsec = inode->i_ctime.tv_sec;
+	info->ctime.tnsec = inode->i_ctime.tv_nsec;
+
+	info->mtime.tsec = inode->i_mtime.tv_sec;
+	info->mtime.tnsec = inode->i_mtime.tv_nsec;
+
+	info->atime.tsec = inode->i_atime.tv_sec;
+	info->atime.tnsec = inode->i_atime.tv_nsec;
+
+	info->flags = 0;
+}
+
+void pohmelfs_fill_inode(struct inode *inode, struct pohmelfs_inode_info *info)
+{
+	pr_debug("pohmelfs: %s: ino: %lu inode is regular: %d, dir: %d, link: %d, mode: %o, "
+			"namelen: %u, size: %llu, state: %lx, mtime: %llu.%llu/%lu.%lu\n",
+			pohmelfs_dump_id(info->id.id), inode->i_ino,
+			S_ISREG(inode->i_mode), S_ISDIR(inode->i_mode),
+			S_ISLNK(inode->i_mode), inode->i_mode, info->namelen, inode->i_size, inode->i_state,
+			(unsigned long long)info->mtime.tsec, (unsigned long long)info->mtime.tnsec,
+			inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec);
+
+	if (info->mtime.tsec < inode->i_mtime.tv_sec)
+		return;
+	if ((info->mtime.tsec == inode->i_mtime.tv_sec) &&
+			(info->mtime.tnsec < inode->i_mtime.tv_nsec))
+		return;
+
+	pohmelfs_inode(inode)->id = info->id;
+
+	inode->i_mode = info->mode;
+	inode->i_nlink = info->nlink;
+	inode->i_uid = info->uid;
+	inode->i_gid = info->gid;
+	inode->i_blocks = info->blocks;
+	inode->i_rdev = info->rdev;
+	inode->i_size = info->size;
+	inode->i_version = info->version;
+	inode->i_blkbits = ffs(info->blocksize);
+
+	inode->i_mtime = pohmelfs_date(&info->mtime);
+	inode->i_atime = pohmelfs_date(&info->atime);
+	inode->i_ctime = pohmelfs_date(&info->ctime);
+}
+
+static void pohmelfs_inode_info_current(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info)
+{
+	struct timespec ts = CURRENT_TIME;
+	struct dnet_time dtime;
+
+	info->nlink = S_ISDIR(info->mode) ? 2 : 1;
+	info->uid = current_fsuid();
+	info->gid = current_fsgid();
+	info->size = 0;
+	info->blocksize = PAGE_SIZE;
+	info->blocks = 0;
+	info->rdev = 0;
+	info->version = 0;
+
+	dtime.tsec = ts.tv_sec;
+	dtime.tnsec = ts.tv_nsec;
+
+	info->ctime = dtime;
+	info->mtime = dtime;
+	info->atime = dtime;
+
+	pohmelfs_gen_id(psb, &info->id);
+}
+
+const struct inode_operations pohmelfs_special_inode_operations = {
+	.setattr			= simple_setattr,
+};
+
+struct pohmelfs_inode *pohmelfs_existing_inode(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info)
+{
+	struct pohmelfs_inode *pi;
+	struct inode *inode;
+	int err;
+
+	inode = iget_locked(psb->sb, atomic_long_inc_return(&psb->ino));
+	if (!inode) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	pi = pohmelfs_inode(inode);
+
+	if (inode->i_state & I_NEW) {
+		pohmelfs_fill_inode(inode, info);
+		/*
+		 * i_mapping is a pointer to i_data during inode initialization.
+		 */
+		inode->i_data.a_ops = &pohmelfs_aops;
+
+		if (S_ISREG(inode->i_mode)) {
+			inode->i_fop = &pohmelfs_file_ops;
+			inode->i_op = &pohmelfs_file_inode_operations;
+		} else if (S_ISDIR(inode->i_mode)) {
+			inode->i_fop = &pohmelfs_dir_fops;
+			inode->i_op = &pohmelfs_dir_inode_operations;
+		} else if (S_ISLNK(inode->i_mode)) {
+			inode->i_op = &pohmelfs_symlink_inode_operations;
+			inode->i_mapping->a_ops = &pohmelfs_aops;
+		} else {
+			inode->i_op = &pohmelfs_special_inode_operations;
+		}
+
+		err = pohmelfs_sb_inode_insert(psb, pi);
+		if (err)
+			goto err_out_put;
+
+		unlock_new_inode(inode);
+	}
+
+	return pi;
+
+err_out_put:
+	unlock_new_inode(inode);
+	iput(inode);
+err_out_exit:
+	return ERR_PTR(err);
+}
+
+struct pohmelfs_inode *pohmelfs_new_inode(struct pohmelfs_sb *psb, int mode)
+{
+	struct pohmelfs_inode *pi;
+	struct pohmelfs_inode_info *info;
+	int err;
+
+	info = kmem_cache_zalloc(pohmelfs_inode_info_cache, GFP_NOIO);
+	if (!info) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	info->mode = mode;
+
+	pohmelfs_inode_info_current(psb, info);
+
+	pi = pohmelfs_existing_inode(psb, info);
+	if (IS_ERR(pi)) {
+		err = PTR_ERR(pi);
+		goto err_out_free;
+	}
+
+	kmem_cache_free(pohmelfs_inode_info_cache, info);
+	return pi;
+
+err_out_free:
+	kmem_cache_free(pohmelfs_inode_info_cache, info);
+err_out_exit:
+	return ERR_PTR(err);
+}
+
+int pohmelfs_wait_init(struct pohmelfs_wait *wait, struct pohmelfs_inode *pi)
+{
+	if (!igrab(&pi->vfs_inode))
+		return -EINVAL;
+
+	wait->pi = pi;
+
+	atomic_long_set(&wait->count, 0);
+	init_waitqueue_head(&wait->wq);
+	kref_init(&wait->refcnt);
+
+	return 0;
+}
+
+struct pohmelfs_wait *pohmelfs_wait_alloc(struct pohmelfs_inode *pi)
+{
+	struct pohmelfs_wait *wait;
+
+	wait = kmem_cache_zalloc(pohmelfs_wait_cache, GFP_NOIO);
+	if (!wait) {
+		goto err_out_exit;
+	}
+
+	if (pohmelfs_wait_init(wait, pi))
+		goto err_out_free;
+
+	return wait;
+
+err_out_free:
+	kmem_cache_free(pohmelfs_wait_cache, wait);
+err_out_exit:
+	return NULL;
+}
+
+static void pohmelfs_wait_free(struct kref *kref)
+{
+	struct pohmelfs_wait *wait = container_of(kref, struct pohmelfs_wait, refcnt);
+	struct inode *inode = &wait->pi->vfs_inode;
+
+	iput(inode);
+	kmem_cache_free(pohmelfs_wait_cache, wait);
+}
+
+void pohmelfs_wait_put(struct pohmelfs_wait *wait)
+{
+	kref_put(&wait->refcnt, pohmelfs_wait_free);
+}
diff --git a/fs/pohmelfs/net.c b/fs/pohmelfs/net.c
new file mode 100644
index 0000000..8882ff0
--- /dev/null
+++ b/fs/pohmelfs/net.c
@@ -0,0 +1,611 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/net.h>
+
+#include <net/sock.h>
+#include <net/tcp.h>
+
+#include "pohmelfs.h"
+
+void *pohmelfs_scratch_buf;
+int pohmelfs_scratch_buf_size = 4096;
+
+void pohmelfs_print_addr(struct sockaddr_storage *addr, const char *fmt, ...)
+{
+	struct sockaddr *sa = (struct sockaddr *)addr;
+	va_list args;
+	char *ptr;
+
+	va_start(args, fmt);
+	ptr = kvasprintf(GFP_NOIO, fmt, args);
+	if (!ptr)
+		goto err_out_exit;
+
+	if (sa->sa_family == AF_INET) {
+		struct sockaddr_in *sin = (struct sockaddr_in *)addr;
+		pr_info("pohmelfs: %pI4:%d: %s", &sin->sin_addr.s_addr, ntohs(sin->sin_port), ptr);
+	} else if (sa->sa_family == AF_INET6) {
+		struct sockaddr_in6 *sin = (struct sockaddr_in6 *)addr;
+		pr_info("pohmelfs: %pI6:%d: %s", &sin->sin6_addr, ntohs(sin->sin6_port), ptr);
+	}
+
+err_out_exit:
+	va_end(args);
+}
+
+/*
+ * Basic network sending/receiving functions.
+ * Blocked mode is used.
+ */
+int pohmelfs_data_recv(struct pohmelfs_state *st, void *buf, u64 size, unsigned int flags)
+{
+	struct msghdr msg;
+	struct kvec iov;
+	int err;
+
+	BUG_ON(!size);
+
+	iov.iov_base = buf;
+	iov.iov_len = size;
+
+	msg.msg_iov = (struct iovec *)&iov;
+	msg.msg_iovlen = 1;
+	msg.msg_name = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags = flags;
+
+	err = kernel_recvmsg(st->sock, &msg, &iov, 1, iov.iov_len, msg.msg_flags);
+	if (err <= 0) {
+		if (err == 0)
+			err = -ECONNRESET;
+		goto err_out_exit;
+	}
+
+err_out_exit:
+	return err;
+}
+
+int pohmelfs_recv(struct pohmelfs_trans *t, struct pohmelfs_state *recv, void *data, int size)
+{
+	int err;
+
+	err = pohmelfs_data_recv(recv, data, size, MSG_DONTWAIT);
+	if (err < 0)
+		return err;
+
+	t->recv_offset += err;
+	return err;
+}
+
+static int pohmelfs_data_send(struct pohmelfs_trans *t)
+{
+	struct msghdr msg;
+	struct iovec io[2];
+	int err, ionum = 1;
+
+	io[0].iov_base = &t->cmd;
+	io[0].iov_len = t->header_size;
+
+	if (t->data) {
+		io[1].iov_base = t->data;
+		io[1].iov_len = t->data_size;
+		ionum = 2;
+	}
+
+	msg.msg_name = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags = MSG_WAITALL;
+
+	msg.msg_iov = io;
+	msg.msg_iovlen = ionum;
+
+	err = kernel_sendmsg(t->st->sock, &msg, (struct kvec *)msg.msg_iov, ionum, t->data_size + t->header_size);
+	if (err <= 0) {
+		if (err == 0)
+			err = -ECONNRESET;
+		goto err_out_exit;
+	}
+
+	err = 0;
+
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_page_send(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_write_ctl *ctl = t->wctl;
+	size_t size = le64_to_cpu(t->cmd.p.io.size);
+	pgoff_t offset = le64_to_cpu(t->cmd.p.io.offset);
+	struct msghdr msg;
+	struct iovec io;
+	unsigned i;
+	int err;
+
+	io.iov_base = &t->cmd;
+	io.iov_len = t->header_size;
+
+	msg.msg_name = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags = MSG_WAITALL;
+
+	msg.msg_iov = &io;
+	msg.msg_iovlen = 1;
+
+	err = kernel_sendmsg(t->st->sock, &msg, (struct kvec *)msg.msg_iov, 1, t->header_size);
+	if (err <= 0) {
+		if (err == 0)
+			err = -ECONNRESET;
+		goto err_out_exit;
+	}
+
+	for (i = 0; i< pagevec_count(&ctl->pvec); ++i) {
+		struct page *page = ctl->pvec.pages[i];
+		pgoff_t off = offset & (PAGE_CACHE_SIZE - 1);
+		size_t sz = PAGE_CACHE_SIZE - off;
+
+		if (sz > size)
+			sz = size;
+
+		err = kernel_sendpage(t->st->sock, page, off, sz, msg.msg_flags);
+		if (err <= 0) {
+			if (err == 0)
+				err = -ECONNRESET;
+
+			goto err_out_reset;
+		}
+
+		size -= err;
+		offset += err;
+
+	}
+
+	return 0;
+
+err_out_reset:
+err_out_exit:
+	return err;
+}
+
+/*
+ * Polling machinery.
+ */
+
+struct pohmelfs_poll_helper {
+	poll_table 		pt;
+	struct pohmelfs_state	*st;
+};
+
+static int pohmelfs_queue_wake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct pohmelfs_state *st = container_of(wait, struct pohmelfs_state, wait);
+
+	queue_work(st->psb->wq, &st->recv_work);
+	return 1;
+}
+
+static void pohmelfs_queue_func(struct file *file, wait_queue_head_t *whead, poll_table *pt)
+{
+	struct pohmelfs_state *st = container_of(pt, struct pohmelfs_poll_helper, pt)->st;
+
+	st->whead = whead;
+
+	init_waitqueue_func_entry(&st->wait, pohmelfs_queue_wake);
+	add_wait_queue(whead, &st->wait);
+}
+
+static void pohmelfs_poll_exit(struct pohmelfs_state *st)
+{
+	if (st->whead) {
+		remove_wait_queue(st->whead, &st->wait);
+		st->whead = NULL;
+	}
+}
+
+static int pohmelfs_poll_init(struct pohmelfs_state *st)
+{
+	struct pohmelfs_poll_helper ph;
+
+	ph.st = st;
+	init_poll_funcptr(&ph.pt, &pohmelfs_queue_func);
+
+	st->sock->ops->poll(NULL, st->sock, &ph.pt);
+	return 0;
+}
+
+static void pohmelfs_state_send_work(struct work_struct *work)
+{
+	struct pohmelfs_state *st = container_of(work, struct pohmelfs_state, send_work);
+	struct pohmelfs_trans *t;
+	int err;
+
+	while (1) {
+		t = NULL;
+
+		mutex_lock(&st->trans_lock);
+		if (!list_empty(&st->trans_list)) {
+			t = list_first_entry(&st->trans_list, struct pohmelfs_trans, trans_entry);
+			list_move(&t->trans_entry, &st->sent_trans_list);
+		}
+		mutex_unlock(&st->trans_lock);
+
+		if (!t)
+			break;
+
+		if (t->wctl)
+			err = pohmelfs_page_send(t);
+		else
+			err = pohmelfs_data_send(t);
+
+		if (err) {
+			pohmelfs_print_addr(&st->sa, "send error: %d\n", err);
+
+			pohmelfs_state_add_reconnect(st);
+			break;
+		}
+	}
+}
+
+static void pohmelfs_suck_scratch(struct pohmelfs_state *st)
+{
+	struct dnet_cmd *cmd = &st->cmd;
+	int err = 0;
+
+	pr_debug("pohmelfs_suck_scratch: %llu\n", (unsigned long long)cmd->size);
+
+	while (cmd->size) {
+		int sz = pohmelfs_scratch_buf_size;
+
+		if (cmd->size < sz)
+			sz = cmd->size;
+
+		err = pohmelfs_data_recv(st, pohmelfs_scratch_buf, sz, MSG_WAITALL);
+		if (err < 0) {
+			pohmelfs_print_addr(&st->sa, "recv-scratch err: %d\n", err);
+			goto err_out_exit;
+		}
+
+		cmd->size -= err;
+	}
+
+err_out_exit:
+	st->cmd_read = 1;
+}
+
+static void pohmelfs_state_recv_work(struct work_struct *work)
+{
+	struct pohmelfs_state *st = container_of(work, struct pohmelfs_state, recv_work);
+	struct dnet_cmd *cmd = &st->cmd;
+	struct pohmelfs_trans *t;
+	unsigned long long trans;
+	unsigned int revents;
+	int err = 0;
+
+	while (1) {
+		revents = st->sock->ops->poll(NULL, st->sock, NULL);
+		if (!(revents & POLLIN))
+			break;
+
+		if (st->cmd_read) {
+			err = pohmelfs_data_recv(st, cmd, sizeof(struct dnet_cmd), MSG_WAITALL);
+			if (err < 0) {
+				pohmelfs_print_addr(&st->sa, "recv error: %d\n", err);
+				goto err_out_exit;
+			}
+
+			dnet_convert_cmd(cmd);
+
+			trans = cmd->trans & ~DNET_TRANS_REPLY;
+			st->cmd_read = 0;
+		}
+
+		t = pohmelfs_trans_lookup(st, cmd);
+		if (!t) {
+			pohmelfs_suck_scratch(st);
+
+			err = 0;
+			goto err_out_continue;
+		}
+		if (cmd->size && (t->recv_offset != cmd->size)) {
+			err = t->cb.recv_reply(t, st);
+			if (err && (err != -EAGAIN)) {
+				pohmelfs_print_addr(&st->sa, "recv-reply error: %d\n", err);
+				goto err_out_remove;
+			}
+
+			if (t->recv_offset != cmd->size)
+				goto err_out_continue_put;
+		}
+
+		err = t->cb.complete(t, st);
+		if (err) {
+			pohmelfs_print_addr(&st->sa, "recv-complete err: %d\n", err);
+		}
+
+		kfree(t->recv_data);
+		t->recv_data = NULL;
+		t->recv_offset = 0;
+
+err_out_remove:
+		/* only remove and free transaction if there is error or there will be no more replies */
+		if (!(cmd->flags & DNET_FLAGS_MORE) || err) {
+			mutex_lock(&st->trans_lock);
+			list_del(&t->trans_entry);
+			mutex_unlock(&st->trans_lock);
+
+			/*
+			 * refcnt was grabbed twice:
+			 *   in pohmelfs_trans_lookup()
+			 *   and at transaction creation
+			 */
+			pohmelfs_trans_put(t);
+		}
+		st->cmd_read = 1;
+		if (err) {
+			cmd->size -= t->recv_offset;
+			t->recv_offset = 0;
+		}
+err_out_continue_put:
+		pohmelfs_trans_put(t);
+
+err_out_continue:
+		if (err && (err != -EAGAIN)) {
+			//pohmelfs_suck_scratch(st);
+			goto err_out_exit;
+		}
+
+		continue;
+	}
+
+err_out_exit:
+	if (err && err != -EAGAIN)
+		pohmelfs_state_add_reconnect(st);
+	return;
+}
+
+struct pohmelfs_state *pohmelfs_addr_exist(struct pohmelfs_sb *psb, struct sockaddr_storage *sa, int addrlen)
+{
+	struct pohmelfs_state *st;
+
+	list_for_each_entry(st, &psb->state_list, state_entry) {
+		if (st->addrlen != addrlen)
+			continue;
+
+		if (!memcmp(&st->sa, sa, addrlen)) {
+			return st;
+		}
+	}
+
+	return 0;
+}
+
+struct pohmelfs_state *pohmelfs_state_create(struct pohmelfs_sb *psb, struct sockaddr_storage *sa, int addrlen,
+		int ask_route, int group_id)
+{
+	int err = 0;
+	struct pohmelfs_state *st;
+	struct sockaddr *addr = (struct sockaddr *)sa;
+
+	/* early check - this state can be inserted into route table, no need to create state and check again */
+	spin_lock(&psb->state_lock);
+	if (pohmelfs_addr_exist(psb, sa, addrlen))
+		err = -EEXIST;
+	spin_unlock(&psb->state_lock);
+
+	if (err)
+		goto err_out_exit;
+
+	st = kzalloc(sizeof(struct pohmelfs_state), GFP_KERNEL);
+	if (!st) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	st->psb = psb;
+	mutex_init(&st->trans_lock);
+	INIT_LIST_HEAD(&st->trans_list);
+	INIT_LIST_HEAD(&st->sent_trans_list);
+
+	st->group_id = group_id;
+
+	kref_init(&st->refcnt);
+
+	INIT_WORK(&st->send_work, pohmelfs_state_send_work);
+	INIT_WORK(&st->recv_work, pohmelfs_state_recv_work);
+
+	st->cmd_read = 1;
+
+	err = sock_create(addr->sa_family, SOCK_STREAM, IPPROTO_TCP, &st->sock);
+	if (err) {
+		pohmelfs_print_addr(sa, "sock_create: failed family: %d, err: %d\n", addr->sa_family, err);
+		goto err_out_free;
+	}
+
+	st->sock->sk->sk_allocation = GFP_NOIO;
+	st->sock->sk->sk_sndtimeo = st->sock->sk->sk_rcvtimeo = msecs_to_jiffies(60000);
+
+	err = 1;
+	sock_setsockopt(st->sock, SOL_SOCKET, SO_KEEPALIVE, (char *)&err, 4);
+
+	tcp_setsockopt(st->sock->sk, SOL_TCP, TCP_KEEPIDLE, (char *)&psb->keepalive_idle, 4);
+	tcp_setsockopt(st->sock->sk, SOL_TCP, TCP_KEEPINTVL, (char *)&psb->keepalive_interval, 4);
+	tcp_setsockopt(st->sock->sk, SOL_TCP, TCP_KEEPCNT, (char *)&psb->keepalive_cnt, 4);
+
+	err = kernel_connect(st->sock, (struct sockaddr *)addr, addrlen, 0);
+	if (err) {
+		pohmelfs_print_addr(sa, "kernel_connect: failed family: %d, err: %d\n", addr->sa_family, err);
+		goto err_out_release;
+	}
+	st->sock->sk->sk_sndtimeo = st->sock->sk->sk_rcvtimeo = msecs_to_jiffies(60000);
+
+	memcpy(&st->sa, sa, sizeof(struct sockaddr_storage));
+	st->addrlen = addrlen;
+
+	pohmelfs_print_addr(sa, "connected\n");
+
+	err = pohmelfs_poll_init(st);
+	if (err)
+		goto err_out_shutdown;
+
+
+	spin_lock(&psb->state_lock);
+	err = -EEXIST;
+	if (!pohmelfs_addr_exist(psb, sa, addrlen)) {
+		list_add_tail(&st->state_entry, &psb->state_list);
+		err = 0;
+	}
+	spin_unlock(&psb->state_lock);
+
+	if (err)
+		goto err_out_poll_exit;
+
+	if (ask_route) {
+		err = pohmelfs_route_request(st);
+		if (err)
+			goto err_out_poll_exit;
+	}
+
+	return st;
+
+err_out_poll_exit:
+	pohmelfs_poll_exit(st);
+err_out_shutdown:
+	st->sock->ops->shutdown(st->sock, 2);
+err_out_release:
+	sock_release(st->sock);
+err_out_free:
+	kfree(st);
+err_out_exit:
+	if (err != -EEXIST) {
+		pohmelfs_print_addr(sa, "state creation failed: %d\n", err);
+	}
+	return ERR_PTR(err);
+}
+
+static void pohmelfs_state_exit(struct pohmelfs_state *st)
+{
+	if (!st->sock)
+		return;
+
+	pohmelfs_poll_exit(st);
+	st->sock->ops->shutdown(st->sock, 2);
+
+	pohmelfs_print_addr(&st->sa, "disconnected\n");
+	sock_release(st->sock);
+}
+
+static void pohmelfs_state_release(struct kref *kref)
+{
+	struct pohmelfs_state *st = container_of(kref, struct pohmelfs_state, refcnt);
+	pohmelfs_state_exit(st);
+}
+
+void pohmelfs_state_put(struct pohmelfs_state *st)
+{
+	kref_put(&st->refcnt, pohmelfs_state_release);
+}
+
+static void pohmelfs_state_clean(struct pohmelfs_state *st)
+{
+	struct pohmelfs_trans *t, *tmp;
+
+	pohmelfs_route_remove_all(st);
+
+	mutex_lock(&st->trans_lock);
+	list_for_each_entry_safe(t, tmp, &st->trans_list, trans_entry) {
+		list_del(&t->trans_entry);
+		pohmelfs_trans_put(t);
+	}
+
+	list_for_each_entry_safe(t, tmp, &st->sent_trans_list, trans_entry) {
+		list_del(&t->trans_entry);
+		pohmelfs_trans_put(t);
+	}
+	mutex_unlock(&st->trans_lock);
+
+	cancel_work_sync(&st->send_work);
+	cancel_work_sync(&st->recv_work);
+}
+
+void pohmelfs_state_kill(struct pohmelfs_state *st)
+{
+	BUG_ON(!list_empty(&st->state_entry));
+
+	pohmelfs_state_clean(st);
+	pohmelfs_state_put(st);
+}
+
+void pohmelfs_state_schedule(struct pohmelfs_state *st)
+{
+	struct pohmelfs_sb *psb = st->psb;
+
+	queue_work(psb->wq, &st->send_work);
+}
+
+int pohmelfs_state_add_reconnect(struct pohmelfs_state *st)
+{
+	struct pohmelfs_sb *psb = st->psb;
+	struct pohmelfs_reconnect *r, *tmp;
+	int err = 0;
+
+	pohmelfs_route_remove_all(st);
+
+	/*
+	 * Remove state from route table
+	 */
+	spin_lock(&psb->state_lock);
+	list_move(&st->state_entry, &psb->kill_state_list);
+	spin_unlock(&psb->state_lock);
+
+	r = kzalloc(sizeof(struct pohmelfs_reconnect), GFP_NOIO);
+	if (!r) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	memcpy(&r->sa, &st->sa, sizeof(struct sockaddr_storage));
+	r->addrlen = st->addrlen;
+	r->group_id = st->group_id;
+
+	mutex_lock(&psb->reconnect_lock);
+	list_for_each_entry(tmp, &psb->reconnect_list, reconnect_entry) {
+		if (tmp->addrlen != r->addrlen)
+			continue;
+
+		if (memcmp(&tmp->sa, &r->sa, r->addrlen))
+			continue;
+
+		err = -EEXIST;
+		break;
+	}
+
+	if (!err) {
+		list_add_tail(&r->reconnect_entry, &psb->reconnect_list);
+	}
+	mutex_unlock(&psb->reconnect_lock);
+
+	if (err)
+		goto err_out_free;
+
+	/* we do not really care if this work will not be processed immediately */
+	queue_delayed_work(psb->wq, &psb->reconnect_work, 0);
+
+	pohmelfs_print_addr(&st->sa, "reconnection added\n");
+	err = 0;
+	goto err_out_exit;
+
+err_out_free:
+	kfree(r);
+err_out_exit:
+	return err;
+}
diff --git a/fs/pohmelfs/packet.h b/fs/pohmelfs/packet.h
new file mode 100644
index 0000000..f432987
--- /dev/null
+++ b/fs/pohmelfs/packet.h
@@ -0,0 +1,752 @@
+/*
+ * 2008+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __DNET_PACKET_H
+#define __DNET_PACKET_H
+
+#ifndef __KERNEL__
+#include <sys/time.h>
+#include <arpa/inet.h>
+#include <sys/stat.h>
+
+#include <string.h>
+#include <stdint.h>
+
+#include <elliptics/typedefs.h>
+#include <elliptics/core.h>
+#endif
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+enum dnet_commands {
+	DNET_CMD_LOOKUP = 1,			/* Lookup address by ID and per-object info: size, permissions and so on*/
+	DNET_CMD_REVERSE_LOOKUP,		/* Lookup ID by address */
+	DNET_CMD_JOIN,				/* Join the network - force remote nodes to update
+						 * their route tables to include given node with given
+						 * address
+						 */
+	DNET_CMD_WRITE,
+	DNET_CMD_READ,				/* IO commands. They have to follow by the
+						 * IO attribute which will have offset and size
+						 * parameters.
+						 */
+	DNET_CMD_LIST,				/* List all objects for given node ID */
+	DNET_CMD_EXEC,				/* Execute given command on the remote node */
+	DNET_CMD_ROUTE_LIST,			/* Receive route table from given node */
+	DNET_CMD_STAT,				/* Gather remote VM, LA and FS statistics */
+	DNET_CMD_NOTIFY,			/* Notify when object in question was modified */
+	DNET_CMD_DEL,				/* Remove given object from the storage */
+	DNET_CMD_STAT_COUNT,			/* Gather remote per-cmd statistics */
+	DNET_CMD_STATUS,			/* Change elliptics node status */
+	DNET_CMD_READ_RANGE,			/* Read range of objects */
+	DNET_CMD_DEL_RANGE,			/* Remove range of objects */
+	DNET_CMD_AUTH,				/* Authentification cookie check */
+	DNET_CMD_BULK_READ,			/* Read a number of ids at one time */
+
+	DNET_CMD_UNKNOWN,			/* This slot is allocated for statistics gathered for unknown commands */
+	__DNET_CMD_MAX,
+};
+
+enum dnet_counters {
+	DNET_CNTR_LA1 = __DNET_CMD_MAX*2,	/* Load average for 1 min */
+	DNET_CNTR_LA5,				/* Load average for 5 min */
+	DNET_CNTR_LA15,				/* Load average for 15 min */
+	DNET_CNTR_BSIZE,			/* Block size */
+	DNET_CNTR_FRSIZE,			/* Fragment size */
+	DNET_CNTR_BLOCKS,			/* Filesystem size in frsize units */
+	DNET_CNTR_BFREE,			/* # free blocks */
+	DNET_CNTR_BAVAIL,			/* # free blocks for non-root */
+	DNET_CNTR_FILES,			/* # inodes */
+	DNET_CNTR_FFREE,			/* # free inodes */
+	DNET_CNTR_FAVAIL,			/* # free inodes for non-root */
+	DNET_CNTR_FSID,				/* File system ID */
+	DNET_CNTR_VM_ACTIVE,			/* Active memory */
+	DNET_CNTR_VM_INACTIVE,			/* Inactive memory */
+	DNET_CNTR_VM_TOTAL,			/* Total memory */
+	DNET_CNTR_VM_FREE,			/* Free memory */
+	DNET_CNTR_VM_CACHED,			/* Used for cache */
+	DNET_CNTR_VM_BUFFERS,			/* Used for buffers */
+	DNET_CNTR_NODE_FILES,			/* # files in meta */
+	DNET_CNTR_NODE_LAST_MERGE,		/* Result of the last merge */
+	DNET_CNTR_NODE_CHECK_COPY,		/* Result of the last check copies */
+	DNET_CNTR_DBR_NOREC,			/* Kyoto Cabinet DB read error KCENOREC */
+	DNET_CNTR_DBR_SYSTEM,			/* Kyoto Cabinet DB read error KCESYSTEM */
+	DNET_CNTR_DBR_ERROR,			/* Kyoto Cabinet DB read error */
+	DNET_CNTR_DBW_SYSTEM,			/* Kyoto Cabinet DB write error KCESYSTEM */
+	DNET_CNTR_DBW_ERROR,			/* Kyoto Cabinet DB write error */
+	DNET_CNTR_UNKNOWN,			/* This slot is allocated for statistics gathered for unknown counters */
+	__DNET_CNTR_MAX,
+};
+
+/*
+ * Transaction ID direction bit.
+ * When set, data is a reply for the given transaction.
+ */
+#define DNET_TRANS_REPLY		0x8000000000000000ULL
+
+/*
+ * Command flags.
+ */
+
+/*
+ * When set, node will generate a reply when transaction
+ * is completed and put completion status into cmd.status
+ * field.
+ */
+#define DNET_FLAGS_NEED_ACK		(1<<0)
+
+/* There will be more commands with the same parameters (transaction number and id) */
+#define DNET_FLAGS_MORE			(1<<1)
+
+/* Transaction is about to be destroyed */
+#define DNET_FLAGS_DESTROY		(1<<2)
+
+/* Do not forward requst to antoher node even if given ID does not belong to our range */
+#define DNET_FLAGS_DIRECT		(1<<3)
+
+/* Do not locks operations - must be set for script callers or recursive operations */
+#define DNET_FLAGS_NOLOCK		(1<<4)
+
+struct dnet_id {
+	uint8_t			id[DNET_ID_SIZE];
+	uint32_t		group_id;
+	int			type;
+} __attribute__ ((packed));
+
+struct dnet_raw_id {
+	uint8_t			id[DNET_ID_SIZE];
+} __attribute__ ((packed));
+
+static inline void dnet_convert_raw_id(struct dnet_raw_id *id __attribute__ ((unused)))
+{
+}
+
+static inline void dnet_setup_id(struct dnet_id *id, unsigned int group_id, unsigned char *raw)
+{
+	memcpy(id->id, raw, DNET_ID_SIZE);
+	id->group_id = group_id;
+}
+
+struct dnet_cmd
+{
+	struct dnet_id		id;
+	uint32_t		flags;
+	int			status;
+	uint64_t		trans;
+	uint64_t		size;
+	uint8_t			data[0];
+} __attribute__ ((packed));
+
+/* kernel (pohmelfs) provides own defines for byteorder changes */
+#ifndef __KERNEL__
+#ifdef WORDS_BIGENDIAN
+
+#define dnet_bswap16(x)		((((x) >> 8) & 0xff) | (((x) & 0xff) << 8))
+
+#define dnet_bswap32(x) \
+     ((((x) & 0xff000000) >> 24) | (((x) & 0x00ff0000) >>  8) |		      \
+      (((x) & 0x0000ff00) <<  8) | (((x) & 0x000000ff) << 24))
+
+#define dnet_bswap64(x) \
+     ((((x) & 0xff00000000000000ull) >> 56)				      \
+      | (((x) & 0x00ff000000000000ull) >> 40)				      \
+      | (((x) & 0x0000ff0000000000ull) >> 24)				      \
+      | (((x) & 0x000000ff00000000ull) >> 8)				      \
+      | (((x) & 0x00000000ff000000ull) << 8)				      \
+      | (((x) & 0x0000000000ff0000ull) << 24)				      \
+      | (((x) & 0x000000000000ff00ull) << 40)				      \
+      | (((x) & 0x00000000000000ffull) << 56))
+#else
+#define dnet_bswap16(x) (x)
+#define dnet_bswap32(x) (x)
+#define dnet_bswap64(x) (x)
+#endif
+#endif
+
+static inline void dnet_convert_id(struct dnet_id *id)
+{
+	id->group_id = dnet_bswap32(id->group_id);
+	id->type = dnet_bswap32(id->type);
+}
+
+static inline void dnet_convert_cmd(struct dnet_cmd *cmd)
+{
+	dnet_convert_id(&cmd->id);
+	cmd->flags = dnet_bswap32(cmd->flags);
+	cmd->status = dnet_bswap32(cmd->status);
+	cmd->size = dnet_bswap64(cmd->size);
+	cmd->trans = dnet_bswap64(cmd->trans);
+}
+
+/* Completely remove object history and metadata */
+#define DNET_ATTR_DELETE_HISTORY		(1<<0)
+
+/* What type of counters to fetch */
+#define DNET_ATTR_CNTR_GLOBAL			(1<<0)
+
+/* Bulk request for checking files */
+#define DNET_ATTR_BULK_CHECK			(1<<0)
+
+/* Fill ctime/mtime from metadata when processing DNET_CMD_LOOKUP */
+#define DNET_ATTR_META_TIMES			(1<<1)
+
+/* Do not verify checksum */
+#define DNET_ATTR_NOCSUM			(1<<2)
+
+/*
+ * ascending sort data before returning range request to user
+ * c++ bindings only
+ */
+#define DNET_ATTR_SORT				(1<<3)
+
+/*
+ * This flag will force its parent CMD not to lock operation
+ * Flag will be propagated to cmd->flags
+ */
+#define DNET_ATTR_NOLOCK			(1<<4)
+
+struct dnet_attr
+{
+	uint64_t		size;
+	uint32_t		cmd;
+	uint32_t		flags;
+	uint32_t		unused[2];
+} __attribute__ ((packed));
+
+static inline void dnet_convert_attr(struct dnet_attr *a)
+{
+	a->size = dnet_bswap64(a->size);
+	a->cmd = dnet_bswap32(a->cmd);
+	a->flags = dnet_bswap32(a->flags);
+}
+
+#define DNET_ADDR_SIZE		28
+
+struct dnet_addr
+{
+	uint8_t			addr[DNET_ADDR_SIZE];
+	uint32_t		addr_len;
+} __attribute__ ((packed));
+
+struct dnet_list
+{
+	struct dnet_id		id;
+	uint32_t		size;
+	uint8_t			data[0];
+} __attribute__ ((packed));
+
+static inline void dnet_convert_list(struct dnet_list *l)
+{
+	dnet_convert_id(&l->id);
+	l->size = dnet_bswap32(l->size);
+}
+
+struct dnet_addr_attr
+{
+	uint16_t		sock_type;
+	uint16_t		family;
+	uint32_t		proto;
+	struct dnet_addr	addr;
+} __attribute__ ((packed));
+
+static inline void dnet_convert_addr_attr(struct dnet_addr_attr *a)
+{
+	a->addr.addr_len = dnet_bswap32(a->addr.addr_len);
+	a->proto = dnet_bswap32(a->proto);
+	a->sock_type = dnet_bswap16(a->sock_type);
+	a->family = dnet_bswap16(a->family);
+}
+
+struct dnet_addr_cmd
+{
+	struct dnet_cmd		cmd;
+	struct dnet_attr	a;
+	struct dnet_addr_attr	addr;
+} __attribute__ ((packed));
+
+static inline void dnet_convert_addr_cmd(struct dnet_addr_cmd *l)
+{
+	dnet_convert_cmd(&l->cmd);
+	dnet_convert_attr(&l->a);
+	dnet_convert_addr_attr(&l->addr);
+}
+
+/* Do not update history for given transaction */
+#define DNET_IO_FLAGS_SKIP_SENDING	(1<<0)
+
+/* Append given data at the end of the object */
+#define DNET_IO_FLAGS_APPEND		(1<<1)
+
+#define DNET_IO_FLAGS_COMPRESS		(1<<2)
+
+/* Metada IO request */
+#define DNET_IO_FLAGS_META		(1<<3)
+
+/* eblob prepare/commit phase */
+#define DNET_IO_FLAGS_PREPARE		(1<<4)
+#define DNET_IO_FLAGS_COMMIT		(1<<5)
+
+/* Object was removed */
+#define DNET_IO_FLAGS_REMOVED		(1<<6)
+
+/* Overwrite data */
+#define DNET_IO_FLAGS_OVERWRITE		(1<<7)
+
+/* Do not checksum data */
+#define DNET_IO_FLAGS_NOCSUM		(1<<8)
+
+/*
+ * this flag is used when we want backend not to perform any additional actions
+ * except than write data at given offset. This is no-op in filesystem backend,
+ * but eblob one should disable prepare/commit operations.
+ */
+#define DNET_IO_FLAGS_PLAIN_WRITE	(1<<9)
+
+/* Do not really send data in range request.
+ * Send only statistics instead.
+ *
+ * -- we do not care if it matches above DNET_IO_FLAGS_PLAIN_WRITE,
+ *  since using plain write and nodata (read) is useless anyway
+ */
+#define DNET_IO_FLAGS_NODATA		(1<<9)
+
+struct dnet_io_attr
+{
+	uint8_t			parent[DNET_ID_SIZE];
+	uint8_t			id[DNET_ID_SIZE];
+
+	/*
+	 * used in range request as start and number for LIMIT(start, num) 
+	 *
+	 * write prepare request uses @num is used as a placeholder
+	 * for number of bytes to reserve on disk
+	 */
+	uint64_t		start, num;
+	int			type;
+	uint32_t		flags;
+	uint64_t		offset;
+	uint64_t		size;
+} __attribute__ ((packed));
+
+static inline void dnet_convert_io_attr(struct dnet_io_attr *a)
+{
+	a->start = dnet_bswap64(a->start);
+	a->num = dnet_bswap64(a->num);
+
+	a->flags = dnet_bswap32(a->flags);
+	a->offset = dnet_bswap64(a->offset);
+	a->size = dnet_bswap64(a->size);
+}
+
+struct dnet_history_entry
+{
+	uint8_t			id[DNET_ID_SIZE];
+	uint32_t		flags;
+	uint64_t		reserved;
+	uint64_t		tsec, tnsec;
+	uint64_t		offset;
+	uint64_t		size;
+} __attribute__ ((packed));
+
+/*
+ * Helper structure and set of functions to map history file and perform basic checks.
+ */
+struct dnet_history_map
+{
+	struct dnet_history_entry	*ent;
+	long				num;
+	ssize_t				size;
+	int				fd;
+};
+
+static inline void dnet_convert_history_entry(struct dnet_history_entry *a)
+{
+	a->flags = dnet_bswap32(a->flags);
+	a->offset = dnet_bswap64(a->offset);
+	a->size = dnet_bswap64(a->size);
+	a->tsec = dnet_bswap64(a->tsec);
+	a->tnsec = dnet_bswap64(a->tnsec);
+}
+
+static inline void dnet_setup_history_entry(struct dnet_history_entry *e,
+		unsigned char *id, uint64_t size, uint64_t offset,
+		struct timespec *ts, uint32_t flags)
+{
+	if (!ts) {
+		struct timeval tv;
+
+		gettimeofday(&tv, NULL);
+
+		e->tsec = tv.tv_sec;
+		e->tnsec = tv.tv_usec * 1000;
+	} else {
+		e->tsec = ts->tv_sec;
+		e->tnsec = ts->tv_nsec;
+	}
+
+	memcpy(e->id, id, DNET_ID_SIZE);
+
+	e->size = size;
+	e->offset = offset;
+	e->flags = flags;
+	e->reserved = 0;
+
+	dnet_convert_history_entry(e);
+}
+
+struct dnet_stat
+{
+	/* Load average from the target system multiplied by 100 */
+	uint16_t		la[3];
+
+	uint16_t		namemax;	/* maximum filename length */
+
+	uint64_t		bsize;		/* Block size */
+	uint64_t		frsize;		/* Fragment size */
+	uint64_t		blocks;		/* Filesystem size in frsize units */
+	uint64_t		bfree;		/* # free blocks */
+	uint64_t		bavail;		/* # free blocks for non-root */
+	uint64_t		files;		/* # inodes */
+	uint64_t		ffree;		/* # free inodes */
+	uint64_t		favail;		/* # free inodes for non-root */
+	uint64_t		fsid;		/* file system ID */
+	uint64_t		flag;		/* mount flags */
+
+	/*
+	 * VM counters in KB (1024) units.
+	 * On FreeBSD vm_buffers is used for wire counter.
+	 */
+	uint64_t		vm_active;
+	uint64_t		vm_inactive;
+	uint64_t		vm_total;
+	uint64_t		vm_free;
+	uint64_t		vm_cached;
+	uint64_t		vm_buffers;
+
+	/*
+	 * Per node IO statistics will live here.
+	 * Reserved for future use.
+	 */
+	uint64_t		reserved[32];
+};
+
+static inline void dnet_convert_stat(struct dnet_stat *st)
+{
+	int i;
+
+	for (i=0; i<3; ++i)
+		st->la[i] = dnet_bswap16(st->la[i]);
+
+	st->bsize = dnet_bswap64(st->bsize);
+	st->frsize = dnet_bswap64(st->frsize);
+	st->blocks = dnet_bswap64(st->blocks);
+	st->bfree = dnet_bswap64(st->bfree);
+	st->bavail = dnet_bswap64(st->bavail);
+	st->files = dnet_bswap64(st->files);
+	st->ffree = dnet_bswap64(st->ffree);
+	st->favail = dnet_bswap64(st->favail);
+	st->fsid = dnet_bswap64(st->fsid);
+	st->namemax = dnet_bswap16(st->namemax);
+
+	st->vm_active = dnet_bswap64(st->vm_active);
+	st->vm_inactive = dnet_bswap64(st->vm_inactive);
+	st->vm_total = dnet_bswap64(st->vm_total);
+	st->vm_free = dnet_bswap64(st->vm_free);
+	st->vm_buffers = dnet_bswap64(st->vm_buffers);
+	st->vm_cached = dnet_bswap64(st->vm_cached);
+}
+
+struct dnet_io_notification
+{
+	struct dnet_addr_attr		addr;
+	struct dnet_io_attr		io;
+};
+
+static inline void dnet_convert_io_notification(struct dnet_io_notification *n)
+{
+	dnet_convert_addr_attr(&n->addr);
+	dnet_convert_io_attr(&n->io);
+}
+
+struct dnet_stat_count
+{
+	uint64_t			count;
+	uint64_t			err;
+};
+
+static inline void dnet_convert_stat_count(struct dnet_stat_count *st, int num)
+{
+	int i;
+
+	for (i=0; i<num; ++i) {
+		st[i].count = dnet_bswap64(st[i].count);
+		st[i].err = dnet_bswap64(st[i].err);
+	}
+}
+
+struct dnet_addr_stat
+{
+	struct dnet_addr		addr;
+	int				num;
+	int				cmd_num;
+	struct dnet_stat_count		count[0];
+} __attribute__ ((packed));
+
+static inline void dnet_convert_addr_stat(struct dnet_addr_stat *st, int num)
+{
+	st->addr.addr_len = dnet_bswap32(st->addr.addr_len);
+	st->num = dnet_bswap32(st->num);
+	if (!num)
+		num = st->num;
+	st->cmd_num = dnet_bswap32(st->cmd_num);
+
+	dnet_convert_stat_count(st->count, num);
+}
+
+static inline void dnet_stat_inc(struct dnet_stat_count *st, int cmd, int err)
+{
+	if (cmd >= __DNET_CMD_MAX)
+		cmd = DNET_CMD_UNKNOWN;
+
+	if (!err)
+		st[cmd].count++;
+	else
+		st[cmd].err++;
+}
+
+struct dnet_time {
+	uint64_t		tsec, tnsec;
+};
+
+static inline void dnet_convert_time(struct dnet_time *tm)
+{
+	tm->tsec = dnet_bswap64(tm->tsec);
+	tm->tnsec = dnet_bswap64(tm->tnsec);
+}
+
+static inline void dnet_current_time(struct dnet_time *t)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+
+	t->tsec = tv.tv_sec;
+	t->tnsec = tv.tv_usec * 1000;
+}
+
+struct dnet_file_info {
+	int			flen;		/* filename length, which goes after this structure */
+	unsigned char		checksum[DNET_CSUM_SIZE];
+
+	unsigned int		nlink;
+
+	uint64_t		mode;
+
+	uint64_t		dev;
+	uint64_t		rdev;
+
+	uint64_t		ino;
+
+	uint64_t		uid;
+	uint64_t		gid;
+
+	uint64_t		blksize;
+	uint64_t		blocks;
+
+	uint64_t		size;
+	uint64_t		offset;		/* offset within eblob */
+
+	struct dnet_time	atime;
+	struct dnet_time	ctime;
+	struct dnet_time	mtime;
+};
+
+static inline void dnet_convert_file_info(struct dnet_file_info *info)
+{
+	info->flen = dnet_bswap32(info->flen);
+	info->nlink = dnet_bswap32(info->nlink);
+
+	info->mode = dnet_bswap64(info->mode);
+	info->dev = dnet_bswap64(info->dev);
+	info->ino = dnet_bswap64(info->ino);
+	info->uid = dnet_bswap64(info->uid);
+	info->gid = dnet_bswap64(info->gid);
+	info->blksize = dnet_bswap64(info->blksize);
+	info->blocks = dnet_bswap64(info->blocks);
+	info->rdev = dnet_bswap64(info->rdev);
+	info->size = dnet_bswap64(info->size);
+	info->offset = dnet_bswap64(info->offset);
+
+	dnet_convert_time(&info->atime);
+	dnet_convert_time(&info->ctime);
+	dnet_convert_time(&info->mtime);
+}
+
+static inline void dnet_info_from_stat(struct dnet_file_info *info, struct stat *st)
+{
+	info->nlink = st->st_nlink;
+	info->mode = st->st_mode;
+	info->dev = st->st_dev;
+	info->ino = st->st_ino;
+	info->uid = st->st_uid;
+	info->gid = st->st_gid;
+	info->blksize = st->st_blksize;
+	info->blocks = st->st_blocks;
+	info->rdev = st->st_rdev;
+	info->size = st->st_size;
+	info->offset = 0;
+
+	info->atime.tsec = st->st_atime;
+	info->ctime.tsec = st->st_ctime;
+	info->mtime.tsec = st->st_mtime;
+
+	info->atime.tnsec = 0;
+	info->ctime.tnsec = 0;
+	info->mtime.tnsec = 0;
+}
+
+/* Elliptics node status - if set, status will be changed */
+#define DNET_ATTR_STATUS_CHANGE		(1<<0)
+
+/* Elliptics node should exit */
+#define DNET_STATUS_EXIT		(1<<0)
+
+/* Ellipitcs node goes ro/rw */
+#define DNET_STATUS_RO			(1<<1)
+
+struct dnet_node_status {
+	int nflags;
+	int status_flags;  /* DNET_STATUS_EXIT, DNET_STATUS_RO should be specified here */
+	uint32_t log_mask;
+};
+
+static inline void dnet_convert_node_status(struct dnet_node_status *st)
+{
+	st->nflags = dnet_bswap32(st->nflags);
+	st->status_flags = dnet_bswap32(st->status_flags);
+	st->log_mask = dnet_bswap32(st->log_mask);
+}
+
+enum cmd_type {
+	DNET_EXEC_SHELL = 0,
+	DNET_EXEC_PYTHON_SCRIPT_NAME,
+	DNET_EXEC_PYTHON,
+};
+
+struct dnet_exec {
+	int			type;
+	int			flags;
+	uint64_t		script_size, name_size, binary_size;
+	uint64_t		reserved[2];
+
+	/*
+	 * we pack script name first, then user's script content and then binary data,
+	 * which will be pushed into server's object
+	 */
+	char			data[0];
+} __attribute__((packed));
+
+static inline void dnet_convert_exec(struct dnet_exec *e)
+{
+	e->type = dnet_bswap32(e->type);
+	e->script_size = dnet_bswap64(e->script_size);
+	e->name_size = dnet_bswap64(e->name_size);
+	e->binary_size = dnet_bswap64(e->binary_size);
+	e->flags = dnet_bswap32(e->flags);
+}
+
+#define DNET_AUTH_COOKIE_SIZE	32
+
+struct dnet_auth {
+	char			cookie[DNET_AUTH_COOKIE_SIZE];
+	uint64_t		flags;
+	uint64_t		unused[3];
+};
+
+static inline void dnet_convert_auth(struct dnet_auth *a)
+{
+	a->flags = dnet_bswap64(a->flags);
+}
+
+enum dnet_meta_types {
+	DNET_META_PARENT_OBJECT = 1,	/* parent object name */
+	DNET_META_GROUPS,		/* this object has copies in given groups */
+	DNET_META_CHECK_STATUS,		/* last checking status: timestamp and so on */
+	DNET_META_NAMESPACE,		/* namespace where given object lives */
+	DNET_META_UPDATE,		/* last update information (timestamp, flags) */
+	DNET_META_CHECKSUM,		/* checksum (sha512) of the whole data object calculated on server */
+	__DNET_META_MAX,
+};
+
+struct dnet_meta
+{
+	uint32_t			type;
+	uint32_t			size;
+	uint64_t			common;
+	uint8_t				tmp[16];
+	uint8_t				data[0];
+} __attribute__ ((packed));
+
+static inline void dnet_convert_meta(struct dnet_meta *m)
+{
+	m->type = dnet_bswap32(m->type);
+	m->size = dnet_bswap32(m->size);
+	m->common = dnet_bswap64(m->common);
+}
+
+struct dnet_meta_update {
+	int			unused_gap;
+	int			group_id;
+	uint64_t		flags;
+	struct dnet_time	tm;
+	uint64_t		reserved[4];
+} __attribute__((packed));
+
+static inline void dnet_convert_meta_update(struct dnet_meta_update *m)
+{
+	dnet_convert_time(&m->tm);
+	m->flags = dnet_bswap64(m->flags);
+}
+
+struct dnet_meta_check_status {
+	int			status;
+	int			pad;
+	struct dnet_time	tm;
+	uint64_t		reserved[4];
+} __attribute__ ((packed));
+
+static inline void dnet_convert_meta_check_status(struct dnet_meta_check_status *c)
+{
+	c->status = dnet_bswap32(c->status);
+	dnet_convert_time(&c->tm);
+}
+
+struct dnet_meta_checksum {
+	uint8_t			checksum[DNET_CSUM_SIZE];
+	struct dnet_time	tm;
+} __attribute__ ((packed));
+
+static inline void dnet_convert_meta_checksum(struct dnet_meta_checksum *c)
+{
+	dnet_convert_time(&c->tm);
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* __DNET_PACKET_H */
diff --git a/fs/pohmelfs/pohmelfs.h b/fs/pohmelfs/pohmelfs.h
new file mode 100644
index 0000000..8b7cb72
--- /dev/null
+++ b/fs/pohmelfs/pohmelfs.h
@@ -0,0 +1,461 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#ifndef __POHMELFS_H
+#define __POHMELFS_H
+
+#include <linux/backing-dev.h>
+#include <linux/crypto.h>
+#include <linux/fs.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/net.h>
+#include <linux/pagemap.h>
+#include <linux/pagevec.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include <crypto/sha.h>
+
+#define dnet_bswap16(x)		cpu_to_le16(x)
+#define dnet_bswap32(x)		cpu_to_le32(x)
+#define dnet_bswap64(x)		cpu_to_le64(x)
+
+/* theese are needed for packet.h below to compile */
+#define DNET_ID_SIZE	SHA512_DIGEST_SIZE
+#define DNET_CSUM_SIZE	SHA512_DIGEST_SIZE
+
+/*
+ * is not used in kernel, but we want to share the same header
+ * with userspace, so I put it here for compiler to shut up
+ */
+int gettimeofday(struct timeval *, struct timezone *);
+
+#include "packet.h"
+
+static inline struct timespec pohmelfs_date(struct dnet_time *tm)
+{
+	struct timespec ts;
+
+	ts.tv_sec = tm->tsec;
+	ts.tv_nsec = tm->tnsec;
+
+	return ts;
+}
+
+struct pohmelfs_cmd {
+	struct dnet_cmd		cmd;
+	struct dnet_attr	attr;
+	union {
+		struct dnet_io_attr	io;
+	} p;
+};
+
+/*
+ * Compare two IDs.
+ * Returns  1 when id1 > id2
+ *         -1 when id1 < id2
+ *          0 when id1 = id2
+ */
+static inline int dnet_id_cmp_str(const unsigned char *id1, const unsigned char *id2)
+{
+	unsigned int i = 0;
+
+	for (i*=sizeof(unsigned long); i<DNET_ID_SIZE; ++i) {
+		if (id1[i] < id2[i])
+			return -1;
+		if (id1[i] > id2[i])
+			return 1;
+	}
+
+	return 0;
+}
+
+struct pohmelfs_state;
+struct pohmelfs_sb;
+struct pohmelfs_trans;
+
+struct pohmelfs_trans_cb {
+	int				(* init)(struct pohmelfs_trans *t);
+	int				(* complete)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
+	int				(* recv_reply)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
+	void				(* destroy)(struct pohmelfs_trans *t);
+};
+
+struct pohmelfs_trans {
+	struct list_head	trans_entry;
+
+	struct kref		refcnt;
+
+	unsigned long		trans;
+
+	struct inode		*inode;
+
+	struct pohmelfs_state	*st;
+
+	struct pohmelfs_cmd	cmd;
+
+	u64			header_size, data_size;
+
+	void			*data;
+
+	unsigned long long	recv_offset;
+	void			*recv_data;
+
+	struct pohmelfs_write_ctl	*wctl;
+	void			*priv;
+
+	struct pohmelfs_trans_cb	cb;
+};
+
+struct pohmelfs_trans *pohmelfs_trans_alloc(struct inode *inode);
+struct pohmelfs_trans *pohmelfs_trans_alloc_io_buf(struct inode *inode, int group, int command,
+		void *data, u64 offset, u64 size, int aflags, int ioflags, int type);
+void pohmelfs_trans_put(struct pohmelfs_trans *t);
+
+int pohmelfs_trans_insert(struct pohmelfs_trans *t);
+struct pohmelfs_trans *pohmelfs_trans_lookup(struct pohmelfs_state *st, struct dnet_cmd *cmd);
+
+struct pohmelfs_state {
+	struct pohmelfs_sb	*psb;
+	struct list_head	state_entry;
+
+	struct sockaddr_storage	sa;
+	int			addrlen;
+	struct socket		*sock;
+
+	int			group_id;
+
+	struct mutex		trans_lock;
+	struct list_head	trans_list;
+	struct list_head	sent_trans_list;
+
+	struct kref		refcnt;
+
+	int			routes;
+
+	/* Waiting/polling machinery */
+	wait_queue_t		wait;
+	wait_queue_head_t	*whead;
+
+	struct work_struct	send_work;
+	struct work_struct	recv_work;
+
+	/* is set when dnet_cmd is being read, otherwise attached data */
+	int			cmd_read;
+	/* currently read command reply */
+	struct dnet_cmd		cmd;
+};
+
+struct pohmelfs_state *pohmelfs_state_create(struct pohmelfs_sb *psb, struct sockaddr_storage *sa, int addrlen,
+		int ask_route, int group_id);
+struct pohmelfs_state *pohmelfs_state_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id, int group);
+
+static inline void pohmelfs_state_get(struct pohmelfs_state *st)
+{
+	kref_get(&st->refcnt);
+}
+
+void pohmelfs_state_put(struct pohmelfs_state *st);
+void pohmelfs_state_kill(struct pohmelfs_state *st);
+
+struct pohmelfs_state *pohmelfs_addr_exist(struct pohmelfs_sb *psb, struct sockaddr_storage *sa, int addrlen);
+
+void pohmelfs_state_schedule(struct pohmelfs_state *st);
+
+__attribute__ ((format (printf, 2, 3))) void pohmelfs_print_addr(struct sockaddr_storage *addr, const char *fmt, ...);
+
+#define POHMELFS_INODE_INFO_REMOVED		(1<<0)
+
+struct pohmelfs_inode_info {
+	struct dnet_raw_id	id;
+
+	unsigned int		mode;
+	unsigned int		nlink;
+	unsigned int		uid;
+	unsigned int		gid;
+	unsigned int		blocksize;
+	unsigned int		namelen;
+	__u64			ino;
+	__u64			blocks;
+	__u64			rdev;
+	__u64			size;
+	__u64			version;
+
+	__u64			flags;
+
+	struct dnet_time	ctime;
+	struct dnet_time	mtime;
+	struct dnet_time	atime;
+} __attribute__ ((packed));
+
+void pohmelfs_fill_inode_info(struct inode *inode, struct pohmelfs_inode_info *info);
+void pohmelfs_fill_inode(struct inode *inode, struct pohmelfs_inode_info *info);
+void pohmelfs_convert_inode_info(struct pohmelfs_inode_info *info);
+
+struct pohmelfs_inode {
+	struct inode		vfs_inode;
+	struct dnet_raw_id	id;
+	struct dnet_raw_id	parent_id;
+
+	struct rb_node		node;
+
+	struct mutex		lock;
+
+	int			*groups;
+	int			group_num;
+
+	time_t			update;
+};
+
+int pohmelfs_send_dentry(struct pohmelfs_inode *pi, struct dnet_raw_id *id, const char *sname, int len, int sync);
+struct pohmelfs_inode *pohmelfs_sb_inode_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id);
+
+
+struct pohmelfs_reconnect {
+	struct list_head	reconnect_entry;
+	struct sockaddr_storage	sa;
+	int			addrlen;
+	int			group_id;
+};
+
+int pohmelfs_state_add_reconnect(struct pohmelfs_state *st);
+
+struct pohmelfs_path {
+	struct mutex		lock;
+	char			*data;
+};
+
+int pohmelfs_http_compat_id(struct pohmelfs_inode *pi);
+
+struct pohmelfs_sb {
+	struct super_block	*sb;
+	struct backing_dev_info	bdi;
+
+	struct pohmelfs_inode	*root;
+
+	spinlock_t		inode_lock;
+	struct rb_root		inode_root;
+
+	int			http_compat;
+	struct pohmelfs_path	*path;
+
+	int			bdi_num;
+
+	struct rb_root		route_root;
+	struct list_head	state_list;
+	spinlock_t		state_lock;
+
+	long			read_wait_timeout;
+	long			write_wait_timeout;
+
+	long			sync_timeout;
+	struct delayed_work	sync_work;
+
+	char			*fsid;
+	int			fsid_len;
+
+	int			no_read_csum;
+
+	atomic_long_t		ino;
+	atomic_long_t		trans;
+
+	struct crypto_hash	*hash;
+
+	struct workqueue_struct	*wq;
+
+	int			*groups;
+	int			group_num;
+
+	/*
+	 * number of copies to be successfully written to mark write as successful
+	 * if not set, half of groups plus one must be successfully written, i.e. plain write quorum
+	 */
+	int			successful_write_count;
+
+	struct mutex		reconnect_lock;
+	struct list_head	reconnect_list;
+	struct list_head	kill_state_list;
+	struct delayed_work	reconnect_work;
+	long			reconnect_timeout;
+
+	int			keepalive_cnt, keepalive_interval, keepalive_idle;
+
+	int			readdir_allocation;
+
+	int			sync_on_close;
+};
+
+static inline struct pohmelfs_sb *pohmelfs_sb(struct super_block *sb)
+{
+	return (struct pohmelfs_sb *)sb->s_fs_info;
+}
+
+static inline struct pohmelfs_inode *pohmelfs_inode(struct inode *inode)
+{
+	return container_of(inode, struct pohmelfs_inode, vfs_inode);
+}
+
+struct pohmelfs_wait {
+	wait_queue_head_t	wq;
+	struct pohmelfs_inode	*pi;
+	void			*ret;
+	atomic_long_t		count;
+	int			condition;
+	struct kref		refcnt;
+};
+
+int pohmelfs_wait_init(struct pohmelfs_wait *wait, struct pohmelfs_inode *pi);
+struct pohmelfs_wait *pohmelfs_wait_alloc(struct pohmelfs_inode *pi);
+void pohmelfs_wait_put(struct pohmelfs_wait *wait);
+static inline void pohmelfs_wait_get(struct pohmelfs_wait *wait)
+{
+	kref_get(&wait->refcnt);
+}
+
+struct pohmelfs_inode_info_binary_package {
+	struct pohmelfs_inode_info	info;
+
+	struct pohmelfs_wait		wait;
+};
+
+struct pohmelfs_write_ctl {
+	struct pagevec			pvec;
+	struct pohmelfs_inode_info	*info;
+
+	struct kref			refcnt;
+	atomic_t			good_writes;
+};
+
+struct pohmelfs_dentry_disk {
+	struct dnet_raw_id		id;
+	uint64_t			ino;
+	int				pad0;
+	short				pad1;
+	char				type;
+	char				len;
+	char				name[0];
+};
+
+struct pohmelfs_dentry {
+	struct dnet_raw_id		parent_id;
+	struct pohmelfs_dentry_disk	disk;
+};
+
+extern struct kmem_cache *pohmelfs_inode_cache;
+extern struct kmem_cache *pohmelfs_trans_cache;
+extern struct kmem_cache *pohmelfs_inode_info_cache;
+extern struct kmem_cache *pohmelfs_route_cache;
+extern struct kmem_cache *pohmelfs_wait_cache;
+extern struct kmem_cache *pohmelfs_io_cache;
+extern struct kmem_cache *pohmelfs_inode_info_binary_package_cache;
+extern struct kmem_cache *pohmelfs_write_cache;
+extern struct kmem_cache *pohmelfs_dentry_cache;
+
+struct inode *pohmelfs_alloc_inode(struct super_block *sb);
+void pohmelfs_destroy_inode(struct inode *);
+
+struct pohmelfs_inode *pohmelfs_existing_inode(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info);
+struct pohmelfs_inode *pohmelfs_new_inode(struct pohmelfs_sb *psb, int mode);
+int pohmelfs_hash(struct pohmelfs_sb *psb, const void *data, const size_t size, struct dnet_raw_id *id);
+
+char *pohmelfs_dump_id(const unsigned char *id);
+char *pohmelfs_dump_id_len_raw(const unsigned char *id, unsigned int len, char *dst);
+
+int pohmelfs_write_command(struct pohmelfs_inode *pi, struct pohmelfs_write_ctl *ctl, loff_t offset, size_t len);
+void pohmelfs_write_ctl_release(struct kref *kref);
+int pohmelfs_metadata_inode(struct pohmelfs_inode *pi, int sync);
+
+extern const struct file_operations pohmelfs_dir_fops;
+extern const struct inode_operations pohmelfs_dir_inode_operations;
+
+extern const struct file_operations pohmelfs_file_ops;
+extern const struct inode_operations pohmelfs_file_inode_operations;
+
+extern const struct inode_operations pohmelfs_symlink_inode_operations;
+extern const struct inode_operations pohmelfs_special_inode_operations;
+
+extern void *pohmelfs_scratch_buf;
+extern int pohmelfs_scratch_buf_size;
+
+/*
+ * if this flag is set, pohmelfs_inode_info->data is owned by the caller,
+ * so sending path may use it on its own and free (using kfree) when it's done
+ *
+ * This logic does not work for shared buffers or
+ * when multiple transactions will be sent for single pohmelfs_inode_info
+ */
+#define POHMELFS_IO_OWN			(1<<0)
+
+struct pohmelfs_io {
+	struct pohmelfs_inode		*pi;
+
+	struct dnet_raw_id		*id;
+
+	int				cmd;
+	int				type;
+
+	u64				offset, size;
+	u64				start, num;
+
+	u32				cflags;
+	u32				aflags;
+	u32				ioflags;
+
+	int				group_id;
+
+	u32				alloc_flags;
+	void				*data;
+
+	struct pohmelfs_write_ctl	*wctl;
+	void				*priv;
+
+	struct pohmelfs_trans_cb	cb;
+};
+
+int pohmelfs_send_io_group(struct pohmelfs_io *pio, int group_id);
+int pohmelfs_send_io(struct pohmelfs_io *pio);
+int pohmelfs_send_buf_single(struct pohmelfs_io *pio, struct pohmelfs_state *st);
+int pohmelfs_send_buf(struct pohmelfs_io *pio);
+
+int pohmelfs_data_recv(struct pohmelfs_state *st, void *buf, u64 size, unsigned int flags);
+int pohmelfs_recv(struct pohmelfs_trans *t, struct pohmelfs_state *recv, void *data, int size);
+
+struct pohmelfs_route {
+	struct rb_node			node;
+	int				group_id;
+	struct dnet_raw_id		id;
+	struct pohmelfs_state		*st;
+};
+
+int pohmelfs_route_request(struct pohmelfs_state *st);
+void pohmelfs_route_remove_all(struct pohmelfs_state *st);
+
+struct pohmelfs_script_req {
+	char			*obj_name;
+	int			obj_len;
+
+	char			*script_name;
+	int			script_namelen;
+
+	void			*binary;
+	int			binary_size;
+
+	int			group_id;
+
+	int			sync;
+
+	struct dnet_raw_id	*id;
+
+	int			(* complete)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
+	void			*ret;
+	int			ret_cond;
+};
+
+int pohmelfs_send_script_request(struct pohmelfs_inode *parent, struct pohmelfs_script_req *req);
+
+#endif /* __POHMELFS_H */
diff --git a/fs/pohmelfs/route.c b/fs/pohmelfs/route.c
new file mode 100644
index 0000000..6a0400d
--- /dev/null
+++ b/fs/pohmelfs/route.c
@@ -0,0 +1,279 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#include "pohmelfs.h"
+
+
+static inline int pohmelfs_route_cmp_raw(const struct pohmelfs_route *rt, const struct dnet_raw_id *raw, int group_id)
+{
+	if (rt->group_id < group_id)
+		return -1;
+	if (rt->group_id > group_id)
+		return 1;
+
+	return dnet_id_cmp_str(rt->id.id, raw->id);
+}
+
+static inline int pohmelfs_route_cmp(const struct pohmelfs_route *id1, const struct pohmelfs_route *id2)
+{
+	return pohmelfs_route_cmp_raw(id1, &id2->id, id2->group_id);
+}
+
+static int pohmelfs_route_insert(struct pohmelfs_sb *psb, struct pohmelfs_route *rt)
+{
+	struct rb_node **n = &psb->route_root.rb_node, *parent = NULL;
+	struct pohmelfs_route *tmp;
+	int cmp, err = 0;
+
+	spin_lock(&psb->state_lock);
+	while (*n) {
+		parent = *n;
+
+		tmp = rb_entry(parent, struct pohmelfs_route, node);
+
+		cmp = pohmelfs_route_cmp(tmp, rt);
+		if (cmp < 0)
+			n = &parent->rb_left;
+		else if (cmp > 0)
+			n = &parent->rb_right;
+		else {
+			err = -EEXIST;
+			goto err_out_unlock;
+		}
+	}
+
+	rb_link_node(&rt->node, parent, n);
+	rb_insert_color(&rt->node, &psb->route_root);
+
+err_out_unlock:
+	spin_unlock(&psb->state_lock);
+	return err;
+	
+}
+
+static int pohmelfs_route_add(struct pohmelfs_state *st, struct dnet_raw_id *id, int group_id)
+{
+	struct pohmelfs_sb *psb = st->psb;
+	struct pohmelfs_route *rt;
+	int err;
+
+	rt = kmem_cache_zalloc(pohmelfs_route_cache, GFP_NOIO);
+	if (!rt) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	memcpy(&rt->id, id, sizeof(struct dnet_raw_id));
+	rt->group_id = group_id;
+	rt->st = st;
+
+	pohmelfs_state_get(st);
+
+	err = pohmelfs_route_insert(psb, rt);
+	if (err)
+		goto err_out_put;
+
+	rt->st->routes++;
+	return 0;
+
+err_out_put:
+	pohmelfs_state_put(st);
+	kmem_cache_free(pohmelfs_route_cache, rt);
+err_out_exit:
+	return err;
+}
+
+struct pohmelfs_state *pohmelfs_state_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id, int group_id)
+{
+	struct rb_node *n = psb->route_root.rb_node;
+	struct pohmelfs_route *rt;
+	struct pohmelfs_state *st = NULL;
+	int cmp;
+
+	spin_lock(&psb->state_lock);
+	while (n) {
+		rt = rb_entry(n, struct pohmelfs_route, node);
+
+		cmp = pohmelfs_route_cmp_raw(rt, id, group_id);
+
+		if (!st && (rt->group_id == group_id)) {
+			st = rt->st;
+		}
+
+		if (cmp < 0) {
+			n = n->rb_left;
+
+			if (rt->group_id == group_id) {
+				st = rt->st;
+			}
+		} else if (cmp > 0)
+			n = n->rb_right;
+		else {
+			st = rt->st;
+			break;
+		}
+	}
+	if (st)
+		pohmelfs_state_get(st);
+
+	spin_unlock(&psb->state_lock);
+
+	return st;
+}
+
+static void pohmelfs_route_remove_nolock(struct pohmelfs_sb *psb, struct pohmelfs_route *rt)
+{
+	rt->st->routes--;
+	rb_erase(&rt->node, &psb->route_root);
+	pohmelfs_state_put(rt->st);
+	kmem_cache_free(pohmelfs_route_cache, rt);
+}
+
+void pohmelfs_route_remove_all(struct pohmelfs_state *st)
+{
+	struct pohmelfs_sb *psb = st->psb;
+	struct pohmelfs_route *rt;
+	struct rb_node *n;
+	int found = 1;
+
+	spin_lock(&psb->state_lock);
+
+	while (found) {
+		n = rb_first(&psb->route_root);
+		found = 0;
+
+		while (n) {
+			rt = rb_entry(n, struct pohmelfs_route, node);
+
+			if (rt->st == st) {
+				pohmelfs_route_remove_nolock(psb, rt);
+				found = 1;
+				break;
+			}
+
+			n = rb_next(&rt->node);
+		}
+	}
+
+	spin_unlock(&psb->state_lock);
+}
+
+static int pohmelfs_route_request_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(t->inode->i_sb);
+	struct dnet_cmd *cmd = &recv->cmd;
+	struct pohmelfs_state *st;
+	struct dnet_attr *attr;
+	struct dnet_addr_attr *a;
+	struct dnet_raw_id *ids;
+	int err = 0;
+
+	if (!t->recv_offset)
+		goto err_out_exit;
+
+	attr = t->recv_data;
+	dnet_convert_attr(attr);
+
+	if (attr->size > sizeof(struct dnet_addr_attr)) {
+		int i, num = (attr->size - sizeof(struct dnet_addr_attr)) / sizeof(struct dnet_raw_id);
+
+		a = (struct dnet_addr_attr *)(attr + 1);
+		dnet_convert_addr_attr(a);
+		ids = (struct dnet_raw_id *)(a + 1);
+
+		st = pohmelfs_state_create(psb, (struct sockaddr_storage *)&a->addr.addr, a->addr.addr_len, 0, cmd->id.group_id);
+		if (IS_ERR(st)) {
+			err = PTR_ERR(st);
+
+			if (err == -EEXIST) {
+				spin_lock(&psb->state_lock);
+				st = pohmelfs_addr_exist(psb, (struct sockaddr_storage *)&a->addr.addr, a->addr.addr_len);
+				if (st) {
+					st->group_id = cmd->id.group_id;
+					pohmelfs_state_get(st);
+					err = 0;
+				}
+				spin_unlock(&psb->state_lock);
+			}
+
+			if (err)
+				goto err_out_exit;
+		} else {
+			/*
+			 * reference grab logic should be the same
+			 * as in case when state exist - we will drop
+			 * it at the end, so we would not check whether
+			 * it is new state (and refcnt == 1) or
+			 * existing (refcnt > 1)
+			 */
+			pohmelfs_state_get(st);
+		}
+
+		for (i = 0; i < num; ++i) {
+			dnet_convert_raw_id(&ids[i]);
+#if 0
+			pohmelfs_print_addr((struct sockaddr_storage *)&a->addr.addr, "%d:%s\n",
+					cmd->id.group_id, pohmelfs_dump_id(ids[i].id));
+#endif
+
+			err = pohmelfs_route_add(st, &ids[i], cmd->id.group_id);
+			if (err) {
+				if (err != -EEXIST) {
+					/* remove this state from route table */
+					spin_lock(&psb->state_lock);
+					list_del_init(&st->state_entry);
+					spin_unlock(&psb->state_lock);
+
+					/* drop abovementioned refcnt */
+					pohmelfs_state_put(st);
+
+					pohmelfs_state_kill(st);
+					goto err_out_exit;
+				}
+
+				err = 0;
+			}
+		}
+
+		/* drop abovementioned refcnt */
+		pohmelfs_state_put(st);
+	}
+
+err_out_exit:
+	return err;
+}
+
+int pohmelfs_route_request(struct pohmelfs_state *st)
+{
+	struct pohmelfs_sb *psb = st->psb;
+	struct pohmelfs_io *pio;
+	int err;
+
+	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
+	if (!pio) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	pio->pi = psb->root;
+	pio->id = &psb->root->id;
+	pio->cmd = DNET_CMD_ROUTE_LIST;
+	pio->cflags = DNET_FLAGS_DIRECT | DNET_FLAGS_NEED_ACK;
+	pio->cb.complete = pohmelfs_route_request_complete;
+
+	err = pohmelfs_send_buf_single(pio, st);
+	if (err) {
+		pohmelfs_print_addr(&st->sa, "pohmelfs: pohmelfs_route_request: %d\n", err);
+		goto err_out_free;
+	}
+	pohmelfs_print_addr(&st->sa, "route request sent\n");
+
+err_out_free:
+	kmem_cache_free(pohmelfs_io_cache, pio);
+err_out_exit:
+	return err;
+}
diff --git a/fs/pohmelfs/super.c b/fs/pohmelfs/super.c
new file mode 100644
index 0000000..a02a89a
--- /dev/null
+++ b/fs/pohmelfs/super.c
@@ -0,0 +1,905 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/blkdev.h>
+#include <linux/parser.h>
+#include <linux/random.h>
+#include <linux/buffer_head.h>
+#include <linux/exportfs.h>
+#include <linux/vfs.h>
+#include <linux/seq_file.h>
+#include <linux/mount.h>
+#include <linux/quotaops.h>
+#include <asm/uaccess.h>
+
+#include "pohmelfs.h"
+
+#define POHMELFS_MAGIC_NUM	0x504f482e
+
+struct kmem_cache *pohmelfs_inode_cache;
+struct kmem_cache *pohmelfs_trans_cache;
+struct kmem_cache *pohmelfs_inode_info_cache;
+struct kmem_cache *pohmelfs_route_cache;
+struct kmem_cache *pohmelfs_wait_cache;
+struct kmem_cache *pohmelfs_io_cache;
+struct kmem_cache *pohmelfs_inode_info_binary_package_cache;
+struct kmem_cache *pohmelfs_write_cache;
+struct kmem_cache *pohmelfs_dentry_cache;
+
+static atomic_t psb_bdi_num = ATOMIC_INIT(0);
+
+static void pohmelfs_http_compat_cleanup(struct pohmelfs_sb *psb)
+{
+	struct pohmelfs_path *p;
+	int i;
+
+	for (i = 0; i < psb->http_compat; ++i) {
+		p = &psb->path[i];
+
+		mutex_destroy(&p->lock);
+		kfree(p->data);
+	}
+}
+
+static int pohmelfs_http_compat_init(struct pohmelfs_sb *psb)
+{
+	int i, err;
+	struct pohmelfs_path *path, *p;
+
+	path = kmalloc(psb->http_compat * sizeof(struct pohmelfs_path), GFP_KERNEL);
+	if (!path) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	for (i = 0; i < psb->http_compat; ++i) {
+		p = &path[i];
+
+		mutex_init(&p->lock);
+
+		p->data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!p->data) {
+			err = -ENOMEM;
+			goto err_out_free;
+		}
+	}
+
+	psb->path = path;
+	return 0;
+
+err_out_free:
+	while (--i >= 0) {
+		p = &path[i];
+
+		mutex_destroy(&p->lock);
+		kfree(p->data);
+	}
+
+	kfree(path);
+err_out_exit:
+	psb->http_compat = 0;
+	return err;
+}
+
+static void pohmelfs_cleanup_psb(struct pohmelfs_sb *psb)
+{
+	struct pohmelfs_state *st, *tmp;
+	struct pohmelfs_reconnect *r, *rtmp;
+
+	cancel_delayed_work(&psb->reconnect_work);
+	cancel_delayed_work(&psb->sync_work);
+
+	list_for_each_entry_safe(st, tmp, &psb->state_list, state_entry) {
+		list_del_init(&st->state_entry);
+
+		pohmelfs_state_kill(st);
+	}
+
+	list_for_each_entry_safe(st, tmp, &psb->kill_state_list, state_entry) {
+		list_del_init(&st->state_entry);
+		pohmelfs_state_kill(st);
+	}
+
+	list_for_each_entry_safe(r, rtmp, &psb->reconnect_list, reconnect_entry) {
+		list_del(&r->reconnect_entry);
+		kfree(r);
+	}
+
+	destroy_workqueue(psb->wq);
+	crypto_free_hash(psb->hash);
+
+	pohmelfs_http_compat_cleanup(psb);
+
+	kfree(psb->groups);
+	kfree(psb->fsid);
+}
+
+static void pohmelfs_put_super(struct super_block *sb)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(sb);
+
+	pohmelfs_cleanup_psb(psb);
+	bdi_destroy(&psb->bdi);
+}
+
+static int pohmelfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+
+	/*
+	 * There are no filesystem size limits yet.
+	 */
+	memset(buf, 0, sizeof(struct kstatfs));
+
+	buf->f_type = POHMELFS_MAGIC_NUM; /* 'POH.' */
+	buf->f_bsize = sb->s_blocksize;
+	buf->f_files = 0;
+	buf->f_namelen = 4096;
+	buf->f_files = 0;
+	buf->f_bfree = buf->f_bavail = ~0ULL >> PAGE_SHIFT;
+	buf->f_blocks = ~0ULL >> PAGE_SHIFT;
+
+	return 0;
+}
+
+static int pohmelfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(vfs->mnt_sb);
+
+	if (psb->no_read_csum)
+		seq_printf(seq, ",noreadcsum");
+	seq_printf(seq, ",sync_timeout=%ld", psb->sync_timeout);
+	if (psb->fsid)
+		seq_printf(seq, ",fsid=%s", psb->fsid);
+	if (psb->successful_write_count)
+		seq_printf(seq, ",successful_write_count=%d", psb->successful_write_count);
+	seq_printf(seq, ",keepalive_cnt=%d", psb->keepalive_cnt);
+	seq_printf(seq, ",keepalive_interval=%d", psb->keepalive_interval);
+	seq_printf(seq, ",keepalive_idle=%d", psb->keepalive_idle);
+	seq_printf(seq, ",readdir_allocation=%d", psb->readdir_allocation);
+	if (psb->http_compat)
+		seq_printf(seq, ",http_compat=%d", psb->http_compat);
+	if (psb->sync_on_close)
+		seq_printf(seq, ",sync_on_close");
+	return 0;
+}
+
+/*
+ * This is tricky function - inode cache can be shrunk and inode is about to be dropped,
+ * since its last reference is dropped. But then icache can __iget() on this inode and
+ * later iput() it, which will again call ->drop_inode() callback.
+ *
+ * So, ->drop_inode() can be called multiple times for single inode without its reintialization
+ * And we better to be ready for this
+ */
+static int pohmelfs_drop_inode(struct inode *inode)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+
+	pr_debug("pohmelfs: %s: drop ino: %ld, mapping: %p\n", pohmelfs_dump_id(pi->id.id), inode->i_ino, inode->i_mapping);
+
+	spin_lock(&psb->inode_lock);
+	if (rb_parent(&pi->node) != &pi->node)
+		rb_erase(&pi->node, &psb->inode_root);
+	rb_init_node(&pi->node);
+	spin_unlock(&psb->inode_lock);
+
+	return generic_drop_inode(inode);
+}
+
+static int pohmelfs_write_inode_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct dnet_cmd *cmd = &recv->cmd;
+	struct pohmelfs_inode_info_binary_package *bin = t->priv;
+	struct pohmelfs_wait *wait = &bin->wait;
+
+	if (cmd->flags & DNET_FLAGS_MORE)
+		return 0;
+
+	wait->condition = cmd->status;
+	if (!wait->condition)
+		wait->condition = 1;
+	wake_up(&wait->wq);
+
+	return 0;
+}
+
+static int pohmelfs_write_inode_init(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_inode_info_binary_package *bin = t->priv;
+
+	kref_get(&bin->wait.refcnt);
+	return 0;
+}
+
+static void pohmelfs_write_inode_release(struct kref *kref)
+{
+	struct pohmelfs_wait *wait = container_of(kref, struct pohmelfs_wait, refcnt);
+	struct pohmelfs_inode_info_binary_package *bin = container_of(wait, struct pohmelfs_inode_info_binary_package, wait);
+
+	iput(&bin->wait.pi->vfs_inode);
+	kmem_cache_free(pohmelfs_inode_info_binary_package_cache, bin);
+}
+
+static void pohmelfs_write_inode_destroy(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_inode_info_binary_package *bin = t->priv;
+
+	/*
+	 * We own this pointer - it points to &bin->info
+	 * Zero it here to prevent pohmelfs_trans_release() from freeing it
+	 */
+	t->data = NULL;
+	
+	kref_put(&bin->wait.refcnt, pohmelfs_write_inode_release);
+}
+
+static int pohmelfs_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct pohmelfs_inode_info_binary_package *bin;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_io *pio;
+	int sync = 0;
+	long ret;
+	int err;
+
+	if (wbc)
+		sync = wbc->sync_mode == WB_SYNC_ALL;
+
+	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
+	if (!pio) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	bin = kmem_cache_zalloc(pohmelfs_inode_info_binary_package_cache, GFP_NOIO);
+	if (!bin) {
+		err = -ENOMEM;
+		goto err_out_free_pio;
+	}
+
+	pohmelfs_fill_inode_info(inode, &bin->info);
+	err = pohmelfs_wait_init(&bin->wait, pi);
+	if (err)
+		goto err_out_put_bin;
+
+	pio->pi = pi;
+	pio->id = &pi->id;
+	pio->cmd = DNET_CMD_WRITE;
+	pio->offset = 0;
+	pio->size = sizeof(struct pohmelfs_inode_info);
+	pio->cflags = DNET_FLAGS_NEED_ACK;
+	pio->priv = bin;
+	pio->type = 3;
+
+	pio->data = &bin->info;
+	pio->alloc_flags = POHMELFS_IO_OWN;
+
+	pio->cb.complete = pohmelfs_write_inode_complete;
+	pio->cb.init = pohmelfs_write_inode_init;
+	pio->cb.destroy = pohmelfs_write_inode_destroy;
+
+	err = pohmelfs_send_io(pio);
+	if (err)
+		goto err_out_put_bin;
+
+	if (sync) {
+		struct pohmelfs_wait *wait = &bin->wait;
+
+		ret = wait_event_interruptible_timeout(wait->wq,
+				wait->condition != 0 && atomic_read(&wait->refcnt.refcount) <= 2,
+				msecs_to_jiffies(psb->write_wait_timeout));
+		if (ret <= 0) {
+			err = ret;
+			if (ret == 0)
+				err = -ETIMEDOUT;
+			goto err_out_put_bin;
+		}
+
+		if (wait->condition < 0) {
+			err = wait->condition;
+			goto err_out_put_bin;
+		}
+	}
+
+err_out_put_bin:
+	kref_put(&bin->wait.refcnt, pohmelfs_write_inode_release);
+err_out_free_pio:
+	kmem_cache_free(pohmelfs_io_cache, pio);
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_parse_options(struct pohmelfs_sb *psb, char *data);
+
+static int pohmelfs_remount_fs(struct super_block *sb, int *flags, char *data)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(sb);
+
+	return pohmelfs_parse_options(psb, data);
+}
+
+static const struct super_operations pohmelfs_sb_ops = {
+	.alloc_inode	= pohmelfs_alloc_inode,
+	.destroy_inode	= pohmelfs_destroy_inode,
+	.drop_inode	= pohmelfs_drop_inode,
+	.write_inode	= pohmelfs_write_inode,
+	.put_super	= pohmelfs_put_super,
+	.show_options   = pohmelfs_show_options,
+	.statfs		= pohmelfs_statfs,
+	.remount_fs	= pohmelfs_remount_fs,
+};
+
+static void pohmelfs_sync(struct work_struct *work)
+{
+	struct pohmelfs_sb *psb = container_of(to_delayed_work(work), struct pohmelfs_sb, sync_work);
+	struct super_block *sb = psb->sb;
+
+	down_read(&sb->s_umount);
+	sync_filesystem(sb);
+	up_read(&sb->s_umount);
+
+	queue_delayed_work(psb->wq, &psb->sync_work, msecs_to_jiffies(psb->sync_timeout * 1000));
+}
+
+static void pohmelfs_reconnect(struct work_struct *work)
+{
+	struct pohmelfs_sb *psb = container_of(to_delayed_work(work), struct pohmelfs_sb, reconnect_work);
+	struct pohmelfs_reconnect *r, *tmp;
+	struct pohmelfs_state *st, *stmp;
+	LIST_HEAD(head);
+	int err;
+
+	mutex_lock(&psb->reconnect_lock);
+	list_for_each_entry_safe(r, tmp, &psb->reconnect_list, reconnect_entry) {
+		st = pohmelfs_state_create(psb, &r->sa, r->addrlen, 1, r->group_id);
+		if (IS_ERR(st)) {
+			err = PTR_ERR(st);
+
+			if (err != -EEXIST)
+				continue;
+		} else {
+			pohmelfs_print_addr(&st->sa, "reconnected\n");
+		}
+
+		list_del(&r->reconnect_entry);
+		kfree(r);
+	}
+	mutex_unlock(&psb->reconnect_lock);
+
+	spin_lock(&psb->state_lock);
+	list_for_each_entry_safe(st, stmp, &psb->kill_state_list, state_entry) {
+		list_move(&st->state_entry, &head);
+	}
+	spin_unlock(&psb->state_lock);
+
+	list_for_each_entry_safe(st, stmp, &head, state_entry) {
+		list_del_init(&st->state_entry);
+		pohmelfs_state_kill(st);
+	}
+
+	if (!list_empty(&psb->reconnect_list))
+		queue_delayed_work(psb->wq, &psb->reconnect_work, psb->reconnect_timeout);
+}
+
+static int pohmelfs_init_psb(struct pohmelfs_sb *psb, struct super_block *sb)
+{
+	int err;
+	char name[16];
+
+	INIT_LIST_HEAD(&psb->state_list);
+	psb->route_root = RB_ROOT;
+
+	psb->inode_root = RB_ROOT;
+	spin_lock_init(&psb->inode_lock);
+
+	spin_lock_init(&psb->state_lock);
+
+	atomic_long_set(&psb->ino, 0);
+	atomic_long_set(&psb->trans, 0);
+
+	sb->s_fs_info = psb;
+	sb->s_op = &pohmelfs_sb_ops;
+	sb->s_magic = POHMELFS_MAGIC_NUM;
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_blocksize = PAGE_SIZE;
+	sb->s_bdi = &psb->bdi;
+	sb->s_time_gran = 0;
+
+	psb->read_wait_timeout = 5000;
+	psb->write_wait_timeout = 5000;
+
+	psb->sync_timeout = 300;
+
+	psb->keepalive_cnt = 5;
+	psb->keepalive_interval = 10;
+	psb->keepalive_idle = 30;
+
+	psb->readdir_allocation = 4;
+	psb->reconnect_timeout = msecs_to_jiffies(30000);
+
+	psb->sb = sb;
+
+	psb->hash = crypto_alloc_hash("sha512", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(psb->hash)) {
+		err = PTR_ERR(psb->hash);
+		goto err_out_exit;
+	}
+
+	snprintf(name, sizeof(name), "pohmelfs-%d", psb->bdi_num);
+	psb->wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
+	if (!psb->wq) {
+		err = -ENOMEM;
+		goto err_out_crypto_free;
+	}
+
+	INIT_DELAYED_WORK(&psb->sync_work, pohmelfs_sync);
+
+	INIT_DELAYED_WORK(&psb->reconnect_work, pohmelfs_reconnect);
+	mutex_init(&psb->reconnect_lock);
+	INIT_LIST_HEAD(&psb->reconnect_list);
+	INIT_LIST_HEAD(&psb->kill_state_list);
+
+	return 0;
+
+err_out_crypto_free:
+	crypto_free_hash(psb->hash);
+err_out_exit:
+	psb->sb = NULL;
+	sb->s_fs_info = NULL;
+	return err;
+}
+
+static int pohmelfs_parse_addr(char *addr, struct sockaddr_storage *a, int *addrlen)
+{
+	int family, port;
+	char *ptr;
+	int err = -EINVAL;
+
+	ptr = strrchr(addr, ':');
+	if (!ptr)
+		goto err_out_print_wrong_param;
+	*ptr++ = 0;
+	if (!ptr)
+		goto err_out_print_wrong_param;
+
+	family = simple_strtol(ptr, NULL, 10);
+
+	ptr = strrchr(addr, ':');
+	if (!ptr)
+		goto err_out_print_wrong_param;
+	*ptr++ = 0;
+	if (!ptr)
+		goto err_out_print_wrong_param;
+
+	port = simple_strtol(ptr, NULL, 10);
+
+	if (family == AF_INET) {
+		struct sockaddr_in *sin = (struct sockaddr_in *)a;
+
+		sin->sin_family = family;
+		sin->sin_port = htons(port);
+
+		err = in4_pton(addr, strlen(addr), (u8 *)&sin->sin_addr, ':', NULL);
+		*addrlen = sizeof(struct sockaddr_in);
+	} else if (family == AF_INET6) {
+		struct sockaddr_in6 *sin = (struct sockaddr_in6 *)a;
+
+		sin->sin6_family = family;
+		sin->sin6_port = htons(port);
+		err = in6_pton(addr, strlen(addr), (u8 *)&sin->sin6_addr, ':', NULL);
+		*addrlen = sizeof(struct sockaddr_in6);
+	} else {
+		err = -ENOTSUPP;
+	}
+
+	if (err == 1)
+		err = 0;
+	else if (!err)
+		err = -EINVAL;
+
+	if (err)
+		goto err_out_print_wrong_param;
+
+	return 0;
+
+err_out_print_wrong_param:
+	pr_err("pohmelfs: %s: wrong addr: '%s', should be 'addr:port:family': %d.\n", __func__, addr, err);
+	return err;
+}
+
+static int pohmelfs_option(char *option, char *data, int *lenp, int have_data)
+{
+	int len;
+	char *ptr;
+
+	if (!strncmp(option, data, strlen(option))) {
+		len = strlen(option);
+		ptr = data + len;
+
+		if (have_data && (!ptr || !*ptr))
+			return 0;
+
+		*lenp = len;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int pohmelfs_set_groups(struct pohmelfs_sb *psb, char *value, int len)
+{
+	int i, num = 0, start = 0, pos = 0;
+	char *ptr = value;
+
+	for (i = 0; i < len; ++i) {
+		if (value[i] == ':')
+			start = 0;
+		else if (!start) {
+			start = 1;
+			num++;
+		}
+	}
+
+	if (!num) {
+		return -ENOENT;
+	}
+
+	psb->groups = kzalloc(sizeof(int) * num, GFP_KERNEL);
+	if (!psb->groups)
+		return -ENOMEM;
+	psb->group_num = num;
+
+	start = 0;
+	for (i = 0; i < len; ++i) {
+		if (value[i] == ':') {
+			value[i] = '\0';
+			if (start) {
+				psb->groups[pos] = simple_strtol(ptr, NULL, 10);
+				pos++;
+				start = 0;
+			}
+		} else if (!start) {
+			ptr = &value[i];
+			start = 1;
+		}
+	}
+
+	if (start) {
+		psb->groups[pos] = simple_strtol(ptr, NULL, 10);
+		pos++;
+	}
+
+	return 0;
+}
+
+static int pohmelfs_parse_option(struct pohmelfs_sb *psb, char *data)
+{
+	int len;
+	int err = 0;
+
+	pr_debug("pohmelfs: %s: option: %s\n", __func__, data);
+
+	if (pohmelfs_option("server=", data, &len, 1)) {
+		int addrlen;
+		char *addr_str = data + len;
+		struct sockaddr_storage sa;
+		struct pohmelfs_state *st;
+
+		memset(&sa, 0, sizeof(struct sockaddr_storage));
+		err = pohmelfs_parse_addr(addr_str, &sa, &addrlen);
+		if (err)
+			goto err_out_exit;
+
+		st = pohmelfs_state_create(psb, &sa, addrlen, 1, 0);
+		if (IS_ERR(st)) {
+			err = PTR_ERR(st);
+			if (err != -EEXIST)
+				goto err_out_exit;
+			err = 0;
+		}
+	} else if (pohmelfs_option("fsid=", data, &len, 1)) {
+		data += len;
+		len = strlen(data);
+
+		psb->fsid = kmalloc(len + 1, GFP_KERNEL);
+		if (!psb->fsid) {
+			err = -ENOMEM;
+			goto err_out_exit;
+		}
+
+		snprintf(psb->fsid, len + 1, "%s", data);
+		psb->fsid_len = len;
+	} else if (pohmelfs_option("sync_timeout=", data, &len, 1)) {
+		psb->sync_timeout = simple_strtol(data + len, NULL, 10);
+	} else if (pohmelfs_option("http_compat=", data, &len, 1)) {
+		psb->http_compat = simple_strtol(data + len, NULL, 10);
+		err = pohmelfs_http_compat_init(psb);
+	} else if (pohmelfs_option("groups=", data, &len, 1)) {
+		data += len;
+		len = strlen(data);
+
+		err = pohmelfs_set_groups(psb, data, len);
+	} else if (pohmelfs_option("noatime", data, &len, 0)) {
+		psb->sb->s_flags |= FS_NOATIME_FL;
+	} else if (pohmelfs_option("relatime", data, &len, 0)) {
+		psb->sb->s_flags |= MS_RELATIME;
+	} else if (pohmelfs_option("noreadcsum", data, &len, 0)) {
+		psb->no_read_csum = 1;
+	} else if (pohmelfs_option("readcsum", data, &len, 0)) {
+		psb->no_read_csum = 0;
+	} else if (pohmelfs_option("successful_write_count=", data, &len, 1)) {
+		psb->successful_write_count = simple_strtol(data + len, NULL, 10);
+	} else if (pohmelfs_option("keepalive_cnt=", data, &len, 1)) {
+		psb->keepalive_cnt = simple_strtol(data + len, NULL, 10);
+	} else if (pohmelfs_option("keepalive_idle=", data, &len, 1)) {
+		psb->keepalive_idle = simple_strtol(data + len, NULL, 10);
+	} else if (pohmelfs_option("keepalive_interval=", data, &len, 1)) {
+		psb->keepalive_interval = simple_strtol(data + len, NULL, 10);
+	} else if (pohmelfs_option("readdir_allocation=", data, &len, 1)) {
+		psb->readdir_allocation = simple_strtol(data + len, NULL, 10);
+	} else if (pohmelfs_option("sync_on_close", data, &len, 0)) {
+		psb->sync_on_close = 1;
+	} else {
+		err = -ENOTSUPP;
+	}
+
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_parse_options(struct pohmelfs_sb *psb, char *data)
+{
+	int err = -ENOENT;
+	char *ptr, *start;
+
+	ptr = start = data;
+
+	while (ptr && *ptr) {
+		if (*ptr == ',') {
+			*ptr = '\0';
+			err = pohmelfs_parse_option(psb, start);
+			if (err)
+				goto err_out_exit;
+			ptr++;
+			if (ptr && *ptr)
+				start = ptr;
+
+			continue;
+		}
+
+		ptr++;
+	}
+
+	if (start != ptr) {
+		err = pohmelfs_parse_option(psb, start);
+		if (err)
+			goto err_out_exit;
+	}
+
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct pohmelfs_sb *psb;
+	int err;
+
+	psb = kzalloc(sizeof(struct pohmelfs_sb), GFP_KERNEL);
+	if (!psb) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	psb->bdi_num = atomic_inc_return(&psb_bdi_num);
+
+	err = bdi_init(&psb->bdi);
+	if (err)
+		goto err_out_free_psb;
+
+	psb->bdi.ra_pages = default_backing_dev_info.ra_pages;
+
+	err = bdi_register(&psb->bdi, NULL, "pfs-%d", psb->bdi_num);
+	if (err) {
+		bdi_destroy(&psb->bdi);
+		goto err_out_free_psb;
+	}
+
+	err = pohmelfs_init_psb(psb, sb);
+	if (err)
+		goto err_out_free_bdi;
+
+	psb->root = pohmelfs_new_inode(psb, 0755|S_IFDIR);
+	if (IS_ERR(psb->root)) {
+		err = PTR_ERR(psb->root);
+		goto err_out_cleanup_psb;
+	}
+
+	err = pohmelfs_parse_options(psb, data);
+	if (err)
+		goto err_out_put_root;
+
+	if (!psb->group_num) {
+		err = -EINVAL;
+		pr_err("pohmelfs: you did not specify groups option, which is mandatory\n");
+		goto err_out_put_root;
+	}
+
+	if (!psb->fsid_len) {
+		char str[] = "pohmelfs";
+		err = pohmelfs_hash(psb, str, 8, &psb->root->id);
+	} else {
+		err = pohmelfs_hash(psb, psb->fsid, psb->fsid_len, &psb->root->id);
+	}
+	if (err)
+		goto err_out_put_root;
+
+	psb->root->parent_id = psb->root->id;
+
+	sb->s_root = d_alloc_root(&psb->root->vfs_inode);
+	if (!sb->s_root) {
+		err = -ENOMEM;
+		goto err_out_put_root;
+	}
+
+	queue_delayed_work(psb->wq, &psb->sync_work, msecs_to_jiffies(psb->sync_timeout * 1000));
+
+	return 0;
+
+err_out_put_root:
+	iput(&psb->root->vfs_inode);
+err_out_cleanup_psb:
+	pohmelfs_cleanup_psb(psb);
+err_out_free_bdi:
+	bdi_destroy(&psb->bdi);
+err_out_free_psb:
+	kfree(psb);
+err_out_exit:
+	pr_err("pohmelfs: %s: error: %d\n", __func__, err);
+	return err;
+}
+
+static struct dentry *pohmelfs_mount(struct file_system_type *fs_type,
+		       int flags, const char *dev_name, void *data)
+{
+	return mount_nodev(fs_type, flags, data, pohmelfs_fill_super);
+}
+
+static void pohmelfs_kill_sb(struct super_block *sb)
+{
+	sync_inodes_sb(sb);
+	kill_anon_super(sb);
+}
+
+static struct file_system_type pohmelfs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "pohmelfs",
+	.mount		= pohmelfs_mount,
+	.kill_sb	= pohmelfs_kill_sb,
+};
+
+static void pohmelfs_cleanup_cache(void)
+{
+	kmem_cache_destroy(pohmelfs_trans_cache);
+	kmem_cache_destroy(pohmelfs_inode_cache);
+	kmem_cache_destroy(pohmelfs_inode_info_cache);
+	kmem_cache_destroy(pohmelfs_route_cache);
+	kmem_cache_destroy(pohmelfs_wait_cache);
+	kmem_cache_destroy(pohmelfs_io_cache);
+	kmem_cache_destroy(pohmelfs_inode_info_binary_package_cache);
+	kfree(pohmelfs_scratch_buf);
+	kmem_cache_destroy(pohmelfs_write_cache);
+	kmem_cache_destroy(pohmelfs_dentry_cache);
+}
+
+static int pohmelfs_init_cache(void)
+{
+	int err = -ENOMEM;
+
+	pohmelfs_inode_cache = KMEM_CACHE(pohmelfs_inode, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_inode_cache)
+		goto err_out_exit;
+
+	pohmelfs_trans_cache = KMEM_CACHE(pohmelfs_trans, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_trans_cache)
+		goto err_out_destroy_inode_cache;
+
+	pohmelfs_inode_info_cache = KMEM_CACHE(pohmelfs_inode_info, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_inode_info_cache)
+		goto err_out_destroy_trans_cache;
+
+	pohmelfs_route_cache = KMEM_CACHE(pohmelfs_route, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_route_cache)
+		goto err_out_destroy_inode_info_cache;
+
+	pohmelfs_wait_cache = KMEM_CACHE(pohmelfs_wait, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_wait_cache)
+		goto err_out_destroy_inode_info_cache;
+
+	pohmelfs_io_cache = KMEM_CACHE(pohmelfs_io, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_io_cache)
+		goto err_out_destroy_wait_cache;
+
+	pohmelfs_scratch_buf = kmalloc(pohmelfs_scratch_buf_size, GFP_KERNEL);
+	if (!pohmelfs_scratch_buf) {
+		err = -ENOMEM;
+		goto err_out_destroy_io_cache;
+	}
+
+	pohmelfs_inode_info_binary_package_cache = KMEM_CACHE(pohmelfs_inode_info_binary_package, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_inode_info_binary_package_cache)
+		goto err_out_free_scratch;
+
+	pohmelfs_write_cache = KMEM_CACHE(pohmelfs_write_ctl, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_write_cache)
+		goto err_out_destroy_inode_info_binary_package_cache;
+
+	pohmelfs_dentry_cache = KMEM_CACHE(pohmelfs_dentry, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!pohmelfs_dentry_cache)
+		goto err_out_destroy_write_cache;
+
+	return 0;
+
+err_out_destroy_write_cache:
+	kmem_cache_destroy(pohmelfs_write_cache);
+err_out_destroy_inode_info_binary_package_cache:
+	kmem_cache_destroy(pohmelfs_inode_info_binary_package_cache);
+err_out_free_scratch:
+	kfree(pohmelfs_scratch_buf);
+err_out_destroy_io_cache:
+	kmem_cache_destroy(pohmelfs_io_cache);
+err_out_destroy_wait_cache:
+	kmem_cache_destroy(pohmelfs_wait_cache);
+err_out_destroy_inode_info_cache:
+	kmem_cache_destroy(pohmelfs_inode_info_cache);
+err_out_destroy_trans_cache:
+	kmem_cache_destroy(pohmelfs_trans_cache);
+err_out_destroy_inode_cache:
+	kmem_cache_destroy(pohmelfs_inode_cache);
+err_out_exit:
+	return err;
+}
+
+static int __init pohmelfs_init(void)
+{
+	int err;
+
+	err = pohmelfs_init_cache();
+	if (err)
+		goto err_out_exit;
+
+        err = register_filesystem(&pohmelfs_type);
+	if (err)
+		goto err_out_cleanup_cache;
+
+	return 0;
+
+err_out_cleanup_cache:
+	pohmelfs_cleanup_cache();
+err_out_exit:
+	return err;
+}
+
+static void __exit pohmelfs_exit(void)
+{
+	unregister_filesystem(&pohmelfs_type);
+	pohmelfs_cleanup_cache();
+}
+
+module_init(pohmelfs_init)
+module_exit(pohmelfs_exit)
+
+MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
+MODULE_DESCRIPTION("POHMELFS");
+MODULE_LICENSE("GPL");
diff --git a/fs/pohmelfs/symlink.c b/fs/pohmelfs/symlink.c
new file mode 100644
index 0000000..80a9d87
--- /dev/null
+++ b/fs/pohmelfs/symlink.c
@@ -0,0 +1,13 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/namei.h>
+
+#include "pohmelfs.h"
+
+const struct inode_operations pohmelfs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
+};
diff --git a/fs/pohmelfs/trans.c b/fs/pohmelfs/trans.c
new file mode 100644
index 0000000..8a623fc
--- /dev/null
+++ b/fs/pohmelfs/trans.c
@@ -0,0 +1,384 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#include "pohmelfs.h"
+
+static void pohmelfs_trans_free(struct pohmelfs_trans *t)
+{
+	iput(t->inode);
+
+	kmem_cache_free(pohmelfs_trans_cache, t);
+}
+
+static void pohmelfs_trans_release(struct kref *kref)
+{
+	struct pohmelfs_trans *t = container_of(kref, struct pohmelfs_trans, refcnt);
+	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
+
+	pr_debug("pohmelfs: %s: trans freed: %lu, recv_offset: %llu, ino: %ld\n",
+			pohmelfs_dump_id(pi->id.id), t->trans, t->recv_offset, t->inode->i_ino);
+
+	if (t->cb.destroy)
+		t->cb.destroy(t);
+
+	pohmelfs_state_put(t->st);
+
+	kfree(t->data);
+	kfree(t->recv_data);
+	pohmelfs_trans_free(t);
+}
+
+void pohmelfs_trans_put(struct pohmelfs_trans *t)
+{
+	kref_put(&t->refcnt, pohmelfs_trans_release);
+}
+
+struct pohmelfs_trans *pohmelfs_trans_alloc(struct inode *inode)
+{
+	struct pohmelfs_trans *t;
+	int err;
+
+	t = kmem_cache_zalloc(pohmelfs_trans_cache, GFP_NOIO);
+	if (!t) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	kref_init(&t->refcnt);
+
+	t->inode = igrab(inode);
+	if (!t->inode) {
+		err = -ENOENT;
+		goto err_out_free;
+	}
+
+	return t;
+
+err_out_free:
+	kmem_cache_free(pohmelfs_trans_cache, t);
+err_out_exit:
+	return ERR_PTR(err);
+}
+
+static int pohmelfs_buf_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
+	struct dnet_cmd *cmd = &recv->cmd;
+	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
+
+	pr_debug("pohmelfs: %s: trans complete: %llu, flags: %x\n",
+			pohmelfs_dump_id(pi->id.id), trans, cmd->flags);
+
+	return 0;
+}
+
+static int pohmelfs_buf_recv(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct dnet_cmd *cmd = &recv->cmd;
+	int err;
+
+	if (!t->recv_data) {
+		t->recv_data = kmalloc(cmd->size, GFP_NOIO);
+		if (!t->recv_data) {
+			err = -ENOMEM;
+			goto err_out_exit;
+		}
+
+		t->recv_offset = 0;
+	}
+
+	err = pohmelfs_data_recv(recv, t->recv_data + t->recv_offset, cmd->size - t->recv_offset, MSG_DONTWAIT);
+	if (err < 0)
+		goto err_out_exit;
+
+	t->recv_offset += err;
+	err = 0;
+
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_init_callbacks(struct pohmelfs_trans *t, struct pohmelfs_io *pio)
+{
+	int err = 0;
+	struct pohmelfs_state *st = t->st;
+
+	t->priv = pio->priv;
+	t->cb = pio->cb;
+
+	if (!t->cb.complete)
+		t->cb.complete = pohmelfs_buf_complete;
+
+	if (!t->cb.recv_reply)
+		t->cb.recv_reply = pohmelfs_buf_recv;
+
+	if (t->cb.init) {
+		err = t->cb.init(t);
+		if (err)
+			goto err_out_exit;
+	}
+
+	pohmelfs_trans_insert(t);
+
+	pohmelfs_state_schedule(st);
+	pohmelfs_state_put(st);
+
+err_out_exit:
+	return err;
+}
+
+int pohmelfs_send_io_group(struct pohmelfs_io *pio, int group)
+{
+	struct pohmelfs_inode *pi = pio->pi;
+	struct inode *inode = &pi->vfs_inode;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_state *st;
+	struct pohmelfs_trans *t;
+	struct dnet_cmd *cmd;
+	struct dnet_attr *attr;
+	struct dnet_io_attr *io;
+	u64 iosize = pio->size;
+	u64 alloc_io_size = pio->size;
+	int err;
+
+	/* Dirty hack to prevent setting cmd/attr size to pio->size,
+	 * since in read command we specify in io->size number bytes we want,
+	 * and it should not be accounted in the packet we send to remote node
+	 */
+	if (pio->cmd == DNET_CMD_READ)
+		alloc_io_size = 0;
+
+	t = pohmelfs_trans_alloc(inode);
+	if (IS_ERR(t)) {
+		err = PTR_ERR(t);
+		goto err_out_exit;
+	}
+
+	st = pohmelfs_state_lookup(psb, pio->id, group);
+	if (!st) {
+		err = -ENOENT;
+		goto err_out_free;
+	}
+
+	t->st = st;
+
+	/*
+	 * We already hold a reference grabbed in pohmelfs_state_lookup(), it is dropped when transaction is destroyed
+	 * We have to have valid state pointer to schedule sending, but after transaction is inserted into state's list,
+	 * it can be processed immediately and freed and grabbed reference pointer will dissapear.
+	 */
+	pohmelfs_state_get(st);
+
+	cmd = &t->cmd.cmd;
+	attr = &t->cmd.attr;
+	io = &t->cmd.p.io;
+
+	dnet_setup_id(&cmd->id, group, pio->id->id);
+	cmd->flags = pio->cflags;
+	cmd->trans = t->trans = atomic_long_inc_return(&psb->trans);
+	cmd->size = alloc_io_size + sizeof(struct dnet_io_attr) + sizeof(struct dnet_attr);
+
+	attr->cmd = pio->cmd;
+	attr->size = alloc_io_size + sizeof(struct dnet_io_attr);
+	attr->flags = pio->aflags;
+
+	memcpy(io->id, pio->id->id, DNET_ID_SIZE);
+	memcpy(io->parent, pio->id->id, DNET_ID_SIZE);
+	io->flags = pio->ioflags;
+	io->size = iosize;
+	io->offset = pio->offset;
+	io->type = pio->type;
+	io->start = pio->start;
+	io->num = pio->num;
+
+	t->header_size = sizeof(struct dnet_cmd) + sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
+	t->data_size = alloc_io_size;
+
+	dnet_convert_cmd(cmd);
+	dnet_convert_attr(attr);
+	dnet_convert_io_attr(io);
+
+	t->wctl = pio->wctl;
+
+	if (pio->data) {
+		if (pio->alloc_flags & POHMELFS_IO_OWN) {
+			t->data = pio->data;
+		} else {
+			t->data = kmalloc(alloc_io_size, GFP_NOIO);
+			if (!t->data) {
+				err = -ENOMEM;
+				goto err_out_put_state;
+			}
+
+			memcpy(t->data, pio->data, alloc_io_size);
+		}
+	}
+
+	err = pohmelfs_init_callbacks(t, pio);
+	if (err)
+		goto err_out_put_state;
+
+
+	return 0;
+
+err_out_put_state:
+	pohmelfs_state_put(t->st);
+err_out_free:
+	pohmelfs_trans_free(t);
+err_out_exit:
+	return err;
+}
+
+int pohmelfs_send_io(struct pohmelfs_io *pio)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(pio->pi->vfs_inode.i_sb);
+	int i, err, err_num;
+
+	err = -ENOENT;
+	err_num = 0;
+
+	for (i = 0; i < psb->group_num; ++i) {
+		err = pohmelfs_send_io_group(pio, psb->groups[i]);
+		if (err)
+			err_num++;
+	}
+
+	return (err_num == psb->group_num) ? err : 0;
+}
+
+int pohmelfs_trans_insert(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_state *st = t->st;
+
+	mutex_lock(&st->trans_lock);
+	list_add_tail(&t->trans_entry, &st->trans_list);
+	mutex_unlock(&st->trans_lock);
+
+	return 0;
+}
+
+void pohmelfs_trans_remove(struct pohmelfs_trans *t)
+{
+	struct pohmelfs_state *st = t->st;
+
+	mutex_lock(&st->trans_lock);
+	list_del(&t->trans_entry);
+	mutex_unlock(&st->trans_lock);
+}
+
+struct pohmelfs_trans *pohmelfs_trans_lookup(struct pohmelfs_state *st, struct dnet_cmd *cmd)
+{
+	struct pohmelfs_trans *t, *found = NULL;
+	u64 trans = cmd->trans & ~DNET_TRANS_REPLY;
+
+	mutex_lock(&st->trans_lock);
+	list_for_each_entry(t, &st->sent_trans_list, trans_entry) {
+		if (trans == t->trans) {
+			found = t;
+
+			kref_get(&t->refcnt);
+			break;
+		}
+	}
+	mutex_unlock(&st->trans_lock);
+
+	return found;
+}
+
+int pohmelfs_send_buf_single(struct pohmelfs_io *pio, struct pohmelfs_state *st)
+{
+	struct pohmelfs_inode *pi = pio->pi;
+	struct inode *inode = &pi->vfs_inode;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_trans *t;
+	struct dnet_cmd *cmd;
+	struct dnet_attr *attr;
+	int err;
+
+	t = pohmelfs_trans_alloc(inode);
+	if (IS_ERR(t)) {
+		err = PTR_ERR(t);
+		goto err_out_exit;
+	}
+
+	if (!st) {
+		st = pohmelfs_state_lookup(psb, pio->id, pio->group_id);
+		if (!st) {
+			err = -ENOENT;
+			goto err_out_free;
+		}
+	} else {
+		pohmelfs_state_get(st);
+	}
+
+	t->st = st;
+	pohmelfs_state_get(st);
+
+	cmd = &t->cmd.cmd;
+	attr = &t->cmd.attr;
+
+	dnet_setup_id(&cmd->id, st->group_id, pio->id->id);
+	cmd->flags = pio->cflags;
+	cmd->trans = t->trans = atomic_long_inc_return(&psb->trans);
+	cmd->size = pio->size + sizeof(struct dnet_attr);
+
+	attr->cmd = pio->cmd;
+	attr->size = pio->size;
+	attr->flags = pio->aflags;
+
+	t->header_size = sizeof(struct dnet_cmd) + sizeof(struct dnet_attr);
+	t->data_size = pio->size;
+
+	dnet_convert_cmd(cmd);
+	dnet_convert_attr(attr);
+
+	if (pio->data) {
+		if (pio->alloc_flags & POHMELFS_IO_OWN) {
+			t->data = pio->data;
+		} else {
+			t->data = kmalloc(pio->size, GFP_NOIO);
+			if (!t->data) {
+				err = -ENOMEM;
+				goto err_out_put_state;
+			}
+
+			memcpy(t->data, pio->data, pio->size);
+		}
+	}
+
+	err = pohmelfs_init_callbacks(t, pio);
+	if (err)
+		goto err_out_put_state;
+
+	return 0;
+
+err_out_put_state:
+	pohmelfs_state_put(t->st);
+err_out_free:
+	pohmelfs_trans_free(t);
+err_out_exit:
+	return err;
+}
+
+int pohmelfs_send_buf(struct pohmelfs_io *pio)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(pio->pi->vfs_inode.i_sb);
+	int i, err, err_num;
+
+	err = -ENOENT;
+	err_num = 0;
+
+	for (i = 0; i < psb->group_num; ++i) {
+		pio->group_id = psb->groups[i];
+
+		err = pohmelfs_send_buf_single(pio, NULL);
+		if (err)
+			err_num++;
+	}
+
+	return (err_num == psb->group_num) ? err : 0;
+}

--gKMricLos+KVdGMg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="pohmelfs-staging-remove.diff"

commit 0a1cf67228562021535f3d2d35ff8aa198af0eba
Author: Evgeniy Polyakov <zbr@ioremap.net>
Date:   Wed Feb 8 23:12:08 2012 +0400

    Removed drivers/staging/pohmelfs

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 06c9081..a7bf415 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -66,8 +66,6 @@ source "drivers/staging/rts_pstor/Kconfig"
 
 source "drivers/staging/frontier/Kconfig"
 
-source "drivers/staging/pohmelfs/Kconfig"
-
 source "drivers/staging/phison/Kconfig"
 
 source "drivers/staging/line6/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index f3c5e33..6dce1c3 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -27,7 +27,6 @@ obj-$(CONFIG_R8712U)		+= rtl8712/
 obj-$(CONFIG_RTS_PSTOR)		+= rts_pstor/
 obj-$(CONFIG_SPECTRA)		+= spectra/
 obj-$(CONFIG_TRANZPORT)		+= frontier/
-obj-$(CONFIG_POHMELFS)		+= pohmelfs/
 obj-$(CONFIG_IDE_PHISON)	+= phison/
 obj-$(CONFIG_LINE6_USB)		+= line6/
 obj-$(CONFIG_USB_SERIAL_QUATECH2)	+= serqt_usb2/
diff --git a/drivers/staging/pohmelfs/Kconfig b/drivers/staging/pohmelfs/Kconfig
deleted file mode 100644
index 58158b8..0000000
--- a/drivers/staging/pohmelfs/Kconfig
+++ /dev/null
@@ -1,28 +0,0 @@
-config POHMELFS
-	tristate "POHMELFS filesystem support"
-	depends on NET
-	select CONNECTOR
-	select CRYPTO
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_HMAC
-	help
-	  POHMELFS stands for Parallel Optimized Host Message Exchange Layered
-	  File System.  This is a network filesystem which supports coherent
-	  caching of data and metadata on clients.
-
-config POHMELFS_DEBUG
-	bool "POHMELFS debugging"
-	depends on POHMELFS
-	default n
-	help
-	  Turns on excessive POHMELFS debugging facilities.
-	  You usually do not want to slow things down noticeably and get really
-	  lots of kernel messages in syslog.
-
-config POHMELFS_CRYPTO
-	bool "POHMELFS crypto support"
-	depends on POHMELFS
-	help
-	  This option allows to encrypt and/or protect with strong
-	  cryptographic hash all dataflow between server and clients.
-	  Each config group can have its own keys.
diff --git a/drivers/staging/pohmelfs/Makefile b/drivers/staging/pohmelfs/Makefile
deleted file mode 100644
index 196561c..0000000
--- a/drivers/staging/pohmelfs/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-obj-$(CONFIG_POHMELFS)	+= pohmelfs.o
-
-pohmelfs-y := inode.o config.o dir.o net.o path_entry.o trans.o crypto.o lock.o mcache.o
diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
deleted file mode 100644
index b6c42cb..0000000
--- a/drivers/staging/pohmelfs/config.c
+++ /dev/null
@@ -1,611 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/connector.h>
-#include <linux/crypto.h>
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/string.h>
-#include <linux/in.h>
-#include <linux/slab.h>
-
-#include "netfs.h"
-
-/*
- * Global configuration list.
- * Each client can be asked to get one of them.
- *
- * Allows to provide remote server address (ipv4/v6/whatever), port
- * and so on via kernel connector.
- */
-
-static struct cb_id pohmelfs_cn_id = {.idx = POHMELFS_CN_IDX, .val = POHMELFS_CN_VAL};
-static LIST_HEAD(pohmelfs_config_list);
-static DEFINE_MUTEX(pohmelfs_config_lock);
-
-static inline int pohmelfs_config_eql(struct pohmelfs_ctl *sc, struct pohmelfs_ctl *ctl)
-{
-	if (sc->idx == ctl->idx && sc->type == ctl->type &&
-			sc->proto == ctl->proto &&
-			sc->addrlen == ctl->addrlen &&
-			!memcmp(&sc->addr, &ctl->addr, ctl->addrlen))
-		return 1;
-
-	return 0;
-}
-
-static struct pohmelfs_config_group *pohmelfs_find_config_group(unsigned int idx)
-{
-	struct pohmelfs_config_group *g, *group = NULL;
-
-	list_for_each_entry(g, &pohmelfs_config_list, group_entry) {
-		if (g->idx == idx) {
-			group = g;
-			break;
-		}
-	}
-
-	return group;
-}
-
-static struct pohmelfs_config_group *pohmelfs_find_create_config_group(unsigned int idx)
-{
-	struct pohmelfs_config_group *g;
-
-	g = pohmelfs_find_config_group(idx);
-	if (g)
-		return g;
-
-	g = kzalloc(sizeof(struct pohmelfs_config_group), GFP_KERNEL);
-	if (!g)
-		return NULL;
-
-	INIT_LIST_HEAD(&g->config_list);
-	g->idx = idx;
-	g->num_entry = 0;
-
-	list_add_tail(&g->group_entry, &pohmelfs_config_list);
-
-	return g;
-}
-
-static inline void pohmelfs_insert_config_entry(struct pohmelfs_sb *psb, struct pohmelfs_config *dst)
-{
-	struct pohmelfs_config *tmp;
-
-	INIT_LIST_HEAD(&dst->config_entry);
-
-	list_for_each_entry(tmp, &psb->state_list, config_entry) {
-		if (dst->state.ctl.prio > tmp->state.ctl.prio)
-			list_add_tail(&dst->config_entry, &tmp->config_entry);
-	}
-	if (list_empty(&dst->config_entry))
-		list_add_tail(&dst->config_entry, &psb->state_list);
-}
-
-static int pohmelfs_move_config_entry(struct pohmelfs_sb *psb,
-		struct pohmelfs_config *dst, struct pohmelfs_config *new)
-{
-	if ((dst->state.ctl.prio == new->state.ctl.prio) &&
-		(dst->state.ctl.perm == new->state.ctl.perm))
-		return 0;
-
-	dprintk("%s: dst: prio: %d, perm: %x, new: prio: %d, perm: %d.\n",
-			__func__, dst->state.ctl.prio, dst->state.ctl.perm,
-			new->state.ctl.prio, new->state.ctl.perm);
-	dst->state.ctl.prio = new->state.ctl.prio;
-	dst->state.ctl.perm = new->state.ctl.perm;
-
-	list_del_init(&dst->config_entry);
-	pohmelfs_insert_config_entry(psb, dst);
-	return 0;
-}
-
-/*
- * pohmelfs_copy_config() is used to copy new state configs from the
- * config group (controlled by the netlink messages) into the superblock.
- * This happens either at startup time where no transactions can access
- * the list of the configs (and thus list of the network states), or at
- * run-time, where it is protected by the psb->state_lock.
- */
-int pohmelfs_copy_config(struct pohmelfs_sb *psb)
-{
-	struct pohmelfs_config_group *g;
-	struct pohmelfs_config *c, *dst;
-	int err = -ENODEV;
-
-	mutex_lock(&pohmelfs_config_lock);
-
-	g = pohmelfs_find_config_group(psb->idx);
-	if (!g)
-		goto out_unlock;
-
-	/*
-	 * Run over all entries in given config group and try to create and
-	 * initialize those, which do not exist in superblock list.
-	 * Skip all existing entries.
-	 */
-
-	list_for_each_entry(c, &g->config_list, config_entry) {
-		err = 0;
-		list_for_each_entry(dst, &psb->state_list, config_entry) {
-			if (pohmelfs_config_eql(&dst->state.ctl, &c->state.ctl)) {
-				err = pohmelfs_move_config_entry(psb, dst, c);
-				if (!err)
-					err = -EEXIST;
-				break;
-			}
-		}
-
-		if (err)
-			continue;
-
-		dst = kzalloc(sizeof(struct pohmelfs_config), GFP_KERNEL);
-		if (!dst) {
-			err = -ENOMEM;
-			break;
-		}
-
-		memcpy(&dst->state.ctl, &c->state.ctl, sizeof(struct pohmelfs_ctl));
-
-		pohmelfs_insert_config_entry(psb, dst);
-
-		err = pohmelfs_state_init_one(psb, dst);
-		if (err) {
-			list_del(&dst->config_entry);
-			kfree(dst);
-		}
-
-		err = 0;
-	}
-
-out_unlock:
-	mutex_unlock(&pohmelfs_config_lock);
-
-	return err;
-}
-
-int pohmelfs_copy_crypto(struct pohmelfs_sb *psb)
-{
-	struct pohmelfs_config_group *g;
-	int err = -ENOENT;
-
-	mutex_lock(&pohmelfs_config_lock);
-	g = pohmelfs_find_config_group(psb->idx);
-	if (!g)
-		goto err_out_exit;
-
-	if (g->hash_string) {
-		err = -ENOMEM;
-		psb->hash_string = kstrdup(g->hash_string, GFP_KERNEL);
-		if (!psb->hash_string)
-			goto err_out_exit;
-		psb->hash_strlen = g->hash_strlen;
-	}
-
-	if (g->cipher_string) {
-		psb->cipher_string = kstrdup(g->cipher_string, GFP_KERNEL);
-		if (!psb->cipher_string)
-			goto err_out_free_hash_string;
-		psb->cipher_strlen = g->cipher_strlen;
-	}
-
-	if (g->hash_keysize) {
-		psb->hash_key = kmemdup(g->hash_key, g->hash_keysize,
-					GFP_KERNEL);
-		if (!psb->hash_key)
-			goto err_out_free_cipher_string;
-		psb->hash_keysize = g->hash_keysize;
-	}
-
-	if (g->cipher_keysize) {
-		psb->cipher_key = kmemdup(g->cipher_key, g->cipher_keysize,
-					  GFP_KERNEL);
-		if (!psb->cipher_key)
-			goto err_out_free_hash;
-		psb->cipher_keysize = g->cipher_keysize;
-	}
-
-	mutex_unlock(&pohmelfs_config_lock);
-
-	return 0;
-
-err_out_free_hash:
-	kfree(psb->hash_key);
-err_out_free_cipher_string:
-	kfree(psb->cipher_string);
-err_out_free_hash_string:
-	kfree(psb->hash_string);
-err_out_exit:
-	mutex_unlock(&pohmelfs_config_lock);
-	return err;
-}
-
-static int pohmelfs_send_reply(int err, int msg_num, int action, struct cn_msg *msg, struct pohmelfs_ctl *ctl)
-{
-	struct pohmelfs_cn_ack *ack;
-
-	ack = kzalloc(sizeof(struct pohmelfs_cn_ack), GFP_KERNEL);
-	if (!ack)
-		return -ENOMEM;
-
-	memcpy(&ack->msg, msg, sizeof(struct cn_msg));
-
-	if (action == POHMELFS_CTLINFO_ACK)
-		memcpy(&ack->ctl, ctl, sizeof(struct pohmelfs_ctl));
-
-	ack->msg.len = sizeof(struct pohmelfs_cn_ack) - sizeof(struct cn_msg);
-	ack->msg.ack = msg->ack + 1;
-	ack->error = err;
-	ack->msg_num = msg_num;
-
-	cn_netlink_send(&ack->msg, 0, GFP_KERNEL);
-	kfree(ack);
-	return 0;
-}
-
-static int pohmelfs_cn_disp(struct cn_msg *msg)
-{
-	struct pohmelfs_config_group *g;
-	struct pohmelfs_ctl *ctl = (struct pohmelfs_ctl *)msg->data;
-	struct pohmelfs_config *c, *tmp;
-	int err = 0, i = 1;
-
-	if (msg->len != sizeof(struct pohmelfs_ctl))
-		return -EBADMSG;
-
-	mutex_lock(&pohmelfs_config_lock);
-
-	g = pohmelfs_find_config_group(ctl->idx);
-	if (!g) {
-		pohmelfs_send_reply(err, 0, POHMELFS_NOINFO_ACK, msg, NULL);
-		goto out_unlock;
-	}
-
-	list_for_each_entry_safe(c, tmp, &g->config_list, config_entry) {
-		struct pohmelfs_ctl *sc = &c->state.ctl;
-		if (pohmelfs_send_reply(err, g->num_entry - i, POHMELFS_CTLINFO_ACK, msg, sc)) {
-			err = -ENOMEM;
-			goto out_unlock;
-		}
-		i += 1;
-	}
-
- out_unlock:
-	mutex_unlock(&pohmelfs_config_lock);
-	return err;
-}
-
-static int pohmelfs_cn_dump(struct cn_msg *msg)
-{
-	struct pohmelfs_config_group *g;
-	struct pohmelfs_config *c, *tmp;
-	int err = 0, i = 1;
-	int total_msg = 0;
-
-	if (msg->len != sizeof(struct pohmelfs_ctl))
-		return -EBADMSG;
-
-	mutex_lock(&pohmelfs_config_lock);
-
-	list_for_each_entry(g, &pohmelfs_config_list, group_entry)
-		total_msg += g->num_entry;
-	if (total_msg == 0) {
-		if (pohmelfs_send_reply(err, 0, POHMELFS_NOINFO_ACK, msg, NULL))
-			err = -ENOMEM;
-		goto out_unlock;
-	}
-
-	list_for_each_entry(g, &pohmelfs_config_list, group_entry) {
-		list_for_each_entry_safe(c, tmp, &g->config_list,
-					 config_entry) {
-			struct pohmelfs_ctl *sc = &c->state.ctl;
-			if (pohmelfs_send_reply(err, total_msg - i,
-						POHMELFS_CTLINFO_ACK, msg,
-						sc)) {
-				err = -ENOMEM;
-				goto out_unlock;
-			}
-			i += 1;
-		}
-	}
-
-out_unlock:
-	mutex_unlock(&pohmelfs_config_lock);
-	return err;
-}
-
-static int pohmelfs_cn_flush(struct cn_msg *msg)
-{
-	struct pohmelfs_config_group *g;
-	struct pohmelfs_ctl *ctl = (struct pohmelfs_ctl *)msg->data;
-	struct pohmelfs_config *c, *tmp;
-	int err = 0;
-
-	if (msg->len != sizeof(struct pohmelfs_ctl))
-		return -EBADMSG;
-
-	mutex_lock(&pohmelfs_config_lock);
-
-	if (ctl->idx != POHMELFS_NULL_IDX) {
-		g = pohmelfs_find_config_group(ctl->idx);
-
-		if (!g)
-			goto out_unlock;
-
-		list_for_each_entry_safe(c, tmp, &g->config_list, config_entry) {
-			list_del(&c->config_entry);
-			g->num_entry--;
-			kfree(c);
-		}
-	} else {
-		list_for_each_entry(g, &pohmelfs_config_list, group_entry) {
-			list_for_each_entry_safe(c, tmp, &g->config_list,
-						 config_entry) {
-				list_del(&c->config_entry);
-				g->num_entry--;
-				kfree(c);
-			}
-		}
-	}
-
-out_unlock:
-	mutex_unlock(&pohmelfs_config_lock);
-	pohmelfs_cn_dump(msg);
-
-	return err;
-}
-
-static int pohmelfs_modify_config(struct pohmelfs_ctl *old, struct pohmelfs_ctl *new)
-{
-	old->perm = new->perm;
-	old->prio = new->prio;
-	return 0;
-}
-
-static int pohmelfs_cn_ctl(struct cn_msg *msg, int action)
-{
-	struct pohmelfs_config_group *g;
-	struct pohmelfs_ctl *ctl = (struct pohmelfs_ctl *)msg->data;
-	struct pohmelfs_config *c, *tmp;
-	int err = 0;
-
-	if (msg->len != sizeof(struct pohmelfs_ctl))
-		return -EBADMSG;
-
-	mutex_lock(&pohmelfs_config_lock);
-
-	g = pohmelfs_find_create_config_group(ctl->idx);
-	if (!g) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
-
-	list_for_each_entry_safe(c, tmp, &g->config_list, config_entry) {
-		struct pohmelfs_ctl *sc = &c->state.ctl;
-
-		if (pohmelfs_config_eql(sc, ctl)) {
-			if (action == POHMELFS_FLAGS_ADD) {
-				err = -EEXIST;
-				goto out_unlock;
-			} else if (action == POHMELFS_FLAGS_DEL) {
-				list_del(&c->config_entry);
-				g->num_entry--;
-				kfree(c);
-				goto out_unlock;
-			} else if (action == POHMELFS_FLAGS_MODIFY) {
-				err = pohmelfs_modify_config(sc, ctl);
-				goto out_unlock;
-			} else {
-				err = -EEXIST;
-				goto out_unlock;
-			}
-		}
-	}
-	if (action == POHMELFS_FLAGS_DEL) {
-		err = -EBADMSG;
-		goto out_unlock;
-	}
-
-	c = kzalloc(sizeof(struct pohmelfs_config), GFP_KERNEL);
-	if (!c) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
-	memcpy(&c->state.ctl, ctl, sizeof(struct pohmelfs_ctl));
-	g->num_entry++;
-
-	list_add_tail(&c->config_entry, &g->config_list);
-
- out_unlock:
-	mutex_unlock(&pohmelfs_config_lock);
-	if (pohmelfs_send_reply(err, 0, POHMELFS_NOINFO_ACK, msg, NULL))
-		err = -ENOMEM;
-
-	return err;
-}
-
-static int pohmelfs_crypto_hash_init(struct pohmelfs_config_group *g, struct pohmelfs_crypto *c)
-{
-	char *algo = (char *)c->data;
-	u8 *key = (u8 *)(algo + c->strlen);
-
-	if (g->hash_string)
-		return -EEXIST;
-
-	g->hash_string = kstrdup(algo, GFP_KERNEL);
-	if (!g->hash_string)
-		return -ENOMEM;
-	g->hash_strlen = c->strlen;
-	g->hash_keysize = c->keysize;
-
-	g->hash_key = kmemdup(key, c->keysize, GFP_KERNEL);
-	if (!g->hash_key) {
-		kfree(g->hash_string);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int pohmelfs_crypto_cipher_init(struct pohmelfs_config_group *g, struct pohmelfs_crypto *c)
-{
-	char *algo = (char *)c->data;
-	u8 *key = (u8 *)(algo + c->strlen);
-
-	if (g->cipher_string)
-		return -EEXIST;
-
-	g->cipher_string = kstrdup(algo, GFP_KERNEL);
-	if (!g->cipher_string)
-		return -ENOMEM;
-	g->cipher_strlen = c->strlen;
-	g->cipher_keysize = c->keysize;
-
-	g->cipher_key = kmemdup(key, c->keysize, GFP_KERNEL);
-	if (!g->cipher_key) {
-		kfree(g->cipher_string);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int pohmelfs_cn_crypto(struct cn_msg *msg)
-{
-	struct pohmelfs_crypto *crypto = (struct pohmelfs_crypto *)msg->data;
-	struct pohmelfs_config_group *g;
-	int err = 0;
-
-	dprintk("%s: idx: %u, strlen: %u, type: %u, keysize: %u, algo: %s.\n",
-			__func__, crypto->idx, crypto->strlen, crypto->type,
-			crypto->keysize, (char *)crypto->data);
-
-	mutex_lock(&pohmelfs_config_lock);
-	g = pohmelfs_find_create_config_group(crypto->idx);
-	if (!g) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
-
-	switch (crypto->type) {
-	case POHMELFS_CRYPTO_HASH:
-			err = pohmelfs_crypto_hash_init(g, crypto);
-			break;
-	case POHMELFS_CRYPTO_CIPHER:
-			err = pohmelfs_crypto_cipher_init(g, crypto);
-			break;
-	default:
-			err = -ENOTSUPP;
-			break;
-	}
-
-out_unlock:
-	mutex_unlock(&pohmelfs_config_lock);
-	if (pohmelfs_send_reply(err, 0, POHMELFS_NOINFO_ACK, msg, NULL))
-		err = -ENOMEM;
-
-	return err;
-}
-
-static void pohmelfs_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
-{
-	int err;
-
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
-		return;
-
-	switch (msg->flags) {
-	case POHMELFS_FLAGS_ADD:
-	case POHMELFS_FLAGS_DEL:
-	case POHMELFS_FLAGS_MODIFY:
-			err = pohmelfs_cn_ctl(msg, msg->flags);
-			break;
-	case POHMELFS_FLAGS_FLUSH:
-			err = pohmelfs_cn_flush(msg);
-			break;
-	case POHMELFS_FLAGS_SHOW:
-			err = pohmelfs_cn_disp(msg);
-			break;
-	case POHMELFS_FLAGS_DUMP:
-			err = pohmelfs_cn_dump(msg);
-			break;
-	case POHMELFS_FLAGS_CRYPTO:
-			err = pohmelfs_cn_crypto(msg);
-			break;
-	default:
-			err = -ENOSYS;
-			break;
-	}
-}
-
-int pohmelfs_config_check(struct pohmelfs_config *config, int idx)
-{
-	struct pohmelfs_ctl *ctl = &config->state.ctl;
-	struct pohmelfs_config *tmp;
-	int err = -ENOENT;
-	struct pohmelfs_ctl *sc;
-	struct pohmelfs_config_group *g;
-
-	mutex_lock(&pohmelfs_config_lock);
-
-	g = pohmelfs_find_config_group(ctl->idx);
-	if (g) {
-		list_for_each_entry(tmp, &g->config_list, config_entry) {
-			sc = &tmp->state.ctl;
-
-			if (pohmelfs_config_eql(sc, ctl)) {
-				err = 0;
-				break;
-			}
-		}
-	}
-
-	mutex_unlock(&pohmelfs_config_lock);
-
-	return err;
-}
-
-int __init pohmelfs_config_init(void)
-{
-	/* XXX remove (void *) cast when vanilla connector got synced */
-	return cn_add_callback(&pohmelfs_cn_id, "pohmelfs", (void *)pohmelfs_cn_callback);
-}
-
-void pohmelfs_config_exit(void)
-{
-	struct pohmelfs_config *c, *tmp;
-	struct pohmelfs_config_group *g, *gtmp;
-
-	cn_del_callback(&pohmelfs_cn_id);
-
-	mutex_lock(&pohmelfs_config_lock);
-	list_for_each_entry_safe(g, gtmp, &pohmelfs_config_list, group_entry) {
-		list_for_each_entry_safe(c, tmp, &g->config_list, config_entry) {
-			list_del(&c->config_entry);
-			kfree(c);
-		}
-
-		list_del(&g->group_entry);
-
-		kfree(g->hash_string);
-
-		kfree(g->cipher_string);
-
-		kfree(g);
-	}
-	mutex_unlock(&pohmelfs_config_lock);
-}
diff --git a/drivers/staging/pohmelfs/crypto.c b/drivers/staging/pohmelfs/crypto.c
deleted file mode 100644
index ad92771..0000000
--- a/drivers/staging/pohmelfs/crypto.c
+++ /dev/null
@@ -1,878 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/crypto.h>
-#include <linux/highmem.h>
-#include <linux/kthread.h>
-#include <linux/pagemap.h>
-#include <linux/scatterlist.h>
-#include <linux/slab.h>
-
-#include "netfs.h"
-
-static struct crypto_hash *pohmelfs_init_hash(struct pohmelfs_sb *psb)
-{
-	int err;
-	struct crypto_hash *hash;
-
-	hash = crypto_alloc_hash(psb->hash_string, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hash)) {
-		err = PTR_ERR(hash);
-		dprintk("%s: idx: %u: failed to allocate hash '%s', err: %d.\n",
-				__func__, psb->idx, psb->hash_string, err);
-		goto err_out_exit;
-	}
-
-	psb->crypto_attached_size = crypto_hash_digestsize(hash);
-
-	if (!psb->hash_keysize)
-		return hash;
-
-	err = crypto_hash_setkey(hash, psb->hash_key, psb->hash_keysize);
-	if (err) {
-		dprintk("%s: idx: %u: failed to set key for hash '%s', err: %d.\n",
-				__func__, psb->idx, psb->hash_string, err);
-		goto err_out_free;
-	}
-
-	return hash;
-
-err_out_free:
-	crypto_free_hash(hash);
-err_out_exit:
-	return ERR_PTR(err);
-}
-
-static struct crypto_ablkcipher *pohmelfs_init_cipher(struct pohmelfs_sb *psb)
-{
-	int err = -EINVAL;
-	struct crypto_ablkcipher *cipher;
-
-	if (!psb->cipher_keysize)
-		goto err_out_exit;
-
-	cipher = crypto_alloc_ablkcipher(psb->cipher_string, 0, 0);
-	if (IS_ERR(cipher)) {
-		err = PTR_ERR(cipher);
-		dprintk("%s: idx: %u: failed to allocate cipher '%s', err: %d.\n",
-				__func__, psb->idx, psb->cipher_string, err);
-		goto err_out_exit;
-	}
-
-	crypto_ablkcipher_clear_flags(cipher, ~0);
-
-	err = crypto_ablkcipher_setkey(cipher, psb->cipher_key, psb->cipher_keysize);
-	if (err) {
-		dprintk("%s: idx: %u: failed to set key for cipher '%s', err: %d.\n",
-				__func__, psb->idx, psb->cipher_string, err);
-		goto err_out_free;
-	}
-
-	return cipher;
-
-err_out_free:
-	crypto_free_ablkcipher(cipher);
-err_out_exit:
-	return ERR_PTR(err);
-}
-
-int pohmelfs_crypto_engine_init(struct pohmelfs_crypto_engine *e, struct pohmelfs_sb *psb)
-{
-	int err;
-
-	e->page_num = 0;
-
-	e->size = PAGE_SIZE;
-	e->data = kmalloc(e->size, GFP_KERNEL);
-	if (!e->data) {
-		err = -ENOMEM;
-		goto err_out_exit;
-	}
-
-	if (psb->hash_string) {
-		e->hash = pohmelfs_init_hash(psb);
-		if (IS_ERR(e->hash)) {
-			err = PTR_ERR(e->hash);
-			e->hash = NULL;
-			goto err_out_free;
-		}
-	}
-
-	if (psb->cipher_string) {
-		e->cipher = pohmelfs_init_cipher(psb);
-		if (IS_ERR(e->cipher)) {
-			err = PTR_ERR(e->cipher);
-			e->cipher = NULL;
-			goto err_out_free_hash;
-		}
-	}
-
-	return 0;
-
-err_out_free_hash:
-	crypto_free_hash(e->hash);
-err_out_free:
-	kfree(e->data);
-err_out_exit:
-	return err;
-}
-
-void pohmelfs_crypto_engine_exit(struct pohmelfs_crypto_engine *e)
-{
-	crypto_free_hash(e->hash);
-	crypto_free_ablkcipher(e->cipher);
-	kfree(e->data);
-}
-
-static void pohmelfs_crypto_complete(struct crypto_async_request *req, int err)
-{
-	struct pohmelfs_crypto_completion *c = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	dprintk("%s: req: %p, err: %d.\n", __func__, req, err);
-	c->error = err;
-	complete(&c->complete);
-}
-
-static int pohmelfs_crypto_process(struct ablkcipher_request *req,
-		struct scatterlist *sg_dst, struct scatterlist *sg_src,
-		void *iv, int enc, unsigned long timeout)
-{
-	struct pohmelfs_crypto_completion complete;
-	int err;
-
-	init_completion(&complete.complete);
-	complete.error = -EINPROGRESS;
-
-	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					pohmelfs_crypto_complete, &complete);
-
-	ablkcipher_request_set_crypt(req, sg_src, sg_dst, sg_src->length, iv);
-
-	if (enc)
-		err = crypto_ablkcipher_encrypt(req);
-	else
-		err = crypto_ablkcipher_decrypt(req);
-
-	switch (err) {
-	case -EINPROGRESS:
-	case -EBUSY:
-		err = wait_for_completion_interruptible_timeout(&complete.complete,
-					timeout);
-		if (!err)
-			err = -ETIMEDOUT;
-		else if (err > 0)
-			err = complete.error;
-		break;
-	default:
-		break;
-	}
-
-	return err;
-}
-
-int pohmelfs_crypto_process_input_data(struct pohmelfs_crypto_engine *e, u64 cmd_iv,
-		void *data, struct page *page, unsigned int size)
-{
-	int err;
-	struct scatterlist sg;
-
-	if (!e->cipher && !e->hash)
-		return 0;
-
-	dprintk("%s: eng: %p, iv: %llx, data: %p, page: %p/%lu, size: %u.\n",
-		__func__, e, cmd_iv, data, page, (page) ? page->index : 0, size);
-
-	if (data) {
-		sg_init_one(&sg, data, size);
-	} else {
-		sg_init_table(&sg, 1);
-		sg_set_page(&sg, page, size, 0);
-	}
-
-	if (e->cipher) {
-		struct ablkcipher_request *req = e->data + crypto_hash_digestsize(e->hash);
-		u8 iv[32];
-
-		memset(iv, 0, sizeof(iv));
-		memcpy(iv, &cmd_iv, sizeof(cmd_iv));
-
-		ablkcipher_request_set_tfm(req, e->cipher);
-
-		err = pohmelfs_crypto_process(req, &sg, &sg, iv, 0, e->timeout);
-		if (err)
-			goto err_out_exit;
-	}
-
-	if (e->hash) {
-		struct hash_desc desc;
-		void *dst = e->data + e->size/2;
-
-		desc.tfm = e->hash;
-		desc.flags = 0;
-
-		err = crypto_hash_init(&desc);
-		if (err)
-			goto err_out_exit;
-
-		err = crypto_hash_update(&desc, &sg, size);
-		if (err)
-			goto err_out_exit;
-
-		err = crypto_hash_final(&desc, dst);
-		if (err)
-			goto err_out_exit;
-
-		err = !!memcmp(dst, e->data, crypto_hash_digestsize(e->hash));
-
-		if (err) {
-#ifdef CONFIG_POHMELFS_DEBUG
-			unsigned int i;
-			unsigned char *recv = e->data, *calc = dst;
-
-			dprintk("%s: eng: %p, hash: %p, cipher: %p: iv : %llx, hash mismatch (recv/calc): ",
-					__func__, e, e->hash, e->cipher, cmd_iv);
-			for (i = 0; i < crypto_hash_digestsize(e->hash); ++i) {
-#if 0
-				dprintka("%02x ", recv[i]);
-				if (recv[i] != calc[i]) {
-					dprintka("| calc byte: %02x.\n", calc[i]);
-					break;
-				}
-#else
-				dprintka("%02x/%02x ", recv[i], calc[i]);
-#endif
-			}
-			dprintk("\n");
-#endif
-			goto err_out_exit;
-		} else {
-			dprintk("%s: eng: %p, hash: %p, cipher: %p: hashes matched.\n",
-					__func__, e, e->hash, e->cipher);
-		}
-	}
-
-	dprintk("%s: eng: %p, size: %u, hash: %p, cipher: %p: completed.\n",
-			__func__, e, e->size, e->hash, e->cipher);
-
-	return 0;
-
-err_out_exit:
-	dprintk("%s: eng: %p, hash: %p, cipher: %p: err: %d.\n",
-			__func__, e, e->hash, e->cipher, err);
-	return err;
-}
-
-static int pohmelfs_trans_iter(struct netfs_trans *t, struct pohmelfs_crypto_engine *e,
-		int (*iterator) (struct pohmelfs_crypto_engine *e,
-				  struct scatterlist *dst,
-				  struct scatterlist *src))
-{
-	void *data = t->iovec.iov_base + sizeof(struct netfs_cmd) + t->psb->crypto_attached_size;
-	unsigned int size = t->iovec.iov_len - sizeof(struct netfs_cmd) - t->psb->crypto_attached_size;
-	struct netfs_cmd *cmd = data;
-	unsigned int sz, pages = t->attached_pages, i, csize, cmd_cmd, dpage_idx;
-	struct scatterlist sg_src, sg_dst;
-	int err;
-
-	while (size) {
-		cmd = data;
-		cmd_cmd = __be16_to_cpu(cmd->cmd);
-		csize = __be32_to_cpu(cmd->size);
-		cmd->iv = __cpu_to_be64(e->iv);
-
-		if (cmd_cmd == NETFS_READ_PAGES || cmd_cmd == NETFS_READ_PAGE)
-			csize = __be16_to_cpu(cmd->ext);
-
-		sz = csize + __be16_to_cpu(cmd->cpad) + sizeof(struct netfs_cmd);
-
-		dprintk("%s: size: %u, sz: %u, cmd_size: %u, cmd_cpad: %u.\n",
-				__func__, size, sz, __be32_to_cpu(cmd->size), __be16_to_cpu(cmd->cpad));
-
-		data += sz;
-		size -= sz;
-
-		sg_init_one(&sg_src, cmd->data, sz - sizeof(struct netfs_cmd));
-		sg_init_one(&sg_dst, cmd->data, sz - sizeof(struct netfs_cmd));
-
-		err = iterator(e, &sg_dst, &sg_src);
-		if (err)
-			return err;
-	}
-
-	if (!pages)
-		return 0;
-
-	dpage_idx = 0;
-	for (i = 0; i < t->page_num; ++i) {
-		struct page *page = t->pages[i];
-		struct page *dpage = e->pages[dpage_idx];
-
-		if (!page)
-			continue;
-
-		sg_init_table(&sg_src, 1);
-		sg_init_table(&sg_dst, 1);
-		sg_set_page(&sg_src, page, page_private(page), 0);
-		sg_set_page(&sg_dst, dpage, page_private(page), 0);
-
-		err = iterator(e, &sg_dst, &sg_src);
-		if (err)
-			return err;
-
-		pages--;
-		if (!pages)
-			break;
-		dpage_idx++;
-	}
-
-	return 0;
-}
-
-static int pohmelfs_encrypt_iterator(struct pohmelfs_crypto_engine *e,
-		struct scatterlist *sg_dst, struct scatterlist *sg_src)
-{
-	struct ablkcipher_request *req = e->data;
-	u8 iv[32];
-
-	memset(iv, 0, sizeof(iv));
-
-	memcpy(iv, &e->iv, sizeof(e->iv));
-
-	return pohmelfs_crypto_process(req, sg_dst, sg_src, iv, 1, e->timeout);
-}
-
-static int pohmelfs_encrypt(struct pohmelfs_crypto_thread *tc)
-{
-	struct netfs_trans *t = tc->trans;
-	struct pohmelfs_crypto_engine *e = &tc->eng;
-	struct ablkcipher_request *req = e->data;
-
-	memset(req, 0, sizeof(struct ablkcipher_request));
-	ablkcipher_request_set_tfm(req, e->cipher);
-
-	e->iv = pohmelfs_gen_iv(t);
-
-	return pohmelfs_trans_iter(t, e, pohmelfs_encrypt_iterator);
-}
-
-static int pohmelfs_hash_iterator(struct pohmelfs_crypto_engine *e,
-		struct scatterlist *sg_dst, struct scatterlist *sg_src)
-{
-	return crypto_hash_update(e->data, sg_src, sg_src->length);
-}
-
-static int pohmelfs_hash(struct pohmelfs_crypto_thread *tc)
-{
-	struct pohmelfs_crypto_engine *e = &tc->eng;
-	struct hash_desc *desc = e->data;
-	unsigned char *dst = tc->trans->iovec.iov_base + sizeof(struct netfs_cmd);
-	int err;
-
-	desc->tfm = e->hash;
-	desc->flags = 0;
-
-	err = crypto_hash_init(desc);
-	if (err)
-		return err;
-
-	err = pohmelfs_trans_iter(tc->trans, e, pohmelfs_hash_iterator);
-	if (err)
-		return err;
-
-	err = crypto_hash_final(desc, dst);
-	if (err)
-		return err;
-
-	{
-		unsigned int i;
-		dprintk("%s: ", __func__);
-		for (i = 0; i < tc->psb->crypto_attached_size; ++i)
-			dprintka("%02x ", dst[i]);
-		dprintka("\n");
-	}
-
-	return 0;
-}
-
-static void pohmelfs_crypto_pages_free(struct pohmelfs_crypto_engine *e)
-{
-	unsigned int i;
-
-	for (i = 0; i < e->page_num; ++i)
-		__free_page(e->pages[i]);
-	kfree(e->pages);
-}
-
-static int pohmelfs_crypto_pages_alloc(struct pohmelfs_crypto_engine *e, struct pohmelfs_sb *psb)
-{
-	unsigned int i;
-
-	e->pages = kmalloc(psb->trans_max_pages * sizeof(struct page *), GFP_KERNEL);
-	if (!e->pages)
-		return -ENOMEM;
-
-	for (i = 0; i < psb->trans_max_pages; ++i) {
-		e->pages[i] = alloc_page(GFP_KERNEL);
-		if (!e->pages[i])
-			break;
-	}
-
-	e->page_num = i;
-	if (!e->page_num)
-		goto err_out_free;
-
-	return 0;
-
-err_out_free:
-	kfree(e->pages);
-	return -ENOMEM;
-}
-
-static void pohmelfs_sys_crypto_exit_one(struct pohmelfs_crypto_thread *t)
-{
-	struct pohmelfs_sb *psb = t->psb;
-
-	if (t->thread)
-		kthread_stop(t->thread);
-
-	mutex_lock(&psb->crypto_thread_lock);
-	list_del(&t->thread_entry);
-	psb->crypto_thread_num--;
-	mutex_unlock(&psb->crypto_thread_lock);
-
-	pohmelfs_crypto_engine_exit(&t->eng);
-	pohmelfs_crypto_pages_free(&t->eng);
-	kfree(t);
-}
-
-static int pohmelfs_crypto_finish(struct netfs_trans *t, struct pohmelfs_sb *psb, int err)
-{
-	struct netfs_cmd *cmd = t->iovec.iov_base;
-	netfs_convert_cmd(cmd);
-
-	if (likely(!err))
-		err = netfs_trans_finish_send(t, psb);
-
-	t->result = err;
-	netfs_trans_put(t);
-
-	return err;
-}
-
-void pohmelfs_crypto_thread_make_ready(struct pohmelfs_crypto_thread *th)
-{
-	struct pohmelfs_sb *psb = th->psb;
-
-	th->page = NULL;
-	th->trans = NULL;
-
-	mutex_lock(&psb->crypto_thread_lock);
-	list_move_tail(&th->thread_entry, &psb->crypto_ready_list);
-	mutex_unlock(&psb->crypto_thread_lock);
-	wake_up(&psb->wait);
-}
-
-static int pohmelfs_crypto_thread_trans(struct pohmelfs_crypto_thread *t)
-{
-	struct netfs_trans *trans;
-	int err = 0;
-
-	trans = t->trans;
-	trans->eng = NULL;
-
-	if (t->eng.hash) {
-		err = pohmelfs_hash(t);
-		if (err)
-			goto out_complete;
-	}
-
-	if (t->eng.cipher) {
-		err = pohmelfs_encrypt(t);
-		if (err)
-			goto out_complete;
-		trans->eng = &t->eng;
-	}
-
-out_complete:
-	t->page = NULL;
-	t->trans = NULL;
-
-	if (!trans->eng)
-		pohmelfs_crypto_thread_make_ready(t);
-
-	pohmelfs_crypto_finish(trans, t->psb, err);
-	return err;
-}
-
-static int pohmelfs_crypto_thread_page(struct pohmelfs_crypto_thread *t)
-{
-	struct pohmelfs_crypto_engine *e = &t->eng;
-	struct page *page = t->page;
-	int err;
-
-	WARN_ON(!PageChecked(page));
-
-	err = pohmelfs_crypto_process_input_data(e, e->iv, NULL, page, t->size);
-	if (!err)
-		SetPageUptodate(page);
-	else
-		SetPageError(page);
-	unlock_page(page);
-	page_cache_release(page);
-
-	pohmelfs_crypto_thread_make_ready(t);
-
-	return err;
-}
-
-static int pohmelfs_crypto_thread_func(void *data)
-{
-	struct pohmelfs_crypto_thread *t = data;
-
-	while (!kthread_should_stop()) {
-		wait_event_interruptible(t->wait, kthread_should_stop() ||
-				t->trans || t->page);
-
-		if (kthread_should_stop())
-			break;
-
-		if (!t->trans && !t->page)
-			continue;
-
-		dprintk("%s: thread: %p, trans: %p, page: %p.\n",
-				__func__, t, t->trans, t->page);
-
-		if (t->trans)
-			pohmelfs_crypto_thread_trans(t);
-		else if (t->page)
-			pohmelfs_crypto_thread_page(t);
-	}
-
-	return 0;
-}
-
-static void pohmelfs_crypto_flush(struct pohmelfs_sb *psb, struct list_head *head)
-{
-	while (!list_empty(head)) {
-		struct pohmelfs_crypto_thread *t = NULL;
-
-		mutex_lock(&psb->crypto_thread_lock);
-		if (!list_empty(head)) {
-			t = list_first_entry(head, struct pohmelfs_crypto_thread, thread_entry);
-			list_del_init(&t->thread_entry);
-		}
-		mutex_unlock(&psb->crypto_thread_lock);
-
-		if (t)
-			pohmelfs_sys_crypto_exit_one(t);
-	}
-}
-
-static void pohmelfs_sys_crypto_exit(struct pohmelfs_sb *psb)
-{
-	while (!list_empty(&psb->crypto_active_list) || !list_empty(&psb->crypto_ready_list)) {
-		dprintk("%s: crypto_thread_num: %u.\n", __func__, psb->crypto_thread_num);
-		pohmelfs_crypto_flush(psb, &psb->crypto_active_list);
-		pohmelfs_crypto_flush(psb, &psb->crypto_ready_list);
-	}
-}
-
-static int pohmelfs_sys_crypto_init(struct pohmelfs_sb *psb)
-{
-	unsigned int i;
-	struct pohmelfs_crypto_thread *t;
-	struct pohmelfs_config *c;
-	struct netfs_state *st;
-	int err;
-
-	list_for_each_entry(c, &psb->state_list, config_entry) {
-		st = &c->state;
-
-		err = pohmelfs_crypto_engine_init(&st->eng, psb);
-		if (err)
-			goto err_out_exit;
-
-		dprintk("%s: st: %p, eng: %p, hash: %p, cipher: %p.\n",
-				__func__, st, &st->eng, &st->eng.hash, &st->eng.cipher);
-	}
-
-	for (i = 0; i < psb->crypto_thread_num; ++i) {
-		err = -ENOMEM;
-		t = kzalloc(sizeof(struct pohmelfs_crypto_thread), GFP_KERNEL);
-		if (!t)
-			goto err_out_free_state_engines;
-
-		init_waitqueue_head(&t->wait);
-
-		t->psb = psb;
-		t->trans = NULL;
-		t->eng.thread = t;
-
-		err = pohmelfs_crypto_engine_init(&t->eng, psb);
-		if (err)
-			goto err_out_free_state_engines;
-
-		err = pohmelfs_crypto_pages_alloc(&t->eng, psb);
-		if (err)
-			goto err_out_free;
-
-		t->thread = kthread_run(pohmelfs_crypto_thread_func, t,
-				"pohmelfs-crypto-%d-%d", psb->idx, i);
-		if (IS_ERR(t->thread)) {
-			err = PTR_ERR(t->thread);
-			t->thread = NULL;
-			goto err_out_free;
-		}
-
-		if (t->eng.cipher)
-			psb->crypto_align_size = crypto_ablkcipher_blocksize(t->eng.cipher);
-
-		mutex_lock(&psb->crypto_thread_lock);
-		list_add_tail(&t->thread_entry, &psb->crypto_ready_list);
-		mutex_unlock(&psb->crypto_thread_lock);
-	}
-
-	psb->crypto_thread_num = i;
-	return 0;
-
-err_out_free:
-	pohmelfs_sys_crypto_exit_one(t);
-err_out_free_state_engines:
-	list_for_each_entry(c, &psb->state_list, config_entry) {
-		st = &c->state;
-		pohmelfs_crypto_engine_exit(&st->eng);
-	}
-err_out_exit:
-	pohmelfs_sys_crypto_exit(psb);
-	return err;
-}
-
-void pohmelfs_crypto_exit(struct pohmelfs_sb *psb)
-{
-	pohmelfs_sys_crypto_exit(psb);
-
-	kfree(psb->hash_string);
-	kfree(psb->cipher_string);
-}
-
-static int pohmelfs_crypt_init_complete(struct page **pages, unsigned int page_num,
-		void *private, int err)
-{
-	struct pohmelfs_sb *psb = private;
-
-	psb->flags = -err;
-	dprintk("%s: err: %d.\n", __func__, err);
-
-	wake_up(&psb->wait);
-
-	return err;
-}
-
-static int pohmelfs_crypto_init_handshake(struct pohmelfs_sb *psb)
-{
-	struct netfs_trans *t;
-	struct netfs_crypto_capabilities *cap;
-	struct netfs_cmd *cmd;
-	char *str;
-	int err = -ENOMEM, size;
-
-	size = sizeof(struct netfs_crypto_capabilities) +
-		psb->cipher_strlen + psb->hash_strlen + 2; /* 0 bytes */
-
-	t = netfs_trans_alloc(psb, size, 0, 0);
-	if (!t)
-		goto err_out_exit;
-
-	t->complete = pohmelfs_crypt_init_complete;
-	t->private = psb;
-
-	cmd = netfs_trans_current(t);
-	cap = (struct netfs_crypto_capabilities *)(cmd + 1);
-	str = (char *)(cap + 1);
-
-	cmd->cmd = NETFS_CAPABILITIES;
-	cmd->id = POHMELFS_CRYPTO_CAPABILITIES;
-	cmd->size = size;
-	cmd->start = 0;
-	cmd->ext = 0;
-	cmd->csize = 0;
-
-	netfs_convert_cmd(cmd);
-	netfs_trans_update(cmd, t, size);
-
-	cap->hash_strlen = psb->hash_strlen;
-	if (cap->hash_strlen) {
-		sprintf(str, "%s", psb->hash_string);
-		str += cap->hash_strlen;
-	}
-
-	cap->cipher_strlen = psb->cipher_strlen;
-	cap->cipher_keysize = psb->cipher_keysize;
-	if (cap->cipher_strlen)
-		sprintf(str, "%s", psb->cipher_string);
-
-	netfs_convert_crypto_capabilities(cap);
-
-	psb->flags = ~0;
-	err = netfs_trans_finish(t, psb);
-	if (err)
-		goto err_out_exit;
-
-	err = wait_event_interruptible_timeout(psb->wait, (psb->flags != ~0),
-			psb->wait_on_page_timeout);
-	if (!err)
-		err = -ETIMEDOUT;
-	else if (err > 0)
-		err = -psb->flags;
-
-	if (!err)
-		psb->perform_crypto = 1;
-	psb->flags = 0;
-
-	/*
-	 * At this point NETFS_CAPABILITIES response command
-	 * should setup superblock in a way, which is acceptable
-	 * for both client and server, so if server refuses connection,
-	 * it will send error in transaction response.
-	 */
-
-	if (err)
-		goto err_out_exit;
-
-	return 0;
-
-err_out_exit:
-	return err;
-}
-
-int pohmelfs_crypto_init(struct pohmelfs_sb *psb)
-{
-	int err;
-
-	if (!psb->cipher_string && !psb->hash_string)
-		return 0;
-
-	err = pohmelfs_crypto_init_handshake(psb);
-	if (err)
-		return err;
-
-	err = pohmelfs_sys_crypto_init(psb);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-static int pohmelfs_crypto_thread_get(struct pohmelfs_sb *psb,
-		int (*action)(struct pohmelfs_crypto_thread *t, void *data), void *data)
-{
-	struct pohmelfs_crypto_thread *t = NULL;
-	int err;
-
-	while (!t) {
-		err = wait_event_interruptible_timeout(psb->wait,
-				!list_empty(&psb->crypto_ready_list),
-				psb->wait_on_page_timeout);
-
-		t = NULL;
-		err = 0;
-		mutex_lock(&psb->crypto_thread_lock);
-		if (!list_empty(&psb->crypto_ready_list)) {
-			t = list_entry(psb->crypto_ready_list.prev,
-					struct pohmelfs_crypto_thread,
-					thread_entry);
-
-			list_move_tail(&t->thread_entry,
-					&psb->crypto_active_list);
-
-			action(t, data);
-			wake_up(&t->wait);
-
-		}
-		mutex_unlock(&psb->crypto_thread_lock);
-	}
-
-	return err;
-}
-
-static int pohmelfs_trans_crypt_action(struct pohmelfs_crypto_thread *t, void *data)
-{
-	struct netfs_trans *trans = data;
-
-	netfs_trans_get(trans);
-	t->trans = trans;
-
-	dprintk("%s: t: %p, gen: %u, thread: %p.\n", __func__, trans, trans->gen, t);
-	return 0;
-}
-
-int pohmelfs_trans_crypt(struct netfs_trans *trans, struct pohmelfs_sb *psb)
-{
-	if ((!psb->hash_string && !psb->cipher_string) || !psb->perform_crypto) {
-		netfs_trans_get(trans);
-		return pohmelfs_crypto_finish(trans, psb, 0);
-	}
-
-	return pohmelfs_crypto_thread_get(psb, pohmelfs_trans_crypt_action, trans);
-}
-
-struct pohmelfs_crypto_input_action_data {
-	struct page			*page;
-	struct pohmelfs_crypto_engine	*e;
-	u64				iv;
-	unsigned int			size;
-};
-
-static int pohmelfs_crypt_input_page_action(struct pohmelfs_crypto_thread *t, void *data)
-{
-	struct pohmelfs_crypto_input_action_data *act = data;
-
-	memcpy(t->eng.data, act->e->data, t->psb->crypto_attached_size);
-
-	t->size = act->size;
-	t->eng.iv = act->iv;
-
-	t->page = act->page;
-	return 0;
-}
-
-int pohmelfs_crypto_process_input_page(struct pohmelfs_crypto_engine *e,
-		struct page *page, unsigned int size, u64 iv)
-{
-	struct inode *inode = page->mapping->host;
-	struct pohmelfs_crypto_input_action_data act;
-	int err = -ENOENT;
-
-	act.page = page;
-	act.e = e;
-	act.size = size;
-	act.iv = iv;
-
-	err = pohmelfs_crypto_thread_get(POHMELFS_SB(inode->i_sb),
-			pohmelfs_crypt_input_page_action, &act);
-	if (err)
-		goto err_out_exit;
-
-	return 0;
-
-err_out_exit:
-	SetPageUptodate(page);
-	page_cache_release(page);
-
-	return err;
-}
diff --git a/drivers/staging/pohmelfs/dir.c b/drivers/staging/pohmelfs/dir.c
deleted file mode 100644
index 7598e77..0000000
--- a/drivers/staging/pohmelfs/dir.c
+++ /dev/null
@@ -1,1101 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/jhash.h>
-#include <linux/namei.h>
-#include <linux/slab.h>
-#include <linux/pagemap.h>
-
-#include "netfs.h"
-
-static int pohmelfs_cmp_hash(struct pohmelfs_name *n, u32 hash)
-{
-	if (n->hash > hash)
-		return -1;
-	if (n->hash < hash)
-		return 1;
-
-	return 0;
-}
-
-static struct pohmelfs_name *pohmelfs_search_hash_unprecise(struct pohmelfs_inode *pi, u32 hash)
-{
-	struct rb_node *n = pi->hash_root.rb_node;
-	struct pohmelfs_name *tmp = NULL;
-	int cmp;
-
-	while (n) {
-		tmp = rb_entry(n, struct pohmelfs_name, hash_node);
-
-		cmp = pohmelfs_cmp_hash(tmp, hash);
-		if (cmp < 0)
-			n = n->rb_left;
-		else if (cmp > 0)
-			n = n->rb_right;
-		else
-			break;
-
-	}
-
-	return tmp;
-}
-
-struct pohmelfs_name *pohmelfs_search_hash(struct pohmelfs_inode *pi, u32 hash)
-{
-	struct pohmelfs_name *tmp;
-
-	tmp = pohmelfs_search_hash_unprecise(pi, hash);
-	if (tmp && (tmp->hash == hash))
-		return tmp;
-
-	return NULL;
-}
-
-static void __pohmelfs_name_del(struct pohmelfs_inode *parent, struct pohmelfs_name *node)
-{
-	rb_erase(&node->hash_node, &parent->hash_root);
-}
-
-/*
- * Remove name cache entry from its caches and free it.
- */
-static void pohmelfs_name_free(struct pohmelfs_inode *parent, struct pohmelfs_name *node)
-{
-	__pohmelfs_name_del(parent, node);
-	list_del(&node->sync_create_entry);
-	kfree(node);
-}
-
-static struct pohmelfs_name *pohmelfs_insert_hash(struct pohmelfs_inode *pi,
-		struct pohmelfs_name *new)
-{
-	struct rb_node **n = &pi->hash_root.rb_node, *parent = NULL;
-	struct pohmelfs_name *ret = NULL, *tmp;
-	int cmp;
-
-	while (*n) {
-		parent = *n;
-
-		tmp = rb_entry(parent, struct pohmelfs_name, hash_node);
-
-		cmp = pohmelfs_cmp_hash(tmp, new->hash);
-		if (cmp < 0)
-			n = &parent->rb_left;
-		else if (cmp > 0)
-			n = &parent->rb_right;
-		else {
-			ret = tmp;
-			break;
-		}
-	}
-
-	if (ret) {
-		printk("%s: exist: parent: %llu, ino: %llu, hash: %x, len: %u, data: '%s', "
-					"new: ino: %llu, hash: %x, len: %u, data: '%s'.\n",
-				__func__, pi->ino,
-				ret->ino, ret->hash, ret->len, ret->data,
-				new->ino, new->hash, new->len, new->data);
-		ret->ino = new->ino;
-		return ret;
-	}
-
-	rb_link_node(&new->hash_node, parent, n);
-	rb_insert_color(&new->hash_node, &pi->hash_root);
-
-	return NULL;
-}
-
-/*
- * Free name cache for given inode.
- */
-void pohmelfs_free_names(struct pohmelfs_inode *parent)
-{
-	struct rb_node *rb_node;
-	struct pohmelfs_name *n;
-
-	for (rb_node = rb_first(&parent->hash_root); rb_node;) {
-		n = rb_entry(rb_node, struct pohmelfs_name, hash_node);
-		rb_node = rb_next(rb_node);
-
-		pohmelfs_name_free(parent, n);
-	}
-}
-
-static void pohmelfs_fix_offset(struct pohmelfs_inode *parent, struct pohmelfs_name *node)
-{
-	parent->total_len -= node->len;
-}
-
-/*
- * Free name cache entry helper.
- */
-void pohmelfs_name_del(struct pohmelfs_inode *parent, struct pohmelfs_name *node)
-{
-	pohmelfs_fix_offset(parent, node);
-	pohmelfs_name_free(parent, node);
-}
-
-/*
- * Insert new name cache entry into all hash cache.
- */
-static int pohmelfs_insert_name(struct pohmelfs_inode *parent, struct pohmelfs_name *n)
-{
-	struct pohmelfs_name *name;
-
-	name = pohmelfs_insert_hash(parent, n);
-	if (name)
-		return -EEXIST;
-
-	parent->total_len += n->len;
-	list_add_tail(&n->sync_create_entry, &parent->sync_create_list);
-
-	return 0;
-}
-
-/*
- * Allocate new name cache entry.
- */
-static struct pohmelfs_name *pohmelfs_name_alloc(unsigned int len)
-{
-	struct pohmelfs_name *n;
-
-	n = kzalloc(sizeof(struct pohmelfs_name) + len, GFP_KERNEL);
-	if (!n)
-		return NULL;
-
-	INIT_LIST_HEAD(&n->sync_create_entry);
-
-	n->data = (char *)(n+1);
-
-	return n;
-}
-
-/*
- * Add new name entry into directory's cache.
- */
-static int pohmelfs_add_dir(struct pohmelfs_sb *psb, struct pohmelfs_inode *parent,
-		struct pohmelfs_inode *npi, struct qstr *str, unsigned int mode, int link)
-{
-	int err = -ENOMEM;
-	struct pohmelfs_name *n;
-
-	n = pohmelfs_name_alloc(str->len + 1);
-	if (!n)
-		goto err_out_exit;
-
-	n->ino = npi->ino;
-	n->mode = mode;
-	n->len = str->len;
-	n->hash = str->hash;
-	sprintf(n->data, "%s", str->name);
-
-	mutex_lock(&parent->offset_lock);
-	err = pohmelfs_insert_name(parent, n);
-	mutex_unlock(&parent->offset_lock);
-
-	if (err) {
-		if (err != -EEXIST)
-			goto err_out_free;
-		kfree(n);
-	}
-
-	return 0;
-
-err_out_free:
-	kfree(n);
-err_out_exit:
-	return err;
-}
-
-/*
- * Create new inode for given parameters (name, inode info, parent).
- * This does not create object on the server, it will be synced there during writeback.
- */
-struct pohmelfs_inode *pohmelfs_new_inode(struct pohmelfs_sb *psb,
-		struct pohmelfs_inode *parent, struct qstr *str,
-		struct netfs_inode_info *info, int link)
-{
-	struct inode *new = NULL;
-	struct pohmelfs_inode *npi;
-	int err = -EEXIST;
-
-	dprintk("%s: creating inode: parent: %llu, ino: %llu, str: %p.\n",
-			__func__, (parent) ? parent->ino : 0, info->ino, str);
-
-	err = -ENOMEM;
-	new = iget_locked(psb->sb, info->ino);
-	if (!new)
-		goto err_out_exit;
-
-	npi = POHMELFS_I(new);
-	npi->ino = info->ino;
-	err = 0;
-
-	if (new->i_state & I_NEW) {
-		dprintk("%s: filling VFS inode: %lu/%llu.\n",
-				__func__, new->i_ino, info->ino);
-		pohmelfs_fill_inode(new, info);
-
-		if (S_ISDIR(info->mode)) {
-			struct qstr s;
-
-			s.name = ".";
-			s.len = 1;
-			s.hash = jhash(s.name, s.len, 0);
-
-			err = pohmelfs_add_dir(psb, npi, npi, &s, info->mode, 0);
-			if (err)
-				goto err_out_put;
-
-			s.name = "..";
-			s.len = 2;
-			s.hash = jhash(s.name, s.len, 0);
-
-			err = pohmelfs_add_dir(psb, npi, (parent) ? parent : npi, &s,
-					(parent) ? parent->vfs_inode.i_mode : npi->vfs_inode.i_mode, 0);
-			if (err)
-				goto err_out_put;
-		}
-	}
-
-	if (str) {
-		if (parent) {
-			err = pohmelfs_add_dir(psb, parent, npi, str, info->mode, link);
-
-			dprintk("%s: %s inserted name: '%s', new_offset: %llu, ino: %llu, parent: %llu.\n",
-					__func__, (err) ? "unsuccessfully" : "successfully",
-					str->name, parent->total_len, info->ino, parent->ino);
-
-			if (err && err != -EEXIST)
-				goto err_out_put;
-		}
-	}
-
-	if (new->i_state & I_NEW) {
-		if (parent)
-			mark_inode_dirty(&parent->vfs_inode);
-		mark_inode_dirty(new);
-	}
-
-	set_bit(NETFS_INODE_OWNED, &npi->state);
-	npi->lock_type = POHMELFS_WRITE_LOCK;
-	unlock_new_inode(new);
-
-	return npi;
-
-err_out_put:
-	printk("%s: putting inode: %p, npi: %p, error: %d.\n", __func__, new, npi, err);
-	iput(new);
-err_out_exit:
-	return ERR_PTR(err);
-}
-
-static int pohmelfs_remote_sync_complete(struct page **pages, unsigned int page_num,
-		void *private, int err)
-{
-	struct pohmelfs_inode *pi = private;
-	struct pohmelfs_sb *psb = POHMELFS_SB(pi->vfs_inode.i_sb);
-
-	dprintk("%s: ino: %llu, err: %d.\n", __func__, pi->ino, err);
-
-	if (err)
-		pi->error = err;
-	wake_up(&psb->wait);
-	pohmelfs_put_inode(pi);
-
-	return err;
-}
-
-/*
- * Receive directory content from the server.
- * This should be only done for objects, which were not created locally,
- * and which were not synced previously.
- */
-static int pohmelfs_sync_remote_dir(struct pohmelfs_inode *pi)
-{
-	struct inode *inode = &pi->vfs_inode;
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	long ret = psb->wait_on_page_timeout;
-	int err;
-
-	dprintk("%s: dir: %llu, state: %lx: remote_synced: %d.\n",
-		__func__, pi->ino, pi->state, test_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state));
-
-	if (test_bit(NETFS_INODE_REMOTE_DIR_SYNCED, &pi->state))
-		return 0;
-
-	if (!igrab(inode)) {
-		err = -ENOENT;
-		goto err_out_exit;
-	}
-
-	err = pohmelfs_meta_command(pi, NETFS_READDIR, NETFS_TRANS_SINGLE_DST,
-			pohmelfs_remote_sync_complete, pi, 0);
-	if (err)
-		goto err_out_exit;
-
-	pi->error = 0;
-	ret = wait_event_interruptible_timeout(psb->wait,
-			test_bit(NETFS_INODE_REMOTE_DIR_SYNCED, &pi->state) || pi->error, ret);
-	dprintk("%s: awake dir: %llu, ret: %ld, err: %d.\n", __func__, pi->ino, ret, pi->error);
-	if (ret <= 0) {
-		err = ret;
-		if (!err)
-			err = -ETIMEDOUT;
-		goto err_out_exit;
-	}
-
-	if (pi->error)
-		return pi->error;
-
-	return 0;
-
-err_out_exit:
-	clear_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state);
-
-	return err;
-}
-
-static int pohmelfs_dir_open(struct inode *inode, struct file *file)
-{
-	file->private_data = NULL;
-	return 0;
-}
-
-/*
- * VFS readdir callback. Syncs directory content from server if needed,
- * and provides direntry info to the userspace.
- */
-static int pohmelfs_readdir(struct file *file, void *dirent, filldir_t filldir)
-{
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	struct pohmelfs_name *n;
-	struct rb_node *rb_node;
-	int err = 0, mode;
-	u64 len;
-
-	dprintk("%s: parent: %llu, fpos: %llu, hash: %08lx.\n",
-			__func__, pi->ino, (u64)file->f_pos,
-			(unsigned long)file->private_data);
-#if 0
-	err = pohmelfs_data_lock(pi, 0, ~0, POHMELFS_READ_LOCK);
-	if (err)
-		return err;
-#endif
-	err = pohmelfs_sync_remote_dir(pi);
-	if (err)
-		return err;
-
-	if (file->private_data && (file->private_data == (void *)(unsigned long)file->f_pos))
-		return 0;
-
-	mutex_lock(&pi->offset_lock);
-	n = pohmelfs_search_hash_unprecise(pi, (unsigned long)file->private_data);
-
-	while (n) {
-		mode = (n->mode >> 12) & 15;
-
-		dprintk("%s: offset: %llu, parent ino: %llu, name: '%s', len: %u, ino: %llu, "
-				"mode: %o/%o, fpos: %llu, hash: %08x.\n",
-				__func__, file->f_pos, pi->ino, n->data, n->len,
-				n->ino, n->mode, mode, file->f_pos, n->hash);
-
-		file->private_data = (void *)(unsigned long)n->hash;
-
-		len = n->len;
-		err = filldir(dirent, n->data, n->len, file->f_pos, n->ino, mode);
-
-		if (err < 0) {
-			dprintk("%s: err: %d.\n", __func__, err);
-			err = 0;
-			break;
-		}
-
-		file->f_pos += len;
-
-		rb_node = rb_next(&n->hash_node);
-
-		if (!rb_node || (rb_node == &n->hash_node)) {
-			file->private_data = (void *)(unsigned long)file->f_pos;
-			break;
-		}
-
-		n = rb_entry(rb_node, struct pohmelfs_name, hash_node);
-	}
-	mutex_unlock(&pi->offset_lock);
-
-	return err;
-}
-
-static loff_t pohmelfs_dir_lseek(struct file *file, loff_t offset, int origin)
-{
-	file->f_pos = offset;
-	file->private_data = NULL;
-	return offset;
-}
-
-const struct file_operations pohmelfs_dir_fops = {
-	.open = pohmelfs_dir_open,
-	.read = generic_read_dir,
-	.llseek = pohmelfs_dir_lseek,
-	.readdir = pohmelfs_readdir,
-};
-
-/*
- * Lookup single object on server.
- */
-static int pohmelfs_lookup_single(struct pohmelfs_inode *parent,
-		struct qstr *str, u64 ino)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(parent->vfs_inode.i_sb);
-	long ret = msecs_to_jiffies(5000);
-	int err;
-
-	set_bit(NETFS_COMMAND_PENDING, &parent->state);
-	err = pohmelfs_meta_command_data(parent, parent->ino, NETFS_LOOKUP,
-			(char *)str->name, NETFS_TRANS_SINGLE_DST, NULL, NULL, ino);
-	if (err)
-		goto err_out_exit;
-
-	err = 0;
-	ret = wait_event_interruptible_timeout(psb->wait,
-			!test_bit(NETFS_COMMAND_PENDING, &parent->state), ret);
-	if (ret <= 0) {
-		err = ret;
-		if (!err)
-			err = -ETIMEDOUT;
-	}
-
-	if (err)
-		goto err_out_exit;
-
-	return 0;
-
-err_out_exit:
-	clear_bit(NETFS_COMMAND_PENDING, &parent->state);
-
-	printk("%s: failed: parent: %llu, ino: %llu, name: '%s', err: %d.\n",
-			__func__, parent->ino, ino, str->name, err);
-
-	return err;
-}
-
-/*
- * VFS lookup callback.
- * We first try to get inode number from local name cache, if we have one,
- * then inode can be found in inode cache. If there is no inode or no object in
- * local cache, try to lookup it on server. This only should be done for directories,
- * which were not created locally, otherwise remote server does not know about dir at all,
- * so no need to try to know that.
- */
-struct dentry *pohmelfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
-{
-	struct pohmelfs_inode *parent = POHMELFS_I(dir);
-	struct pohmelfs_name *n;
-	struct inode *inode = NULL;
-	unsigned long ino = 0;
-	int err, lock_type = POHMELFS_READ_LOCK, need_lock = 1;
-	struct qstr str = dentry->d_name;
-
-	if ((nd->intent.open.flags & O_ACCMODE) != O_RDONLY)
-		lock_type = POHMELFS_WRITE_LOCK;
-
-	if (test_bit(NETFS_INODE_OWNED, &parent->state)) {
-		if (lock_type == parent->lock_type)
-			need_lock = 0;
-		if ((lock_type == POHMELFS_READ_LOCK) && (parent->lock_type == POHMELFS_WRITE_LOCK))
-			need_lock = 0;
-	}
-
-	if ((lock_type == POHMELFS_READ_LOCK) && !test_bit(NETFS_INODE_REMOTE_DIR_SYNCED, &parent->state))
-		need_lock = 1;
-
-	str.hash = jhash(dentry->d_name.name, dentry->d_name.len, 0);
-
-	mutex_lock(&parent->offset_lock);
-	n = pohmelfs_search_hash(parent, str.hash);
-	if (n)
-		ino = n->ino;
-	mutex_unlock(&parent->offset_lock);
-
-	dprintk("%s: start ino: %lu, inode: %p, name: '%s', hash: %x, parent_state: %lx, need_lock: %d.\n",
-			__func__, ino, inode, str.name, str.hash, parent->state, need_lock);
-
-	if (ino) {
-		inode = ilookup(dir->i_sb, ino);
-		if (inode)
-			goto out;
-	}
-
-	dprintk("%s: no inode dir: %p, dir_ino: %llu, name: '%s', len: %u, dir_state: %lx, ino: %lu.\n",
-			__func__, dir, parent->ino,
-			str.name, str.len, parent->state, ino);
-
-	if (!ino) {
-		if (!need_lock)
-			goto out;
-	}
-
-	err = pohmelfs_data_lock(parent, 0, ~0, lock_type);
-	if (err)
-		goto out;
-
-	err = pohmelfs_lookup_single(parent, &str, ino);
-	if (err)
-		goto out;
-
-	if (!ino) {
-		mutex_lock(&parent->offset_lock);
-		n = pohmelfs_search_hash(parent, str.hash);
-		if (n)
-			ino = n->ino;
-		mutex_unlock(&parent->offset_lock);
-	}
-
-	if (ino) {
-		inode = ilookup(dir->i_sb, ino);
-		dprintk("%s: second lookup ino: %lu, inode: %p, name: '%s', hash: %x.\n",
-				__func__, ino, inode, str.name, str.hash);
-		if (!inode) {
-			dprintk("%s: No inode for ino: %lu, name: '%s', hash: %x.\n",
-				__func__, ino, str.name, str.hash);
-			/* return NULL; */
-			return ERR_PTR(-EACCES);
-		}
-	} else {
-		printk("%s: No inode number : name: '%s', hash: %x.\n",
-			__func__, str.name, str.hash);
-	}
-out:
-	return d_splice_alias(inode, dentry);
-}
-
-/*
- * Create new object in local cache. Object will be synced to server
- * during writeback for given inode.
- */
-struct pohmelfs_inode *pohmelfs_create_entry_local(struct pohmelfs_sb *psb,
-	struct pohmelfs_inode *parent, struct qstr *str, u64 start, int mode)
-{
-	struct pohmelfs_inode *npi;
-	int err = -ENOMEM;
-	struct netfs_inode_info info;
-
-	dprintk("%s: name: '%s', mode: %o, start: %llu.\n",
-			__func__, str->name, mode, start);
-
-	info.mode = mode;
-	info.ino = start;
-
-	if (!start)
-		info.ino = pohmelfs_new_ino(psb);
-
-	info.nlink = S_ISDIR(mode) ? 2 : 1;
-	info.uid = current_fsuid();
-	info.gid = current_fsgid();
-	info.size = 0;
-	info.blocksize = 512;
-	info.blocks = 0;
-	info.rdev = 0;
-	info.version = 0;
-
-	npi = pohmelfs_new_inode(psb, parent, str, &info, !!start);
-	if (IS_ERR(npi)) {
-		err = PTR_ERR(npi);
-		goto err_out_unlock;
-	}
-
-	return npi;
-
-err_out_unlock:
-	dprintk("%s: err: %d.\n", __func__, err);
-	return ERR_PTR(err);
-}
-
-/*
- * Create local object and bind it to dentry.
- */
-static int pohmelfs_create_entry(struct inode *dir, struct dentry *dentry, u64 start, int mode)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(dir->i_sb);
-	struct pohmelfs_inode *npi, *parent;
-	struct qstr str = dentry->d_name;
-	int err;
-
-	parent = POHMELFS_I(dir);
-
-	err = pohmelfs_data_lock(parent, 0, ~0, POHMELFS_WRITE_LOCK);
-	if (err)
-		return err;
-
-	str.hash = jhash(dentry->d_name.name, dentry->d_name.len, 0);
-
-	npi = pohmelfs_create_entry_local(psb, parent, &str, start, mode);
-	if (IS_ERR(npi))
-		return PTR_ERR(npi);
-
-	d_instantiate(dentry, &npi->vfs_inode);
-
-	dprintk("%s: parent: %llu, inode: %llu, name: '%s', parent_nlink: %d, nlink: %d.\n",
-			__func__, parent->ino, npi->ino, dentry->d_name.name,
-			(signed)dir->i_nlink, (signed)npi->vfs_inode.i_nlink);
-
-	return 0;
-}
-
-/*
- * VFS create and mkdir callbacks.
- */
-static int pohmelfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
-{
-	return pohmelfs_create_entry(dir, dentry, 0, mode);
-}
-
-static int pohmelfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
-{
-	int err;
-
-	inode_inc_link_count(dir);
-	err = pohmelfs_create_entry(dir, dentry, 0, mode | S_IFDIR);
-	if (err)
-		inode_dec_link_count(dir);
-
-	return err;
-}
-
-static int pohmelfs_remove_entry(struct inode *dir, struct dentry *dentry)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(dir->i_sb);
-	struct inode *inode = dentry->d_inode;
-	struct pohmelfs_inode *parent = POHMELFS_I(dir), *pi = POHMELFS_I(inode);
-	struct pohmelfs_name *n;
-	int err = -ENOENT;
-	struct qstr str = dentry->d_name;
-
-	err = pohmelfs_data_lock(parent, 0, ~0, POHMELFS_WRITE_LOCK);
-	if (err)
-		return err;
-
-	str.hash = jhash(dentry->d_name.name, dentry->d_name.len, 0);
-
-	dprintk("%s: dir_ino: %llu, inode: %llu, name: '%s', nlink: %d.\n",
-			__func__, parent->ino, pi->ino,
-			str.name, (signed)inode->i_nlink);
-
-	BUG_ON(!inode);
-
-	mutex_lock(&parent->offset_lock);
-	n = pohmelfs_search_hash(parent, str.hash);
-	if (n) {
-		pohmelfs_fix_offset(parent, n);
-		if (test_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state))
-			pohmelfs_remove_child(pi, n);
-
-		pohmelfs_name_free(parent, n);
-		err = 0;
-	}
-	mutex_unlock(&parent->offset_lock);
-
-	if (!err) {
-		psb->avail_size += inode->i_size;
-
-		pohmelfs_inode_del_inode(psb, pi);
-
-		mark_inode_dirty(dir);
-
-		inode->i_ctime = dir->i_ctime;
-		if (inode->i_nlink)
-			inode_dec_link_count(inode);
-	}
-
-	return err;
-}
-
-/*
- * Unlink and rmdir VFS callbacks.
- */
-static int pohmelfs_unlink(struct inode *dir, struct dentry *dentry)
-{
-	return pohmelfs_remove_entry(dir, dentry);
-}
-
-static int pohmelfs_rmdir(struct inode *dir, struct dentry *dentry)
-{
-	int err;
-	struct inode *inode = dentry->d_inode;
-
-	dprintk("%s: parent: %llu, inode: %llu, name: '%s', parent_nlink: %d, nlink: %d.\n",
-			__func__, POHMELFS_I(dir)->ino, POHMELFS_I(inode)->ino,
-			dentry->d_name.name, (signed)dir->i_nlink, (signed)inode->i_nlink);
-
-	err = pohmelfs_remove_entry(dir, dentry);
-	if (!err) {
-		inode_dec_link_count(dir);
-		inode_dec_link_count(inode);
-	}
-
-	return err;
-}
-
-/*
- * Link creation is synchronous.
- * I'm lazy.
- * Earth is somewhat round.
- */
-static int pohmelfs_create_link(struct pohmelfs_inode *parent, struct qstr *obj,
-		struct pohmelfs_inode *target, struct qstr *tstr)
-{
-	struct super_block *sb = parent->vfs_inode.i_sb;
-	struct pohmelfs_sb *psb = POHMELFS_SB(sb);
-	struct netfs_cmd *cmd;
-	struct netfs_trans *t;
-	void *data;
-	int err, parent_len, target_len = 0, cur_len, path_size = 0;
-
-	err = pohmelfs_data_lock(parent, 0, ~0, POHMELFS_WRITE_LOCK);
-	if (err)
-		return err;
-
-	err = sb->s_op->write_inode(&parent->vfs_inode, 0);
-	if (err)
-		goto err_out_exit;
-
-	if (tstr)
-		target_len = tstr->len;
-
-	parent_len = pohmelfs_path_length(parent);
-	if (target)
-		target_len += pohmelfs_path_length(target);
-
-	if (parent_len < 0) {
-		err = parent_len;
-		goto err_out_exit;
-	}
-
-	if (target_len < 0) {
-		err = target_len;
-		goto err_out_exit;
-	}
-
-	t = netfs_trans_alloc(psb, parent_len + target_len + obj->len + 2, 0, 0);
-	if (!t) {
-		err = -ENOMEM;
-		goto err_out_exit;
-	}
-	cur_len = netfs_trans_cur_len(t);
-
-	cmd = netfs_trans_current(t);
-	if (IS_ERR(cmd)) {
-		err = PTR_ERR(cmd);
-		goto err_out_free;
-	}
-
-	data = (void *)(cmd + 1);
-	cur_len -= sizeof(struct netfs_cmd);
-
-	err = pohmelfs_construct_path_string(parent, data, parent_len);
-	if (err > 0) {
-		/* Do not place null-byte before the slash */
-		path_size = err - 1;
-		cur_len -= path_size;
-
-		err = snprintf(data + path_size, cur_len, "/%s|", obj->name);
-
-		path_size += err;
-		cur_len -= err;
-
-		cmd->ext = path_size - 1; /* No | symbol */
-
-		if (target) {
-			err = pohmelfs_construct_path_string(target, data + path_size, target_len);
-			if (err > 0) {
-				path_size += err;
-				cur_len -= err;
-			}
-		}
-	}
-
-	if (err < 0)
-		goto err_out_free;
-
-	cmd->start = 0;
-
-	if (!target && tstr) {
-		if (tstr->len > cur_len - 1) {
-			err = -ENAMETOOLONG;
-			goto err_out_free;
-		}
-
-		err = snprintf(data + path_size, cur_len, "%s", tstr->name) + 1; /* 0-byte */
-		path_size += err;
-		cur_len -= err;
-		cmd->start = 1;
-	}
-
-	dprintk("%s: parent: %llu, obj: '%s', target_inode: %llu, target_str: '%s', full: '%s'.\n",
-			__func__, parent->ino, obj->name, (target) ? target->ino : 0, (tstr) ? tstr->name : NULL,
-			(char *)data);
-
-	cmd->cmd = NETFS_LINK;
-	cmd->size = path_size;
-	cmd->id = parent->ino;
-
-	netfs_convert_cmd(cmd);
-
-	netfs_trans_update(cmd, t, path_size);
-
-	err = netfs_trans_finish(t, psb);
-	if (err)
-		goto err_out_exit;
-
-	return 0;
-
-err_out_free:
-	t->result = err;
-	netfs_trans_put(t);
-err_out_exit:
-	return err;
-}
-
-/*
- *  VFS hard and soft link callbacks.
- */
-static int pohmelfs_link(struct dentry *old_dentry, struct inode *dir,
-	struct dentry *dentry)
-{
-	struct inode *inode = old_dentry->d_inode;
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	int err;
-	struct qstr str = dentry->d_name;
-
-	str.hash = jhash(dentry->d_name.name, dentry->d_name.len, 0);
-
-	err = inode->i_sb->s_op->write_inode(inode, 0);
-	if (err)
-		return err;
-
-	err = pohmelfs_create_link(POHMELFS_I(dir), &str, pi, NULL);
-	if (err)
-		return err;
-
-	return pohmelfs_create_entry(dir, dentry, pi->ino, inode->i_mode);
-}
-
-static int pohmelfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
-{
-	struct qstr sym_str;
-	struct qstr str = dentry->d_name;
-	struct inode *inode;
-	int err;
-
-	str.hash = jhash(dentry->d_name.name, dentry->d_name.len, 0);
-
-	sym_str.name = symname;
-	sym_str.len = strlen(symname);
-
-	err = pohmelfs_create_link(POHMELFS_I(dir), &str, NULL, &sym_str);
-	if (err)
-		goto err_out_exit;
-
-	err = pohmelfs_create_entry(dir, dentry, 0, S_IFLNK | S_IRWXU | S_IRWXG | S_IRWXO);
-	if (err)
-		goto err_out_exit;
-
-	inode = dentry->d_inode;
-
-	err = page_symlink(inode, symname, sym_str.len + 1);
-	if (err)
-		goto err_out_put;
-
-	return 0;
-
-err_out_put:
-	iput(inode);
-err_out_exit:
-	return err;
-}
-
-static int pohmelfs_send_rename(struct pohmelfs_inode *pi, struct pohmelfs_inode *parent,
-		struct qstr *str)
-{
-	int path_len, err, total_len = 0, inode_len, parent_len;
-	char *path;
-	struct netfs_trans *t;
-	struct netfs_cmd *cmd;
-	struct pohmelfs_sb *psb = POHMELFS_SB(pi->vfs_inode.i_sb);
-
-	parent_len = pohmelfs_path_length(parent);
-	inode_len = pohmelfs_path_length(pi);
-
-	if (parent_len < 0 || inode_len < 0)
-		return -EINVAL;
-
-	path_len = parent_len + inode_len + str->len + 3;
-
-	t = netfs_trans_alloc(psb, path_len, 0, 0);
-	if (!t)
-		return -ENOMEM;
-
-	cmd = netfs_trans_current(t);
-	path = (char *)(cmd + 1);
-
-	err = pohmelfs_construct_path_string(pi, path, inode_len);
-	if (err < 0)
-		goto err_out_unlock;
-
-	cmd->ext = err;
-
-	path += err;
-	total_len += err;
-	path_len -= err;
-
-	*path = '|';
-	path++;
-	total_len++;
-	path_len--;
-
-	err = pohmelfs_construct_path_string(parent, path, parent_len);
-	if (err < 0)
-		goto err_out_unlock;
-
-	/*
-	 * Do not place a null-byte before the final slash and the name.
-	 */
-	err--;
-	path += err;
-	total_len += err;
-	path_len -= err;
-
-	err = snprintf(path, path_len - 1, "/%s", str->name);
-
-	total_len += err + 1; /* 0 symbol */
-	path_len -= err + 1;
-
-	cmd->cmd = NETFS_RENAME;
-	cmd->id = pi->ino;
-	cmd->start = parent->ino;
-	cmd->size = total_len;
-
-	netfs_convert_cmd(cmd);
-
-	netfs_trans_update(cmd, t, total_len);
-
-	return netfs_trans_finish(t, psb);
-
-err_out_unlock:
-	netfs_trans_free(t);
-	return err;
-}
-
-static int pohmelfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-			struct inode *new_dir, struct dentry *new_dentry)
-{
-	struct inode *inode = old_dentry->d_inode;
-	struct pohmelfs_inode *old_parent, *pi, *new_parent;
-	struct qstr str = new_dentry->d_name;
-	struct pohmelfs_name *n;
-	unsigned int old_hash;
-	int err = -ENOENT;
-
-	pi = POHMELFS_I(inode);
-	old_parent = POHMELFS_I(old_dir);
-
-	if (new_dir)
-		new_dir->i_sb->s_op->write_inode(new_dir, 0);
-
-	old_hash = jhash(old_dentry->d_name.name, old_dentry->d_name.len, 0);
-	str.hash = jhash(new_dentry->d_name.name, new_dentry->d_name.len, 0);
-
-	str.len = new_dentry->d_name.len;
-	str.name = new_dentry->d_name.name;
-	str.hash = jhash(new_dentry->d_name.name, new_dentry->d_name.len, 0);
-
-	if (new_dir) {
-		new_parent = POHMELFS_I(new_dir);
-		err = -ENOTEMPTY;
-
-		if (S_ISDIR(inode->i_mode) &&
-				new_parent->total_len <= 3)
-			goto err_out_exit;
-	} else {
-		new_parent = old_parent;
-	}
-
-	dprintk("%s: ino: %llu, parent: %llu, name: '%s' -> parent: %llu, name: '%s', i_size: %llu.\n",
-			__func__, pi->ino, old_parent->ino, old_dentry->d_name.name,
-			new_parent->ino, new_dentry->d_name.name, inode->i_size);
-
-	if (test_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state) &&
-			test_bit(NETFS_INODE_OWNED, &pi->state)) {
-		err = pohmelfs_send_rename(pi, new_parent, &str);
-		if (err)
-			goto err_out_exit;
-	}
-
-	n = pohmelfs_name_alloc(str.len + 1);
-	if (!n)
-		goto err_out_exit;
-
-	mutex_lock(&new_parent->offset_lock);
-	n->ino = pi->ino;
-	n->mode = inode->i_mode;
-	n->len = str.len;
-	n->hash = str.hash;
-	sprintf(n->data, "%s", str.name);
-
-	err = pohmelfs_insert_name(new_parent, n);
-	mutex_unlock(&new_parent->offset_lock);
-
-	if (err)
-		goto err_out_exit;
-
-	mutex_lock(&old_parent->offset_lock);
-	n = pohmelfs_search_hash(old_parent, old_hash);
-	if (n)
-		pohmelfs_name_del(old_parent, n);
-	mutex_unlock(&old_parent->offset_lock);
-
-	mark_inode_dirty(inode);
-	mark_inode_dirty(&new_parent->vfs_inode);
-
-	WARN_ON_ONCE(list_empty(&inode->i_dentry));
-
-	return 0;
-
-err_out_exit:
-
-	clear_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state);
-
-	return err;
-}
-
-/*
- * POHMELFS directory inode operations.
- */
-const struct inode_operations pohmelfs_dir_inode_ops = {
-	.link		= pohmelfs_link,
-	.symlink	= pohmelfs_symlink,
-	.unlink		= pohmelfs_unlink,
-	.mkdir		= pohmelfs_mkdir,
-	.rmdir		= pohmelfs_rmdir,
-	.create		= pohmelfs_create,
-	.lookup 	= pohmelfs_lookup,
-	.setattr	= pohmelfs_setattr,
-	.rename		= pohmelfs_rename,
-};
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
deleted file mode 100644
index f3c6060..0000000
--- a/drivers/staging/pohmelfs/inode.c
+++ /dev/null
@@ -1,2056 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/backing-dev.h>
-#include <linux/crypto.h>
-#include <linux/fs.h>
-#include <linux/jhash.h>
-#include <linux/hash.h>
-#include <linux/ktime.h>
-#include <linux/mm.h>
-#include <linux/mount.h>
-#include <linux/pagemap.h>
-#include <linux/pagevec.h>
-#include <linux/parser.h>
-#include <linux/swap.h>
-#include <linux/slab.h>
-#include <linux/statfs.h>
-#include <linux/writeback.h>
-#include <linux/prefetch.h>
-
-#include "netfs.h"
-
-#define POHMELFS_MAGIC_NUM	0x504f482e
-
-static struct kmem_cache *pohmelfs_inode_cache;
-static atomic_t psb_bdi_num = ATOMIC_INIT(0);
-
-/*
- * Removes inode from all trees, drops local name cache and removes all queued
- * requests for object removal.
- */
-void pohmelfs_inode_del_inode(struct pohmelfs_sb *psb, struct pohmelfs_inode *pi)
-{
-	mutex_lock(&pi->offset_lock);
-	pohmelfs_free_names(pi);
-	mutex_unlock(&pi->offset_lock);
-
-	dprintk("%s: deleted stuff in ino: %llu.\n", __func__, pi->ino);
-}
-
-/*
- * Sync inode to server.
- * Returns zero in success and negative error value otherwise.
- * It will gather path to root directory into structures containing
- * creation mode, permissions and names, so that the whole path
- * to given inode could be created using only single network command.
- */
-int pohmelfs_write_inode_create(struct inode *inode, struct netfs_trans *trans)
-{
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	int err = -ENOMEM, size;
-	struct netfs_cmd *cmd;
-	void *data;
-	int cur_len = netfs_trans_cur_len(trans);
-
-	if (unlikely(cur_len < 0))
-		return -ETOOSMALL;
-
-	cmd = netfs_trans_current(trans);
-	cur_len -= sizeof(struct netfs_cmd);
-
-	data = (void *)(cmd + 1);
-
-	err = pohmelfs_construct_path_string(pi, data, cur_len);
-	if (err < 0)
-		goto err_out_exit;
-
-	size = err;
-
-	cmd->start = i_size_read(inode);
-	cmd->cmd = NETFS_CREATE;
-	cmd->size = size;
-	cmd->id = pi->ino;
-	cmd->ext = inode->i_mode;
-
-	netfs_convert_cmd(cmd);
-
-	netfs_trans_update(cmd, trans, size);
-
-	return 0;
-
-err_out_exit:
-	printk("%s: completed ino: %llu, err: %d.\n", __func__, pi->ino, err);
-	return err;
-}
-
-static int pohmelfs_write_trans_complete(struct page **pages, unsigned int page_num,
-		void *private, int err)
-{
-	unsigned i;
-
-	dprintk("%s: pages: %lu-%lu, page_num: %u, err: %d.\n",
-			__func__, pages[0]->index, pages[page_num-1]->index,
-			page_num, err);
-
-	for (i = 0; i < page_num; i++) {
-		struct page *page = pages[i];
-
-		if (!page)
-			continue;
-
-		end_page_writeback(page);
-
-		if (err < 0) {
-			SetPageError(page);
-			set_page_dirty(page);
-		}
-
-		unlock_page(page);
-		page_cache_release(page);
-
-		/* dprintk("%s: %3u/%u: page: %p.\n", __func__, i, page_num, page); */
-	}
-	return err;
-}
-
-static int pohmelfs_inode_has_dirty_pages(struct address_space *mapping, pgoff_t index)
-{
-	int ret;
-	struct page *page;
-
-	rcu_read_lock();
-	ret = radix_tree_gang_lookup_tag(&mapping->page_tree,
-				(void **)&page, index, 1, PAGECACHE_TAG_DIRTY);
-	rcu_read_unlock();
-	return ret;
-}
-
-static int pohmelfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
-{
-	struct inode *inode = mapping->host;
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	int err = 0;
-	int done = 0;
-	int nr_pages;
-	pgoff_t index;
-	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
-	int range_whole = 0;
-
-	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
-	} else {
-		index = wbc->range_start >> PAGE_CACHE_SHIFT;
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
-		scanned = 1;
-	}
-retry:
-	while (!done && (index <= end)) {
-		unsigned int i = min(end - index, (pgoff_t)psb->trans_max_pages);
-		int path_len;
-		struct netfs_trans *trans;
-
-		err = pohmelfs_inode_has_dirty_pages(mapping, index);
-		if (!err)
-			break;
-
-		err = pohmelfs_path_length(pi);
-		if (err < 0)
-			break;
-
-		path_len = err;
-
-		if (path_len <= 2) {
-			err = -ENOENT;
-			break;
-		}
-
-		trans = netfs_trans_alloc(psb, path_len, 0, i);
-		if (!trans) {
-			err = -ENOMEM;
-			break;
-		}
-		trans->complete = &pohmelfs_write_trans_complete;
-
-		trans->page_num = nr_pages = find_get_pages_tag(mapping, &index,
-				PAGECACHE_TAG_DIRTY, trans->page_num,
-				trans->pages);
-
-		dprintk("%s: t: %p, nr_pages: %u, end: %lu, index: %lu, max: %u.\n",
-				__func__, trans, nr_pages, end, index, trans->page_num);
-
-		if (!nr_pages)
-			goto err_out_reset;
-
-		err = pohmelfs_write_inode_create(inode, trans);
-		if (err)
-			goto err_out_reset;
-
-		err = 0;
-		scanned = 1;
-
-		for (i = 0; i < trans->page_num; i++) {
-			struct page *page = trans->pages[i];
-
-			lock_page(page);
-
-			if (unlikely(page->mapping != mapping))
-				goto out_continue;
-
-			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
-				goto out_continue;
-			}
-
-			if (wbc->sync_mode != WB_SYNC_NONE)
-				wait_on_page_writeback(page);
-
-			if (PageWriteback(page) ||
-			    !clear_page_dirty_for_io(page)) {
-				dprintk("%s: not clear for io page: %p, writeback: %d.\n",
-						__func__, page, PageWriteback(page));
-				goto out_continue;
-			}
-
-			set_page_writeback(page);
-
-			trans->attached_size += page_private(page);
-			trans->attached_pages++;
-#if 0
-			dprintk("%s: %u/%u added trans: %p, gen: %u, page: %p, [High: %d], size: %lu, idx: %lu.\n",
-					__func__, i, trans->page_num, trans, trans->gen, page,
-					!!PageHighMem(page), page_private(page), page->index);
-#endif
-			wbc->nr_to_write--;
-
-			if (wbc->nr_to_write <= 0)
-				done = 1;
-
-			continue;
-out_continue:
-			unlock_page(page);
-			trans->pages[i] = NULL;
-		}
-
-		err = netfs_trans_finish(trans, psb);
-		if (err)
-			break;
-
-		continue;
-
-err_out_reset:
-		trans->result = err;
-		netfs_trans_reset(trans);
-		netfs_trans_put(trans);
-		break;
-	}
-
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
-		index = 0;
-		goto retry;
-	}
-
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = index;
-
-	return err;
-}
-
-/*
- * Inode writeback creation completion callback.
- * Only invoked for just created inodes, which do not have pages attached,
- * like dirs and empty files.
- */
-static int pohmelfs_write_inode_complete(struct page **pages, unsigned int page_num,
-		void *private, int err)
-{
-	struct inode *inode = private;
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-
-	if (inode) {
-		if (err) {
-			mark_inode_dirty(inode);
-			clear_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state);
-		} else {
-			set_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state);
-		}
-
-		pohmelfs_put_inode(pi);
-	}
-
-	return err;
-}
-
-int pohmelfs_write_create_inode(struct pohmelfs_inode *pi)
-{
-	struct netfs_trans *t;
-	struct inode *inode = &pi->vfs_inode;
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	int err;
-
-	if (test_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state))
-		return 0;
-
-	dprintk("%s: started ino: %llu.\n", __func__, pi->ino);
-
-	err = pohmelfs_path_length(pi);
-	if (err < 0)
-		goto err_out_exit;
-
-	t = netfs_trans_alloc(psb, err + 1, 0, 0);
-	if (!t) {
-		err = -ENOMEM;
-		goto err_out_exit;
-	}
-	t->complete = pohmelfs_write_inode_complete;
-	t->private = igrab(inode);
-	if (!t->private) {
-		err = -ENOENT;
-		goto err_out_put;
-	}
-
-	err = pohmelfs_write_inode_create(inode, t);
-	if (err)
-		goto err_out_put;
-
-	netfs_trans_finish(t, POHMELFS_SB(inode->i_sb));
-
-	return 0;
-
-err_out_put:
-	t->result = err;
-	netfs_trans_put(t);
-err_out_exit:
-	return err;
-}
-
-/*
- * Sync all not-yet-created children in given directory to the server.
- */
-static int pohmelfs_write_inode_create_children(struct inode *inode)
-{
-	struct pohmelfs_inode *parent = POHMELFS_I(inode);
-	struct super_block *sb = inode->i_sb;
-	struct pohmelfs_name *n;
-
-	while (!list_empty(&parent->sync_create_list)) {
-		n = NULL;
-		mutex_lock(&parent->offset_lock);
-		if (!list_empty(&parent->sync_create_list)) {
-			n = list_first_entry(&parent->sync_create_list,
-				struct pohmelfs_name, sync_create_entry);
-			list_del_init(&n->sync_create_entry);
-		}
-		mutex_unlock(&parent->offset_lock);
-
-		if (!n)
-			break;
-
-		inode = ilookup(sb, n->ino);
-
-		dprintk("%s: parent: %llu, ino: %llu, inode: %p.\n",
-				__func__, parent->ino, n->ino, inode);
-
-		if (inode && (inode->i_state & I_DIRTY)) {
-			struct pohmelfs_inode *pi = POHMELFS_I(inode);
-			pohmelfs_write_create_inode(pi);
-			/* pohmelfs_meta_command(pi, NETFS_INODE_INFO, 0, NULL, NULL, 0); */
-			iput(inode);
-		}
-	}
-
-	return 0;
-}
-
-/*
- * Removes given child from given inode on server.
- */
-int pohmelfs_remove_child(struct pohmelfs_inode *pi, struct pohmelfs_name *n)
-{
-	return pohmelfs_meta_command_data(pi, pi->ino, NETFS_REMOVE, NULL, 0, NULL, NULL, 0);
-}
-
-/*
- * Writeback for given inode.
- */
-static int pohmelfs_write_inode(struct inode *inode,
-				struct writeback_control *wbc)
-{
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-
-	pohmelfs_write_create_inode(pi);
-	pohmelfs_write_inode_create_children(inode);
-
-	return 0;
-}
-
-/*
- * It is not exported, sorry...
- */
-static inline wait_queue_head_t *page_waitqueue(struct page *page)
-{
-	const struct zone *zone = page_zone(page);
-
-	return &zone->wait_table[hash_ptr(page, zone->wait_table_bits)];
-}
-
-static int pohmelfs_wait_on_page_locked(struct page *page)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(page->mapping->host->i_sb);
-	long ret = psb->wait_on_page_timeout;
-	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
-	int err = 0;
-
-	if (!PageLocked(page))
-		return 0;
-
-	for (;;) {
-		prepare_to_wait(page_waitqueue(page),
-				&wait.wait, TASK_INTERRUPTIBLE);
-
-		dprintk("%s: page: %p, locked: %d, uptodate: %d, error: %d, flags: %lx.\n",
-				__func__, page, PageLocked(page), PageUptodate(page),
-				PageError(page), page->flags);
-
-		if (!PageLocked(page))
-			break;
-
-		if (!signal_pending(current)) {
-			ret = schedule_timeout(ret);
-			if (!ret)
-				break;
-			continue;
-		}
-		ret = -ERESTARTSYS;
-		break;
-	}
-	finish_wait(page_waitqueue(page), &wait.wait);
-
-	if (!ret)
-		err = -ETIMEDOUT;
-
-
-	if (!err)
-		SetPageUptodate(page);
-
-	if (err)
-		printk("%s: page: %p, uptodate: %d, locked: %d, err: %d.\n",
-			__func__, page, PageUptodate(page), PageLocked(page), err);
-
-	return err;
-}
-
-static int pohmelfs_read_page_complete(struct page **pages, unsigned int page_num,
-		void *private, int err)
-{
-	struct page *page = private;
-
-	if (PageChecked(page))
-		return err;
-
-	if (err < 0) {
-		dprintk("%s: page: %p, err: %d.\n", __func__, page, err);
-		SetPageError(page);
-	}
-
-	unlock_page(page);
-
-	return err;
-}
-
-/*
- * Read a page from remote server.
- * Function will wait until page is unlocked.
- */
-static int pohmelfs_readpage(struct file *file, struct page *page)
-{
-	struct inode *inode = page->mapping->host;
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	struct netfs_trans *t;
-	struct netfs_cmd *cmd;
-	int err, path_len;
-	void *data;
-	u64 isize;
-
-	err = pohmelfs_data_lock(pi, page->index << PAGE_CACHE_SHIFT,
-			PAGE_SIZE, POHMELFS_READ_LOCK);
-	if (err)
-		goto err_out_exit;
-
-	isize = i_size_read(inode);
-	if (isize <= page->index << PAGE_CACHE_SHIFT) {
-		SetPageUptodate(page);
-		unlock_page(page);
-		return 0;
-	}
-
-	path_len = pohmelfs_path_length(pi);
-	if (path_len < 0) {
-		err = path_len;
-		goto err_out_exit;
-	}
-
-	t = netfs_trans_alloc(psb, path_len, NETFS_TRANS_SINGLE_DST, 0);
-	if (!t) {
-		err = -ENOMEM;
-		goto err_out_exit;
-	}
-
-	t->complete = pohmelfs_read_page_complete;
-	t->private = page;
-
-	cmd = netfs_trans_current(t);
-	data = (void *)(cmd + 1);
-
-	err = pohmelfs_construct_path_string(pi, data, path_len);
-	if (err < 0)
-		goto err_out_free;
-
-	path_len = err;
-
-	cmd->id = pi->ino;
-	cmd->start = page->index;
-	cmd->start <<= PAGE_CACHE_SHIFT;
-	cmd->size = PAGE_CACHE_SIZE + path_len;
-	cmd->cmd = NETFS_READ_PAGE;
-	cmd->ext = path_len;
-
-	dprintk("%s: path: '%s', page: %p, ino: %llu, start: %llu, size: %lu.\n",
-			__func__, (char *)data, page, pi->ino, cmd->start, PAGE_CACHE_SIZE);
-
-	netfs_convert_cmd(cmd);
-	netfs_trans_update(cmd, t, path_len);
-
-	err = netfs_trans_finish(t, psb);
-	if (err)
-		goto err_out_return;
-
-	return pohmelfs_wait_on_page_locked(page);
-
-err_out_free:
-	t->result = err;
-	netfs_trans_put(t);
-err_out_exit:
-	SetPageError(page);
-	if (PageLocked(page))
-		unlock_page(page);
-err_out_return:
-	printk("%s: page: %p, start: %lu, size: %lu, err: %d.\n",
-		__func__, page, page->index << PAGE_CACHE_SHIFT, PAGE_CACHE_SIZE, err);
-
-	return err;
-}
-
-/*
- * Write begin/end magic.
- * Allocates a page and writes inode if it was not synced to server before.
- */
-static int pohmelfs_write_begin(struct file *file, struct address_space *mapping,
-		loff_t pos, unsigned len, unsigned flags,
-		struct page **pagep, void **fsdata)
-{
-	struct inode *inode = mapping->host;
-	struct page *page;
-	pgoff_t index;
-	unsigned start, end;
-	int err;
-
-	*pagep = NULL;
-
-	index = pos >> PAGE_CACHE_SHIFT;
-	start = pos & (PAGE_CACHE_SIZE - 1);
-	end = start + len;
-
-	page = grab_cache_page(mapping, index);
-#if 0
-	dprintk("%s: page: %p pos: %llu, len: %u, index: %lu, start: %u, end: %u, uptodate: %d.\n",
-			__func__, page,	pos, len, index, start, end, PageUptodate(page));
-#endif
-	if (!page) {
-		err = -ENOMEM;
-		goto err_out_exit;
-	}
-
-	while (!PageUptodate(page)) {
-		if (start && test_bit(NETFS_INODE_REMOTE_SYNCED, &POHMELFS_I(inode)->state)) {
-			err = pohmelfs_readpage(file, page);
-			if (err)
-				goto err_out_exit;
-
-			lock_page(page);
-			continue;
-		}
-
-		if (len != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
-
-			memset(kaddr + start, 0, PAGE_CACHE_SIZE - start);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
-		SetPageUptodate(page);
-	}
-
-	set_page_private(page, end);
-
-	*pagep = page;
-
-	return 0;
-
-err_out_exit:
-	page_cache_release(page);
-	*pagep = NULL;
-
-	return err;
-}
-
-static int pohmelfs_write_end(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata)
-{
-	struct inode *inode = mapping->host;
-
-	if (copied != len) {
-		unsigned from = pos & (PAGE_CACHE_SIZE - 1);
-		void *kaddr = kmap_atomic(page, KM_USER0);
-
-		memset(kaddr + from + copied, 0, len - copied);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
-	}
-
-	SetPageUptodate(page);
-	set_page_dirty(page);
-#if 0
-	dprintk("%s: page: %p [U: %d, D: %d, L: %d], pos: %llu, len: %u, copied: %u.\n",
-			__func__, page,
-			PageUptodate(page), PageDirty(page), PageLocked(page),
-			pos, len, copied);
-#endif
-	flush_dcache_page(page);
-
-	unlock_page(page);
-	page_cache_release(page);
-
-	if (pos + copied > inode->i_size) {
-		struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-
-		psb->avail_size -= pos + copied - inode->i_size;
-
-		i_size_write(inode, pos + copied);
-	}
-
-	return copied;
-}
-
-static int pohmelfs_readpages_trans_complete(struct page **__pages, unsigned int page_num,
-		void *private, int err)
-{
-	struct pohmelfs_inode *pi = private;
-	unsigned int i, num;
-	struct page **pages, *page = (struct page *)__pages;
-	loff_t index = page->index;
-
-	pages = kzalloc(sizeof(void *) * page_num, GFP_NOIO);
-	if (!pages)
-		return -ENOMEM;
-
-	num = find_get_pages_contig(pi->vfs_inode.i_mapping, index, page_num, pages);
-	if (num <= 0) {
-		err = num;
-		goto err_out_free;
-	}
-
-	for (i = 0; i < num; ++i) {
-		page = pages[i];
-
-		if (err)
-			printk("%s: %u/%u: page: %p, index: %lu, uptodate: %d, locked: %d, err: %d.\n",
-				__func__, i, num, page, page->index,
-				PageUptodate(page), PageLocked(page), err);
-
-		if (!PageChecked(page)) {
-			if (err < 0)
-				SetPageError(page);
-			unlock_page(page);
-		}
-		page_cache_release(page);
-		page_cache_release(page);
-	}
-
-err_out_free:
-	kfree(pages);
-	return err;
-}
-
-static int pohmelfs_send_readpages(struct pohmelfs_inode *pi, struct page *first, unsigned int num)
-{
-	struct netfs_trans *t;
-	struct netfs_cmd *cmd;
-	struct pohmelfs_sb *psb = POHMELFS_SB(pi->vfs_inode.i_sb);
-	int err, path_len;
-	void *data;
-
-	err = pohmelfs_data_lock(pi, first->index << PAGE_CACHE_SHIFT,
-			num * PAGE_SIZE, POHMELFS_READ_LOCK);
-	if (err)
-		goto err_out_exit;
-
-	path_len = pohmelfs_path_length(pi);
-	if (path_len < 0) {
-		err = path_len;
-		goto err_out_exit;
-	}
-
-	t = netfs_trans_alloc(psb, path_len, NETFS_TRANS_SINGLE_DST, 0);
-	if (!t) {
-		err = -ENOMEM;
-		goto err_out_exit;
-	}
-
-	cmd = netfs_trans_current(t);
-	data = (void *)(cmd + 1);
-
-	t->complete = pohmelfs_readpages_trans_complete;
-	t->private = pi;
-	t->page_num = num;
-	t->pages = (struct page **)first;
-
-	err = pohmelfs_construct_path_string(pi, data, path_len);
-	if (err < 0)
-		goto err_out_put;
-
-	path_len = err;
-
-	cmd->cmd = NETFS_READ_PAGES;
-	cmd->start = first->index;
-	cmd->start <<= PAGE_CACHE_SHIFT;
-	cmd->size = (num << 8 | PAGE_CACHE_SHIFT);
-	cmd->id = pi->ino;
-	cmd->ext = path_len;
-
-	dprintk("%s: t: %p, gen: %u, path: '%s', path_len: %u, "
-			"start: %lu, num: %u.\n",
-			__func__, t, t->gen, (char *)data, path_len,
-			first->index, num);
-
-	netfs_convert_cmd(cmd);
-	netfs_trans_update(cmd, t, path_len);
-
-	return netfs_trans_finish(t, psb);
-
-err_out_put:
-	netfs_trans_free(t);
-err_out_exit:
-	pohmelfs_readpages_trans_complete((struct page **)first, num, pi, err);
-	return err;
-}
-
-#define list_to_page(head) (list_entry((head)->prev, struct page, lru))
-
-static int pohmelfs_readpages(struct file *file, struct address_space *mapping,
-			struct list_head *pages, unsigned nr_pages)
-{
-	unsigned int page_idx, num = 0;
-	struct page *page = NULL, *first = NULL;
-
-	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
-		page = list_to_page(pages);
-
-		prefetchw(&page->flags);
-		list_del(&page->lru);
-
-		if (!add_to_page_cache_lru(page, mapping,
-					page->index, GFP_KERNEL)) {
-
-			if (!num) {
-				num = 1;
-				first = page;
-				continue;
-			}
-
-			dprintk("%s: added to lru page: %p, page_index: %lu, first_index: %lu.\n",
-					__func__, page, page->index, first->index);
-
-			if (unlikely(first->index + num != page->index) || (num > 500)) {
-				pohmelfs_send_readpages(POHMELFS_I(mapping->host),
-						first, num);
-				first = page;
-				num = 0;
-			}
-
-			num++;
-		}
-	}
-	pohmelfs_send_readpages(POHMELFS_I(mapping->host), first, num);
-
-	/*
-	 * This will be sync read, so when last page is processed,
-	 * all previous are alerady unlocked and ready to be used.
-	 */
-	return 0;
-}
-
-/*
- * Small address space operations for POHMELFS.
- */
-const struct address_space_operations pohmelfs_aops = {
-	.readpage		= pohmelfs_readpage,
-	.readpages		= pohmelfs_readpages,
-	.writepages		= pohmelfs_writepages,
-	.write_begin		= pohmelfs_write_begin,
-	.write_end		= pohmelfs_write_end,
-	.set_page_dirty 	= __set_page_dirty_nobuffers,
-};
-
-static void pohmelfs_i_callback(struct rcu_head *head)
-{
-	struct inode *inode = container_of(head, struct inode, i_rcu);
-	INIT_LIST_HEAD(&inode->i_dentry);
-	kmem_cache_free(pohmelfs_inode_cache, POHMELFS_I(inode));
-}
-
-/*
- * ->destroy_inode() callback. Deletes inode from the caches
- *  and frees private data.
- */
-static void pohmelfs_destroy_inode(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-	struct pohmelfs_sb *psb = POHMELFS_SB(sb);
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-
-	/* pohmelfs_data_unlock(pi, 0, inode->i_size, POHMELFS_READ_LOCK); */
-
-	pohmelfs_inode_del_inode(psb, pi);
-
-	dprintk("%s: pi: %p, inode: %p, ino: %llu.\n",
-		__func__, pi, &pi->vfs_inode, pi->ino);
-	atomic_long_dec(&psb->total_inodes);
-	call_rcu(&inode->i_rcu, pohmelfs_i_callback);
-}
-
-/*
- * ->alloc_inode() callback. Allocates inode and initializes private data.
- */
-static struct inode *pohmelfs_alloc_inode(struct super_block *sb)
-{
-	struct pohmelfs_inode *pi;
-
-	pi = kmem_cache_alloc(pohmelfs_inode_cache, GFP_NOIO);
-	if (!pi)
-		return NULL;
-
-	pi->hash_root = RB_ROOT;
-	mutex_init(&pi->offset_lock);
-
-	INIT_LIST_HEAD(&pi->sync_create_list);
-
-	INIT_LIST_HEAD(&pi->inode_entry);
-
-	pi->lock_type = 0;
-	pi->state = 0;
-	pi->total_len = 0;
-	pi->drop_count = 0;
-
-	dprintk("%s: pi: %p, inode: %p.\n", __func__, pi, &pi->vfs_inode);
-
-	atomic_long_inc(&POHMELFS_SB(sb)->total_inodes);
-
-	return &pi->vfs_inode;
-}
-
-/*
- * We want fsync() to work on POHMELFS.
- */
-static int pohmelfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
-{
-	struct inode *inode = file->f_mapping->host;
-	int err = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (!err) {
-		mutex_lock(&inode->i_mutex);
-		err = sync_inode_metadata(inode, 1);
-		mutex_unlock(&inode->i_mutex);
-	}
-	return err;
-}
-
-ssize_t pohmelfs_write(struct file *file, const char __user *buf,
-		size_t len, loff_t *ppos)
-{
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = len };
-	struct kiocb kiocb;
-	ssize_t ret;
-	loff_t pos = *ppos;
-
-	init_sync_kiocb(&kiocb, file);
-	kiocb.ki_pos = pos;
-	kiocb.ki_left = len;
-
-	dprintk("%s: len: %zu, pos: %llu.\n", __func__, len, pos);
-
-	mutex_lock(&inode->i_mutex);
-	ret = pohmelfs_data_lock(pi, pos, len, POHMELFS_WRITE_LOCK);
-	if (ret)
-		goto err_out_unlock;
-
-	ret = __generic_file_aio_write(&kiocb, &iov, 1, &kiocb.ki_pos);
-	*ppos = kiocb.ki_pos;
-
-	mutex_unlock(&inode->i_mutex);
-	WARN_ON(ret < 0);
-
-	if (ret > 0) {
-		ssize_t err;
-
-		err = generic_write_sync(file, pos, ret);
-		if (err < 0)
-			ret = err;
-		WARN_ON(ret < 0);
-	}
-
-	return ret;
-
-err_out_unlock:
-	mutex_unlock(&inode->i_mutex);
-	return ret;
-}
-
-static const struct file_operations pohmelfs_file_ops = {
-	.open		= generic_file_open,
-	.fsync		= pohmelfs_fsync,
-
-	.llseek		= generic_file_llseek,
-
-	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
-
-	.mmap		= generic_file_mmap,
-
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= generic_file_splice_write,
-
-	.write		= pohmelfs_write,
-	.aio_write	= generic_file_aio_write,
-};
-
-const struct inode_operations pohmelfs_symlink_inode_operations = {
-	.readlink	= generic_readlink,
-	.follow_link	= page_follow_link_light,
-	.put_link	= page_put_link,
-};
-
-int pohmelfs_setattr_raw(struct inode *inode, struct iattr *attr)
-{
-	int err;
-
-	err = inode_change_ok(inode, attr);
-	if (err) {
-		dprintk("%s: ino: %llu, inode changes are not allowed.\n", __func__, POHMELFS_I(inode)->ino);
-		goto err_out_exit;
-	}
-
-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		err = vmtruncate(inode, attr->ia_size);
-		if (err) {
-			dprintk("%s: ino: %llu, failed to set the attributes.\n", __func__, POHMELFS_I(inode)->ino);
-			goto err_out_exit;
-		}
-	}
-
-	setattr_copy(inode, attr);
-	mark_inode_dirty(inode);
-
-	dprintk("%s: ino: %llu, mode: %o -> %o, uid: %u -> %u, gid: %u -> %u, size: %llu -> %llu.\n",
-			__func__, POHMELFS_I(inode)->ino, inode->i_mode, attr->ia_mode,
-			inode->i_uid, attr->ia_uid, inode->i_gid, attr->ia_gid, inode->i_size, attr->ia_size);
-
-	return 0;
-
-err_out_exit:
-	return err;
-}
-
-int pohmelfs_setattr(struct dentry *dentry, struct iattr *attr)
-{
-	struct inode *inode = dentry->d_inode;
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	int err;
-
-	err = pohmelfs_data_lock(pi, 0, ~0, POHMELFS_WRITE_LOCK);
-	if (err)
-		goto err_out_exit;
-
-	err = security_inode_setattr(dentry, attr);
-	if (err)
-		goto err_out_exit;
-
-	err = pohmelfs_setattr_raw(inode, attr);
-	if (err)
-		goto err_out_exit;
-
-	return 0;
-
-err_out_exit:
-	return err;
-}
-
-static int pohmelfs_send_xattr_req(struct pohmelfs_inode *pi, u64 id, u64 start,
-		const char *name, const void *value, size_t attrsize, int command)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(pi->vfs_inode.i_sb);
-	int err, path_len, namelen = strlen(name) + 1; /* 0-byte */
-	struct netfs_trans *t;
-	struct netfs_cmd *cmd;
-	void *data;
-
-	dprintk("%s: id: %llu, start: %llu, name: '%s', attrsize: %zu, cmd: %d.\n",
-			__func__, id, start, name, attrsize, command);
-
-	path_len = pohmelfs_path_length(pi);
-	if (path_len < 0) {
-		err = path_len;
-		goto err_out_exit;
-	}
-
-	t = netfs_trans_alloc(psb, namelen + path_len + attrsize, 0, 0);
-	if (!t) {
-		err = -ENOMEM;
-		goto err_out_exit;
-	}
-
-	cmd = netfs_trans_current(t);
-	data = cmd + 1;
-
-	path_len = pohmelfs_construct_path_string(pi, data, path_len);
-	if (path_len < 0) {
-		err = path_len;
-		goto err_out_put;
-	}
-	data += path_len;
-
-	/*
-	 * 'name' is a NUL-terminated string already and
-	 * 'namelen' includes 0-byte.
-	 */
-	memcpy(data, name, namelen);
-	data += namelen;
-
-	memcpy(data, value, attrsize);
-
-	cmd->cmd = command;
-	cmd->id = id;
-	cmd->start = start;
-	cmd->size = attrsize + namelen + path_len;
-	cmd->ext = path_len;
-	cmd->csize = 0;
-	cmd->cpad = 0;
-
-	netfs_convert_cmd(cmd);
-	netfs_trans_update(cmd, t, namelen + path_len + attrsize);
-
-	return netfs_trans_finish(t, psb);
-
-err_out_put:
-	t->result = err;
-	netfs_trans_put(t);
-err_out_exit:
-	return err;
-}
-
-static int pohmelfs_setxattr(struct dentry *dentry, const char *name,
-		const void *value, size_t attrsize, int flags)
-{
-	struct inode *inode = dentry->d_inode;
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-
-	if (!(psb->state_flags & POHMELFS_FLAGS_XATTR))
-		return -EOPNOTSUPP;
-
-	return pohmelfs_send_xattr_req(pi, flags, attrsize, name,
-			value, attrsize, NETFS_XATTR_SET);
-}
-
-static ssize_t pohmelfs_getxattr(struct dentry *dentry, const char *name,
-		void *value, size_t attrsize)
-{
-	struct inode *inode = dentry->d_inode;
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	struct pohmelfs_mcache *m;
-	int err;
-	long timeout = psb->mcache_timeout;
-
-	if (!(psb->state_flags & POHMELFS_FLAGS_XATTR))
-		return -EOPNOTSUPP;
-
-	m = pohmelfs_mcache_alloc(psb, 0, attrsize, value);
-	if (IS_ERR(m))
-		return PTR_ERR(m);
-
-	dprintk("%s: ino: %llu, name: '%s', size: %zu.\n",
-			__func__, pi->ino, name, attrsize);
-
-	err = pohmelfs_send_xattr_req(pi, m->gen, attrsize, name, value, 0, NETFS_XATTR_GET);
-	if (err)
-		goto err_out_put;
-
-	do {
-		err = wait_for_completion_timeout(&m->complete, timeout);
-		if (err) {
-			err = m->err;
-			break;
-		}
-
-		/*
-		 * This loop is a bit ugly, since it waits until reference counter
-		 * hits 1 and then puts the object here. Main goal is to prevent race with
-		 * the network thread, when it can start processing the given request, i.e.
-		 * increase its reference counter but yet not complete it, while
-		 * we will exit from ->getxattr() with timeout, and although request
-		 * will not be freed (its reference counter was increased by network
-		 * thread), data pointer provided by user may be released, so we will
-		 * overwrite an already freed area in the network thread.
-		 *
-		 * Now after timeout we remove request from the cache, so it can not be
-		 * found by network thread, and wait for its reference counter to hit 1,
-		 * i.e. if network thread already started to process this request, we wait
-		 * for it to finish, and then free object locally. If reference counter is
-		 * already 1, i.e. request is not used by anyone else, we can free it without
-		 * problem.
-		 */
-		err = -ETIMEDOUT;
-		timeout = HZ;
-
-		pohmelfs_mcache_remove_locked(psb, m);
-	} while (atomic_read(&m->refcnt) != 1);
-
-	pohmelfs_mcache_put(psb, m);
-
-	dprintk("%s: ino: %llu, err: %d.\n", __func__, pi->ino, err);
-
-	return err;
-
-err_out_put:
-	pohmelfs_mcache_put(psb, m);
-	return err;
-}
-
-static int pohmelfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
-{
-	struct inode *inode = dentry->d_inode;
-#if 0
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-	int err;
-
-	err = pohmelfs_data_lock(pi, 0, ~0, POHMELFS_READ_LOCK);
-	if (err)
-		return err;
-	dprintk("%s: ino: %llu, mode: %o, uid: %u, gid: %u, size: %llu.\n",
-			__func__, pi->ino, inode->i_mode, inode->i_uid,
-			inode->i_gid, inode->i_size);
-#endif
-
-	generic_fillattr(inode, stat);
-	return 0;
-}
-
-const struct inode_operations pohmelfs_file_inode_operations = {
-	.setattr	= pohmelfs_setattr,
-	.getattr	= pohmelfs_getattr,
-	.setxattr	= pohmelfs_setxattr,
-	.getxattr	= pohmelfs_getxattr,
-};
-
-/*
- * Fill inode data: mode, size, operation callbacks and so on...
- */
-void pohmelfs_fill_inode(struct inode *inode, struct netfs_inode_info *info)
-{
-	inode->i_mode = info->mode;
-	inode->i_nlink = info->nlink;
-	inode->i_uid = info->uid;
-	inode->i_gid = info->gid;
-	inode->i_blocks = info->blocks;
-	inode->i_rdev = info->rdev;
-	inode->i_size = info->size;
-	inode->i_version = info->version;
-	inode->i_blkbits = ffs(info->blocksize);
-
-	dprintk("%s: inode: %p, num: %lu/%llu inode is regular: %d, dir: %d, link: %d, mode: %o, size: %llu.\n",
-			__func__, inode, inode->i_ino, info->ino,
-			S_ISREG(inode->i_mode), S_ISDIR(inode->i_mode),
-			S_ISLNK(inode->i_mode), inode->i_mode, inode->i_size);
-
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
-
-	/*
-	 * i_mapping is a pointer to i_data during inode initialization.
-	 */
-	inode->i_data.a_ops = &pohmelfs_aops;
-
-	if (S_ISREG(inode->i_mode)) {
-		inode->i_fop = &pohmelfs_file_ops;
-		inode->i_op = &pohmelfs_file_inode_operations;
-	} else if (S_ISDIR(inode->i_mode)) {
-		inode->i_fop = &pohmelfs_dir_fops;
-		inode->i_op = &pohmelfs_dir_inode_ops;
-	} else if (S_ISLNK(inode->i_mode)) {
-		inode->i_op = &pohmelfs_symlink_inode_operations;
-		inode->i_fop = &pohmelfs_file_ops;
-	} else {
-		inode->i_fop = &generic_ro_fops;
-	}
-}
-
-static int pohmelfs_drop_inode(struct inode *inode)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	struct pohmelfs_inode *pi = POHMELFS_I(inode);
-
-	spin_lock(&psb->ino_lock);
-	list_del_init(&pi->inode_entry);
-	spin_unlock(&psb->ino_lock);
-
-	return generic_drop_inode(inode);
-}
-
-static struct pohmelfs_inode *pohmelfs_get_inode_from_list(struct pohmelfs_sb *psb,
-		struct list_head *head, unsigned int *count)
-{
-	struct pohmelfs_inode *pi = NULL;
-
-	spin_lock(&psb->ino_lock);
-	if (!list_empty(head)) {
-		pi = list_entry(head->next, struct pohmelfs_inode,
-					inode_entry);
-		list_del_init(&pi->inode_entry);
-		*count = pi->drop_count;
-		pi->drop_count = 0;
-	}
-	spin_unlock(&psb->ino_lock);
-
-	return pi;
-}
-
-static void pohmelfs_flush_transactions(struct pohmelfs_sb *psb)
-{
-	struct pohmelfs_config *c;
-
-	mutex_lock(&psb->state_lock);
-	list_for_each_entry(c, &psb->state_list, config_entry) {
-		pohmelfs_state_flush_transactions(&c->state);
-	}
-	mutex_unlock(&psb->state_lock);
-}
-
-/*
- * ->put_super() callback. Invoked before superblock is destroyed,
- *  so it has to clean all private data.
- */
-static void pohmelfs_put_super(struct super_block *sb)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(sb);
-	struct pohmelfs_inode *pi;
-	unsigned int count = 0;
-	unsigned int in_drop_list = 0;
-	struct inode *inode, *tmp;
-
-	dprintk("%s.\n", __func__);
-
-	/*
-	 * Kill pending transactions, which could affect inodes in-flight.
-	 */
-	pohmelfs_flush_transactions(psb);
-
-	while ((pi = pohmelfs_get_inode_from_list(psb, &psb->drop_list, &count))) {
-		inode = &pi->vfs_inode;
-
-		dprintk("%s: ino: %llu, pi: %p, inode: %p, count: %u.\n",
-				__func__, pi->ino, pi, inode, count);
-
-		if (atomic_read(&inode->i_count) != count) {
-			printk("%s: ino: %llu, pi: %p, inode: %p, count: %u, i_count: %d.\n",
-					__func__, pi->ino, pi, inode, count,
-					atomic_read(&inode->i_count));
-			count = atomic_read(&inode->i_count);
-			in_drop_list++;
-		}
-
-		while (count--)
-			iput(&pi->vfs_inode);
-	}
-
-	list_for_each_entry_safe(inode, tmp, &sb->s_inodes, i_sb_list) {
-		pi = POHMELFS_I(inode);
-
-		dprintk("%s: ino: %llu, pi: %p, inode: %p, i_count: %u.\n",
-				__func__, pi->ino, pi, inode, atomic_read(&inode->i_count));
-
-		/*
-		 * These are special inodes, they were created during
-		 * directory reading or lookup, and were not bound to dentry,
-		 * so they live here with reference counter being 1 and prevent
-		 * umount from succeed since it believes that they are busy.
-		 */
-		count = atomic_read(&inode->i_count);
-		if (count) {
-			list_del_init(&inode->i_sb_list);
-			while (count--)
-				iput(&pi->vfs_inode);
-		}
-	}
-
-	psb->trans_scan_timeout = psb->drop_scan_timeout = 0;
-	cancel_delayed_work_sync(&psb->dwork);
-	cancel_delayed_work_sync(&psb->drop_dwork);
-	flush_scheduled_work();
-
-	dprintk("%s: stopped workqueues.\n", __func__);
-
-	pohmelfs_crypto_exit(psb);
-	pohmelfs_state_exit(psb);
-
-	bdi_destroy(&psb->bdi);
-
-	kfree(psb);
-	sb->s_fs_info = NULL;
-}
-
-static int pohmelfs_statfs(struct dentry *dentry, struct kstatfs *buf)
-{
-	struct super_block *sb = dentry->d_sb;
-	struct pohmelfs_sb *psb = POHMELFS_SB(sb);
-
-	/*
-	 * There are no filesystem size limits yet.
-	 */
-	memset(buf, 0, sizeof(struct kstatfs));
-
-	buf->f_type = POHMELFS_MAGIC_NUM; /* 'POH.' */
-	buf->f_bsize = sb->s_blocksize;
-	buf->f_files = psb->ino;
-	buf->f_namelen = 255;
-	buf->f_files = atomic_long_read(&psb->total_inodes);
-	buf->f_bfree = buf->f_bavail = psb->avail_size >> PAGE_SHIFT;
-	buf->f_blocks = psb->total_size >> PAGE_SHIFT;
-
-	dprintk("%s: total: %llu, avail: %llu, inodes: %llu, bsize: %lu.\n",
-		__func__, psb->total_size, psb->avail_size, buf->f_files, sb->s_blocksize);
-
-	return 0;
-}
-
-static int pohmelfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(vfs->mnt_sb);
-
-	seq_printf(seq, ",idx=%u", psb->idx);
-	seq_printf(seq, ",trans_scan_timeout=%u", jiffies_to_msecs(psb->trans_scan_timeout));
-	seq_printf(seq, ",drop_scan_timeout=%u", jiffies_to_msecs(psb->drop_scan_timeout));
-	seq_printf(seq, ",wait_on_page_timeout=%u", jiffies_to_msecs(psb->wait_on_page_timeout));
-	seq_printf(seq, ",trans_retries=%u", psb->trans_retries);
-	seq_printf(seq, ",crypto_thread_num=%u", psb->crypto_thread_num);
-	seq_printf(seq, ",trans_max_pages=%u", psb->trans_max_pages);
-	seq_printf(seq, ",mcache_timeout=%u", jiffies_to_msecs(psb->mcache_timeout));
-	if (psb->crypto_fail_unsupported)
-		seq_printf(seq, ",crypto_fail_unsupported");
-
-	return 0;
-}
-
-enum {
-	pohmelfs_opt_idx,
-	pohmelfs_opt_crypto_thread_num,
-	pohmelfs_opt_trans_max_pages,
-	pohmelfs_opt_crypto_fail_unsupported,
-
-	/* Remountable options */
-	pohmelfs_opt_trans_scan_timeout,
-	pohmelfs_opt_drop_scan_timeout,
-	pohmelfs_opt_wait_on_page_timeout,
-	pohmelfs_opt_trans_retries,
-	pohmelfs_opt_mcache_timeout,
-};
-
-static struct match_token pohmelfs_tokens[] = {
-	{pohmelfs_opt_idx, "idx=%u"},
-	{pohmelfs_opt_crypto_thread_num, "crypto_thread_num=%u"},
-	{pohmelfs_opt_trans_max_pages, "trans_max_pages=%u"},
-	{pohmelfs_opt_crypto_fail_unsupported, "crypto_fail_unsupported"},
-	{pohmelfs_opt_trans_scan_timeout, "trans_scan_timeout=%u"},
-	{pohmelfs_opt_drop_scan_timeout, "drop_scan_timeout=%u"},
-	{pohmelfs_opt_wait_on_page_timeout, "wait_on_page_timeout=%u"},
-	{pohmelfs_opt_trans_retries, "trans_retries=%u"},
-	{pohmelfs_opt_mcache_timeout, "mcache_timeout=%u"},
-};
-
-static int pohmelfs_parse_options(char *options, struct pohmelfs_sb *psb, int remount)
-{
-	char *p;
-	substring_t args[MAX_OPT_ARGS];
-	int option, err;
-
-	if (!options)
-		return 0;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int token;
-		if (!*p)
-			continue;
-
-		token = match_token(p, pohmelfs_tokens, args);
-
-		err = match_int(&args[0], &option);
-		if (err)
-			return err;
-
-		if (remount && token <= pohmelfs_opt_crypto_fail_unsupported)
-			continue;
-
-		switch (token) {
-		case pohmelfs_opt_idx:
-			psb->idx = option;
-			break;
-		case pohmelfs_opt_trans_scan_timeout:
-			psb->trans_scan_timeout = msecs_to_jiffies(option);
-			break;
-		case pohmelfs_opt_drop_scan_timeout:
-			psb->drop_scan_timeout = msecs_to_jiffies(option);
-			break;
-		case pohmelfs_opt_wait_on_page_timeout:
-			psb->wait_on_page_timeout = msecs_to_jiffies(option);
-			break;
-		case pohmelfs_opt_mcache_timeout:
-			psb->mcache_timeout = msecs_to_jiffies(option);
-			break;
-		case pohmelfs_opt_trans_retries:
-			psb->trans_retries = option;
-			break;
-		case pohmelfs_opt_crypto_thread_num:
-			psb->crypto_thread_num = option;
-			break;
-		case pohmelfs_opt_trans_max_pages:
-			psb->trans_max_pages = option;
-			break;
-		case pohmelfs_opt_crypto_fail_unsupported:
-			psb->crypto_fail_unsupported = 1;
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-
-static int pohmelfs_remount(struct super_block *sb, int *flags, char *data)
-{
-	int err;
-	struct pohmelfs_sb *psb = POHMELFS_SB(sb);
-	unsigned long old_sb_flags = sb->s_flags;
-
-	err = pohmelfs_parse_options(data, psb, 1);
-	if (err)
-		goto err_out_restore;
-
-	if (!(*flags & MS_RDONLY))
-		sb->s_flags &= ~MS_RDONLY;
-	return 0;
-
-err_out_restore:
-	sb->s_flags = old_sb_flags;
-	return err;
-}
-
-static void pohmelfs_flush_inode(struct pohmelfs_inode *pi, unsigned int count)
-{
-	struct inode *inode = &pi->vfs_inode;
-
-	dprintk("%s: %p: ino: %llu, owned: %d.\n",
-		__func__, inode, pi->ino, test_bit(NETFS_INODE_OWNED, &pi->state));
-
-	mutex_lock(&inode->i_mutex);
-	if (test_and_clear_bit(NETFS_INODE_OWNED, &pi->state)) {
-		filemap_fdatawrite(inode->i_mapping);
-		inode->i_sb->s_op->write_inode(inode, 0);
-	}
-
-#ifdef POHMELFS_TRUNCATE_ON_INODE_FLUSH
-	truncate_inode_pages(inode->i_mapping, 0);
-#endif
-
-	pohmelfs_data_unlock(pi, 0, ~0, POHMELFS_WRITE_LOCK);
-	mutex_unlock(&inode->i_mutex);
-}
-
-static void pohmelfs_put_inode_count(struct pohmelfs_inode *pi, unsigned int count)
-{
-	dprintk("%s: ino: %llu, pi: %p, inode: %p, count: %u.\n",
-			__func__, pi->ino, pi, &pi->vfs_inode, count);
-
-	if (test_and_clear_bit(NETFS_INODE_NEED_FLUSH, &pi->state))
-		pohmelfs_flush_inode(pi, count);
-
-	while (count--)
-		iput(&pi->vfs_inode);
-}
-
-static void pohmelfs_drop_scan(struct work_struct *work)
-{
-	struct pohmelfs_sb *psb =
-		container_of(work, struct pohmelfs_sb, drop_dwork.work);
-	struct pohmelfs_inode *pi;
-	unsigned int count = 0;
-
-	while ((pi = pohmelfs_get_inode_from_list(psb, &psb->drop_list, &count)))
-		pohmelfs_put_inode_count(pi, count);
-
-	pohmelfs_check_states(psb);
-
-	if (psb->drop_scan_timeout)
-		schedule_delayed_work(&psb->drop_dwork, psb->drop_scan_timeout);
-}
-
-/*
- * Run through all transactions starting from the oldest,
- * drop transaction from current state and try to send it
- * to all remote nodes, which are currently installed.
- */
-static void pohmelfs_trans_scan_state(struct netfs_state *st)
-{
-	struct rb_node *rb_node;
-	struct netfs_trans_dst *dst;
-	struct pohmelfs_sb *psb = st->psb;
-	unsigned int timeout = psb->trans_scan_timeout;
-	struct netfs_trans *t;
-	int err;
-
-	mutex_lock(&st->trans_lock);
-	for (rb_node = rb_first(&st->trans_root); rb_node; ) {
-		dst = rb_entry(rb_node, struct netfs_trans_dst, state_entry);
-		t = dst->trans;
-
-		if (timeout && time_after(dst->send_time + timeout, jiffies)
-				&& dst->retries == 0)
-			break;
-
-		dprintk("%s: t: %p, gen: %u, st: %p, retries: %u, max: %u.\n",
-			__func__, t, t->gen, st, dst->retries, psb->trans_retries);
-		netfs_trans_get(t);
-
-		rb_node = rb_next(rb_node);
-
-		err = -ETIMEDOUT;
-		if (timeout && (++dst->retries < psb->trans_retries))
-			err = netfs_trans_resend(t, psb);
-
-		if (err || (t->flags & NETFS_TRANS_SINGLE_DST)) {
-			if (netfs_trans_remove_nolock(dst, st))
-				netfs_trans_drop_dst_nostate(dst);
-		}
-
-		t->result = err;
-		netfs_trans_put(t);
-	}
-	mutex_unlock(&st->trans_lock);
-}
-
-/*
- * Walk through all installed network states and resend all
- * transactions, which are old enough.
- */
-static void pohmelfs_trans_scan(struct work_struct *work)
-{
-	struct pohmelfs_sb *psb =
-		container_of(work, struct pohmelfs_sb, dwork.work);
-	struct netfs_state *st;
-	struct pohmelfs_config *c;
-
-	mutex_lock(&psb->state_lock);
-	list_for_each_entry(c, &psb->state_list, config_entry) {
-		st = &c->state;
-
-		pohmelfs_trans_scan_state(st);
-	}
-	mutex_unlock(&psb->state_lock);
-
-	/*
-	 * If no timeout specified then system is in the middle of umount process,
-	 * so no need to reschedule scanning process again.
-	 */
-	if (psb->trans_scan_timeout)
-		schedule_delayed_work(&psb->dwork, psb->trans_scan_timeout);
-}
-
-int pohmelfs_meta_command_data(struct pohmelfs_inode *pi, u64 id, unsigned int cmd_op, char *addon,
-		unsigned int flags, netfs_trans_complete_t complete, void *priv, u64 start)
-{
-	struct inode *inode = &pi->vfs_inode;
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	int err = 0, sz;
-	struct netfs_trans *t;
-	int path_len, addon_len = 0;
-	void *data;
-	struct netfs_inode_info *info;
-	struct netfs_cmd *cmd;
-
-	dprintk("%s: ino: %llu, cmd: %u, addon: %p.\n", __func__, pi->ino, cmd_op, addon);
-
-	path_len = pohmelfs_path_length(pi);
-	if (path_len < 0) {
-		err = path_len;
-		goto err_out_exit;
-	}
-
-	if (addon)
-		addon_len = strlen(addon) + 1; /* 0-byte */
-	sz = addon_len;
-
-	if (cmd_op == NETFS_INODE_INFO)
-		sz += sizeof(struct netfs_inode_info);
-
-	t = netfs_trans_alloc(psb, sz + path_len, flags, 0);
-	if (!t) {
-		err = -ENOMEM;
-		goto err_out_exit;
-	}
-	t->complete = complete;
-	t->private = priv;
-
-	cmd = netfs_trans_current(t);
-	data = (void *)(cmd + 1);
-
-	if (cmd_op == NETFS_INODE_INFO) {
-		info = (struct netfs_inode_info *)(cmd + 1);
-		data = (void *)(info + 1);
-
-		/*
-		 * We are under i_mutex, can read and change whatever we want...
-		 */
-		info->mode = inode->i_mode;
-		info->nlink = inode->i_nlink;
-		info->uid = inode->i_uid;
-		info->gid = inode->i_gid;
-		info->blocks = inode->i_blocks;
-		info->rdev = inode->i_rdev;
-		info->size = inode->i_size;
-		info->version = inode->i_version;
-
-		netfs_convert_inode_info(info);
-	}
-
-	path_len = pohmelfs_construct_path_string(pi, data, path_len);
-	if (path_len < 0)
-		goto err_out_free;
-
-	dprintk("%s: path_len: %d.\n", __func__, path_len);
-
-	if (addon) {
-		path_len--; /* Do not place null-byte before the addon */
-		path_len += sprintf(data + path_len, "/%s", addon) + 1; /* 0 - byte */
-	}
-
-	sz += path_len;
-
-	cmd->cmd = cmd_op;
-	cmd->ext = path_len;
-	cmd->size = sz;
-	cmd->id = id;
-	cmd->start = start;
-
-	netfs_convert_cmd(cmd);
-	netfs_trans_update(cmd, t, sz);
-
-	/*
-	 * Note, that it is possible to leak error here: transaction callback will not
-	 * be invoked for allocation path failure.
-	 */
-	return netfs_trans_finish(t, psb);
-
-err_out_free:
-	netfs_trans_free(t);
-err_out_exit:
-	if (complete)
-		complete(NULL, 0, priv, err);
-	return err;
-}
-
-int pohmelfs_meta_command(struct pohmelfs_inode *pi, unsigned int cmd_op, unsigned int flags,
-		netfs_trans_complete_t complete, void *priv, u64 start)
-{
-	return pohmelfs_meta_command_data(pi, pi->ino, cmd_op, NULL, flags, complete, priv, start);
-}
-
-/*
- * Send request and wait for POHMELFS root capabilities response,
- * which will update server's informaion about size of the export,
- * permissions, number of objects, available size and so on.
- */
-static int pohmelfs_root_handshake(struct pohmelfs_sb *psb)
-{
-	struct netfs_trans *t;
-	struct netfs_cmd *cmd;
-	int err = -ENOMEM;
-
-	t = netfs_trans_alloc(psb, 0, 0, 0);
-	if (!t)
-		goto err_out_exit;
-
-	cmd = netfs_trans_current(t);
-
-	cmd->cmd = NETFS_CAPABILITIES;
-	cmd->id = POHMELFS_ROOT_CAPABILITIES;
-	cmd->size = 0;
-	cmd->start = 0;
-	cmd->ext = 0;
-	cmd->csize = 0;
-
-	netfs_convert_cmd(cmd);
-	netfs_trans_update(cmd, t, 0);
-
-	err = netfs_trans_finish(t, psb);
-	if (err)
-		goto err_out_exit;
-
-	psb->flags = ~0;
-	err = wait_event_interruptible_timeout(psb->wait,
-			(psb->flags != ~0),
-			psb->wait_on_page_timeout);
-	if (!err)
-		err = -ETIMEDOUT;
-	else if (err > 0)
-		err = -psb->flags;
-
-	if (err)
-		goto err_out_exit;
-
-	return 0;
-
-err_out_exit:
-	return err;
-}
-
-static int pohmelfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
-{
-	struct netfs_state *st;
-	struct pohmelfs_ctl *ctl;
-	struct pohmelfs_sb *psb = POHMELFS_SB(mnt->mnt_sb);
-	struct pohmelfs_config *c;
-
-	mutex_lock(&psb->state_lock);
-
-	seq_printf(m, "\nidx addr(:port) socket_type protocol active priority permissions\n");
-
-	list_for_each_entry(c, &psb->state_list, config_entry) {
-		st = &c->state;
-		ctl = &st->ctl;
-
-		seq_printf(m, "%u ", ctl->idx);
-		if (ctl->addr.sa_family == AF_INET) {
-			struct sockaddr_in *sin = (struct sockaddr_in *)&st->ctl.addr;
-			seq_printf(m, "%pI4:%u", &sin->sin_addr.s_addr, ntohs(sin->sin_port));
-		} else if (ctl->addr.sa_family == AF_INET6) {
-			struct sockaddr_in6 *sin = (struct sockaddr_in6 *)&st->ctl.addr;
-			seq_printf(m, "%pi6:%u", &sin->sin6_addr, ntohs(sin->sin6_port));
-		} else {
-			unsigned int i;
-			for (i = 0; i < ctl->addrlen; ++i)
-				seq_printf(m, "%02x.", ctl->addr.addr[i]);
-		}
-
-		seq_printf(m, " %u %u %d %u %x\n",
-				ctl->type, ctl->proto,
-				st->socket != NULL,
-				ctl->prio, ctl->perm);
-	}
-	mutex_unlock(&psb->state_lock);
-
-	return 0;
-}
-
-static const struct super_operations pohmelfs_sb_ops = {
-	.alloc_inode	= pohmelfs_alloc_inode,
-	.destroy_inode	= pohmelfs_destroy_inode,
-	.drop_inode	= pohmelfs_drop_inode,
-	.write_inode	= pohmelfs_write_inode,
-	.put_super	= pohmelfs_put_super,
-	.remount_fs	= pohmelfs_remount,
-	.statfs		= pohmelfs_statfs,
-	.show_options	= pohmelfs_show_options,
-	.show_stats	= pohmelfs_show_stats,
-};
-
-/*
- * Allocate private superblock and create root dir.
- */
-static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
-{
-	struct pohmelfs_sb *psb;
-	int err = -ENOMEM;
-	struct inode *root;
-	struct pohmelfs_inode *npi;
-	struct qstr str;
-
-	psb = kzalloc(sizeof(struct pohmelfs_sb), GFP_KERNEL);
-	if (!psb)
-		goto err_out_exit;
-
-	err = bdi_init(&psb->bdi);
-	if (err)
-		goto err_out_free_sb;
-
-	err = bdi_register(&psb->bdi, NULL, "pfs-%d", atomic_inc_return(&psb_bdi_num));
-	if (err) {
-		bdi_destroy(&psb->bdi);
-		goto err_out_free_sb;
-	}
-
-	sb->s_fs_info = psb;
-	sb->s_op = &pohmelfs_sb_ops;
-	sb->s_magic = POHMELFS_MAGIC_NUM;
-	sb->s_maxbytes = MAX_LFS_FILESIZE;
-	sb->s_blocksize = PAGE_SIZE;
-	sb->s_bdi = &psb->bdi;
-
-	psb->sb = sb;
-
-	psb->ino = 2;
-	psb->idx = 0;
-	psb->active_state = NULL;
-	psb->trans_retries = 5;
-	psb->trans_data_size = PAGE_SIZE;
-	psb->drop_scan_timeout = msecs_to_jiffies(1000);
-	psb->trans_scan_timeout = msecs_to_jiffies(5000);
-	psb->wait_on_page_timeout = msecs_to_jiffies(5000);
-	init_waitqueue_head(&psb->wait);
-
-	spin_lock_init(&psb->ino_lock);
-
-	INIT_LIST_HEAD(&psb->drop_list);
-
-	mutex_init(&psb->mcache_lock);
-	psb->mcache_root = RB_ROOT;
-	psb->mcache_timeout = msecs_to_jiffies(5000);
-	atomic_long_set(&psb->mcache_gen, 0);
-
-	psb->trans_max_pages = 100;
-
-	psb->crypto_align_size = 16;
-	psb->crypto_attached_size = 0;
-	psb->hash_strlen = 0;
-	psb->cipher_strlen = 0;
-	psb->perform_crypto = 0;
-	psb->crypto_thread_num = 2;
-	psb->crypto_fail_unsupported = 0;
-	mutex_init(&psb->crypto_thread_lock);
-	INIT_LIST_HEAD(&psb->crypto_ready_list);
-	INIT_LIST_HEAD(&psb->crypto_active_list);
-
-	atomic_set(&psb->trans_gen, 1);
-	atomic_long_set(&psb->total_inodes, 0);
-
-	mutex_init(&psb->state_lock);
-	INIT_LIST_HEAD(&psb->state_list);
-
-	err = pohmelfs_parse_options((char *) data, psb, 0);
-	if (err)
-		goto err_out_free_bdi;
-
-	err = pohmelfs_copy_crypto(psb);
-	if (err)
-		goto err_out_free_bdi;
-
-	err = pohmelfs_state_init(psb);
-	if (err)
-		goto err_out_free_strings;
-
-	err = pohmelfs_crypto_init(psb);
-	if (err)
-		goto err_out_state_exit;
-
-	err = pohmelfs_root_handshake(psb);
-	if (err)
-		goto err_out_crypto_exit;
-
-	str.name = "/";
-	str.hash = jhash("/", 1, 0);
-	str.len = 1;
-
-	npi = pohmelfs_create_entry_local(psb, NULL, &str, 0, 0755|S_IFDIR);
-	if (IS_ERR(npi)) {
-		err = PTR_ERR(npi);
-		goto err_out_crypto_exit;
-	}
-	set_bit(NETFS_INODE_REMOTE_SYNCED, &npi->state);
-	clear_bit(NETFS_INODE_OWNED, &npi->state);
-
-	root = &npi->vfs_inode;
-
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root)
-		goto err_out_put_root;
-
-	INIT_DELAYED_WORK(&psb->drop_dwork, pohmelfs_drop_scan);
-	schedule_delayed_work(&psb->drop_dwork, psb->drop_scan_timeout);
-
-	INIT_DELAYED_WORK(&psb->dwork, pohmelfs_trans_scan);
-	schedule_delayed_work(&psb->dwork, psb->trans_scan_timeout);
-
-	return 0;
-
-err_out_put_root:
-	iput(root);
-err_out_crypto_exit:
-	pohmelfs_crypto_exit(psb);
-err_out_state_exit:
-	pohmelfs_state_exit(psb);
-err_out_free_strings:
-	kfree(psb->cipher_string);
-	kfree(psb->hash_string);
-err_out_free_bdi:
-	bdi_destroy(&psb->bdi);
-err_out_free_sb:
-	kfree(psb);
-err_out_exit:
-
-	dprintk("%s: err: %d.\n", __func__, err);
-	return err;
-}
-
-/*
- * Some VFS magic here...
- */
-static struct dentry *pohmelfs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
-{
-	return mount_nodev(fs_type, flags, data, pohmelfs_fill_super);
-}
-
-/*
- * We need this to sync all inodes earlier, since when writeback
- * is invoked from the umount/mntput path dcache is already shrunk,
- * see generic_shutdown_super(), and no inodes can access the path.
- */
-static void pohmelfs_kill_super(struct super_block *sb)
-{
-	sync_inodes_sb(sb);
-	kill_anon_super(sb);
-}
-
-static struct file_system_type pohmel_fs_type = {
-	.owner		= THIS_MODULE,
-	.name		= "pohmel",
-	.mount		= pohmelfs_mount,
-	.kill_sb 	= pohmelfs_kill_super,
-};
-
-/*
- * Cache and module initializations and freeing routings.
- */
-static void pohmelfs_init_once(void *data)
-{
-	struct pohmelfs_inode *pi = data;
-
-	inode_init_once(&pi->vfs_inode);
-}
-
-static int __init pohmelfs_init_inodecache(void)
-{
-	pohmelfs_inode_cache = kmem_cache_create("pohmelfs_inode_cache",
-				sizeof(struct pohmelfs_inode),
-				0, (SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
-				pohmelfs_init_once);
-	if (!pohmelfs_inode_cache)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void pohmelfs_destroy_inodecache(void)
-{
-	kmem_cache_destroy(pohmelfs_inode_cache);
-}
-
-static int __init init_pohmel_fs(void)
-{
-	int err;
-
-	err = pohmelfs_config_init();
-	if (err)
-		goto err_out_exit;
-
-	err = pohmelfs_init_inodecache();
-	if (err)
-		goto err_out_config_exit;
-
-	err = pohmelfs_mcache_init();
-	if (err)
-		goto err_out_destroy;
-
-	err = netfs_trans_init();
-	if (err)
-		goto err_out_mcache_exit;
-
-	err = register_filesystem(&pohmel_fs_type);
-	if (err)
-		goto err_out_trans;
-
-	return 0;
-
-err_out_trans:
-	netfs_trans_exit();
-err_out_mcache_exit:
-	pohmelfs_mcache_exit();
-err_out_destroy:
-	pohmelfs_destroy_inodecache();
-err_out_config_exit:
-	pohmelfs_config_exit();
-err_out_exit:
-	return err;
-}
-
-static void __exit exit_pohmel_fs(void)
-{
-	unregister_filesystem(&pohmel_fs_type);
-	pohmelfs_destroy_inodecache();
-	pohmelfs_mcache_exit();
-	pohmelfs_config_exit();
-	netfs_trans_exit();
-}
-
-module_init(init_pohmel_fs);
-module_exit(exit_pohmel_fs);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
-MODULE_DESCRIPTION("Pohmel filesystem");
diff --git a/drivers/staging/pohmelfs/lock.c b/drivers/staging/pohmelfs/lock.c
deleted file mode 100644
index 6710114cd..0000000
--- a/drivers/staging/pohmelfs/lock.c
+++ /dev/null
@@ -1,182 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/backing-dev.h>
-#include <linux/fs.h>
-#include <linux/fsnotify.h>
-#include <linux/mempool.h>
-
-#include "netfs.h"
-
-static int pohmelfs_send_lock_trans(struct pohmelfs_inode *pi,
-		u64 id, u64 start, u32 size, int type)
-{
-	struct inode *inode = &pi->vfs_inode;
-	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	struct netfs_trans *t;
-	struct netfs_cmd *cmd;
-	int path_len, err;
-	void *data;
-	struct netfs_lock *l;
-	int isize = (type & POHMELFS_LOCK_GRAB) ? 0 : sizeof(struct netfs_inode_info);
-
-	err = pohmelfs_path_length(pi);
-	if (err < 0)
-		goto err_out_exit;
-
-	path_len = err;
-
-	err = -ENOMEM;
-	t = netfs_trans_alloc(psb, path_len + sizeof(struct netfs_lock) + isize,
-			NETFS_TRANS_SINGLE_DST, 0);
-	if (!t)
-		goto err_out_exit;
-
-	cmd = netfs_trans_current(t);
-	data = cmd + 1;
-
-	err = pohmelfs_construct_path_string(pi, data, path_len);
-	if (err < 0)
-		goto err_out_free;
-	path_len = err;
-
-	l = data + path_len;
-
-	l->start = start;
-	l->size = size;
-	l->type = type;
-	l->ino = pi->ino;
-
-	cmd->cmd = NETFS_LOCK;
-	cmd->start = 0;
-	cmd->id = id;
-	cmd->size = sizeof(struct netfs_lock) + path_len + isize;
-	cmd->ext = path_len;
-	cmd->csize = 0;
-
-	netfs_convert_cmd(cmd);
-	netfs_convert_lock(l);
-
-	if (isize) {
-		struct netfs_inode_info *info = (struct netfs_inode_info *)(l + 1);
-
-		info->mode = inode->i_mode;
-		info->nlink = inode->i_nlink;
-		info->uid = inode->i_uid;
-		info->gid = inode->i_gid;
-		info->blocks = inode->i_blocks;
-		info->rdev = inode->i_rdev;
-		info->size = inode->i_size;
-		info->version = inode->i_version;
-
-		netfs_convert_inode_info(info);
-	}
-
-	netfs_trans_update(cmd, t, path_len + sizeof(struct netfs_lock) + isize);
-
-	return netfs_trans_finish(t, psb);
-
-err_out_free:
-	netfs_trans_free(t);
-err_out_exit:
-	printk("%s: err: %d.\n", __func__, err);
-	return err;
-}
-
-int pohmelfs_data_lock(struct pohmelfs_inode *pi, u64 start, u32 size, int type)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(pi->vfs_inode.i_sb);
-	struct pohmelfs_mcache *m;
-	int err = -ENOMEM;
-	struct iattr iattr;
-	struct inode *inode = &pi->vfs_inode;
-
-	dprintk("%s: %p: ino: %llu, start: %llu, size: %u, "
-			"type: %d, locked as: %d, owned: %d.\n",
-			__func__, &pi->vfs_inode, pi->ino,
-			start, size, type, pi->lock_type,
-			!!test_bit(NETFS_INODE_OWNED, &pi->state));
-
-	if (!pohmelfs_need_lock(pi, type))
-		return 0;
-
-	m = pohmelfs_mcache_alloc(psb, start, size, NULL);
-	if (IS_ERR(m))
-		return PTR_ERR(m);
-
-	err = pohmelfs_send_lock_trans(pi, m->gen, start, size,
-			type | POHMELFS_LOCK_GRAB);
-	if (err)
-		goto err_out_put;
-
-	err = wait_for_completion_timeout(&m->complete, psb->mcache_timeout);
-	if (err)
-		err = m->err;
-	else
-		err = -ETIMEDOUT;
-
-	if (err) {
-		printk("%s: %p: ino: %llu, mgen: %llu, start: %llu, size: %u, err: %d.\n",
-			__func__, &pi->vfs_inode, pi->ino, m->gen, start, size, err);
-	}
-
-	if (err && (err != -ENOENT))
-		goto err_out_put;
-
-	if (!err) {
-		netfs_convert_inode_info(&m->info);
-
-		iattr.ia_valid = ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_SIZE | ATTR_ATIME;
-		iattr.ia_mode = m->info.mode;
-		iattr.ia_uid = m->info.uid;
-		iattr.ia_gid = m->info.gid;
-		iattr.ia_size = m->info.size;
-		iattr.ia_atime = CURRENT_TIME;
-
-		dprintk("%s: %p: ino: %llu, mgen: %llu, start: %llu, isize: %llu -> %llu.\n",
-			__func__, &pi->vfs_inode, pi->ino, m->gen, start, inode->i_size, m->info.size);
-
-		err = pohmelfs_setattr_raw(inode, &iattr);
-		if (!err) {
-			struct dentry *dentry = d_find_alias(inode);
-			if (dentry) {
-				fsnotify_change(dentry, iattr.ia_valid);
-				dput(dentry);
-			}
-		}
-	}
-
-	pi->lock_type = type;
-	set_bit(NETFS_INODE_OWNED, &pi->state);
-
-	pohmelfs_mcache_put(psb, m);
-
-	return 0;
-
-err_out_put:
-	pohmelfs_mcache_put(psb, m);
-	return err;
-}
-
-int pohmelfs_data_unlock(struct pohmelfs_inode *pi, u64 start, u32 size, int type)
-{
-	dprintk("%s: %p: ino: %llu, start: %llu, size: %u, type: %d.\n",
-			__func__, &pi->vfs_inode, pi->ino, start, size, type);
-	pi->lock_type = 0;
-	clear_bit(NETFS_INODE_REMOTE_DIR_SYNCED, &pi->state);
-	clear_bit(NETFS_INODE_OWNED, &pi->state);
-	return pohmelfs_send_lock_trans(pi, pi->ino, start, size, type);
-}
diff --git a/drivers/staging/pohmelfs/mcache.c b/drivers/staging/pohmelfs/mcache.c
deleted file mode 100644
index e22665c..0000000
--- a/drivers/staging/pohmelfs/mcache.c
+++ /dev/null
@@ -1,171 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/mempool.h>
-
-#include "netfs.h"
-
-static struct kmem_cache *pohmelfs_mcache_cache;
-static mempool_t *pohmelfs_mcache_pool;
-
-static inline int pohmelfs_mcache_cmp(u64 gen, u64 new)
-{
-	if (gen < new)
-		return 1;
-	if (gen > new)
-		return -1;
-	return 0;
-}
-
-struct pohmelfs_mcache *pohmelfs_mcache_search(struct pohmelfs_sb *psb, u64 gen)
-{
-	struct rb_root *root = &psb->mcache_root;
-	struct rb_node *n = root->rb_node;
-	struct pohmelfs_mcache *tmp, *ret = NULL;
-	int cmp;
-
-	while (n) {
-		tmp = rb_entry(n, struct pohmelfs_mcache, mcache_entry);
-
-		cmp = pohmelfs_mcache_cmp(tmp->gen, gen);
-		if (cmp < 0)
-			n = n->rb_left;
-		else if (cmp > 0)
-			n = n->rb_right;
-		else {
-			ret = tmp;
-			pohmelfs_mcache_get(ret);
-			break;
-		}
-	}
-
-	return ret;
-}
-
-static int pohmelfs_mcache_insert(struct pohmelfs_sb *psb, struct pohmelfs_mcache *m)
-{
-	struct rb_root *root = &psb->mcache_root;
-	struct rb_node **n = &root->rb_node, *parent = NULL;
-	struct pohmelfs_mcache *ret = NULL, *tmp;
-	int cmp;
-
-	while (*n) {
-		parent = *n;
-
-		tmp = rb_entry(parent, struct pohmelfs_mcache, mcache_entry);
-
-		cmp = pohmelfs_mcache_cmp(tmp->gen, m->gen);
-		if (cmp < 0)
-			n = &parent->rb_left;
-		else if (cmp > 0)
-			n = &parent->rb_right;
-		else {
-			ret = tmp;
-			break;
-		}
-	}
-
-	if (ret)
-		return -EEXIST;
-
-	rb_link_node(&m->mcache_entry, parent, n);
-	rb_insert_color(&m->mcache_entry, root);
-
-	return 0;
-}
-
-static int pohmelfs_mcache_remove(struct pohmelfs_sb *psb, struct pohmelfs_mcache *m)
-{
-	if (m && m->mcache_entry.rb_parent_color) {
-		rb_erase(&m->mcache_entry, &psb->mcache_root);
-		m->mcache_entry.rb_parent_color = 0;
-		return 1;
-	}
-	return 0;
-}
-
-void pohmelfs_mcache_remove_locked(struct pohmelfs_sb *psb, struct pohmelfs_mcache *m)
-{
-	mutex_lock(&psb->mcache_lock);
-	pohmelfs_mcache_remove(psb, m);
-	mutex_unlock(&psb->mcache_lock);
-}
-
-struct pohmelfs_mcache *pohmelfs_mcache_alloc(struct pohmelfs_sb *psb, u64 start,
-		unsigned int size, void *data)
-{
-	struct pohmelfs_mcache *m;
-	int err = -ENOMEM;
-
-	m = mempool_alloc(pohmelfs_mcache_pool, GFP_KERNEL);
-	if (!m)
-		goto err_out_exit;
-
-	init_completion(&m->complete);
-	m->err = 0;
-	atomic_set(&m->refcnt, 1);
-	m->data = data;
-	m->start = start;
-	m->size = size;
-	m->gen = atomic_long_inc_return(&psb->mcache_gen);
-
-	mutex_lock(&psb->mcache_lock);
-	err = pohmelfs_mcache_insert(psb, m);
-	mutex_unlock(&psb->mcache_lock);
-	if (err)
-		goto err_out_free;
-
-	return m;
-
-err_out_free:
-	mempool_free(m, pohmelfs_mcache_pool);
-err_out_exit:
-	return ERR_PTR(err);
-}
-
-void pohmelfs_mcache_free(struct pohmelfs_sb *psb, struct pohmelfs_mcache *m)
-{
-	pohmelfs_mcache_remove_locked(psb, m);
-
-	mempool_free(m, pohmelfs_mcache_pool);
-}
-
-int __init pohmelfs_mcache_init(void)
-{
-	pohmelfs_mcache_cache = kmem_cache_create("pohmelfs_mcache_cache",
-				sizeof(struct pohmelfs_mcache),
-				0, (SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD), NULL);
-	if (!pohmelfs_mcache_cache)
-		goto err_out_exit;
-
-	pohmelfs_mcache_pool = mempool_create_slab_pool(256, pohmelfs_mcache_cache);
-	if (!pohmelfs_mcache_pool)
-		goto err_out_free;
-
-	return 0;
-
-err_out_free:
-	kmem_cache_destroy(pohmelfs_mcache_cache);
-err_out_exit:
-	return -ENOMEM;
-}
-
-void pohmelfs_mcache_exit(void)
-{
-	mempool_destroy(pohmelfs_mcache_pool);
-	kmem_cache_destroy(pohmelfs_mcache_cache);
-}
diff --git a/drivers/staging/pohmelfs/net.c b/drivers/staging/pohmelfs/net.c
deleted file mode 100644
index b2e9186..0000000
--- a/drivers/staging/pohmelfs/net.c
+++ /dev/null
@@ -1,1209 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/fsnotify.h>
-#include <linux/jhash.h>
-#include <linux/in.h>
-#include <linux/in6.h>
-#include <linux/kthread.h>
-#include <linux/pagemap.h>
-#include <linux/poll.h>
-#include <linux/slab.h>
-#include <linux/swap.h>
-#include <linux/syscalls.h>
-#include <linux/vmalloc.h>
-
-#include "netfs.h"
-
-/*
- * Async machinery lives here.
- * All commands being sent to server do _not_ require sync reply,
- * instead, if it is really needed, like readdir or readpage, caller
- * sleeps waiting for data, which will be placed into provided buffer
- * and caller will be awakened.
- *
- * Every command response can come without some listener. For example
- * readdir response will add new objects into cache without appropriate
- * request from userspace. This is used in cache coherency.
- *
- * If object is not found for given data, it is discarded.
- *
- * All requests are received by dedicated kernel thread.
- */
-
-/*
- * Basic network sending/receiving functions.
- * Blocked mode is used.
- */
-static int netfs_data_recv(struct netfs_state *st, void *buf, u64 size)
-{
-	struct msghdr msg;
-	struct kvec iov;
-	int err;
-
-	BUG_ON(!size);
-
-	iov.iov_base = buf;
-	iov.iov_len = size;
-
-	msg.msg_iov = (struct iovec *)&iov;
-	msg.msg_iovlen = 1;
-	msg.msg_name = NULL;
-	msg.msg_namelen = 0;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_flags = MSG_DONTWAIT;
-
-	err = kernel_recvmsg(st->socket, &msg, &iov, 1, iov.iov_len,
-			msg.msg_flags);
-	if (err <= 0) {
-		printk("%s: failed to recv data: size: %llu, err: %d.\n", __func__, size, err);
-		if (err == 0)
-			err = -ECONNRESET;
-	}
-
-	return err;
-}
-
-static int pohmelfs_data_recv(struct netfs_state *st, void *data, unsigned int size)
-{
-	unsigned int revents = 0;
-	unsigned int err_mask = POLLERR | POLLHUP | POLLRDHUP;
-	unsigned int mask = err_mask | POLLIN;
-	int err = 0;
-
-	while (size && !err) {
-		revents = netfs_state_poll(st);
-
-		if (!(revents & mask)) {
-			DEFINE_WAIT(wait);
-
-			for (;;) {
-				prepare_to_wait(&st->thread_wait, &wait, TASK_INTERRUPTIBLE);
-				if (kthread_should_stop())
-					break;
-
-				revents = netfs_state_poll(st);
-
-				if (revents & mask)
-					break;
-
-				if (signal_pending(current))
-					break;
-
-				schedule();
-				continue;
-			}
-			finish_wait(&st->thread_wait, &wait);
-		}
-
-		err = 0;
-		netfs_state_lock(st);
-		if (st->socket && (st->read_socket == st->socket) && (revents & POLLIN)) {
-			err = netfs_data_recv(st, data, size);
-			if (err > 0) {
-				data += err;
-				size -= err;
-				err = 0;
-			} else if (err == 0)
-				err = -ECONNRESET;
-		}
-
-		if (revents & err_mask) {
-			printk("%s: revents: %x, socket: %p, size: %u, err: %d.\n",
-					__func__, revents, st->socket, size, err);
-			err = -ECONNRESET;
-		}
-		netfs_state_unlock(st);
-
-		if (err < 0) {
-			if (netfs_state_trylock_send(st)) {
-				netfs_state_exit(st);
-				err = netfs_state_init(st);
-				if (!err)
-					err = -EAGAIN;
-				netfs_state_unlock_send(st);
-			} else {
-				st->need_reset = 1;
-			}
-		}
-
-		if (kthread_should_stop())
-			err = -ENODEV;
-
-		if (err)
-			printk("%s: socket: %p, read_socket: %p, revents: %x, rev_error: %d, "
-					"should_stop: %d, size: %u, err: %d.\n",
-				__func__, st->socket, st->read_socket,
-				revents, revents & err_mask, kthread_should_stop(), size, err);
-	}
-
-	return err;
-}
-
-int pohmelfs_data_recv_and_check(struct netfs_state *st, void *data, unsigned int size)
-{
-	struct netfs_cmd *cmd = &st->cmd;
-	int err;
-
-	err = pohmelfs_data_recv(st, data, size);
-	if (err)
-		return err;
-
-	return pohmelfs_crypto_process_input_data(&st->eng, cmd->iv, data, NULL, size);
-}
-
-/*
- * Polling machinery.
- */
-
-struct netfs_poll_helper {
-	poll_table 		pt;
-	struct netfs_state	*st;
-};
-
-static int netfs_queue_wake(wait_queue_t *wait, unsigned mode, int sync, void *key)
-{
-	struct netfs_state *st = container_of(wait, struct netfs_state, wait);
-
-	wake_up(&st->thread_wait);
-	return 1;
-}
-
-static void netfs_queue_func(struct file *file, wait_queue_head_t *whead,
-				 poll_table *pt)
-{
-	struct netfs_state *st = container_of(pt, struct netfs_poll_helper, pt)->st;
-
-	st->whead = whead;
-	init_waitqueue_func_entry(&st->wait, netfs_queue_wake);
-	add_wait_queue(whead, &st->wait);
-}
-
-static void netfs_poll_exit(struct netfs_state *st)
-{
-	if (st->whead) {
-		remove_wait_queue(st->whead, &st->wait);
-		st->whead = NULL;
-	}
-}
-
-static int netfs_poll_init(struct netfs_state *st)
-{
-	struct netfs_poll_helper ph;
-
-	ph.st = st;
-	init_poll_funcptr(&ph.pt, &netfs_queue_func);
-
-	st->socket->ops->poll(NULL, st->socket, &ph.pt);
-	return 0;
-}
-
-/*
- * Get response for readpage command. We search inode and page in its mapping
- * and copy data into. If it was async request, then we queue page into shared
- * data and wakeup listener, who will copy it to userspace.
- *
- * There is a work in progress of allowing to call copy_to_user() directly from
- * async receiving kernel thread.
- */
-static int pohmelfs_read_page_response(struct netfs_state *st)
-{
-	struct pohmelfs_sb *psb = st->psb;
-	struct netfs_cmd *cmd = &st->cmd;
-	struct inode *inode;
-	struct page *page;
-	int err = 0;
-
-	if (cmd->size > PAGE_CACHE_SIZE) {
-		err = -EINVAL;
-		goto err_out_exit;
-	}
-
-	inode = ilookup(st->psb->sb, cmd->id);
-	if (!inode) {
-		printk("%s: failed to find inode: id: %llu.\n", __func__, cmd->id);
-		err = -ENOENT;
-		goto err_out_exit;
-	}
-
-	page = find_get_page(inode->i_mapping, cmd->start >> PAGE_CACHE_SHIFT);
-	if (!page || !PageLocked(page)) {
-		printk("%s: failed to find/lock page: page: %p, id: %llu, start: %llu, index: %llu.\n",
-				__func__, page, cmd->id, cmd->start, cmd->start >> PAGE_CACHE_SHIFT);
-
-		while (cmd->size) {
-			unsigned int sz = min(cmd->size, st->size);
-
-			err = pohmelfs_data_recv(st, st->data, sz);
-			if (err)
-				break;
-
-			cmd->size -= sz;
-		}
-
-		err = -ENODEV;
-		if (page)
-			goto err_out_page_put;
-		goto err_out_put;
-	}
-
-	if (cmd->size) {
-		void *addr;
-
-		addr = kmap(page);
-		err = pohmelfs_data_recv(st, addr, cmd->size);
-		kunmap(page);
-
-		if (err)
-			goto err_out_page_unlock;
-	}
-
-	dprintk("%s: page: %p, start: %llu, size: %u, locked: %d.\n",
-		__func__, page, cmd->start, cmd->size, PageLocked(page));
-
-	SetPageChecked(page);
-	if ((psb->hash_string || psb->cipher_string) && psb->perform_crypto && cmd->size) {
-		err = pohmelfs_crypto_process_input_page(&st->eng, page, cmd->size, cmd->iv);
-		if (err < 0)
-			goto err_out_page_unlock;
-	} else {
-		SetPageUptodate(page);
-		unlock_page(page);
-		page_cache_release(page);
-	}
-
-	pohmelfs_put_inode(POHMELFS_I(inode));
-	wake_up(&st->psb->wait);
-
-	return 0;
-
-err_out_page_unlock:
-	SetPageError(page);
-	unlock_page(page);
-err_out_page_put:
-	page_cache_release(page);
-err_out_put:
-	pohmelfs_put_inode(POHMELFS_I(inode));
-err_out_exit:
-	wake_up(&st->psb->wait);
-	return err;
-}
-
-static int pohmelfs_check_name(struct pohmelfs_inode *parent, struct qstr *str,
-		struct netfs_inode_info *info)
-{
-	struct inode *inode;
-	struct pohmelfs_name *n;
-	int err = 0;
-	u64 ino = 0;
-
-	mutex_lock(&parent->offset_lock);
-	n = pohmelfs_search_hash(parent, str->hash);
-	if (n)
-		ino = n->ino;
-	mutex_unlock(&parent->offset_lock);
-
-	if (!ino)
-		goto out;
-
-	inode = ilookup(parent->vfs_inode.i_sb, ino);
-	if (!inode)
-		goto out;
-
-	dprintk("%s: parent: %llu, inode: %llu.\n", __func__, parent->ino, ino);
-
-	pohmelfs_fill_inode(inode, info);
-	pohmelfs_put_inode(POHMELFS_I(inode));
-	err = -EEXIST;
-out:
-	return err;
-}
-
-/*
- * Readdir response from server. If special field is set, we wakeup
- * listener (readdir() call), which will copy data to userspace.
- */
-static int pohmelfs_readdir_response(struct netfs_state *st)
-{
-	struct inode *inode;
-	struct netfs_cmd *cmd = &st->cmd;
-	struct netfs_inode_info *info;
-	struct pohmelfs_inode *parent = NULL, *npi;
-	int err = 0, last = cmd->ext;
-	struct qstr str;
-
-	if (cmd->size > st->size)
-		return -EINVAL;
-
-	inode = ilookup(st->psb->sb, cmd->id);
-	if (!inode) {
-		printk("%s: failed to find inode: id: %llu.\n", __func__, cmd->id);
-		return -ENOENT;
-	}
-	parent = POHMELFS_I(inode);
-
-	if (!cmd->size && cmd->start) {
-		err = -cmd->start;
-		goto out;
-	}
-
-	if (cmd->size) {
-		char *name;
-
-		err = pohmelfs_data_recv_and_check(st, st->data, cmd->size);
-		if (err)
-			goto err_out_put;
-
-		info = (struct netfs_inode_info *)(st->data);
-
-		name = (char *)(info + 1);
-		str.len = cmd->size - sizeof(struct netfs_inode_info) - 1 - cmd->cpad;
-		name[str.len] = 0;
-		str.name = name;
-		str.hash = jhash(str.name, str.len, 0);
-
-		netfs_convert_inode_info(info);
-
-		if (parent) {
-			err = pohmelfs_check_name(parent, &str, info);
-			if (err) {
-				if (err == -EEXIST)
-					err = 0;
-				goto out;
-			}
-		}
-
-		info->ino = cmd->start;
-		if (!info->ino)
-			info->ino = pohmelfs_new_ino(st->psb);
-
-		dprintk("%s: parent: %llu, ino: %llu, name: '%s', hash: %x, len: %u, mode: %o.\n",
-				__func__, parent->ino, info->ino, str.name, str.hash, str.len,
-				info->mode);
-
-		npi = pohmelfs_new_inode(st->psb, parent, &str, info, 0);
-		if (IS_ERR(npi)) {
-			err = PTR_ERR(npi);
-
-			if (err != -EEXIST)
-				goto err_out_put;
-		} else {
-			struct dentry *dentry, *alias, *pd;
-
-			set_bit(NETFS_INODE_REMOTE_SYNCED, &npi->state);
-			clear_bit(NETFS_INODE_OWNED, &npi->state);
-
-			pd = d_find_alias(&parent->vfs_inode);
-			if (pd) {
-				str.hash = full_name_hash(str.name, str.len);
-				dentry = d_alloc(pd, &str);
-				if (dentry) {
-					alias = d_materialise_unique(dentry, &npi->vfs_inode);
-					if (alias)
-						dput(alias);
-				}
-
-				dput(dentry);
-				dput(pd);
-			}
-		}
-	}
-out:
-	if (last) {
-		set_bit(NETFS_INODE_REMOTE_DIR_SYNCED, &parent->state);
-		set_bit(NETFS_INODE_REMOTE_SYNCED, &parent->state);
-		wake_up(&st->psb->wait);
-	}
-	pohmelfs_put_inode(parent);
-
-	return err;
-
-err_out_put:
-	clear_bit(NETFS_INODE_REMOTE_DIR_SYNCED, &parent->state);
-	printk("%s: parent: %llu, ino: %llu, cmd_id: %llu.\n", __func__, parent->ino, cmd->start, cmd->id);
-	pohmelfs_put_inode(parent);
-	wake_up(&st->psb->wait);
-	return err;
-}
-
-/*
- * Lookup command response.
- * It searches for inode to be looked at (if it exists) and substitutes
- * its inode information (size, permission, mode and so on), if inode does
- * not exist, new one will be created and inserted into caches.
- */
-static int pohmelfs_lookup_response(struct netfs_state *st)
-{
-	struct inode *inode = NULL;
-	struct netfs_cmd *cmd = &st->cmd;
-	struct netfs_inode_info *info;
-	struct pohmelfs_inode *parent = NULL, *npi;
-	int err = -EINVAL;
-	char *name;
-
-	inode = ilookup(st->psb->sb, cmd->id);
-	if (!inode) {
-		printk("%s: lookup response: id: %llu, start: %llu, size: %u.\n",
-				__func__, cmd->id, cmd->start, cmd->size);
-		err = -ENOENT;
-		goto err_out_exit;
-	}
-	parent = POHMELFS_I(inode);
-
-	if (!cmd->size) {
-		err = -cmd->start;
-		goto err_out_put;
-	}
-
-	if (cmd->size < sizeof(struct netfs_inode_info)) {
-		printk("%s: broken lookup response: id: %llu, start: %llu, size: %u.\n",
-				__func__, cmd->id, cmd->start, cmd->size);
-		err = -EINVAL;
-		goto err_out_put;
-	}
-
-	err = pohmelfs_data_recv_and_check(st, st->data, cmd->size);
-	if (err)
-		goto err_out_put;
-
-	info = (struct netfs_inode_info *)(st->data);
-	name = (char *)(info + 1);
-
-	netfs_convert_inode_info(info);
-
-	info->ino = cmd->start;
-	if (!info->ino)
-		info->ino = pohmelfs_new_ino(st->psb);
-
-	dprintk("%s: parent: %llu, ino: %llu, name: '%s', start: %llu.\n",
-			__func__, parent->ino, info->ino, name, cmd->start);
-
-	if (cmd->start)
-		npi = pohmelfs_new_inode(st->psb, parent, NULL, info, 0);
-	else {
-		struct qstr str;
-
-		str.name = name;
-		str.len = cmd->size - sizeof(struct netfs_inode_info) - 1 - cmd->cpad;
-		str.hash = jhash(name, str.len, 0);
-
-		npi = pohmelfs_new_inode(st->psb, parent, &str, info, 0);
-	}
-	if (IS_ERR(npi)) {
-		err = PTR_ERR(npi);
-
-		if (err != -EEXIST)
-			goto err_out_put;
-	} else {
-		set_bit(NETFS_INODE_REMOTE_SYNCED, &npi->state);
-		clear_bit(NETFS_INODE_OWNED, &npi->state);
-	}
-
-	clear_bit(NETFS_COMMAND_PENDING, &parent->state);
-	pohmelfs_put_inode(parent);
-
-	wake_up(&st->psb->wait);
-
-	return 0;
-
-err_out_put:
-	pohmelfs_put_inode(parent);
-err_out_exit:
-	clear_bit(NETFS_COMMAND_PENDING, &parent->state);
-	wake_up(&st->psb->wait);
-	printk("%s: inode: %p, id: %llu, start: %llu, size: %u, err: %d.\n",
-			__func__, inode, cmd->id, cmd->start, cmd->size, err);
-	return err;
-}
-
-/*
- * Create response, just marks local inode as 'created', so that writeback
- * for any of its children (or own) would not try to sync it again.
- */
-static int pohmelfs_create_response(struct netfs_state *st)
-{
-	struct inode *inode;
-	struct netfs_cmd *cmd = &st->cmd;
-	struct pohmelfs_inode *pi;
-
-	inode = ilookup(st->psb->sb, cmd->id);
-	if (!inode) {
-		printk("%s: failed to find inode: id: %llu, start: %llu.\n",
-				__func__, cmd->id, cmd->start);
-		goto err_out_exit;
-	}
-
-	pi = POHMELFS_I(inode);
-
-	/*
-	 * To lock or not to lock?
-	 * We actually do not care if it races...
-	 */
-	if (cmd->start)
-		make_bad_inode(inode);
-	set_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state);
-
-	pohmelfs_put_inode(pi);
-
-	wake_up(&st->psb->wait);
-	return 0;
-
-err_out_exit:
-	wake_up(&st->psb->wait);
-	return -ENOENT;
-}
-
-/*
- * Object remove response. Just says that remove request has been received.
- * Used in cache coherency protocol.
- */
-static int pohmelfs_remove_response(struct netfs_state *st)
-{
-	struct netfs_cmd *cmd = &st->cmd;
-	int err;
-
-	err = pohmelfs_data_recv_and_check(st, st->data, cmd->size);
-	if (err)
-		return err;
-
-	dprintk("%s: parent: %llu, path: '%s'.\n", __func__, cmd->id, (char *)st->data);
-
-	return 0;
-}
-
-/*
- * Transaction reply processing.
- *
- * Find transaction based on its generation number, bump its reference counter,
- * so that none could free it under us, drop from the trees and lists and
- * drop reference counter. When it hits zero (when all destinations replied
- * and all timeout handled by async scanning code), completion will be called
- * and transaction will be freed.
- */
-static int pohmelfs_transaction_response(struct netfs_state *st)
-{
-	struct netfs_trans_dst *dst;
-	struct netfs_trans *t = NULL;
-	struct netfs_cmd *cmd = &st->cmd;
-	short err = (signed)cmd->ext;
-
-	mutex_lock(&st->trans_lock);
-	dst = netfs_trans_search(st, cmd->start);
-	if (dst) {
-		netfs_trans_remove_nolock(dst, st);
-		t = dst->trans;
-	}
-	mutex_unlock(&st->trans_lock);
-
-	if (!t) {
-		printk("%s: failed to find transaction: start: %llu: id: %llu, size: %u, ext: %u.\n",
-				__func__, cmd->start, cmd->id, cmd->size, cmd->ext);
-		err = -EINVAL;
-		goto out;
-	}
-
-	t->result = err;
-	netfs_trans_drop_dst_nostate(dst);
-
-out:
-	wake_up(&st->psb->wait);
-	return err;
-}
-
-/*
- * Inode metadata cache coherency message.
- */
-static int pohmelfs_page_cache_response(struct netfs_state *st)
-{
-	struct netfs_cmd *cmd = &st->cmd;
-	struct inode *inode;
-
-	dprintk("%s: st: %p, id: %llu, start: %llu, size: %u.\n", __func__, st, cmd->id, cmd->start, cmd->size);
-
-	inode = ilookup(st->psb->sb, cmd->id);
-	if (!inode) {
-		printk("%s: failed to find inode: id: %llu.\n", __func__, cmd->id);
-		return -ENOENT;
-	}
-
-	set_bit(NETFS_INODE_NEED_FLUSH, &POHMELFS_I(inode)->state);
-	pohmelfs_put_inode(POHMELFS_I(inode));
-
-	return 0;
-}
-
-/*
- * Root capabilities response: export statistics
- * like used and available size, number of files and dirs,
- * permissions.
- */
-static int pohmelfs_root_cap_response(struct netfs_state *st)
-{
-	struct netfs_cmd *cmd = &st->cmd;
-	struct netfs_root_capabilities *cap;
-	struct pohmelfs_sb *psb = st->psb;
-
-	if (cmd->size != sizeof(struct netfs_root_capabilities)) {
-		psb->flags = EPROTO;
-		wake_up(&psb->wait);
-		return -EPROTO;
-	}
-
-	cap = st->data;
-
-	netfs_convert_root_capabilities(cap);
-
-	if (psb->total_size < cap->used + cap->avail)
-		psb->total_size = cap->used + cap->avail;
-	if (cap->avail)
-		psb->avail_size = cap->avail;
-	psb->state_flags = cap->flags;
-
-	if (psb->state_flags & POHMELFS_FLAGS_RO) {
-		psb->sb->s_flags |= MS_RDONLY;
-		printk(KERN_INFO "Mounting POHMELFS (%d) read-only.\n", psb->idx);
-	}
-
-	if (psb->state_flags & POHMELFS_FLAGS_XATTR)
-		printk(KERN_INFO "Mounting POHMELFS (%d) "
-			"with extended attributes support.\n", psb->idx);
-
-	if (atomic_long_read(&psb->total_inodes) <= 1)
-		atomic_long_set(&psb->total_inodes, cap->nr_files);
-
-	dprintk("%s: total: %llu, avail: %llu, flags: %llx, inodes: %llu.\n",
-		__func__, psb->total_size, psb->avail_size, psb->state_flags, cap->nr_files);
-
-	psb->flags = 0;
-	wake_up(&psb->wait);
-	return 0;
-}
-
-/*
- * Crypto capabilities of the server, where it says that
- * it supports or does not requested hash/cipher algorithms.
- */
-static int pohmelfs_crypto_cap_response(struct netfs_state *st)
-{
-	struct netfs_cmd *cmd = &st->cmd;
-	struct netfs_crypto_capabilities *cap;
-	struct pohmelfs_sb *psb = st->psb;
-	int err = 0;
-
-	if (cmd->size != sizeof(struct netfs_crypto_capabilities)) {
-		psb->flags = EPROTO;
-		wake_up(&psb->wait);
-		return -EPROTO;
-	}
-
-	cap = st->data;
-
-	dprintk("%s: cipher '%s': %s, hash: '%s': %s.\n",
-			__func__,
-			psb->cipher_string, (cap->cipher_strlen) ? "SUPPORTED" : "NOT SUPPORTED",
-			psb->hash_string, (cap->hash_strlen) ? "SUPPORTED" : "NOT SUPPORTED");
-
-	if (!cap->hash_strlen) {
-		if (psb->hash_strlen && psb->crypto_fail_unsupported)
-			err = -ENOTSUPP;
-		psb->hash_strlen = 0;
-		kfree(psb->hash_string);
-		psb->hash_string = NULL;
-	}
-
-	if (!cap->cipher_strlen) {
-		if (psb->cipher_strlen && psb->crypto_fail_unsupported)
-			err = -ENOTSUPP;
-		psb->cipher_strlen = 0;
-		kfree(psb->cipher_string);
-		psb->cipher_string = NULL;
-	}
-
-	return err;
-}
-
-/*
- * Capabilities handshake response.
- */
-static int pohmelfs_capabilities_response(struct netfs_state *st)
-{
-	struct netfs_cmd *cmd = &st->cmd;
-	int err = 0;
-
-	err = pohmelfs_data_recv(st, st->data, cmd->size);
-	if (err)
-		return err;
-
-	switch (cmd->id) {
-	case POHMELFS_CRYPTO_CAPABILITIES:
-			return pohmelfs_crypto_cap_response(st);
-	case POHMELFS_ROOT_CAPABILITIES:
-			return pohmelfs_root_cap_response(st);
-	default:
-			break;
-	}
-	return -EINVAL;
-}
-
-/*
- * Receiving extended attribute.
- * Does not work properly if received size is more than requested one,
- * it should not happen with current request/reply model though.
- */
-static int pohmelfs_getxattr_response(struct netfs_state *st)
-{
-	struct pohmelfs_sb *psb = st->psb;
-	struct netfs_cmd *cmd = &st->cmd;
-	struct pohmelfs_mcache *m;
-	short error = (signed short)cmd->ext, err;
-	unsigned int sz, total_size;
-
-	m = pohmelfs_mcache_search(psb, cmd->id);
-
-	dprintk("%s: id: %llu, gen: %llu, err: %d.\n",
-		__func__, cmd->id, (m) ? m->gen : 0, error);
-
-	if (!m) {
-		printk("%s: failed to find getxattr cache entry: id: %llu.\n", __func__, cmd->id);
-		return -ENOENT;
-	}
-
-	if (cmd->size) {
-		sz = min_t(unsigned int, cmd->size, m->size);
-		err = pohmelfs_data_recv_and_check(st, m->data, sz);
-		if (err) {
-			error = err;
-			goto out;
-		}
-
-		m->size = sz;
-		total_size = cmd->size - sz;
-
-		while (total_size) {
-			sz = min(total_size, st->size);
-
-			err = pohmelfs_data_recv_and_check(st, st->data, sz);
-			if (err) {
-				error = err;
-				break;
-			}
-
-			total_size -= sz;
-		}
-	}
-
-out:
-	m->err = error;
-	complete(&m->complete);
-	pohmelfs_mcache_put(psb, m);
-
-	return error;
-}
-
-int pohmelfs_data_lock_response(struct netfs_state *st)
-{
-	struct pohmelfs_sb *psb = st->psb;
-	struct netfs_cmd *cmd = &st->cmd;
-	struct pohmelfs_mcache *m;
-	short err = (signed short)cmd->ext;
-	u64 id = cmd->id;
-
-	m = pohmelfs_mcache_search(psb, id);
-
-	dprintk("%s: id: %llu, gen: %llu, err: %d.\n",
-		__func__, cmd->id, (m) ? m->gen : 0, err);
-
-	if (!m) {
-		pohmelfs_data_recv(st, st->data, cmd->size);
-		printk("%s: failed to find data lock response: id: %llu.\n", __func__, cmd->id);
-		return -ENOENT;
-	}
-
-	if (cmd->size)
-		err = pohmelfs_data_recv_and_check(st, &m->info, cmd->size);
-
-	m->err = err;
-	complete(&m->complete);
-	pohmelfs_mcache_put(psb, m);
-
-	return err;
-}
-
-static void __inline__ netfs_state_reset(struct netfs_state *st)
-{
-	netfs_state_lock_send(st);
-	netfs_state_exit(st);
-	netfs_state_init(st);
-	netfs_state_unlock_send(st);
-}
-
-/*
- * Main receiving function, called from dedicated kernel thread.
- */
-static int pohmelfs_recv(void *data)
-{
-	int err = -EINTR;
-	struct netfs_state *st = data;
-	struct netfs_cmd *cmd = &st->cmd;
-
-	while (!kthread_should_stop()) {
-		/*
-		 * If socket will be reset after this statement, then
-		 * pohmelfs_data_recv() will just fail and loop will
-		 * start again, so it can be done without any locks.
-		 *
-		 * st->read_socket is needed to prevents state machine
-		 * breaking between this data reading and subsequent one
-		 * in protocol specific functions during connection reset.
-		 * In case of reset we have to read next command and do
-		 * not expect data for old command to magically appear in
-		 * new connection.
-		 */
-		st->read_socket = st->socket;
-		err = pohmelfs_data_recv(st, cmd, sizeof(struct netfs_cmd));
-		if (err) {
-			msleep(1000);
-			continue;
-		}
-
-		netfs_convert_cmd(cmd);
-
-		dprintk("%s: cmd: %u, id: %llu, start: %llu, size: %u, "
-				"ext: %u, csize: %u, cpad: %u.\n",
-				__func__, cmd->cmd, cmd->id, cmd->start,
-				cmd->size, cmd->ext, cmd->csize, cmd->cpad);
-
-		if (cmd->csize) {
-			struct pohmelfs_crypto_engine *e = &st->eng;
-
-			if (unlikely(cmd->csize > e->size/2)) {
-				netfs_state_reset(st);
-				continue;
-			}
-
-			if (e->hash && unlikely(cmd->csize != st->psb->crypto_attached_size)) {
-				dprintk("%s: cmd: cmd: %u, id: %llu, start: %llu, size: %u, "
-						"csize: %u != digest size %u.\n",
-						__func__, cmd->cmd, cmd->id, cmd->start, cmd->size,
-						cmd->csize, st->psb->crypto_attached_size);
-				netfs_state_reset(st);
-				continue;
-			}
-
-			err = pohmelfs_data_recv(st, e->data, cmd->csize);
-			if (err) {
-				netfs_state_reset(st);
-				continue;
-			}
-
-#ifdef CONFIG_POHMELFS_DEBUG
-			{
-				unsigned int i;
-				unsigned char *hash = e->data;
-
-				dprintk("%s: received hash: ", __func__);
-				for (i = 0; i < cmd->csize; ++i)
-					printk("%02x ", hash[i]);
-
-				printk("\n");
-			}
-#endif
-			cmd->size -= cmd->csize;
-		}
-
-		/*
-		 * This should catch protocol breakage and random garbage instead of commands.
-		 */
-		if (unlikely((cmd->size > st->size) && (cmd->cmd != NETFS_XATTR_GET))) {
-			netfs_state_reset(st);
-			continue;
-		}
-
-		switch (cmd->cmd) {
-		case NETFS_READ_PAGE:
-				err = pohmelfs_read_page_response(st);
-				break;
-		case NETFS_READDIR:
-				err = pohmelfs_readdir_response(st);
-				break;
-		case NETFS_LOOKUP:
-				err = pohmelfs_lookup_response(st);
-				break;
-		case NETFS_CREATE:
-				err = pohmelfs_create_response(st);
-				break;
-		case NETFS_REMOVE:
-				err = pohmelfs_remove_response(st);
-				break;
-		case NETFS_TRANS:
-				err = pohmelfs_transaction_response(st);
-				break;
-		case NETFS_PAGE_CACHE:
-				err = pohmelfs_page_cache_response(st);
-				break;
-		case NETFS_CAPABILITIES:
-				err = pohmelfs_capabilities_response(st);
-				break;
-		case NETFS_LOCK:
-				err = pohmelfs_data_lock_response(st);
-				break;
-		case NETFS_XATTR_GET:
-				err = pohmelfs_getxattr_response(st);
-				break;
-		default:
-				printk("%s: wrong cmd: %u, id: %llu, start: %llu, size: %u, ext: %u.\n",
-					__func__, cmd->cmd, cmd->id, cmd->start, cmd->size, cmd->ext);
-				netfs_state_reset(st);
-				break;
-		}
-	}
-
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(msecs_to_jiffies(10));
-
-	return err;
-}
-
-int netfs_state_init(struct netfs_state *st)
-{
-	int err;
-	struct pohmelfs_ctl *ctl = &st->ctl;
-
-	err = sock_create(ctl->addr.sa_family, ctl->type, ctl->proto, &st->socket);
-	if (err) {
-		printk("%s: failed to create a socket: family: %d, type: %d, proto: %d, err: %d.\n",
-				__func__, ctl->addr.sa_family, ctl->type, ctl->proto, err);
-		goto err_out_exit;
-	}
-
-	st->socket->sk->sk_allocation = GFP_NOIO;
-	st->socket->sk->sk_sndtimeo = st->socket->sk->sk_rcvtimeo = msecs_to_jiffies(60000);
-
-	err = kernel_connect(st->socket, (struct sockaddr *)&ctl->addr, ctl->addrlen, 0);
-	if (err) {
-		printk("%s: failed to connect to server: idx: %u, err: %d.\n",
-				__func__, st->psb->idx, err);
-		goto err_out_release;
-	}
-	st->socket->sk->sk_sndtimeo = st->socket->sk->sk_rcvtimeo = msecs_to_jiffies(60000);
-
-	err = netfs_poll_init(st);
-	if (err)
-		goto err_out_release;
-
-	if (st->socket->ops->family == AF_INET) {
-		struct sockaddr_in *sin = (struct sockaddr_in *)&ctl->addr;
-		printk(KERN_INFO "%s: (re)connected to peer %pi4:%d.\n", __func__,
-			&sin->sin_addr.s_addr, ntohs(sin->sin_port));
-	} else if (st->socket->ops->family == AF_INET6) {
-		struct sockaddr_in6 *sin = (struct sockaddr_in6 *)&ctl->addr;
-		printk(KERN_INFO "%s: (re)connected to peer %pi6:%d", __func__,
-				&sin->sin6_addr, ntohs(sin->sin6_port));
-	}
-
-	return 0;
-
-err_out_release:
-	sock_release(st->socket);
-err_out_exit:
-	st->socket = NULL;
-	return err;
-}
-
-void netfs_state_exit(struct netfs_state *st)
-{
-	if (st->socket) {
-		netfs_poll_exit(st);
-		st->socket->ops->shutdown(st->socket, 2);
-
-		if (st->socket->ops->family == AF_INET) {
-			struct sockaddr_in *sin = (struct sockaddr_in *)&st->ctl.addr;
-			printk(KERN_INFO "%s: disconnected from peer %pi4:%d.\n", __func__,
-				&sin->sin_addr.s_addr, ntohs(sin->sin_port));
-		} else if (st->socket->ops->family == AF_INET6) {
-			struct sockaddr_in6 *sin = (struct sockaddr_in6 *)&st->ctl.addr;
-			printk(KERN_INFO "%s: disconnected from peer %pi6:%d", __func__,
-				&sin->sin6_addr, ntohs(sin->sin6_port));
-		}
-
-		sock_release(st->socket);
-		st->socket = NULL;
-		st->read_socket = NULL;
-		st->need_reset = 0;
-	}
-}
-
-int pohmelfs_state_init_one(struct pohmelfs_sb *psb, struct pohmelfs_config *conf)
-{
-	struct netfs_state *st = &conf->state;
-	int err = -ENOMEM;
-
-	mutex_init(&st->__state_lock);
-	mutex_init(&st->__state_send_lock);
-	init_waitqueue_head(&st->thread_wait);
-
-	st->psb = psb;
-	st->trans_root = RB_ROOT;
-	mutex_init(&st->trans_lock);
-
-	st->size = psb->trans_data_size;
-	st->data = kmalloc(st->size, GFP_KERNEL);
-	if (!st->data)
-		goto err_out_exit;
-
-	if (psb->perform_crypto) {
-		err = pohmelfs_crypto_engine_init(&st->eng, psb);
-		if (err)
-			goto err_out_free_data;
-	}
-
-	err = netfs_state_init(st);
-	if (err)
-		goto err_out_free_engine;
-
-	st->thread = kthread_run(pohmelfs_recv, st, "pohmelfs/%u", psb->idx);
-	if (IS_ERR(st->thread)) {
-		err = PTR_ERR(st->thread);
-		goto err_out_netfs_exit;
-	}
-
-	if (!psb->active_state)
-		psb->active_state = conf;
-
-	dprintk("%s: conf: %p, st: %p, socket: %p.\n",
-			__func__, conf, st, st->socket);
-	return 0;
-
-err_out_netfs_exit:
-	netfs_state_exit(st);
-err_out_free_engine:
-	pohmelfs_crypto_engine_exit(&st->eng);
-err_out_free_data:
-	kfree(st->data);
-err_out_exit:
-	return err;
-
-}
-
-void pohmelfs_state_flush_transactions(struct netfs_state *st)
-{
-	struct rb_node *rb_node;
-	struct netfs_trans_dst *dst;
-
-	mutex_lock(&st->trans_lock);
-	for (rb_node = rb_first(&st->trans_root); rb_node; ) {
-		dst = rb_entry(rb_node, struct netfs_trans_dst, state_entry);
-		rb_node = rb_next(rb_node);
-
-		dst->trans->result = -EINVAL;
-		netfs_trans_remove_nolock(dst, st);
-		netfs_trans_drop_dst_nostate(dst);
-	}
-	mutex_unlock(&st->trans_lock);
-}
-
-static void pohmelfs_state_exit_one(struct pohmelfs_config *c)
-{
-	struct netfs_state *st = &c->state;
-
-	dprintk("%s: exiting, st: %p.\n", __func__, st);
-	if (st->thread) {
-		kthread_stop(st->thread);
-		st->thread = NULL;
-	}
-
-	netfs_state_lock_send(st);
-	netfs_state_exit(st);
-	netfs_state_unlock_send(st);
-
-	pohmelfs_state_flush_transactions(st);
-
-	pohmelfs_crypto_engine_exit(&st->eng);
-	kfree(st->data);
-
-	kfree(c);
-}
-
-/*
- * Initialize network stack. It searches for given ID in global
- * configuration table, this contains information of the remote server
- * (address (any supported by socket interface) and port, protocol and so on).
- */
-int pohmelfs_state_init(struct pohmelfs_sb *psb)
-{
-	int err = -ENOMEM;
-
-	err = pohmelfs_copy_config(psb);
-	if (err) {
-		pohmelfs_state_exit(psb);
-		return err;
-	}
-
-	return 0;
-}
-
-void pohmelfs_state_exit(struct pohmelfs_sb *psb)
-{
-	struct pohmelfs_config *c, *tmp;
-
-	list_for_each_entry_safe(c, tmp, &psb->state_list, config_entry) {
-		list_del(&c->config_entry);
-		pohmelfs_state_exit_one(c);
-	}
-}
-
-void pohmelfs_switch_active(struct pohmelfs_sb *psb)
-{
-	struct pohmelfs_config *c = psb->active_state;
-
-	if (!list_empty(&psb->state_list)) {
-		if (c->config_entry.next != &psb->state_list) {
-			psb->active_state = list_entry(c->config_entry.next,
-				struct pohmelfs_config, config_entry);
-		} else {
-			psb->active_state = list_entry(psb->state_list.next,
-				struct pohmelfs_config, config_entry);
-		}
-
-		dprintk("%s: empty: %d, active %p -> %p.\n",
-			__func__, list_empty(&psb->state_list), c,
-			psb->active_state);
-	} else
-		psb->active_state = NULL;
-}
-
-void pohmelfs_check_states(struct pohmelfs_sb *psb)
-{
-	struct pohmelfs_config *c, *tmp;
-	LIST_HEAD(delete_list);
-
-	mutex_lock(&psb->state_lock);
-	list_for_each_entry_safe(c, tmp, &psb->state_list, config_entry) {
-		if (pohmelfs_config_check(c, psb->idx)) {
-
-			if (psb->active_state == c)
-				pohmelfs_switch_active(psb);
-			list_move(&c->config_entry, &delete_list);
-		}
-	}
-	pohmelfs_copy_config(psb);
-	mutex_unlock(&psb->state_lock);
-
-	list_for_each_entry_safe(c, tmp, &delete_list, config_entry) {
-		list_del(&c->config_entry);
-		pohmelfs_state_exit_one(c);
-	}
-}
diff --git a/drivers/staging/pohmelfs/netfs.h b/drivers/staging/pohmelfs/netfs.h
deleted file mode 100644
index 985b6b7..0000000
--- a/drivers/staging/pohmelfs/netfs.h
+++ /dev/null
@@ -1,919 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __NETFS_H
-#define __NETFS_H
-
-#include <linux/types.h>
-#include <linux/connector.h>
-#include <linux/backing-dev.h>
-
-#define POHMELFS_CN_IDX			5
-#define POHMELFS_CN_VAL			0
-
-#define POHMELFS_CTLINFO_ACK		1
-#define POHMELFS_NOINFO_ACK		2
-
-#define POHMELFS_NULL_IDX		65535
-
-/*
- * Network command structure.
- * Will be extended.
- */
-struct netfs_cmd {
-	__u16			cmd;	/* Command number */
-	__u16			csize;	/* Attached crypto information size */
-	__u16			cpad;	/* Attached padding size */
-	__u16			ext;	/* External flags */
-	__u32			size;	/* Size of the attached data */
-	__u32			trans;	/* Transaction id */
-	__u64			id;	/* Object ID to operate on. Used for feedback.*/
-	__u64			start;	/* Start of the object. */
-	__u64			iv;	/* IV sequence */
-	__u8			data[0];
-};
-
-static inline void netfs_convert_cmd(struct netfs_cmd *cmd)
-{
-	cmd->id = __be64_to_cpu(cmd->id);
-	cmd->start = __be64_to_cpu(cmd->start);
-	cmd->iv = __be64_to_cpu(cmd->iv);
-	cmd->cmd = __be16_to_cpu(cmd->cmd);
-	cmd->ext = __be16_to_cpu(cmd->ext);
-	cmd->csize = __be16_to_cpu(cmd->csize);
-	cmd->cpad = __be16_to_cpu(cmd->cpad);
-	cmd->size = __be32_to_cpu(cmd->size);
-}
-
-#define NETFS_TRANS_SINGLE_DST		(1<<0)
-
-enum {
-	NETFS_READDIR	= 1,	/* Read directory for given inode number */
-	NETFS_READ_PAGE,	/* Read data page from the server */
-	NETFS_WRITE_PAGE,	/* Write data page to the server */
-	NETFS_CREATE,		/* Create directory entry */
-	NETFS_REMOVE,		/* Remove directory entry */
-
-	NETFS_LOOKUP,		/* Lookup single object */
-	NETFS_LINK,		/* Create a link */
-	NETFS_TRANS,		/* Transaction */
-	NETFS_OPEN,		/* Open intent */
-	NETFS_INODE_INFO,	/* Metadata cache coherency synchronization message */
-
-	NETFS_PAGE_CACHE,	/* Page cache invalidation message */
-	NETFS_READ_PAGES,	/* Read multiple contiguous pages in one go */
-	NETFS_RENAME,		/* Rename object */
-	NETFS_CAPABILITIES,	/* Capabilities of the client, for example supported crypto */
-	NETFS_LOCK,		/* Distributed lock message */
-
-	NETFS_XATTR_SET,	/* Set extended attribute */
-	NETFS_XATTR_GET,	/* Get extended attribute */
-	NETFS_CMD_MAX
-};
-
-enum {
-	POHMELFS_FLAGS_ADD = 0, /* Network state control message for ADD */
-	POHMELFS_FLAGS_DEL,     /* Network state control message for DEL */
-	POHMELFS_FLAGS_SHOW,    /* Network state control message for SHOW */
-	POHMELFS_FLAGS_CRYPTO,	/* Crypto data control message */
-	POHMELFS_FLAGS_MODIFY,	/* Network state modification message */
-	POHMELFS_FLAGS_DUMP,	/* Network state control message for SHOW ALL */
-	POHMELFS_FLAGS_FLUSH,	/* Network state control message for FLUSH */
-};
-
-/*
- * Always wanted to copy it from socket headers into public one,
- * since they are __KERNEL__ protected there.
- */
-#define _K_SS_MAXSIZE	128
-
-struct saddr {
-	unsigned short		sa_family;
-	char			addr[_K_SS_MAXSIZE];
-};
-
-enum {
-	POHMELFS_CRYPTO_HASH = 0,
-	POHMELFS_CRYPTO_CIPHER,
-};
-
-struct pohmelfs_crypto {
-	unsigned int		idx;		/* Config index */
-	unsigned short		strlen;		/* Size of the attached crypto string including 0-byte
-						 * "cbc(aes)" for example */
-	unsigned short		type;		/* HMAC, cipher, both */
-	unsigned int		keysize;	/* Key size */
-	unsigned char		data[0];	/* Algorithm string, key and IV */
-};
-
-#define POHMELFS_IO_PERM_READ		(1<<0)
-#define POHMELFS_IO_PERM_WRITE		(1<<1)
-
-/*
- * Configuration command used to create table of different remote servers.
- */
-struct pohmelfs_ctl {
-	__u32			idx;		/* Config index */
-	__u32			type;		/* Socket type */
-	__u32			proto;		/* Socket protocol */
-	__u16			addrlen;	/* Size of the address */
-	__u16			perm;		/* IO permission */
-	__u16			prio;		/* IO priority */
-	struct saddr		addr;		/* Remote server address */
-};
-
-/*
- * Ack for userspace about requested command.
- */
-struct pohmelfs_cn_ack {
-	struct cn_msg		msg;
-	int			error;
-	int			msg_num;
-	int			unused[3];
-	struct pohmelfs_ctl	ctl;
-};
-
-/*
- * Inode info structure used to sync with server.
- * Check what stat() returns.
- */
-struct netfs_inode_info {
-	unsigned int		mode;
-	unsigned int		nlink;
-	unsigned int		uid;
-	unsigned int		gid;
-	unsigned int		blocksize;
-	unsigned int		padding;
-	__u64			ino;
-	__u64			blocks;
-	__u64			rdev;
-	__u64			size;
-	__u64			version;
-};
-
-static inline void netfs_convert_inode_info(struct netfs_inode_info *info)
-{
-	info->mode = __cpu_to_be32(info->mode);
-	info->nlink = __cpu_to_be32(info->nlink);
-	info->uid = __cpu_to_be32(info->uid);
-	info->gid = __cpu_to_be32(info->gid);
-	info->blocksize = __cpu_to_be32(info->blocksize);
-	info->blocks = __cpu_to_be64(info->blocks);
-	info->rdev = __cpu_to_be64(info->rdev);
-	info->size = __cpu_to_be64(info->size);
-	info->version = __cpu_to_be64(info->version);
-	info->ino = __cpu_to_be64(info->ino);
-}
-
-/*
- * Cache state machine.
- */
-enum {
-	NETFS_COMMAND_PENDING = 0,	/* Command is being executed */
-	NETFS_INODE_REMOTE_SYNCED,	/* Inode was synced to server */
-	NETFS_INODE_REMOTE_DIR_SYNCED,	/* Inode (directory) was synced from the server */
-	NETFS_INODE_OWNED,		/* Inode is owned by given host */
-	NETFS_INODE_NEED_FLUSH,		/* Inode has to be flushed to the server */
-};
-
-/*
- * POHMELFS capabilities: information about supported
- * crypto operations (hash/cipher, modes, key sizes and so on),
- * root information (used/available size, number of objects, permissions)
- */
-enum pohmelfs_capabilities {
-	POHMELFS_CRYPTO_CAPABILITIES = 0,
-	POHMELFS_ROOT_CAPABILITIES,
-};
-
-/* Read-only mount */
-#define POHMELFS_FLAGS_RO		(1<<0)
-/* Extended attributes support on/off */
-#define POHMELFS_FLAGS_XATTR		(1<<1)
-
-struct netfs_root_capabilities {
-	__u64			nr_files;
-	__u64			used, avail;
-	__u64			flags;
-};
-
-static inline void netfs_convert_root_capabilities(struct netfs_root_capabilities *cap)
-{
-	cap->nr_files = __cpu_to_be64(cap->nr_files);
-	cap->used = __cpu_to_be64(cap->used);
-	cap->avail = __cpu_to_be64(cap->avail);
-	cap->flags = __cpu_to_be64(cap->flags);
-}
-
-struct netfs_crypto_capabilities {
-	unsigned short		hash_strlen;	/* Hash string length, like "hmac(sha1) including 0 byte "*/
-	unsigned short		cipher_strlen;	/* Cipher string length with the same format */
-	unsigned int		cipher_keysize;	/* Cipher key size */
-};
-
-static inline void netfs_convert_crypto_capabilities(struct netfs_crypto_capabilities *cap)
-{
-	cap->hash_strlen = __cpu_to_be16(cap->hash_strlen);
-	cap->cipher_strlen = __cpu_to_be16(cap->cipher_strlen);
-	cap->cipher_keysize = __cpu_to_be32(cap->cipher_keysize);
-}
-
-enum pohmelfs_lock_type {
-	POHMELFS_LOCK_GRAB	= (1<<15),
-
-	POHMELFS_READ_LOCK	= 0,
-	POHMELFS_WRITE_LOCK,
-};
-
-struct netfs_lock {
-	__u64			start;
-	__u64			ino;
-	__u32			size;
-	__u32			type;
-};
-
-static inline void netfs_convert_lock(struct netfs_lock *lock)
-{
-	lock->start = __cpu_to_be64(lock->start);
-	lock->ino = __cpu_to_be64(lock->ino);
-	lock->size = __cpu_to_be32(lock->size);
-	lock->type = __cpu_to_be32(lock->type);
-}
-
-#ifdef __KERNEL__
-
-#include <linux/kernel.h>
-#include <linux/completion.h>
-#include <linux/rbtree.h>
-#include <linux/net.h>
-#include <linux/poll.h>
-
-/*
- * Private POHMELFS cache of objects in directory.
- */
-struct pohmelfs_name {
-	struct rb_node		hash_node;
-
-	struct list_head	sync_create_entry;
-
-	u64			ino;
-
-	u32			hash;
-	u32			mode;
-	u32			len;
-
-	char			*data;
-};
-
-/*
- * POHMELFS inode. Main object.
- */
-struct pohmelfs_inode {
-	struct list_head	inode_entry;		/* Entry in superblock list.
-							 * Objects which are not bound to dentry require to be dropped
-							 * in ->put_super()
-							 */
-	struct rb_root		hash_root;		/* The same, but indexed by name hash and len */
-	struct mutex		offset_lock;		/* Protect both above trees */
-
-	struct list_head	sync_create_list;	/* List of created but not yet synced to the server children */
-
-	unsigned int		drop_count;
-
-	int			lock_type;		/* How this inode is locked: read or write */
-
-	int			error;			/* Transaction error for given inode */
-
-	long			state;			/* State machine above */
-
-	u64			ino;			/* Inode number */
-	u64			total_len;		/* Total length of all children names, used to create offsets */
-
-	struct inode		vfs_inode;
-};
-
-struct netfs_trans;
-typedef int (*netfs_trans_complete_t)(struct page **pages, unsigned int page_num,
-		void *private, int err);
-
-struct netfs_state;
-struct pohmelfs_sb;
-
-struct netfs_trans {
-	/*
-	 * Transaction header and attached contiguous data live here.
-	 */
-	struct iovec			iovec;
-
-	/*
-	 * Pages attached to transaction.
-	 */
-	struct page			**pages;
-
-	/*
-	 * List and protecting lock for transaction destination
-	 * network states.
-	 */
-	spinlock_t			dst_lock;
-	struct list_head		dst_list;
-
-	/*
-	 * Number of users for given transaction.
-	 * For example each network state attached to transaction
-	 * via dst_list increases it.
-	 */
-	atomic_t			refcnt;
-
-	/*
-	 * Number of pages attached to given transaction.
-	 * Some slots in above page array can be NULL, since
-	 * for example page can be under writeback already,
-	 * so we skip it in this transaction.
-	 */
-	unsigned int			page_num;
-
-	/*
-	 * Transaction flags: single dst or broadcast and so on.
-	 */
-	unsigned int			flags;
-
-	/*
-	 * Size of the data, which can be placed into
-	 * iovec.iov_base area.
-	 */
-	unsigned int			total_size;
-
-	/*
-	 * Number of pages to be sent to remote server.
-	 * Usually equal to above page_num, but in case of partial
-	 * writeback it can accumulate only pages already completed
-	 * previous writeback.
-	 */
-	unsigned int			attached_pages;
-
-	/*
-	 * Attached number of bytes in all above pages.
-	 */
-	unsigned int			attached_size;
-
-	/*
-	 * Unique transacton generation number.
-	 * Used as identity in the network state tree of transactions.
-	 */
-	unsigned int			gen;
-
-	/*
-	 * Transaction completion status.
-	 */
-	int				result;
-
-	/*
-	 * Superblock this transaction belongs to
-	 */
-	struct pohmelfs_sb		*psb;
-
-	/*
-	 * Crypto engine, which processed this transaction.
-	 * Can be not NULL only if crypto engine holds encrypted pages.
-	 */
-	struct pohmelfs_crypto_engine	*eng;
-
-	/* Private data */
-	void				*private;
-
-	/* Completion callback, invoked just before transaction is destroyed */
-	netfs_trans_complete_t		complete;
-};
-
-static inline int netfs_trans_cur_len(struct netfs_trans *t)
-{
-	return (signed)(t->total_size - t->iovec.iov_len);
-}
-
-static inline void *netfs_trans_current(struct netfs_trans *t)
-{
-	return t->iovec.iov_base + t->iovec.iov_len;
-}
-
-struct netfs_trans *netfs_trans_alloc(struct pohmelfs_sb *psb, unsigned int size,
-		unsigned int flags, unsigned int nr);
-void netfs_trans_free(struct netfs_trans *t);
-int netfs_trans_finish(struct netfs_trans *t, struct pohmelfs_sb *psb);
-int netfs_trans_finish_send(struct netfs_trans *t, struct pohmelfs_sb *psb);
-
-static inline void netfs_trans_reset(struct netfs_trans *t)
-{
-	t->complete = NULL;
-}
-
-struct netfs_trans_dst {
-	struct list_head		trans_entry;
-	struct rb_node			state_entry;
-
-	unsigned long			send_time;
-
-	/*
-	 * Times this transaction was resent to its old or new,
-	 * depending on flags, destinations. When it reaches maximum
-	 * allowed number, specified in superblock->trans_retries,
-	 * transaction will be freed with ETIMEDOUT error.
-	 */
-	unsigned int			retries;
-
-	struct netfs_trans		*trans;
-	struct netfs_state		*state;
-};
-
-struct netfs_trans_dst *netfs_trans_search(struct netfs_state *st, unsigned int gen);
-void netfs_trans_drop_dst(struct netfs_trans_dst *dst);
-void netfs_trans_drop_dst_nostate(struct netfs_trans_dst *dst);
-void netfs_trans_drop_trans(struct netfs_trans *t, struct netfs_state *st);
-void netfs_trans_drop_last(struct netfs_trans *t, struct netfs_state *st);
-int netfs_trans_resend(struct netfs_trans *t, struct pohmelfs_sb *psb);
-int netfs_trans_remove_nolock(struct netfs_trans_dst *dst, struct netfs_state *st);
-
-int netfs_trans_init(void);
-void netfs_trans_exit(void);
-
-struct pohmelfs_crypto_engine {
-	u64				iv;		/* Crypto IV for current operation */
-	unsigned long			timeout;	/* Crypto waiting timeout */
-	unsigned int			size;		/* Size of crypto scratchpad */
-	void				*data;		/* Temporal crypto scratchpad */
-	/*
-	 * Crypto operations performed on objects.
-	 */
-	struct crypto_hash		*hash;
-	struct crypto_ablkcipher	*cipher;
-
-	struct pohmelfs_crypto_thread	*thread;	/* Crypto thread which hosts this engine */
-
-	struct page			**pages;
-	unsigned int			page_num;
-};
-
-struct pohmelfs_crypto_thread {
-	struct list_head		thread_entry;
-
-	struct task_struct		*thread;
-	struct pohmelfs_sb		*psb;
-
-	struct pohmelfs_crypto_engine	eng;
-
-	struct netfs_trans		*trans;
-
-	wait_queue_head_t		wait;
-	int				error;
-
-	unsigned int			size;
-	struct page			*page;
-};
-
-void pohmelfs_crypto_thread_make_ready(struct pohmelfs_crypto_thread *th);
-
-/*
- * Network state, attached to one server.
- */
-struct netfs_state {
-	struct mutex		__state_lock;		/* Can not allow to use the same socket simultaneously */
-	struct mutex		__state_send_lock;
-	struct netfs_cmd	cmd;			/* Cached command */
-	struct netfs_inode_info	info;			/* Cached inode info */
-
-	void			*data;			/* Cached some data */
-	unsigned int		size;			/* Size of that data */
-
-	struct pohmelfs_sb	*psb;			/* Superblock */
-
-	struct task_struct	*thread;		/* Async receiving thread */
-
-	/* Waiting/polling machinery */
-	wait_queue_t		wait;
-	wait_queue_head_t	*whead;
-	wait_queue_head_t	thread_wait;
-
-	struct mutex		trans_lock;
-	struct rb_root		trans_root;
-
-	struct pohmelfs_ctl	ctl;			/* Remote peer */
-
-	struct socket		*socket;		/* Socket object */
-	struct socket		*read_socket;		/* Cached pointer to socket object.
-							 * Used to determine if between lock drops socket was changed.
-							 * Never used to read data or any kind of access.
-							 */
-	/*
-	 * Crypto engines to process incoming data.
-	 */
-	struct pohmelfs_crypto_engine	eng;
-
-	int			need_reset;
-};
-
-int netfs_state_init(struct netfs_state *st);
-void netfs_state_exit(struct netfs_state *st);
-
-static inline void netfs_state_lock_send(struct netfs_state *st)
-{
-	mutex_lock(&st->__state_send_lock);
-}
-
-static inline int netfs_state_trylock_send(struct netfs_state *st)
-{
-	return mutex_trylock(&st->__state_send_lock);
-}
-
-static inline void netfs_state_unlock_send(struct netfs_state *st)
-{
-	BUG_ON(!mutex_is_locked(&st->__state_send_lock));
-
-	mutex_unlock(&st->__state_send_lock);
-}
-
-static inline void netfs_state_lock(struct netfs_state *st)
-{
-	mutex_lock(&st->__state_lock);
-}
-
-static inline void netfs_state_unlock(struct netfs_state *st)
-{
-	BUG_ON(!mutex_is_locked(&st->__state_lock));
-
-	mutex_unlock(&st->__state_lock);
-}
-
-static inline unsigned int netfs_state_poll(struct netfs_state *st)
-{
-	unsigned int revents = POLLHUP | POLLERR;
-
-	netfs_state_lock(st);
-	if (st->socket)
-		revents = st->socket->ops->poll(NULL, st->socket, NULL);
-	netfs_state_unlock(st);
-
-	return revents;
-}
-
-struct pohmelfs_config;
-
-struct pohmelfs_sb {
-	struct rb_root		mcache_root;
-	struct mutex		mcache_lock;
-	atomic_long_t		mcache_gen;
-	unsigned long		mcache_timeout;
-
-	unsigned int		idx;
-
-	unsigned int		trans_retries;
-
-	atomic_t		trans_gen;
-
-	unsigned int		crypto_attached_size;
-	unsigned int		crypto_align_size;
-
-	unsigned int		crypto_fail_unsupported;
-
-	unsigned int		crypto_thread_num;
-	struct list_head	crypto_active_list, crypto_ready_list;
-	struct mutex		crypto_thread_lock;
-
-	unsigned int		trans_max_pages;
-	unsigned long		trans_data_size;
-	unsigned long		trans_timeout;
-
-	unsigned long		drop_scan_timeout;
-	unsigned long		trans_scan_timeout;
-
-	unsigned long		wait_on_page_timeout;
-
-	struct list_head	flush_list;
-	struct list_head	drop_list;
-	spinlock_t		ino_lock;
-	u64			ino;
-
-	/*
-	 * Remote nodes POHMELFS connected to.
-	 */
-	struct list_head	state_list;
-	struct mutex		state_lock;
-
-	/*
-	 * Currently active state to request data from.
-	 */
-	struct pohmelfs_config	*active_state;
-
-
-	wait_queue_head_t	wait;
-
-	/*
-	 * Timed checks: stale transactions, inodes to be freed and so on.
-	 */
-	struct delayed_work	dwork;
-	struct delayed_work	drop_dwork;
-
-	struct super_block	*sb;
-
-	struct backing_dev_info	bdi;
-
-	/*
-	 * Algorithm strings.
-	 */
-	char			*hash_string;
-	char			*cipher_string;
-
-	u8			*hash_key;
-	u8			*cipher_key;
-
-	/*
-	 * Algorithm string lengths.
-	 */
-	unsigned int		hash_strlen;
-	unsigned int		cipher_strlen;
-	unsigned int		hash_keysize;
-	unsigned int		cipher_keysize;
-
-	/*
-	 * Controls whether to perfrom crypto processing or not.
-	 */
-	int			perform_crypto;
-
-	/*
-	 * POHMELFS statistics.
-	 */
-	u64			total_size;
-	u64			avail_size;
-	atomic_long_t		total_inodes;
-
-	/*
-	 * Xattr support, read-only and so on.
-	 */
-	u64			state_flags;
-
-	/*
-	 * Temporary storage to detect changes in the wait queue.
-	 */
-	long			flags;
-};
-
-static inline void netfs_trans_update(struct netfs_cmd *cmd,
-		struct netfs_trans *t, unsigned int size)
-{
-	unsigned int sz = ALIGN(size, t->psb->crypto_align_size);
-
-	t->iovec.iov_len += sizeof(struct netfs_cmd) + sz;
-	cmd->cpad = __cpu_to_be16(sz - size);
-}
-
-static inline struct pohmelfs_sb *POHMELFS_SB(struct super_block *sb)
-{
-	return sb->s_fs_info;
-}
-
-static inline struct pohmelfs_inode *POHMELFS_I(struct inode *inode)
-{
-	return container_of(inode, struct pohmelfs_inode, vfs_inode);
-}
-
-static inline u64 pohmelfs_new_ino(struct pohmelfs_sb *psb)
-{
-	u64 ino;
-
-	spin_lock(&psb->ino_lock);
-	ino = psb->ino++;
-	spin_unlock(&psb->ino_lock);
-
-	return ino;
-}
-
-static inline void pohmelfs_put_inode(struct pohmelfs_inode *pi)
-{
-	struct pohmelfs_sb *psb = POHMELFS_SB(pi->vfs_inode.i_sb);
-
-	spin_lock(&psb->ino_lock);
-	list_move_tail(&pi->inode_entry, &psb->drop_list);
-	pi->drop_count++;
-	spin_unlock(&psb->ino_lock);
-}
-
-struct pohmelfs_config {
-	struct list_head	config_entry;
-
-	struct netfs_state	state;
-};
-
-struct pohmelfs_config_group {
-	/*
-	 * Entry in the global config group list.
-	 */
-	struct list_head	group_entry;
-
-	/*
-	 * Index of the current group.
-	 */
-	unsigned int		idx;
-	/*
-	 * Number of config_list entries in this group entry.
-	 */
-	unsigned int		num_entry;
-	/*
-	 * Algorithm strings.
-	 */
-	char			*hash_string;
-	char			*cipher_string;
-
-	/*
-	 * Algorithm string lengths.
-	 */
-	unsigned int		hash_strlen;
-	unsigned int		cipher_strlen;
-
-	/*
-	 * Key and its size.
-	 */
-	unsigned int		hash_keysize;
-	unsigned int		cipher_keysize;
-	u8			*hash_key;
-	u8			*cipher_key;
-
-	/*
-	 * List of config entries (network state info) for given idx.
-	 */
-	struct list_head	config_list;
-};
-
-int __init pohmelfs_config_init(void);
-void pohmelfs_config_exit(void);
-int pohmelfs_copy_config(struct pohmelfs_sb *psb);
-int pohmelfs_copy_crypto(struct pohmelfs_sb *psb);
-int pohmelfs_config_check(struct pohmelfs_config *config, int idx);
-int pohmelfs_state_init_one(struct pohmelfs_sb *psb, struct pohmelfs_config *conf);
-
-extern const struct file_operations pohmelfs_dir_fops;
-extern const struct inode_operations pohmelfs_dir_inode_ops;
-
-int pohmelfs_state_init(struct pohmelfs_sb *psb);
-void pohmelfs_state_exit(struct pohmelfs_sb *psb);
-void pohmelfs_state_flush_transactions(struct netfs_state *st);
-
-void pohmelfs_fill_inode(struct inode *inode, struct netfs_inode_info *info);
-
-void pohmelfs_name_del(struct pohmelfs_inode *parent, struct pohmelfs_name *n);
-void pohmelfs_free_names(struct pohmelfs_inode *parent);
-struct pohmelfs_name *pohmelfs_search_hash(struct pohmelfs_inode *pi, u32 hash);
-
-void pohmelfs_inode_del_inode(struct pohmelfs_sb *psb, struct pohmelfs_inode *pi);
-
-struct pohmelfs_inode *pohmelfs_create_entry_local(struct pohmelfs_sb *psb,
-	struct pohmelfs_inode *parent, struct qstr *str, u64 start, int mode);
-
-int pohmelfs_write_create_inode(struct pohmelfs_inode *pi);
-
-int pohmelfs_write_inode_create(struct inode *inode, struct netfs_trans *trans);
-int pohmelfs_remove_child(struct pohmelfs_inode *parent, struct pohmelfs_name *n);
-
-struct pohmelfs_inode *pohmelfs_new_inode(struct pohmelfs_sb *psb,
-		struct pohmelfs_inode *parent, struct qstr *str,
-		struct netfs_inode_info *info, int link);
-
-int pohmelfs_setattr(struct dentry *dentry, struct iattr *attr);
-int pohmelfs_setattr_raw(struct inode *inode, struct iattr *attr);
-
-int pohmelfs_meta_command(struct pohmelfs_inode *pi, unsigned int cmd_op, unsigned int flags,
-		netfs_trans_complete_t complete, void *priv, u64 start);
-int pohmelfs_meta_command_data(struct pohmelfs_inode *pi, u64 id, unsigned int cmd_op, char *addon,
-		unsigned int flags, netfs_trans_complete_t complete, void *priv, u64 start);
-
-void pohmelfs_check_states(struct pohmelfs_sb *psb);
-void pohmelfs_switch_active(struct pohmelfs_sb *psb);
-
-int pohmelfs_construct_path_string(struct pohmelfs_inode *pi, void *data, int len);
-int pohmelfs_path_length(struct pohmelfs_inode *pi);
-
-struct pohmelfs_crypto_completion {
-	struct completion	complete;
-	int			error;
-};
-
-int pohmelfs_trans_crypt(struct netfs_trans *t, struct pohmelfs_sb *psb);
-void pohmelfs_crypto_exit(struct pohmelfs_sb *psb);
-int pohmelfs_crypto_init(struct pohmelfs_sb *psb);
-
-int pohmelfs_crypto_engine_init(struct pohmelfs_crypto_engine *e, struct pohmelfs_sb *psb);
-void pohmelfs_crypto_engine_exit(struct pohmelfs_crypto_engine *e);
-
-int pohmelfs_crypto_process_input_data(struct pohmelfs_crypto_engine *e, u64 iv,
-		void *data, struct page *page, unsigned int size);
-int pohmelfs_crypto_process_input_page(struct pohmelfs_crypto_engine *e,
-		struct page *page, unsigned int size, u64 iv);
-
-static inline u64 pohmelfs_gen_iv(struct netfs_trans *t)
-{
-	u64 iv = t->gen;
-
-	iv <<= 32;
-	iv |= ((unsigned long)t) & 0xffffffff;
-
-	return iv;
-}
-
-int pohmelfs_data_lock(struct pohmelfs_inode *pi, u64 start, u32 size, int type);
-int pohmelfs_data_unlock(struct pohmelfs_inode *pi, u64 start, u32 size, int type);
-int pohmelfs_data_lock_response(struct netfs_state *st);
-
-static inline int pohmelfs_need_lock(struct pohmelfs_inode *pi, int type)
-{
-	if (test_bit(NETFS_INODE_OWNED, &pi->state)) {
-		if (type == pi->lock_type)
-			return 0;
-		if ((type == POHMELFS_READ_LOCK) && (pi->lock_type == POHMELFS_WRITE_LOCK))
-			return 0;
-	}
-
-	if (!test_bit(NETFS_INODE_REMOTE_SYNCED, &pi->state))
-		return 0;
-
-	return 1;
-}
-
-int __init pohmelfs_mcache_init(void);
-void pohmelfs_mcache_exit(void);
-
-/* #define CONFIG_POHMELFS_DEBUG */
-
-#ifdef CONFIG_POHMELFS_DEBUG
-#define dprintka(f, a...) printk(f, ##a)
-#define dprintk(f, a...) printk("%d: " f, task_pid_vnr(current), ##a)
-#else
-#define dprintka(f, a...) do {} while (0)
-#define dprintk(f, a...) do {} while (0)
-#endif
-
-static inline void netfs_trans_get(struct netfs_trans *t)
-{
-	atomic_inc(&t->refcnt);
-}
-
-static inline void netfs_trans_put(struct netfs_trans *t)
-{
-	if (atomic_dec_and_test(&t->refcnt)) {
-		dprintk("%s: t: %p, gen: %u, err: %d.\n",
-			__func__, t, t->gen, t->result);
-		if (t->complete)
-			t->complete(t->pages, t->page_num,
-				t->private, t->result);
-		netfs_trans_free(t);
-	}
-}
-
-struct pohmelfs_mcache {
-	struct rb_node			mcache_entry;
-	struct completion		complete;
-
-	atomic_t			refcnt;
-
-	u64				gen;
-
-	void				*data;
-	u64				start;
-	u32				size;
-	int				err;
-
-	struct netfs_inode_info		info;
-};
-
-struct pohmelfs_mcache *pohmelfs_mcache_alloc(struct pohmelfs_sb *psb, u64 start,
-		unsigned int size, void *data);
-void pohmelfs_mcache_free(struct pohmelfs_sb *psb, struct pohmelfs_mcache *m);
-struct pohmelfs_mcache *pohmelfs_mcache_search(struct pohmelfs_sb *psb, u64 gen);
-void pohmelfs_mcache_remove_locked(struct pohmelfs_sb *psb, struct pohmelfs_mcache *m);
-
-static inline void pohmelfs_mcache_get(struct pohmelfs_mcache *m)
-{
-	atomic_inc(&m->refcnt);
-}
-
-static inline void pohmelfs_mcache_put(struct pohmelfs_sb *psb,
-		struct pohmelfs_mcache *m)
-{
-	if (atomic_dec_and_test(&m->refcnt))
-		pohmelfs_mcache_free(psb, m);
-}
-
-/*#define POHMELFS_TRUNCATE_ON_INODE_FLUSH
- */
-
-#endif /* __KERNEL__*/
-
-#endif /* __NETFS_H */
diff --git a/drivers/staging/pohmelfs/path_entry.c b/drivers/staging/pohmelfs/path_entry.c
deleted file mode 100644
index 400a9fc..0000000
--- a/drivers/staging/pohmelfs/path_entry.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/ktime.h>
-#include <linux/fs_struct.h>
-#include <linux/pagemap.h>
-#include <linux/writeback.h>
-#include <linux/mount.h>
-#include <linux/mm.h>
-
-#include "netfs.h"
-
-#define UNHASHED_OBSCURE_STRING_SIZE		sizeof(" (deleted)")
-
-/*
- * Create path from root for given inode.
- * Path is formed as set of stuctures, containing name of the object
- * and its inode data (mode, permissions and so on).
- */
-int pohmelfs_construct_path_string(struct pohmelfs_inode *pi, void *data, int len)
-{
-	struct path path;
-	struct dentry *d;
-	char *ptr;
-	int err = 0, strlen, reduce = 0;
-
-	d = d_find_alias(&pi->vfs_inode);
-	if (!d) {
-		printk("%s: no alias, list_empty: %d.\n", __func__, list_empty(&pi->vfs_inode.i_dentry));
-		return -ENOENT;
-	}
-
-	spin_lock(&current->fs->lock);
-	path.mnt = mntget(current->fs->root.mnt);
-	spin_unlock(&current->fs->lock);
-
-	path.dentry = d;
-
-	if (!IS_ROOT(d) && d_unhashed(d))
-		reduce = 1;
-
-	ptr = d_path(&path, data, len);
-	if (IS_ERR(ptr)) {
-		err = PTR_ERR(ptr);
-		goto out;
-	}
-
-	if (reduce && len >= UNHASHED_OBSCURE_STRING_SIZE) {
-		char *end = data + len - UNHASHED_OBSCURE_STRING_SIZE;
-		*end = '\0';
-	}
-
-	strlen = len - (ptr - (char *)data);
-	memmove(data, ptr, strlen);
-	ptr = data;
-
-	err = strlen;
-
-	dprintk("%s: dname: '%s', len: %u, maxlen: %u, name: '%s', strlen: %d.\n",
-			__func__, d->d_name.name, d->d_name.len, len, ptr, strlen);
-
-out:
-	dput(d);
-	mntput(path.mnt);
-
-	return err;
-}
-
-int pohmelfs_path_length(struct pohmelfs_inode *pi)
-{
-	struct dentry *d, *root, *first;
-	int len;
-	unsigned seq;
-
-	first = d_find_alias(&pi->vfs_inode);
-	if (!first) {
-		dprintk("%s: ino: %llu, mode: %o.\n", __func__, pi->ino, pi->vfs_inode.i_mode);
-		return -ENOENT;
-	}
-
-	spin_lock(&current->fs->lock);
-	root = dget(current->fs->root.dentry);
-	spin_unlock(&current->fs->lock);
-
-rename_retry:
-	len = 1; /* Root slash */
-	d = first;
-	seq = read_seqbegin(&rename_lock);
-	rcu_read_lock();
-
-	if (!IS_ROOT(d) && d_unhashed(d))
-		len += UNHASHED_OBSCURE_STRING_SIZE; /* Obscure " (deleted)" string */
-
-	while (d && d != root && !IS_ROOT(d)) {
-		len += d->d_name.len + 1; /* Plus slash */
-		d = d->d_parent;
-	}
-	rcu_read_unlock();
-	if (read_seqretry(&rename_lock, seq))
-		goto rename_retry;
-
-	dput(root);
-	dput(first);
-
-	return len + 1; /* Including zero-byte */
-}
diff --git a/drivers/staging/pohmelfs/trans.c b/drivers/staging/pohmelfs/trans.c
deleted file mode 100644
index 36a2535..0000000
--- a/drivers/staging/pohmelfs/trans.c
+++ /dev/null
@@ -1,706 +0,0 @@
-/*
- * 2007+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/crypto.h>
-#include <linux/fs.h>
-#include <linux/jhash.h>
-#include <linux/hash.h>
-#include <linux/ktime.h>
-#include <linux/mempool.h>
-#include <linux/mm.h>
-#include <linux/mount.h>
-#include <linux/pagemap.h>
-#include <linux/parser.h>
-#include <linux/poll.h>
-#include <linux/swap.h>
-#include <linux/slab.h>
-#include <linux/statfs.h>
-#include <linux/writeback.h>
-
-#include "netfs.h"
-
-static struct kmem_cache *netfs_trans_dst;
-static mempool_t *netfs_trans_dst_pool;
-
-static void netfs_trans_init_static(struct netfs_trans *t, int num, int size)
-{
-	t->page_num = num;
-	t->total_size = size;
-	atomic_set(&t->refcnt, 1);
-
-	spin_lock_init(&t->dst_lock);
-	INIT_LIST_HEAD(&t->dst_list);
-}
-
-static int netfs_trans_send_pages(struct netfs_trans *t, struct netfs_state *st)
-{
-	int err = 0;
-	unsigned int i, attached_pages = t->attached_pages, ci;
-	struct msghdr msg;
-	struct page **pages = (t->eng)?t->eng->pages:t->pages;
-	struct page *p;
-	unsigned int size;
-
-	msg.msg_name = NULL;
-	msg.msg_namelen = 0;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_flags = MSG_WAITALL | MSG_MORE;
-
-	ci = 0;
-	for (i=0; i<t->page_num; ++i) {
-		struct page *page = pages[ci];
-		struct netfs_cmd cmd;
-		struct iovec io;
-
-		p = t->pages[i];
-
-		if (!p)
-			continue;
-
-		size = page_private(p);
-
-		io.iov_base = &cmd;
-		io.iov_len = sizeof(struct netfs_cmd);
-
-		cmd.cmd = NETFS_WRITE_PAGE;
-		cmd.ext = 0;
-		cmd.id = 0;
-		cmd.size = size;
-		cmd.start = p->index;
-		cmd.start <<= PAGE_CACHE_SHIFT;
-		cmd.csize = 0;
-		cmd.cpad = 0;
-		cmd.iv = pohmelfs_gen_iv(t);
-
-		netfs_convert_cmd(&cmd);
-
-		msg.msg_iov = &io;
-		msg.msg_iovlen = 1;
-		msg.msg_flags = MSG_WAITALL | MSG_MORE;
-
-		err = kernel_sendmsg(st->socket, &msg, (struct kvec *)msg.msg_iov, 1, sizeof(struct netfs_cmd));
-		if (err <= 0) {
-			printk("%s: %d/%d failed to send transaction header: t: %p, gen: %u, err: %d.\n",
-					__func__, i, t->page_num, t, t->gen, err);
-			if (err == 0)
-				err = -ECONNRESET;
-			goto err_out;
-		}
-
-		msg.msg_flags = MSG_WAITALL | (attached_pages == 1 ? 0 :
-				MSG_MORE);
-
-		err = kernel_sendpage(st->socket, page, 0, size, msg.msg_flags);
-		if (err <= 0) {
-			printk("%s: %d/%d failed to send transaction page: t: %p, gen: %u, size: %u, err: %d.\n",
-					__func__, i, t->page_num, t, t->gen, size, err);
-			if (err == 0)
-				err = -ECONNRESET;
-			goto err_out;
-		}
-
-		dprintk("%s: %d/%d sent t: %p, gen: %u, page: %p/%p, size: %u.\n",
-			__func__, i, t->page_num, t, t->gen, page, p, size);
-
-		err = 0;
-		attached_pages--;
-		if (!attached_pages)
-			break;
-		ci++;
-
-		continue;
-
-err_out:
-		printk("%s: t: %p, gen: %u, err: %d.\n", __func__, t, t->gen, err);
-		netfs_state_exit(st);
-		break;
-	}
-
-	return err;
-}
-
-int netfs_trans_send(struct netfs_trans *t, struct netfs_state *st)
-{
-	int err;
-	struct msghdr msg;
-
-	BUG_ON(!t->iovec.iov_len);
-	BUG_ON(t->iovec.iov_len > 1024*1024*1024);
-
-	netfs_state_lock_send(st);
-	if (!st->socket) {
-		err = netfs_state_init(st);
-		if (err)
-			goto err_out_unlock_return;
-	}
-
-	msg.msg_iov = &t->iovec;
-	msg.msg_iovlen = 1;
-	msg.msg_name = NULL;
-	msg.msg_namelen = 0;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_flags = MSG_WAITALL;
-
-	if (t->attached_pages)
-		msg.msg_flags |= MSG_MORE;
-
-	err = kernel_sendmsg(st->socket, &msg, (struct kvec *)msg.msg_iov, 1, t->iovec.iov_len);
-	if (err <= 0) {
-		printk("%s: failed to send contig transaction: t: %p, gen: %u, size: %zu, err: %d.\n",
-				__func__, t, t->gen, t->iovec.iov_len, err);
-		if (err == 0)
-			err = -ECONNRESET;
-		goto err_out_unlock_return;
-	}
-
-	dprintk("%s: sent %s transaction: t: %p, gen: %u, size: %zu, page_num: %u.\n",
-			__func__, (t->page_num)?"partial":"full",
-			t, t->gen, t->iovec.iov_len, t->page_num);
-
-	err = 0;
-	if (t->attached_pages)
-		err = netfs_trans_send_pages(t, st);
-
-err_out_unlock_return:
-
-	if (st->need_reset)
-		netfs_state_exit(st);
-
-	netfs_state_unlock_send(st);
-
-	dprintk("%s: t: %p, gen: %u, err: %d.\n",
-		__func__, t, t->gen, err);
-
-	t->result = err;
-	return err;
-}
-
-static inline int netfs_trans_cmp(unsigned int gen, unsigned int new)
-{
-	if (gen < new)
-		return 1;
-	if (gen > new)
-		return -1;
-	return 0;
-}
-
-struct netfs_trans_dst *netfs_trans_search(struct netfs_state *st, unsigned int gen)
-{
-	struct rb_root *root = &st->trans_root;
-	struct rb_node *n = root->rb_node;
-	struct netfs_trans_dst *tmp, *ret = NULL;
-	struct netfs_trans *t;
-	int cmp;
-
-	while (n) {
-		tmp = rb_entry(n, struct netfs_trans_dst, state_entry);
-		t = tmp->trans;
-
-		cmp = netfs_trans_cmp(t->gen, gen);
-		if (cmp < 0)
-			n = n->rb_left;
-		else if (cmp > 0)
-			n = n->rb_right;
-		else {
-			ret = tmp;
-			break;
-		}
-	}
-
-	return ret;
-}
-
-static int netfs_trans_insert(struct netfs_trans_dst *ndst, struct netfs_state *st)
-{
-	struct rb_root *root = &st->trans_root;
-	struct rb_node **n = &root->rb_node, *parent = NULL;
-	struct netfs_trans_dst *ret = NULL, *tmp;
-	struct netfs_trans *t = NULL, *new = ndst->trans;
-	int cmp;
-
-	while (*n) {
-		parent = *n;
-
-		tmp = rb_entry(parent, struct netfs_trans_dst, state_entry);
-		t = tmp->trans;
-
-		cmp = netfs_trans_cmp(t->gen, new->gen);
-		if (cmp < 0)
-			n = &parent->rb_left;
-		else if (cmp > 0)
-			n = &parent->rb_right;
-		else {
-			ret = tmp;
-			break;
-		}
-	}
-
-	if (ret) {
-		printk("%s: exist: old: gen: %u, flags: %x, send_time: %lu, "
-				"new: gen: %u, flags: %x, send_time: %lu.\n",
-			__func__, t->gen, t->flags, ret->send_time,
-			new->gen, new->flags, ndst->send_time);
-		return -EEXIST;
-	}
-
-	rb_link_node(&ndst->state_entry, parent, n);
-	rb_insert_color(&ndst->state_entry, root);
-	ndst->send_time = jiffies;
-
-	return 0;
-}
-
-int netfs_trans_remove_nolock(struct netfs_trans_dst *dst, struct netfs_state *st)
-{
-	if (dst && dst->state_entry.rb_parent_color) {
-		rb_erase(&dst->state_entry, &st->trans_root);
-		dst->state_entry.rb_parent_color = 0;
-		return 1;
-	}
-	return 0;
-}
-
-static int netfs_trans_remove_state(struct netfs_trans_dst *dst)
-{
-	int ret;
-	struct netfs_state *st = dst->state;
-
-	mutex_lock(&st->trans_lock);
-	ret = netfs_trans_remove_nolock(dst, st);
-	mutex_unlock(&st->trans_lock);
-
-	return ret;
-}
-
-/*
- * Create new destination for given transaction associated with given network state.
- * Transaction's reference counter is bumped and will be dropped when either
- * reply is received or when async timeout detection task will fail resending
- * and drop transaction.
- */
-static int netfs_trans_push_dst(struct netfs_trans *t, struct netfs_state *st)
-{
-	struct netfs_trans_dst *dst;
-	int err;
-
-	dst = mempool_alloc(netfs_trans_dst_pool, GFP_KERNEL);
-	if (!dst)
-		return -ENOMEM;
-
-	dst->retries = 0;
-	dst->send_time = 0;
-	dst->state = st;
-	dst->trans = t;
-	netfs_trans_get(t);
-
-	mutex_lock(&st->trans_lock);
-	err = netfs_trans_insert(dst, st);
-	mutex_unlock(&st->trans_lock);
-
-	if (err)
-		goto err_out_free;
-
-	spin_lock(&t->dst_lock);
-	list_add_tail(&dst->trans_entry, &t->dst_list);
-	spin_unlock(&t->dst_lock);
-
-	return 0;
-
-err_out_free:
-	t->result = err;
-	netfs_trans_put(t);
-	mempool_free(dst, netfs_trans_dst_pool);
-	return err;
-}
-
-static void netfs_trans_free_dst(struct netfs_trans_dst *dst)
-{
-	netfs_trans_put(dst->trans);
-	mempool_free(dst, netfs_trans_dst_pool);
-}
-
-static void netfs_trans_remove_dst(struct netfs_trans_dst *dst)
-{
-	if (netfs_trans_remove_state(dst))
-		netfs_trans_free_dst(dst);
-}
-
-/*
- * Drop destination transaction entry when we know it.
- */
-void netfs_trans_drop_dst(struct netfs_trans_dst *dst)
-{
-	struct netfs_trans *t = dst->trans;
-
-	spin_lock(&t->dst_lock);
-	list_del_init(&dst->trans_entry);
-	spin_unlock(&t->dst_lock);
-
-	netfs_trans_remove_dst(dst);
-}
-
-/*
- * Drop destination transaction entry when we know it and when we
- * already removed dst from state tree.
- */
-void netfs_trans_drop_dst_nostate(struct netfs_trans_dst *dst)
-{
-	struct netfs_trans *t = dst->trans;
-
-	spin_lock(&t->dst_lock);
-	list_del_init(&dst->trans_entry);
-	spin_unlock(&t->dst_lock);
-
-	netfs_trans_free_dst(dst);
-}
-
-/*
- * This drops destination transaction entry from appropriate network state
- * tree and drops related reference counter. It is possible that transaction
- * will be freed here if its reference counter hits zero.
- * Destination transaction entry will be freed.
- */
-void netfs_trans_drop_trans(struct netfs_trans *t, struct netfs_state *st)
-{
-	struct netfs_trans_dst *dst, *tmp, *ret = NULL;
-
-	spin_lock(&t->dst_lock);
-	list_for_each_entry_safe(dst, tmp, &t->dst_list, trans_entry) {
-		if (dst->state == st) {
-			ret = dst;
-			list_del(&dst->trans_entry);
-			break;
-		}
-	}
-	spin_unlock(&t->dst_lock);
-
-	if (ret)
-		netfs_trans_remove_dst(ret);
-}
-
-/*
- * This drops destination transaction entry from appropriate network state
- * tree and drops related reference counter. It is possible that transaction
- * will be freed here if its reference counter hits zero.
- * Destination transaction entry will be freed.
- */
-void netfs_trans_drop_last(struct netfs_trans *t, struct netfs_state *st)
-{
-	struct netfs_trans_dst *dst, *tmp, *ret;
-
-	spin_lock(&t->dst_lock);
-	ret = list_entry(t->dst_list.prev, struct netfs_trans_dst, trans_entry);
-	if (ret->state != st) {
-		ret = NULL;
-		list_for_each_entry_safe(dst, tmp, &t->dst_list, trans_entry) {
-			if (dst->state == st) {
-				ret = dst;
-				list_del_init(&dst->trans_entry);
-				break;
-			}
-		}
-	} else {
-		list_del(&ret->trans_entry);
-	}
-	spin_unlock(&t->dst_lock);
-
-	if (ret)
-		netfs_trans_remove_dst(ret);
-}
-
-static int netfs_trans_push(struct netfs_trans *t, struct netfs_state *st)
-{
-	int err;
-
-	err = netfs_trans_push_dst(t, st);
-	if (err)
-		return err;
-
-	err = netfs_trans_send(t, st);
-	if (err)
-		goto err_out_free;
-
-	if (t->flags & NETFS_TRANS_SINGLE_DST)
-		pohmelfs_switch_active(st->psb);
-
-	return 0;
-
-err_out_free:
-	t->result = err;
-	netfs_trans_drop_last(t, st);
-
-	return err;
-}
-
-int netfs_trans_finish_send(struct netfs_trans *t, struct pohmelfs_sb *psb)
-{
-	struct pohmelfs_config *c;
-	int err = -ENODEV;
-	struct netfs_state *st;
-#if 0
-	dprintk("%s: t: %p, gen: %u, size: %u, page_num: %u, active: %p.\n",
-		__func__, t, t->gen, t->iovec.iov_len, t->page_num, psb->active_state);
-#endif
-	mutex_lock(&psb->state_lock);
-	list_for_each_entry(c, &psb->state_list, config_entry) {
-		st = &c->state;
-
-		if (t->flags & NETFS_TRANS_SINGLE_DST) {
-			if (!(st->ctl.perm & POHMELFS_IO_PERM_READ))
-				continue;
-		} else {
-			if (!(st->ctl.perm & POHMELFS_IO_PERM_WRITE))
-				continue;
-		}
-
-		if (psb->active_state && (psb->active_state->state.ctl.prio >= st->ctl.prio) &&
-				(t->flags & NETFS_TRANS_SINGLE_DST))
-			st = &psb->active_state->state;
-
-		err = netfs_trans_push(t, st);
-		if (!err && (t->flags & NETFS_TRANS_SINGLE_DST))
-			break;
-	}
-
-	mutex_unlock(&psb->state_lock);
-#if 0
-	dprintk("%s: fully sent t: %p, gen: %u, size: %u, page_num: %u, err: %d.\n",
-		__func__, t, t->gen, t->iovec.iov_len, t->page_num, err);
-#endif
-	if (err)
-		t->result = err;
-	return err;
-}
-
-int netfs_trans_finish(struct netfs_trans *t, struct pohmelfs_sb *psb)
-{
-	int err;
-	struct netfs_cmd *cmd = t->iovec.iov_base;
-
-	t->gen = atomic_inc_return(&psb->trans_gen);
-
-	cmd->size = t->iovec.iov_len - sizeof(struct netfs_cmd) +
-		t->attached_size + t->attached_pages * sizeof(struct netfs_cmd);
-	cmd->cmd = NETFS_TRANS;
-	cmd->start = t->gen;
-	cmd->id = 0;
-
-	if (psb->perform_crypto) {
-		cmd->ext = psb->crypto_attached_size;
-		cmd->csize = psb->crypto_attached_size;
-	}
-
-	dprintk("%s: t: %u, size: %u, iov_len: %zu, attached_size: %u, attached_pages: %u.\n",
-			__func__, t->gen, cmd->size, t->iovec.iov_len, t->attached_size, t->attached_pages);
-	err = pohmelfs_trans_crypt(t, psb);
-	if (err) {
-		t->result = err;
-		netfs_convert_cmd(cmd);
-		dprintk("%s: trans: %llu, crypto_attached_size: %u, attached_size: %u, attached_pages: %d, trans_size: %u, err: %d.\n",
-			__func__, cmd->start, psb->crypto_attached_size, t->attached_size, t->attached_pages, cmd->size, err);
-	}
-	netfs_trans_put(t);
-	return err;
-}
-
-/*
- * Resend transaction to remote server(s).
- * If new servers were added into superblock, we can try to send data
- * to them too.
- *
- * It is called under superblock's state_lock, so we can safely
- * dereference psb->state_list. Also, transaction's reference counter is
- * bumped, so it can not go away under us, thus we can safely access all
- * its members. State is locked.
- *
- * This function returns 0 if transaction was successfully sent to at
- * least one destination target.
- */
-int netfs_trans_resend(struct netfs_trans *t, struct pohmelfs_sb *psb)
-{
-	struct netfs_trans_dst *dst;
-	struct netfs_state *st;
-	struct pohmelfs_config *c;
-	int err, exist, error = -ENODEV;
-
-	list_for_each_entry(c, &psb->state_list, config_entry) {
-		st = &c->state;
-
-		exist = 0;
-		spin_lock(&t->dst_lock);
-		list_for_each_entry(dst, &t->dst_list, trans_entry) {
-			if (st == dst->state) {
-				exist = 1;
-				break;
-			}
-		}
-		spin_unlock(&t->dst_lock);
-
-		if (exist) {
-			if (!(t->flags & NETFS_TRANS_SINGLE_DST) ||
-					(c->config_entry.next == &psb->state_list)) {
-				dprintk("%s: resending st: %p, t: %p, gen: %u.\n",
-						__func__, st, t, t->gen);
-				err = netfs_trans_send(t, st);
-				if (!err)
-					error = 0;
-			}
-			continue;
-		}
-
-		dprintk("%s: pushing/resending st: %p, t: %p, gen: %u.\n",
-				__func__, st, t, t->gen);
-		err = netfs_trans_push(t, st);
-		if (err)
-			continue;
-		error = 0;
-		if (t->flags & NETFS_TRANS_SINGLE_DST)
-			break;
-	}
-
-	t->result = error;
-	return error;
-}
-
-void *netfs_trans_add(struct netfs_trans *t, unsigned int size)
-{
-	struct iovec *io = &t->iovec;
-	void *ptr;
-
-	if (size > t->total_size) {
-		ptr = ERR_PTR(-EINVAL);
-		goto out;
-	}
-
-	if (io->iov_len + size > t->total_size) {
-		dprintk("%s: too big size t: %p, gen: %u, iov_len: %zu, size: %u, total: %u.\n",
-				__func__, t, t->gen, io->iov_len, size, t->total_size);
-		ptr = ERR_PTR(-E2BIG);
-		goto out;
-	}
-
-	ptr = io->iov_base + io->iov_len;
-	io->iov_len += size;
-
-out:
-	dprintk("%s: t: %p, gen: %u, size: %u, total: %zu.\n",
-		__func__, t, t->gen, size, io->iov_len);
-	return ptr;
-}
-
-void netfs_trans_free(struct netfs_trans *t)
-{
-	if (t->eng)
-		pohmelfs_crypto_thread_make_ready(t->eng->thread);
-	kfree(t);
-}
-
-struct netfs_trans *netfs_trans_alloc(struct pohmelfs_sb *psb, unsigned int size,
-		unsigned int flags, unsigned int nr)
-{
-	struct netfs_trans *t;
-	unsigned int num, cont, pad, size_no_trans;
-	unsigned int crypto_added = 0;
-	struct netfs_cmd *cmd;
-
-	if (psb->perform_crypto)
-		crypto_added = psb->crypto_attached_size;
-
-	/*
-	 * |sizeof(struct netfs_trans)|
-	 * |sizeof(struct netfs_cmd)| - transaction header
-	 * |size| - buffer with requested size
-	 * |padding| - crypto padding, zero bytes
-	 * |nr * sizeof(struct page *)| - array of page pointers
-	 *
-	 * Overall size should be less than PAGE_SIZE for guaranteed allocation.
-	 */
-
-	cont = size;
-	size = ALIGN(size, psb->crypto_align_size);
-	pad = size - cont;
-
-	size_no_trans = size + sizeof(struct netfs_cmd) * 2 + crypto_added;
-
-	cont = sizeof(struct netfs_trans) + size_no_trans;
-
-	num = (PAGE_SIZE - cont)/sizeof(struct page *);
-
-	if (nr > num)
-		nr = num;
-
-	t = kzalloc(cont + nr*sizeof(struct page *), GFP_NOIO);
-	if (!t)
-		goto err_out_exit;
-
-	t->iovec.iov_base = (void *)(t + 1);
-	t->pages = (struct page **)(t->iovec.iov_base + size_no_trans);
-
-	/*
-	 * Reserving space for transaction header.
-	 */
-	t->iovec.iov_len = sizeof(struct netfs_cmd) + crypto_added;
-
-	netfs_trans_init_static(t, nr, size_no_trans);
-
-	t->flags = flags;
-	t->psb = psb;
-
-	cmd = (struct netfs_cmd *)t->iovec.iov_base;
-
-	cmd->size = size;
-	cmd->cpad = pad;
-	cmd->csize = crypto_added;
-
-	dprintk("%s: t: %p, gen: %u, size: %u, padding: %u, align_size: %u, flags: %x, "
-			"page_num: %u, base: %p, pages: %p.\n",
-			__func__, t, t->gen, size, pad, psb->crypto_align_size, flags, nr,
-			t->iovec.iov_base, t->pages);
-
-	return t;
-
-err_out_exit:
-	return NULL;
-}
-
-int netfs_trans_init(void)
-{
-	int err = -ENOMEM;
-
-	netfs_trans_dst = kmem_cache_create("netfs_trans_dst", sizeof(struct netfs_trans_dst),
-			0, 0, NULL);
-	if (!netfs_trans_dst)
-		goto err_out_exit;
-
-	netfs_trans_dst_pool = mempool_create_slab_pool(256, netfs_trans_dst);
-	if (!netfs_trans_dst_pool)
-		goto err_out_free;
-
-	return 0;
-
-err_out_free:
-	kmem_cache_destroy(netfs_trans_dst);
-err_out_exit:
-	return err;
-}
-
-void netfs_trans_exit(void)
-{
-	mempool_destroy(netfs_trans_dst_pool);
-	kmem_cache_destroy(netfs_trans_dst);
-}

--gKMricLos+KVdGMg--
