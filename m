Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab2IZRwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:52:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46816 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab2IZRwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:52:31 -0400
Date: Wed, 26 Sep 2012 12:52:24 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 10/14] userns: Convert s390 hypfs to use kuid and kgid
 where appropriate
Message-ID: <20120926175224.GC30620@sergelap>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
 <1348187330-6616-10-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348187330-6616-10-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  arch/s390/hypfs/inode.c |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
> index 6767b43..124ec1a 100644
> --- a/arch/s390/hypfs/inode.c
> +++ b/arch/s390/hypfs/inode.c
> @@ -31,8 +31,8 @@ static struct dentry *hypfs_create_update_file(struct super_block *sb,
>  					       struct dentry *dir);
>  
>  struct hypfs_sb_info {
> -	uid_t uid;			/* uid used for files and dirs */
> -	gid_t gid;			/* gid used for files and dirs */
> +	kuid_t uid;			/* uid used for files and dirs */
> +	kgid_t gid;			/* gid used for files and dirs */
>  	struct dentry *update_file;	/* file to trigger update */
>  	time_t last_update;		/* last update time in secs since 1970 */
>  	struct mutex lock;		/* lock to protect update process */
> @@ -229,6 +229,8 @@ static int hypfs_parse_options(char *options, struct super_block *sb)
>  {
>  	char *str;
>  	substring_t args[MAX_OPT_ARGS];
> +	kuid_t uid;
> +	kgid_t gid;
>  
>  	if (!options)
>  		return 0;
> @@ -243,12 +245,18 @@ static int hypfs_parse_options(char *options, struct super_block *sb)
>  		case opt_uid:
>  			if (match_int(&args[0], &option))
>  				return -EINVAL;
> -			hypfs_info->uid = option;
> +			uid = make_kuid(current_user_ns(), option);
> +			if (!uid_valid(uid))
> +				return -EINVAL;
> +			hypfs_info->uid = uid;
>  			break;
>  		case opt_gid:
>  			if (match_int(&args[0], &option))
>  				return -EINVAL;
> -			hypfs_info->gid = option;
> +			gid = make_kgid(current_user_ns(), option);
> +			if (!gid_valid(gid))
> +				return -EINVAL;
> +			hypfs_info->gid = gid;
>  			break;
>  		case opt_err:
>  		default:
> @@ -263,8 +271,8 @@ static int hypfs_show_options(struct seq_file *s, struct dentry *root)
>  {
>  	struct hypfs_sb_info *hypfs_info = root->d_sb->s_fs_info;
>  
> -	seq_printf(s, ",uid=%u", hypfs_info->uid);
> -	seq_printf(s, ",gid=%u", hypfs_info->gid);
> +	seq_printf(s, ",uid=%u", from_kuid_munged(&init_user_ns, hypfs_info->uid));
> +	seq_printf(s, ",gid=%u", from_kgid_munged(&init_user_ns, hypfs_info->gid));
>  	return 0;
>  }
>  
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
