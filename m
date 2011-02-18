Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1BRB3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:29:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33492 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1BRB3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:29:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150406.GI26395@mail.hallyn.com>
Date: Thu, 17 Feb 2011 17:29:32 -0800
In-Reply-To: <20110217150406.GI26395@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 17 Feb 2011 15:04:07 +0000")
Message-ID: <m14o82dtab.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19UzYMoBIfNUjdNtkCCzQ1YcAYuqLoTX9U=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 9/9] userns: check user namespace for task->file uid equivalence checks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Cheat for now and say all files belong to init_user_ns.  Next
> step will be to let superblocks belong to a user_ns, and derive
> inode_userns(inode) from inode->i_sb->s_user_ns.  Finally we'll
> introduce more flexible arrangements.

This looks good.  I am a little worried that a concept like
inode_user_ns will imply that there is only ever one.

However this looks like a good place to start and it will only
be strange filesystems that implement a notion of permissions
that is namespace aware so I don't expect the generic code
needs to handle that case other than allowing the permission checks
to be overridden.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Changelog:
> 	Feb 15: make is_owner_or_cap take const struct inode
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  fs/inode.c         |   17 +++++++++++++++++
>  fs/namei.c         |   20 +++++++++++++++-----
>  include/linux/fs.h |    9 +++++++--
>  3 files changed, 39 insertions(+), 7 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index da85e56..1930b45 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -25,6 +25,7 @@
>  #include <linux/async.h>
>  #include <linux/posix_acl.h>
>  #include <linux/ima.h>
> +#include <linux/cred.h>
>  
>  /*
>   * This is needed for the following functions:
> @@ -1722,3 +1723,19 @@ void inode_init_owner(struct inode *inode, const struct inode *dir,
>  	inode->i_mode = mode;
>  }
>  EXPORT_SYMBOL(inode_init_owner);
> +
> +/*
> + * return 1 if current either has CAP_FOWNER to the
> + * file, or owns the file.
> + */
> +int is_owner_or_cap(const struct inode *inode)
> +{
> +	struct user_namespace *ns = inode_userns(inode);
> +
> +	if (current_user_ns() == ns && current_fsuid() == inode->i_uid)
> +		return 1;
> +	if (ns_capable(ns, CAP_FOWNER))
> +		return 1;
> +	return 0;
> +}
> +EXPORT_SYMBOL(is_owner_or_cap);
> diff --git a/fs/namei.c b/fs/namei.c
> index 9e701e2..cfac5b4 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -176,6 +176,9 @@ static int acl_permission_check(struct inode *inode, int mask, unsigned int flag
>  
>  	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
>  
> +	if (current_user_ns() != inode_userns(inode))
> +		goto other_perms;
> +
>  	if (current_fsuid() == inode->i_uid)
>  		mode >>= 6;
>  	else {
> @@ -189,6 +192,7 @@ static int acl_permission_check(struct inode *inode, int mask, unsigned int flag
>  			mode >>= 3;
>  	}
>  
> +other_perms:
>  	/*
>  	 * If the DACs are ok we don't need any capability check.
>  	 */
> @@ -230,7 +234,7 @@ int generic_permission(struct inode *inode, int mask, unsigned int flags,
>  	 * Executable DACs are overridable if at least one exec bit is set.
>  	 */
>  	if (!(mask & MAY_EXEC) || execute_ok(inode))
> -		if (capable(CAP_DAC_OVERRIDE))
> +		if (ns_capable(inode_userns(inode), CAP_DAC_OVERRIDE))
>  			return 0;
>  
>  	/*
> @@ -238,7 +242,7 @@ int generic_permission(struct inode *inode, int mask, unsigned int flags,
>  	 */
>  	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
>  	if (mask == MAY_READ || (S_ISDIR(inode->i_mode) && !(mask & MAY_WRITE)))
> -		if (capable(CAP_DAC_READ_SEARCH))
> +		if (ns_capable(inode_userns(inode), CAP_DAC_READ_SEARCH))
>  			return 0;
>  
>  	return -EACCES;
> @@ -675,6 +679,7 @@ force_reval_path(struct path *path, struct nameidata *nd)
>  static inline int exec_permission(struct inode *inode, unsigned int flags)
>  {
>  	int ret;
> +	struct user_namespace *ns = inode_userns(inode);
>  
>  	if (inode->i_op->permission) {
>  		ret = inode->i_op->permission(inode, MAY_EXEC, flags);
> @@ -687,7 +692,7 @@ static inline int exec_permission(struct inode *inode, unsigned int flags)
>  	if (ret == -ECHILD)
>  		return ret;
>  
> -	if (capable(CAP_DAC_OVERRIDE) || capable(CAP_DAC_READ_SEARCH))
> +	if (ns_capable(ns, CAP_DAC_OVERRIDE) || ns_capable(ns, CAP_DAC_READ_SEARCH))
>  		goto ok;
>  
>  	return ret;
> @@ -1940,11 +1945,15 @@ static inline int check_sticky(struct inode *dir, struct inode *inode)
>  
>  	if (!(dir->i_mode & S_ISVTX))
>  		return 0;
> +	if (current_user_ns() != inode_userns(inode))
> +		goto other_userns;
>  	if (inode->i_uid == fsuid)
>  		return 0;
>  	if (dir->i_uid == fsuid)
>  		return 0;
> -	return !capable(CAP_FOWNER);
> +
> +other_userns:
> +	return !ns_capable(inode_userns(inode), CAP_FOWNER);
>  }
>  
>  /*
> @@ -2635,7 +2644,8 @@ int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
>  	if (error)
>  		return error;
>  
> -	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
> +	if ((S_ISCHR(mode) || S_ISBLK(mode)) &&
> +	    !ns_capable(inode_userns(dir), CAP_MKNOD))
>  		return -EPERM;
>  
>  	if (!dir->i_op->mknod)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bd32159..c84417a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1446,8 +1446,13 @@ enum {
>  #define put_fs_excl() atomic_dec(&current->fs_excl)
>  #define has_fs_excl() atomic_read(&current->fs_excl)
>  
> -#define is_owner_or_cap(inode)	\
> -	((current_fsuid() == (inode)->i_uid) || capable(CAP_FOWNER))
> +/*
> + * until VFS tracks user namespaces for inodes, just make all files
> + * belong to init_user_ns
> + */
> +extern struct user_namespace init_user_ns;
> +#define inode_userns(inode) (&init_user_ns)
> +extern int is_owner_or_cap(const struct inode *inode);
>  
>  /* not quite ready to be deprecated, but... */
>  extern void lock_super(struct super_block *);
