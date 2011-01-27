Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab1A0Fr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 00:47:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54277 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1A0Fr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 00:47:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uIEtx/4qRSe+bBa3lbyxHBEQuWoeTNsVrWzMc0znTJHZVzCWthyGxG8siEnkLv/SVY
         Eng7JwCNmwBhsDGDYuHT1ryPB17bUC/y2KMe50NqtZLRhGBuxHBZgTtP/kQ9DvWU2ieo
         CMX+namit4PreRm5OsFhN9Z4th6g8FRA5p2sA=
MIME-Version: 1.0
In-Reply-To: <1295993854-4971-16-git-send-email-arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	<1295993854-4971-16-git-send-email-arnd@arndb.de>
Date: Thu, 27 Jan 2011 16:47:55 +1100
Message-ID: <AANLkTinKO=HM1BqDdFkdcCAGz85co64Ma79qomw6PDPp@mail.gmail.com>
Subject: Re: [PATCH 15/20] ufs: remove the BKL
From: Nick Piggin <npiggin@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>,
        Evgeniy Dushistov <dushistov@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Really great work in removing BKL, Arnd. It's awesome
work and I'm sure a lot of it was pretty thankless along
the way.

On Wed, Jan 26, 2011 at 9:17 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> This introduces a new per-superblock mutex in UFS to replace
> the big kernel lock. I have been careful to avoid nested
> calls to lock_ufs and to get the lock order right with
> respect to other mutexes, in particular lock_super.

When I looked at removing bkl from minix a long time ago,
I was a bit worried about reclaim and fs/io recursion in some
of the filesystems with bkl.


> @@ -436,7 +439,8 @@ int ufs_getfrag_block(struct inode *inode, sector_t fragment, struct buffer_head
>        ret = 0;
>        bh = NULL;
>
> -       lock_kernel();
> +       if (needs_lock)
> +               lock_ufs(sb);
>
>        UFSD("ENTER, ino %lu, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
>        if (fragment >

[...]

> @@ -55,16 +54,16 @@ static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, stru
>        if (dentry->d_name.len > UFS_MAXNAMLEN)
>                return ERR_PTR(-ENAMETOOLONG);
>
> -       lock_kernel();
> +       lock_ufs(dir->i_sb);
>        ino = ufs_inode_by_name(dir, &dentry->d_name);
>        if (ino) {
>                inode = ufs_iget(dir->i_sb, ino);
>                if (IS_ERR(inode)) {
> -                       unlock_kernel();
> +                       unlock_ufs(dir->i_sb);
>                        return ERR_CAST(inode);
>                }
>        }
> -       unlock_kernel();
> +       unlock_ufs(dir->i_sb);
>        d_add(dentry, inode);
>        return NULL;
>  }

versus

1405static struct inode *ufs_alloc_inode(struct super_block *sb)
1406{
1407        struct ufs_inode_info *ei;
1408        ei = (struct ufs_inode_info
*)kmem_cache_alloc(ufs_inode_cachep, GFP_KERNEL);
1409        if (!ei)
1410                return NULL;
1411        ei->vfs_inode.i_version = 1;
1412        return &ei->vfs_inode;
1413}

So, get_block can be called for .writepage in page reclaim,
which takes the lock. ufs_lookup takes the lock and winds
up calling ufs_alloc_inode. And ufs_alloc_inode does
GFP_KERNEL, which can enter reclaim with __GFP_FS
set.

I didn't look through all your filesystem conversions, but it is
something tricky to watch out for I think.

Changing everything to GFP_NOFS may be an option, for
such crufty old filesystems...
