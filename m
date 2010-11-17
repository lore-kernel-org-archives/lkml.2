Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab0KQAoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:44:10 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50410 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265Ab0KQAoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:44:09 -0500
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Tue, 16 Nov 2010 16:44:03 -0800
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/28] fs: change d_compare for rcu-walk
Message-ID: <20101117004403.GB22789@tpepper-t61p.dolavim.us>
References: <20101116140900.039761100@kernel.dk>
 <20101116142028.836625566@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116142028.836625566@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17 Nov at 01:09:07 +1100 npiggin@kernel.dk said:

> Index: linux-2.6/include/linux/dcache.h
> ===================================================================
> --- linux-2.6.orig/include/linux/dcache.h	2010-11-17 00:52:37.000000000 +1100
> +++ linux-2.6/include/linux/dcache.h	2010-11-17 01:05:48.000000000 +1100
> @@ -134,7 +134,9 @@ enum dentry_d_lock_class
>  struct dentry_operations {
>  	int (*d_revalidate)(struct dentry *, struct nameidata *);
>  	int (*d_hash)(struct dentry *, struct qstr *);
> -	int (*d_compare)(struct dentry *, struct qstr *, struct qstr *);
> +	int (*d_compare)(const struct dentry *,
> +			const struct dentry *, const struct inode *,
> +			unsigned int, const char *, const struct qstr *);
>  	int (*d_delete)(const struct dentry *);
>  	void (*d_release)(struct dentry *);
>  	void (*d_iput)(struct dentry *, struct inode *);

The white space change I'd previously noted may as well happen here
if you're wanting it...just keeps the revision history cleaner for
future eyes.

> Index: linux-2.6/Documentation/filesystems/vfs.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/filesystems/vfs.txt	2010-11-17 00:52:37.000000000 +1100
> +++ linux-2.6/Documentation/filesystems/vfs.txt	2010-11-17 01:05:49.000000000 +1100
> @@ -842,7 +842,9 @@ the VFS uses a default. As of kernel 2.6
>  struct dentry_operations {
>  	int (*d_revalidate)(struct dentry *, struct nameidata *);
>  	int (*d_hash)(struct dentry *, struct qstr *);
> -	int (*d_compare)(struct dentry *, struct qstr *, struct qstr *);
> +	int (*d_compare)(const struct dentry *,
> +			const struct dentry *, const struct inode *,
> +			unsigned int, const char *, const struct qstr *);
>  	int (*d_delete)(const struct dentry *);
>  	void (*d_release)(struct dentry *);
>  	void (*d_iput)(struct dentry *, struct inode *);

Ditto.

> @@ -854,9 +856,26 @@ struct dentry_operations {
>  	dcache. Most filesystems leave this as NULL, because all their
>  	dentries in the dcache are valid
> 
> -  d_hash: called when the VFS adds a dentry to the hash table
> +  d_hash: called when the VFS adds a dentry to the hash table. The first
> +	dentry passed to d_hash is the parent directory that the name is
> + 	to be hashed into.

Similarly it'd be cleaner if this was in the next patch which is changing
d_hash().  Same for the d_hash() prototype white space changes.

> 
> -  d_compare: called when a dentry should be compared with another
> +  d_compare: called to compare a dentry name with a given name. The first
> +	dentry is the parent of the dentry to be compared, the second is
> +	the dentry itself. inode, len, and name string are properties of
> +	the dentry to be compared. qstr is the name to compare it with.
> +
> +	Must be constant and idempotent, and should not take locks if
> +	possible, and should not or store into the dentry or inodes.
                           ^^^^^^^^^^^^^^^^
Verb missing?  Or extra conjunction?

> +	Should not dereference pointers outside the dentry or inodes without
> +	lots of care (eg.  d_parent, d_inode shouldn't be used).
> +
> +	However, our vfsmount is pinned, and RCU held, so the dentries and
> +	inodes won't disappear, neither will our sb or filesystem module.
> +	->i_sb and ->d_sb may be used.
> +
> +	It is a tricky calling convention because it needs to be called under
> +	"rcu-walk", ie. without any locks or references on things.
> 
>    d_delete: called when the last reference to a dentry is dropped and the
>  	dcache is deciding whether or not to cache it. Return 1 to delete

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
