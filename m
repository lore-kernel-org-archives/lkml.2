Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2DRS4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:56:21 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:43787 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2DRS4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:56:20 -0400
Date: Wed, 18 Apr 2012 18:57:17 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 25/43] userns: Store uid and gid types in vfs
 structures with kuid_t and kgid_t types
Message-ID: <20120418185717.GB5186@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-25-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-25-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> The conversion of all of the users is not done yet there are too many to change
> in one go and leave the code reviewable. For now I change just the header and
> a few trivial users and rely on CONFIG_UIDGID_STRICT_TYPE_CHECKS not being set
> to ensure that the code will still compile during the transition.
> 
> Helper functions i_uid_read, i_uid_write, i_gid_read, i_gid_write are added
> so that in most cases filesystems can avoid the complexities of multiple user
> namespaces and can concentrate on moving their raw numeric values into and
> out of the vfs data structures.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/inode.c         |    6 +++---
>  include/linux/fs.h |   36 +++++++++++++++++++++++++++++++-----
>  2 files changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index f0c4ace..deb72f6 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -135,8 +135,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
>  	inode->i_fop = &empty_fops;
>  	inode->__i_nlink = 1;
>  	inode->i_opflags = 0;
> -	inode->i_uid = 0;
> -	inode->i_gid = 0;
> +	i_uid_write(inode, 0);
> +	i_gid_write(inode, 0);
>  	atomic_set(&inode->i_writecount, 0);
>  	inode->i_size = 0;
>  	inode->i_blocks = 0;
> @@ -1732,7 +1732,7 @@ EXPORT_SYMBOL(inode_init_owner);
>   */
>  bool inode_owner_or_capable(const struct inode *inode)
>  {
> -	if (current_fsuid() == inode->i_uid)
> +	if (uid_eq(current_fsuid(), inode->i_uid))
>  		return true;
>  	if (inode_capable(inode, CAP_FOWNER))
>  		return true;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a6c5efb..797eb26 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -402,6 +402,7 @@ struct inodes_stat_t {
>  #include <linux/atomic.h>
>  #include <linux/shrinker.h>
>  #include <linux/migrate_mode.h>
> +#include <linux/uidgid.h>
>  
>  #include <asm/byteorder.h>
>  
> @@ -469,8 +470,8 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  struct iattr {
>  	unsigned int	ia_valid;
>  	umode_t		ia_mode;
> -	uid_t		ia_uid;
> -	gid_t		ia_gid;
> +	kuid_t		ia_uid;
> +	kgid_t		ia_gid;
>  	loff_t		ia_size;
>  	struct timespec	ia_atime;
>  	struct timespec	ia_mtime;
> @@ -761,8 +762,8 @@ struct posix_acl;
>  struct inode {
>  	umode_t			i_mode;
>  	unsigned short		i_opflags;
> -	uid_t			i_uid;
> -	gid_t			i_gid;
> +	kuid_t			i_uid;
> +	kgid_t			i_gid;
>  	unsigned int		i_flags;
>  
>  #ifdef CONFIG_FS_POSIX_ACL
> @@ -927,6 +928,31 @@ static inline void i_size_write(struct inode *inode, loff_t i_size)
>  #endif
>  }
>  
> +/* Helper functions so that in most cases filesystems will
> + * not need to deal directly with kuid_t and kgid_t and can
> + * instead deal with the raw numeric values that are stored
> + * in the filesystem.
> + */
> +static inline uid_t i_uid_read(const struct inode *inode)
> +{
> +	return from_kuid(&init_user_ns, inode->i_uid);
> +}
> +
> +static inline gid_t i_gid_read(const struct inode *inode)
> +{
> +	return from_kgid(&init_user_ns, inode->i_gid);
> +}
> +
> +static inline void i_uid_write(struct inode *inode, uid_t uid)
> +{
> +	inode->i_uid = make_kuid(&init_user_ns, uid);
> +}
> +
> +static inline void i_gid_write(struct inode *inode, gid_t gid)
> +{
> +	inode->i_gid = make_kgid(&init_user_ns, gid);
> +}
> +
>  static inline unsigned iminor(const struct inode *inode)
>  {
>  	return MINOR(inode->i_rdev);
> @@ -943,7 +969,7 @@ struct fown_struct {
>  	rwlock_t lock;          /* protects pid, uid, euid fields */
>  	struct pid *pid;	/* pid or -pgrp where SIGIO should be sent */
>  	enum pid_type pid_type;	/* Kind of process group SIGIO should be sent to */
> -	uid_t uid, euid;	/* uid/euid of process setting the owner */
> +	kuid_t uid, euid;	/* uid/euid of process setting the owner */
>  	int signum;		/* posix.1b rt signal to be delivered on IO */
>  };
>  
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
