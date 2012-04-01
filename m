Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2DAWu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 18:50:26 -0400
Received: from cet.com.ru ([195.178.208.66]:49770 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752777Ab2DAWuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 18:50:23 -0400
Date: Mon, 2 Apr 2012 02:50:18 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [take 4] pohmelfs: call for inclusion
Message-ID: <20120401225018.GA24856@ioremap.net>
References: <20120322164143.GA19973@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322164143.GA19973@ioremap.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Until Linus run away hacking GNOME or glibc or becoming monk with
Al Viro telling people that only peaceful conversation without ever
using undecent words and other pinky bullshit - PING

PING-PING-PING

On Thu, Mar 22, 2012 at 08:41:43PM +0400, Evgeniy Polyakov (zbr@ioremap.net) wrote:
> [ take4 updates patch to use correct dentry_path(). Al, if you feel this
> chunk should be killed, drop me a note and we will go further instead of
> running over and over the same shit, also setup git repo to pull,
> rebased against v3.3 commit]
> 
> I'm please to announce new and completely rewritten distributed
> filesystem - POHMELFS
> 
> It went a long way from parallel NFS design which lived in
> drivers/staging/pohmelfs for years effectively without usage case - that
> design was dead.
> 
> New pohmelfs uses elliptics network [1] as its storage backend, which
> was proved as effective distributed system. Elliptics is used in
> production in Yandex search company for several years now and clusters
> range from small (like 6 nodes in 3 datacenters to host 15 billions of
> small files or hundred of nodes to scale to 1 Pb used for streaming).
> 
> We start to cook up 2 small clusters for production pohmelfs testing -
> one of them is largest in East Europe mirror site, another one is used
> for internal package storage.
> 
> Pohmelfs is just a POSIX frontend to elliptics. It supports hardlinks,
> symlinks, data checksums, multiple copies and so on.
> Pohmelfs uses local cache (synced on timely basis) for all operations,
> and only sync (or close with sync_on_close mount option) or writeback
> will flush data to remote nodes. There is also background work to flush
> data to storage like commit in ext3
> Directory objects are synced to the storage when they are created on
> pohmelfs node, file data is being sent from cache later.
> 
> All recovery process is handled by elliptics and is performed without
> pohmelfs clients every noticing that. In particular reads are always
> directed to the replica with the latest data (determined according to
> ellptics metadata checked at file open time).
> 
> Writes in pohmelfs can be configured to succeed when quorum commits it
> or when specified in 'successful_write_count=' number of writes return
> ok. This is useful when you do not care much about number of active
> replicas, since you know that your data is safe. Or when you create new
> storage and want to copy to single datacenter to save bandwidth.
> 
> But that's enough for advertisement. Here is the code.
> 
> 1. Elliptics network
> http://www.ioremap.net/projects/elliptics
> http://www.elliptics.ru (russian support forum - we understand english
> and will answer pohmelfs questions too)
> 
> 2. Pohmelfs
> http://www.ioremap.net/projects/pohmelfs
> http://www.ioremap.net/taxonomy/term/4 (development blog section)
> 
> 3. POHMELFS git repo (rebased on v3.3)
> http://www.ioremap.net/git/pohmelfs.git
> 
> 
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index d621f02..d7b8308 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -261,6 +261,7 @@ config NFS_COMMON
>  source "net/sunrpc/Kconfig"
>  source "fs/ceph/Kconfig"
>  source "fs/cifs/Kconfig"
> +source "fs/pohmelfs/Kconfig"
>  source "fs/ncpfs/Kconfig"
>  source "fs/coda/Kconfig"
>  source "fs/afs/Kconfig"
> diff --git a/fs/Makefile b/fs/Makefile
> index 93804d4..a2a819f 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -124,3 +124,4 @@ obj-$(CONFIG_GFS2_FS)           += gfs2/
>  obj-y				+= exofs/ # Multiple modules
>  obj-$(CONFIG_CEPH_FS)		+= ceph/
>  obj-$(CONFIG_PSTORE)		+= pstore/
> +obj-$(CONFIG_POHMELFS)		+= pohmelfs/
> diff --git a/fs/pohmelfs/Kconfig b/fs/pohmelfs/Kconfig
> new file mode 100644
> index 0000000..6358362
> --- /dev/null
> +++ b/fs/pohmelfs/Kconfig
> @@ -0,0 +1,11 @@
> +config POHMELFS
> +	tristate "POHMELFS distributed filesystem"
> +	depends on INET && EXPERIMENTAL
> +	select CRYPTO_HASH
> +	help
> +	  POHMELFS is a POSIX frontend to Elliptics network
> +
> +	  Elliptics is a key/value storage, which by default implements
> +	  distributed hash table structure.
> +
> +	  More information can be found at http://www.ioremap.net/projects/elliptics
> diff --git a/fs/pohmelfs/Makefile b/fs/pohmelfs/Makefile
> new file mode 100644
> index 0000000..f38002d
> --- /dev/null
> +++ b/fs/pohmelfs/Makefile
> @@ -0,0 +1,7 @@
> +#
> +# Makefile for the linux pohmel filesystem routines.
> +#
> +
> +obj-$(CONFIG_POHMELFS) += pohmelfs.o
> +
> +pohmelfs-y := dir.o file.o inode.o net.o route.o super.o trans.o symlink.o stat.o pool.o
> diff --git a/fs/pohmelfs/Module.symvers b/fs/pohmelfs/Module.symvers
> new file mode 100644
> index 0000000..e69de29
> diff --git a/fs/pohmelfs/README b/fs/pohmelfs/README
> new file mode 100644
> index 0000000..2e42d5a
> --- /dev/null
> +++ b/fs/pohmelfs/README
> @@ -0,0 +1,84 @@
> +Pohmelfs is a POSIX frontend to elliptics distributed network build on top of DHT design
> +You may find more about elliptics at http://www.ioremap.net/projects/elliptics
> +Or example pohmelfs raid1 configuration at http://www.ioremap.net/node/535
> +
> +Here I will desribe pohmelfs mount options
> +
> +server=addr:port:family
> +Remote node to connect (family may be 2 for IPv4 and 6 for IPv6)
> +You may specify multiple nodes, usually it is ok to put here only subset
> +of all remote nodes in cluster, pohmelfs will automatically discover other nodes
> +
> +fsid=<string>
> +Filesystem ID - you may have multiple filesystems in the same elliptics cluster
> +This ID may be thought of as container or namespace identity
> +By default it is 'pohmelfs' (without quotes)
> +
> +sync_timeout=<int>
> +Timeout in seconds used to synchronize local cache with the storage
> +In particular all pending writes will be flushed to storage.
> +If you read directory, which previously was read more than 'sync_timeout' seconds,
> +it will be reread from storage, otherwise it will be read from local cache.
> +The same logic _will_ apply to file content, right now once read, file will not
> +be reread again until cache is dropped
> +
> +groups=<int>:<int>:...
> +You may specify group IDs to store data to.
> +One may think about group ID as replica ID, i.e. if you specify groups=1:2:3,
> +each write will put data into groups with IDs 1, 2 and 3
> +Read will fetch data from group 1 first, then 2 and 3
> +If your replicas are not in sync, read will fetch elliptics metadata first,
> +determine which replica has the most recent data, and will first try to read
> +that group
> +
> +http_compat=<int>
> +Specifies whether to use hash of full path name as inode ID (512 bits, sha512 is used)
> +Provided number limits number of temporal pages allocated for path traversal, i.e.
> +number of parallel pathes hashed
> +Having something like 5-10 is ok for common cases
> +
> +readcsum/noreadcsum
> +Specifies whether to turn on or off remote checksumming
> +Having read csums for large files may be not a very good idea, since every read
> +will force server to check whole file checksum, so for multi-gigabyte files read
> +of the single page may take a while (until it is already cached)
> +
> +successful_write_count=<num>
> +If not specified, write will be considered successful only if quorum
> +(number of groups above / 2 + 1) of writes succeeded. You may alter this number
> +by given option.
> +Please note, that if write does not succeed, error may only be detected as returned
> +value from sync() or close() syscall. Also, unsuccessful write is rescheduled and
> +all its pages are redirtied again to be resent in future.
> +
> +keepalive_idle=<int>
> +Number of seconds to wait before starting to send first TCP keepalive message
> +
> +keepalive_cnt=<int>
> +Number of TCP keepalive messages to send before closing connection
> +
> +keepalive_interval=<int>
> +Number of seconds between TCP keepalive messages
> +
> +readdir_allocation=<int>
> +Number of pages allocated in one kmalloc() call when reading directory content from server
> +Please note that higher-order allocations may fail, but low-ordered (like 1 or 2 pages)
> +ends up in slow directory read for large directories.
> +It may take up to couple of seconds to read directory with several thousands of entries,
> +but usually because VFS will call ->lookup() method to every directory entry
> +
> +sync_on_close
> +Forces flushing inode (and its data) to disk when file is closed
> +
> +connection_pool_size=<int>
> +Number of simultaneous connections to every remote node. Connections are selected
> +in round-robin fashion, but 1/4 of them (or at least one) are reserved for small-sized requests,
> +which usually carry metadata messages like directory listing or file lookup requests.
> +Messing them with bulk IO requests is always a bad idea.
> +
> +read_wait_timeout=<int>/write_wait_timeout=<int>
> +Maximum number of milliseconds to wait for appropriate request to complete.
> +By default both are equal to 5 seconds, which is not always a good idea especially for huge
> +readahead, big cache writeback intervals and/or rather slow disks.
> +These timeouts are used not only for IO requests, but also for metadata commands like
> +directory listing or object lookup.
> diff --git a/fs/pohmelfs/dir.c b/fs/pohmelfs/dir.c
> new file mode 100644
> index 0000000..67b61ac
> --- /dev/null
> +++ b/fs/pohmelfs/dir.c
> @@ -0,0 +1,1124 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/fs.h>
> +#include <linux/dcache.h>
> +#include <linux/quotaops.h>
> +
> +#include "pohmelfs.h"
> +
> +#define POHMELFS_LOOKUP_SCRIPT				"pohmelfs_lookup.py"
> +#define POHMELFS_UNLINK_SCRIPT				"pohmelfs_unlink.py"
> +#define POHMELFS_DATA_UNLINK_SCRIPT			"pohmelfs_data_unlink.py"
> +#define POHMELFS_HARDLINK_SCRIPT			"pohmelfs_hardlink.py"
> +#define POHMELFS_RENAME_SCRIPT				"pohmelfs_rename.py"
> +#define POHMELFS_INODE_INFO_SCRIPT_INSERT		"pohmelfs_inode_info_insert.py"
> +#define POHMELFS_READDIR_SCRIPT				"pohmelfs_readdir.py"
> +#define POHMELFS_DENTRY_NAME_SCRIPT			"pohmelfs_dentry_name="
> +
> +static void pohmelfs_init_local(struct pohmelfs_inode *pi, struct inode *dir)
> +{
> +	struct inode *inode = &pi->vfs_inode;
> +
> +	inode_init_owner(inode, dir, inode->i_mode);
> +	pi->local = 1;
> +
> +	mark_inode_dirty(inode);
> +}
> +
> +static int pohmelfs_send_dentry_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
> +	struct pohmelfs_wait *wait = t->priv;
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
> +
> +	if (cmd->flags & DNET_FLAGS_MORE) {
> +		if (cmd->status == 0 && cmd->size != sizeof(struct dnet_attr) + 2)
> +			cmd->status = -EINVAL;
> +
> +		pr_debug("%s: %llu, cmd_size: %llu, flags: %x, status: %d\n",
> +			 pohmelfs_dump_id(pi->id.id), trans, cmd->size,
> +			 cmd->flags, cmd->status);
> +
> +		if (!cmd->status)
> +			wait->condition = 1;
> +		else
> +			wait->condition = cmd->status;
> +		wake_up(&wait->wq);
> +	}
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_send_inode_info_init(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_wait *wait = t->priv;
> +
> +	pohmelfs_wait_get(wait);
> +	return 0;
> +}
> +
> +static void pohmelfs_send_inode_info_destroy(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_wait *wait = t->priv;
> +
> +	if (!wait->condition)
> +		wait->condition = 1;
> +	wake_up(&wait->wq);
> +	pohmelfs_wait_put(wait);
> +}
> +
> +static int pohmelfs_lookup_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_inode *parent = pohmelfs_inode(t->inode);
> +	struct pohmelfs_wait *wait = t->priv;
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
> +	int err = cmd->status;
> +
> +	if (err)
> +		goto err_out_exit;
> +
> +	if (cmd->flags & DNET_FLAGS_MORE) {
> +		struct pohmelfs_sb *psb = pohmelfs_sb(t->inode->i_sb);
> +		struct pohmelfs_inode_info *info;
> +		struct pohmelfs_inode *pi;
> +
> +		if (cmd->size != sizeof(struct dnet_attr) + sizeof(struct pohmelfs_inode_info)) {
> +			err = -ENOENT;
> +			goto err_out_exit;
> +		}
> +
> +		pr_debug("%s: %llu, size: %llu, min size: %zu, flags: %x, status: %d\n",
> +			 pohmelfs_dump_id(parent->id.id), trans, cmd->size,
> +			 sizeof(struct dnet_attr) + sizeof(struct pohmelfs_inode_info),
> +			 cmd->flags, cmd->status);
> +
> +
> +		info = t->recv_data + sizeof(struct dnet_attr);
> +		pohmelfs_convert_inode_info(info);
> +
> +		pi = pohmelfs_existing_inode(psb, info);
> +		if (IS_ERR(pi)) {
> +			err = PTR_ERR(pi);
> +
> +			if (err != -EEXIST)
> +				goto err_out_exit;
> +
> +			err = 0;
> +			pi = pohmelfs_sb_inode_lookup(psb, &info->id);
> +			if (!pi) {
> +				err = -ENOENT;
> +				goto err_out_exit;
> +			}
> +
> +			pohmelfs_fill_inode(&pi->vfs_inode, info);
> +		}
> +
> +		wait->ret = pi;
> +	}
> +
> +err_out_exit:
> +	if (err)
> +		wait->condition = err;
> +	else
> +		wait->condition = 1;
> +	wake_up(&wait->wq);
> +
> +	return 0;
> +}
> +
> +int pohmelfs_send_script_request(struct pohmelfs_inode *parent, struct pohmelfs_script_req *req)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(parent->vfs_inode.i_sb);
> +	struct pohmelfs_wait *wait;
> +	struct pohmelfs_io *pio;
> +	struct dnet_exec *e;
> +	int script_len;
> +	long ret;
> +	int err;
> +
> +	/* 2 commas, \n and 0-byte, which is accounted in sizeof(string) */
> +	script_len = sizeof(POHMELFS_DENTRY_NAME_SCRIPT) + req->obj_len + 3;
> +
> +	wait = pohmelfs_wait_alloc(parent);
> +	if (!wait) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!pio) {
> +		err = -ENOMEM;
> +		goto err_out_wait_put;
> +	}
> +
> +	e = kmalloc(sizeof(struct dnet_exec) + req->script_namelen + script_len + req->binary_size, GFP_NOIO);
> +	if (!e) {
> +		err = -ENOMEM;
> +		goto err_out_free_pio;
> +	}
> +
> +	memset(e, 0, sizeof(struct dnet_exec));
> +
> +	snprintf(e->data, req->script_namelen + script_len, "%s%s'%s'\n", req->script_name, POHMELFS_DENTRY_NAME_SCRIPT, req->obj_name);
> +	script_len--; /* do not include last 0-byte in the script */
> +
> +	memcpy(e->data + req->script_namelen + script_len, req->binary, req->binary_size);
> +
> +	e->type = DNET_EXEC_PYTHON_SCRIPT_NAME;
> +	e->name_size = req->script_namelen;
> +	e->script_size = script_len;
> +	e->binary_size = req->binary_size;
> +	dnet_convert_exec(e);
> +
> +	pio->pi = parent;
> +	pio->id = req->id;
> +	pio->group_id = req->group_id;
> +	pio->cflags = DNET_FLAGS_NEED_ACK | req->cflags;
> +
> +	pio->cmd = DNET_CMD_EXEC;
> +	pio->size = sizeof(struct dnet_exec) + req->script_namelen + script_len + req->binary_size;
> +	pio->data = e;
> +	pio->priv = wait;
> +	pio->cb.init = pohmelfs_send_inode_info_init;
> +	pio->cb.destroy = pohmelfs_send_inode_info_destroy;
> +	pio->cb.complete = req->complete;
> +
> +	if (pio->group_id) {
> +		err = pohmelfs_send_buf_single(pio, NULL);
> +	} else {
> +		err = pohmelfs_send_buf(pio);
> +	}
> +	if (err)
> +		goto err_out_free;
> +
> +	{
> +		int len = 6;
> +		char parent_id_str[len*2+1];
> +
> +		pr_debug("SENT: %.*s: %s: inode->id: %s, ino: %lu, object: %s, binary size: %d, ret: %p, condition: %d\n",
> +			 req->script_namelen, req->script_name,
> +			 pohmelfs_dump_id(req->id->id),
> +			 pohmelfs_dump_id_len_raw(parent->id.id, len,
> +						  parent_id_str),
> +			 parent->vfs_inode.i_ino, req->obj_name,
> +			 req->binary_size, req->ret, req->ret_cond);
> +	}
> +
> +	if (req->sync) {
> +		ret = wait_event_interruptible_timeout(wait->wq, wait->condition != 0, msecs_to_jiffies(psb->read_wait_timeout));
> +		if (ret <= 0) {
> +			err = ret;
> +			if (ret == 0)
> +				err = -ETIMEDOUT;
> +			goto err_out_free;
> +		}
> +
> +		if (wait->condition < 0)
> +			err = wait->condition;
> +
> +		req->ret = wait->ret;
> +		req->ret_cond = wait->condition;
> +	}
> +
> +err_out_free:
> +	kfree(e);
> +err_out_free_pio:
> +	kmem_cache_free(pohmelfs_io_cache, pio);
> +err_out_wait_put:
> +	pohmelfs_wait_put(wait);
> +err_out_exit:
> +	{
> +		int len = 6;
> +		char parent_id_str[len*2+1];
> +
> +		pr_debug("DONE: %.*s: %s: inode->id: %s, ino: %lu, object: %s, binary size: %d, ret: %p, condition: %d, err: %d\n",
> +			 req->script_namelen, req->script_name,
> +			 pohmelfs_dump_id(req->id->id),
> +			 pohmelfs_dump_id_len_raw(parent->id.id, len,
> +						  parent_id_str),
> +			 parent->vfs_inode.i_ino, req->obj_name,
> +			 req->binary_size, req->ret, req->ret_cond, err);
> +	}
> +	return err;
> +}
> +
> +int pohmelfs_send_dentry(struct pohmelfs_inode *pi, struct dnet_raw_id *id, const char *sname, int len, int sync)
> +{
> +	struct pohmelfs_script_req req;
> +	struct pohmelfs_dentry *pd;
> +	int err;
> +
> +	if (!len) {
> +		err = -EINVAL;
> +		goto err_out_exit;
> +	}
> +
> +	pd = kmem_cache_alloc(pohmelfs_dentry_cache, GFP_NOIO);
> +	if (!pd) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	pd->parent_id = *id;
> +	pd->disk.id = pi->id;
> +	pd->disk.ino = cpu_to_le64(pi->vfs_inode.i_ino);
> +	pd->disk.type = (pi->vfs_inode.i_mode >> 12) & 15;
> +	pd->disk.len = len;
> +
> +	memset(&req, 0, sizeof(struct pohmelfs_script_req));
> +
> +	req.id = id;
> +
> +	req.script_name = POHMELFS_INODE_INFO_SCRIPT_INSERT;
> +	req.script_namelen = sizeof(POHMELFS_INODE_INFO_SCRIPT_INSERT) - 1; /* not including 0-byte */
> +
> +	req.obj_name = (char *)sname;
> +	req.obj_len = len;
> +
> +	req.binary = pd;
> +	req.binary_size = sizeof(struct pohmelfs_dentry);
> +
> +	req.group_id = 0;
> +	req.id = id;
> +
> +	req.sync = sync;
> +	req.complete = pohmelfs_send_dentry_complete;
> +
> +	err = pohmelfs_send_script_request(pi, &req);
> +	if (err)
> +		goto err_out_free;
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_dentry_cache, pd);
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
> +		struct nameidata *nd)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
> +	struct pohmelfs_inode *pi;
> +	int err;
> +
> +	inode_inc_link_count(dir);
> +
> +	pi = pohmelfs_new_inode(psb, mode);
> +	if (IS_ERR(pi)) {
> +		err = PTR_ERR(pi);
> +		goto err_out_exit;
> +	}
> +	pohmelfs_init_local(pi, dir);
> +	mark_inode_dirty(dir);
> +
> +	/*
> +	 * calling d_instantiate() implies that
> +	 * ->lookup() used d_splice_alias() with NULL inode
> +	 *  when it failed to find requested object
> +	 */
> +	d_instantiate(dentry, &pi->vfs_inode);
> +	if (psb->http_compat)
> +		pohmelfs_http_compat_id(pi);
> +
> +	err = pohmelfs_send_dentry(pi, &pohmelfs_inode(dir)->id, dentry->d_name.name, dentry->d_name.len, 1);
> +	if (err)
> +		goto err_out_exit;
> +
> +	pr_debug("%s: ino: %lu, parent dir: %lu, object: %s\n",
> +		 pohmelfs_dump_id(pi->id.id), pi->vfs_inode.i_ino,
> +		 dir->i_ino, dentry->d_name.name);
> +
> +	return 0;
> +
> +err_out_exit:
> +	inode_dec_link_count(dir);
> +	return err;
> +}
> +
> +static struct pohmelfs_inode *pohmelfs_lookup_group(struct inode *dir, struct dentry *dentry, int group_id)
> +{
> +	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
> +	struct pohmelfs_script_req req;
> +	struct pohmelfs_inode *pi;
> +	int err;
> +
> +	memset(&req, 0, sizeof(struct pohmelfs_script_req));
> +
> +	req.script_name = POHMELFS_LOOKUP_SCRIPT;
> +	req.script_namelen = sizeof(POHMELFS_LOOKUP_SCRIPT) - 1; /* not including 0-byte */
> +
> +	req.obj_name = (char *)dentry->d_name.name;
> +	req.obj_len = dentry->d_name.len;
> +
> +	req.binary = &parent->id;
> +	req.binary_size = sizeof(struct dnet_raw_id);
> +
> +	req.id = &parent->id;
> +	req.complete = pohmelfs_lookup_complete;
> +
> +	req.group_id = group_id;
> +	req.sync = 1;
> +	req.cflags = 0;
> +
> +	err = pohmelfs_send_script_request(parent, &req);
> +	if (err)
> +		goto err_out_exit;
> +
> +	pi = req.ret;
> +	if (!pi) {
> +		err = -ENOENT;
> +		goto err_out_exit;
> +	}
> +
> +	return pi;
> +
> +err_out_exit:
> +	pr_debug("%s: group: %d: parent ino: %lu, name: %s: %d\n",
> +		 pohmelfs_dump_id(parent->id.id), group_id,
> +		 parent->vfs_inode.i_ino, dentry->d_name.name, err);
> +	return ERR_PTR(err);
> +}
> +
> +static struct dentry *pohmelfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
> +	struct inode *inode = NULL;
> +	struct pohmelfs_inode *pi;
> +	int i, err = -ENOENT;
> +
> +	for (i = 0; i < psb->group_num; ++i) {
> +		pi = pohmelfs_lookup_group(dir, dentry, psb->groups[i]);
> +		if (IS_ERR(pi)) {
> +			err = PTR_ERR(pi);
> +			continue;
> +		}
> +
> +		inode = &pi->vfs_inode;
> +		err = 0;
> +		break;
> +	}
> +
> +	return d_splice_alias(inode, dentry);
> +}
> +
> +static int pohmelfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
> +	struct pohmelfs_inode *pi;
> +	int err;
> +
> +	inode_inc_link_count(dir);
> +
> +	pi = pohmelfs_new_inode(psb, mode | S_IFDIR);
> +	if (IS_ERR(pi)) {
> +		err = PTR_ERR(pi);
> +		goto err_out_dir;
> +	}
> +	pohmelfs_init_local(pi, dir);
> +	mark_inode_dirty(dir);
> +
> +	d_instantiate(dentry, &pi->vfs_inode);
> +	if (psb->http_compat)
> +		pohmelfs_http_compat_id(pi);
> +
> +	err = pohmelfs_send_dentry(pi, &pohmelfs_inode(dir)->id, dentry->d_name.name, dentry->d_name.len, 1);
> +	if (err)
> +		goto err_out_dir;
> +
> +	pr_debug("%s: ino: %lu, parent dir: %lu, object: %s, refcnt: %d\n",
> +		 pohmelfs_dump_id(pi->id.id), pi->vfs_inode.i_ino,
> +		 dir->i_ino, dentry->d_name.name, dentry->d_count);
> +	return 0;
> +
> +err_out_dir:
> +	inode_dec_link_count(dir);
> +	return err;
> +}
> +
> +static int pohmelfs_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
> +	struct inode *inode = dentry->d_inode;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	struct pohmelfs_script_req req;
> +	int err;
> +
> +	inode->i_ctime = dir->i_ctime;
> +	mark_inode_dirty(dir);
> +
> +	memset(&req, 0, sizeof(struct pohmelfs_script_req));
> +
> +	req.script_name = POHMELFS_UNLINK_SCRIPT;
> +	req.script_namelen = sizeof(POHMELFS_UNLINK_SCRIPT) - 1; /* not including 0-byte */
> +
> +	req.obj_name = (char *)dentry->d_name.name;
> +	req.obj_len = dentry->d_name.len;
> +
> +	req.binary = &parent->id;
> +	req.binary_size = sizeof(struct dnet_raw_id);
> +
> +	req.group_id = 0;
> +	req.id = &parent->id;
> +	req.complete = pohmelfs_send_dentry_complete;
> +
> +	req.sync = 1;
> +
> +	err = pohmelfs_send_script_request(parent, &req);
> +	if (err)
> +		return err;
> +
> +	req.script_name = POHMELFS_DATA_UNLINK_SCRIPT;
> +	req.script_namelen = sizeof(POHMELFS_DATA_UNLINK_SCRIPT) - 1; /* not including 0-byte */
> +
> +	req.binary = &pi->id;
> +	req.binary_size = sizeof(struct dnet_raw_id);
> +
> +	return pohmelfs_send_script_request(parent, &req);
> +}
> +
> +static int pohmelfs_rmdir(struct inode *dir, struct dentry *dentry)
> +{
> +	return pohmelfs_unlink(dir, dentry);
> +}
> +
> +struct pohmelfs_rename_req {
> +	struct dnet_raw_id		old_dir_id;
> +
> +	struct pohmelfs_dentry		dentry;
> +} __attribute__ ((packed));
> +
> +static int pohmelfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> +			struct inode *new_dir, struct dentry *new_dentry)
> +{
> +	struct pohmelfs_inode *old_parent = pohmelfs_inode(old_dir);
> +	struct inode *inode = old_dentry->d_inode;
> +	struct inode *new_inode = new_dentry->d_inode;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	struct pohmelfs_script_req req;
> +	struct pohmelfs_rename_req *r;
> +	int size = sizeof(struct pohmelfs_rename_req) + new_dentry->d_name.len;
> +	int err;
> +
> +	pr_debug("%s: rename: %.*s -> %.*s: mtime: %ld\n",
> +		 pohmelfs_dump_id(pi->id.id),
> +		 old_dentry->d_name.len, old_dentry->d_name.name,
> +		 new_dentry->d_name.len, new_dentry->d_name.name,
> +		 inode->i_mtime.tv_sec);
> +
> +	if (pohmelfs_sb(inode->i_sb)->http_compat) {
> +		err = -ENOTSUPP;
> +		goto err_out_exit;
> +	}
> +
> +	r = kzalloc(size, GFP_NOIO);
> +	if (!r) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	r->old_dir_id = pohmelfs_inode(old_dir)->id;
> +	r->dentry.parent_id = pohmelfs_inode(new_dir)->id;
> +	r->dentry.disk.id = pohmelfs_inode(inode)->id;
> +	r->dentry.disk.ino = cpu_to_le64(inode->i_ino);
> +	r->dentry.disk.type = (inode->i_mode >> 12) & 15;
> +	r->dentry.disk.len = new_dentry->d_name.len;
> +
> +	memcpy(r->dentry.disk.name, new_dentry->d_name.name, new_dentry->d_name.len);
> +
> +	memset(&req, 0, sizeof(struct pohmelfs_script_req));
> +
> +	req.script_name = POHMELFS_RENAME_SCRIPT;
> +	req.script_namelen = sizeof(POHMELFS_RENAME_SCRIPT) - 1; /* not including 0-byte */
> +
> +	req.obj_name = (char *)old_dentry->d_name.name;
> +	req.obj_len = old_dentry->d_name.len;
> +
> +	req.binary = r;
> +	req.binary_size = size;
> +
> +	req.sync = 1;
> +	req.group_id = 0;
> +	req.id = &old_parent->id;
> +	req.complete = pohmelfs_send_dentry_complete;
> +
> +	if (new_inode) {
> +		new_inode->i_ctime = CURRENT_TIME_SEC;
> +	}
> +	inode->i_ctime = CURRENT_TIME_SEC;
> +	mark_inode_dirty(inode);
> +	mark_inode_dirty(new_dir);
> +
> +	err = pohmelfs_send_script_request(old_parent, &req);
> +	if (err)
> +		goto err_out_free;
> +
> +err_out_free:
> +	kfree(r);
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
> +	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
> +	struct pohmelfs_inode *pi;
> +	struct inode *inode;
> +	unsigned len = strlen(symname)+1;
> +	int err = 0;
> +
> +	inode_inc_link_count(dir);
> +	pi = pohmelfs_new_inode(psb, S_IFLNK | S_IRWXUGO);
> +	if (IS_ERR(pi)) {
> +		err = PTR_ERR(pi);
> +		goto err_out_exit;
> +	}
> +	inode = &pi->vfs_inode;
> +	pohmelfs_init_local(pi, dir);
> +	mark_inode_dirty(dir);
> +
> +	err = page_symlink(inode, symname, len);
> +	if (err)
> +		goto err_out_put;
> +
> +	d_instantiate(dentry, inode);
> +	if (psb->http_compat)
> +		pohmelfs_http_compat_id(pi);
> +
> +	err = pohmelfs_send_dentry(pi, &parent->id, dentry->d_name.name, dentry->d_name.len, 1);
> +	if (err)
> +		goto err_out_exit;
> +
> +	return 0;
> +
> +err_out_put:
> +	iput(inode);
> +err_out_exit:
> +	inode_dec_link_count(dir);
> +	return err;
> +}
> +
> +static int pohmelfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode *inode = old_dentry->d_inode;
> +	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	struct pohmelfs_script_req req;
> +	int err;
> +
> +	if (pohmelfs_sb(inode->i_sb)->http_compat) {
> +		err = -ENOTSUPP;
> +		goto err_out_exit;
> +	}
> +
> +	dquot_initialize(dir);
> +
> +	inode->i_ctime = CURRENT_TIME_SEC;
> +	inode_inc_link_count(inode);
> +	ihold(inode);
> +
> +	err = pohmelfs_send_dentry(pi, &parent->id, dentry->d_name.name, dentry->d_name.len, 1);
> +	if (err) {
> +		goto err_out_put;
> +	}
> +
> +	memset(&req, 0, sizeof(struct pohmelfs_script_req));
> +
> +	req.script_name = POHMELFS_HARDLINK_SCRIPT;
> +	req.script_namelen = sizeof(POHMELFS_HARDLINK_SCRIPT) - 1; /* not including 0-byte */
> +
> +	req.obj_name = (char *)dentry->d_name.name;
> +	req.obj_len = dentry->d_name.len;
> +
> +	req.binary = &pi->id;
> +	req.binary_size = sizeof(struct dnet_raw_id);
> +
> +	req.group_id = 0;
> +	req.id = &pi->id;
> +	req.complete = pohmelfs_send_dentry_complete;
> +
> +	req.sync = 1;
> +
> +	err = pohmelfs_send_script_request(parent, &req);
> +	if (err)
> +		goto err_out_unlink;
> +
> +	mark_inode_dirty(dir);
> +	mark_inode_dirty(inode);
> +	d_instantiate(dentry, inode);
> +	return 0;
> +
> +err_out_unlink:
> +	req.binary = &parent->id;
> +	req.script_name = POHMELFS_UNLINK_SCRIPT;
> +	req.script_namelen = sizeof(POHMELFS_UNLINK_SCRIPT) - 1; /* not including 0-byte */
> +	pohmelfs_send_script_request(parent, &req);
> +err_out_put:
> +	inode_dec_link_count(inode);
> +	iput(inode);
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rdev)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
> +	struct pohmelfs_inode *pi;
> +	struct inode *inode;
> +	int err;
> +
> +	if (!new_valid_dev(rdev))
> +		return -EINVAL;
> +
> +	inode_inc_link_count(dir);
> +	dquot_initialize(dir);
> +
> +	pi = pohmelfs_new_inode(psb, mode);
> +	if (IS_ERR(pi)) {
> +		err = PTR_ERR(pi);
> +		goto err_out_exit;
> +	}
> +	inode = &pi->vfs_inode;
> +	pohmelfs_init_local(pi, dir);
> +	mark_inode_dirty(dir);
> +
> +	init_special_inode(inode, inode->i_mode, rdev);
> +	inode->i_op = &pohmelfs_special_inode_operations;
> +
> +	d_instantiate(dentry, inode);
> +	if (psb->http_compat)
> +		pohmelfs_http_compat_id(pi);
> +
> +	err = pohmelfs_send_dentry(pi, &pohmelfs_inode(dir)->id, dentry->d_name.name, dentry->d_name.len, 1);
> +	if (err)
> +		goto err_out_exit;
> +
> +	return 0;
> +
> +err_out_exit:
> +	inode_dec_link_count(dir);
> +	return err;
> +}
> +
> +const struct inode_operations pohmelfs_dir_inode_operations = {
> +	.create		= pohmelfs_create,
> +	.lookup 	= pohmelfs_lookup,
> +	.mkdir		= pohmelfs_mkdir,
> +	.unlink		= pohmelfs_unlink,
> +	.rmdir		= pohmelfs_rmdir,
> +	.rename		= pohmelfs_rename,
> +	.symlink	= pohmelfs_symlink,
> +	.link		= pohmelfs_link,
> +	.mknod		= pohmelfs_mknod,
> +};
> +
> +static int pohmelfs_readdir_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
> +	struct pohmelfs_wait *wait = t->priv;
> +	struct dnet_cmd *cmd = &recv->cmd;
> +
> +	pr_debug("%s: cmd size: %llu, flags: %x\n",
> +		 pohmelfs_dump_id(pi->id.id), (unsigned long long)cmd->size,
> +		 cmd->flags);
> +
> +	if (cmd->flags & DNET_FLAGS_MORE) {
> +		if (cmd->size > sizeof(struct dnet_attr)) {
> +			wait->ret = t->recv_data;
> +			wait->condition = cmd->size;
> +
> +			t->recv_data = NULL;
> +			wake_up(&wait->wq);
> +		}
> +	} else {
> +		if (!wait->condition) {
> +			wait->condition = cmd->status;
> +			if (!wait->condition)
> +				wait->condition = 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_dentry_add(struct dentry *parent_dentry, struct pohmelfs_inode *pi, char *name, int len)
> +{
> +	struct inode *inode = &pi->vfs_inode;
> +	struct dentry *dentry, *old;
> +	struct qstr str;
> +	int err = 0;
> +
> +	str.name = name;
> +	str.len = len;
> +	str.hash = full_name_hash(str.name, str.len);
> +
> +	dentry = d_lookup(parent_dentry, &str);
> +	if (dentry) {
> +		err = -EEXIST;
> +
> +		dput(dentry);
> +		goto err_out_exit;
> +	}
> +	/*
> +	 * if things are ok, dentry has 2 references -
> +	 * one in parent dir, and another its own,
> +	 * which we should drop
> +	 */
> +	dentry = d_alloc(parent_dentry, &str);
> +	if (!dentry) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	old = d_splice_alias(inode, dentry);
> +	if (unlikely(old)) {
> +		dput(dentry);
> +		err = -EEXIST;
> +	} else {
> +		dput(dentry);
> +	}
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_update_inode(struct dentry *parent_dentry, struct pohmelfs_inode_info *info, char *name)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(parent_dentry->d_inode->i_sb);
> +	struct pohmelfs_inode *pi;
> +	struct inode *inode;
> +	int err = 0;
> +
> +	pi = pohmelfs_sb_inode_lookup(psb, &info->id);
> +	if (pi) {
> +		inode = &pi->vfs_inode;
> +		pohmelfs_fill_inode(inode, info);
> +	} else {
> +		pi = pohmelfs_existing_inode(psb, info);
> +		if (IS_ERR(pi)) {
> +			err = PTR_ERR(pi);
> +			goto err_out_exit;
> +		}
> +		inode = &pi->vfs_inode;
> +	}
> +
> +	mutex_lock(&inode->i_mutex);
> +	err = pohmelfs_dentry_add(parent_dentry, pi, name, info->namelen);
> +	mutex_unlock(&inode->i_mutex);
> +	if (err)
> +		iput(inode);
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +struct pohmelfs_fetch_info {
> +	struct dentry		*parent;
> +	struct kref		refcnt;
> +	int			len;
> +	char			name[0];
> +};
> +
> +static void pohmelfs_fetch_inode_info_free(struct kref *kref)
> +{
> +	struct pohmelfs_fetch_info *fi = container_of(kref, struct pohmelfs_fetch_info, refcnt);
> +
> +	dput(fi->parent);
> +	kfree(fi);
> +}
> +
> +static void pohmelfs_fetch_inode_info_destroy(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_fetch_info *fi = t->priv;
> +
> +	kref_put(&fi->refcnt, pohmelfs_fetch_inode_info_free);
> +}
> +
> +static int pohmelfs_fetch_inode_info_init(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_fetch_info *fi = t->priv;
> +
> +	kref_get(&fi->refcnt);
> +	return 0;
> +}
> +
> +static int pohmelfs_fetch_inode_info_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_fetch_info *fi = t->priv;
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	struct pohmelfs_inode_info *info;
> +	int err;
> +
> +	if (cmd->status)
> +		return 0;
> +
> +	if (cmd->size < sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr) + sizeof(struct pohmelfs_inode_info))
> +		return 0;
> +
> +	info = t->recv_data + sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
> +	pohmelfs_convert_inode_info(info);
> +
> +	info->namelen = fi->len;
> +	err = pohmelfs_update_inode(fi->parent, info, fi->name);
> +
> +	pr_debug("%s: fetched: '%.*s': %d\n",
> +		 pohmelfs_dump_id(cmd->id.id), fi->len, fi->name, err);
> +	return 0;
> +}
> +
> +static int pohmelfs_fetch_inode_info_group(struct dentry *parent, struct pohmelfs_inode *pi,
> +		struct pohmelfs_dentry_disk *d, int *groups, int group_num)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
> +	struct pohmelfs_io *pio;
> +	struct pohmelfs_fetch_info *fi;
> +	int err, i;
> +
> +	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!pio) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	fi = kmalloc(sizeof(struct pohmelfs_fetch_info) + d->len, GFP_NOIO);
> +	if (!fi) {
> +		err = -ENOMEM;
> +		goto err_out_free;
> +	}
> +
> +	memcpy(fi->name, d->name, d->len);
> +	fi->len = d->len;
> +	kref_init(&fi->refcnt);
> +	fi->parent = dget(parent);
> +
> +	pio->pi = pi;
> +	pio->id = &d->id;
> +	pio->cmd = DNET_CMD_READ;
> +	pio->cflags = DNET_FLAGS_NEED_ACK | DNET_FLAGS_NOLOCK;
> +	if (psb->no_read_csum)
> +		pio->ioflags = DNET_IO_FLAGS_NOCSUM;
> +	pio->type = POHMELFS_INODE_COLUMN;
> +	pio->cb.complete = pohmelfs_fetch_inode_info_complete;
> +	pio->cb.init = pohmelfs_fetch_inode_info_init;
> +	pio->cb.destroy = pohmelfs_fetch_inode_info_destroy;
> +	pio->priv = fi;
> +
> +	err = -ENOENT;
> +	for (i = 0; i < group_num; ++i) {
> +		pio->group_id = groups[i];
> +		err = pohmelfs_send_io_group(pio, groups[i]);
> +		if (!err)
> +			break;
> +	}
> +
> +	kref_put(&fi->refcnt, pohmelfs_fetch_inode_info_free);
> +err_out_free:
> +	kmem_cache_free(pohmelfs_io_cache, pio);
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_fetch_inode_info(struct dentry *parent, struct pohmelfs_inode *pi, struct pohmelfs_dentry_disk *d)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
> +	if (pi->groups)
> +		return pohmelfs_fetch_inode_info_group(parent, pi, d, pi->groups, pi->group_num);
> +	else
> +		return pohmelfs_fetch_inode_info_group(parent, pi, d, psb->groups, psb->group_num);
> +}
> +
> +static int pohmelfs_readdir_process(void *data, int size, struct file *filp, void *dirent, filldir_t filldir)
> +{
> +	struct dentry *dentry = filp->f_path.dentry, *child;
> +	struct inode *dir = dentry->d_inode;
> +	void *orig_data = data;
> +	int orig_size = size;
> +	struct qstr str;
> +	int err = 0;
> +
> +	while (size > 0) {
> +		struct pohmelfs_dentry_disk *d = data;
> +
> +		if (size < sizeof(struct pohmelfs_dentry_disk)) {
> +			err = -EINVAL;
> +			goto err_out_exit;
> +		}
> +
> +		if (size < d->len) {
> +			err = -EINVAL;
> +			goto err_out_exit;
> +		}
> +
> +		str.name = d->name;
> +		str.len = d->len;
> +		str.hash = full_name_hash(str.name, str.len);
> +
> +		child = d_lookup(dentry, &str);
> +		pr_debug("%s: child: %.*s/%.*s: %p\n",
> +			 pohmelfs_dump_id(d->id.id),
> +			 dentry->d_name.len, dentry->d_name.name,
> +			 d->len, d->name,
> +			 child);
> +		if (!child) {
> +			pohmelfs_fetch_inode_info(dentry, pohmelfs_inode(dir), d);
> +		} else {
> +			dput(child);
> +		}
> +
> +		size -= sizeof(struct pohmelfs_dentry_disk) + d->len;
> +		data += sizeof(struct pohmelfs_dentry_disk) + d->len;
> +	}
> +
> +	data = orig_data;
> +	size = orig_size;
> +	while (size > 0) {
> +		struct pohmelfs_dentry_disk *d = data;
> +
> +		err = filldir(dirent, d->name, d->len, filp->f_pos, le64_to_cpu(d->ino), d->type);
> +		if (err)
> +			return 0;
> +
> +		filp->f_pos += 1;
> +		size -= sizeof(struct pohmelfs_dentry_disk) + d->len;
> +		data += sizeof(struct pohmelfs_dentry_disk) + d->len;
> +	}
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +struct pohmelfs_readdir {
> +	struct dnet_raw_id			id;
> +	int					max_size;
> +	int					fpos;
> +};
> +
> +static void *pohmelfs_readdir_group(int group_id, struct file *filp, int *sizep)
> +{
> +	struct dentry *dentry = filp->f_path.dentry;
> +	struct inode *dir = dentry->d_inode;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
> +	struct pohmelfs_inode *parent = pohmelfs_inode(dir);
> +	struct pohmelfs_readdir rd;
> +	struct pohmelfs_script_req req;
> +	void *data;
> +	int size;
> +	int err;
> +
> +	memset(&req, 0, sizeof(struct pohmelfs_script_req));
> +
> +	req.script_name = POHMELFS_READDIR_SCRIPT;
> +	req.script_namelen = sizeof(POHMELFS_READDIR_SCRIPT) - 1; /* not including 0-byte */
> +
> +	req.obj_name = (char *)dentry->d_name.name;
> +	req.obj_len = dentry->d_name.len;
> +
> +	rd.id = parent->id;
> +	rd.max_size = psb->readdir_allocation * PAGE_SIZE - sizeof(struct dnet_attr); /* cmd->size should fit one page */
> +	rd.fpos = filp->f_pos - 2; /* account for . and .. */
> +
> +	req.binary = &rd;
> +	req.binary_size = sizeof(struct pohmelfs_readdir);
> +
> +	req.id = &parent->id;
> +	req.complete = pohmelfs_readdir_complete;
> +	req.cflags = 0;
> +
> +	req.group_id = group_id;
> +	req.sync = 1;
> +
> +	err = pohmelfs_send_script_request(parent, &req);
> +	if (err < 0)
> +		goto err_out_exit;
> +
> +	data = req.ret;
> +	size = req.ret_cond;
> +	if (!data || !size) {
> +		err = -ENOENT;
> +		goto err_out_exit;
> +	}
> +
> +	*sizep = size;
> +	return data;
> +
> +err_out_exit:
> +	return ERR_PTR(err);
> +}
> +
> +static int pohmelfs_dir_open(struct inode *dir, struct file *filp)
> +{
> +#if 0
> +	struct pohmelfs_inode *pi = pohmelfs_inode(dir);
> +
> +	if (!pohmelfs_need_resync(pi))
> +		return dcache_dir_open(dir, filp);
> +#endif
> +	filp->f_pos = 0;
> +	return 0;
> +}
> +
> +static int pohmelfs_dir_close(struct inode *inode, struct file *filp)
> +{
> +	if (filp->private_data)
> +		return dcache_dir_close(inode, filp);
> +	return 0;
> +}
> +
> +static int pohmelfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
> +	struct dentry *dentry = filp->f_path.dentry;
> +	struct inode *dir = dentry->d_inode;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(dir);
> +	struct pohmelfs_sb *psb = pohmelfs_sb(dir->i_sb);
> +	int i, err = -ENOENT;
> +
> +	if (filp->private_data) {
> +		return dcache_readdir(filp, dirent, filldir);
> +	}
> +
> +	if (filp->f_pos == 0) {
> +		err = filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR);
> +		if (err)
> +			return err;
> +		filp->f_pos++;
> +	}
> +
> +	if (filp->f_pos == 1) {
> +		err = filldir(dirent, "..", 2, filp->f_pos, parent_ino(dentry), DT_DIR);
> +		if (err)
> +			return err;
> +		filp->f_pos++;
> +	}
> +
> +	for (i = 0; i < psb->group_num; ++i) {
> +		int size;
> +		void *data;
> +
> +		data = pohmelfs_readdir_group(psb->groups[i], filp, &size);
> +		if (IS_ERR(data)) {
> +			err = PTR_ERR(data);
> +			continue;
> +		}
> +
> +		pi->update = get_seconds();
> +		err = pohmelfs_readdir_process(data + sizeof(struct dnet_attr), size - sizeof(struct dnet_attr), filp, dirent, filldir);
> +		kfree(data);
> +
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +const struct file_operations pohmelfs_dir_fops = {
> +	.open		= pohmelfs_dir_open,
> +	.release	= pohmelfs_dir_close,
> +	.read		= generic_read_dir,
> +	.readdir	= pohmelfs_readdir,
> +};
> diff --git a/fs/pohmelfs/file.c b/fs/pohmelfs/file.c
> new file mode 100644
> index 0000000..46b6812
> --- /dev/null
> +++ b/fs/pohmelfs/file.c
> @@ -0,0 +1,483 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/fs.h>
> +
> +#include "pohmelfs.h"
> +
> +#define POHMELFS_READ_LATEST_GROUPS_SCRIPT		"pohmelfs_read_latest_groups.py"
> +
> +static int pohmelfs_write_init(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_wait *wait = t->priv;
> +
> +	pohmelfs_wait_get(wait);
> +	return 0;
> +}
> +
> +static void pohmelfs_write_destroy(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_wait *wait = t->priv;
> +
> +	wake_up(&wait->wq);
> +	pohmelfs_wait_put(wait);
> +}
> +
> +static int pohmelfs_write_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_wait *wait = t->priv;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
> +
> +	pr_debug("%s: %llu, flags: %x, status: %d\n",
> +		 pohmelfs_dump_id(pi->id.id), trans, cmd->flags, cmd->status);
> +
> +	if (cmd->flags & DNET_FLAGS_MORE)
> +		return 0;
> +
> +	wait->condition = cmd->status;
> +	if (!wait->condition)
> +		wait->condition = 1;
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_send_write_metadata(struct pohmelfs_inode *pi, struct pohmelfs_io *pio, struct pohmelfs_wait *wait)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
> +	struct timespec ts = CURRENT_TIME;
> +	struct dnet_meta_update *mu;
> +	struct dnet_meta *m;
> +	int err, size;
> +	void *data;
> +
> +	size = sizeof(struct dnet_meta) * 4 +
> +			sizeof(struct dnet_meta_check_status) +
> +			sizeof(struct dnet_meta_update) +
> +			psb->fsid_len +
> +			psb->group_num * sizeof(int);
> +
> +	data = kzalloc(size, GFP_NOIO);
> +	if (!data) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	m = data;
> +	m->type = DNET_META_GROUPS;
> +	m->size = psb->group_num * sizeof(int);
> +	memcpy(m->data, psb->groups, m->size);
> +	dnet_convert_meta(m);
> +
> +	m = (struct dnet_meta *)(m->data + le32_to_cpu(m->size));
> +	m->type = DNET_META_NAMESPACE;
> +	m->size = psb->fsid_len;
> +	memcpy(m->data, psb->fsid, psb->fsid_len);
> +	dnet_convert_meta(m);
> +
> +	m = (struct dnet_meta *)(m->data + le32_to_cpu(m->size));
> +	m->type = DNET_META_UPDATE;
> +	m->size = sizeof(struct dnet_meta_update);
> +	mu = (struct dnet_meta_update *)m->data;
> +	mu->tm.tsec = ts.tv_sec;
> +	mu->tm.tnsec = ts.tv_nsec;
> +	dnet_convert_meta_update(mu);
> +	dnet_convert_meta(m);
> +
> +	m = (struct dnet_meta *)(m->data + le32_to_cpu(m->size));
> +	m->type = DNET_META_CHECK_STATUS;
> +	m->size = sizeof(struct dnet_meta_check_status);
> +	/* do not fill, it will be updated on server */
> +	dnet_convert_meta(m);
> +
> +	pio->pi = pi;
> +	pio->id = &pi->id;
> +	pio->cmd = DNET_CMD_WRITE;
> +	pio->ioflags = DNET_IO_FLAGS_OVERWRITE | DNET_IO_FLAGS_META;
> +	pio->cflags = DNET_FLAGS_NEED_ACK;
> +	pio->type = 1;
> +	pio->cb.init = pohmelfs_write_init;
> +	pio->cb.destroy = pohmelfs_write_destroy;
> +	pio->cb.complete = pohmelfs_write_complete;
> +	pio->priv = wait;
> +	pio->data = data;
> +	pio->size = size;
> +
> +	err = pohmelfs_send_io(pio);
> +	if (err)
> +		goto err_out_free;
> +
> +err_out_free:
> +	kfree(data);
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_write_command_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	struct pohmelfs_write_ctl *ctl = t->wctl;
> +
> +	if (cmd->flags & DNET_FLAGS_MORE)
> +		return 0;
> +
> +	if (cmd->status == 0)
> +		atomic_inc(&ctl->good_writes);
> +	else {
> +		struct inode *inode = t->inode;
> +		struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +		unsigned long long size = le64_to_cpu(t->cmd.p.io.size);
> +		unsigned long long offset = le64_to_cpu(t->cmd.p.io.offset);
> +
> +		pr_debug("%s: write failed: ino: %lu, isize: %llu, offset: %llu, size: %llu: %d\n",
> +			 pohmelfs_dump_id(pi->id.id), inode->i_ino,
> +			 inode->i_size, offset, size, cmd->status);
> +	}
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_write_command_init(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_write_ctl *ctl = t->wctl;
> +
> +	kref_get(&ctl->refcnt);
> +	return 0;
> +}
> +
> +static void pohmelfs_write_command_destroy(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_write_ctl *ctl = t->wctl;
> +
> +	kref_put(&ctl->refcnt, pohmelfs_write_ctl_release);
> +}
> +
> +int pohmelfs_write_command(struct pohmelfs_inode *pi, struct pohmelfs_write_ctl *ctl, loff_t offset, size_t len)
> +{
> +	int err;
> +	struct inode *inode = &pi->vfs_inode;
> +	struct pohmelfs_io *pio;
> +	uint64_t prepare_size = i_size_read(&pi->vfs_inode);
> +
> +	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!pio) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	pio->pi = pi;
> +	pio->id = &pi->id;
> +	pio->cmd = DNET_CMD_WRITE;
> +	pio->offset = offset;
> +	pio->size = len;
> +	pio->cflags = DNET_FLAGS_NEED_ACK;
> +
> +	/*
> +	 * We always set prepare bit, since elliptics/eblob reuses existing (previously prepared/reserved) area
> +	 * But it also allows to 'miss' prepare message (for example if we sent prepare bit when node was offline)
> +	 */
> +	pio->ioflags = DNET_IO_FLAGS_OVERWRITE | DNET_IO_FLAGS_PLAIN_WRITE | DNET_IO_FLAGS_PREPARE;
> +
> +	pio->num = prepare_size;
> +
> +	/* commit when whole inode is written */
> +	if (offset + len == prepare_size) {
> +		pio->ioflags |= DNET_IO_FLAGS_COMMIT;
> +	}
> +
> +	pio->wctl = ctl;
> +	pio->priv = ctl;
> +	pio->cb.complete = pohmelfs_write_command_complete;
> +	pio->cb.init = pohmelfs_write_command_init;
> +	pio->cb.destroy = pohmelfs_write_command_destroy;
> +
> +	pr_debug("%s: ino: %lu, offset: %llu, len: %zu, total size: %llu\n",
> +		 pohmelfs_dump_id(pi->id.id), inode->i_ino,
> +		 (unsigned long long)offset, len, inode->i_size);
> +
> +	err = pohmelfs_send_io(pio);
> +	if (err)
> +		goto err_out_free;
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_io_cache, pio);
> +err_out_exit:
> +	return err;
> +}
> +
> +int pohmelfs_metadata_inode(struct pohmelfs_inode *pi, int sync)
> +{
> +	struct inode *inode = &pi->vfs_inode;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
> +	struct pohmelfs_io *pio;
> +	struct pohmelfs_wait *wait;
> +	long ret;
> +	int err;
> +
> +	wait = pohmelfs_wait_alloc(pi);
> +	if (!wait) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!pio) {
> +		err = -ENOMEM;
> +		goto err_out_put;
> +	}
> +
> +	err = pohmelfs_send_write_metadata(pi, pio, wait);
> +	if (err)
> +		goto err_out_free;
> +
> +	if (sync) {
> +		ret = wait_event_interruptible_timeout(wait->wq,
> +				wait->condition != 0 && atomic_read(&wait->refcnt.refcount) <= 2,
> +				msecs_to_jiffies(psb->write_wait_timeout));
> +		if (ret <= 0) {
> +			err = ret;
> +			if (ret == 0)
> +				err = -ETIMEDOUT;
> +			goto err_out_free;
> +		}
> +
> +		if (wait->condition < 0) {
> +			err = wait->condition;
> +			goto err_out_free;
> +		}
> +	}
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_io_cache, pio);
> +err_out_put:
> +	pohmelfs_wait_put(wait);
> +err_out_exit:
> +	return err;
> +}
> +
> +static long pohmelfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	struct pohmelfs_io *pio;
> +	int err;
> +
> +	if (offset + len < i_size_read(inode)) {
> +		err = 0;
> +		goto err_out_exit;
> +	}
> +
> +	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!pio) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	pio->pi = pi;
> +	pio->id = &pi->id;
> +	pio->cmd = DNET_CMD_WRITE;
> +	pio->cflags = DNET_FLAGS_NEED_ACK;
> +	pio->ioflags = DNET_IO_FLAGS_PREPARE;
> +	pio->num = i_size_read(inode);
> +
> +	pr_debug("%s: ino: %lu, offset: %llu, len: %llu, total size: %llu\n",
> +		 pohmelfs_dump_id(pi->id.id), inode->i_ino,
> +		 (unsigned long long)offset, (unsigned long long)len,
> +		 inode->i_size);
> +
> +	err = pohmelfs_send_io(pio);
> +	if (err)
> +		goto err_out_free;
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_io_cache, pio);
> +err_out_exit:
> +	return err;
> +}
> +
> +struct pohmelfs_latest_ctl {
> +	struct dnet_id			id;
> +	uint64_t			offset;
> +	uint64_t			size;
> +};
> +
> +static int pohmelfs_read_latest_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
> +	struct pohmelfs_wait *wait = t->priv;
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	int err = cmd->status;
> +
> +	if (cmd->status)
> +		goto err_out_exit;
> +
> +	if (cmd->flags & DNET_FLAGS_MORE) {
> +		pr_debug("%s: group: %d, attr size: %lld\n",
> +			 pohmelfs_dump_id(cmd->id.id), cmd->id.group_id,
> +			 cmd->size - sizeof(struct dnet_attr));
> +		if (cmd->size < sizeof(struct dnet_attr) + 4) {
> +			err = -ENOENT;
> +			goto err_out_exit;
> +		}
> +
> +		mutex_lock(&pi->lock);
> +		if (!pi->groups) {
> +			pi->groups = kmalloc(cmd->size - sizeof(struct dnet_attr), GFP_NOIO);
> +			if (!pi->groups) {
> +				err = -ENOMEM;
> +				mutex_unlock(&pi->lock);
> +				goto err_out_exit;
> +			}
> +
> +			pi->group_num = (cmd->size - sizeof(struct dnet_attr)) / sizeof(int);
> +			memcpy(pi->groups, t->recv_data + sizeof(struct dnet_attr), pi->group_num * sizeof(int));
> +
> +			pr_debug("%s: group: %d, received: %d groups\n",
> +				 pohmelfs_dump_id(cmd->id.id), cmd->id.group_id,
> +				 pi->group_num);
> +		}
> +		mutex_unlock(&pi->lock);
> +	}
> +
> +err_out_exit:
> +	if (err)
> +		wait->condition = err;
> +	else
> +		wait->condition = 1;
> +	return 0;
> +}
> +
> +static int pohmelfs_read_latest_group(struct pohmelfs_inode *pi, struct pohmelfs_latest_ctl *r, int group_id)
> +{
> +	struct pohmelfs_script_req req;
> +
> +	memset(&req, 0, sizeof(struct pohmelfs_script_req));
> +
> +	req.script_name = POHMELFS_READ_LATEST_GROUPS_SCRIPT;
> +	req.script_namelen = sizeof(POHMELFS_READ_LATEST_GROUPS_SCRIPT) - 1;
> +
> +	req.obj_name = "noname";
> +	req.obj_len = 5;
> +
> +	req.binary = r;
> +	req.binary_size = sizeof(struct pohmelfs_latest_ctl);
> +
> +	req.id = &pi->id;
> +	req.group_id = group_id;
> +	req.sync = 1;
> +	req.cflags = 0;
> +	req.complete = pohmelfs_read_latest_complete;
> +
> +	return pohmelfs_send_script_request(pi, &req);
> +}
> +
> +static int pohmelfs_read_latest(struct pohmelfs_inode *pi)
> +{
> +	struct pohmelfs_latest_ctl *r;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
> +	int i, err = -ENOENT;
> +
> +	r = kzalloc(sizeof(struct pohmelfs_latest_ctl), GFP_NOIO);
> +	if (!r) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	dnet_setup_id(&r->id, 0, pi->id.id);
> +
> +	for (i = 0; i < psb->group_num; ++i) {
> +		r->id.group_id = psb->groups[i];
> +
> +		err = pohmelfs_read_latest_group(pi, r, psb->groups[i]);
> +		if (err)
> +			continue;
> +
> +		break;
> +	}
> +
> +	kfree(r);
> +
> +	pr_debug("%s: %d groups\n", pohmelfs_dump_id(pi->id.id), pi->group_num);
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_file_open(struct inode *inode, struct file *filp)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +
> +	if (!pi->group_num && !pi->local)
> +		pohmelfs_read_latest(pi);
> +
> +	if (pohmelfs_need_resync(pi))
> +		invalidate_mapping_pages(&inode->i_data, 0, -1);
> +
> +	return generic_file_open(inode, filp);
> +}
> +
> +/*
> + * We want fsync() to work on POHMELFS.
> + */
> +static int pohmelfs_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
> +{
> +	struct inode *inode = filp->f_mapping->host;
> +	int err = filemap_write_and_wait_range(inode->i_mapping, start, end);
> +	if (!err) {
> +		mutex_lock(&inode->i_mutex);
> +		err = sync_inode_metadata(inode, 1);
> +		mutex_unlock(&inode->i_mutex);
> +	}
> +	pr_debug("%s: start: %lld, end: %lld, nrpages: %ld, dirty: %d: %d\n",
> +		 pohmelfs_dump_id(pohmelfs_inode(inode)->id.id),
> +		 (unsigned long long)start, (unsigned long long)end,
> +		 inode->i_mapping->nrpages,
> +		 mapping_cap_writeback_dirty(inode->i_mapping), err);
> +	return err;
> +}
> +
> +static int pohmelfs_flush(struct file *filp, fl_owner_t id)
> +{
> +	struct inode *inode = filp->f_mapping->host;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
> +	int err = 0;
> +
> +	if (psb->sync_on_close)
> +		err = pohmelfs_fsync(filp, 0, ~0ULL, 1);
> +
> +	if (!err && test_bit(AS_EIO, &inode->i_mapping->flags))
> +		err = -EIO;
> +
> +	pr_debug("%s: %d\n",
> +		 pohmelfs_dump_id(pohmelfs_inode(inode)->id.id), err);
> +	return err;
> +}
> +
> +const struct file_operations pohmelfs_file_ops = {
> +	.open		= pohmelfs_file_open,
> +
> +	.llseek		= generic_file_llseek,
> +
> +	.read		= do_sync_read,
> +	.aio_read	= generic_file_aio_read,
> +
> +	.mmap		= generic_file_mmap,
> +
> +	.splice_read	= generic_file_splice_read,
> +	.splice_write	= generic_file_splice_write,
> +
> +	.write		= do_sync_write,
> +	.aio_write	= generic_file_aio_write,
> +
> +	.fallocate	= pohmelfs_fallocate,
> +
> +	.fsync		= pohmelfs_fsync,
> +	.flush		= pohmelfs_flush,
> +};
> +
> +const struct inode_operations pohmelfs_file_inode_operations = {
> +};
> diff --git a/fs/pohmelfs/inode.c b/fs/pohmelfs/inode.c
> new file mode 100644
> index 0000000..3f7c623
> --- /dev/null
> +++ b/fs/pohmelfs/inode.c
> @@ -0,0 +1,1084 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/buffer_head.h>
> +#include <linux/cred.h>
> +#include <linux/fiemap.h>
> +#include <linux/fs.h>
> +#include <linux/fs_struct.h>
> +#include <linux/mpage.h>
> +#include <linux/mount.h>
> +#include <linux/mm.h>
> +#include <linux/namei.h>
> +#include <linux/pagevec.h>
> +#include <linux/pagemap.h>
> +#include <linux/random.h>
> +#include <linux/scatterlist.h>
> +#include <linux/slab.h>
> +#include <linux/time.h>
> +#include <linux/writeback.h>
> +
> +#include "pohmelfs.h"
> +
> +char *pohmelfs_dump_id_len_raw(const unsigned char *id, unsigned int len, char *dst)
> +{
> +	unsigned int i;
> +
> +	if (len > SHA512_DIGEST_SIZE)
> +		len = SHA512_DIGEST_SIZE;
> +
> +	for (i=0; i<len; ++i)
> +		sprintf(&dst[2*i], "%02x", id[i]);
> +	return dst;
> +}
> +
> +#define pohmelfs_dump_len 6
> +typedef struct {
> +	char			id_str[pohmelfs_dump_len * 2 + 1];
> +} pohmelfs_dump_t;
> +static DEFINE_PER_CPU(pohmelfs_dump_t, pohmelfs_dump_per_cpu);
> +
> +char *pohmelfs_dump_id(const unsigned char *id)
> +{
> +	pohmelfs_dump_t *ptr;
> +
> +	ptr = &get_cpu_var(pohmelfs_dump_per_cpu);
> +	pohmelfs_dump_id_len_raw(id, pohmelfs_dump_len, ptr->id_str);
> +	put_cpu_var(ptr);
> +
> +	return ptr->id_str;
> +}
> +
> +#define dnet_raw_id_scratch 6
> +typedef struct {
> +	unsigned long 			rand;
> +	struct timespec			ts;
> +} dnet_raw_id_scratch_t;
> +static DEFINE_PER_CPU(dnet_raw_id_scratch_t, dnet_raw_id_scratch_per_cpu);
> +
> +static int pohmelfs_gen_id(struct pohmelfs_sb *psb, struct dnet_raw_id *id)
> +{
> +	dnet_raw_id_scratch_t *sc;
> +	int err;
> +	long rand;
> +
> +	get_random_bytes(&rand, sizeof(sc->rand));
> +
> +	sc = &get_cpu_var(dnet_raw_id_scratch_per_cpu);
> +	sc->rand ^= rand;
> +	sc->ts = CURRENT_TIME;
> +
> +	err = pohmelfs_hash(psb, sc, sizeof(dnet_raw_id_scratch_t), id);
> +	put_cpu_var(sc);
> +
> +	return err;
> +}
> +
> +/*
> + * Create path from root for given inode.
> + * Path is formed as set of stuctures, containing name of the object
> + * and its inode data (mode, permissions and so on).
> + */
> +static int pohmelfs_construct_path_string(struct pohmelfs_inode *pi, char *data, int len)
> +{
> +	struct dentry *d;
> +	char *ptr;
> +	int err;
> +
> +	d = d_find_alias(&pi->vfs_inode);
> +	if (!d) {
> +		err = -ENOENT;
> +		goto err_out_exit;
> +	}
> +
> +	ptr = dentry_path_raw(d, data, len);
> +	if (IS_ERR(ptr)) {
> +		err = PTR_ERR(ptr);
> +		goto err_out_put;
> +	}
> +
> +	err = ptr - data - 1; /* not including 0-byte */
> +
> +	pr_debug("dname: '%s', len: %u, maxlen: %u, name: '%s', strlen: %d\n",
> +		 d->d_name.name, d->d_name.len, len, data, err);
> +
> +err_out_put:
> +	dput(d);
> +err_out_exit:
> +	return err;
> +}
> +
> +int pohmelfs_http_compat_id(struct pohmelfs_inode *pi)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
> +	struct timespec ts = CURRENT_TIME;
> +	int idx = ts.tv_nsec % psb->http_compat;
> +	struct pohmelfs_path *p = &psb->path[idx];
> +	int err;
> +
> +	mutex_lock(&p->lock);
> +	err = pohmelfs_construct_path_string(pi, p->data, PAGE_SIZE);
> +	if (err > 0) {
> +		pohmelfs_hash(psb, p->data, err, &pi->id);
> +	}
> +	mutex_unlock(&p->lock);
> +
> +	return err;
> +}
> +
> +static int pohmelfs_sb_inode_insert(struct pohmelfs_sb *psb, struct pohmelfs_inode *pi)
> +{
> +	struct rb_node **n = &psb->inode_root.rb_node, *parent = NULL;
> +	struct pohmelfs_inode *tmp;
> +	int cmp, err = 0;
> +
> +	spin_lock(&psb->inode_lock);
> +	while (*n) {
> +		parent = *n;
> +
> +		tmp = rb_entry(parent, struct pohmelfs_inode, node);
> +
> +		cmp = dnet_id_cmp_str(tmp->id.id, pi->id.id);
> +		if (cmp < 0)
> +			n = &parent->rb_left;
> +		else if (cmp > 0)
> +			n = &parent->rb_right;
> +		else {
> +			err = -EEXIST;
> +			goto err_out_unlock;
> +		}
> +	}
> +
> +	rb_link_node(&pi->node, parent, n);
> +	rb_insert_color(&pi->node, &psb->inode_root);
> +
> +err_out_unlock:
> +	spin_unlock(&psb->inode_lock);
> +
> +	return err;
> +}
> +
> +struct pohmelfs_inode *pohmelfs_sb_inode_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id)
> +{
> +	struct rb_node *n = psb->inode_root.rb_node;
> +	struct pohmelfs_inode *pi, *found = NULL;
> +	int cmp;
> +
> +	spin_lock(&psb->inode_lock);
> +	while (n) {
> +		pi = rb_entry(n, struct pohmelfs_inode, node);
> +
> +		cmp = dnet_id_cmp_str(pi->id.id, id->id);
> +		if (cmp < 0) {
> +			n = n->rb_left;
> +		} else if (cmp > 0)
> +			n = n->rb_right;
> +		else {
> +			found = pi;
> +			break;
> +		}
> +	}
> +	if (found) {
> +		if (!igrab(&found->vfs_inode))
> +			found = NULL;
> +	}
> +	spin_unlock(&psb->inode_lock);
> +
> +	return found;
> +}
> +
> +struct inode *pohmelfs_alloc_inode(struct super_block *sb)
> +{
> +	struct pohmelfs_inode *pi;
> +
> +	pi = kmem_cache_zalloc(pohmelfs_inode_cache, GFP_NOIO);
> +	if (!pi)
> +		goto err_out_exit;
> +
> +	inode_init_once(&pi->vfs_inode);
> +
> +	rb_init_node(&pi->node);
> +	mutex_init(&pi->lock);
> +
> +	return &pi->vfs_inode;
> +
> +err_out_exit:
> +	return NULL;
> +}
> +
> +void pohmelfs_destroy_inode(struct inode *inode)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +
> +	pr_debug("%s: ino: %ld, dirty: %lx\n",
> +		 pohmelfs_dump_id(pi->id.id), inode->i_ino,
> +		 inode->i_state & I_DIRTY);
> +
> +	kfree(pi->groups);
> +	kmem_cache_free(pohmelfs_inode_cache, pi);
> +}
> +
> +int pohmelfs_hash(struct pohmelfs_sb *psb, const void *data, const size_t size, struct dnet_raw_id *id)
> +{
> +	struct scatterlist sg;
> +	struct hash_desc desc;
> +
> +	sg_init_table(&sg, 1);
> +	sg_set_buf(&sg, data, size);
> +
> +	desc.tfm = psb->hash;
> +	desc.flags = 0;
> +
> +	return crypto_hash_digest(&desc, &sg, size, id->id);
> +}
> +
> +struct pohmelfs_readpages_priv {
> +	struct pohmelfs_wait		wait;
> +	struct kref			refcnt;
> +	int				page_num, page_index;
> +	struct page			*pages[0];
> +};
> +
> +static void pohmelfs_readpages_free(struct kref *kref)
> +{
> +	struct pohmelfs_readpages_priv *rp = container_of(kref, struct pohmelfs_readpages_priv, refcnt);
> +	struct pohmelfs_inode *pi = rp->wait.pi;
> +	int i;
> +
> +	pr_debug("%s: read: %ld/%ld, wait: %d\n",
> +		 pohmelfs_dump_id(pi->id.id), atomic_long_read(&rp->wait.count),
> +		 rp->page_num * PAGE_CACHE_SIZE, rp->wait.condition);
> +
> +	for (i = 0; i < rp->page_num; ++i) {
> +		struct page *page = rp->pages[i];
> +
> +		flush_dcache_page(page);
> +		SetPageUptodate(page);
> +		unlock_page(page);
> +		page_cache_release(page);
> +	}
> +
> +	iput(&rp->wait.pi->vfs_inode);
> +	kfree(rp);
> +}
> +
> +static void pohmelfs_readpages_destroy(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_readpages_priv *rp = t->priv;
> +	struct pohmelfs_wait *wait = &rp->wait;
> +
> +	if (!wait->condition)
> +		wait->condition = 1;
> +
> +	wake_up(&wait->wq);
> +	kref_put(&rp->refcnt, pohmelfs_readpages_free);
> +}
> +
> +static int pohmelfs_readpages_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_readpages_priv *rp = t->priv;
> +	struct pohmelfs_wait *wait = &rp->wait;
> +	struct dnet_cmd *cmd = &recv->cmd;
> +
> +	if (!(cmd->flags & DNET_FLAGS_MORE)) {
> +		if (!wait->condition) {
> +			wait->condition = cmd->status;
> +			if (!wait->condition)
> +				wait->condition = 1;
> +			wake_up(&rp->wait.wq);
> +		}
> +	}
> +
> +	pr_debug("%d:%s: read: %ld, wait: %d\n",
> +		 cmd->id.group_id, pohmelfs_dump_id(wait->pi->id.id),
> +		 atomic_long_read(&wait->count), wait->condition);
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_readpages_init(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_readpages_priv *rp = t->priv;
> +
> +	kref_get(&rp->refcnt);
> +	return 0;
> +}
> +
> +static int pohmelfs_readpages_recv_reply(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_readpages_priv *rp = t->priv;
> +	struct pohmelfs_wait *wait = &rp->wait;
> +	struct pohmelfs_inode *pi = wait->pi;
> +	unsigned int asize = sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
> +	void *data = &t->cmd.attr; /* overwrite send buffer used for attr/ioattr */
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	struct page *page;
> +	pgoff_t offset;
> +	int err, size;
> +
> +	if (t->io_offset < asize) {
> +		size = asize - t->io_offset;
> +		data += t->io_offset;
> +		err = pohmelfs_recv(t, recv, data, size);
> +		if (err < 0)
> +			goto err_out_exit;
> +
> +		dnet_convert_io_attr(&t->cmd.p.io);
> +	}
> +
> +	while (t->io_offset != cmd->size) {
> +		offset = (t->io_offset - asize) & (PAGE_CACHE_SIZE - 1);
> +		size = PAGE_CACHE_SIZE - offset;
> +		page = rp->pages[rp->page_index];
> +
> +		if (size > cmd->size - t->io_offset)
> +			size = cmd->size - t->io_offset;
> +
> +		data = kmap(page);
> +		err = pohmelfs_recv(t, recv, data + offset, size);
> +		kunmap(page);
> +
> +		if (err > 0 && ((err + offset == PAGE_CACHE_SIZE) || (t->io_offset == cmd->size)))  {
> +			rp->page_index++;
> +		}
> +
> +		if (err < 0)
> +			goto err_out_exit;
> +
> +		atomic_long_add(err, &wait->count);
> +	}
> +
> +	err = 0;
> +
> +err_out_exit:
> +	if ((err < 0) && (err != -ENOENT) && (err != -EAGAIN))
> +		pr_err("%d:%s: offset: %lld, data size: %llu, err: %d\n",
> +		       cmd->id.group_id, pohmelfs_dump_id(pi->id.id),
> +		       t->io_offset - asize + t->cmd.p.io.offset,
> +		       (unsigned long long)cmd->size - asize, err);
> +
> +	return err;
> +}
> +
> +static int pohmelfs_readpages_group(struct pohmelfs_inode *pi, struct pohmelfs_readpages_priv *rp, int group_id)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
> +	struct pohmelfs_wait *wait = &rp->wait;
> +	struct pohmelfs_io *io;
> +	long ret;
> +	int err;
> +
> +	io = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!io) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	io->pi = pi;
> +	io->id = &pi->id;
> +	io->cmd = DNET_CMD_READ;
> +	/*
> +	 * We send read command with lock, so its will be picked by the same threads as process
> +	 * bulk write commands leaving nonblocking threads free for metadata commands like
> +	 * directory reading, lookup and so on
> +	 */
> +	//io->cflags = DNET_FLAGS_NEED_ACK | DNET_FLAGS_NOLOCK;
> +	io->cflags = DNET_FLAGS_NEED_ACK;
> +	io->offset = page_offset(rp->pages[0]);
> +	io->size = rp->page_num * PAGE_CACHE_SIZE;
> +	if (psb->no_read_csum)
> +		io->ioflags = DNET_IO_FLAGS_NOCSUM;
> +	io->cb.init = pohmelfs_readpages_init;
> +	io->cb.complete = pohmelfs_readpages_complete;
> +	io->cb.destroy = pohmelfs_readpages_destroy;
> +	io->cb.recv_reply = pohmelfs_readpages_recv_reply;
> +	io->priv = rp;
> +
> +	err = pohmelfs_send_io_group(io, group_id);
> +	if (err)
> +		goto err_out_free;
> +
> +	ret = wait_event_interruptible_timeout(wait->wq, wait->condition != 0, msecs_to_jiffies(psb->read_wait_timeout));
> +	if (ret <= 0) {
> +		err = ret;
> +		if (ret == 0)
> +			err = -ETIMEDOUT;
> +		goto err_out_free;
> +	}
> +
> +	if (wait->condition < 0) {
> +		err = wait->condition;
> +		goto err_out_free;
> +	}
> +
> +	err = atomic_long_read(&wait->count);
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_io_cache, io);
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_readpages_groups(struct pohmelfs_inode *pi, struct pohmelfs_readpages_priv *rp,
> +		int *groups, int group_num)
> +{
> +	int err = -ENOENT;
> +	int i;
> +
> +	for (i = 0; i < group_num; ++i) {
> +		err = pohmelfs_readpages_group(pi, rp, groups[i]);
> +		if (err < 0)
> +			continue;
> +
> +		break;
> +	}
> +
> +	pi->update = get_seconds();
> +	return err;
> +}
> +
> +static struct pohmelfs_readpages_priv *pohmelfs_readpages_alloc(struct pohmelfs_inode *pi, int page_num)
> +{
> +	struct pohmelfs_readpages_priv *rp;
> +	int err;
> +
> +	rp = kzalloc(sizeof(struct pohmelfs_readpages_priv) + page_num * sizeof(struct page *), GFP_NOIO);
> +	if (!rp) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	err = pohmelfs_wait_init(&rp->wait, pi);
> +	if (err)
> +		goto err_out_free;
> +
> +	rp->page_num = page_num;
> +	kref_init(&rp->refcnt);
> +	return rp;
> +
> +err_out_free:
> +	kfree(rp);
> +err_out_exit:
> +	return ERR_PTR(err);
> +}
> +
> +static int pohmelfs_readpages_send(struct pohmelfs_inode *pi, struct pohmelfs_readpages_priv *rp)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
> +	int err;
> +
> +	if (pi->group_num) {
> +		err = pohmelfs_readpages_groups(pi, rp, pi->groups, pi->group_num);
> +	} else {
> +		err = pohmelfs_readpages_groups(pi, rp, psb->groups, psb->group_num);
> +	}
> +
> +	return err;
> +}
> +
> +static int pohmelfs_readpages_send_list(struct address_space *mapping, struct list_head *page_list, int num)
> +{
> +	struct inode *inode = mapping->host;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	int err = 0, i;
> +	struct pohmelfs_readpages_priv *rp;
> +	struct page *tmp, *page;
> +
> +	if (list_empty(page_list))
> +		goto err_out_exit;
> +
> +	rp = pohmelfs_readpages_alloc(pi, num);
> +	if (IS_ERR(rp)) {
> +		err = PTR_ERR(rp);
> +		goto err_out_exit;
> +	}
> +
> +	i = 0;
> +	list_for_each_entry_safe(page, tmp, page_list, lru) {
> +		list_del(&page->lru);
> +
> +		if (add_to_page_cache_lru(page, mapping, page->index, GFP_KERNEL)) {
> +			/* Failed - free current page, optionally send already grabbed and free others */
> +			page_cache_release(page);
> +			break;
> +		}
> +
> +		rp->pages[i] = page;
> +		i++;
> +	}
> +
> +	if (i > 0) {
> +		rp->page_num = i;
> +		err = pohmelfs_readpages_send(pi, rp);
> +
> +		pr_debug("%s: ino: %lu, offset: %lu, pages: %u/%u: %d\n",
> +			 pohmelfs_dump_id(pi->id.id), inode->i_ino,
> +			 (long)page_offset(rp->pages[0]),
> +			 rp->page_num, num, err);
> +	}
> +
> +	kref_put(&rp->refcnt, pohmelfs_readpages_free);
> +
> +	/* Cleanup pages which were not added into page cache */
> +	list_for_each_entry_safe(page, tmp, page_list, lru) {
> +		list_del(&page->lru);
> +		page_cache_release(page);
> +	}
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_readpages(struct file *filp, struct address_space *mapping,
> +			struct list_head *page_list, unsigned nr_pages)
> +{
> +	struct page *tmp, *page;
> +	pgoff_t idx;
> +	LIST_HEAD(head);
> +	int err = 0, i = 0;
> +
> +	while (!list_empty(page_list)) {
> +		page = list_entry(page_list->prev, struct page, lru);
> +		idx = page->index;
> +		i = 0;
> +
> +		INIT_LIST_HEAD(&head);
> +
> +		list_for_each_entry_safe_reverse(page, tmp, page_list, lru) {
> +			if (idx != page->index) {
> +				struct pohmelfs_inode *pi = pohmelfs_inode(mapping->host);
> +				pr_debug("%s: index mismatch: want: %ld, page-index: %ld, total: %d\n",
> +					 pohmelfs_dump_id(pi->id.id),
> +					 (long)idx, (long)page->index,
> +					 nr_pages);
> +				break;
> +			}
> +
> +			list_move_tail(&page->lru, &head);
> +			i++;
> +			idx++;
> +		}
> +
> +		err = pohmelfs_readpages_send_list(mapping, &head, i);
> +	}
> +	if (err >= 0)
> +		err = 0;
> +
> +	return err;
> +}
> +
> +static int pohmelfs_readpage(struct file *file, struct page *page)
> +{
> +	struct inode *inode = page->mapping->host;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	struct pohmelfs_readpages_priv *rp;
> +	int err;
> +
> +	if (inode->i_size <= page->index << PAGE_CACHE_SHIFT) {
> +		SetPageUptodate(page);
> +		unlock_page(page);
> +		return 0;
> +	}
> +
> +	rp = pohmelfs_readpages_alloc(pi, 1);
> +	if (IS_ERR(rp)) {
> +		err = PTR_ERR(rp);
> +		goto err_out_exit;
> +	}
> +
> +	rp->pages[0] = page;
> +	page_cache_get(page);
> +
> +	err = pohmelfs_readpages_send(pi, rp);
> +	if (err >= 0)
> +		err = 0;
> +
> +	kref_put(&rp->refcnt, pohmelfs_readpages_free);
> +err_out_exit:
> +	if (err < 0)
> +		pr_err("%s: %s: ino: %lu, offset: %lu, uptodate: %d, err: %d\n",
> +		       __func__, pohmelfs_dump_id(pi->id.id), inode->i_ino,
> +		       (long)page_offset(page), PageUptodate(page), err);
> +
> +	return err;
> +}
> +
> +void pohmelfs_write_ctl_release(struct kref *kref)
> +{
> +	struct pohmelfs_write_ctl *ctl = container_of(kref, struct pohmelfs_write_ctl, refcnt);
> +	struct address_space *mapping = ctl->pvec.pages[0]->mapping;
> +	struct inode *inode = mapping->host;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
> +	int bad_write = atomic_read(&ctl->good_writes) < psb->group_num / 2 + 1;
> +	struct page *page;
> +	unsigned int i;
> +
> +	if (psb->successful_write_count && (atomic_read(&ctl->good_writes) >= psb->successful_write_count))
> +		bad_write = 0;
> +
> +	if (bad_write) {
> +		struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +		unsigned long long offset = page_offset(ctl->pvec.pages[0]);
> +
> +		pr_debug("%s: bad write: ino: %lu, isize: %llu, offset: %llu: writes: %d/%d\n",
> +			 pohmelfs_dump_id(pi->id.id),
> +			 inode->i_ino, inode->i_size, offset,
> +			 atomic_read(&ctl->good_writes), psb->group_num);
> +		mapping_set_error(mapping, -EIO);
> +	}
> +
> +	for (i = 0; i < pagevec_count(&ctl->pvec); ++i) {
> +		page = ctl->pvec.pages[i];
> +
> +		if (PageLocked(page)) {
> +			end_page_writeback(page);
> +
> +			if (bad_write) {
> +				SetPageError(page);
> +				ClearPageUptodate(page);
> +				/*
> +				 * Do not reschedule failed write page again
> +				 * This may explode systems with large caches
> +				 * when there is no connection to elliptics cluster
> +				 */
> +				//set_page_dirty(page);
> +			}
> +			unlock_page(page);
> +		}
> +	}
> +
> +	pagevec_release(&ctl->pvec);
> +	kmem_cache_free(pohmelfs_write_cache, ctl);
> +}
> +
> +static int pohmelfs_writepages_chunk(struct pohmelfs_inode *pi, struct pohmelfs_write_ctl *ctl,
> +		struct writeback_control *wbc, struct address_space *mapping)
> +{
> +	struct inode *inode = &pi->vfs_inode;
> +	uint64_t offset, size;
> +	unsigned i;
> +	int err = 0, good = 0;
> +
> +	offset = page_offset(ctl->pvec.pages[0]);
> +
> +	size = 0;
> +	/* we will lookup them again when doing actual send */
> +	for (i = 0; i< pagevec_count(&ctl->pvec); ++i) {
> +		struct page *page = ctl->pvec.pages[i];
> +
> +		lock_page(page);
> +#if 1
> +		if (unlikely(page->mapping != mapping)) {
> +continue_unlock:
> +			unlock_page(page);
> +			continue;
> +		}
> +
> +		if (wbc->sync_mode != WB_SYNC_NONE)
> +			wait_on_page_writeback(page);
> +		if (PageWriteback(page)) {
> +			unlock_page(page);
> +			break;
> +		}
> +
> +		if (!PageDirty(page))
> +			goto continue_unlock;
> +
> +		if (!clear_page_dirty_for_io(page))
> +			goto continue_unlock;
> +#else
> +		clear_page_dirty_for_io(page);
> +#endif
> +
> +		set_page_writeback(page);
> +
> +		good++;
> +		size += PAGE_CACHE_SIZE;
> +		wbc->nr_to_write--;
> +	}
> +
> +	if (good != 0) {
> +		size = pagevec_count(&ctl->pvec) * PAGE_CACHE_SIZE;
> +		if (offset + size > inode->i_size)
> +			size = inode->i_size - offset;
> +
> +		err = pohmelfs_write_command(pi, ctl, offset, size);
> +		if (err)
> +			goto err_out_exit;
> +	}
> +
> +err_out_exit:
> +	kref_put(&ctl->refcnt, pohmelfs_write_ctl_release);
> +	return err;
> +}
> +
> +static int pohmelfs_writepages_send(struct address_space *mapping, struct writeback_control *wbc, struct pagevec *pvec, int start, int end)
> +{
> +	struct inode *inode = mapping->host;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	struct pohmelfs_write_ctl *ctl;
> +	int err, i;
> +
> +	ctl = kmem_cache_zalloc(pohmelfs_write_cache, GFP_NOIO);
> +	if (!ctl) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	kref_init(&ctl->refcnt);
> +	atomic_set(&ctl->good_writes, 0);
> +
> +	for (i = start; i < end; ++i)
> +		pagevec_add(&ctl->pvec, pvec->pages[i]);
> +
> +	err = pohmelfs_writepages_chunk(pi, ctl, wbc, mapping);
> +	if (err)
> +		goto err_out_exit;
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
> +{
> +	struct inode *inode = mapping->host;
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	pgoff_t index, start, end /* inclusive */, idx;
> +	int done = 0;
> +	int range_whole = 0;
> +	int should_loop = 1;
> +	int nr_pages, err = 0, i, start_idx;
> +	struct pagevec pvec;
> +	int written = 0;
> +
> +	index = wbc->range_start >> PAGE_CACHE_SHIFT;
> +	end = wbc->range_end >> PAGE_CACHE_SHIFT;
> +
> +	pr_debug("%s: ino: %ld, nr: %ld, index: %llu, end: %llu, total_size: %lu, sync: %d\n",
> +		 pohmelfs_dump_id(pohmelfs_inode(inode)->id.id), inode->i_ino,
> +		 wbc->nr_to_write, wbc->range_start, wbc->range_end,
> +		 (unsigned long)inode->i_size, wbc->sync_mode);
> +
> +	if (wbc->range_cyclic) {
> +		start = mapping->writeback_index; /* Start from prev offset */
> +		end = -1;
> +	} else {
> +		start = wbc->range_start >> PAGE_CACHE_SHIFT;
> +		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> +		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
> +			range_whole = 1;
> +		should_loop = 0;
> +	}
> +	index = start;
> +
> +retry:
> +	while (!done && index <= end) {
> +		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
> +			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
> +		if (!nr_pages) {
> +			err = 0;
> +			break;
> +		}
> +
> +		idx = pvec.pages[0]->index;
> +		for (start_idx = 0, i = 0; i< nr_pages; ++i) {
> +			struct page *page = pvec.pages[i];
> +
> +			/* non-contiguous pages detected */
> +			if (idx != page->index) {
> +				err = pohmelfs_writepages_send(mapping, wbc, &pvec, start_idx, i);
> +				if (err)
> +					goto err_out_exit;
> +				start_idx = i;
> +			}
> +
> +			idx++;
> +		}
> +
> +		err = pohmelfs_writepages_send(mapping, wbc, &pvec, start_idx, nr_pages);
> +		if (err)
> +			goto err_out_exit;
> +
> +		if (wbc->nr_to_write <= 0)
> +			done = 1;
> +
> +		written += nr_pages;
> +	}
> +
> +	if (should_loop && !done) {
> +		/* more to do; loop back to beginning of file */
> +		should_loop = 0;
> +		index = 0;
> +		goto retry;
> +	}
> +
> +	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
> +		mapping->writeback_index = index;
> +
> +	if (written) {
> +		err = pohmelfs_metadata_inode(pi, wbc->sync_mode != WB_SYNC_NONE);
> +		if (err)
> +			goto err_out_exit;
> +	}
> +
> +
> +	if (test_and_clear_bit(AS_EIO, &mapping->flags))
> +		err = -EIO;
> +err_out_exit:
> +	pr_debug("%s: metadata write complete: %d\n",
> +		 pohmelfs_dump_id(pi->id.id), err);
> +	return err;
> +}
> +
> +static const struct address_space_operations pohmelfs_aops = {
> +	.write_begin		= simple_write_begin,
> +	.write_end		= simple_write_end,
> +	.writepages		= pohmelfs_writepages,
> +	.readpage		= pohmelfs_readpage,
> +	.readpages		= pohmelfs_readpages,
> +	.set_page_dirty 	= __set_page_dirty_nobuffers,
> +};
> +
> +void pohmelfs_convert_inode_info(struct pohmelfs_inode_info *info)
> +{
> +	info->ino = cpu_to_le64(info->ino);
> +	info->mode = cpu_to_le64(info->mode);
> +	info->nlink = cpu_to_le64(info->nlink);
> +	info->uid = cpu_to_le32(info->uid);
> +	info->gid = cpu_to_le32(info->gid);
> +	info->namelen = cpu_to_le32(info->namelen);
> +	info->blocks = cpu_to_le64(info->blocks);
> +	info->rdev = cpu_to_le64(info->rdev);
> +	info->size = cpu_to_le64(info->size);
> +	info->version = cpu_to_le64(info->version);
> +	info->blocksize = cpu_to_le64(info->blocksize);
> +	info->flags = cpu_to_le64(info->flags);
> +
> +	dnet_convert_time(&info->ctime);
> +	dnet_convert_time(&info->mtime);
> +	dnet_convert_time(&info->atime);
> +}
> +
> +void pohmelfs_fill_inode_info(struct inode *inode, struct pohmelfs_inode_info *info)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +
> +	memcpy(info->id.id, pi->id.id, DNET_ID_SIZE);
> +
> +	info->ino = inode->i_ino;
> +	info->mode = inode->i_mode;
> +	info->nlink = inode->i_nlink;
> +	info->uid = inode->i_uid;
> +	info->gid = inode->i_gid;
> +	info->blocks = inode->i_blocks;
> +	info->rdev = inode->i_rdev;
> +	info->size = inode->i_size;
> +	info->version = inode->i_version;
> +	info->blocksize = 1 << inode->i_blkbits;
> +
> +	info->ctime.tsec = inode->i_ctime.tv_sec;
> +	info->ctime.tnsec = inode->i_ctime.tv_nsec;
> +
> +	info->mtime.tsec = inode->i_mtime.tv_sec;
> +	info->mtime.tnsec = inode->i_mtime.tv_nsec;
> +
> +	info->atime.tsec = inode->i_atime.tv_sec;
> +	info->atime.tnsec = inode->i_atime.tv_nsec;
> +
> +	info->flags = 0;
> +}
> +
> +void pohmelfs_fill_inode(struct inode *inode, struct pohmelfs_inode_info *info)
> +{
> +	pr_debug("%s: ino: %lu inode is regular: %d, dir: %d, link: %d, mode: %o, "
> +		 "namelen: %u, size: %llu, state: %lx, mtime: %llu.%llu/%lu.%lu\n",
> +		 pohmelfs_dump_id(info->id.id), inode->i_ino,
> +		 S_ISREG(inode->i_mode), S_ISDIR(inode->i_mode),
> +		 S_ISLNK(inode->i_mode), inode->i_mode, info->namelen,
> +		 inode->i_size, inode->i_state,
> +		 (unsigned long long)info->mtime.tsec,
> +		 (unsigned long long)info->mtime.tnsec,
> +		 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec);
> +
> +	if (info->mtime.tsec < inode->i_mtime.tv_sec)
> +		return;
> +	if ((info->mtime.tsec == inode->i_mtime.tv_sec) &&
> +			(info->mtime.tnsec < inode->i_mtime.tv_nsec))
> +		return;
> +
> +	pohmelfs_inode(inode)->id = info->id;
> +
> +	inode->i_mode = info->mode;
> +	set_nlink(inode, info->nlink);
> +	inode->i_uid = info->uid;
> +	inode->i_gid = info->gid;
> +	inode->i_blocks = info->blocks;
> +	inode->i_rdev = info->rdev;
> +	inode->i_size = info->size;
> +	inode->i_version = info->version;
> +	inode->i_blkbits = ffs(info->blocksize);
> +
> +	inode->i_mtime = pohmelfs_date(&info->mtime);
> +	inode->i_atime = pohmelfs_date(&info->atime);
> +	inode->i_ctime = pohmelfs_date(&info->ctime);
> +}
> +
> +static void pohmelfs_inode_info_current(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info)
> +{
> +	struct timespec ts = CURRENT_TIME;
> +	struct dnet_time dtime;
> +
> +	info->nlink = S_ISDIR(info->mode) ? 2 : 1;
> +	info->uid = current_fsuid();
> +	info->gid = current_fsgid();
> +	info->size = 0;
> +	info->blocksize = PAGE_SIZE;
> +	info->blocks = 0;
> +	info->rdev = 0;
> +	info->version = 0;
> +
> +	dtime.tsec = ts.tv_sec;
> +	dtime.tnsec = ts.tv_nsec;
> +
> +	info->ctime = dtime;
> +	info->mtime = dtime;
> +	info->atime = dtime;
> +
> +	pohmelfs_gen_id(psb, &info->id);
> +}
> +
> +const struct inode_operations pohmelfs_special_inode_operations = {
> +	.setattr			= simple_setattr,
> +};
> +
> +struct pohmelfs_inode *pohmelfs_existing_inode(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info)
> +{
> +	struct pohmelfs_inode *pi;
> +	struct inode *inode;
> +	int err;
> +
> +	inode = iget_locked(psb->sb, atomic_long_inc_return(&psb->ino));
> +	if (!inode) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	pi = pohmelfs_inode(inode);
> +
> +	if (inode->i_state & I_NEW) {
> +		pohmelfs_fill_inode(inode, info);
> +		/*
> +		 * i_mapping is a pointer to i_data during inode initialization.
> +		 */
> +		inode->i_data.a_ops = &pohmelfs_aops;
> +
> +		if (S_ISREG(inode->i_mode)) {
> +			inode->i_fop = &pohmelfs_file_ops;
> +			inode->i_op = &pohmelfs_file_inode_operations;
> +		} else if (S_ISDIR(inode->i_mode)) {
> +			inode->i_fop = &pohmelfs_dir_fops;
> +			inode->i_op = &pohmelfs_dir_inode_operations;
> +		} else if (S_ISLNK(inode->i_mode)) {
> +			inode->i_op = &pohmelfs_symlink_inode_operations;
> +			inode->i_mapping->a_ops = &pohmelfs_aops;
> +		} else {
> +			inode->i_op = &pohmelfs_special_inode_operations;
> +		}
> +
> +		err = pohmelfs_sb_inode_insert(psb, pi);
> +		if (err)
> +			goto err_out_put;
> +
> +		unlock_new_inode(inode);
> +	}
> +
> +	return pi;
> +
> +err_out_put:
> +	unlock_new_inode(inode);
> +	iput(inode);
> +err_out_exit:
> +	return ERR_PTR(err);
> +}
> +
> +struct pohmelfs_inode *pohmelfs_new_inode(struct pohmelfs_sb *psb, int mode)
> +{
> +	struct pohmelfs_inode *pi;
> +	struct pohmelfs_inode_info *info;
> +	int err;
> +
> +	info = kmem_cache_zalloc(pohmelfs_inode_info_cache, GFP_NOIO);
> +	if (!info) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	info->mode = mode;
> +
> +	pohmelfs_inode_info_current(psb, info);
> +
> +	pi = pohmelfs_existing_inode(psb, info);
> +	if (IS_ERR(pi)) {
> +		err = PTR_ERR(pi);
> +		goto err_out_free;
> +	}
> +
> +	kmem_cache_free(pohmelfs_inode_info_cache, info);
> +	return pi;
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_inode_info_cache, info);
> +err_out_exit:
> +	return ERR_PTR(err);
> +}
> +
> +int pohmelfs_wait_init(struct pohmelfs_wait *wait, struct pohmelfs_inode *pi)
> +{
> +	if (!igrab(&pi->vfs_inode))
> +		return -EINVAL;
> +
> +	wait->pi = pi;
> +
> +	atomic_long_set(&wait->count, 0);
> +	init_waitqueue_head(&wait->wq);
> +	kref_init(&wait->refcnt);
> +
> +	return 0;
> +}
> +
> +struct pohmelfs_wait *pohmelfs_wait_alloc(struct pohmelfs_inode *pi)
> +{
> +	struct pohmelfs_wait *wait;
> +
> +	wait = kmem_cache_zalloc(pohmelfs_wait_cache, GFP_NOIO);
> +	if (!wait) {
> +		goto err_out_exit;
> +	}
> +
> +	if (pohmelfs_wait_init(wait, pi))
> +		goto err_out_free;
> +
> +	return wait;
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_wait_cache, wait);
> +err_out_exit:
> +	return NULL;
> +}
> +
> +static void pohmelfs_wait_free(struct kref *kref)
> +{
> +	struct pohmelfs_wait *wait = container_of(kref, struct pohmelfs_wait, refcnt);
> +	struct inode *inode = &wait->pi->vfs_inode;
> +
> +	iput(inode);
> +	kmem_cache_free(pohmelfs_wait_cache, wait);
> +}
> +
> +void pohmelfs_wait_put(struct pohmelfs_wait *wait)
> +{
> +	kref_put(&wait->refcnt, pohmelfs_wait_free);
> +}
> diff --git a/fs/pohmelfs/net.c b/fs/pohmelfs/net.c
> new file mode 100644
> index 0000000..7907939
> --- /dev/null
> +++ b/fs/pohmelfs/net.c
> @@ -0,0 +1,703 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <linux/net.h>
> +
> +#include <net/sock.h>
> +#include <net/tcp.h>
> +
> +#include "pohmelfs.h"
> +
> +void *pohmelfs_scratch_buf;
> +int pohmelfs_scratch_buf_size = 4096;
> +
> +void pohmelfs_print_addr(struct sockaddr_storage *addr, const char *fmt, ...)
> +{
> +	struct sockaddr *sa = (struct sockaddr *)addr;
> +	struct va_format vaf;
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	if (sa->sa_family == AF_INET) {
> +		struct sockaddr_in *sin = (struct sockaddr_in *)addr;
> +		pr_info("%pI4:%d: %pV",
> +			&sin->sin_addr.s_addr, ntohs(sin->sin_port), &vaf);
> +	} else if (sa->sa_family == AF_INET6) {
> +		struct sockaddr_in6 *sin = (struct sockaddr_in6 *)addr;
> +		pr_info("%pI6:%d: %pV",
> +			&sin->sin6_addr, ntohs(sin->sin6_port), &vaf);
> +	}
> +
> +	va_end(args);
> +}
> +
> +/*
> + * Basic network sending/receiving functions.
> + * Blocked mode is used.
> + */
> +int pohmelfs_data_recv(struct pohmelfs_state *st, void *buf, u64 size, unsigned int flags)
> +{
> +	struct msghdr msg;
> +	struct kvec iov;
> +	int err;
> +
> +	BUG_ON(!size);
> +
> +	iov.iov_base = buf;
> +	iov.iov_len = size;
> +
> +	msg.msg_iov = (struct iovec *)&iov;
> +	msg.msg_iovlen = 1;
> +	msg.msg_name = NULL;
> +	msg.msg_namelen = 0;
> +	msg.msg_control = NULL;
> +	msg.msg_controllen = 0;
> +	msg.msg_flags = flags;
> +
> +	err = kernel_recvmsg(st->sock, &msg, &iov, 1, iov.iov_len, msg.msg_flags);
> +	if (err < 0)
> +		goto err_out_exit;
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +int pohmelfs_recv(struct pohmelfs_trans *t, struct pohmelfs_state *recv, void *data, int size)
> +{
> +	int err;
> +
> +	err = pohmelfs_data_recv(recv, data, size, MSG_DONTWAIT);
> +	if (err < 0)
> +		return err;
> +
> +	t->io_offset += err;
> +	return err;
> +}
> +
> +static int pohmelfs_data_send(struct pohmelfs_trans *t)
> +{
> +	struct msghdr msg;
> +	struct iovec io;
> +	int err;
> +
> +	msg.msg_name = NULL;
> +	msg.msg_namelen = 0;
> +	msg.msg_control = NULL;
> +	msg.msg_controllen = 0;
> +	msg.msg_flags = MSG_DONTWAIT;
> +
> +	msg.msg_iov = &io;
> +	msg.msg_iovlen = 1;
> +
> +
> +	if (t->io_offset < t->header_size) {
> +		io.iov_base = (void *)(&t->cmd) + t->io_offset;
> +		io.iov_len = t->header_size - t->io_offset;
> +
> +		err = kernel_sendmsg(t->st->sock, &msg, (struct kvec *)msg.msg_iov, 1, io.iov_len);
> +		if (err < 0) {
> +			if (err == 0)
> +				err = -ECONNRESET;
> +			goto err_out_exit;
> +		}
> +
> +		t->io_offset += err;
> +	}
> +
> +	if ((t->io_offset >= t->header_size) && t->data) {
> +		size_t sent_size = t->io_offset - t->header_size;
> +		io.iov_base = t->data + sent_size;
> +		io.iov_len = t->data_size - sent_size;
> +
> +		err = kernel_sendmsg(t->st->sock, &msg, (struct kvec *)msg.msg_iov, 1, io.iov_len);
> +		if (err < 0) {
> +			if (err == 0)
> +				err = -ECONNRESET;
> +			goto err_out_exit;
> +		}
> +
> +		t->io_offset += err;
> +	}
> +
> +
> +	err = 0;
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_page_send(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_write_ctl *ctl = t->wctl;
> +	struct msghdr msg;
> +	struct iovec io;
> +	unsigned i;
> +	int err = -EINVAL;
> +
> +	if (t->io_offset < t->header_size) {
> +		io.iov_base = (void *)(&t->cmd) + t->io_offset;
> +		io.iov_len = t->header_size - t->io_offset;
> +
> +		msg.msg_name = NULL;
> +		msg.msg_namelen = 0;
> +		msg.msg_control = NULL;
> +		msg.msg_controllen = 0;
> +		msg.msg_flags = MSG_DONTWAIT;
> +
> +		msg.msg_iov = &io;
> +		msg.msg_iovlen = 1;
> +
> +		err = kernel_sendmsg(t->st->sock, &msg, (struct kvec *)msg.msg_iov, 1, io.iov_len);
> +		if (err < 0) {
> +			if (err == 0)
> +				err = -ECONNRESET;
> +			goto err_out_exit;
> +		}
> +
> +		t->io_offset += err;
> +	}
> +
> +	if (t->io_offset >= t->header_size) {
> +		size_t skip_offset = 0;
> +		size_t size = le64_to_cpu(t->cmd.cmd.size) + sizeof(struct dnet_cmd) - t->io_offset;
> +		size_t current_io_offset = t->io_offset - t->header_size;
> +
> +		for (i = 0; i < pagevec_count(&ctl->pvec); ++i) {
> +			struct page *page = ctl->pvec.pages[i];
> +			size_t sz = PAGE_CACHE_SIZE;
> +
> +			if (sz > size)
> +				sz = size;
> +
> +			if (current_io_offset > skip_offset + sz) {
> +				skip_offset += sz;
> +				continue;
> +			}
> +
> +			sz -= current_io_offset - skip_offset;
> +
> +			err = kernel_sendpage(t->st->sock, page, current_io_offset - skip_offset, sz, MSG_DONTWAIT);
> +
> +			pr_debug("%s: %d/%d: total-size: %llu, io-offset: %llu, rest-size: %zd, current-io: %zd, skip-offset: %zd, sz: %zu: %d\n",
> +				 pohmelfs_dump_id(pohmelfs_inode(t->inode)->id.id),
> +				 i, pagevec_count(&ctl->pvec),
> +				 (unsigned long long)le64_to_cpu(t->cmd.cmd.size) + sizeof(struct dnet_cmd),
> +				 t->io_offset, size, current_io_offset,
> +				 skip_offset, sz, err);
> +
> +			if (err <= 0) {
> +				if (err == 0)
> +					err = -ECONNRESET;
> +				goto err_out_exit;
> +			}
> +
> +			current_io_offset += err;
> +			skip_offset = current_io_offset;
> +			size -= err;
> +			t->io_offset += err;
> +
> +			err = 0;
> +		}
> +	}
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +/*
> + * Polling machinery.
> + */
> +
> +struct pohmelfs_poll_helper {
> +	poll_table 		pt;
> +	struct pohmelfs_state	*st;
> +};
> +
> +static int pohmelfs_queue_wake(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	struct pohmelfs_state *st = container_of(wait, struct pohmelfs_state, wait);
> +
> +	if (!st->conn->need_exit)
> +		queue_work(st->conn->wq, &st->io_work);
> +	return 0;
> +}
> +
> +static void pohmelfs_queue_func(struct file *file, wait_queue_head_t *whead, poll_table *pt)
> +{
> +	struct pohmelfs_state *st = container_of(pt, struct pohmelfs_poll_helper, pt)->st;
> +
> +	st->whead = whead;
> +
> +	init_waitqueue_func_entry(&st->wait, pohmelfs_queue_wake);
> +	add_wait_queue(whead, &st->wait);
> +}
> +
> +static void pohmelfs_poll_exit(struct pohmelfs_state *st)
> +{
> +	if (st->whead) {
> +		remove_wait_queue(st->whead, &st->wait);
> +		st->whead = NULL;
> +	}
> +}
> +
> +static int pohmelfs_poll_init(struct pohmelfs_state *st)
> +{
> +	struct pohmelfs_poll_helper ph;
> +
> +	ph.st = st;
> +	init_poll_funcptr(&ph.pt, &pohmelfs_queue_func);
> +
> +	st->sock->ops->poll(NULL, st->sock, &ph.pt);
> +	return 0;
> +}
> +
> +static int pohmelfs_revents(struct pohmelfs_state *st, unsigned mask)
> +{
> +	unsigned revents;
> +
> +	revents = st->sock->ops->poll(NULL, st->sock, NULL);
> +	if (revents & mask)
> +		return 0;
> +
> +	if (revents & (POLLERR | POLLHUP | POLLNVAL | POLLRDHUP | POLLREMOVE)) {
> +		pohmelfs_print_addr(&st->sa, "error revents: %x\n", revents);
> +		return -ECONNRESET;
> +	}
> +
> +	return -EAGAIN;
> +}
> +
> +static int pohmelfs_state_send(struct pohmelfs_state *st)
> +{
> +	struct pohmelfs_trans *t = NULL;
> +	int trans_put = 0;
> +	size_t size;
> +	int err = -EAGAIN;
> +
> +	mutex_lock(&st->trans_lock);
> +	if (!list_empty(&st->trans_list))
> +		t = list_first_entry(&st->trans_list, struct pohmelfs_trans, trans_entry);
> +	mutex_unlock(&st->trans_lock);
> +
> +	if (!t)
> +		goto err_out_exit;
> +
> +	err = pohmelfs_revents(st, POLLOUT);
> +	if (err)
> +		goto err_out_exit;
> +
> +	size = le64_to_cpu(t->cmd.cmd.size) + sizeof(struct dnet_cmd);
> +	pr_debug("%s: starting sending: %llu/%zd\n",
> +		 pohmelfs_dump_id(pohmelfs_inode(t->inode)->id.id),
> +		 t->io_offset, size);
> +
> +	if (t->wctl)
> +		err = pohmelfs_page_send(t);
> +	else
> +		err = pohmelfs_data_send(t);
> +
> +	pr_debug("%s: sent: %llu/%zd: %d\n",
> +		 pohmelfs_dump_id(pohmelfs_inode(t->inode)->id.id),
> +		 t->io_offset, size, err);
> +	if (!err && (t->io_offset == size)) {
> +		mutex_lock(&st->trans_lock);
> +			list_del_init(&t->trans_entry);
> +			err = pohmelfs_trans_insert_tree(st, t);
> +			if (err)
> +				trans_put = 1;
> +			t->io_offset = 0;
> +		mutex_unlock(&st->trans_lock);
> +	}
> +
> +	BUG_ON(t->io_offset > size);
> +
> +	if (trans_put)
> +		pohmelfs_trans_put(t);
> +
> +	if ((err < 0) && (err != -EAGAIN))
> +		goto err_out_exit;
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static void pohmelfs_suck_scratch(struct pohmelfs_state *st)
> +{
> +	struct dnet_cmd *cmd = &st->cmd;
> +	int err = 0;
> +
> +	pr_debug("%llu\n", (unsigned long long)cmd->size);
> +
> +	while (cmd->size) {
> +		int sz = pohmelfs_scratch_buf_size;
> +
> +		if (cmd->size < sz)
> +			sz = cmd->size;
> +
> +		err = pohmelfs_data_recv(st, pohmelfs_scratch_buf, sz, MSG_WAITALL);
> +		if (err < 0) {
> +			pohmelfs_print_addr(&st->sa, "recv-scratch err: %d\n", err);
> +			goto err_out_exit;
> +		}
> +
> +		cmd->size -= err;
> +	}
> +
> +err_out_exit:
> +	st->cmd_read = 1;
> +}
> +
> +static int pohmelfs_state_recv(struct pohmelfs_state *st)
> +{
> +	struct dnet_cmd *cmd = &st->cmd;
> +	struct pohmelfs_trans *t;
> +	unsigned long long trans;
> +	int err;
> +
> +	err = pohmelfs_revents(st, POLLIN);
> +	if (err)
> +		goto err_out_exit;
> +
> +	if (st->cmd_read) {
> +		err = pohmelfs_data_recv(st, cmd, sizeof(struct dnet_cmd), MSG_WAITALL);
> +		if (err <= 0) {
> +			if (err == 0)
> +				err = -ECONNRESET;
> +
> +			pohmelfs_print_addr(&st->sa, "recv error: %d\n", err);
> +			goto err_out_exit;
> +		}
> +
> +		dnet_convert_cmd(cmd);
> +
> +		trans = cmd->trans & ~DNET_TRANS_REPLY;
> +		st->cmd_read = 0;
> +	}
> +
> +	t = pohmelfs_trans_lookup(st, cmd);
> +	if (!t) {
> +		pohmelfs_suck_scratch(st);
> +
> +		err = 0;
> +		goto err_out_exit;
> +	}
> +	if (cmd->size && (t->io_offset != cmd->size)) {
> +		err = t->cb.recv_reply(t, st);
> +		if (err && (err != -EAGAIN)) {
> +			pohmelfs_print_addr(&st->sa, "recv-reply error: %d\n", err);
> +			goto err_out_remove;
> +		}
> +
> +		if (t->io_offset != cmd->size)
> +			goto err_out_put;
> +	}
> +
> +	err = t->cb.complete(t, st);
> +	if (err) {
> +		pohmelfs_print_addr(&st->sa, "recv-complete err: %d\n", err);
> +	}
> +
> +	kfree(t->recv_data);
> +	t->recv_data = NULL;
> +	t->io_offset = 0;
> +
> +err_out_remove:
> +	/* only remove and free transaction if there is error or there will be no more replies */
> +	if (!(cmd->flags & DNET_FLAGS_MORE) || err) {
> +		pohmelfs_trans_remove(t);
> +
> +		/*
> +		 * refcnt was grabbed twice:
> +		 *   in pohmelfs_trans_lookup()
> +		 *   and at transaction creation
> +		 */
> +		pohmelfs_trans_put(t);
> +	}
> +	st->cmd_read = 1;
> +	if (err) {
> +		cmd->size -= t->io_offset;
> +		t->io_offset = 0;
> +	}
> +
> +err_out_put:
> +	pohmelfs_trans_put(t);
> +err_out_exit:
> +	return err;
> +}
> +
> +static void pohmelfs_state_io_work(struct work_struct *work)
> +{
> +	struct pohmelfs_state *st = container_of(work, struct pohmelfs_state, io_work);
> +	int send_err, recv_err;
> +
> +	send_err = recv_err = -EAGAIN;
> +	while (!st->conn->psb->need_exit) {
> +		send_err = pohmelfs_state_send(st);
> +		if (send_err && (send_err != -EAGAIN)) {
> +			pohmelfs_print_addr(&st->sa, "state send error: %d\n", send_err);
> +			goto err_out_exit;
> +		}
> +
> +		recv_err = pohmelfs_state_recv(st);
> +		if (recv_err && (recv_err != -EAGAIN)) {
> +			pohmelfs_print_addr(&st->sa, "state recv error: %d\n", recv_err);
> +			goto err_out_exit;
> +		}
> +
> +		if ((send_err == -EAGAIN) && (recv_err == -EAGAIN))
> +			break;
> +	}
> +
> +err_out_exit:
> +	if ((send_err && (send_err != -EAGAIN)) || (recv_err && (recv_err != -EAGAIN))) {
> +		pohmelfs_state_add_reconnect(st);
> +	}
> +	return;
> +}
> +
> +struct pohmelfs_state *pohmelfs_addr_exist(struct pohmelfs_connection *conn, struct sockaddr_storage *sa, int addrlen)
> +{
> +	struct pohmelfs_state *st;
> +
> +	list_for_each_entry(st, &conn->state_list, state_entry) {
> +		if (st->addrlen != addrlen)
> +			continue;
> +
> +		if (!memcmp(&st->sa, sa, addrlen)) {
> +			return st;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +struct pohmelfs_state *pohmelfs_state_create(struct pohmelfs_connection *conn, struct sockaddr_storage *sa, int addrlen,
> +		int ask_route, int group_id)
> +{
> +	int err = 0;
> +	struct pohmelfs_state *st;
> +	struct sockaddr *addr = (struct sockaddr *)sa;
> +
> +	/* early check - this state can be inserted into route table, no need to create state and check again */
> +	spin_lock(&conn->state_lock);
> +	if (pohmelfs_addr_exist(conn, sa, addrlen))
> +		err = -EEXIST;
> +	spin_unlock(&conn->state_lock);
> +
> +	if (err)
> +		goto err_out_exit;
> +
> +	st = kzalloc(sizeof(struct pohmelfs_state), GFP_KERNEL);
> +	if (!st) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	st->conn = conn;
> +	mutex_init(&st->trans_lock);
> +	INIT_LIST_HEAD(&st->trans_list);
> +	st->trans_root = RB_ROOT;
> +
> +	st->group_id = group_id;
> +
> +	kref_init(&st->refcnt);
> +
> +	INIT_WORK(&st->io_work, pohmelfs_state_io_work);
> +
> +	st->cmd_read = 1;
> +
> +	err = sock_create_kern(addr->sa_family, SOCK_STREAM, IPPROTO_TCP, &st->sock);
> +	if (err) {
> +		pohmelfs_print_addr(sa, "sock_create: failed family: %d, err: %d\n", addr->sa_family, err);
> +		goto err_out_free;
> +	}
> +
> +	st->sock->sk->sk_allocation = GFP_NOIO;
> +	st->sock->sk->sk_sndtimeo = st->sock->sk->sk_rcvtimeo = msecs_to_jiffies(60000);
> +
> +	err = 1;
> +	sock_setsockopt(st->sock, SOL_SOCKET, SO_KEEPALIVE, (char *)&err, 4);
> +
> +	tcp_setsockopt(st->sock->sk, SOL_TCP, TCP_KEEPIDLE, (char *)&conn->psb->keepalive_idle, 4);
> +	tcp_setsockopt(st->sock->sk, SOL_TCP, TCP_KEEPINTVL, (char *)&conn->psb->keepalive_interval, 4);
> +	tcp_setsockopt(st->sock->sk, SOL_TCP, TCP_KEEPCNT, (char *)&conn->psb->keepalive_cnt, 4);
> +
> +	err = kernel_connect(st->sock, (struct sockaddr *)addr, addrlen, 0);
> +	if (err) {
> +		pohmelfs_print_addr(sa, "kernel_connect: failed family: %d, err: %d\n", addr->sa_family, err);
> +		goto err_out_release;
> +	}
> +	st->sock->sk->sk_sndtimeo = st->sock->sk->sk_rcvtimeo = msecs_to_jiffies(60000);
> +
> +	memcpy(&st->sa, sa, sizeof(struct sockaddr_storage));
> +	st->addrlen = addrlen;
> +
> +	err = pohmelfs_poll_init(st);
> +	if (err)
> +		goto err_out_shutdown;
> +
> +
> +	spin_lock(&conn->state_lock);
> +	err = -EEXIST;
> +	if (!pohmelfs_addr_exist(conn, sa, addrlen)) {
> +		list_add_tail(&st->state_entry, &conn->state_list);
> +		err = 0;
> +	}
> +	spin_unlock(&conn->state_lock);
> +
> +	if (err)
> +		goto err_out_poll_exit;
> +
> +	if (ask_route) {
> +		err = pohmelfs_route_request(st);
> +		if (err)
> +			goto err_out_poll_exit;
> +	}
> +
> +	pohmelfs_print_addr(sa, "%d: connected\n", st->conn->idx);
> +
> +	return st;
> +
> +err_out_poll_exit:
> +	pohmelfs_poll_exit(st);
> +err_out_shutdown:
> +	st->sock->ops->shutdown(st->sock, 2);
> +err_out_release:
> +	sock_release(st->sock);
> +err_out_free:
> +	kfree(st);
> +err_out_exit:
> +	if (err != -EEXIST) {
> +		pohmelfs_print_addr(sa, "state creation failed: %d\n", err);
> +	}
> +	return ERR_PTR(err);
> +}
> +
> +static void pohmelfs_state_exit(struct pohmelfs_state *st)
> +{
> +	if (!st->sock)
> +		return;
> +
> +	pohmelfs_poll_exit(st);
> +	st->sock->ops->shutdown(st->sock, 2);
> +
> +	pohmelfs_print_addr(&st->sa, "disconnected\n");
> +	sock_release(st->sock);
> +}
> +
> +static void pohmelfs_state_release(struct kref *kref)
> +{
> +	struct pohmelfs_state *st = container_of(kref, struct pohmelfs_state, refcnt);
> +	pohmelfs_state_exit(st);
> +}
> +
> +void pohmelfs_state_put(struct pohmelfs_state *st)
> +{
> +	kref_put(&st->refcnt, pohmelfs_state_release);
> +}
> +
> +static void pohmelfs_state_clean(struct pohmelfs_state *st)
> +{
> +	struct pohmelfs_trans *t, *tmp;
> +
> +	pohmelfs_route_remove_all(st);
> +
> +	mutex_lock(&st->trans_lock);
> +	list_for_each_entry_safe(t, tmp, &st->trans_list, trans_entry) {
> +		list_del(&t->trans_entry);
> +
> +		pohmelfs_trans_put(t);
> +	}
> +
> +	while (1) {
> +		struct rb_node *n = rb_first(&st->trans_root);
> +		if (!n)
> +			break;
> +
> +		t = rb_entry(n, struct pohmelfs_trans, trans_node);
> +
> +		rb_erase(&t->trans_node, &st->trans_root);
> +		pohmelfs_trans_put(t);
> +	}
> +	mutex_unlock(&st->trans_lock);
> +
> +	cancel_work_sync(&st->io_work);
> +}
> +
> +void pohmelfs_state_kill(struct pohmelfs_state *st)
> +{
> +	BUG_ON(!list_empty(&st->state_entry));
> +
> +	pohmelfs_state_clean(st);
> +	pohmelfs_state_put(st);
> +}
> +
> +void pohmelfs_state_schedule(struct pohmelfs_state *st)
> +{
> +	if (!st->conn->need_exit)
> +		queue_work(st->conn->wq, &st->io_work);
> +}
> +
> +int pohmelfs_state_add_reconnect(struct pohmelfs_state *st)
> +{
> +	struct pohmelfs_connection *conn = st->conn;
> +	struct pohmelfs_reconnect *r, *tmp;
> +	int err = 0;
> +
> +	pohmelfs_route_remove_all(st);
> +
> +	r = kzalloc(sizeof(struct pohmelfs_reconnect), GFP_NOIO);
> +	if (!r) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	memcpy(&r->sa, &st->sa, sizeof(struct sockaddr_storage));
> +	r->addrlen = st->addrlen;
> +	r->group_id = st->group_id;
> +
> +	mutex_lock(&conn->reconnect_lock);
> +	list_for_each_entry(tmp, &conn->reconnect_list, reconnect_entry) {
> +		if (tmp->addrlen != r->addrlen)
> +			continue;
> +
> +		if (memcmp(&tmp->sa, &r->sa, r->addrlen))
> +			continue;
> +
> +		err = -EEXIST;
> +		break;
> +	}
> +
> +	if (!err) {
> +		list_add_tail(&r->reconnect_entry, &conn->reconnect_list);
> +	}
> +	mutex_unlock(&conn->reconnect_lock);
> +
> +	if (err)
> +		goto err_out_free;
> +
> +	pohmelfs_print_addr(&st->sa, "reconnection added\n");
> +	err = 0;
> +	goto err_out_exit;
> +
> +err_out_free:
> +	kfree(r);
> +err_out_exit:
> +
> +	spin_lock(&conn->state_lock);
> +	list_move(&st->state_entry, &conn->kill_state_list);
> +	spin_unlock(&conn->state_lock);
> +
> +	/* we do not really care if this work will not be processed immediately */
> +	queue_delayed_work(conn->wq, &conn->reconnect_work, 0);
> +
> +	return err;
> +}
> diff --git a/fs/pohmelfs/packet.h b/fs/pohmelfs/packet.h
> new file mode 100644
> index 0000000..f432987
> --- /dev/null
> +++ b/fs/pohmelfs/packet.h
> @@ -0,0 +1,752 @@
> +/*
> + * 2008+ Copyright (c) Evgeniy Polyakov <zbr@ioremap.net>
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __DNET_PACKET_H
> +#define __DNET_PACKET_H
> +
> +#ifndef __KERNEL__
> +#include <sys/time.h>
> +#include <arpa/inet.h>
> +#include <sys/stat.h>
> +
> +#include <string.h>
> +#include <stdint.h>
> +
> +#include <elliptics/typedefs.h>
> +#include <elliptics/core.h>
> +#endif
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +enum dnet_commands {
> +	DNET_CMD_LOOKUP = 1,			/* Lookup address by ID and per-object info: size, permissions and so on*/
> +	DNET_CMD_REVERSE_LOOKUP,		/* Lookup ID by address */
> +	DNET_CMD_JOIN,				/* Join the network - force remote nodes to update
> +						 * their route tables to include given node with given
> +						 * address
> +						 */
> +	DNET_CMD_WRITE,
> +	DNET_CMD_READ,				/* IO commands. They have to follow by the
> +						 * IO attribute which will have offset and size
> +						 * parameters.
> +						 */
> +	DNET_CMD_LIST,				/* List all objects for given node ID */
> +	DNET_CMD_EXEC,				/* Execute given command on the remote node */
> +	DNET_CMD_ROUTE_LIST,			/* Receive route table from given node */
> +	DNET_CMD_STAT,				/* Gather remote VM, LA and FS statistics */
> +	DNET_CMD_NOTIFY,			/* Notify when object in question was modified */
> +	DNET_CMD_DEL,				/* Remove given object from the storage */
> +	DNET_CMD_STAT_COUNT,			/* Gather remote per-cmd statistics */
> +	DNET_CMD_STATUS,			/* Change elliptics node status */
> +	DNET_CMD_READ_RANGE,			/* Read range of objects */
> +	DNET_CMD_DEL_RANGE,			/* Remove range of objects */
> +	DNET_CMD_AUTH,				/* Authentification cookie check */
> +	DNET_CMD_BULK_READ,			/* Read a number of ids at one time */
> +
> +	DNET_CMD_UNKNOWN,			/* This slot is allocated for statistics gathered for unknown commands */
> +	__DNET_CMD_MAX,
> +};
> +
> +enum dnet_counters {
> +	DNET_CNTR_LA1 = __DNET_CMD_MAX*2,	/* Load average for 1 min */
> +	DNET_CNTR_LA5,				/* Load average for 5 min */
> +	DNET_CNTR_LA15,				/* Load average for 15 min */
> +	DNET_CNTR_BSIZE,			/* Block size */
> +	DNET_CNTR_FRSIZE,			/* Fragment size */
> +	DNET_CNTR_BLOCKS,			/* Filesystem size in frsize units */
> +	DNET_CNTR_BFREE,			/* # free blocks */
> +	DNET_CNTR_BAVAIL,			/* # free blocks for non-root */
> +	DNET_CNTR_FILES,			/* # inodes */
> +	DNET_CNTR_FFREE,			/* # free inodes */
> +	DNET_CNTR_FAVAIL,			/* # free inodes for non-root */
> +	DNET_CNTR_FSID,				/* File system ID */
> +	DNET_CNTR_VM_ACTIVE,			/* Active memory */
> +	DNET_CNTR_VM_INACTIVE,			/* Inactive memory */
> +	DNET_CNTR_VM_TOTAL,			/* Total memory */
> +	DNET_CNTR_VM_FREE,			/* Free memory */
> +	DNET_CNTR_VM_CACHED,			/* Used for cache */
> +	DNET_CNTR_VM_BUFFERS,			/* Used for buffers */
> +	DNET_CNTR_NODE_FILES,			/* # files in meta */
> +	DNET_CNTR_NODE_LAST_MERGE,		/* Result of the last merge */
> +	DNET_CNTR_NODE_CHECK_COPY,		/* Result of the last check copies */
> +	DNET_CNTR_DBR_NOREC,			/* Kyoto Cabinet DB read error KCENOREC */
> +	DNET_CNTR_DBR_SYSTEM,			/* Kyoto Cabinet DB read error KCESYSTEM */
> +	DNET_CNTR_DBR_ERROR,			/* Kyoto Cabinet DB read error */
> +	DNET_CNTR_DBW_SYSTEM,			/* Kyoto Cabinet DB write error KCESYSTEM */
> +	DNET_CNTR_DBW_ERROR,			/* Kyoto Cabinet DB write error */
> +	DNET_CNTR_UNKNOWN,			/* This slot is allocated for statistics gathered for unknown counters */
> +	__DNET_CNTR_MAX,
> +};
> +
> +/*
> + * Transaction ID direction bit.
> + * When set, data is a reply for the given transaction.
> + */
> +#define DNET_TRANS_REPLY		0x8000000000000000ULL
> +
> +/*
> + * Command flags.
> + */
> +
> +/*
> + * When set, node will generate a reply when transaction
> + * is completed and put completion status into cmd.status
> + * field.
> + */
> +#define DNET_FLAGS_NEED_ACK		(1<<0)
> +
> +/* There will be more commands with the same parameters (transaction number and id) */
> +#define DNET_FLAGS_MORE			(1<<1)
> +
> +/* Transaction is about to be destroyed */
> +#define DNET_FLAGS_DESTROY		(1<<2)
> +
> +/* Do not forward requst to antoher node even if given ID does not belong to our range */
> +#define DNET_FLAGS_DIRECT		(1<<3)
> +
> +/* Do not locks operations - must be set for script callers or recursive operations */
> +#define DNET_FLAGS_NOLOCK		(1<<4)
> +
> +struct dnet_id {
> +	uint8_t			id[DNET_ID_SIZE];
> +	uint32_t		group_id;
> +	int			type;
> +} __attribute__ ((packed));
> +
> +struct dnet_raw_id {
> +	uint8_t			id[DNET_ID_SIZE];
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_raw_id(struct dnet_raw_id *id __attribute__ ((unused)))
> +{
> +}
> +
> +static inline void dnet_setup_id(struct dnet_id *id, unsigned int group_id, unsigned char *raw)
> +{
> +	memcpy(id->id, raw, DNET_ID_SIZE);
> +	id->group_id = group_id;
> +}
> +
> +struct dnet_cmd
> +{
> +	struct dnet_id		id;
> +	uint32_t		flags;
> +	int			status;
> +	uint64_t		trans;
> +	uint64_t		size;
> +	uint8_t			data[0];
> +} __attribute__ ((packed));
> +
> +/* kernel (pohmelfs) provides own defines for byteorder changes */
> +#ifndef __KERNEL__
> +#ifdef WORDS_BIGENDIAN
> +
> +#define dnet_bswap16(x)		((((x) >> 8) & 0xff) | (((x) & 0xff) << 8))
> +
> +#define dnet_bswap32(x) \
> +     ((((x) & 0xff000000) >> 24) | (((x) & 0x00ff0000) >>  8) |		      \
> +      (((x) & 0x0000ff00) <<  8) | (((x) & 0x000000ff) << 24))
> +
> +#define dnet_bswap64(x) \
> +     ((((x) & 0xff00000000000000ull) >> 56)				      \
> +      | (((x) & 0x00ff000000000000ull) >> 40)				      \
> +      | (((x) & 0x0000ff0000000000ull) >> 24)				      \
> +      | (((x) & 0x000000ff00000000ull) >> 8)				      \
> +      | (((x) & 0x00000000ff000000ull) << 8)				      \
> +      | (((x) & 0x0000000000ff0000ull) << 24)				      \
> +      | (((x) & 0x000000000000ff00ull) << 40)				      \
> +      | (((x) & 0x00000000000000ffull) << 56))
> +#else
> +#define dnet_bswap16(x) (x)
> +#define dnet_bswap32(x) (x)
> +#define dnet_bswap64(x) (x)
> +#endif
> +#endif
> +
> +static inline void dnet_convert_id(struct dnet_id *id)
> +{
> +	id->group_id = dnet_bswap32(id->group_id);
> +	id->type = dnet_bswap32(id->type);
> +}
> +
> +static inline void dnet_convert_cmd(struct dnet_cmd *cmd)
> +{
> +	dnet_convert_id(&cmd->id);
> +	cmd->flags = dnet_bswap32(cmd->flags);
> +	cmd->status = dnet_bswap32(cmd->status);
> +	cmd->size = dnet_bswap64(cmd->size);
> +	cmd->trans = dnet_bswap64(cmd->trans);
> +}
> +
> +/* Completely remove object history and metadata */
> +#define DNET_ATTR_DELETE_HISTORY		(1<<0)
> +
> +/* What type of counters to fetch */
> +#define DNET_ATTR_CNTR_GLOBAL			(1<<0)
> +
> +/* Bulk request for checking files */
> +#define DNET_ATTR_BULK_CHECK			(1<<0)
> +
> +/* Fill ctime/mtime from metadata when processing DNET_CMD_LOOKUP */
> +#define DNET_ATTR_META_TIMES			(1<<1)
> +
> +/* Do not verify checksum */
> +#define DNET_ATTR_NOCSUM			(1<<2)
> +
> +/*
> + * ascending sort data before returning range request to user
> + * c++ bindings only
> + */
> +#define DNET_ATTR_SORT				(1<<3)
> +
> +/*
> + * This flag will force its parent CMD not to lock operation
> + * Flag will be propagated to cmd->flags
> + */
> +#define DNET_ATTR_NOLOCK			(1<<4)
> +
> +struct dnet_attr
> +{
> +	uint64_t		size;
> +	uint32_t		cmd;
> +	uint32_t		flags;
> +	uint32_t		unused[2];
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_attr(struct dnet_attr *a)
> +{
> +	a->size = dnet_bswap64(a->size);
> +	a->cmd = dnet_bswap32(a->cmd);
> +	a->flags = dnet_bswap32(a->flags);
> +}
> +
> +#define DNET_ADDR_SIZE		28
> +
> +struct dnet_addr
> +{
> +	uint8_t			addr[DNET_ADDR_SIZE];
> +	uint32_t		addr_len;
> +} __attribute__ ((packed));
> +
> +struct dnet_list
> +{
> +	struct dnet_id		id;
> +	uint32_t		size;
> +	uint8_t			data[0];
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_list(struct dnet_list *l)
> +{
> +	dnet_convert_id(&l->id);
> +	l->size = dnet_bswap32(l->size);
> +}
> +
> +struct dnet_addr_attr
> +{
> +	uint16_t		sock_type;
> +	uint16_t		family;
> +	uint32_t		proto;
> +	struct dnet_addr	addr;
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_addr_attr(struct dnet_addr_attr *a)
> +{
> +	a->addr.addr_len = dnet_bswap32(a->addr.addr_len);
> +	a->proto = dnet_bswap32(a->proto);
> +	a->sock_type = dnet_bswap16(a->sock_type);
> +	a->family = dnet_bswap16(a->family);
> +}
> +
> +struct dnet_addr_cmd
> +{
> +	struct dnet_cmd		cmd;
> +	struct dnet_attr	a;
> +	struct dnet_addr_attr	addr;
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_addr_cmd(struct dnet_addr_cmd *l)
> +{
> +	dnet_convert_cmd(&l->cmd);
> +	dnet_convert_attr(&l->a);
> +	dnet_convert_addr_attr(&l->addr);
> +}
> +
> +/* Do not update history for given transaction */
> +#define DNET_IO_FLAGS_SKIP_SENDING	(1<<0)
> +
> +/* Append given data at the end of the object */
> +#define DNET_IO_FLAGS_APPEND		(1<<1)
> +
> +#define DNET_IO_FLAGS_COMPRESS		(1<<2)
> +
> +/* Metada IO request */
> +#define DNET_IO_FLAGS_META		(1<<3)
> +
> +/* eblob prepare/commit phase */
> +#define DNET_IO_FLAGS_PREPARE		(1<<4)
> +#define DNET_IO_FLAGS_COMMIT		(1<<5)
> +
> +/* Object was removed */
> +#define DNET_IO_FLAGS_REMOVED		(1<<6)
> +
> +/* Overwrite data */
> +#define DNET_IO_FLAGS_OVERWRITE		(1<<7)
> +
> +/* Do not checksum data */
> +#define DNET_IO_FLAGS_NOCSUM		(1<<8)
> +
> +/*
> + * this flag is used when we want backend not to perform any additional actions
> + * except than write data at given offset. This is no-op in filesystem backend,
> + * but eblob one should disable prepare/commit operations.
> + */
> +#define DNET_IO_FLAGS_PLAIN_WRITE	(1<<9)
> +
> +/* Do not really send data in range request.
> + * Send only statistics instead.
> + *
> + * -- we do not care if it matches above DNET_IO_FLAGS_PLAIN_WRITE,
> + *  since using plain write and nodata (read) is useless anyway
> + */
> +#define DNET_IO_FLAGS_NODATA		(1<<9)
> +
> +struct dnet_io_attr
> +{
> +	uint8_t			parent[DNET_ID_SIZE];
> +	uint8_t			id[DNET_ID_SIZE];
> +
> +	/*
> +	 * used in range request as start and number for LIMIT(start, num) 
> +	 *
> +	 * write prepare request uses @num is used as a placeholder
> +	 * for number of bytes to reserve on disk
> +	 */
> +	uint64_t		start, num;
> +	int			type;
> +	uint32_t		flags;
> +	uint64_t		offset;
> +	uint64_t		size;
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_io_attr(struct dnet_io_attr *a)
> +{
> +	a->start = dnet_bswap64(a->start);
> +	a->num = dnet_bswap64(a->num);
> +
> +	a->flags = dnet_bswap32(a->flags);
> +	a->offset = dnet_bswap64(a->offset);
> +	a->size = dnet_bswap64(a->size);
> +}
> +
> +struct dnet_history_entry
> +{
> +	uint8_t			id[DNET_ID_SIZE];
> +	uint32_t		flags;
> +	uint64_t		reserved;
> +	uint64_t		tsec, tnsec;
> +	uint64_t		offset;
> +	uint64_t		size;
> +} __attribute__ ((packed));
> +
> +/*
> + * Helper structure and set of functions to map history file and perform basic checks.
> + */
> +struct dnet_history_map
> +{
> +	struct dnet_history_entry	*ent;
> +	long				num;
> +	ssize_t				size;
> +	int				fd;
> +};
> +
> +static inline void dnet_convert_history_entry(struct dnet_history_entry *a)
> +{
> +	a->flags = dnet_bswap32(a->flags);
> +	a->offset = dnet_bswap64(a->offset);
> +	a->size = dnet_bswap64(a->size);
> +	a->tsec = dnet_bswap64(a->tsec);
> +	a->tnsec = dnet_bswap64(a->tnsec);
> +}
> +
> +static inline void dnet_setup_history_entry(struct dnet_history_entry *e,
> +		unsigned char *id, uint64_t size, uint64_t offset,
> +		struct timespec *ts, uint32_t flags)
> +{
> +	if (!ts) {
> +		struct timeval tv;
> +
> +		gettimeofday(&tv, NULL);
> +
> +		e->tsec = tv.tv_sec;
> +		e->tnsec = tv.tv_usec * 1000;
> +	} else {
> +		e->tsec = ts->tv_sec;
> +		e->tnsec = ts->tv_nsec;
> +	}
> +
> +	memcpy(e->id, id, DNET_ID_SIZE);
> +
> +	e->size = size;
> +	e->offset = offset;
> +	e->flags = flags;
> +	e->reserved = 0;
> +
> +	dnet_convert_history_entry(e);
> +}
> +
> +struct dnet_stat
> +{
> +	/* Load average from the target system multiplied by 100 */
> +	uint16_t		la[3];
> +
> +	uint16_t		namemax;	/* maximum filename length */
> +
> +	uint64_t		bsize;		/* Block size */
> +	uint64_t		frsize;		/* Fragment size */
> +	uint64_t		blocks;		/* Filesystem size in frsize units */
> +	uint64_t		bfree;		/* # free blocks */
> +	uint64_t		bavail;		/* # free blocks for non-root */
> +	uint64_t		files;		/* # inodes */
> +	uint64_t		ffree;		/* # free inodes */
> +	uint64_t		favail;		/* # free inodes for non-root */
> +	uint64_t		fsid;		/* file system ID */
> +	uint64_t		flag;		/* mount flags */
> +
> +	/*
> +	 * VM counters in KB (1024) units.
> +	 * On FreeBSD vm_buffers is used for wire counter.
> +	 */
> +	uint64_t		vm_active;
> +	uint64_t		vm_inactive;
> +	uint64_t		vm_total;
> +	uint64_t		vm_free;
> +	uint64_t		vm_cached;
> +	uint64_t		vm_buffers;
> +
> +	/*
> +	 * Per node IO statistics will live here.
> +	 * Reserved for future use.
> +	 */
> +	uint64_t		reserved[32];
> +};
> +
> +static inline void dnet_convert_stat(struct dnet_stat *st)
> +{
> +	int i;
> +
> +	for (i=0; i<3; ++i)
> +		st->la[i] = dnet_bswap16(st->la[i]);
> +
> +	st->bsize = dnet_bswap64(st->bsize);
> +	st->frsize = dnet_bswap64(st->frsize);
> +	st->blocks = dnet_bswap64(st->blocks);
> +	st->bfree = dnet_bswap64(st->bfree);
> +	st->bavail = dnet_bswap64(st->bavail);
> +	st->files = dnet_bswap64(st->files);
> +	st->ffree = dnet_bswap64(st->ffree);
> +	st->favail = dnet_bswap64(st->favail);
> +	st->fsid = dnet_bswap64(st->fsid);
> +	st->namemax = dnet_bswap16(st->namemax);
> +
> +	st->vm_active = dnet_bswap64(st->vm_active);
> +	st->vm_inactive = dnet_bswap64(st->vm_inactive);
> +	st->vm_total = dnet_bswap64(st->vm_total);
> +	st->vm_free = dnet_bswap64(st->vm_free);
> +	st->vm_buffers = dnet_bswap64(st->vm_buffers);
> +	st->vm_cached = dnet_bswap64(st->vm_cached);
> +}
> +
> +struct dnet_io_notification
> +{
> +	struct dnet_addr_attr		addr;
> +	struct dnet_io_attr		io;
> +};
> +
> +static inline void dnet_convert_io_notification(struct dnet_io_notification *n)
> +{
> +	dnet_convert_addr_attr(&n->addr);
> +	dnet_convert_io_attr(&n->io);
> +}
> +
> +struct dnet_stat_count
> +{
> +	uint64_t			count;
> +	uint64_t			err;
> +};
> +
> +static inline void dnet_convert_stat_count(struct dnet_stat_count *st, int num)
> +{
> +	int i;
> +
> +	for (i=0; i<num; ++i) {
> +		st[i].count = dnet_bswap64(st[i].count);
> +		st[i].err = dnet_bswap64(st[i].err);
> +	}
> +}
> +
> +struct dnet_addr_stat
> +{
> +	struct dnet_addr		addr;
> +	int				num;
> +	int				cmd_num;
> +	struct dnet_stat_count		count[0];
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_addr_stat(struct dnet_addr_stat *st, int num)
> +{
> +	st->addr.addr_len = dnet_bswap32(st->addr.addr_len);
> +	st->num = dnet_bswap32(st->num);
> +	if (!num)
> +		num = st->num;
> +	st->cmd_num = dnet_bswap32(st->cmd_num);
> +
> +	dnet_convert_stat_count(st->count, num);
> +}
> +
> +static inline void dnet_stat_inc(struct dnet_stat_count *st, int cmd, int err)
> +{
> +	if (cmd >= __DNET_CMD_MAX)
> +		cmd = DNET_CMD_UNKNOWN;
> +
> +	if (!err)
> +		st[cmd].count++;
> +	else
> +		st[cmd].err++;
> +}
> +
> +struct dnet_time {
> +	uint64_t		tsec, tnsec;
> +};
> +
> +static inline void dnet_convert_time(struct dnet_time *tm)
> +{
> +	tm->tsec = dnet_bswap64(tm->tsec);
> +	tm->tnsec = dnet_bswap64(tm->tnsec);
> +}
> +
> +static inline void dnet_current_time(struct dnet_time *t)
> +{
> +	struct timeval tv;
> +
> +	gettimeofday(&tv, NULL);
> +
> +	t->tsec = tv.tv_sec;
> +	t->tnsec = tv.tv_usec * 1000;
> +}
> +
> +struct dnet_file_info {
> +	int			flen;		/* filename length, which goes after this structure */
> +	unsigned char		checksum[DNET_CSUM_SIZE];
> +
> +	unsigned int		nlink;
> +
> +	uint64_t		mode;
> +
> +	uint64_t		dev;
> +	uint64_t		rdev;
> +
> +	uint64_t		ino;
> +
> +	uint64_t		uid;
> +	uint64_t		gid;
> +
> +	uint64_t		blksize;
> +	uint64_t		blocks;
> +
> +	uint64_t		size;
> +	uint64_t		offset;		/* offset within eblob */
> +
> +	struct dnet_time	atime;
> +	struct dnet_time	ctime;
> +	struct dnet_time	mtime;
> +};
> +
> +static inline void dnet_convert_file_info(struct dnet_file_info *info)
> +{
> +	info->flen = dnet_bswap32(info->flen);
> +	info->nlink = dnet_bswap32(info->nlink);
> +
> +	info->mode = dnet_bswap64(info->mode);
> +	info->dev = dnet_bswap64(info->dev);
> +	info->ino = dnet_bswap64(info->ino);
> +	info->uid = dnet_bswap64(info->uid);
> +	info->gid = dnet_bswap64(info->gid);
> +	info->blksize = dnet_bswap64(info->blksize);
> +	info->blocks = dnet_bswap64(info->blocks);
> +	info->rdev = dnet_bswap64(info->rdev);
> +	info->size = dnet_bswap64(info->size);
> +	info->offset = dnet_bswap64(info->offset);
> +
> +	dnet_convert_time(&info->atime);
> +	dnet_convert_time(&info->ctime);
> +	dnet_convert_time(&info->mtime);
> +}
> +
> +static inline void dnet_info_from_stat(struct dnet_file_info *info, struct stat *st)
> +{
> +	info->nlink = st->st_nlink;
> +	info->mode = st->st_mode;
> +	info->dev = st->st_dev;
> +	info->ino = st->st_ino;
> +	info->uid = st->st_uid;
> +	info->gid = st->st_gid;
> +	info->blksize = st->st_blksize;
> +	info->blocks = st->st_blocks;
> +	info->rdev = st->st_rdev;
> +	info->size = st->st_size;
> +	info->offset = 0;
> +
> +	info->atime.tsec = st->st_atime;
> +	info->ctime.tsec = st->st_ctime;
> +	info->mtime.tsec = st->st_mtime;
> +
> +	info->atime.tnsec = 0;
> +	info->ctime.tnsec = 0;
> +	info->mtime.tnsec = 0;
> +}
> +
> +/* Elliptics node status - if set, status will be changed */
> +#define DNET_ATTR_STATUS_CHANGE		(1<<0)
> +
> +/* Elliptics node should exit */
> +#define DNET_STATUS_EXIT		(1<<0)
> +
> +/* Ellipitcs node goes ro/rw */
> +#define DNET_STATUS_RO			(1<<1)
> +
> +struct dnet_node_status {
> +	int nflags;
> +	int status_flags;  /* DNET_STATUS_EXIT, DNET_STATUS_RO should be specified here */
> +	uint32_t log_mask;
> +};
> +
> +static inline void dnet_convert_node_status(struct dnet_node_status *st)
> +{
> +	st->nflags = dnet_bswap32(st->nflags);
> +	st->status_flags = dnet_bswap32(st->status_flags);
> +	st->log_mask = dnet_bswap32(st->log_mask);
> +}
> +
> +enum cmd_type {
> +	DNET_EXEC_SHELL = 0,
> +	DNET_EXEC_PYTHON_SCRIPT_NAME,
> +	DNET_EXEC_PYTHON,
> +};
> +
> +struct dnet_exec {
> +	int			type;
> +	int			flags;
> +	uint64_t		script_size, name_size, binary_size;
> +	uint64_t		reserved[2];
> +
> +	/*
> +	 * we pack script name first, then user's script content and then binary data,
> +	 * which will be pushed into server's object
> +	 */
> +	char			data[0];
> +} __attribute__((packed));
> +
> +static inline void dnet_convert_exec(struct dnet_exec *e)
> +{
> +	e->type = dnet_bswap32(e->type);
> +	e->script_size = dnet_bswap64(e->script_size);
> +	e->name_size = dnet_bswap64(e->name_size);
> +	e->binary_size = dnet_bswap64(e->binary_size);
> +	e->flags = dnet_bswap32(e->flags);
> +}
> +
> +#define DNET_AUTH_COOKIE_SIZE	32
> +
> +struct dnet_auth {
> +	char			cookie[DNET_AUTH_COOKIE_SIZE];
> +	uint64_t		flags;
> +	uint64_t		unused[3];
> +};
> +
> +static inline void dnet_convert_auth(struct dnet_auth *a)
> +{
> +	a->flags = dnet_bswap64(a->flags);
> +}
> +
> +enum dnet_meta_types {
> +	DNET_META_PARENT_OBJECT = 1,	/* parent object name */
> +	DNET_META_GROUPS,		/* this object has copies in given groups */
> +	DNET_META_CHECK_STATUS,		/* last checking status: timestamp and so on */
> +	DNET_META_NAMESPACE,		/* namespace where given object lives */
> +	DNET_META_UPDATE,		/* last update information (timestamp, flags) */
> +	DNET_META_CHECKSUM,		/* checksum (sha512) of the whole data object calculated on server */
> +	__DNET_META_MAX,
> +};
> +
> +struct dnet_meta
> +{
> +	uint32_t			type;
> +	uint32_t			size;
> +	uint64_t			common;
> +	uint8_t				tmp[16];
> +	uint8_t				data[0];
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_meta(struct dnet_meta *m)
> +{
> +	m->type = dnet_bswap32(m->type);
> +	m->size = dnet_bswap32(m->size);
> +	m->common = dnet_bswap64(m->common);
> +}
> +
> +struct dnet_meta_update {
> +	int			unused_gap;
> +	int			group_id;
> +	uint64_t		flags;
> +	struct dnet_time	tm;
> +	uint64_t		reserved[4];
> +} __attribute__((packed));
> +
> +static inline void dnet_convert_meta_update(struct dnet_meta_update *m)
> +{
> +	dnet_convert_time(&m->tm);
> +	m->flags = dnet_bswap64(m->flags);
> +}
> +
> +struct dnet_meta_check_status {
> +	int			status;
> +	int			pad;
> +	struct dnet_time	tm;
> +	uint64_t		reserved[4];
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_meta_check_status(struct dnet_meta_check_status *c)
> +{
> +	c->status = dnet_bswap32(c->status);
> +	dnet_convert_time(&c->tm);
> +}
> +
> +struct dnet_meta_checksum {
> +	uint8_t			checksum[DNET_CSUM_SIZE];
> +	struct dnet_time	tm;
> +} __attribute__ ((packed));
> +
> +static inline void dnet_convert_meta_checksum(struct dnet_meta_checksum *c)
> +{
> +	dnet_convert_time(&c->tm);
> +}
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif /* __DNET_PACKET_H */
> diff --git a/fs/pohmelfs/pohmelfs.h b/fs/pohmelfs/pohmelfs.h
> new file mode 100644
> index 0000000..3b30a59
> --- /dev/null
> +++ b/fs/pohmelfs/pohmelfs.h
> @@ -0,0 +1,503 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#ifndef __POHMELFS_H
> +#define __POHMELFS_H
> +
> +#include <linux/backing-dev.h>
> +#include <linux/crypto.h>
> +#include <linux/fs.h>
> +#include <linux/kref.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/net.h>
> +#include <linux/pagemap.h>
> +#include <linux/pagevec.h>
> +#include <linux/printk.h>
> +#include <linux/slab.h>
> +#include <linux/time.h>
> +#include <linux/wait.h>
> +#include <linux/workqueue.h>
> +
> +#include <crypto/sha.h>
> +
> +#define dnet_bswap16(x)		cpu_to_le16(x)
> +#define dnet_bswap32(x)		cpu_to_le32(x)
> +#define dnet_bswap64(x)		cpu_to_le64(x)
> +
> +/* theese are needed for packet.h below to compile */
> +#define DNET_ID_SIZE	SHA512_DIGEST_SIZE
> +#define DNET_CSUM_SIZE	SHA512_DIGEST_SIZE
> +
> +#define POHMELFS_INODE_COLUMN		3
> +
> +/*
> + * is not used in kernel, but we want to share the same header
> + * with userspace, so I put it here for compiler to shut up
> + */
> +int gettimeofday(struct timeval *, struct timezone *);
> +
> +#include "packet.h"
> +
> +static inline struct timespec pohmelfs_date(struct dnet_time *tm)
> +{
> +	struct timespec ts;
> +
> +	ts.tv_sec = tm->tsec;
> +	ts.tv_nsec = tm->tnsec;
> +
> +	return ts;
> +}
> +
> +struct pohmelfs_cmd {
> +	struct dnet_cmd		cmd;
> +	struct dnet_attr	attr;
> +	union {
> +		struct dnet_io_attr	io;
> +	} p;
> +};
> +
> +/*
> + * Compare two IDs.
> + * Returns  1 when id1 > id2
> + *         -1 when id1 < id2
> + *          0 when id1 = id2
> + */
> +static inline int dnet_id_cmp_str(const unsigned char *id1, const unsigned char *id2)
> +{
> +	unsigned int i = 0;
> +
> +	for (i*=sizeof(unsigned long); i<DNET_ID_SIZE; ++i) {
> +		if (id1[i] < id2[i])
> +			return -1;
> +		if (id1[i] > id2[i])
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +struct pohmelfs_state;
> +struct pohmelfs_sb;
> +struct pohmelfs_trans;
> +
> +struct pohmelfs_trans_cb {
> +	int				(* init)(struct pohmelfs_trans *t);
> +	int				(* complete)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
> +	int				(* recv_reply)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
> +	void				(* destroy)(struct pohmelfs_trans *t);
> +};
> +
> +struct pohmelfs_trans {
> +	struct list_head	trans_entry;
> +	struct rb_node		trans_node;
> +
> +	struct kref		refcnt;
> +
> +	unsigned long		trans;
> +
> +	struct inode		*inode;
> +
> +	struct pohmelfs_state	*st;
> +
> +	struct pohmelfs_cmd	cmd;
> +
> +	u64			header_size, data_size;
> +
> +	unsigned long long	io_offset;
> +
> +	void			*data;
> +	void			*recv_data;
> +
> +	struct pohmelfs_write_ctl	*wctl;
> +	void			*priv;
> +
> +	struct pohmelfs_trans_cb	cb;
> +};
> +
> +struct pohmelfs_trans *pohmelfs_trans_alloc(struct inode *inode);
> +struct pohmelfs_trans *pohmelfs_trans_alloc_io_buf(struct inode *inode, int group, int command,
> +		void *data, u64 offset, u64 size, int aflags, int ioflags, int type);
> +void pohmelfs_trans_put(struct pohmelfs_trans *t);
> +
> +int pohmelfs_trans_insert(struct pohmelfs_trans *t);
> +int pohmelfs_trans_insert_tree(struct pohmelfs_state *st, struct pohmelfs_trans *t);
> +void pohmelfs_trans_remove(struct pohmelfs_trans *t);
> +struct pohmelfs_trans *pohmelfs_trans_lookup(struct pohmelfs_state *st, struct dnet_cmd *cmd);
> +
> +struct pohmelfs_state {
> +	struct pohmelfs_connection	*conn;
> +	struct list_head	state_entry;
> +
> +	struct sockaddr_storage	sa;
> +	int			addrlen;
> +	struct socket		*sock;
> +
> +	int			group_id;
> +
> +	struct mutex		trans_lock;
> +	struct list_head	trans_list;
> +	struct rb_root		trans_root;
> +
> +	struct kref		refcnt;
> +
> +	int			routes;
> +
> +	/* Waiting/polling machinery */
> +	wait_queue_t		wait;
> +	wait_queue_head_t	*whead;
> +
> +	struct work_struct	io_work;
> +
> +	/* is set when dnet_cmd is being read, otherwise attached data */
> +	int			cmd_read;
> +	/* currently read command reply */
> +	struct dnet_cmd		cmd;
> +
> +	uint64_t		bsize;		/* Block size */
> +	uint64_t		frsize;		/* Fragment size */
> +	uint64_t		blocks;		/* Filesystem size in frsize units */
> +	uint64_t		bfree;		/* # free blocks */
> +	uint64_t		bavail;		/* # free blocks for non-root */
> +};
> +
> +struct pohmelfs_state *pohmelfs_state_create(struct pohmelfs_connection *conn, struct sockaddr_storage *sa, int addrlen,
> +		int ask_route, int group_id);
> +struct pohmelfs_state *pohmelfs_state_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id, int group, ssize_t size);
> +int pohmelfs_grab_states(struct pohmelfs_sb *psb, struct pohmelfs_state ***stp);
> +
> +static inline void pohmelfs_state_get(struct pohmelfs_state *st)
> +{
> +	kref_get(&st->refcnt);
> +}
> +
> +void pohmelfs_state_put(struct pohmelfs_state *st);
> +void pohmelfs_state_kill(struct pohmelfs_state *st);
> +
> +struct pohmelfs_state *pohmelfs_addr_exist(struct pohmelfs_connection *conn, struct sockaddr_storage *sa, int addrlen);
> +
> +void pohmelfs_state_schedule(struct pohmelfs_state *st);
> +
> +__attribute__ ((format (printf, 2, 3))) void pohmelfs_print_addr(struct sockaddr_storage *addr, const char *fmt, ...);
> +
> +#define POHMELFS_INODE_INFO_REMOVED		(1<<0)
> +
> +struct pohmelfs_inode_info {
> +	struct dnet_raw_id	id;
> +
> +	unsigned int		mode;
> +	unsigned int		nlink;
> +	unsigned int		uid;
> +	unsigned int		gid;
> +	unsigned int		blocksize;
> +	unsigned int		namelen;
> +	__u64			ino;
> +	__u64			blocks;
> +	__u64			rdev;
> +	__u64			size;
> +	__u64			version;
> +
> +	__u64			flags;
> +
> +	struct dnet_time	ctime;
> +	struct dnet_time	mtime;
> +	struct dnet_time	atime;
> +} __attribute__ ((packed));
> +
> +void pohmelfs_fill_inode_info(struct inode *inode, struct pohmelfs_inode_info *info);
> +void pohmelfs_fill_inode(struct inode *inode, struct pohmelfs_inode_info *info);
> +void pohmelfs_convert_inode_info(struct pohmelfs_inode_info *info);
> +
> +struct pohmelfs_inode {
> +	struct inode		vfs_inode;
> +	struct dnet_raw_id	id;
> +
> +	struct rb_node		node;
> +
> +	struct mutex		lock;
> +
> +	int			*groups;
> +	int			group_num;
> +
> +	time_t			update;
> +	int			local;
> +};
> +
> +int pohmelfs_send_dentry(struct pohmelfs_inode *pi, struct dnet_raw_id *id, const char *sname, int len, int sync);
> +struct pohmelfs_inode *pohmelfs_sb_inode_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id);
> +
> +struct pohmelfs_reconnect {
> +	struct list_head	reconnect_entry;
> +	struct sockaddr_storage	sa;
> +	int			addrlen;
> +	int			group_id;
> +};
> +
> +int pohmelfs_state_add_reconnect(struct pohmelfs_state *st);
> +
> +struct pohmelfs_path {
> +	struct mutex		lock;
> +	char			*data;
> +};
> +
> +int pohmelfs_http_compat_id(struct pohmelfs_inode *pi);
> +
> +struct pohmelfs_addr {
> +	struct list_head	addr_entry;
> +	struct sockaddr_storage	sa;
> +	int			addrlen;
> +};
> +
> +struct pohmelfs_connection {
> +	struct pohmelfs_sb	*psb;
> +
> +	int			idx;
> +
> +	struct rb_root		route_root;
> +	struct list_head	state_list;
> +	spinlock_t		state_lock;
> +
> +	struct mutex		reconnect_lock;
> +	struct list_head	reconnect_list;
> +	struct list_head	kill_state_list;
> +
> +	struct workqueue_struct	*wq;
> +
> +	int			need_exit;
> +	struct delayed_work	reconnect_work;
> +};
> +
> +void pohmelfs_pool_clean(struct pohmelfs_connection *conn, int conn_num);
> +int pohmelfs_pool_resize(struct pohmelfs_sb *psb, int num);
> +
> +struct pohmelfs_sb {
> +	struct super_block	*sb;
> +	struct backing_dev_info	bdi;
> +
> +	struct pohmelfs_inode	*root;
> +
> +	spinlock_t		inode_lock;
> +	struct rb_root		inode_root;
> +
> +	int			http_compat;
> +	struct pohmelfs_path	*path;
> +
> +	int			bdi_num;
> +
> +	struct pohmelfs_connection	*conn;
> +	int			conn_num;
> +	int			bulk_idx, bulk_num;
> +	int			meta_idx, meta_num;
> +	struct mutex		conn_lock;
> +
> +	/* protected by conn_lock */
> +	struct list_head	addr_list;
> +
> +	long			read_wait_timeout;
> +	long			write_wait_timeout;
> +	long			sync_timeout;
> +	long			reconnect_timeout;
> +
> +	int			need_exit;
> +	struct delayed_work	sync_work;
> +	struct workqueue_struct	*wq;
> +
> +	char			*fsid;
> +	int			fsid_len;
> +
> +	atomic_long_t		ino;
> +	atomic_long_t		trans;
> +
> +	struct crypto_hash	*hash;
> +
> +	int			*groups;
> +	int			group_num;
> +
> +	/*
> +	 * number of copies to be successfully written to mark write as successful
> +	 * if not set, half of groups plus one must be successfully written, i.e. plain write quorum
> +	 */
> +	int			successful_write_count;
> +	int			keepalive_cnt, keepalive_interval, keepalive_idle;
> +	int			readdir_allocation;
> +	int			sync_on_close;
> +	int			no_read_csum;
> +};
> +
> +static inline struct pohmelfs_sb *pohmelfs_sb(struct super_block *sb)
> +{
> +	return (struct pohmelfs_sb *)sb->s_fs_info;
> +}
> +
> +static inline struct pohmelfs_inode *pohmelfs_inode(struct inode *inode)
> +{
> +	return container_of(inode, struct pohmelfs_inode, vfs_inode);
> +}
> +
> +struct pohmelfs_wait {
> +	wait_queue_head_t	wq;
> +	struct pohmelfs_inode	*pi;
> +	void			*ret;
> +	atomic_long_t		count;
> +	int			condition;
> +	struct kref		refcnt;
> +};
> +
> +int pohmelfs_wait_init(struct pohmelfs_wait *wait, struct pohmelfs_inode *pi);
> +struct pohmelfs_wait *pohmelfs_wait_alloc(struct pohmelfs_inode *pi);
> +void pohmelfs_wait_put(struct pohmelfs_wait *wait);
> +static inline void pohmelfs_wait_get(struct pohmelfs_wait *wait)
> +{
> +	kref_get(&wait->refcnt);
> +}
> +
> +struct pohmelfs_inode_info_binary_package {
> +	struct pohmelfs_inode_info	info;
> +
> +	struct pohmelfs_wait		wait;
> +};
> +
> +struct pohmelfs_write_ctl {
> +	struct pagevec			pvec;
> +	struct pohmelfs_inode_info	*info;
> +
> +	struct kref			refcnt;
> +	atomic_t			good_writes;
> +};
> +
> +struct pohmelfs_dentry_disk {
> +	struct dnet_raw_id		id;
> +	uint64_t			ino;
> +	int				type;
> +	int				len;
> +	char				name[0];
> +} __attribute__((packed));
> +
> +struct pohmelfs_dentry {
> +	struct dnet_raw_id		parent_id;
> +	struct pohmelfs_dentry_disk	disk;
> +};
> +
> +extern struct kmem_cache *pohmelfs_inode_cache;
> +extern struct kmem_cache *pohmelfs_trans_cache;
> +extern struct kmem_cache *pohmelfs_inode_info_cache;
> +extern struct kmem_cache *pohmelfs_route_cache;
> +extern struct kmem_cache *pohmelfs_wait_cache;
> +extern struct kmem_cache *pohmelfs_io_cache;
> +extern struct kmem_cache *pohmelfs_inode_info_binary_package_cache;
> +extern struct kmem_cache *pohmelfs_write_cache;
> +extern struct kmem_cache *pohmelfs_dentry_cache;
> +
> +struct inode *pohmelfs_alloc_inode(struct super_block *sb);
> +void pohmelfs_destroy_inode(struct inode *);
> +
> +struct pohmelfs_inode *pohmelfs_existing_inode(struct pohmelfs_sb *psb, struct pohmelfs_inode_info *info);
> +struct pohmelfs_inode *pohmelfs_new_inode(struct pohmelfs_sb *psb, int mode);
> +int pohmelfs_hash(struct pohmelfs_sb *psb, const void *data, const size_t size, struct dnet_raw_id *id);
> +
> +char *pohmelfs_dump_id(const unsigned char *id);
> +char *pohmelfs_dump_id_len_raw(const unsigned char *id, unsigned int len, char *dst);
> +
> +int pohmelfs_write_command(struct pohmelfs_inode *pi, struct pohmelfs_write_ctl *ctl, loff_t offset, size_t len);
> +void pohmelfs_write_ctl_release(struct kref *kref);
> +int pohmelfs_metadata_inode(struct pohmelfs_inode *pi, int sync);
> +
> +extern const struct file_operations pohmelfs_dir_fops;
> +extern const struct inode_operations pohmelfs_dir_inode_operations;
> +
> +extern const struct file_operations pohmelfs_file_ops;
> +extern const struct inode_operations pohmelfs_file_inode_operations;
> +
> +extern const struct inode_operations pohmelfs_symlink_inode_operations;
> +extern const struct inode_operations pohmelfs_special_inode_operations;
> +
> +extern void *pohmelfs_scratch_buf;
> +extern int pohmelfs_scratch_buf_size;
> +
> +/*
> + * if this flag is set, pohmelfs_inode_info->data is owned by the caller,
> + * so sending path may use it on its own and free (using kfree) when it's done
> + *
> + * This logic does not work for shared buffers or
> + * when multiple transactions will be sent for single pohmelfs_inode_info
> + */
> +#define POHMELFS_IO_OWN			(1<<0)
> +
> +struct pohmelfs_io {
> +	struct pohmelfs_inode		*pi;
> +
> +	struct dnet_raw_id		*id;
> +
> +	int				cmd;
> +	int				type;
> +
> +	u64				offset, size;
> +	u64				start, num;
> +
> +	u32				cflags;
> +	u32				aflags;
> +	u32				ioflags;
> +
> +	int				group_id;
> +
> +	u32				alloc_flags;
> +	void				*data;
> +
> +	struct pohmelfs_write_ctl	*wctl;
> +	void				*priv;
> +
> +	struct pohmelfs_trans_cb	cb;
> +};
> +
> +int pohmelfs_send_io_group(struct pohmelfs_io *pio, int group_id);
> +int pohmelfs_send_io(struct pohmelfs_io *pio);
> +int pohmelfs_send_buf_single(struct pohmelfs_io *pio, struct pohmelfs_state *st);
> +int pohmelfs_send_buf(struct pohmelfs_io *pio);
> +
> +int pohmelfs_data_recv(struct pohmelfs_state *st, void *buf, u64 size, unsigned int flags);
> +int pohmelfs_recv(struct pohmelfs_trans *t, struct pohmelfs_state *recv, void *data, int size);
> +
> +struct pohmelfs_route {
> +	struct rb_node			node;
> +	int				group_id;
> +	struct dnet_raw_id		id;
> +	struct pohmelfs_state		*st;
> +};
> +
> +int pohmelfs_route_request(struct pohmelfs_state *st);
> +void pohmelfs_route_remove_all(struct pohmelfs_state *st);
> +
> +struct pohmelfs_script_req {
> +	char			*obj_name;
> +	int			obj_len;
> +
> +	char			*script_name;
> +	int			script_namelen;
> +
> +	void			*binary;
> +	int			binary_size;
> +
> +	int			group_id;
> +
> +	unsigned int		cflags;
> +	int			sync;
> +
> +	struct dnet_raw_id	*id;
> +
> +	int			(* complete)(struct pohmelfs_trans *t, struct pohmelfs_state *recv);
> +	void			*ret;
> +	int			ret_cond;
> +};
> +
> +int pohmelfs_send_script_request(struct pohmelfs_inode *parent, struct pohmelfs_script_req *req);
> +
> +int pohmelfs_stat(struct pohmelfs_sb *psb, int sync);
> +
> +static inline int pohmelfs_need_resync(struct pohmelfs_inode *pi)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pi->vfs_inode.i_sb);
> +	return get_seconds() > pi->update + psb->sync_timeout;
> +}
> +
> +#endif /* __POHMELFS_H */
> diff --git a/fs/pohmelfs/pool.c b/fs/pohmelfs/pool.c
> new file mode 100644
> index 0000000..c4572c7
> --- /dev/null
> +++ b/fs/pohmelfs/pool.c
> @@ -0,0 +1,159 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <linux/net.h>
> +
> +#include <net/sock.h>
> +#include <net/tcp.h>
> +
> +#include "pohmelfs.h"
> +
> +static void pohmelfs_reconnect(struct work_struct *work)
> +{
> +	struct pohmelfs_connection *conn = container_of(to_delayed_work(work), struct pohmelfs_connection, reconnect_work);
> +	struct pohmelfs_reconnect *r, *tmp;
> +	struct pohmelfs_state *st, *stmp;
> +	LIST_HEAD(head);
> +	int err;
> +
> +	mutex_lock(&conn->reconnect_lock);
> +	list_for_each_entry_safe(r, tmp, &conn->reconnect_list, reconnect_entry) {
> +		st = pohmelfs_state_create(conn, &r->sa, r->addrlen, 1, r->group_id);
> +		if (IS_ERR(st)) {
> +			err = PTR_ERR(st);
> +
> +			if (err != -EEXIST)
> +				continue;
> +		} else {
> +			pohmelfs_print_addr(&st->sa, "reconnected\n");
> +		}
> +
> +		list_del(&r->reconnect_entry);
> +		kfree(r);
> +	}
> +	mutex_unlock(&conn->reconnect_lock);
> +
> +	spin_lock(&conn->state_lock);
> +	list_for_each_entry_safe(st, stmp, &conn->kill_state_list, state_entry) {
> +		list_move(&st->state_entry, &head);
> +	}
> +	spin_unlock(&conn->state_lock);
> +
> +	list_for_each_entry_safe(st, stmp, &head, state_entry) {
> +		list_del_init(&st->state_entry);
> +		pohmelfs_state_kill(st);
> +	}
> +
> +	if (!list_empty(&conn->reconnect_list) && !conn->need_exit)
> +		queue_delayed_work(conn->wq, &conn->reconnect_work, conn->psb->reconnect_timeout);
> +}
> +
> +void pohmelfs_pool_clean(struct pohmelfs_connection *conn, int conn_num)
> +{
> +	struct pohmelfs_connection *c;
> +	struct pohmelfs_state *st, *tmp;
> +	struct pohmelfs_reconnect *r, *rtmp;
> +	int i;
> +
> +	if (!conn || !conn_num)
> +		return;
> +
> +	for (i = 0; i < conn_num; ++i) {
> +		c = &conn[i];
> +
> +		c->need_exit = 1;
> +
> +		cancel_delayed_work_sync(&c->reconnect_work);
> +
> +		list_for_each_entry_safe(st, tmp, &c->state_list, state_entry) {
> +			list_del_init(&st->state_entry);
> +
> +			pohmelfs_state_kill(st);
> +		}
> +
> +		list_for_each_entry_safe(st, tmp, &c->kill_state_list, state_entry) {
> +			list_del_init(&st->state_entry);
> +			pohmelfs_state_kill(st);
> +		}
> +
> +		list_for_each_entry_safe(r, rtmp, &c->reconnect_list, reconnect_entry) {
> +			list_del(&r->reconnect_entry);
> +			kfree(r);
> +		}
> +
> +		destroy_workqueue(c->wq);
> +	}
> +
> +	kfree(conn);
> +}
> +
> +int pohmelfs_pool_resize(struct pohmelfs_sb *psb, int num)
> +{
> +	int err = 0, old_conn_num, i;
> +	struct pohmelfs_connection *conn, *old_conn, *c;
> +	struct pohmelfs_addr *a;
> +	char name[16];
> +
> +	conn = kzalloc(num * sizeof(struct pohmelfs_connection), GFP_NOIO);
> +	if (!conn) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	for (i = 0; i < num; ++i) {
> +		c = &conn[i];
> +
> +		c->psb = psb;
> +		c->idx = i;
> +
> +		c->route_root = RB_ROOT;
> +		spin_lock_init(&c->state_lock);
> +		INIT_LIST_HEAD(&c->state_list);
> +
> +		INIT_LIST_HEAD(&c->kill_state_list);
> +
> +		mutex_init(&c->reconnect_lock);
> +		INIT_LIST_HEAD(&c->reconnect_list);
> +
> +		INIT_DELAYED_WORK(&c->reconnect_work, pohmelfs_reconnect);
> +
> +		snprintf(name, sizeof(name), "pohmelfs-%d-%d", psb->bdi_num, i);
> +		c->wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
> +		if (!c->wq) {
> +			err = -ENOMEM;
> +			old_conn = conn;
> +			old_conn_num = i;
> +			goto err_out_free;
> +		}
> +
> +		mutex_lock(&psb->conn_lock);
> +		list_for_each_entry(a, &psb->addr_list, addr_entry) {
> +			pohmelfs_state_create(c, &a->sa, a->addrlen, 1, 0);
> +		}
> +		mutex_unlock(&psb->conn_lock);
> +
> +	}
> +
> +	mutex_lock(&psb->conn_lock);
> +	old_conn = psb->conn;
> +	old_conn_num = psb->conn_num;
> +
> +	psb->conn = conn;
> +	psb->conn_num = num;
> +
> +	psb->meta_num = psb->conn_num / 8 + 1;
> +	psb->bulk_num = psb->conn_num - psb->meta_num;
> +
> +	psb->meta_idx = 0;
> +	psb->bulk_idx = 0;
> +	mutex_unlock(&psb->conn_lock);
> +	err = 0;
> +
> +err_out_free:
> +	pohmelfs_pool_clean(old_conn, old_conn_num);
> +err_out_exit:
> +	return err;
> +}
> diff --git a/fs/pohmelfs/route.c b/fs/pohmelfs/route.c
> new file mode 100644
> index 0000000..c6a4755
> --- /dev/null
> +++ b/fs/pohmelfs/route.c
> @@ -0,0 +1,369 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +
> +#include "pohmelfs.h"
> +
> +
> +static inline int pohmelfs_route_cmp_raw(const struct pohmelfs_route *rt, const struct dnet_raw_id *raw, int group_id)
> +{
> +	if (rt->group_id < group_id)
> +		return -1;
> +	if (rt->group_id > group_id)
> +		return 1;
> +
> +	return dnet_id_cmp_str(rt->id.id, raw->id);
> +}
> +
> +static inline int pohmelfs_route_cmp(const struct pohmelfs_route *id1, const struct pohmelfs_route *id2)
> +{
> +	return pohmelfs_route_cmp_raw(id1, &id2->id, id2->group_id);
> +}
> +
> +static int pohmelfs_route_insert(struct pohmelfs_connection *conn, struct pohmelfs_route *rt)
> +{
> +	struct rb_node **n = &conn->route_root.rb_node, *parent = NULL;
> +	struct pohmelfs_route *tmp;
> +	int cmp, err = 0;
> +
> +	spin_lock(&conn->state_lock);
> +	while (*n) {
> +		parent = *n;
> +
> +		tmp = rb_entry(parent, struct pohmelfs_route, node);
> +
> +		cmp = pohmelfs_route_cmp(tmp, rt);
> +		if (cmp < 0)
> +			n = &parent->rb_left;
> +		else if (cmp > 0)
> +			n = &parent->rb_right;
> +		else {
> +			err = -EEXIST;
> +			goto err_out_unlock;
> +		}
> +	}
> +
> +	rb_link_node(&rt->node, parent, n);
> +	rb_insert_color(&rt->node, &conn->route_root);
> +
> +err_out_unlock:
> +	spin_unlock(&conn->state_lock);
> +	return err;
> +	
> +}
> +
> +static int pohmelfs_route_add(struct pohmelfs_state *st, struct dnet_raw_id *id, int group_id)
> +{
> +	struct pohmelfs_connection *conn = st->conn;
> +	struct pohmelfs_route *rt;
> +	int err;
> +
> +	rt = kmem_cache_zalloc(pohmelfs_route_cache, GFP_NOIO);
> +	if (!rt) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	memcpy(&rt->id, id, sizeof(struct dnet_raw_id));
> +	rt->group_id = group_id;
> +	rt->st = st;
> +
> +	pohmelfs_state_get(st);
> +
> +	err = pohmelfs_route_insert(conn, rt);
> +	if (err)
> +		goto err_out_put;
> +
> +	rt->st->routes++;
> +	return 0;
> +
> +err_out_put:
> +	pohmelfs_state_put(st);
> +	kmem_cache_free(pohmelfs_route_cache, rt);
> +err_out_exit:
> +	return err;
> +}
> +
> +static struct pohmelfs_state *pohmelfs_state_lookup_connection(struct pohmelfs_connection *conn, struct dnet_raw_id *id, int group_id)
> +{
> +	struct rb_node *n = conn->route_root.rb_node;
> +	struct pohmelfs_route *rt;
> +	struct pohmelfs_state *st = NULL;
> +	int cmp;
> +
> +	spin_lock(&conn->state_lock);
> +	while (n) {
> +		rt = rb_entry(n, struct pohmelfs_route, node);
> +
> +		cmp = pohmelfs_route_cmp_raw(rt, id, group_id);
> +
> +		if (!st && (rt->group_id == group_id)) {
> +			st = rt->st;
> +		}
> +
> +		if (cmp < 0) {
> +			n = n->rb_left;
> +
> +			if (rt->group_id == group_id) {
> +				st = rt->st;
> +			}
> +		} else if (cmp > 0)
> +			n = n->rb_right;
> +		else {
> +			st = rt->st;
> +			break;
> +		}
> +	}
> +	if (st)
> +		pohmelfs_state_get(st);
> +
> +	spin_unlock(&conn->state_lock);
> +
> +	return st;
> +}
> +
> +struct pohmelfs_state *pohmelfs_state_lookup(struct pohmelfs_sb *psb, struct dnet_raw_id *id, int group_id, ssize_t size)
> +{
> +	struct pohmelfs_state *st;
> +	struct pohmelfs_connection *c;
> +	int idx;
> +
> +	mutex_lock(&psb->conn_lock);
> +	if ((size > PAGE_SIZE) || (size < 0)) {
> +		idx = psb->bulk_idx;
> +		if (++psb->bulk_idx >= psb->bulk_num)
> +			psb->bulk_idx = 0;
> +	} else {
> +		/* meta connections are placed after bulk */
> +		idx = psb->meta_idx + psb->bulk_num;
> +		if (++psb->meta_idx >= psb->meta_num)
> +			psb->meta_idx = 0;
> +	}
> +
> +	pr_debug("%s: selected connection: %d, group: %d, size: %zd\n",
> +		 pohmelfs_dump_id(id->id), idx, group_id, size);
> +
> +	c = &psb->conn[idx];
> +	st = pohmelfs_state_lookup_connection(c, id, group_id);
> +	mutex_unlock(&psb->conn_lock);
> +
> +	return st;
> +}
> +
> +int pohmelfs_grab_states(struct pohmelfs_sb *psb, struct pohmelfs_state ***stp)
> +{
> +	struct pohmelfs_state **states, *st;
> +	struct pohmelfs_connection *c;
> +	int err;
> +	int num = 0, pos = 0;
> +
> +	mutex_lock(&psb->conn_lock);
> +	c = &psb->conn[0];
> +
> +	spin_lock(&c->state_lock);
> +	list_for_each_entry(st, &c->state_list, state_entry) {
> +		++num;
> +	}
> +	spin_unlock(&c->state_lock);
> +	mutex_unlock(&psb->conn_lock);
> +
> +	if (!num) {
> +		err = -ENOENT;
> +		goto err_out_exit;
> +	}
> +
> +	states = kzalloc(sizeof(struct pohmelfs_state *) * num, GFP_NOIO);
> +	if (!states) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	mutex_lock(&psb->conn_lock);
> +	c = &psb->conn[0];
> +
> +	spin_lock(&c->state_lock);
> +	list_for_each_entry(st, &c->state_list, state_entry) {
> +		pohmelfs_state_get(st);
> +		states[pos] = st;
> +		++pos;
> +	}
> +	spin_unlock(&c->state_lock);
> +	mutex_unlock(&psb->conn_lock);
> +
> +	*stp = states;
> +	return pos;
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static void pohmelfs_route_remove_nolock(struct pohmelfs_connection *conn, struct pohmelfs_route *rt)
> +{
> +	rt->st->routes--;
> +	rb_erase(&rt->node, &conn->route_root);
> +	pohmelfs_state_put(rt->st);
> +	kmem_cache_free(pohmelfs_route_cache, rt);
> +}
> +
> +void pohmelfs_route_remove_all(struct pohmelfs_state *st)
> +{
> +	struct pohmelfs_connection *conn = st->conn;
> +	struct pohmelfs_route *rt;
> +	struct rb_node *n;
> +	int again = 1;
> +
> +	while (again) {
> +		spin_lock(&conn->state_lock);
> +
> +		n = rb_first(&conn->route_root);
> +		if (!n) {
> +			spin_unlock(&conn->state_lock);
> +			break;
> +		}
> +
> +		again = 0;
> +		while (n) {
> +			rt = rb_entry(n, struct pohmelfs_route, node);
> +
> +			if (rt->st == st) {
> +				pohmelfs_route_remove_nolock(conn, rt);
> +				again = 1;
> +				break;
> +			}
> +
> +			n = rb_next(n);
> +		}
> +		spin_unlock(&conn->state_lock);
> +
> +		cond_resched();
> +	}
> +}
> +
> +static int pohmelfs_route_request_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(t->inode->i_sb);
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	struct pohmelfs_state *st;
> +	struct dnet_attr *attr;
> +	struct dnet_addr_attr *a;
> +	struct dnet_raw_id *ids;
> +	int err = 0;
> +
> +	if (!t->io_offset)
> +		goto err_out_exit;
> +
> +	attr = t->recv_data;
> +	dnet_convert_attr(attr);
> +
> +	if (attr->size > sizeof(struct dnet_addr_attr)) {
> +		int i, j, num = (attr->size - sizeof(struct dnet_addr_attr)) / sizeof(struct dnet_raw_id);
> +
> +		a = (struct dnet_addr_attr *)(attr + 1);
> +		dnet_convert_addr_attr(a);
> +		ids = (struct dnet_raw_id *)(a + 1);
> +
> +		mutex_lock(&psb->conn_lock);
> +		for (j = 0; j < psb->conn_num; ++j) {
> +			struct pohmelfs_connection *c = &psb->conn[j];
> +
> +			st = pohmelfs_state_create(c, (struct sockaddr_storage *)&a->addr.addr, a->addr.addr_len,
> +					0, cmd->id.group_id);
> +			if (IS_ERR(st)) {
> +				err = PTR_ERR(st);
> +
> +				if (err == -EEXIST) {
> +					spin_lock(&c->state_lock);
> +					st = pohmelfs_addr_exist(c, (struct sockaddr_storage *)&a->addr.addr, a->addr.addr_len);
> +					if (st) {
> +						st->group_id = cmd->id.group_id;
> +						pohmelfs_state_get(st);
> +						err = 0;
> +					}
> +					spin_unlock(&c->state_lock);
> +				}
> +
> +				if (err)
> +					goto err_out_unlock;
> +			} else {
> +				/*
> +				 * reference grab logic should be the same
> +				 * as in case when state exist - we will drop
> +				 * it at the end, so we would not check whether
> +				 * it is new state (and refcnt == 1) or
> +				 * existing (refcnt > 1)
> +				 */
> +				pohmelfs_state_get(st);
> +			}
> +
> +			for (i = 0; i < num; ++i) {
> +				dnet_convert_raw_id(&ids[i]);
> +#if 0
> +				pohmelfs_print_addr((struct sockaddr_storage *)&a->addr.addr, "%d:%s\n",
> +						cmd->id.group_id, pohmelfs_dump_id(ids[i].id));
> +#endif
> +
> +				err = pohmelfs_route_add(st, &ids[i], cmd->id.group_id);
> +				if (err) {
> +					if (err != -EEXIST) {
> +						/* remove this state from route table */
> +						spin_lock(&c->state_lock);
> +						list_del_init(&st->state_entry);
> +						spin_unlock(&c->state_lock);
> +
> +						/* drop abovementioned refcnt */
> +						pohmelfs_state_put(st);
> +
> +						pohmelfs_state_kill(st);
> +						goto err_out_exit;
> +					}
> +
> +					err = 0;
> +				}
> +			}
> +
> +			/* drop abovementioned refcnt */
> +			pohmelfs_state_put(st);
> +		}
> +err_out_unlock:
> +		mutex_unlock(&psb->conn_lock);
> +	}
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +int pohmelfs_route_request(struct pohmelfs_state *st)
> +{
> +	struct pohmelfs_sb *psb = st->conn->psb;
> +	struct pohmelfs_io *pio;
> +	int err;
> +
> +	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!pio) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	pio->pi = psb->root;
> +	pio->id = &psb->root->id;
> +	pio->cmd = DNET_CMD_ROUTE_LIST;
> +	pio->cflags = DNET_FLAGS_DIRECT | DNET_FLAGS_NEED_ACK;
> +	pio->cb.complete = pohmelfs_route_request_complete;
> +
> +	err = pohmelfs_send_buf_single(pio, st);
> +	if (err) {
> +		pohmelfs_print_addr(&st->sa, "%s: %d\n", __func__, err);
> +		goto err_out_free;
> +	}
> +	pohmelfs_print_addr(&st->sa, "route request sent\n");
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_io_cache, pio);
> +err_out_exit:
> +	return err;
> +}
> diff --git a/fs/pohmelfs/stat.c b/fs/pohmelfs/stat.c
> new file mode 100644
> index 0000000..1001760
> --- /dev/null
> +++ b/fs/pohmelfs/stat.c
> @@ -0,0 +1,141 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include "pohmelfs.h"
> +
> +static int pohmelfs_stat_init(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_wait *wait = t->priv;
> +
> +	atomic_long_inc(&wait->count);
> +	pohmelfs_wait_get(wait);
> +	return 0;
> +}
> +
> +static void pohmelfs_stat_destroy(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_wait *wait = t->priv;
> +
> +	atomic_long_dec(&wait->count);
> +	wake_up(&wait->wq);
> +	pohmelfs_wait_put(wait);
> +}
> +
> +static int pohmelfs_stat_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_wait *wait = t->priv;
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	struct dnet_attr *attr;
> +	int err = cmd->status;
> +
> +	if (err)
> +		goto err_out_exit;
> +
> +	if (cmd->size != sizeof(struct dnet_attr) + sizeof(struct dnet_stat)) {
> +		err = -ENOENT;
> +		goto err_out_exit;
> +	}
> +
> +	attr = t->recv_data;
> +
> +	if ((cmd->flags & DNET_FLAGS_MORE) && (attr->cmd == DNET_CMD_STAT) && (attr->size == sizeof(struct dnet_stat))) {
> +		struct dnet_stat *stat;
> +
> +		stat = t->recv_data + sizeof(struct dnet_attr);
> +		dnet_convert_stat(stat);
> +
> +		recv->bsize = stat->bsize;
> +		recv->frsize = stat->frsize;
> +		recv->blocks = stat->blocks;
> +		recv->bfree = stat->bfree;
> +		recv->bavail = stat->bavail;
> +
> +		pr_debug("%s: total: %llu, avail: %llu\n",
> +			 pohmelfs_dump_id(cmd->id.id),
> +			 (unsigned long long)(stat->frsize * stat->blocks / 1024 / 1024),
> +			 (unsigned long long)(stat->bavail * stat->bsize / 1024 / 1024));
> +	}
> +
> +err_out_exit:
> +	if (err)
> +		wait->condition = err;
> +	else
> +		wait->condition = 1;
> +	wake_up(&wait->wq);
> +
> +	return 0;
> +}
> +
> +int pohmelfs_stat(struct pohmelfs_sb *psb, int sync)
> +{
> +	struct pohmelfs_state **states, *st;
> +	struct pohmelfs_wait *wait;
> +	struct pohmelfs_io *pio;
> +	int err, i, num;
> +	long ret;
> +
> +	wait = pohmelfs_wait_alloc(psb->root);
> +	if (!wait) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!pio) {
> +		err = -ENOMEM;
> +		goto err_out_put;
> +	}
> +
> +	err = pohmelfs_grab_states(psb, &states);
> +	if (err < 0)
> +		goto err_out_free_pio;
> +
> +	pio->pi = psb->root;
> +	/* we use state pointer, but do not know correct ID, so use DIRECT flag here to forbid request forwarding */
> +	pio->cflags = DNET_FLAGS_NEED_ACK | DNET_FLAGS_NOLOCK | DNET_FLAGS_DIRECT;
> +	pio->cmd = DNET_CMD_STAT;
> +	pio->priv = wait;
> +	pio->cb.init = pohmelfs_stat_init;
> +	pio->cb.destroy = pohmelfs_stat_destroy;
> +	pio->cb.complete = pohmelfs_stat_complete;
> +
> +	num = err;
> +	for (i = 0; i < num; ++i) {
> +		st = states[i];
> +
> +		pio->group_id = st->group_id;
> +		pio->id = &psb->root->id;
> +
> +		err = pohmelfs_send_buf_single(pio, st);
> +		pohmelfs_state_put(st);
> +	}
> +
> +	err = 0;
> +
> +	if (sync) {
> +		ret = wait_event_interruptible_timeout(wait->wq,
> +				atomic_long_read(&wait->count) != 0,
> +				msecs_to_jiffies(psb->read_wait_timeout));
> +		if (ret <= 0) {
> +			err = ret;
> +			if (ret == 0)
> +				err = -ETIMEDOUT;
> +			goto err_out_free;
> +		}
> +
> +		if (wait->condition < 0)
> +			err = wait->condition;
> +	}
> +
> +err_out_free:
> +	kfree(states);
> +err_out_free_pio:
> +	kmem_cache_free(pohmelfs_io_cache, pio);
> +err_out_put:
> +	pohmelfs_wait_put(wait);
> +err_out_exit:
> +	return err;
> +}
> diff --git a/fs/pohmelfs/super.c b/fs/pohmelfs/super.c
> new file mode 100644
> index 0000000..c719937
> --- /dev/null
> +++ b/fs/pohmelfs/super.c
> @@ -0,0 +1,982 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/fs.h>
> +#include <linux/slab.h>
> +#include <linux/inet.h>
> +#include <linux/init.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <linux/blkdev.h>
> +#include <linux/parser.h>
> +#include <linux/random.h>
> +#include <linux/buffer_head.h>
> +#include <linux/exportfs.h>
> +#include <linux/vfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/mount.h>
> +#include <linux/quotaops.h>
> +#include <asm/uaccess.h>
> +
> +#include "pohmelfs.h"
> +
> +#define POHMELFS_MAGIC_NUM	0x504f482e
> +
> +struct kmem_cache *pohmelfs_inode_cache;
> +struct kmem_cache *pohmelfs_trans_cache;
> +struct kmem_cache *pohmelfs_inode_info_cache;
> +struct kmem_cache *pohmelfs_route_cache;
> +struct kmem_cache *pohmelfs_wait_cache;
> +struct kmem_cache *pohmelfs_io_cache;
> +struct kmem_cache *pohmelfs_inode_info_binary_package_cache;
> +struct kmem_cache *pohmelfs_write_cache;
> +struct kmem_cache *pohmelfs_dentry_cache;
> +
> +static atomic_t psb_bdi_num = ATOMIC_INIT(0);
> +
> +static void pohmelfs_http_compat_cleanup(struct pohmelfs_sb *psb)
> +{
> +	struct pohmelfs_path *p;
> +	int i;
> +
> +	for (i = 0; i < psb->http_compat; ++i) {
> +		p = &psb->path[i];
> +
> +		mutex_destroy(&p->lock);
> +		kfree(p->data);
> +	}
> +}
> +
> +static int pohmelfs_http_compat_init(struct pohmelfs_sb *psb)
> +{
> +	int i, err;
> +	struct pohmelfs_path *path, *p;
> +
> +	path = kmalloc(psb->http_compat * sizeof(struct pohmelfs_path), GFP_KERNEL);
> +	if (!path) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	for (i = 0; i < psb->http_compat; ++i) {
> +		p = &path[i];
> +
> +		mutex_init(&p->lock);
> +
> +		p->data = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		if (!p->data) {
> +			err = -ENOMEM;
> +			goto err_out_free;
> +		}
> +	}
> +
> +	psb->path = path;
> +	return 0;
> +
> +err_out_free:
> +	while (--i >= 0) {
> +		p = &path[i];
> +
> +		mutex_destroy(&p->lock);
> +		kfree(p->data);
> +	}
> +
> +	kfree(path);
> +err_out_exit:
> +	psb->http_compat = 0;
> +	return err;
> +}
> +
> +static void pohmelfs_cleanup_psb(struct pohmelfs_sb *psb)
> +{
> +	struct pohmelfs_addr *a, *tmp;
> +
> +	psb->need_exit = 1;
> +	cancel_delayed_work(&psb->sync_work);
> +	destroy_workqueue(psb->wq);
> +
> +	pohmelfs_pool_clean(psb->conn, psb->conn_num);
> +
> +	list_for_each_entry_safe(a, tmp, &psb->addr_list, addr_entry) {
> +		list_del(&a->addr_entry);
> +		kfree(a);
> +	}
> +
> +	crypto_free_hash(psb->hash);
> +
> +	pohmelfs_http_compat_cleanup(psb);
> +
> +	kfree(psb->groups);
> +	kfree(psb->fsid);
> +}
> +
> +static void pohmelfs_put_super(struct super_block *sb)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(sb);
> +
> +	pohmelfs_cleanup_psb(psb);
> +	bdi_destroy(&psb->bdi);
> +}
> +
> +struct pohmelfs_size {
> +	int			group_id;
> +	uint64_t		bsize;		/* Block size */
> +	uint64_t		frsize;		/* Fragment size */
> +	uint64_t		blocks;		/* Filesystem size in frsize units */
> +	uint64_t		bfree;		/* # free blocks */
> +	uint64_t		bavail;		/* # free blocks for non-root */
> +};
> +
> +static int pohmelfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> +{
> +	struct super_block *sb = dentry->d_sb;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(sb);
> +	struct pohmelfs_connection *c;
> +	struct pohmelfs_state *st;
> +	struct pohmelfs_size *sz;
> +	uint64_t min_size = ~0ULL;
> +	int pos = -1;
> +	int err, i;
> +
> +	sz = kzalloc(psb->group_num * sizeof(struct pohmelfs_size), GFP_KERNEL);
> +	if (!sz) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	for (i = 0; i < psb->group_num; ++i) {
> +		sz[i].group_id = psb->groups[i];
> +	}
> +
> +	memset(buf, 0, sizeof(struct kstatfs));
> +
> +	buf->f_type = POHMELFS_MAGIC_NUM; /* 'POH.' */
> +	buf->f_namelen = 4096;
> +	buf->f_files = 0;
> +	buf->f_bfree = buf->f_bavail = buf->f_blocks = 0;
> +
> +	mutex_lock(&psb->conn_lock);
> +	c = &psb->conn[0];
> +
> +	spin_lock(&c->state_lock);
> +	list_for_each_entry(st, &c->state_list, state_entry) {
> +		for (i = 0; i < psb->group_num; ++i) {
> +			if (sz[i].group_id == st->group_id) {
> +				sz[i].bsize = sb->s_blocksize;
> +				sz[i].frsize = st->frsize;
> +				sz[i].blocks += (st->blocks * st->frsize) >> PAGE_SHIFT;
> +				sz[i].bfree += (st->bfree * st->bsize) >> PAGE_SHIFT;
> +				sz[i].bavail += (st->bavail * st->bsize) >> PAGE_SHIFT;
> +				break;
> +			}
> +		}
> +
> +
> +	}
> +	spin_unlock(&c->state_lock);
> +	mutex_unlock(&psb->conn_lock);
> +
> +	for (i = 0; i < psb->group_num; ++i) {
> +		/* skip empty groups */
> +		if (sz[i].blocks && (sz[i].bavail < min_size)) {
> +			min_size = sz[i].bavail;
> +			pos = i;
> +		}
> +	}
> +
> +	if (pos == -1) {
> +		buf->f_bfree = buf->f_bavail = buf->f_blocks = ~0ULL >> PAGE_SHIFT;
> +	} else {
> +		buf->f_bsize = sz[pos].bsize;
> +		buf->f_frsize = sz[pos].frsize;
> +		buf->f_blocks = sz[pos].blocks;
> +		buf->f_bavail = sz[pos].bfree;
> +		buf->f_bfree = sz[pos].bavail;
> +	}
> +
> +	kfree(sz);
> +	err = 0;
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +#if 0
> +static int pohmelfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(vfs->mnt_sb);
> +#else
> +static int pohmelfs_show_options(struct seq_file *seq, struct dentry *dentry)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(dentry->d_inode->i_sb);
> +#endif
> +	struct pohmelfs_addr *a;
> +
> +	mutex_lock(&psb->conn_lock);
> +	list_for_each_entry(a, &psb->addr_list, addr_entry) {
> +		struct sockaddr *sa = (struct sockaddr *)&a->sa;
> +		if (sa->sa_family == AF_INET) {
> +			struct sockaddr_in *sin = (struct sockaddr_in *)sa;
> +			seq_printf(seq, ",server=%pI4:%d:2", &sin->sin_addr.s_addr, ntohs(sin->sin_port));
> +		} else if (sa->sa_family == AF_INET6) {
> +			struct sockaddr_in6 *sin = (struct sockaddr_in6 *)sa;
> +			seq_printf(seq, ",server=%pI6:%d:6", &sin->sin6_addr.s6_addr, ntohs(sin->sin6_port));
> +		}
> +	}
> +	mutex_unlock(&psb->conn_lock);
> +
> +	if (psb->no_read_csum)
> +		seq_printf(seq, ",noreadcsum");
> +	seq_printf(seq, ",sync_timeout=%ld", psb->sync_timeout);
> +	if (psb->fsid)
> +		seq_printf(seq, ",fsid=%s", psb->fsid);
> +	if (psb->successful_write_count)
> +		seq_printf(seq, ",successful_write_count=%d", psb->successful_write_count);
> +	seq_printf(seq, ",keepalive_cnt=%d", psb->keepalive_cnt);
> +	seq_printf(seq, ",keepalive_interval=%d", psb->keepalive_interval);
> +	seq_printf(seq, ",keepalive_idle=%d", psb->keepalive_idle);
> +	seq_printf(seq, ",readdir_allocation=%d", psb->readdir_allocation);
> +	if (psb->http_compat)
> +		seq_printf(seq, ",http_compat=%d", psb->http_compat);
> +	if (psb->sync_on_close)
> +		seq_printf(seq, ",sync_on_close");
> +	seq_printf(seq, ",connection_pool_size=%d", psb->conn_num);
> +	seq_printf(seq, ",read_wait_timeout=%ld", psb->read_wait_timeout);
> +	seq_printf(seq, ",write_wait_timeout=%ld", psb->write_wait_timeout);
> +	return 0;
> +}
> +
> +/*
> + * This is tricky function - inode cache can be shrunk and inode is about to be dropped,
> + * since its last reference is dropped. But then icache can __iget() on this inode and
> + * later iput() it, which will again call ->drop_inode() callback.
> + *
> + * So, ->drop_inode() can be called multiple times for single inode without its reintialization
> + * And we better to be ready for this
> + */
> +static int pohmelfs_drop_inode(struct inode *inode)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
> +
> +	pr_debug("%s: %ld, mapping: %p\n",
> +		 pohmelfs_dump_id(pi->id.id), inode->i_ino, inode->i_mapping);
> +
> +	spin_lock(&psb->inode_lock);
> +	if (rb_parent(&pi->node) != &pi->node)
> +		rb_erase(&pi->node, &psb->inode_root);
> +	rb_init_node(&pi->node);
> +	spin_unlock(&psb->inode_lock);
> +
> +	return generic_drop_inode(inode);
> +}
> +
> +static int pohmelfs_write_inode_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	struct pohmelfs_inode_info_binary_package *bin = t->priv;
> +	struct pohmelfs_wait *wait = &bin->wait;
> +
> +	if (cmd->flags & DNET_FLAGS_MORE)
> +		return 0;
> +
> +	wait->condition = cmd->status;
> +	if (!wait->condition)
> +		wait->condition = 1;
> +	wake_up(&wait->wq);
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_write_inode_init(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_inode_info_binary_package *bin = t->priv;
> +
> +	kref_get(&bin->wait.refcnt);
> +	return 0;
> +}
> +
> +static void pohmelfs_write_inode_release(struct kref *kref)
> +{
> +	struct pohmelfs_wait *wait = container_of(kref, struct pohmelfs_wait, refcnt);
> +	struct pohmelfs_inode_info_binary_package *bin = container_of(wait, struct pohmelfs_inode_info_binary_package, wait);
> +
> +	iput(&bin->wait.pi->vfs_inode);
> +	kmem_cache_free(pohmelfs_inode_info_binary_package_cache, bin);
> +}
> +
> +static void pohmelfs_write_inode_destroy(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_inode_info_binary_package *bin = t->priv;
> +
> +	/*
> +	 * We own this pointer - it points to &bin->info
> +	 * Zero it here to prevent pohmelfs_trans_release() from freeing it
> +	 */
> +	t->data = NULL;
> +	
> +	kref_put(&bin->wait.refcnt, pohmelfs_write_inode_release);
> +}
> +
> +static int pohmelfs_write_inode(struct inode *inode, struct writeback_control *wbc)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(inode);
> +	struct pohmelfs_inode_info_binary_package *bin;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
> +	struct pohmelfs_io *pio;
> +	int sync = 0;
> +	long ret;
> +	int err;
> +
> +	if (wbc)
> +		sync = wbc->sync_mode == WB_SYNC_ALL;
> +
> +	pio = kmem_cache_zalloc(pohmelfs_io_cache, GFP_NOIO);
> +	if (!pio) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	bin = kmem_cache_zalloc(pohmelfs_inode_info_binary_package_cache, GFP_NOIO);
> +	if (!bin) {
> +		err = -ENOMEM;
> +		goto err_out_free_pio;
> +	}
> +
> +	pohmelfs_fill_inode_info(inode, &bin->info);
> +	err = pohmelfs_wait_init(&bin->wait, pi);
> +	if (err)
> +		goto err_out_put_bin;
> +
> +	pio->pi = pi;
> +	pio->id = &pi->id;
> +	pio->cmd = DNET_CMD_WRITE;
> +	pio->offset = 0;
> +	pio->size = sizeof(struct pohmelfs_inode_info);
> +	pio->cflags = DNET_FLAGS_NEED_ACK;
> +	pio->priv = bin;
> +	pio->type = POHMELFS_INODE_COLUMN;
> +	pio->ioflags = DNET_IO_FLAGS_OVERWRITE;
> +
> +	pio->data = &bin->info;
> +	pio->alloc_flags = POHMELFS_IO_OWN;
> +
> +	pio->cb.complete = pohmelfs_write_inode_complete;
> +	pio->cb.init = pohmelfs_write_inode_init;
> +	pio->cb.destroy = pohmelfs_write_inode_destroy;
> +
> +	err = pohmelfs_send_io(pio);
> +	if (err)
> +		goto err_out_put_bin;
> +
> +	if (sync) {
> +		struct pohmelfs_wait *wait = &bin->wait;
> +
> +		ret = wait_event_interruptible_timeout(wait->wq,
> +				wait->condition != 0 && atomic_read(&wait->refcnt.refcount) <= 2,
> +				msecs_to_jiffies(psb->write_wait_timeout));
> +		if (ret <= 0) {
> +			err = ret;
> +			if (ret == 0)
> +				err = -ETIMEDOUT;
> +			goto err_out_put_bin;
> +		}
> +
> +		if (wait->condition < 0) {
> +			err = wait->condition;
> +			goto err_out_put_bin;
> +		}
> +	}
> +
> +err_out_put_bin:
> +	kref_put(&bin->wait.refcnt, pohmelfs_write_inode_release);
> +err_out_free_pio:
> +	kmem_cache_free(pohmelfs_io_cache, pio);
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_parse_options(struct pohmelfs_sb *psb, char *data);
> +
> +static int pohmelfs_remount_fs(struct super_block *sb, int *flags, char *data)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(sb);
> +
> +	return pohmelfs_parse_options(psb, data);
> +}
> +
> +static const struct super_operations pohmelfs_sb_ops = {
> +	.alloc_inode	= pohmelfs_alloc_inode,
> +	.destroy_inode	= pohmelfs_destroy_inode,
> +	.drop_inode	= pohmelfs_drop_inode,
> +	.write_inode	= pohmelfs_write_inode,
> +	.put_super	= pohmelfs_put_super,
> +	.show_options   = pohmelfs_show_options,
> +	.statfs		= pohmelfs_statfs,
> +	.remount_fs	= pohmelfs_remount_fs,
> +};
> +
> +static void pohmelfs_sync(struct work_struct *work)
> +{
> +	struct pohmelfs_sb *psb = container_of(to_delayed_work(work), struct pohmelfs_sb, sync_work);
> +	struct super_block *sb = psb->sb;
> +	long timeout = msecs_to_jiffies(psb->sync_timeout * 1000);
> +
> +	if (down_read_trylock(&sb->s_umount)) {
> +		sync_filesystem(sb);
> +		up_read(&sb->s_umount);
> +
> +		pohmelfs_stat(psb, 0);
> +	} else {
> +		timeout = 0;
> +	}
> +
> +	if (!psb->need_exit)
> +		queue_delayed_work(psb->wq, &psb->sync_work, timeout);
> +}
> +
> +static int pohmelfs_init_psb(struct pohmelfs_sb *psb, struct super_block *sb)
> +{
> +	char name[16];
> +	int err;
> +
> +	psb->inode_root = RB_ROOT;
> +	spin_lock_init(&psb->inode_lock);
> +
> +	atomic_long_set(&psb->ino, 0);
> +	atomic_long_set(&psb->trans, 0);
> +
> +	sb->s_fs_info = psb;
> +	sb->s_op = &pohmelfs_sb_ops;
> +	sb->s_magic = POHMELFS_MAGIC_NUM;
> +	sb->s_maxbytes = MAX_LFS_FILESIZE;
> +	sb->s_blocksize = PAGE_SIZE;
> +	sb->s_bdi = &psb->bdi;
> +	sb->s_time_gran = 0;
> +
> +	psb->read_wait_timeout = 5000;
> +	psb->write_wait_timeout = 5000;
> +
> +	psb->sync_timeout = 300;
> +
> +	psb->keepalive_cnt = 5;
> +	psb->keepalive_interval = 10;
> +	psb->keepalive_idle = 30;
> +
> +	psb->readdir_allocation = 4;
> +	psb->reconnect_timeout = msecs_to_jiffies(30000);
> +
> +	psb->conn_num = 5;
> +
> +	psb->sb = sb;
> +
> +	psb->hash = crypto_alloc_hash("sha512", 0, CRYPTO_ALG_ASYNC);
> +	if (IS_ERR(psb->hash)) {
> +		err = PTR_ERR(psb->hash);
> +		goto err_out_exit;
> +	}
> +
> +	snprintf(name, sizeof(name), "pohmelfs-sync-%d", psb->bdi_num);
> +	psb->wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
> +	if (!psb->wq) {
> +		err = -ENOMEM;
> +		goto err_out_crypto_free;
> +	}
> +
> +	mutex_init(&psb->conn_lock);
> +	INIT_LIST_HEAD(&psb->addr_list);
> +
> +	INIT_DELAYED_WORK(&psb->sync_work, pohmelfs_sync);
> +
> +	return 0;
> +
> +err_out_crypto_free:
> +	crypto_free_hash(psb->hash);
> +err_out_exit:
> +	psb->sb = NULL;
> +	sb->s_fs_info = NULL;
> +	return err;
> +}
> +
> +static int pohmelfs_parse_addr(char *addr, struct sockaddr_storage *a, int *addrlen)
> +{
> +	int family, port;
> +	char *ptr;
> +	int err = -EINVAL;
> +
> +	ptr = strrchr(addr, ':');
> +	if (!ptr)
> +		goto err_out_print_wrong_param;
> +	*ptr++ = 0;
> +	if (!ptr)
> +		goto err_out_print_wrong_param;
> +
> +	family = simple_strtol(ptr, NULL, 10);
> +
> +	ptr = strrchr(addr, ':');
> +	if (!ptr)
> +		goto err_out_print_wrong_param;
> +	*ptr++ = 0;
> +	if (!ptr)
> +		goto err_out_print_wrong_param;
> +
> +	port = simple_strtol(ptr, NULL, 10);
> +
> +	if (family == AF_INET) {
> +		struct sockaddr_in *sin = (struct sockaddr_in *)a;
> +
> +		sin->sin_family = family;
> +		sin->sin_port = htons(port);
> +
> +		err = in4_pton(addr, strlen(addr), (u8 *)&sin->sin_addr, ':', NULL);
> +		*addrlen = sizeof(struct sockaddr_in);
> +	} else if (family == AF_INET6) {
> +		struct sockaddr_in6 *sin = (struct sockaddr_in6 *)a;
> +
> +		sin->sin6_family = family;
> +		sin->sin6_port = htons(port);
> +		err = in6_pton(addr, strlen(addr), (u8 *)&sin->sin6_addr, ':', NULL);
> +		*addrlen = sizeof(struct sockaddr_in6);
> +	} else {
> +		err = -ENOTSUPP;
> +	}
> +
> +	if (err == 1)
> +		err = 0;
> +	else if (!err)
> +		err = -EINVAL;
> +
> +	if (err)
> +		goto err_out_print_wrong_param;
> +
> +	return 0;
> +
> +err_out_print_wrong_param:
> +	pr_err("%s: wrong addr: '%s', should be 'addr:port:family': %d\n",
> +	       __func__, addr, err);
> +	return err;
> +}
> +
> +static int pohmelfs_option(char *option, char *data, int *lenp, int have_data)
> +{
> +	int len;
> +	char *ptr;
> +
> +	if (!strncmp(option, data, strlen(option))) {
> +		len = strlen(option);
> +		ptr = data + len;
> +
> +		if (have_data && (!ptr || !*ptr))
> +			return 0;
> +
> +		*lenp = len;
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_set_groups(struct pohmelfs_sb *psb, char *value, int len)
> +{
> +	int i, num = 0, start = 0, pos = 0;
> +	char *ptr = value;
> +
> +	for (i = 0; i < len; ++i) {
> +		if (value[i] == ':')
> +			start = 0;
> +		else if (!start) {
> +			start = 1;
> +			num++;
> +		}
> +	}
> +
> +	if (!num) {
> +		return -ENOENT;
> +	}
> +
> +	/*
> +	 * We do not allow to mess with different group sets for already built filesystem
> +	 * But to prevent remount from failing, we just pretend that things went the right way
> +	 */
> +	if (psb->groups)
> +		return 0;
> +
> +	psb->groups = kzalloc(sizeof(int) * num, GFP_KERNEL);
> +	if (!psb->groups)
> +		return -ENOMEM;
> +	psb->group_num = num;
> +
> +	start = 0;
> +	for (i = 0; i < len; ++i) {
> +		if (value[i] == ':') {
> +			value[i] = '\0';
> +			if (start) {
> +				psb->groups[pos] = simple_strtol(ptr, NULL, 10);
> +				pos++;
> +				start = 0;
> +			}
> +		} else if (!start) {
> +			ptr = &value[i];
> +			start = 1;
> +		}
> +	}
> +
> +	if (start) {
> +		psb->groups[pos] = simple_strtol(ptr, NULL, 10);
> +		pos++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_parse_option(struct pohmelfs_sb *psb, char *data)
> +{
> +	int len;
> +	int err = 0;
> +
> +	pr_debug("option: %s\n", data);
> +
> +	if (pohmelfs_option("server=", data, &len, 1)) {
> +		struct pohmelfs_addr *a, *tmp;
> +		char *addr_str = data + len;
> +
> +		a = kzalloc(sizeof(struct pohmelfs_addr), GFP_KERNEL);
> +		if (!a) {
> +			err = -ENOMEM;
> +			goto err_out_exit;
> +		}
> +
> +		err = pohmelfs_parse_addr(addr_str, &a->sa, &a->addrlen);
> +		if (err)
> +			goto err_out_exit;
> +
> +		mutex_lock(&psb->conn_lock);
> +		list_for_each_entry(tmp, &psb->addr_list, addr_entry) {
> +			if (tmp->addrlen != a->addrlen)
> +				continue;
> +
> +			if (!memcmp(&tmp->sa, &a->sa, a->addrlen)) {
> +				err = -EEXIST;
> +				break;
> +			}
> +		}
> +
> +		if (!err)
> +			list_add_tail(&a->addr_entry, &psb->addr_list);
> +		else
> +			kfree(a);
> +		mutex_unlock(&psb->conn_lock);
> +		err = 0;
> +	} else if (pohmelfs_option("fsid=", data, &len, 1)) {
> +		data += len;
> +		len = strlen(data);
> +
> +		psb->fsid = kmalloc(len + 1, GFP_KERNEL);
> +		if (!psb->fsid) {
> +			err = -ENOMEM;
> +			goto err_out_exit;
> +		}
> +
> +		snprintf(psb->fsid, len + 1, "%s", data);
> +		psb->fsid_len = len;
> +	} else if (pohmelfs_option("sync_timeout=", data, &len, 1)) {
> +		psb->sync_timeout = simple_strtol(data + len, NULL, 10);
> +	} else if (pohmelfs_option("http_compat=", data, &len, 1)) {
> +		psb->http_compat = simple_strtol(data + len, NULL, 10);
> +		err = pohmelfs_http_compat_init(psb);
> +	} else if (pohmelfs_option("groups=", data, &len, 1)) {
> +		data += len;
> +		len = strlen(data);
> +
> +		err = pohmelfs_set_groups(psb, data, len);
> +	} else if (pohmelfs_option("noatime", data, &len, 0)) {
> +		psb->sb->s_flags |= FS_NOATIME_FL;
> +	} else if (pohmelfs_option("relatime", data, &len, 0)) {
> +		psb->sb->s_flags |= MS_RELATIME;
> +	} else if (pohmelfs_option("noreadcsum", data, &len, 0)) {
> +		psb->no_read_csum = 1;
> +	} else if (pohmelfs_option("readcsum", data, &len, 0)) {
> +		psb->no_read_csum = 0;
> +	} else if (pohmelfs_option("successful_write_count=", data, &len, 1)) {
> +		psb->successful_write_count = simple_strtol(data + len, NULL, 10);
> +	} else if (pohmelfs_option("keepalive_cnt=", data, &len, 1)) {
> +		psb->keepalive_cnt = simple_strtol(data + len, NULL, 10);
> +	} else if (pohmelfs_option("keepalive_idle=", data, &len, 1)) {
> +		psb->keepalive_idle = simple_strtol(data + len, NULL, 10);
> +	} else if (pohmelfs_option("keepalive_interval=", data, &len, 1)) {
> +		psb->keepalive_interval = simple_strtol(data + len, NULL, 10);
> +	} else if (pohmelfs_option("readdir_allocation=", data, &len, 1)) {
> +		psb->readdir_allocation = simple_strtol(data + len, NULL, 10);
> +	} else if (pohmelfs_option("sync_on_close", data, &len, 0)) {
> +		psb->sync_on_close = 1;
> +	} else if (pohmelfs_option("connection_pool_size=", data, &len, 1)) {
> +		psb->conn_num = simple_strtol(data + len, NULL, 10);
> +		if (psb->conn_num < 2)
> +			psb->conn_num = 2;
> +	} else if (pohmelfs_option("read_wait_timeout=", data, &len, 1)) {
> +		psb->read_wait_timeout = simple_strtol(data + len, NULL, 10);
> +	} else if (pohmelfs_option("write_wait_timeout=", data, &len, 1)) {
> +		psb->write_wait_timeout = simple_strtol(data + len, NULL, 10);
> +	} else {
> +		err = -ENOTSUPP;
> +	}
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_parse_options(struct pohmelfs_sb *psb, char *data)
> +{
> +	int err = -ENOENT;
> +	char *ptr, *start;
> +
> +	ptr = start = data;
> +
> +	while (ptr && *ptr) {
> +		if (*ptr == ',') {
> +			*ptr = '\0';
> +			err = pohmelfs_parse_option(psb, start);
> +			if (err)
> +				goto err_out_exit;
> +			ptr++;
> +			if (ptr && *ptr)
> +				start = ptr;
> +
> +			continue;
> +		}
> +
> +		ptr++;
> +	}
> +
> +	if (start != ptr) {
> +		err = pohmelfs_parse_option(psb, start);
> +		if (err)
> +			goto err_out_exit;
> +	}
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
> +{
> +	struct pohmelfs_sb *psb;
> +	int err;
> +
> +	psb = kzalloc(sizeof(struct pohmelfs_sb), GFP_KERNEL);
> +	if (!psb) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	psb->bdi_num = atomic_inc_return(&psb_bdi_num);
> +
> +	err = bdi_init(&psb->bdi);
> +	if (err)
> +		goto err_out_free_psb;
> +
> +	psb->bdi.ra_pages = default_backing_dev_info.ra_pages;
> +
> +	err = bdi_register(&psb->bdi, NULL, "pfs-%d", psb->bdi_num);
> +	if (err) {
> +		bdi_destroy(&psb->bdi);
> +		goto err_out_free_psb;
> +	}
> +
> +	err = pohmelfs_init_psb(psb, sb);
> +	if (err)
> +		goto err_out_free_bdi;
> +
> +	psb->root = pohmelfs_new_inode(psb, 0755|S_IFDIR);
> +	if (IS_ERR(psb->root)) {
> +		err = PTR_ERR(psb->root);
> +		goto err_out_cleanup_psb;
> +	}
> +
> +	err = pohmelfs_parse_options(psb, data);
> +	if (err)
> +		goto err_out_put_root;
> +
> +	if (!psb->group_num || list_empty(&psb->addr_list)) {
> +		err = -EINVAL;
> +		pr_err("you have to specify number of groups and add remote node address (at least one)\n");
> +		goto err_out_put_root;
> +	}
> +
> +	if (!psb->fsid_len) {
> +		char str[] = "pohmelfs";
> +		err = pohmelfs_hash(psb, str, 8, &psb->root->id);
> +	} else {
> +		err = pohmelfs_hash(psb, psb->fsid, psb->fsid_len, &psb->root->id);
> +	}
> +	if (err)
> +		goto err_out_put_root;
> +
> +	err = psb->conn_num;
> +	psb->conn_num = 0;
> +	err = pohmelfs_pool_resize(psb, err);
> +	if (err)
> +		goto err_out_put_root;
> +
> +	sb->s_root = d_make_root(&psb->root->vfs_inode);
> +	if (!sb->s_root) {
> +		err = -ENOMEM;
> +		goto err_out_cleanup_psb;
> +	}
> +
> +	queue_delayed_work(psb->wq, &psb->sync_work, msecs_to_jiffies(psb->sync_timeout * 1000));
> +	pohmelfs_stat(psb, 0);
> +
> +	return 0;
> +
> +err_out_put_root:
> +	iput(&psb->root->vfs_inode);
> +err_out_cleanup_psb:
> +	pohmelfs_cleanup_psb(psb);
> +err_out_free_bdi:
> +	bdi_destroy(&psb->bdi);
> +err_out_free_psb:
> +	kfree(psb);
> +err_out_exit:
> +	pr_err("%s: error: %d\n", __func__, err);
> +	return err;
> +}
> +
> +static struct dentry *pohmelfs_mount(struct file_system_type *fs_type,
> +		       int flags, const char *dev_name, void *data)
> +{
> +	return mount_nodev(fs_type, flags, data, pohmelfs_fill_super);
> +}
> +
> +static void pohmelfs_kill_sb(struct super_block *sb)
> +{
> +	sync_inodes_sb(sb);
> +	kill_anon_super(sb);
> +}
> +
> +static struct file_system_type pohmelfs_type = {
> +	.owner		= THIS_MODULE,
> +	.name		= "pohmelfs",
> +	.mount		= pohmelfs_mount,
> +	.kill_sb	= pohmelfs_kill_sb,
> +};
> +
> +static void pohmelfs_cleanup_cache(void)
> +{
> +	kmem_cache_destroy(pohmelfs_trans_cache);
> +	kmem_cache_destroy(pohmelfs_inode_cache);
> +	kmem_cache_destroy(pohmelfs_inode_info_cache);
> +	kmem_cache_destroy(pohmelfs_route_cache);
> +	kmem_cache_destroy(pohmelfs_wait_cache);
> +	kmem_cache_destroy(pohmelfs_io_cache);
> +	kmem_cache_destroy(pohmelfs_inode_info_binary_package_cache);
> +	kfree(pohmelfs_scratch_buf);
> +	kmem_cache_destroy(pohmelfs_write_cache);
> +	kmem_cache_destroy(pohmelfs_dentry_cache);
> +}
> +
> +static int pohmelfs_init_cache(void)
> +{
> +	int err = -ENOMEM;
> +
> +	pohmelfs_inode_cache = KMEM_CACHE(pohmelfs_inode, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_inode_cache)
> +		goto err_out_exit;
> +
> +	pohmelfs_trans_cache = KMEM_CACHE(pohmelfs_trans, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_trans_cache)
> +		goto err_out_destroy_inode_cache;
> +
> +	pohmelfs_inode_info_cache = KMEM_CACHE(pohmelfs_inode_info, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_inode_info_cache)
> +		goto err_out_destroy_trans_cache;
> +
> +	pohmelfs_route_cache = KMEM_CACHE(pohmelfs_route, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_route_cache)
> +		goto err_out_destroy_inode_info_cache;
> +
> +	pohmelfs_wait_cache = KMEM_CACHE(pohmelfs_wait, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_wait_cache)
> +		goto err_out_destroy_inode_info_cache;
> +
> +	pohmelfs_io_cache = KMEM_CACHE(pohmelfs_io, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_io_cache)
> +		goto err_out_destroy_wait_cache;
> +
> +	pohmelfs_scratch_buf = kmalloc(pohmelfs_scratch_buf_size, GFP_KERNEL);
> +	if (!pohmelfs_scratch_buf) {
> +		err = -ENOMEM;
> +		goto err_out_destroy_io_cache;
> +	}
> +
> +	pohmelfs_inode_info_binary_package_cache = KMEM_CACHE(pohmelfs_inode_info_binary_package, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_inode_info_binary_package_cache)
> +		goto err_out_free_scratch;
> +
> +	pohmelfs_write_cache = KMEM_CACHE(pohmelfs_write_ctl, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_write_cache)
> +		goto err_out_destroy_inode_info_binary_package_cache;
> +
> +	pohmelfs_dentry_cache = KMEM_CACHE(pohmelfs_dentry, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +	if (!pohmelfs_dentry_cache)
> +		goto err_out_destroy_write_cache;
> +
> +	return 0;
> +
> +err_out_destroy_write_cache:
> +	kmem_cache_destroy(pohmelfs_write_cache);
> +err_out_destroy_inode_info_binary_package_cache:
> +	kmem_cache_destroy(pohmelfs_inode_info_binary_package_cache);
> +err_out_free_scratch:
> +	kfree(pohmelfs_scratch_buf);
> +err_out_destroy_io_cache:
> +	kmem_cache_destroy(pohmelfs_io_cache);
> +err_out_destroy_wait_cache:
> +	kmem_cache_destroy(pohmelfs_wait_cache);
> +err_out_destroy_inode_info_cache:
> +	kmem_cache_destroy(pohmelfs_inode_info_cache);
> +err_out_destroy_trans_cache:
> +	kmem_cache_destroy(pohmelfs_trans_cache);
> +err_out_destroy_inode_cache:
> +	kmem_cache_destroy(pohmelfs_inode_cache);
> +err_out_exit:
> +	return err;
> +}
> +
> +static int __init pohmelfs_init(void)
> +{
> +	int err;
> +
> +	err = pohmelfs_init_cache();
> +	if (err)
> +		goto err_out_exit;
> +
> +        err = register_filesystem(&pohmelfs_type);
> +	if (err)
> +		goto err_out_cleanup_cache;
> +
> +	return 0;
> +
> +err_out_cleanup_cache:
> +	pohmelfs_cleanup_cache();
> +err_out_exit:
> +	return err;
> +}
> +
> +static void __exit pohmelfs_exit(void)
> +{
> +	unregister_filesystem(&pohmelfs_type);
> +	pohmelfs_cleanup_cache();
> +}
> +
> +module_init(pohmelfs_init)
> +module_exit(pohmelfs_exit)
> +
> +MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
> +MODULE_DESCRIPTION("POHMELFS");
> +MODULE_LICENSE("GPL");
> diff --git a/fs/pohmelfs/symlink.c b/fs/pohmelfs/symlink.c
> new file mode 100644
> index 0000000..80a9d87
> --- /dev/null
> +++ b/fs/pohmelfs/symlink.c
> @@ -0,0 +1,13 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#include <linux/namei.h>
> +
> +#include "pohmelfs.h"
> +
> +const struct inode_operations pohmelfs_symlink_inode_operations = {
> +	.readlink	= generic_readlink,
> +	.follow_link	= page_follow_link_light,
> +	.put_link	= page_put_link,
> +};
> diff --git a/fs/pohmelfs/trans.c b/fs/pohmelfs/trans.c
> new file mode 100644
> index 0000000..8fb9bf1
> --- /dev/null
> +++ b/fs/pohmelfs/trans.c
> @@ -0,0 +1,432 @@
> +/*
> + * Copyright (C) 2011+ Evgeniy Polyakov <zbr@ioremap.net>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +
> +#include "pohmelfs.h"
> +
> +static void pohmelfs_trans_free(struct pohmelfs_trans *t)
> +{
> +	iput(t->inode);
> +
> +	kmem_cache_free(pohmelfs_trans_cache, t);
> +}
> +
> +static void pohmelfs_trans_release(struct kref *kref)
> +{
> +	struct pohmelfs_trans *t = container_of(kref, struct pohmelfs_trans, refcnt);
> +	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
> +
> +	pr_debug("%s: %lu, io_offset: %llu, ino: %ld\n",
> +		 pohmelfs_dump_id(pi->id.id), t->trans, t->io_offset,
> +		 t->inode->i_ino);
> +
> +	if (t->cb.destroy)
> +		t->cb.destroy(t);
> +
> +	pohmelfs_state_put(t->st);
> +
> +	kfree(t->data);
> +	kfree(t->recv_data);
> +	pohmelfs_trans_free(t);
> +}
> +
> +void pohmelfs_trans_put(struct pohmelfs_trans *t)
> +{
> +	kref_put(&t->refcnt, pohmelfs_trans_release);
> +}
> +
> +struct pohmelfs_trans *pohmelfs_trans_alloc(struct inode *inode)
> +{
> +	struct pohmelfs_trans *t;
> +	int err;
> +
> +	t = kmem_cache_zalloc(pohmelfs_trans_cache, GFP_NOIO);
> +	if (!t) {
> +		err = -ENOMEM;
> +		goto err_out_exit;
> +	}
> +
> +	kref_init(&t->refcnt);
> +
> +	t->inode = igrab(inode);
> +	if (!t->inode) {
> +		err = -ENOENT;
> +		goto err_out_free;
> +	}
> +
> +	return t;
> +
> +err_out_free:
> +	kmem_cache_free(pohmelfs_trans_cache, t);
> +err_out_exit:
> +	return ERR_PTR(err);
> +}
> +
> +static int pohmelfs_buf_complete(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct pohmelfs_inode *pi = pohmelfs_inode(t->inode);
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	unsigned long long trans = cmd->trans & ~DNET_TRANS_REPLY;
> +
> +	pr_debug("%s: %llu, flags: %x\n",
> +		 pohmelfs_dump_id(pi->id.id), trans, cmd->flags);
> +
> +	return 0;
> +}
> +
> +static int pohmelfs_buf_recv(struct pohmelfs_trans *t, struct pohmelfs_state *recv)
> +{
> +	struct dnet_cmd *cmd = &recv->cmd;
> +	int err;
> +
> +	if (!t->recv_data) {
> +		t->recv_data = kmalloc(cmd->size, GFP_NOIO);
> +		if (!t->recv_data) {
> +			err = -ENOMEM;
> +			goto err_out_exit;
> +		}
> +
> +		t->io_offset = 0;
> +	}
> +
> +	err = pohmelfs_data_recv(recv, t->recv_data + t->io_offset, cmd->size - t->io_offset, MSG_DONTWAIT);
> +	if (err < 0)
> +		goto err_out_exit;
> +
> +	t->io_offset += err;
> +	err = 0;
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +static int pohmelfs_init_callbacks(struct pohmelfs_trans *t, struct pohmelfs_io *pio)
> +{
> +	int err = 0;
> +	struct pohmelfs_state *st = t->st;
> +
> +	t->priv = pio->priv;
> +	t->cb = pio->cb;
> +
> +	if (!t->cb.complete)
> +		t->cb.complete = pohmelfs_buf_complete;
> +
> +	if (!t->cb.recv_reply)
> +		t->cb.recv_reply = pohmelfs_buf_recv;
> +
> +	if (t->cb.init) {
> +		err = t->cb.init(t);
> +		if (err)
> +			goto err_out_exit;
> +	}
> +
> +	pohmelfs_trans_insert(t);
> +
> +	pohmelfs_state_schedule(st);
> +	pohmelfs_state_put(st);
> +
> +err_out_exit:
> +	return err;
> +}
> +
> +int pohmelfs_send_io_group(struct pohmelfs_io *pio, int group)
> +{
> +	struct pohmelfs_inode *pi = pio->pi;
> +	struct inode *inode = &pi->vfs_inode;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
> +	struct pohmelfs_state *st;
> +	struct pohmelfs_trans *t;
> +	struct dnet_cmd *cmd;
> +	struct dnet_attr *attr;
> +	struct dnet_io_attr *io;
> +	u64 iosize = pio->size;
> +	u64 alloc_io_size = pio->size;
> +	int err;
> +
> +	/* Dirty hack to prevent setting cmd/attr size to pio->size,
> +	 * since in read command we specify in io->size number bytes we want,
> +	 * and it should not be accounted in the packet we send to remote node
> +	 */
> +	if (pio->cmd == DNET_CMD_READ)
> +		alloc_io_size = 0;
> +
> +	t = pohmelfs_trans_alloc(inode);
> +	if (IS_ERR(t)) {
> +		err = PTR_ERR(t);
> +		goto err_out_exit;
> +	}
> +
> +	st = pohmelfs_state_lookup(psb, pio->id, group, pio->size);
> +	if (!st) {
> +		err = -ENOENT;
> +		goto err_out_free;
> +	}
> +
> +	t->st = st;
> +
> +	/*
> +	 * We already hold a reference grabbed in pohmelfs_state_lookup(), it is dropped when transaction is destroyed
> +	 * We have to have valid state pointer to schedule sending, but after transaction is inserted into state's list,
> +	 * it can be processed immediately and freed and grabbed reference pointer will dissapear.
> +	 */
> +	pohmelfs_state_get(st);
> +
> +	cmd = &t->cmd.cmd;
> +	attr = &t->cmd.attr;
> +	io = &t->cmd.p.io;
> +
> +	dnet_setup_id(&cmd->id, group, pio->id->id);
> +	cmd->flags = pio->cflags;
> +	cmd->trans = t->trans = atomic_long_inc_return(&psb->trans);
> +	cmd->size = alloc_io_size + sizeof(struct dnet_io_attr) + sizeof(struct dnet_attr);
> +
> +	attr->cmd = pio->cmd;
> +	attr->size = alloc_io_size + sizeof(struct dnet_io_attr);
> +	attr->flags = pio->aflags;
> +
> +	memcpy(io->id, pio->id->id, DNET_ID_SIZE);
> +	memcpy(io->parent, pio->id->id, DNET_ID_SIZE);
> +	io->flags = pio->ioflags;
> +	io->size = iosize;
> +	io->offset = pio->offset;
> +	io->type = pio->type;
> +	io->start = pio->start;
> +	io->num = pio->num;
> +
> +	t->header_size = sizeof(struct dnet_cmd) + sizeof(struct dnet_attr) + sizeof(struct dnet_io_attr);
> +	t->data_size = alloc_io_size;
> +
> +	dnet_convert_cmd(cmd);
> +	dnet_convert_attr(attr);
> +	dnet_convert_io_attr(io);
> +
> +	t->wctl = pio->wctl;
> +
> +	if (pio->data) {
> +		if (pio->alloc_flags & POHMELFS_IO_OWN) {
> +			t->data = pio->data;
> +		} else {
> +			t->data = kmalloc(alloc_io_size, GFP_NOIO);
> +			if (!t->data) {
> +				err = -ENOMEM;
> +				goto err_out_put_state;
> +			}
> +
> +			memcpy(t->data, pio->data, alloc_io_size);
> +		}
> +	}
> +
> +	err = pohmelfs_init_callbacks(t, pio);
> +	if (err)
> +		goto err_out_put_state;
> +
> +
> +	return 0;
> +
> +err_out_put_state:
> +	pohmelfs_state_put(t->st);
> +err_out_free:
> +	pohmelfs_trans_free(t);
> +err_out_exit:
> +	return err;
> +}
> +
> +int pohmelfs_send_io(struct pohmelfs_io *pio)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pio->pi->vfs_inode.i_sb);
> +	int i, err, err_num;
> +
> +	err = -ENOENT;
> +	err_num = 0;
> +
> +	for (i = 0; i < psb->group_num; ++i) {
> +		err = pohmelfs_send_io_group(pio, psb->groups[i]);
> +		if (err)
> +			err_num++;
> +	}
> +
> +	return (err_num == psb->group_num) ? err : 0;
> +}
> +
> +int pohmelfs_trans_insert(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_state *st = t->st;
> +
> +	mutex_lock(&st->trans_lock);
> +	list_add_tail(&t->trans_entry, &st->trans_list);
> +	mutex_unlock(&st->trans_lock);
> +
> +	return 0;
> +}
> +
> +void pohmelfs_trans_remove(struct pohmelfs_trans *t)
> +{
> +	struct pohmelfs_state *st = t->st;
> +
> +	mutex_lock(&st->trans_lock);
> +	rb_erase(&t->trans_node, &st->trans_root);
> +	mutex_unlock(&st->trans_lock);
> +}
> +
> +static inline long pohmelfs_trans_cmp(struct pohmelfs_trans *t1, long trans)
> +{
> +	return t1->trans - trans;
> +}
> +
> +/* Must be called under st->trans_lock */
> +int pohmelfs_trans_insert_tree(struct pohmelfs_state *st, struct pohmelfs_trans *t)
> +{
> +	struct rb_node **n = &st->trans_root.rb_node, *parent = NULL;
> +	struct pohmelfs_trans *tmp;
> +	int err = 0;
> +	long cmp;
> +
> +	while (*n) {
> +		parent = *n;
> +
> +		tmp = rb_entry(parent, struct pohmelfs_trans, trans_node);
> +
> +		cmp = pohmelfs_trans_cmp(tmp, t->trans);
> +		if (cmp < 0)
> +			n = &parent->rb_left;
> +		else if (cmp > 0)
> +			n = &parent->rb_right;
> +		else {
> +			err = -EEXIST;
> +			goto err_out_exit;
> +		}
> +	}
> +
> +	rb_link_node(&t->trans_node, parent, n);
> +	rb_insert_color(&t->trans_node, &st->trans_root);
> +
> +err_out_exit:
> +	return err;
> +	
> +}
> +
> +struct pohmelfs_trans *pohmelfs_trans_lookup(struct pohmelfs_state *st, struct dnet_cmd *cmd)
> +{
> +	struct pohmelfs_trans *t, *found = NULL;
> +	u64 trans = cmd->trans & ~DNET_TRANS_REPLY;
> +	struct rb_node *n = st->trans_root.rb_node;
> +	long cmp;
> +
> +	mutex_lock(&st->trans_lock);
> +	while (n) {
> +		t = rb_entry(n, struct pohmelfs_trans, trans_node);
> +
> +		cmp = pohmelfs_trans_cmp(t, trans);
> +		if (cmp < 0) {
> +			n = n->rb_left;
> +		} else if (cmp > 0)
> +			n = n->rb_right;
> +		else {
> +			found = t;
> +			kref_get(&t->refcnt);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&st->trans_lock);
> +
> +	return found;
> +}
> +
> +int pohmelfs_send_buf_single(struct pohmelfs_io *pio, struct pohmelfs_state *st)
> +{
> +	struct pohmelfs_inode *pi = pio->pi;
> +	struct inode *inode = &pi->vfs_inode;
> +	struct pohmelfs_sb *psb = pohmelfs_sb(inode->i_sb);
> +	struct pohmelfs_trans *t;
> +	struct dnet_cmd *cmd;
> +	struct dnet_attr *attr;
> +	int err;
> +
> +	t = pohmelfs_trans_alloc(inode);
> +	if (IS_ERR(t)) {
> +		err = PTR_ERR(t);
> +		goto err_out_exit;
> +	}
> +
> +	if (!st) {
> +		st = pohmelfs_state_lookup(psb, pio->id, pio->group_id, pio->size);
> +		if (!st) {
> +			err = -ENOENT;
> +			goto err_out_free;
> +		}
> +	} else {
> +		pohmelfs_state_get(st);
> +	}
> +
> +	t->st = st;
> +	pohmelfs_state_get(st);
> +
> +	cmd = &t->cmd.cmd;
> +	attr = &t->cmd.attr;
> +
> +	dnet_setup_id(&cmd->id, st->group_id, pio->id->id);
> +	cmd->flags = pio->cflags;
> +	cmd->trans = t->trans = atomic_long_inc_return(&psb->trans);
> +	cmd->size = pio->size + sizeof(struct dnet_attr);
> +
> +	attr->cmd = pio->cmd;
> +	attr->size = pio->size;
> +	attr->flags = pio->aflags;
> +
> +	t->header_size = sizeof(struct dnet_cmd) + sizeof(struct dnet_attr);
> +	t->data_size = pio->size;
> +
> +	dnet_convert_cmd(cmd);
> +	dnet_convert_attr(attr);
> +
> +	if (pio->data) {
> +		if (pio->alloc_flags & POHMELFS_IO_OWN) {
> +			t->data = pio->data;
> +		} else {
> +			t->data = kmalloc(pio->size, GFP_NOIO);
> +			if (!t->data) {
> +				err = -ENOMEM;
> +				goto err_out_put_state;
> +			}
> +
> +			memcpy(t->data, pio->data, pio->size);
> +		}
> +	}
> +
> +	err = pohmelfs_init_callbacks(t, pio);
> +	if (err)
> +		goto err_out_put_state;
> +
> +	return 0;
> +
> +err_out_put_state:
> +	pohmelfs_state_put(t->st);
> +err_out_free:
> +	pohmelfs_trans_free(t);
> +err_out_exit:
> +	return err;
> +}
> +
> +int pohmelfs_send_buf(struct pohmelfs_io *pio)
> +{
> +	struct pohmelfs_sb *psb = pohmelfs_sb(pio->pi->vfs_inode.i_sb);
> +	int i, err, err_num;
> +
> +	err = -ENOENT;
> +	err_num = 0;
> +
> +	for (i = 0; i < psb->group_num; ++i) {
> +		pio->group_id = psb->groups[i];
> +
> +		err = pohmelfs_send_buf_single(pio, NULL);
> +		if (err)
> +			err_num++;
> +	}
> +
> +	return (err_num == psb->group_num) ? err : 0;
> +}
> 
> 
> -- 
> 	Evgeniy Polyakov

-- 
	Evgeniy Polyakov
