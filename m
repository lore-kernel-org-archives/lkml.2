Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2JIUom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:44:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2JIUoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:44:39 -0400
Date: Tue, 9 Oct 2012 22:44:33 +0200
From: Jan Kara <jack@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 16/27] userns: Convert vfs posix_acl support to use
 kuids and kgids
Message-ID: <20121009204433.GB24622@quack.suse.cz>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
 <1348105949-25454-16-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348105949-25454-16-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-09-12 18:52:18, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - In setxattr if we are setting a posix acl convert uids and gids from
>   the current user namespace into the initial user namespace, before
>   the xattrs are passed to the underlying filesystem.
> 
>   Untranslatable uids and gids are represented as -1 which
>   posix_acl_from_xattr will represent as INVALID_UID or INVALID_GID.
>   posix_acl_valid will fail if an acl from userspace has any
>   INVALID_UID or INVALID_GID values.  In net this guarantees that
>   untranslatable posix acls will not be stored by filesystems.
> 
> - In getxattr if we are reading a posix acl convert uids and gids from
>   the initial user namespace into the current user namespace.
> 
>   Uids and gids that can not be tranlsated into the current user namespace
>   will be represented as -1.
> 
> - Replace e_id in struct posix_acl_entry with an anymouns union of
>   e_uid and e_gid.  For the short term retain the e_id field
>   until all of the users are converted.
> 
> - Don't set struct posix_acl.e_id in the cases where the acl type
>   does not use e_id.  Greatly reducing the use of ACL_UNDEFINED_ID.
> 
> - Rework the ordering checks in posix_acl_valid so that I use kuid_t
>   and kgid_t types throughout the code, and so that I don't need
>   arithmetic on uid and gid types.
> 
> Cc: Theodore Tso <tytso@mit.edu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
  I know this got merged but I got to seriously looking into it only now
and frankly I think the push was a hurried one...

> diff --git a/fs/xattr.c b/fs/xattr.c
> index 4d45b71..c111745 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -20,6 +20,7 @@
>  #include <linux/fsnotify.h>
>  #include <linux/audit.h>
>  #include <linux/vmalloc.h>
> +#include <linux/posix_acl_xattr.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -347,6 +348,9 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
>  			error = -EFAULT;
>  			goto out;
>  		}
> +		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
> +		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
> +			posix_acl_fix_xattr_from_user(kvalue, size);
>  	}
>  
>  	error = vfs_setxattr(d, kname, kvalue, size, flags);
> @@ -450,6 +454,9 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
>  
>  	error = vfs_getxattr(d, kname, kvalue, size);
>  	if (error > 0) {
> +		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
> +		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
> +			posix_acl_fix_xattr_to_user(kvalue, size);
>  		if (size && copy_to_user(value, kvalue, error))
>  			error = -EFAULT;
>  	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
> diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
> index 69d06b0..bf472ca 100644
> --- a/fs/xattr_acl.c
> +++ b/fs/xattr_acl.c
> @@ -9,7 +9,65 @@
>  #include <linux/fs.h>
>  #include <linux/posix_acl_xattr.h>
>  #include <linux/gfp.h>
> +#include <linux/user_namespace.h>
>  
> +/*
> + * Fix up the uids and gids in posix acl extended attributes in place.
> + */
> +static void posix_acl_fix_xattr_userns(
> +	struct user_namespace *to, struct user_namespace *from,
> +	void *value, size_t size)
> +{
> +	posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
> +	posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;
> +	int count;
> +	kuid_t uid;
> +	kgid_t gid;
> +
> +	if (!value)
> +		return;
> +	if (size < sizeof(posix_acl_xattr_header))
> +		return;
> +	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
> +		return;
> +
> +	count = posix_acl_xattr_count(size);
> +	if (count < 0)
> +		return;
> +	if (count == 0)
> +		return;
> +
> +	for (end = entry + count; entry != end; entry++) {
> +		switch(le16_to_cpu(entry->e_tag)) {
> +		case ACL_USER:
> +			uid = make_kuid(from, le32_to_cpu(entry->e_id));
  This should have some error checking I guess... The initial checks done
in posix_acl_from_xattr() are for init_user_ns (why?) and only duplicated
in posix_acl_valid().

> +			entry->e_id = cpu_to_le32(from_kuid(to, uid));
> +			break;
> +		case ACL_GROUP:
> +			gid = make_kgid(from, le32_to_cpu(entry->e_id));
> +			entry->e_id = cpu_to_le32(from_kuid(to, uid));
                                             here should be gid ^^^

> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +}
Also what about the following scenario:

We have namespace A with user U1 and namespace B which does not have a
valid representation for U1. There is a file F which can be seen from both
namespaces. In namespace A we create acl for user U1 attached to F. Now in
namespace B we modify the acl via setfacl(1) command. What it does is
getxattr(2) - returns mangled acl because U1 has no representation in B. We
add something to xattr and call setxattr(2) - results in removing the
original acl for U1 and instead adding acl for uid -1. That is a security
bug I'd say.

								Honza
