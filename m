Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab1ELM1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:27:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48760 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab1ELM1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=J3CbDaYPYvCB1MUpYbR73aWbUFx1pDuFJYsz9AJE5gM+zYJ8J9Rcw8KosR2VtUcqQJ
         ZDajW6Y0AGvHHk6l5xgBCrDZyTZSFY90jVBXg78YKcDOUHht5Dr5UKnJOR93hUAPGLXO
         cwx0HfPkLYSRK7EDhBM0wyqxgMpFq7f+AWAL4=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Suchanek <hramrach@centrum.cz>, Andreas Dilger <adilger@dilger.ca>,
        Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
	<BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
	<BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
	<BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
	<C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
	<BANLkTinMNL8Q+_MCHDqAGSdYNAvHB2GdLw@mail.gmail.com>
	<87tydu3t4p.fsf_-_@tucsk.pomaz.szeredi.hu>
	<alpine.LSU.2.00.1105112023560.1424@sister.anvils>
Date: Thu, 12 May 2011 14:27:19 +0200
In-Reply-To: <alpine.LSU.2.00.1105112023560.1424@sister.anvils> (Hugh
	Dickins's message of "Wed, 11 May 2011 21:20:34 -0700 (PDT)")
Message-ID: <87sjskm7dk.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

Hugh Dickins <hughd@google.com> writes:

> I understand from the mm-commits discussion that you're probably
> preparing another version: so let me make just a few comments
> on this old one now, in case you can factor them in.

For sure.  Thanks for your comments.

>> +config TMPFS_XATTR
>> +	bool "Tmpfs extended attributes"
>> +	depends on TMPFS
>> +	default y
>> +	help
>> +	  Extended attributes are name:value pairs associated with inodes by
>> +	  the kernel or by users (see the attr(5) manual page, or visit
>> +	  <http://acl.bestbits.at/> for details).
>> +
>> +	  Currently this enables support for the trusted.* and
>> +	  security.* namespaces.
>> +
>> +	  If unsure, say N.
>> +
>> +	  You need this for POSIX ACL support on tmpfs.
>> +
>
> I disagree with Andrew on this, it should default to off, consistent with
> the "If unsure, say N" comment.  Partly because that's how Linus prefers
> it, for good anti-bloat reasons: if people have got along without a
> feature for years, whyever should we suddenly default it on?  And
> partly because TMPFS_POSIX_ACL already defaults to off (as do
> EXT2_FS_XATTR and EXT2_FS_POSIX_ACL).

Okay, changed to "default n".

> However... if someone already has CONFIG_TMPFS_POSIX_ACL=y in their
> old config, it would be nice to make CONFIG_TMPFS_XATTR=y automatically,
> so we're not in danger of removing their old functionality.  But I haven't
> thought of the right way to achieve that - maybe your helpful POSIX ACL
> comment is enough, but automatic would be better.

AFAICS we don't really support backward compatibility in Kconfig.  If
something breaks, it's the user's (kernel builder's) responsibility to
fix up.

> Few people would choose TMPFS_XATTR on and TMPFS_POSIX_ACL off: perhaps it
> would work to make CONFIG_TMPFS_XATTR the new config option to cover both,
> and select it from config TMPFS_POSIX_ACL (without a prompt) so the
> oldconfig propagates correctly.  Perhaps.  But I haven't tried myself,
> and you may be forgiveably disinclined to make config experiments!

I think it would work, but I prefer to have these options separate and
avoid messy back compat options.

On overlayfs, for example, TMPFS_XATTR would be useful but
TMPFS_POSIX_ACL would not.

>> +	info = SHMEM_I(dentry->d_inode);
>> +
>> +	spin_lock(&dentry->d_inode->i_lock);
>
> Not important, but I suggest you use info->lock throughout for this,
> instead of dentry->d_inode->i_lock: in each case you need "info" for
> info->xattr_list (and don't need "inode" at all I think), so info->lock
> seems appropriate, and may be in the same cacheline once I make
> shmem_inode_info smaller.  But don't worry if you'd prefer to leave
> it.

Makes sense.  I updated the locking.

>> +		new_xattr = kmalloc(len, GFP_NOFS);
>
> There's no need for GFP_NOFS in this patch, the page reclaim path won't
> ever recurse into xattr handling: just use the usual GFP_KERNEL
> throughout.

Yes.  I didn't notice this in Eric's patch, but GFP_NOFS is obviously
not necessary here.

>> +		if (!new_xattr)
>> +		return -ENOMEM;
>> +
>> +		new_xattr->name = kstrdup(name, GFP_NOFS);
>> +		if (!new_xattr->name) {
>> +			kfree(new_xattr);
>> +			return -ENOMEM;
>> +		}
>> +
>> +		new_xattr->size = size;
>> +		memcpy(new_xattr->value, value, size);
>> +	}
>> +
>> +	spin_lock(&inode->i_lock);
>> +	list_for_each_entry(xattr, &info->xattr_list, list) {
>> +		if (!strcmp(name, xattr->name)) {
>> +			if (flags & XATTR_CREATE) {
>> +				xattr = new_xattr;
>> +				err = -EEXIST;
>> +			} else if (new_xattr) {
>> +				list_replace(&xattr->list, &new_xattr->list);
>> +			} else {
>> +				list_del(&xattr->list);
>> +			}
>> +			goto out;
>> +		}
>> +	}
>> +	if (flags & XATTR_REPLACE) {
>> +		xattr = new_xattr;
>> +		err = -ENODATA;
>> +	} else {
>> +		list_add(&new_xattr->list, &info->xattr_list);
>> +		xattr = NULL;
>> +	}
>> +out:
>> +	spin_unlock(&inode->i_lock);
>> +	if (xattr)
>> +		kfree(xattr->name);
>> +	kfree(xattr);
>> +	return 0;
>
> I think you meant to return err rather than always 0.

Right.  Well spotted.

>> +static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
>> +{
>> +	bool trusted = capable(CAP_SYS_ADMIN);
>> +	struct shmem_xattr *xattr;
>> +	struct shmem_inode_info *info;
>> +	size_t used = 0;
>> +
>> +	info = SHMEM_I(dentry->d_inode);
>> +
>> +	spin_lock(&dentry->d_inode->i_lock);
>> +	list_for_each_entry(xattr, &info->xattr_list, list) {
>> +		/* skip "trusted." attributes for unprivileged callers */
>> +		if (!trusted && xattr_is_trusted(xattr->name))
>> +			continue;
>> +
>> +		used += strlen(xattr->name) + 1;
>> +		if (buffer) {
>> +			if (size < used) {
>> +				used = -ERANGE;
>> +				break;
>> +			}
>> +			strncpy(buffer, xattr->name, strlen(xattr->name) + 1);
>> +			buffer += strlen(xattr->name) + 1;
>> +		}
>> +	}
>> +	spin_unlock(&dentry->d_inode->i_lock);
>> +
>> +	return used;
>> +}
>>  #endif
>
> #endif /* CONFIG_TMPFS_XATTR */
>
> would be welcome by the time we get here.

Yes, fixed.

Updated patch will follow shortly.

Thanks,
Miklos
