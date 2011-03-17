Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1CQKoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:44:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53346 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab1CQKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:44:41 -0400
Date: Thu, 17 Mar 2011 10:44:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: tony.luck@intel.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] mnt_devname queue
Message-ID: <20110317104434.GB22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
 <20110317072344.GZ22723@ZenIV.linux.org.uk>
 <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 03:28:47PM +0800, Xiaotian Feng wrote:
> Cc'ed author ...
> 
> > a) What the hell would you expect to happen if userland mounts it twice
> > and unmount the first one? ??pstore_sb = NULL, pstore_mnt = NULL, AFAICS.

BTW, you want
	* mount_single(), not mount_nodev()
	* simple_pin_fs()/mntput() around modifying that sucker from kernel
(held across both the file creation and writing to it)

> > b) pstore_writefile() - struct file on stack? ??Really? ??Again, in the
> > scenario above, what'll happen to you if pstore_mnt gets dropped and
> > freed in the middle of all that?
> >
> > c) in the same function:
> > + ?? ?? ?? memset(&f, '0', sizeof f);
> > Ahem...

Aside of a new meaning given to "zero that structure out", why the devil
are you doing it in such a convoluted way?  Note that you are using ramfs,
so the mapping is unevictable.  Simple kmalloc() + memcpy() and
simple_read_from_buffer() to implement ->read() would do nicely.

And for fsck sake, copy ramfs_get_inode() and trim it.  You are overriding
it for the single directory in there and you are only using it for regular
files otherwise.  With wrong ->i_op and ->i_fop *and* irrelevant messing with
->i_mapping.  Which leaves you with
	inode->i_ino = get_next_ino();
	inode_init_owner(inode, dir, mode);
	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
as useful part.

BTW, you want to make the contents visible before d_add().  You
*definitely* want to finish setting it up before unlocking the parent,
or you are asking for userland to come and unlink() it under you.

Incidentally, you are leaking ->i_private on umount.  You want ->evict_inode()
doing that kfree(), not ->unlink().  And possibly ->erase() as well, with
check for zero i_nlink around it (in ->evict_inode()).
