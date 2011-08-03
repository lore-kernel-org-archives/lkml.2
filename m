Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1HCWRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 18:17:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53342 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab1HCWRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 18:17:11 -0400
Date: Wed, 3 Aug 2011 23:17:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz,
        hch@infradead.org, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: Re: [PATCH 2/4] vfs: keep list of mounts for each superblock
Message-ID: <20110803221707.GM2203@ZenIV.linux.org.uk>
References: <1312368521-7911-1-git-send-email-miklos@szeredi.hu>
 <1312368521-7911-3-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312368521-7911-3-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 12:48:39PM +0200, Miklos Szeredi wrote:
> @@ -696,6 +696,11 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
>  	mnt->mnt_sb = root->d_sb;
>  	mnt->mnt_mountpoint = mnt->mnt_root;
>  	mnt->mnt_parent = mnt;
> +
> +	br_write_lock(vfsmount_lock);
> +	list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
> +	br_write_unlock(vfsmount_lock);

Racy.

> @@ -745,6 +750,10 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
>  			if (!list_empty(&old->mnt_expire))
>  				list_add(&mnt->mnt_expire, &old->mnt_expire);
>  		}
> +
> +		br_write_lock(vfsmount_lock);
> +		list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
> +		br_write_unlock(vfsmount_lock);

Ditto.  If you expect to be able to find *all* vfsmounts over given sb,
this locking is simply wrong.
