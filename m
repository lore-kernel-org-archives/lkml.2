Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0LOHt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 02:49:29 -0500
Received: from www84.your-server.de ([213.133.104.84]:50790 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0LOHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 02:49:27 -0500
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
From: Stefani Seibold <stefani@seibold.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <AANLkTikvN9u3dB_TzNUKjz7g39i+t+h4vt7EVKDLVjLg@mail.gmail.com>
References: <1292368360-32216-1-git-send-email-stefani@seibold.net>
	 <AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
	 <AANLkTikvN9u3dB_TzNUKjz7g39i+t+h4vt7EVKDLVjLg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Dec 2010 08:50:18 +0100
Message-ID: <1292399418.303.8.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 14.12.2010, 15:43 -0800 schrieb Linus Torvalds:
> On Tue, Dec 14, 2010 at 3:32 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Why do you repeat that
> >
> >    inode = iget_locked(sb, cramino(cramfs_inode, offset));
> >    if (inode && (inode->i_state & I_NEW)) {
> >
> > so many times?
> >
> > Wouldn't it be nicer to just do it once at the top?
> 
> Oh, and I think it's probably nicer to then do the if-statements as a
> 
>    switch (cram_inode->mode & S_IFMT) {
>    case S_IFREG:
>    ..	
> 

This is easy to fix.

> but what I objected to in the previous patch was doing it multiple
> times, and moving the nice separate helper function into the caller.
> 
> So I _think_ you should be able to just do something like this:
> 
>    ino = cramino(cramfs_inode, offset);
>    switch (cram_inode->mode & S_IFMT) {
>    case S_IFREG:
>       fops = generic_ro_fops;
>       aops = &cramfs_aops;
>       break;
>    case S_IFDIR:
>       ...
>    default:
>        ino = CRAMINO_UNIQ(offset);
>    }
>    inode = iget_locked(sb, ino);
>    if (inode && (inode->i_state & I_NEW)) {
>       inode->i_ops = iops;
>       inode->i_fops = fops;
>       inode->i_data.a_ops = aops;
>       setup_inode(inode, cramfs_inode, cramfs_inode->size);
>     }
> 

No, it makes no sense, for following reasons:

- Why pre-setup variables like iops, fops and aops which are in the most
cases not needed? Because the inode is still in the cache.

- Each branch is a little bit different.

- The default branch is completly different, because in this case the
init_special_inode() will be called, which sets the inode->fop.

What do you think about this solution:

static void setup_inode(struct inode *inode, struct cramfs_inode * cramfs_inode)
{
	static struct timespec zerotime;
	inode->i_mode = cramfs_inode->mode;
	inode->i_uid = cramfs_inode->uid;
	/* if the lower 2 bits are zero, the inode contains data */
	if (!(inode->i_ino & 3)) {
		inode->i_size = size;
		inode->i_blocks = (size - 1) / 512 + 1;
	}
	inode->i_gid = cramfs_inode->gid;
	/* Struct copy intentional */
	inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
	/* inode->i_nlink is left 1 - arguably wrong for directories,
	   but it's the best we can do without reading the directory
	   contents.  1 yields the right result in GNU find, even
	   without -noleaf option. */
	unlock_new_inode(inode);
}

static struct inode *get_cramfs_inode(struct super_block *sb,
	struct cramfs_inode * cramfs_inode, unsigned int offset)
{
	struct inode *inode;

	switch (cram_inode->mode & S_IFMT) {
	case S_IFREG:
		inode = iget_locked(sb, cramino(cramfs_inode, offset));
		if (inode && (inode->i_state & I_NEW)) {
			inode->i_fop = &generic_ro_fops;
			inode->i_data.a_ops = &cramfs_aops;
			setup_inode(inode, cramfs_inode);
		}
		break;
	case S_IFDIR:
		inode = iget_locked(sb, cramino(cramfs_inode, offset));
		if (inode && (inode->i_state & I_NEW)) {
			inode->i_op = &cramfs_dir_inode_operations;
			inode->i_fop = &cramfs_directory_operations;
			setup_inode(inode, cramfs_inode);
		}
		break;
	case S_IFLNK:
		inode = iget_locked(sb, cramino(cramfs_inode, offset));
		if (inode && (inode->i_state & I_NEW)) {
			inode->i_op = &page_symlink_inode_operations;
			inode->i_data.a_ops = &cramfs_aops;
			setup_inode(inode, cramfs_inode);
		}
		break;
	default:
		inode = iget_locked(sb, CRAMINO_UNIQ(offset));
		if (inode && (inode->i_state & I_NEW)) {
			init_special_inode(inode, cramfs_inode->mode,
				old_decode_dev(cramfs_inode->size));
			setup_inode(inode, cramfs_inode);
		}
		break;
	}
	return inode;
}

- Stefani


