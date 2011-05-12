Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab1ELEUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 00:20:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1ELEUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 00:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Ah/ozBIyyczC1zCY7fL+M/JxiTxH/Cz5DEIqnfa55zYnr5o2+64VYCh8ilwZa3Ridn
         XY9p8Wwl6n+LZ4Zx9M2Q==
Date: Wed, 11 May 2011 21:20:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Miklos Szeredi <miklos@szeredi.hu>
cc: Michal Suchanek <hramrach@centrum.cz>, Andreas Dilger <adilger@dilger.ca>,
        Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
In-Reply-To: <87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
Message-ID: <alpine.LSU.2.00.1105112023560.1424@sister.anvils>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
 <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com> <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com> <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com> <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com> <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
 <C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca> <BANLkTinMNL8Q+_MCHDqAGSdYNAvHB2GdLw@mail.gmail.com> <87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

I understand from the mm-commits discussion that you're probably
preparing another version: so let me make just a few comments
on this old one now, in case you can factor them in.

On Tue, 19 Apr 2011, Miklos Szeredi wrote:

> Michal Suchanek <hramrach@centrum.cz> writes:
> > Applying this patch is not sufficient. Apparently more xattrs are
> > needed but adding them on top of this patch should be easy.
> >
> > The ones mentioned in the overlayfs doc are
> >
> > trusted.overlay.whiteout
> > trusted.overlay.opaque
> >
> > The patch implements security.*
> 
> Here's an updated patch.  It changes a number of things:
> 
>  - it implements shmem specific xattr ops instead of using the generic_*
>    functions.  Which means that there's no back and forth between the
>    VFS and the filesystem.  I basically copied the btrfs way of doing
>    things.
> 
>  - adds a new config option: CONFIG_TMPFS_XATTR and makes
>    CONFIG_TMPFS_POSIX_ACL depend on this.  This way xattr support can be
>    turned on without also adding ACL support.
> 
>  - now supports trusted.* namespace needed by overlayfs in addition to
>    security.*.  Doesn't yet support user.* since that needs more thought
>    wrt. kernel memory use.
> 
>  - supports xattrs on symlinks, again needed by overlayfs
> 
> Hugh, Eric, does this look acceptable?

Pretty much, I think.  As ever I'm somewhat bemused by these xattrs,
so don't count too much on my opinion.  But if it looks good to xattr
people, then it's welcome in tmpfs - thank you.  Eric's ack would be good.

Just a few comments...

