Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0DBPWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:22:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0DBPWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:22:13 -0400
Message-ID: <4BB60BA9.20607@gmail.com>
Date: Fri, 02 Apr 2010 17:22:17 +0200
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: ReiserFS Devel <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 3/3] reiserfs: remove privroot hiding in lookup
References: <20090505193014.926371851@suse.com> <20090505193206.968741619@suse.com>
In-Reply-To: <20090505193206.968741619@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney wrote:
>  With Al Viro's patch to move privroot lookup to fs mount, there's no need
>  to have special code to hide the privroot in reiserfs_lookup.
>   

Jeff, this implication looks strange. IMHO Viro's patch just pins this in
the cache for mount session, while after your "cleanup" everyone can
walk here (including non-privileged users) and do what they want. Um?

Edward.

>  I've also cleaned up the privroot hiding in reiserfs_readdir_dentry and
>  removed the last user of reiserfs_xattrs().
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/reiserfs/dir.c              |   24 +++++++++++++-----------
>  fs/reiserfs/namei.c            |   17 ++---------------
>  fs/reiserfs/xattr.c            |    2 +-
>  include/linux/reiserfs_fs_sb.h |    1 -
>  4 files changed, 16 insertions(+), 28 deletions(-)
>
> --- a/fs/reiserfs/dir.c
> +++ b/fs/reiserfs/dir.c
> @@ -41,6 +41,18 @@ static int reiserfs_dir_fsync(struct fil
>  
>  #define store_ih(where,what) copy_item_head (where, what)
>  
> +static inline bool is_privroot_deh(struct dentry *dir,
> +				   struct reiserfs_de_head *deh)
> +{
> +	int ret = 0;
> +#ifdef CONFIG_REISERFS_FS_XATTR
> +	struct dentry *privroot = REISERFS_SB(dir->d_sb)->priv_root;
> +	ret = (dir == dir->d_parent && privroot->d_inode &&
> +	       deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
> +#endif
> +	return ret;
> +}
> +
>  int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
>  			   filldir_t filldir, loff_t *pos)
>  {
> @@ -138,18 +150,8 @@ int reiserfs_readdir_dentry(struct dentr
>  				}
>  
>  				/* Ignore the .reiserfs_priv entry */
> -				if (reiserfs_xattrs(inode->i_sb) &&
> -				    !old_format_only(inode->i_sb) &&
> -				    dentry == inode->i_sb->s_root &&
> -				    REISERFS_SB(inode->i_sb)->priv_root &&
> -				    REISERFS_SB(inode->i_sb)->priv_root->d_inode
> -				    && deh_objectid(deh) ==
> -				    le32_to_cpu(INODE_PKEY
> -						(REISERFS_SB(inode->i_sb)->
> -						 priv_root->d_inode)->
> -						k_objectid)) {
> +				if (is_privroot_deh(dentry, deh))
>  					continue;
> -				}
>  
>  				d_off = deh_offset(deh);
>  				*pos = d_off;
> --- a/fs/reiserfs/namei.c
> +++ b/fs/reiserfs/namei.c
> @@ -338,21 +338,8 @@ static struct dentry *reiserfs_lookup(st
>  				&path_to_entry, &de);
>  	pathrelse(&path_to_entry);
>  	if (retval == NAME_FOUND) {
> -		/* Hide the .reiserfs_priv directory */
> -		if (reiserfs_xattrs(dir->i_sb) &&
> -		    !old_format_only(dir->i_sb) &&
> -		    REISERFS_SB(dir->i_sb)->priv_root &&
> -		    REISERFS_SB(dir->i_sb)->priv_root->d_inode &&
> -		    de.de_objectid ==
> -		    le32_to_cpu(INODE_PKEY
> -				(REISERFS_SB(dir->i_sb)->priv_root->d_inode)->
> -				k_objectid)) {
> -			reiserfs_write_unlock(dir->i_sb);
> -			return ERR_PTR(-EACCES);
> -		}
> -
> -		inode =
> -		    reiserfs_iget(dir->i_sb, (struct cpu_key *)&(de.de_dir_id));
> +		inode = reiserfs_iget(dir->i_sb,
> +				      (struct cpu_key *)&(de.de_dir_id));
>  		if (!inode || IS_ERR(inode)) {
>  			reiserfs_write_unlock(dir->i_sb);
>  			return ERR_PTR(-EACCES);
> --- a/fs/reiserfs/xattr.c
> +++ b/fs/reiserfs/xattr.c
> @@ -841,7 +841,7 @@ ssize_t reiserfs_listxattr(struct dentry
>  	if (!dentry->d_inode)
>  		return -EINVAL;
>  
> -	if (!reiserfs_xattrs(dentry->d_sb) ||
> +	if (!dentry->d_sb->s_xattr ||
>  	    get_inode_sd_version(dentry->d_inode) == STAT_DATA_V1)
>  		return -EOPNOTSUPP;
>  
> --- a/include/linux/reiserfs_fs_sb.h
> +++ b/include/linux/reiserfs_fs_sb.h
> @@ -488,7 +488,6 @@ enum reiserfs_mount_options {
>  #define reiserfs_data_log(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_DATA_LOG))
>  #define reiserfs_data_ordered(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_DATA_ORDERED))
>  #define reiserfs_data_writeback(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_DATA_WRITEBACK))
> -#define reiserfs_xattrs(s) ((s)->s_xattr != NULL)
>  #define reiserfs_xattrs_user(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_XATTRS_USER))
>  #define reiserfs_posixacl(s) (REISERFS_SB(s)->s_mount_opt & (1 << REISERFS_POSIXACL))
>  #define reiserfs_xattrs_optional(s) (reiserfs_xattrs_user(s) || reiserfs_posixacl(s))
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

