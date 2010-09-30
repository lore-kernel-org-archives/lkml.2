Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0I3JiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:38:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52482 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab0I3JiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:38:16 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, miklos@szeredi.hu, hch@infradead.org,
        agruen@suse.de, npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vaurora@redhat.com
In-reply-to: <1284675145-4391-24-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Thu, 16 Sep 2010 15:12:14 -0700)
Subject: Re: [PATCH 23/34] union-mount: Prevent topmost file system from being mounted elsewhere
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com> <1284675145-4391-24-git-send-email-vaurora@redhat.com>
Message-Id: <E1P1FaG-0001wr-Nn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 30 Sep 2010 11:37:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, Valerie Aurora wrote:
> The device underlying the topmost read-write layer of a file system
> cannot be mounted anywhere else on the system.  We keep a pointer to
> the union stack in the dentry of the topmost directory, so that dentry
> can't be part of a different mount, since dentries are shared between
> different mounts of the same device.
> 
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namespace.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 61256e6..26efaf3 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1998,6 +1998,11 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
>  	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
>  		goto unlock;
>  
> +	/* Top layers of union mounts can't be mounted elsewhere */
> +	err = -EBUSY;
> +	if (newmnt->mnt_sb->s_union_lower_mnts)
> +		goto unlock;
> +

This is insufficient: the super block may be mounted elsewhere later.
And no, preventing bind mounts is not enough.

BTW, what about CLONE_NEWNS?  I think it's a rather big limitation if
that doesn't work...

Thanks,
Miklos
