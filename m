Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab0I2F1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:27:20 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36939 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0I2F1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:27:19 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V20 03/12] vfs: Add open by file handle support
In-Reply-To: <1285702610-32733-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1285702610-32733-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285702610-32733-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 29 Sep 2010 10:57:13 +0530
Message-ID: <m3pqvx86ha.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 01:06:41 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/compat.c              |   11 +++
>  fs/exportfs/expfs.c      |    2 +
>  fs/namei.c               |  223 +++++++++++++++++++++++++++++++++++++++++++---
>  fs/open.c                |   32 ++++++-
>  include/linux/fs.h       |   10 ++-
>  include/linux/namei.h    |    1 +
>  include/linux/syscalls.h |    3 +
>  7 files changed, 263 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/compat.c b/fs/compat.c
> index 0644a15..4a423fa 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -2334,3 +2334,14 @@ asmlinkage long compat_sys_timerfd_gettime(int ufd,
>  }
> 
>  #endif /* CONFIG_TIMERFD */
> +
> +/*
> + * Exactly like fs/open.c:sys_open_by_handle_at(), except that it
> + * doesn't set the O_LARGEFILE flag.
> + */
> +asmlinkage long
> +compat_sys_open_by_handle_at(int mountdirfd,
> +			     struct file_handle __user *handle, int flags)
> +{
> +	return do_handle_open(mountdirfd, handle, flags);
> +}
> diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
> index cfee0f0..05a1179 100644
> --- a/fs/exportfs/expfs.c
> +++ b/fs/exportfs/expfs.c
> @@ -373,6 +373,8 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
>  	/*
>  	 * Try to get any dentry for the given file handle from the filesystem.
>  	 */
> +	if (!nop || !nop->fh_to_dentry)
> +		return ERR_PTR(-ESTALE);
>  	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
>  	if (!result)
>  		result = ERR_PTR(-ESTALE);
> diff --git a/fs/namei.c b/fs/namei.c
> index 24896e8..3439962 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -32,6 +32,7 @@
>  #include <linux/fcntl.h>
>  #include <linux/device_cgroup.h>
>  #include <linux/fs_struct.h>
> +#include <linux/exportfs.h>
>  #include <asm/uaccess.h>
> 
>  #include "internal.h"
> @@ -1050,6 +1051,29 @@ out_fail:
>  	return retval;
>  }
> 
> +struct vfsmount *get_vfsmount_from_fd(int fd)
> +{
> +	int fput_needed;
> +	struct path path;
> +	struct file *filep;
> +
> +	if (fd == AT_FDCWD) {
> +		struct fs_struct *fs = current->fs;
> +		spin_lock(&fs->lock);
> +		path = fs->pwd;
> +		mntget(path.mnt);
> +		spin_lock(&fs->lock);

That should be spin_unlock.  A missing stg refresh before sending the
patch series. 

-aneesh
