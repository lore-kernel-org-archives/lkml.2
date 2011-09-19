Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1ISGNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:13:10 -0400
Received: from tservice.net.ru ([195.178.208.66]:38284 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751315Ab1ISGNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:13:07 -0400
Date: Mon, 19 Sep 2011 10:13:02 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Subject: POHMELFS is back
Message-ID: <20110919061302.GA19699@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

POHMELFS is a distributed filesystem originally created as a
cache-coherent pNFS. Practice showed that parallel NFS as well as NFS
itself is not a way to go because of scalability issues, thus POHMELFS
never got out of staging dir.

So I rewrote POHMELFS from scratch as a frontend to Elliptics network.

Elliptics is a distributed key/value storage, which by default
implements hash table system. It has datacenter-aware replica
management, does not have single points of failure like any kind of
master node/server, column store (with SELECT-like range requests),
compression support and so on.

First production elliptics cluster was deployed about 2 years ago,
it is close to 1 Pb (around 200 storage nodes in 4 datacenters) now with
more that 4 Gb/s of bandwidth from each datacenter,
another one with the biggest number of objects hosts about 400+ millions
(not counting that each of them has 3 copies) in 3 different datacenters.
Currently there are 5 big clusters in production.

I run a small ask-and-talk presentation today at YaC conference in Moscow.

POHMELFS currently is rather alpha version, since it does not support
object removal as well as does not balance reads between multiple
groups. Also directory structure is not scalable enough, so it will be
changed when elliptics starts supporting server-side scripting (in Lua),
which also will be used by elliptics for internal mapreduce
implementation.

This patch is aimed for initial review and discussion.
Thank you.

1. Elliptics network
http://www.ioremap.net/projects/elliptics


Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

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
index 0000000..d75c446
--- /dev/null
+++ b/fs/pohmelfs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux ext2-filesystem routines.
+#
+
+obj-$(CONFIG_POHMELFS) += pohmelfs.o
+
+pohmelfs-y := dir.o file.o inode.o net.o route.o super.o trans.o
diff --git a/fs/pohmelfs/Module.symvers b/fs/pohmelfs/Module.symvers
new file mode 100644
index 0000000..e69de29
diff --git a/fs/pohmelfs/dir.c b/fs/pohmelfs/dir.c
new file mode 100644
index 0000000..69bf48b
--- /dev/null
+++ b/fs/pohmelfs/dir.c
@@ -0,0 +1,574 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/fs.h>
+#include <linux/dcache.h>
+
+#include "pohmelfs.h"
+
+int pohmelfs_send_inode_info(struct pohmelfs_inode *pi, struct dnet_raw_id *id, const char *sname, int len, int overwrite)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
+	struct pohmelfs_inode_info *info;
+	struct pohmelfs_io io;
+	char *dname;
+	int err;
+
+	if (!len) {
+		err = -EINVAL;
+		goto err_out_exit;
+	}
+
+	memset(&io, 0, sizeof(struct pohmelfs_io));
+
+	info = kmalloc(sizeof(struct pohmelfs_inode_info) + len, GFP_NOIO);
+	if (!info) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+	dname = (char *)(info + 1);
+
+	pohmelfs_fill_inode_info(&pi->vfs_inode, info);
+	pi->isize = info->size;
+	info->namelen = len;
+
+	pohmelfs_hash(psb, sname, len, &info->name);
+
+	memcpy(dname, sname, len);
+
+	pohmelfs_convert_inode_info(info);
+
+	io.pi = pi;
+	io.id = id;
+	io.group = 2;
+	io.cmd = DNET_CMD_WRITE;
+	io.aflags = DNET_ATTR_NOCSUM;
+	io.size = sizeof(struct pohmelfs_inode_info) + len;
+	io.ioflags = DNET_IO_FLAGS_APPEND;
+	io.data = info;
+	io.alloc_flags = POHMELFS_IO_OWN;
+
+	err = pohmelfs_send_io(&io);
+	pr_info("pohmelfs: pohmelfs_send_inode_info: %s: pohmelfs_send_io: object ino: %lu, "
+			"name: %s, overwrite: %d, offset: %llu, isize: %llu, mtime: %lu.%lu: %d\n",
+		pohmelfs_dump_id(id->id), pi->vfs_inode.i_ino,
+		sname, overwrite, pi->offset, pi->isize,
+		pi->vfs_inode.i_mtime.tv_sec, pi->vfs_inode.i_mtime.tv_nsec,
+		err);
+
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
+	memcpy(&pi->parent_id, &parent->id, sizeof(struct dnet_raw_id));
+
+	err = pohmelfs_send_inode_info(pi, &parent->id, dentry->d_name.name, dentry->d_name.len, 0);
+	if (err)
+		goto err_out_put;
+
+	pr_info("pohmelfs: create: %s, ino: %lu, parent dir: %lu, object: %s\n",
+			pohmelfs_dump_id(pi->id.id), pi->vfs_inode.i_ino,
+			dir->i_ino, dentry->d_name.name);
+
+	inode_init_owner(&pi->vfs_inode, dir, mode);
+
+	/*
+	 * calling d_instantiate() implies that
+	 * ->lookup() used d_splice_alias() with NULL inode
+	 *  when it failed to find requested object
+	 */
+	d_instantiate(dentry, &pi->vfs_inode);
+
+	return 0;
+
+err_out_put:
+	iput(&pi->vfs_inode);
+err_out_exit:
+	return err;
+}
+
+struct pohmelfs_lookup_priv {
+	struct pohmelfs_wait		*wait;
+
+	struct kref			refcnt;
+
+	/* if set, all received inodes will be attached to dentries in parent dir */
+	int				load_all;
+
+	/* currently read object name */
+	u32				namelen;
+
+	/* currently read inode info */
+	long				offset;
+
+	/*
+	 * this is the name we are looking for
+	 */
+	struct dnet_raw_id		name_id;
+
+	int				found;
+	/*
+	 * will be filled, if inode with given name was found
+	 */
+	struct dnet_raw_id		inode_id;
+};
+
+static void pohmelfs_lookup_free(struct kref *kref)
+{
+	struct pohmelfs_lookup_priv *priv = container_of(kref, struct pohmelfs_lookup_priv, refcnt);
+
+	if (priv->wait)
+		pohmelfs_wait_put(priv->wait);
+	kfree(priv);
+}
+
+static int pohmelfs_lookup_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_lookup_priv *priv = t->priv;
+	struct pohmelfs_wait *wait = priv->wait;
+	struct dnet_cmd *cmd = &recv->cmd;
+
+	if (t->recv_data) {
+		kfree(t->recv_data);
+		t->recv_data = NULL;
+	}
+
+	if (!(cmd->flags & DNET_FLAGS_MORE)) {
+		int err = cmd->status;
+
+		if (!priv->found && !err && !priv->load_all)
+			err = -ENOENT;
+
+		wait->condition = 1;
+		wake_up(&wait->wq);
+
+		pohmelfs_print_addr(&recv->sa, "%s: pohmelfs_lookup_complete: %d\n",
+				pohmelfs_dump_id(priv->name_id.id), err);
+
+		kref_put(&priv->refcnt, pohmelfs_lookup_free);
+
+		return err;
+	}
+
+	return 0;
+}
+
+static int pohmelfs_lookup_dentry(struct pohmelfs_lookup_priv *priv, struct pohmelfs_inode *pi, char *name)
+{
+	struct inode *inode = &pi->vfs_inode;
+	struct inode *dir = &priv->wait->pi->vfs_inode;
+	struct dentry *dentry, *parent_dentry, *old;
+	struct qstr str;
+	int err;
+
+	str.name = name;
+	str.len = priv->namelen;
+	str.hash = full_name_hash(str.name, str.len);
+
+	name[str.len] = '\0';
+
+	/* we do not need to hold dir->i_mutex here, don't we? :) */
+	parent_dentry = d_find_alias(dir);
+	if (!parent_dentry) {
+		err = -ENOENT;
+		goto read_name_out_unlock;
+	}
+
+	dentry = d_lookup(parent_dentry, &str);
+	if (dentry) {
+		err = -EEXIST;
+		dput(dentry);
+		goto read_name_out_put_parent;
+	}
+	/*
+	 * if things are ok, dentry has 2 references -
+	 * one in parent dir, and another its own,
+	 * which we should drop
+	 */
+	dentry = d_alloc(parent_dentry, &str);
+	if (!dentry) {
+		err = -ENOMEM;
+		goto read_name_out_put_parent;
+	}
+
+	old = d_splice_alias(inode, dentry);
+	if (unlikely(old)) {
+		dput(dentry);
+		dentry = old;
+	} else {
+		dput(dentry);
+	}
+
+	dput(parent_dentry);
+	return 0;
+
+read_name_out_put_parent:
+	dput(parent_dentry);
+read_name_out_unlock:
+	iput(inode);
+
+	return err;
+}
+
+static int pohmelfs_lookup_recv_inode(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_lookup_priv *priv = t->priv;
+	u32 iisize = sizeof(struct pohmelfs_inode_info) + priv->namelen;
+	int attr_size = sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
+	struct pohmelfs_sb *psb = pohmelfs_sb(t->inode->i_sb);
+	struct pohmelfs_inode_info *info = t->recv_data;
+	struct pohmelfs_inode *pi;
+	struct inode *inode;
+	char *name;
+	int err;
+
+	/* reading name which follows inode_info */
+	err = pohmelfs_data_recv(recv, t->recv_data + priv->offset, iisize - priv->offset, MSG_DONTWAIT);
+	if (err < 0)
+		goto err_out_exit;
+
+	t->recv_offset += err;
+	priv->offset += err;
+
+	if (priv->offset < iisize) {
+		err = -EAGAIN;
+		goto err_out_exit;
+	}
+
+	name = (char *)(info + 1);
+	/* we allocated enough space for this */
+	name[priv->namelen] = '\0';
+
+	pohmelfs_print_addr(&recv->sa, "name: %s: ino: %llu, removed: %d, name: %s, namelen: %u, size: %llu, mtime: %llu.%llu\n",
+			pohmelfs_dump_id(info->name.id), (unsigned long long)info->ino,
+			!!(info->flags & POHMELFS_INODE_INFO_REMOVED), name, priv->namelen,
+			(unsigned long long)info->size,
+			(unsigned long long)info->mtime.tsec, (unsigned long long)info->mtime.tnsec);
+
+	if (info->flags & POHMELFS_INODE_INFO_REMOVED) {
+		err = -ENOENT;
+		goto err_out_done;
+	}
+
+	pi = pohmelfs_sb_inode_lookup(psb, &info->id);
+	if (pi) {
+		inode = &pi->vfs_inode;
+
+		pohmelfs_fill_inode(inode, info);
+		iput(inode);
+
+		err = -EEXIST;
+		goto err_out_done;
+	} else {
+		pi = pohmelfs_existing_inode(recv->psb, info);
+		if (IS_ERR(pi)) {
+			err = PTR_ERR(pi);
+			goto err_out_done;
+		}
+
+		memcpy(&pi->parent_id, &priv->wait->pi->id, sizeof(struct dnet_raw_id));
+
+		pi->offset = t->recv_offset - sizeof(struct pohmelfs_inode_info) - attr_size;
+
+		if (priv->load_all) {
+			pohmelfs_lookup_dentry(priv, pi, name);
+		} else {
+			if (!memcmp(&info->name, &priv->name_id, sizeof(struct dnet_raw_id))) {
+				if (!priv->found)
+					memcpy(&priv->inode_id, &pi->id, sizeof(struct dnet_raw_id));
+				priv->found = 1;
+			} else {
+				pohmelfs_lookup_dentry(priv, pi, name);
+			}
+		}
+	}
+
+	err = 0;
+
+err_out_done:
+	priv->namelen = 0;
+	priv->offset = 0;
+err_out_exit:
+	pohmelfs_print_addr(&recv->sa, "pohmelfs_lookup_recv_inode: complete: recv_offset: %llu/%llu: %d\n",
+			t->recv_offset, (unsigned long long)recv->cmd.size, err);
+	return err;
+}
+
+static int pohmelfs_lookup_recv_reply(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_lookup_priv *priv = t->priv;
+	struct dnet_cmd *cmd = &recv->cmd;
+	int attr_size = sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
+	int err = 0;
+
+	if (!t->recv_data) {
+		t->recv_data = kmalloc(sizeof(struct pohmelfs_inode_info) + NAME_MAX + 1, GFP_NOIO);
+		if (!t->recv_data) {
+			err = -ENOMEM;
+			goto err_out_exit;
+		}
+
+		pohmelfs_print_addr(&recv->sa, "name: %s: recv_data: %p, cmd size: %llu\n",
+			pohmelfs_dump_id(priv->name_id.id), t->recv_data, (unsigned long long)cmd->size);
+	}
+
+	if (t->recv_offset < attr_size) {
+		void *attr = &t->cmd.attr;
+
+		err = pohmelfs_data_recv(recv, attr + t->recv_offset, attr_size - t->recv_offset, MSG_DONTWAIT);
+		if (err < 0)
+			goto err_out_exit;
+		t->recv_offset += err;
+
+		if (t->recv_offset == attr_size) {
+			dnet_convert_attr(&t->cmd.attr);
+			dnet_convert_io_attr(&t->cmd.p.io);
+
+			pohmelfs_print_addr(&recv->sa, "%s: io size: %llu\n",
+				pohmelfs_dump_id(cmd->id.id), (unsigned long long)cmd->size);
+		}
+	}
+
+	if (t->recv_offset == attr_size)
+		priv->offset = 0;
+
+	if (t->recv_offset >= attr_size) {
+		pohmelfs_print_addr(&recv->sa, "%s: total size: %llu/%llu, priv offset: %lu, inode_info: %zu, priv_namelen: %d\n",
+			pohmelfs_dump_id(cmd->id.id),
+			t->recv_offset, (unsigned long long)cmd->size,
+			priv->offset, sizeof(struct pohmelfs_inode_info),
+			priv->namelen);
+
+		if (priv->offset < sizeof(struct pohmelfs_inode_info)) {
+			/* receiving pohmelfs_inode_info first */
+			err = pohmelfs_data_recv(recv, t->recv_data + priv->offset,
+					sizeof(struct pohmelfs_inode_info) - priv->offset, MSG_DONTWAIT);
+			if (err < 0)
+				goto err_out_exit;
+
+			t->recv_offset += err;
+			priv->offset += err;
+			priv->namelen = 0;
+		}
+
+		if ((priv->offset == sizeof(struct pohmelfs_inode_info)) && !priv->namelen) {
+			struct pohmelfs_inode_info *info = t->recv_data;
+
+			pohmelfs_convert_inode_info(info);
+			priv->namelen = info->namelen;
+
+			/* broken entry, reset */
+			if (!priv->namelen) {
+				pohmelfs_print_addr(&recv->sa, "%s: broken: size: %llu, ino: %llu, mtime: %llu.%llu\n",
+					pohmelfs_dump_id(cmd->id.id), (unsigned long long)info->size, (unsigned long long)info->ino,
+					(unsigned long long)info->mtime.tsec, (unsigned long long)info->mtime.tnsec);
+				priv->offset = 0;
+				err = -EINVAL;
+				goto err_out_exit;
+			}
+		}
+
+		if ((priv->offset >= sizeof(struct pohmelfs_inode_info)) && priv->namelen) {
+			pohmelfs_lookup_recv_inode(t, recv);
+		}
+
+	}
+
+	return 0;
+
+err_out_exit:
+	return err;
+}
+
+static struct pohmelfs_inode *pohmelfs_warm_dir(struct inode *dir, struct dentry *dentry)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	struct pohmelfs_inode *pi;
+	struct pohmelfs_io io;
+	struct pohmelfs_lookup_priv *priv;
+	struct pohmelfs_wait *wait;
+	long ret;
+	int err;
+
+	priv = kzalloc(sizeof(struct pohmelfs_lookup_priv), GFP_NOIO);
+	if (!priv) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	kref_init(&priv->refcnt);
+
+	wait = pohmelfs_wait_alloc(parent);
+	if (!wait) {
+		err = -ENOMEM;
+		goto err_out_put;
+	}
+
+	priv->wait = wait;
+	kref_get(&priv->refcnt);
+
+	if (!dentry)
+		priv->load_all = 1;
+	else {
+		pohmelfs_hash(psb, dentry->d_name.name, dentry->d_name.len, &priv->name_id);
+	}
+
+	memset(&io, 0, sizeof(struct pohmelfs_io));
+
+	io.pi = parent;
+	io.id = &parent->id;
+	io.group = 2;
+	io.aflags = DNET_ATTR_NOCSUM;
+	io.cmd = DNET_CMD_READ;
+	io.recv_reply = pohmelfs_lookup_recv_reply;
+	io.complete = pohmelfs_lookup_complete;
+	io.priv = priv;
+
+	err = pohmelfs_send_io(&io);
+	if (err) {
+		pr_info("pohmelfs: pohmelfs_warm_dir: pohmelfs_send_io: %s, ino: %lu: %d\n",
+				pohmelfs_dump_id(parent->id.id), dir->i_ino, err);
+		goto err_out_put;
+	}
+
+	ret = wait_event_interruptible_timeout(wait->wq, wait->condition != 0, msecs_to_jiffies(psb->read_wait_timeout));
+	if (ret <= 0) {
+		err = ret;
+		if (ret == 0)
+			err = -ETIMEDOUT;
+		goto err_out_put;
+	}
+
+	err = -ENOENT;
+	if (!priv->found)
+		goto err_out_put;
+
+	pi = pohmelfs_sb_inode_lookup(psb, &priv->inode_id);
+	if (!pi)
+		goto err_out_put;
+
+	kref_put(&priv->refcnt, pohmelfs_lookup_free);
+	return pi;
+
+err_out_put:
+	kref_put(&priv->refcnt, pohmelfs_lookup_free);
+err_out_exit:
+	pr_info("pohmelfs: pohmelfs_warm_dir: %s, parent: %lu: %d\n",
+		pohmelfs_dump_id(parent->id.id), dir->i_ino, err);
+	return ERR_PTR(err);
+}
+
+static struct dentry *pohmelfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+{
+	struct pohmelfs_inode *pi;
+	struct inode *inode = NULL;
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	int err;
+
+	pi = pohmelfs_warm_dir(dir, dentry);
+	if (IS_ERR(pi)) {
+		err = PTR_ERR(pi);
+		if (err != -ENOENT)
+			goto err_out_exit;
+	} else {
+		inode = &pi->vfs_inode;
+
+		pr_info("pohmelfs: lookup: %s, parent: %lu, object: %s -> ino: %lu\n",
+			pohmelfs_dump_id(parent->id.id), dir->i_ino, dentry->d_name.name, pi->vfs_inode.i_ino);
+
+		/* we grabbed a reference in pohmelfs_sb_inode_lookup() */
+		iput(inode);
+	}
+
+	return d_splice_alias(inode, dentry);
+
+err_out_exit:
+	pr_err("pohmelfs: lookup failed: %s, parent: %lu, object: %s: %d\n",
+		pohmelfs_dump_id(parent->id.id), dir->i_ino, dentry->d_name.name, err);
+	return ERR_PTR(err);
+}
+
+static int pohmelfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
+	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
+	struct pohmelfs_inode *pi;
+	struct inode *inode;
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
+	inode = &pi->vfs_inode;
+
+	inode_inc_link_count(inode);
+	inode_inc_link_count(inode);
+
+	memcpy(&pi->parent_id, &parent->id, sizeof(struct dnet_raw_id));
+
+	err = pohmelfs_send_inode_info(pi, &parent->id, dentry->d_name.name, dentry->d_name.len, 0);
+	if (err)
+		goto err_out_put;
+
+	pr_info("pohmelfs: mkdir: %s, ino: %lu, parent dir: %lu, object: %s\n",
+			pohmelfs_dump_id(pi->id.id), pi->vfs_inode.i_ino,
+			dir->i_ino, dentry->d_name.name);
+
+	d_instantiate(dentry, inode);
+	return 0;
+
+err_out_put:
+	iput(inode);
+err_out_dir:
+	inode_dec_link_count(dir);
+	return err;
+}
+
+const struct inode_operations pohmelfs_dir_inode_operations = {
+	.create		= pohmelfs_create,
+	.lookup 	= pohmelfs_lookup,
+	.mkdir		= pohmelfs_mkdir,
+};
+
+static int pohmelfs_readdir(struct file *file, void *dirent, filldir_t filldir)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+
+	if (!file->f_pos) {
+		pr_info("pohmelfs: readdir: %s: ino: %lu\n", pohmelfs_dump_id(pi->id.id), inode->i_ino);
+		pohmelfs_warm_dir(inode, NULL);
+	}
+
+	return dcache_readdir(file, dirent, filldir);
+}
+
+const struct file_operations pohmelfs_dir_fops = {
+	.open		= dcache_dir_open,
+	.release	= dcache_dir_close,
+	.llseek		= dcache_dir_lseek,
+
+	.read		= generic_read_dir,
+	.readdir	= pohmelfs_readdir,
+};
diff --git a/fs/pohmelfs/file.c b/fs/pohmelfs/file.c
new file mode 100644
index 0000000..1321ed1
--- /dev/null
+++ b/fs/pohmelfs/file.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/fs.h>
+
+#include "pohmelfs.h"
+
+static int pohmelfs_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = dentry->d_inode;
+	int err;
+
+	err = inode_change_ok(inode, iattr);
+	if (err)
+		return err;
+
+	if (iattr->ia_valid & ATTR_SIZE && iattr->ia_size != inode->i_size) {
+		truncate_setsize(inode, iattr->ia_size);
+
+		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		if (inode_needs_sync(inode)) {
+			sync_inode_metadata(inode, 1);
+		}
+	}
+	setattr_copy(inode, iattr);
+	mark_inode_dirty(inode);
+
+	pr_info("pohmelfs_setattr: ino: %lu, size: %llu, mtime: %lu.%lu\n",
+			inode->i_ino, inode->i_size, inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec);
+
+	return err;
+}
+
+static int pohmelfs_send_prepare_commit(struct pohmelfs_inode *pi, size_t len, loff_t pos, int prepare)
+{
+	struct pohmelfs_io io;
+
+	memset(&io, 0, sizeof(struct pohmelfs_io));
+
+	io.pi = pi;
+	io.id = &pi->id;
+	io.group = 2;
+	io.cmd = DNET_CMD_WRITE;
+	io.offset = pos;
+	io.num = len + pos;
+	io.aflags = DNET_ATTR_NOCSUM;
+	if (prepare)
+		io.ioflags = DNET_IO_FLAGS_PREPARE;
+	else
+		io.ioflags = DNET_IO_FLAGS_COMMIT;
+	io.ioflags |= DNET_IO_FLAGS_PLAIN_WRITE;
+
+	return pohmelfs_send_io(&io);
+}
+
+static ssize_t pohmelfs_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos)
+{
+	ssize_t err;
+	struct inode *inode = filp->f_mapping->host;
+#if 0
+	struct inode *inode = filp->f_mapping->host;
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	loff_t offset = *ppos;
+	err = pohmelfs_send_prepare_commit(pi, len, offset, 1);
+	if (err)
+		goto err_out_exit;
+
+	err = do_sync_write(filp, buf, len, ppos);
+	pohmelfs_send_prepare_commit(pi, 0, 0, 0);
+
+err_out_exit:
+	return err;
+#else
+	err = do_sync_write(filp, buf, len, ppos);
+	pr_info("pohmelfs_write: ino: %lu size: %llu, notime: %d, mtime: %lu.%lu\n",
+			inode->i_ino, inode->i_size, IS_NOCMTIME(inode),
+			inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec);
+#endif
+
+	return err;
+}
+
+const struct file_operations pohmelfs_file_ops = {
+	.open		= generic_file_open,
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
+	.write		= pohmelfs_write,
+	.aio_write	= generic_file_aio_write,
+};
+
+const struct inode_operations pohmelfs_file_inode_operations = {
+	.setattr	= pohmelfs_setattr,
+};
diff --git a/fs/pohmelfs/inode.c b/fs/pohmelfs/inode.c
new file mode 100644
index 0000000..8924fb3
--- /dev/null
+++ b/fs/pohmelfs/inode.c
@@ -0,0 +1,620 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/cred.h>
+#include <linux/fiemap.h>
+#include <linux/mpage.h>
+#include <linux/namei.h>
+#include <linux/pagemap.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/writeback.h>
+
+#include "pohmelfs.h"
+
+static inline char *pohmelfs_dump_id_len_raw(const unsigned char *id, unsigned int len, char *dst)
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
+
+	sc = &get_cpu_var(dnet_raw_id_scratch_per_cpu);
+	get_random_bytes(&sc->rand, sizeof(sc->rand));
+	sc->ts = CURRENT_TIME;
+
+	err = pohmelfs_hash(psb, sc, sizeof(dnet_raw_id_scratch_t), id);
+	put_cpu_var(sc);
+
+	return err;
+}
+
+static struct pohmelfs_inode *pohmelfs_sb_inode_insert(struct pohmelfs_sb *psb, struct pohmelfs_inode *pi)
+{
+	struct rb_node **n = &psb->inode_root.rb_node, *parent = NULL;
+	struct pohmelfs_inode *tmp, *found = NULL;
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
+			if (!igrab(&tmp->vfs_inode)) {
+				err = -ENOENT;
+			} else {
+				found = tmp;
+			}
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
+	if (err)
+		return ERR_PTR(err);
+	return found;
+	
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
+	pi = kmem_cache_alloc(pohmelfs_inode_cache, GFP_NOIO);
+	if (!pi)
+		goto err_out_exit;
+
+	pi->offset = 0;
+	rb_init_node(&pi->node);
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
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+
+	spin_lock(&psb->inode_lock);
+	if (rb_parent(&pi->node) != &pi->node)
+		rb_erase(&pi->node, &psb->inode_root);
+	spin_unlock(&psb->inode_lock);
+
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
+static int pohmelfs_readpages(struct file *filp, struct address_space *mapping,
+			struct list_head *pages, unsigned nr_pages)
+{
+	struct inode *inode = mapping->host;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+
+	pr_info("pohmelfs: %s: ino: %lu, read pages: %u\n", pohmelfs_dump_id(pi->id.id), inode->i_ino, nr_pages);
+
+	return 0;
+}
+
+static int pohmelfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+
+	pr_info("pohmelfs: %s: ino: %lu: write pages: %ld\n", pohmelfs_dump_id(pi->id.id), inode->i_ino, wbc->nr_to_write);
+	return 0;
+}
+
+static int pohmelfs_write_page_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
+	struct dnet_cmd *cmd = &recv->cmd;
+	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
+
+	pr_info("pohmelfs: %s: write page complete: %llu, flags: %x, status: %d\n",
+			pohmelfs_dump_id(pi->id.id), trans, cmd->flags, cmd->status);
+
+	if (!(cmd->flags & DNET_FLAGS_MORE)) {
+		if (cmd->status)
+			set_page_dirty(t->page);
+
+		unlock_page(t->page);
+		page_cache_release(t->page);
+	}
+
+	return 0;
+}
+
+static int pohmelfs_write_end(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned copied, struct page *page, void *fsdata)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	loff_t last_pos = pos + copied;
+	struct pohmelfs_io io;
+	int err;
+
+	memset(&io, 0, sizeof(struct pohmelfs_io));
+
+	io.pi = pi;
+	io.id = &pi->id;
+	io.group = 2;
+	io.cmd = DNET_CMD_WRITE;
+	io.offset = pos & (PAGE_CACHE_SIZE - 1);
+	io.size = copied;
+	io.aflags = DNET_ATTR_NOCSUM;
+	//io.ioflags = DNET_IO_FLAGS_PLAIN_WRITE;
+	io.ioflags = 0;
+	io.page = page;
+	io.complete = pohmelfs_write_page_complete;
+
+	err = pohmelfs_send_io(&io);
+	if (err)
+		goto err_out_exit;
+
+	/* zero the stale part of the page if we did a short copy */
+	if (copied < len) {
+		unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+
+		zero_user(page, from + copied, len - copied);
+	}
+
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
+	/*
+	 * No need to use i_size_read() here, the i_size
+	 * cannot change under us because we hold the i_mutex.
+	 */
+	if (last_pos > inode->i_size)
+		i_size_write(inode, last_pos);
+
+	return copied;
+
+err_out_exit:
+	return err;
+}
+
+static int pohmelfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	set_page_writeback(page);
+	unlock_page(page);
+	end_page_writeback(page);
+	return 0;
+}
+
+static int pohmelfs_readpage_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
+{
+	struct pohmelfs_wait *wait = t->priv;
+	struct pohmelfs_inode *pi = wait->pi;
+	struct page *page = wait->ret;
+	struct dnet_cmd *cmd = &recv->cmd;
+	unsigned int asize = sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
+
+	if (cmd->size > asize) {
+		void *ptr;
+		void *data = t->recv_data + asize;
+		int size = cmd->size - asize - wait->condition;
+
+		pohmelfs_print_addr(&recv->sa, "%s: pohmelfs_readpage_complete: received: %d, local offset: %d\n",
+				pohmelfs_dump_id(pi->id.id), size, wait->condition);
+		
+		if (size > PAGE_CACHE_SIZE)
+			size = PAGE_CACHE_SIZE;
+
+		if (wait->condition < PAGE_CACHE_SIZE) {
+			ptr = kmap_atomic(page);
+			memcpy(ptr + wait->condition, data, size);
+			kunmap_atomic(ptr);
+
+			wait->condition += size;
+		}
+	}
+
+	if (!(cmd->flags & DNET_FLAGS_MORE)) {
+		SetPageUptodate(page);
+		unlock_page(page);
+		page_cache_release(page);
+
+		pohmelfs_print_addr(&recv->sa, "%s: pohmelfs_readpage_complete: read: %d\n",
+				pohmelfs_dump_id(pi->id.id), wait->condition);
+
+		wake_up(&wait->wq);
+		pohmelfs_wait_put(wait);
+	}
+
+	return 0;
+}
+
+static int pohmelfs_readpage(struct file *file, struct page *page)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct pohmelfs_wait *wait;
+	struct pohmelfs_io io;
+	long ret;
+	int err;
+
+	wait = pohmelfs_wait_alloc(pi);
+	if (!wait) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	memset(&io, 0, sizeof(struct pohmelfs_io));
+
+	io.pi = pi;
+	io.id = &pi->id;
+	io.group = 2;
+	io.cmd = DNET_CMD_READ;
+	io.aflags = DNET_ATTR_NOCSUM;
+	io.offset = page_offset(page);
+	io.size = 0;
+	io.complete = pohmelfs_readpage_complete;
+	io.priv = wait;
+
+	page_cache_get(page);
+
+	wait->ret = page;
+	pohmelfs_wait_get(wait);
+
+	err = pohmelfs_send_io(&io);
+	if (err)
+		goto err_out_put;
+
+	ret = wait_event_interruptible_timeout(wait->wq, wait->condition != 0, msecs_to_jiffies(psb->read_wait_timeout));
+	if (ret <= 0) {
+		err = ret;
+		if (ret == 0)
+			err = -ETIMEDOUT;
+		goto err_out_put;
+	}
+
+err_out_put:
+	pohmelfs_wait_put(wait);
+err_out_exit:
+	return err;
+}
+
+static const struct address_space_operations pohmelfs_aops = {
+	.write_begin		= simple_write_begin,
+	.write_end		= pohmelfs_write_end,
+	.writepage		= pohmelfs_writepage,
+	.set_page_dirty 	= __set_page_dirty_nobuffers,
+	.readpage		= pohmelfs_readpage,
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
+	if (info->mtime.tsec < inode->i_mtime.tv_sec)
+		return;
+	if ((info->mtime.tsec == inode->i_mtime.tv_sec) &&
+			(info->mtime.tnsec <= inode->i_mtime.tv_nsec))
+		return;
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
+	pr_info("pohmelfs: %s: ino: %lu inode is regular: %d, dir: %d, link: %d, mode: %o, "
+			"namelen: %u, size: %llu, mtime: %llu.%llu/%lu.%lu\n",
+			pohmelfs_dump_id(pohmelfs_inode(inode)->id.id), inode->i_ino,
+			S_ISREG(inode->i_mode), S_ISDIR(inode->i_mode),
+			S_ISLNK(inode->i_mode), inode->i_mode, info->namelen, inode->i_size,
+			(unsigned long long)info->mtime.tsec, (unsigned long long)info->mtime.tnsec,
+			inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec);
+
+	inode->i_mtime = pohmelfs_date(&info->mtime);
+	inode->i_atime = pohmelfs_date(&info->atime);
+	inode->i_ctime = pohmelfs_date(&info->ctime);
+}
+
+void pohmelfs_inode_info_current(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info)
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
+struct pohmelfs_inode *pohmelfs_existing_inode(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info)
+{
+	struct pohmelfs_inode *pi, *old;
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
+	pohmelfs_fill_inode(inode, info);
+
+	/*
+	 * i_mapping is a pointer to i_data during inode initialization.
+	 */
+	inode->i_data.a_ops = &pohmelfs_aops;
+
+	if (S_ISREG(inode->i_mode)) {
+		inode->i_fop = &pohmelfs_file_ops;
+		inode->i_op = &pohmelfs_file_inode_operations;
+	} else if (S_ISDIR(inode->i_mode)) {
+		inode->i_fop = &pohmelfs_dir_fops;
+		inode->i_op = &pohmelfs_dir_inode_operations;
+	} else {
+		inode->i_fop = &generic_ro_fops;
+	}
+
+	pi->id = info->id;
+	info->ino = inode->i_ino;
+
+	if (inode->i_state & I_NEW) {
+		old = pohmelfs_sb_inode_insert(psb, pi);
+		if (IS_ERR(old)) {
+			err = PTR_ERR(old);
+			goto err_out_put;
+		}
+		if (old) {
+			pohmelfs_fill_inode(&old->vfs_inode, info);
+			pr_info("pohmelfs: %s: updated existing inode: %ld\n", pohmelfs_dump_id(pi->id.id), old->vfs_inode.i_ino);
+			err = -EEXIST;
+			goto err_out_put;
+		}
+
+		mark_inode_dirty(inode);
+		unlock_new_inode(inode);
+		pr_info("pohmelfs: %s: alloc inode: %ld\n", pohmelfs_dump_id(pi->id.id), inode->i_ino);
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
+	pi->isize = info->size;
+
+	pr_info("pohmelfs: %s: alloc new: ino: %ld\n", pohmelfs_dump_id(pi->id.id), pi->vfs_inode.i_ino);
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
+struct pohmelfs_wait *pohmelfs_wait_alloc(struct pohmelfs_inode *pi)
+{
+	struct pohmelfs_wait *wait;
+
+	wait = kmem_cache_zalloc(pohmelfs_wait_cache, GFP_NOIO);
+	if (!wait) {
+		goto err_out_exit;
+	}
+
+	if (!igrab(&pi->vfs_inode))
+		goto err_out_free;
+
+	wait->pi = pi;
+
+	init_waitqueue_head(&wait->wq);
+	kref_init(&wait->refcnt);
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
index 0000000..470506a
--- /dev/null
+++ b/fs/pohmelfs/net.c
@@ -0,0 +1,527 @@
+/*
+ * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
+ */
+
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/net.h>
+
+#include <net/sock.h>
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
+
+	pohmelfs_print_addr(&st->sa, "recv: %d/%llu\n", err, (unsigned long long)size);
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
+	struct msghdr msg;
+	struct iovec io;
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
+	err = kernel_sendpage(t->st->sock, t->page, t->page_offset, t->data_size, msg.msg_flags);
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
+	struct dnet_cmd *cmd;
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
+		if (t->page)
+			err = pohmelfs_page_send(t);
+		else
+			err = pohmelfs_data_send(t);
+
+		cmd = &t->cmd.cmd; /* LE here, so below print will show garbage on BE machines */
+		pohmelfs_print_addr(&st->sa, "send: %s: group: %d, trans: %llu, size: %llu: %d\n",
+				pohmelfs_dump_id(cmd->id.id), cmd->id.group_id,
+				(unsigned long long)cmd->trans, (unsigned long long)cmd->size, err);
+
+		if (err) {
+			pohmelfs_print_addr(&st->sa, "send error: %d\n", err);
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
+	pr_info("pohmelfs_suck_scratch: %llu\n", (unsigned long long)cmd->size);
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
+	int err;
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
+
+			pohmelfs_print_addr(&st->sa, "recv: %s: group: %d, trans: %llu, reply: %d, size: %llu, flags: %x\n",
+					pohmelfs_dump_id(cmd->id.id), cmd->id.group_id,
+					trans, !!(cmd->trans & DNET_TRANS_REPLY), (unsigned long long)cmd->size, cmd->flags);
+
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
+
+		pohmelfs_print_addr(&st->sa, "recv: %s: group: %d, trans: %lu, size: %llu/%llu, flags: %x\n",
+				pohmelfs_dump_id(cmd->id.id), cmd->id.group_id,
+				t->trans, t->recv_offset, (unsigned long long)cmd->size, cmd->flags);
+
+		if (cmd->size && (t->recv_offset != cmd->size)) {
+			err = t->recv_reply(t, st);
+			if (err && (err != -EAGAIN)) {
+				pohmelfs_print_addr(&st->sa, "recv-reply error: %d\n", err);
+				goto err_out_remove;
+			}
+
+			if (t->recv_offset != cmd->size)
+				goto err_out_continue_put;
+		}
+
+		err = t->complete(t, st);
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
+
+			pohmelfs_suck_scratch(st);
+		}
+
+		continue;
+	}
+
+err_out_exit:
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
+struct pohmelfs_state *pohmelfs_state_create(struct pohmelfs_sb *psb, struct sockaddr_storage *sa, int addrlen, int ask_route)
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
+	kref_init(&st->refcnt);
+
+	INIT_WORK(&st->send_work, pohmelfs_state_send_work);
+	INIT_WORK(&st->recv_work, pohmelfs_state_recv_work);
+
+	st->cmd_read = 1;
+
+	err = sock_create(addr->sa_family, SOCK_STREAM, IPPROTO_TCP, &st->sock);
+	if (err) {
+		pr_err("pohmelfs: %s: sock_create: family: %d, err: %d.\n", __func__, addr->sa_family, err);
+		goto err_out_free;
+	}
+
+	st->sock->sk->sk_allocation = GFP_NOIO;
+	st->sock->sk->sk_sndtimeo = st->sock->sk->sk_rcvtimeo = msecs_to_jiffies(60000);
+
+	err = kernel_connect(st->sock, (struct sockaddr *)addr, addrlen, 0);
+	if (err) {
+		pr_err("pohmelfs: %s: kernel_connect: family: %d, err: %d.\n", __func__, addr->sa_family, err);
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
+	} else {
+		pohmelfs_print_addr(sa, "state exists, using old structure\n");
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
diff --git a/fs/pohmelfs/packet.h b/fs/pohmelfs/packet.h
new file mode 100644
index 0000000..13de1b0
--- /dev/null
+++ b/fs/pohmelfs/packet.h
@@ -0,0 +1,627 @@
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
+/* Do not perform local transformation of the received transaction */
+#define DNET_FLAGS_NO_LOCAL_TRANSFORM	(1<<4)
+
+struct dnet_id {
+	uint8_t			id[DNET_ID_SIZE];
+	uint32_t		group_id;
+	uint32_t		type;
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
+/*
+ * this flag is used when we want backend not to perform any additional actions
+ * except than write data at given offset. This is no-op in filesystem backend,
+ * but eblob one should disable prepare/commit operations.
+ */
+#define DNET_IO_FLAGS_PLAIN_WRITE	(1<<7)
+
+#define DNET_IO_FLAGS_NOCSUM		(1<<8)
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
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* __DNET_PACKET_H */
diff --git a/fs/pohmelfs/pohmelfs.h b/fs/pohmelfs/pohmelfs.h
new file mode 100644
index 0000000..119a4a1
--- /dev/null
+++ b/fs/pohmelfs/pohmelfs.h
@@ -0,0 +1,333 @@
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
+	struct page		*page;
+
+	unsigned long		page_offset;
+
+	unsigned long long	recv_offset;
+	void			*recv_data;
+
+	void			*priv;
+
+	int			(* complete)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
+	int			(* recv_reply)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
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
+struct pohmelfs_state *pohmelfs_state_create(struct pohmelfs_sb *psb, struct sockaddr_storage *sa, int addrlen, int ask_route);
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
+	struct dnet_raw_id	name;
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
+void pohmelfs_inode_info_current(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info);
+
+struct pohmelfs_inode {
+	struct inode		vfs_inode;
+	struct dnet_raw_id	id;
+	struct dnet_raw_id	parent_id;
+
+	struct rb_node		node;
+
+	unsigned long long	offset;
+	unsigned long long	isize;
+};
+
+int pohmelfs_send_inode_info(struct pohmelfs_inode *pi, struct dnet_raw_id *id,
+		const char *sname, int len, int overwrite);
+struct pohmelfs_inode *pohmelfs_sb_inode_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id);
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
+	int			sync;
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
+	char			*fsid;
+	int			fsid_len;
+
+	atomic_long_t		ino;
+	atomic_long_t		trans;
+
+	struct crypto_hash	*hash;
+
+	struct workqueue_struct	*wq;
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
+extern struct kmem_cache *pohmelfs_inode_cache;
+extern struct kmem_cache *pohmelfs_trans_cache;
+extern struct kmem_cache *pohmelfs_inode_info_cache;
+extern struct kmem_cache *pohmelfs_route_cache;
+extern struct kmem_cache *pohmelfs_wait_cache;
+
+struct inode *pohmelfs_alloc_inode(struct super_block *sb);
+void pohmelfs_destroy_inode(struct inode *);
+
+struct pohmelfs_inode *pohmelfs_existing_inode(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info);
+struct pohmelfs_inode *pohmelfs_new_inode(struct pohmelfs_sb *psb, int mode);
+int pohmelfs_hash(struct pohmelfs_sb *psb, const void *data, const size_t size, struct dnet_raw_id *id);
+
+char *pohmelfs_dump_id(const unsigned char *id);
+
+extern const struct file_operations pohmelfs_dir_fops;
+extern const struct inode_operations pohmelfs_dir_inode_operations;
+
+extern const struct file_operations pohmelfs_file_ops;
+extern const struct inode_operations pohmelfs_file_inode_operations;
+
+extern void *pohmelfs_scratch_buf;
+extern int pohmelfs_scratch_buf_size;
+
+#define POHMELFS_IO_OWN			(1<<0)
+
+struct pohmelfs_io {
+	struct pohmelfs_inode		*pi;
+
+	struct dnet_raw_id		*id;
+
+	int				group;
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
+	u32				alloc_flags;
+	void				*data;
+
+	struct page			*page;
+
+	void				*priv;
+
+	int				(* complete)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
+	int				(* recv_reply)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
+};
+
+int pohmelfs_send_io(struct pohmelfs_io *pio);
+int pohmelfs_send_buf(struct pohmelfs_state *st, struct pohmelfs_io *pio);
+
+int pohmelfs_data_recv(struct pohmelfs_state *st, void *buf, u64 size, unsigned int flags);
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
+struct pohmelfs_wait {
+	wait_queue_head_t	wq;
+	struct pohmelfs_inode	*pi;
+	void			*ret;
+	int			condition;
+	struct kref		refcnt;
+};
+
+struct pohmelfs_wait *pohmelfs_wait_alloc(struct pohmelfs_inode *pi);
+void pohmelfs_wait_put(struct pohmelfs_wait *wait);
+static inline void pohmelfs_wait_get(struct pohmelfs_wait *wait)
+{
+	kref_get(&wait->refcnt);
+}
+
+#endif /* __POHMELFS_H */
diff --git a/fs/pohmelfs/route.c b/fs/pohmelfs/route.c
new file mode 100644
index 0000000..5596407
--- /dev/null
+++ b/fs/pohmelfs/route.c
@@ -0,0 +1,274 @@
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
+	struct rb_node *n, *next;
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
+			next = rb_next(&rt->node);
+
+			if (rt->st == st) {
+				pohmelfs_route_remove_nolock(psb, rt);
+				found = 1;
+				break;
+			}
+
+			n = next;
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
+		st = pohmelfs_state_create(psb, (struct sockaddr_storage *)&a->addr.addr, a->addr.addr_len, 0);
+		if (IS_ERR(st)) {
+			err = PTR_ERR(st);
+
+			if (err == -EEXIST) {
+				spin_lock(&psb->state_lock);
+				st = pohmelfs_addr_exist(psb, (struct sockaddr_storage *)&a->addr.addr, a->addr.addr_len);
+				if (st) {
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
+	struct pohmelfs_io io;
+	int err;
+
+	memset(&io, 0, sizeof(struct pohmelfs_io));
+
+	io.pi = psb->root;
+	io.id = &psb->root->id;
+	io.cmd = DNET_CMD_ROUTE_LIST;
+	io.cflags = DNET_FLAGS_DIRECT;
+	io.complete = pohmelfs_route_request_complete;
+
+	err = pohmelfs_send_buf(st, &io);
+	if (err) {
+		pohmelfs_print_addr(&st->sa, "pohmelfs: pohmelfs_route_request: %d\n", err);
+		goto err_out_exit;
+	}
+	pohmelfs_print_addr(&st->sa, "route request sent\n");
+
+err_out_exit:
+	return err;
+}
diff --git a/fs/pohmelfs/super.c b/fs/pohmelfs/super.c
new file mode 100644
index 0000000..3921048
--- /dev/null
+++ b/fs/pohmelfs/super.c
@@ -0,0 +1,515 @@
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
+
+static atomic_t psb_bdi_num = ATOMIC_INIT(0);
+
+static void pohmelfs_cleanup_psb(struct pohmelfs_sb *psb)
+{
+	struct pohmelfs_state *st, *tmp;
+
+	list_for_each_entry_safe(st, tmp, &psb->state_list, state_entry) {
+		list_del_init(&st->state_entry);
+
+		pohmelfs_state_kill(st);
+	}
+
+	destroy_workqueue(psb->wq);
+	crypto_free_hash(psb->hash);
+
+	kfree(psb->fsid);
+	kfree(pohmelfs_scratch_buf);
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
+	if (psb->sync)
+		seq_printf(seq, ",sync=%u", psb->sync);
+	if (psb->fsid)
+		seq_printf(seq, ",fsid=%s", psb->fsid);
+	return 0;
+}
+
+static int pohmelfs_drop_inode(struct inode *inode)
+{
+	pr_info("pohmelfs_drop_inode: ino: %lu\n", inode->i_ino);
+	return 1;
+}
+
+static int pohmelfs_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
+	struct dentry *dentry;
+	loff_t isize = i_size_read(inode);
+	int err = 0;
+
+	if (pi == pohmelfs_sb(inode->i_sb)->root)
+		return 0;
+
+	if (pi->isize != isize) {
+		dentry = d_find_alias(inode);
+		if (dentry) {
+			err = pohmelfs_send_inode_info(pi, &pi->parent_id, dentry->d_name.name, dentry->d_name.len, 1);
+			dput(dentry);
+		}
+	}
+
+	return err;
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
+};
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
+	psb->sb = sb;
+
+	pohmelfs_scratch_buf = kmalloc(pohmelfs_scratch_buf_size, GFP_KERNEL);
+	if (!pohmelfs_scratch_buf) {
+		err = -ENOMEM;
+		goto err_out_exit;
+	}
+
+	psb->hash = crypto_alloc_hash("sha512", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(psb->hash)) {
+		err = PTR_ERR(psb->hash);
+		goto err_out_free_scratch;
+	}
+
+	snprintf(name, sizeof(name), "pohmelfs-%d", psb->bdi_num);
+	psb->wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
+	if (!psb->wq) {
+		err = -ENOMEM;
+		goto err_out_crypto_free;
+	}
+
+	return 0;
+
+err_out_crypto_free:
+	crypto_free_hash(psb->hash);
+err_out_free_scratch:
+	kfree(pohmelfs_scratch_buf);
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
+static int pohmelfs_option(char *option, char *data, int *lenp)
+{
+	int len;
+	char *ptr;
+
+	if (!strncmp(option, data, strlen(option))) {
+		len = strlen(option);
+		ptr = data + len;
+
+		if (!ptr || !*ptr)
+			return 0;
+
+		*lenp = len;
+		return 1;
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
+	if (pohmelfs_option("server=", data, &len)) {
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
+		st = pohmelfs_state_create(psb, &sa, addrlen, 1);
+		if (IS_ERR(st)) {
+			err = PTR_ERR(st);
+			goto err_out_exit;
+		}
+	} else if (pohmelfs_option("fsid=", data, &len)) {
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
+	} else if (pohmelfs_option("sync=", data, &len)) {
+		psb->sync = simple_strtol(data + len, NULL, 10);
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
+		if (*ptr == ';') {
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
+	if (!psb->fsid_len) {
+		char str[] = "pohmelfs";
+		err = pohmelfs_hash(psb, str, 8, &psb->root->id);
+	} else {
+		err = pohmelfs_hash(psb, psb->fsid, psb->fsid_len, &psb->root->id);
+	}
+	if (err)
+		goto err_out_put_root;
+
+	sb->s_root = d_alloc_root(&psb->root->vfs_inode);
+	if (!sb->s_root) {
+		err = -ENOMEM;
+		goto err_out_put_root;
+	}
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
+static void pohmelfs_init_inode_once(void *data)
+{
+	struct pohmelfs_inode *ino = data;
+	inode_init_once(&ino->vfs_inode);
+}
+
+static void pohmelfs_cleanup_cache(void)
+{
+	kmem_cache_destroy(pohmelfs_trans_cache);
+	kmem_cache_destroy(pohmelfs_inode_cache);
+	kmem_cache_destroy(pohmelfs_inode_info_cache);
+	kmem_cache_destroy(pohmelfs_route_cache);
+	kmem_cache_destroy(pohmelfs_wait_cache);
+}
+
+static int pohmelfs_init_cache(void)
+{
+	int err = -ENOMEM;
+
+	pohmelfs_inode_cache = kmem_cache_create("pohmelfs_inode",
+				      sizeof(struct pohmelfs_inode),
+				      __alignof__(struct pohmelfs_inode),
+				      (SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
+				      pohmelfs_init_inode_once);
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
+	return 0;
+
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
diff --git a/fs/pohmelfs/trans.c b/fs/pohmelfs/trans.c
new file mode 100644
index 0000000..47eae66
--- /dev/null
+++ b/fs/pohmelfs/trans.c
@@ -0,0 +1,319 @@
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
+	pr_info("pohmelfs: %s: trans freed: %lu, recv_offset: %llu, ino: %ld\n",
+			pohmelfs_dump_id(pi->id.id), t->trans, t->recv_offset, t->inode->i_ino);
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
+	pr_info("pohmelfs: %s: trans complete: %llu, flags: %x\n",
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
+int pohmelfs_send_io(struct pohmelfs_io *pio)
+{
+	struct pohmelfs_inode *pi = pio->pi;
+	struct inode *inode = &pi->vfs_inode;
+	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
+	struct pohmelfs_state *st;
+	struct pohmelfs_trans *t;
+	struct dnet_cmd *cmd;
+	struct dnet_attr *attr;
+	struct dnet_io_attr *io;
+	int err;
+
+	t = pohmelfs_trans_alloc(inode);
+	if (IS_ERR(t)) {
+		err = PTR_ERR(t);
+		goto err_out_exit;
+	}
+
+	st = pohmelfs_state_lookup(psb, pio->id, pio->group);
+	if (!st) {
+		err = -ENOENT;
+		goto err_out_free;
+	}
+
+	t->st = st;
+	pohmelfs_state_get(st);
+
+	cmd = &t->cmd.cmd;
+	attr = &t->cmd.attr;
+	io = &t->cmd.p.io;
+
+	dnet_setup_id(&cmd->id, pio->group, pio->id->id);
+	cmd->flags = DNET_FLAGS_NEED_ACK;
+	cmd->trans = t->trans = atomic_long_inc_return(&psb->trans);
+	cmd->size = pio->size + sizeof(struct dnet_io_attr) + sizeof(struct dnet_attr);
+
+	attr->cmd = pio->cmd;
+	attr->size = pio->size + sizeof(struct dnet_io_attr);
+	attr->flags = pio->aflags;
+
+	memcpy(io->id, pio->id->id, DNET_ID_SIZE);
+	memcpy(io->parent, pio->id->id, DNET_ID_SIZE);
+	io->flags = pio->ioflags;
+	io->size = pio->size;
+	io->offset = pio->offset;
+	io->type = pio->type;
+	io->start = pio->start;
+	io->num = pio->num;
+
+	t->header_size = sizeof(struct dnet_cmd) + sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
+	t->data_size = pio->size;
+
+	dnet_convert_cmd(cmd);
+	dnet_convert_attr(attr);
+	dnet_convert_io_attr(io);
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
+	if (pio->page) {
+		t->page = pio->page;
+		t->page_offset = pio->offset & (PAGE_CACHE_SIZE - 1);
+	}
+
+	t->priv = pio->priv;
+	t->complete = pio->complete;
+	if (!t->complete)
+		t->complete = pohmelfs_buf_complete;
+
+	t->recv_reply = pio->recv_reply;
+	if (!t->recv_reply)
+		t->recv_reply = pohmelfs_buf_recv;
+
+	pohmelfs_trans_insert(t);
+
+	pohmelfs_state_schedule(st);
+	pohmelfs_state_put(st);
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
+int pohmelfs_send_buf(struct pohmelfs_state *st, struct pohmelfs_io *pio)
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
+		st = pohmelfs_state_lookup(psb, pio->id, pio->group);
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
+	dnet_setup_id(&cmd->id, pio->group, pio->id->id);
+	cmd->flags = DNET_FLAGS_NEED_ACK | pio->cflags;
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
+		t->data = kmalloc(pio->size, GFP_NOIO);
+		if (!t->data) {
+			err = -ENOMEM;
+			goto err_out_put_state;
+		}
+
+		memcpy(t->data, pio->data, pio->size);
+	}
+
+	t->priv = pio->priv;
+	t->complete = pio->complete;
+	if (!t->complete)
+		t->complete = pohmelfs_buf_complete;
+
+	t->recv_reply = pio->recv_reply;
+	if (!t->recv_reply)
+		t->recv_reply = pohmelfs_buf_recv;
+
+	pohmelfs_trans_insert(t);
+
+	pohmelfs_state_schedule(st);
+	pohmelfs_state_put(st);
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


-- 
	Evgeniy Polyakov
