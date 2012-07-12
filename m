Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab2GLKMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:12:09 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44065 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759108Ab2GLKME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:12:04 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat (exportfs): fix dentry reconnection
References: <1341930053-10689-1-git-send-email-steve@digidescorp.com>
	<1341930053-10689-3-git-send-email-steve@digidescorp.com>
Date: Thu, 12 Jul 2012 19:12:01 +0900
In-Reply-To: <1341930053-10689-3-git-send-email-steve@digidescorp.com> (Steven
	J. Magnani's message of "Tue, 10 Jul 2012 09:20:53 -0500")
Message-ID: <87vchtp9u6.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> Maintain an index of directory inodes by starting cluster,
> so that fat_get_parent() can return the proper cached inode rather than
> inventing one that cannot be traced back to the filesystem root.
>
> Add a new msdos/vfat binary mount option "nfs" so that FAT filesystems
> that are _not_ exported via NFS are not saddled with maintenance of an index
> they will never use.
>
> Finally, simplify NFS file handle generation and lookups. 
> An ext2-congruent implementation is adequate for FAT needs.

Looks good to me. Let's test with this.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> +static struct inode *fat_dget(struct super_block *sb, int i_logstart)
>  {

[...]

If options.nfs == 0, it may be better to warn once.

printk_once()

> +	head = sbi->dir_hashtable + fat_dir_hash(i_logstart);
> +	spin_lock(&sbi->dir_hash_lock);
> +	hlist_for_each_entry(i, _p, head, i_dir_hash) {
> +		BUG_ON(i->vfs_inode.i_sb != sb);
> +		if (i->i_logstart != i_logstart)
> +			continue;
> +		inode = igrab(&i->vfs_inode);
> +		if (inode)
> +			break;
> +	}
> +	spin_unlock(&sbi->dir_hash_lock);
> +	return inode;
>  }

[...]

> @@ -128,24 +89,13 @@ struct dentry *fat_get_parent(struct den
>  	struct super_block *sb = child_dir->d_sb;
>  	struct buffer_head *bh = NULL;
>  	struct msdos_dir_entry *de;
> -	loff_t i_pos;
> -	struct dentry *parent;
> -	struct inode *inode;
> -	int err;
> -
> -	lock_super(sb);
> +	struct inode *parent_inode = NULL;
>  
> -	err = fat_get_dotdot_entry(child_dir->d_inode, &bh, &de, &i_pos);
> -	if (err) {
> -		parent = ERR_PTR(err);
> -		goto out;
> +	if (!fat_get_dotdot_entry(child_dir->d_inode, &bh, &de)) {
> +		int parent_logstart = fat_get_start(MSDOS_SB(sb), de);
> +		parent_inode = fat_dget(sb, parent_logstart);
>  	}

BTW, I guess, in future, if it is improve, we might be able to create
that "private" inode here. And register it to i_dir_hash without i_pos,
and detach while using by ->get_parent(). And fat_attach() side can find
and grab it, and update i_pos by real one.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
