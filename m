Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384Ab0KPMZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:25:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:51074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933374Ab0KPMZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:25:08 -0500
Date: Tue, 16 Nov 2010 13:25:03 +0100
From: Jan Kara <jack@suse.cz>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, linux-fsdevel@vger.kernel.org,
        tvrtko.ursulin@sophos.com, agruen@suse.de, stefan@buettcher.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fsnotify: Tell the user what part of the file
 might have changed
Message-ID: <20101116122503.GF4757@quack.suse.cz>
References: <20101115004134.9618.6393.stgit@zaytsev.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115004134.9618.6393.stgit@zaytsev.su>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Mon 15-11-10 00:44:08, Alexey Zaytsev wrote:
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> ---
> 
> Hi.
> 
> The patch adds fschange-like [1] modification ranges to
> fsnotify events. Fanotify is made to pass the range
> to the users.
  What I always found a bit awkward about inotify/fanotify is that you get
no notification if the file modification happens via mmap(). For backup
programs this is certainly unacceptable so you have to track open events
and check mtime anyway because of this.

We could start sending MODIFY events when writeable mmap happens (IMHO a
sensible thing to do) but with ranges you have to watch out to send a
range like 0..((1<<64)-1) to accommodate future file changes.

								Honza
> 
> This is useful for backup programs that work on huge files,
> so that only a part of a modified file needs to be scanned
> for changes.
> 
> Looking forwar for your coments on the approach.
> 
> You can also get the patch from
> git://git.zaytsev.su/git/linux-2.6.git branch fsnotify
> 
> A modified fanotify-example is available from
> 
> git://git.zaytsev.su/git/fanotify-example.git branch range
> 
> [1] http://www.stefan.buettcher.org/cs/fschange/index.html
> 
>  fs/nfsd/vfs.c                      |    2 +
>  fs/notify/fanotify/fanotify_user.c |   36 +++++++++++++++++++++--
>  fs/notify/fsnotify.c               |   16 ++++++----
>  fs/notify/inode_mark.c             |    2 +
>  fs/notify/inotify/inotify_user.c   |    2 +
>  fs/notify/notification.c           |    8 ++++-
>  fs/open.c                          |    2 +
>  fs/read_write.c                    |    4 +--
>  include/linux/fanotify.h           |   15 +++++++++-
>  include/linux/fs.h                 |   10 ++++++
>  include/linux/fsnotify.h           |   56 ++++++++++++++++++++++++++----------
>  include/linux/fsnotify_backend.h   |   12 ++++++--
>  12 files changed, 128 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 184938f..d781014 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1035,7 +1035,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
>  		goto out_nfserr;
>  	*cnt = host_err;
>  	nfsdstats.io_write += host_err;
> -	fsnotify_modify(file);
> +	fsnotify_modify(file, offset - host_err, host_err);
>  
>  	/* clear setuid/setgid flag after write */
>  	if (inode->i_mode & (S_ISUID | S_ISGID))
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 0632248..5d75dfa 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -31,6 +31,26 @@ struct fanotify_response_event {
>  	struct fsnotify_event *event;
>  };
>  
> +#ifdef DEBUG
> +static inline void dump_event_meta(const char *str, struct fanotify_event_metadata *meta)
> +{
> +	if (meta->mask & (FAN_MODIFY | FAN_CLOSE_WRITE))
> +		printk("%s event_len=%d vers=%d mask=0x%lld fd=%d pid=%d"
> +				" range_start=%lld range_end=%lld\n", str,
> +				meta->event_len, meta->vers, meta->mask,
> +				meta->fd, meta->pid, meta->range.start,
> +				meta->range.end);
> +	else
> +		printk("%s event_len=%d vers=%d mask=0x%lld fd=%d pid=%d", str,
> +				meta->event_len, meta->vers, meta->mask,
> +				meta->fd, meta->pid);
> +}
> +#else
> +static inline void dump_event_meta(const char *str, struct fanotify_event_metadata *meta)
> +{
> +}
> +#endif
> +
>  /*
>   * Get an fsnotify notification event if one exists and is small
>   * enough to fit in "count". Return an error pointer if the count
> @@ -113,12 +133,20 @@ static ssize_t fill_event_metadata(struct fsnotify_group *group,
>  	pr_debug("%s: group=%p metadata=%p event=%p\n", __func__,
>  		 group, metadata, event);
>  
> -	metadata->event_len = FAN_EVENT_METADATA_LEN;
> +	if (event->mask & (FS_MODIFY | FS_CLOSE_WRITE)) {
> +		metadata->event_len = FAN_RANGE_EVENT_METADATA_LEN;
> +		metadata->range.start = event->range.start;
> +		metadata->range.end = event->range.end;
> +	} else {
> +		metadata->event_len = FAN_EVENT_METADATA_LEN;
> +	}
> +
>  	metadata->vers = FANOTIFY_METADATA_VERSION;
>  	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
>  	metadata->pid = pid_vnr(event->tgid);
>  	metadata->fd = create_fd(group, event);
>  
> +
>  	return metadata->fd;
>  }
>  
> @@ -266,10 +294,12 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
>  		goto out_close_fd;
>  
>  	ret = -EFAULT;
> -	if (copy_to_user(buf, &fanotify_event_metadata, FAN_EVENT_METADATA_LEN))
> +	if (copy_to_user(buf, &fanotify_event_metadata, fanotify_event_metadata.event_len))
>  		goto out_kill_access_response;
>  
> -	return FAN_EVENT_METADATA_LEN;
> +	dump_event_meta("copy_event_to_user: ", &fanotify_event_metadata);
> +
> +	return fanotify_event_metadata.event_len;
>  
>  out_kill_access_response:
>  	remove_access_response(group, event, fd);
> diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
> index 20dc218..81444c2 100644
> --- a/fs/notify/fsnotify.c
> +++ b/fs/notify/fsnotify.c
> @@ -108,10 +108,10 @@ int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
>  
>  		if (path)
>  			ret = fsnotify(p_inode, mask, path, FSNOTIFY_EVENT_PATH,
> -				       dentry->d_name.name, 0);
> +				       dentry->d_name.name, 0, NULL);
>  		else
>  			ret = fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
> -				       dentry->d_name.name, 0);
> +				       dentry->d_name.name, 0, NULL);
>  	}
>  
>  	dput(parent);
> @@ -126,6 +126,7 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
>  			 __u32 mask, void *data,
>  			 int data_is, u32 cookie,
>  			 const unsigned char *file_name,
> +			 struct fsnotify_range *range,
>  			 struct fsnotify_event **event)
>  {
>  	struct fsnotify_group *group = NULL;
> @@ -183,7 +184,7 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
>  	if (!*event) {
>  		*event = fsnotify_create_event(to_tell, mask, data,
>  						data_is, file_name,
> -						cookie, GFP_KERNEL);
> +						cookie, range, GFP_KERNEL);
>  		if (!*event)
>  			return -ENOMEM;
>  	}
> @@ -197,7 +198,8 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
>   * notification event in whatever means they feel necessary.
>   */
>  int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
> -	     const unsigned char *file_name, u32 cookie)
> +	     const unsigned char *file_name, u32 cookie,
> +	     struct fsnotify_range *range)
>  {
>  	struct hlist_node *inode_node = NULL, *vfsmount_node = NULL;
>  	struct fsnotify_mark *inode_mark = NULL, *vfsmount_mark = NULL;
> @@ -256,17 +258,17 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
>  		if (inode_group > vfsmount_group) {
>  			/* handle inode */
>  			ret = send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
> -					    data_is, cookie, file_name, &event);
> +					    data_is, cookie, file_name, range, &event);
>  			/* we didn't use the vfsmount_mark */
>  			vfsmount_group = NULL;
>  		} else if (vfsmount_group > inode_group) {
>  			ret = send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
> -					    data_is, cookie, file_name, &event);
> +					    data_is, cookie, file_name, range, &event);
>  			inode_group = NULL;
>  		} else {
>  			ret = send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
>  					    mask, data, data_is, cookie, file_name,
> -					    &event);
> +					    range, &event);
>  		}
>  
>  		if (ret && (mask & ALL_FSNOTIFY_PERM_EVENTS))
> diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
> index 4c29fcf..cd39df7 100644
> --- a/fs/notify/inode_mark.c
> +++ b/fs/notify/inode_mark.c
> @@ -295,7 +295,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
>  			iput(need_iput_tmp);
>  
>  		/* for each watch, send FS_UNMOUNT and then remove it */
> -		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> +		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
>  
>  		fsnotify_inode_delete(inode);
>  
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index 444c305..a5c2c69 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -524,7 +524,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
>  
>  	ignored_event = fsnotify_create_event(NULL, FS_IN_IGNORED, NULL,
>  					      FSNOTIFY_EVENT_NONE, NULL, 0,
> -					      GFP_NOFS);
> +					      NULL, GFP_NOFS);
>  	if (!ignored_event)
>  		return;
>  
> diff --git a/fs/notify/notification.c b/fs/notify/notification.c
> index f39260f..29b989f 100644
> --- a/fs/notify/notification.c
> +++ b/fs/notify/notification.c
> @@ -395,7 +395,8 @@ struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event)
>   */
>  struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data,
>  					     int data_type, const unsigned char *name,
> -					     u32 cookie, gfp_t gfp)
> +					     u32 cookie, struct fsnotify_range *range,
> +					     gfp_t gfp)
>  {
>  	struct fsnotify_event *event;
>  
> @@ -421,6 +422,9 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
>  	event->sync_cookie = cookie;
>  	event->to_tell = to_tell;
>  	event->data_type = data_type;
> +	/* The range struct might be allocated on stack. */
> +	if (range)
> +		event->range = *range;
>  
>  	switch (data_type) {
>  	case FSNOTIFY_EVENT_PATH: {
> @@ -453,7 +457,7 @@ __init int fsnotify_notification_init(void)
>  	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
>  
>  	q_overflow_event = fsnotify_create_event(NULL, FS_Q_OVERFLOW, NULL,
> -						 FSNOTIFY_EVENT_NONE, NULL, 0,
> +						 FSNOTIFY_EVENT_NONE, NULL, 0, NULL,
>  						 GFP_KERNEL);
>  	if (!q_overflow_event)
>  		panic("unable to allocate fsnotify q_overflow_event\n");
> diff --git a/fs/open.c b/fs/open.c
> index 4197b9e..b3c5b0a 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -675,6 +675,8 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
>  	f->f_path.mnt = mnt;
>  	f->f_pos = 0;
>  	f->f_op = fops_get(inode->i_fop);
> +	f->f_whatchanged.start = -1;
> +	f->f_whatchanged.end = 0;
>  	file_sb_list_add(f, inode->i_sb);
>  
>  	error = security_dentry_open(f, cred);
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 431a0ed..913915d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -384,7 +384,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
>  		else
>  			ret = do_sync_write(file, buf, count, pos);
>  		if (ret > 0) {
> -			fsnotify_modify(file);
> +			fsnotify_modify(file, (*pos) - ret, ret);
>  			add_wchar(current, ret);
>  		}
>  		inc_syscw(current);
> @@ -700,7 +700,7 @@ out:
>  		if (type == READ)
>  			fsnotify_access(file);
>  		else
> -			fsnotify_modify(file);
> +			fsnotify_modify(file, (*pos) - ret, ret);
>  	}
>  	return ret;
>  }
> diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
> index 0f01214..a599517 100644
> --- a/include/linux/fanotify.h
> +++ b/include/linux/fanotify.h
> @@ -91,6 +91,14 @@ struct fanotify_event_metadata {
>  	__aligned_u64 mask;
>  	__s32 fd;
>  	__s32 pid;
> +
> +	/* Optional. Check event_len.*/
> +	union {
> +		struct {
> +			__aligned_u64 start;
> +			__aligned_u64 end;
> +		} range;
> +	};
>  };
>  
>  struct fanotify_response {
> @@ -102,8 +110,13 @@ struct fanotify_response {
>  #define FAN_ALLOW	0x01
>  #define FAN_DENY	0x02
>  
> +#ifndef __KERNEL__
> +#include <stddef.h> /* For the userspace offsetof */
> +#endif
> +
>  /* Helper functions to deal with fanotify_event_metadata buffers */
> -#define FAN_EVENT_METADATA_LEN (sizeof(struct fanotify_event_metadata))
> +#define FAN_EVENT_METADATA_LEN (offsetof(struct fanotify_event_metadata, range))
> +#define FAN_RANGE_EVENT_METADATA_LEN (sizeof(struct fanotify_event_metadata))
>  
>  #define FAN_EVENT_NEXT(meta, len) ((len) -= (meta)->event_len, \
>  				   (struct fanotify_event_metadata*)(((char *)(meta)) + \
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 334d68a..702d360 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -922,6 +922,12 @@ static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
>  		index <  ra->start + ra->size);
>  }
>  
> +/* fsnotify wants to know, what has been changed during the file's lifetime. */
> +struct fsnotify_range {
> +	loff_t start;
> +	loff_t end;
> +};
> +
>  #define FILE_MNT_WRITE_TAKEN	1
>  #define FILE_MNT_WRITE_RELEASED	2
>  
> @@ -965,6 +971,10 @@ struct file {
>  #ifdef CONFIG_DEBUG_WRITECOUNT
>  	unsigned long f_mnt_write_state;
>  #endif
> +
> +#ifdef CONFIG_FSNOTIFY
> +	struct fsnotify_range f_whatchanged;
> +#endif
>  };
>  
>  #define get_file(x)	atomic_long_inc(&(x)->f_count)
> diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> index 5c185fa..5c5cbaa 100644
> --- a/include/linux/fsnotify.h
> +++ b/include/linux/fsnotify.h
> @@ -57,7 +57,8 @@ static inline int fsnotify_perm(struct file *file, int mask)
>  	if (ret)
>  		return ret;
>  
> -	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
> +	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH,
> +			NULL, 0, NULL);
>  }
>  
>  /*
> @@ -78,7 +79,7 @@ static inline void fsnotify_d_move(struct dentry *dentry)
>   */
>  static inline void fsnotify_link_count(struct inode *inode)
>  {
> -	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> +	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
>  }
>  
>  /*
> @@ -102,14 +103,17 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
>  		new_dir_mask |= FS_ISDIR;
>  	}
>  
> -	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE, old_name, fs_cookie);
> -	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE, new_name, fs_cookie);
> +	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE,
> +			old_name, fs_cookie, NULL);
> +	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE,
> +			new_name, fs_cookie, NULL);
>  
>  	if (target)
>  		fsnotify_link_count(target);
>  
>  	if (source)
> -		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> +		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE,
> +				NULL, 0, NULL);
>  	audit_inode_child(moved, new_dir);
>  }
>  
> @@ -147,7 +151,7 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
>   */
>  static inline void fsnotify_inoderemove(struct inode *inode)
>  {
> -	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> +	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
>  	__fsnotify_inode_delete(inode);
>  }
>  
> @@ -158,7 +162,8 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
>  {
>  	audit_inode_child(dentry, inode);
>  
> -	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
> +	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE,
> +			dentry->d_name.name, 0, NULL);
>  }
>  
>  /*
> @@ -171,7 +176,8 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
>  	fsnotify_link_count(inode);
>  	audit_inode_child(new_dentry, dir);
>  
> -	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE, new_dentry->d_name.name, 0);
> +	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE,
> +			new_dentry->d_name.name, 0, NULL);
>  }
>  
>  /*
> @@ -184,7 +190,8 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
>  
>  	audit_inode_child(dentry, inode);
>  
> -	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);
> +	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE,
> +			dentry->d_name.name, 0, NULL);
>  }
>  
>  /*
> @@ -201,25 +208,41 @@ static inline void fsnotify_access(struct file *file)
>  
>  	if (!(file->f_mode & FMODE_NONOTIFY)) {
>  		fsnotify_parent(path, NULL, mask);
> -		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
> +		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0, NULL);
>  	}
>  }
>  
> +static inline void fsnotify_update_range(struct file *f, loff_t orig_fpos, size_t len)
> +{
> +	/* -1 => first modification. */
> +	if (f->f_whatchanged.start == -1)
> +		f->f_whatchanged.start = orig_fpos;
> +	else
> +		f->f_whatchanged.start = min(orig_fpos, f->f_whatchanged.start);
> +
> +	f->f_whatchanged.end = max(orig_fpos + len, f->f_whatchanged.start);
> +}
> +
>  /*
>   * fsnotify_modify - file was modified
>   */
> -static inline void fsnotify_modify(struct file *file)
> +static inline void fsnotify_modify(struct file *file, loff_t original, size_t count) 
>  {
>  	struct path *path = &file->f_path;
>  	struct inode *inode = path->dentry->d_inode;
>  	__u32 mask = FS_MODIFY;
> +	struct fsnotify_range range = {
> +		.start = original,
> +		.end = original + count,
> +	};
>  
> +	fsnotify_update_range(file, original, count);
>  	if (S_ISDIR(inode->i_mode))
>  		mask |= FS_ISDIR;
>  
>  	if (!(file->f_mode & FMODE_NONOTIFY)) {
>  		fsnotify_parent(path, NULL, mask);
> -		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
> +		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0, &range);
>  	}
>  }
>  
> @@ -239,7 +262,7 @@ static inline void fsnotify_open(struct file *file)
>  	file->f_mode &= ~FMODE_NONOTIFY;
>  
>  	fsnotify_parent(path, NULL, mask);
> -	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
> +	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0, NULL);
>  }
>  
>  /*
> @@ -257,7 +280,8 @@ static inline void fsnotify_close(struct file *file)
>  
>  	if (!(file->f_mode & FMODE_NONOTIFY)) {
>  		fsnotify_parent(path, NULL, mask);
> -		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
> +		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH,
> +				NULL, 0, &file->f_whatchanged);
>  	}
>  }
>  
> @@ -273,7 +297,7 @@ static inline void fsnotify_xattr(struct dentry *dentry)
>  		mask |= FS_ISDIR;
>  
>  	fsnotify_parent(NULL, dentry, mask);
> -	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> +	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
>  }
>  
>  /*
> @@ -308,7 +332,7 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
>  			mask |= FS_ISDIR;
>  
>  		fsnotify_parent(NULL, dentry, mask);
> -		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
> +		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
>  	}
>  }
>  
> diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
> index 0a68f92..5348b54 100644
> --- a/include/linux/fsnotify_backend.h
> +++ b/include/linux/fsnotify_backend.h
> @@ -240,6 +240,8 @@ struct fsnotify_event {
>  	size_t name_len;
>  	struct pid *tgid;
>  
> +	struct fsnotify_range range; /* What has been modified */
> +
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
>  	__u32 response;	/* userspace answer to question */
>  #endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
> @@ -305,7 +307,8 @@ struct fsnotify_mark {
>  
>  /* main fsnotify call to send events */
>  extern int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
> -		    const unsigned char *name, u32 cookie);
> +		    const unsigned char *name, u32 cookie,
> +		    struct fsnotify_range *range);
>  extern int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask);
>  extern void __fsnotify_inode_delete(struct inode *inode);
>  extern void __fsnotify_vfsmount_delete(struct vfsmount *mnt);
> @@ -420,7 +423,9 @@ extern void fsnotify_unmount_inodes(struct list_head *list);
>  extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
>  						    void *data, int data_is,
>  						    const unsigned char *name,
> -						    u32 cookie, gfp_t gfp);
> +						    u32 cookie,
> +						    struct fsnotify_range *range,
> +						    gfp_t gfp);
>  
>  /* fanotify likes to change events after they are on lists... */
>  extern struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event);
> @@ -430,7 +435,8 @@ extern int fsnotify_replace_event(struct fsnotify_event_holder *old_holder,
>  #else
>  
>  static inline int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
> -			   const unsigned char *name, u32 cookie)
> +			   const unsigned char *name, u32 cookie,
> +			   struct fsnotify_range *range)
>  {
>  	return 0;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