> 
> Thanks,
> Miklos
> 
> ---
> From: Eric Paris <eparis@redhat.com>
> Subject: tmpfs: implement generic xattr support
> 
> This patch implements generic xattrs for tmpfs filesystems.  The feodra
> project, while trying to replace suid apps with file capabilities,
> realized that tmpfs, which is used on the build systems, does not
> support file capabilities and thus cannot be used to build packages
> which use file capabilities.  Xattrs are also needed for overlayfs.
> 
> The xattr interface is a bit, odd.  If a filesystem does not implement any
> {get,set,list}xattr functions the VFS will call into some random LSM hooks and
> the running LSM can then implement some method for handling xattrs.  SELinux
> for example provides a method to support security.selinux but no other
> security.* xattrs.
> 
> As it stands today when one enables CONFIG_TMPFS_POSIX_ACL tmpfs will have
> xattr handler routines specifically to handle acls.  Because of this tmpfs
> would loose the VFS/LSM helpers to support the running LSM.  To make up for
> that tmpfs had stub functions that did nothing but call into the LSM hooks
> which implement the helpers.
> 
> This new patch does not use the LSM fallback functions and instead
> just implements a native get/set/list xattr feature for the full
> security.* and trusted.* namespace like a normal filesystem.  This
> means that tmpfs can now support both security.selinux and
> security.capability, which was not previously possible.
> 
> The basic implementation is that I attach a:
> 
> struct shmem_xattr {
> 	struct list_head list; /* anchored by shmem_inode_info->xattr_list */
> 	char *name;
> 	size_t size;
> 	char value[0];
> };
> 
> Into the struct shmem_inode_info for each xattr that is set.  This
> implementation could easily support the user.* namespace as well,
> except some care needs to be taken to prevent large amounts of
> unswappable memory being allocated for unprivileged users.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/Kconfig               |   18 ++
>  include/linux/shmem_fs.h |    1 
>  mm/shmem.c               |  302 +++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 273 insertions(+), 48 deletions(-)
> 
> Index: linux-2.6/fs/Kconfig
> ===================================================================
> --- linux-2.6.orig/fs/Kconfig	2011-04-19 21:09:33.000000000 +0200
> +++ linux-2.6/fs/Kconfig	2011-04-19 21:09:35.000000000 +0200
> @@ -121,9 +121,25 @@ config TMPFS
>  
>  	  See <file:Documentation/filesystems/tmpfs.txt> for details.
>  
> +config TMPFS_XATTR
> +	bool "Tmpfs extended attributes"
> +	depends on TMPFS
> +	default y
> +	help
> +	  Extended attributes are name:value pairs associated with inodes by
> +	  the kernel or by users (see the attr(5) manual page, or visit
> +	  <http://acl.bestbits.at/> for details).
> +
> +	  Currently this enables support for the trusted.* and
> +	  security.* namespaces.
> +
> +	  If unsure, say N.
> +
> +	  You need this for POSIX ACL support on tmpfs.
> +

I disagree with Andrew on this, it should default to off, consistent with
the "If unsure, say N" comment.  Partly because that's how Linus prefers
it, for good anti-bloat reasons: if people have got along without a
feature for years, whyever should we suddenly default it on?  And
partly because TMPFS_POSIX_ACL already defaults to off (as do
EXT2_FS_XATTR and EXT2_FS_POSIX_ACL).

However... if someone already has CONFIG_TMPFS_POSIX_ACL=y in their
old config, it would be nice to make CONFIG_TMPFS_XATTR=y automatically,
so we're not in danger of removing their old functionality.  But I haven't
thought of the right way to achieve that - maybe your helpful POSIX ACL
comment is enough, but automatic would be better.

Few people would choose TMPFS_XATTR on and TMPFS_POSIX_ACL off: perhaps it
would work to make CONFIG_TMPFS_XATTR the new config option to cover both,
and select it from config TMPFS_POSIX_ACL (without a prompt) so the
oldconfig propagates correctly.  Perhaps.  But I haven't tried myself,
and you may be forgiveably disinclined to make config experiments!

>  config TMPFS_POSIX_ACL
>  	bool "Tmpfs POSIX Access Control Lists"
> -	depends on TMPFS
> +	depends on TMPFS_XATTR
>  	select GENERIC_ACL
>  	help
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
> Index: linux-2.6/include/linux/shmem_fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/shmem_fs.h	2011-04-19 21:09:25.000000000 +0200
> +++ linux-2.6/include/linux/shmem_fs.h	2011-04-19 21:09:35.000000000 +0200
> @@ -19,6 +19,7 @@ struct shmem_inode_info {
>  	struct page		*i_indirect;	/* top indirect blocks page */
>  	swp_entry_t		i_direct[SHMEM_NR_DIRECT]; /* first blocks */
>  	struct list_head	swaplist;	/* chain of maybes on swap */
> +	struct list_head	xattr_list;	/* list of shmem_xattr */
>  	struct inode		vfs_inode;
>  };
>  
> Index: linux-2.6/mm/shmem.c
> ===================================================================
> --- linux-2.6.orig/mm/shmem.c	2011-04-19 21:09:25.000000000 +0200
> +++ linux-2.6/mm/shmem.c	2011-04-19 21:09:35.000000000 +0200
...
> -#ifdef CONFIG_TMPFS_POSIX_ACL
> +#ifdef CONFIG_TMPFS_XATTR
>  /*
> - * Superblocks without xattr inode operations will get security.* xattr
> - * support from the VFS "for free". As soon as we have any other xattrs
> + * Superblocks without xattr inode operations may get some security.* xattr
> + * support from the LSM "for free". As soon as we have any other xattrs
>   * like ACLs, we also need to implement the security.* handlers at
>   * filesystem level, though.
>   */
>  
> -static size_t shmem_xattr_security_list(struct dentry *dentry, char *list,
> -					size_t list_len, const char *name,
> -					size_t name_len, int handler_flags)
> +static int shmem_xattr_get(struct dentry *dentry, const char *name,
> +			   void *buffer, size_t size)
>  {
> -	return security_inode_listsecurity(dentry->d_inode, list, list_len);
> -}
> +	struct shmem_inode_info *info;
> +	struct shmem_xattr *xattr;
> +	int ret = -ENODATA;
>  
> -static int shmem_xattr_security_get(struct dentry *dentry, const char *name,
> -		void *buffer, size_t size, int handler_flags)
> -{
> -	if (strcmp(name, "") == 0)
> -		return -EINVAL;
> -	return xattr_getsecurity(dentry->d_inode, name, buffer, size);
> +	info = SHMEM_I(dentry->d_inode);
> +
> +	spin_lock(&dentry->d_inode->i_lock);

Not important, but I suggest you use info->lock throughout for this,
instead of dentry->d_inode->i_lock: in each case you need "info" for
info->xattr_list (and don't need "inode" at all I think), so info->lock
seems appropriate, and may be in the same cacheline once I make
shmem_inode_info smaller.  But don't worry if you'd prefer to leave it.

> -static int shmem_xattr_security_set(struct dentry *dentry, const char *name,
> -		const void *value, size_t size, int flags, int handler_flags)
> +static int shmem_xattr_set(struct dentry *dentry, const char *name,
> +			   const void *value, size_t size, int flags)
>  {
> -	if (strcmp(name, "") == 0)
> -		return -EINVAL;
> -	return security_inode_setsecurity(dentry->d_inode, name, value,
> -					  size, flags);
> +	struct inode *inode = dentry->d_inode;
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +	struct shmem_xattr *xattr;
> +	struct shmem_xattr *new_xattr = NULL;
> +	size_t len;
> +	int err = 0;
> +
> +	/* value == NULL means remove */
> +	if (value) {
> +		/* wrap around? */
> +		len = sizeof(*new_xattr) + size;
> +		if (len <= sizeof(*new_xattr))
> +			return -ENOMEM;
> +
> +		new_xattr = kmalloc(len, GFP_NOFS);

There's no need for GFP_NOFS in this patch, the page reclaim path won't
ever recurse into xattr handling: just use the usual GFP_KERNEL throughout.

> +		if (!new_xattr)
> +		return -ENOMEM;
> +
> +		new_xattr->name = kstrdup(name, GFP_NOFS);
> +		if (!new_xattr->name) {
> +			kfree(new_xattr);
> +			return -ENOMEM;
> +		}
> +
> +		new_xattr->size = size;
> +		memcpy(new_xattr->value, value, size);
> +	}
> +
> +	spin_lock(&inode->i_lock);
> +	list_for_each_entry(xattr, &info->xattr_list, list) {
> +		if (!strcmp(name, xattr->name)) {
> +			if (flags & XATTR_CREATE) {
> +				xattr = new_xattr;
> +				err = -EEXIST;
> +			} else if (new_xattr) {
> +				list_replace(&xattr->list, &new_xattr->list);
> +			} else {
> +				list_del(&xattr->list);
> +			}
> +			goto out;
> +		}
> +	}
> +	if (flags & XATTR_REPLACE) {
> +		xattr = new_xattr;
> +		err = -ENODATA;
> +	} else {
> +		list_add(&new_xattr->list, &info->xattr_list);
> +		xattr = NULL;
> +	}
> +out:
> +	spin_unlock(&inode->i_lock);
> +	if (xattr)
> +		kfree(xattr->name);
> +	kfree(xattr);
> +	return 0;

I think you meant to return err rather than always 0.

...

> +static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
> +{
> +	bool trusted = capable(CAP_SYS_ADMIN);
> +	struct shmem_xattr *xattr;
> +	struct shmem_inode_info *info;
> +	size_t used = 0;
> +
> +	info = SHMEM_I(dentry->d_inode);
> +
> +	spin_lock(&dentry->d_inode->i_lock);
> +	list_for_each_entry(xattr, &info->xattr_list, list) {
> +		/* skip "trusted." attributes for unprivileged callers */
> +		if (!trusted && xattr_is_trusted(xattr->name))
> +			continue;
> +
> +		used += strlen(xattr->name) + 1;
> +		if (buffer) {
> +			if (size < used) {
> +				used = -ERANGE;
> +				break;
> +			}
> +			strncpy(buffer, xattr->name, strlen(xattr->name) + 1);
> +			buffer += strlen(xattr->name) + 1;
> +		}
> +	}
> +	spin_unlock(&dentry->d_inode->i_lock);
> +
> +	return used;
> +}
>  #endif

#endif /* CONFIG_TMPFS_XATTR */

would be welcome by the time we get here.

Thanks,
Hugh
