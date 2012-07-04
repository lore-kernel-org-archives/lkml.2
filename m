Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2GDLHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:07:38 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41282 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2GDLHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:07:37 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted inodes/dentries
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	<1341342576-15394-3-git-send-email-steve@digidescorp.com>
Date: Wed, 04 Jul 2012 20:07:34 +0900
In-Reply-To: <1341342576-15394-3-git-send-email-steve@digidescorp.com> (Steven
	J. Magnani's message of "Tue, 3 Jul 2012 14:09:36 -0500")
Message-ID: <87pq8bokcp.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> This patch adds code to support reconstruction of evicted inodes.
> We walk the on-disk structures where necessary to fill in information
> not available in the NFS file handle.
>
> One important point is that when reconstructing an inode, in order to avoid the
> *client* declaring ESTALE we have to ensure that the NFS file handle of the
> reconstruction is identical to that of the original. 

Sorry, I didn't review fully yet though.

We would like to add the comment of [0/2] explanation here. Here is
missing the explanation of the problem.

And the codes of nfs support became larger, and I think we should give
the place for it. I.e. we would like to add new file (maybe, export.c,
nfs.c, or something), move nfs code into it.

With it, we don't need to add "NFS ..." annotation in the comment, and
it would make more clear.

And can you add explanation the test of this? What were tested?

> +/**
> + * NFS helper: retrieve the name of an anonymous (disconnected) child using
> + * its i_pos or i_logstart and knowledge of its parent
> + *
> + * Returns 0 on success, -ENOENT if child cannot be found,
> + * -ENOMEM on malloc failure
> + */
> +int fat_get_name(struct dentry *parent, char *name,
> +		 struct dentry *child)
> +{
> +	struct super_block *sb = parent->d_inode->i_sb;
> +
> +	loff_t child_loc = MSDOS_I(child->d_inode)->i_pos;
> +	int err;
> +
> +	lock_super(sb);
> +
> +	if (child_loc) {
> +		err = fat_name_for_ipos(parent->d_inode, name, NAME_MAX+1,
> +					child_loc);
> +	} else {
> +		child_loc = MSDOS_I(child->d_inode)->i_logstart;
> +		err = fat_name_for_logstart(parent->d_inode, name, NAME_MAX+1,
> +					    child_loc);
> +	}
> +
> +	unlock_super(sb);
> +	return err;
> +}

Please don't add new lock_super() usage if it is not necessary. Almost
all of lock_super() just replaced lock_kernel() usage. It rather should
be removed in future.  Probably, this should use inode->i_mutex instead.

BTW, the above issue is same with all of directory read.

And although this is using i_pos, is there no possibility to be passed
the detached inode (i.e. open but unlinked inode, i_pos == 0)?

What happens in the case of detached inode?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
