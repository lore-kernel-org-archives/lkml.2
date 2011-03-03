Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab1CCDY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:24:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:32785 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab1CCDY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:24:56 -0500
Date: Thu, 3 Mar 2011 03:24:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303032454.GI22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	We have an interesting problem.  Consider the following sequence
of syscalls:
	mkdir("foo", 0777);
	mkdir("bar", 0777);
	fd1 = open("foo", O_DIRECTORY);
	fd2 = open("bar", O_DIRECTORY);
	rename("foo", "bar");	/* kill old bar */
	rmdir("bar"); 		/* kill old foo */
	fstat(fd1, &buf1);
	fstat(fd2, &buf2);
What should be in buf1.st_nlink and buf2.st_nlink, if none of these
syscalls fail?  Note that in both cases any lookups in victim directory
will fail and so will readdir; as far as VFS is concerned, the effect of
such rmdir() and rename() on their victims are identical.  In particular,
both . and .. are gone, as explicitly required by POSIX in case of rmdir().

Surprisingly, the results are *NOT* identical wrt fstat(); for most of
the filesystems we will get 0 in both cases (as expected), but some will
leave 1 in buf2.st_nlink.  What we have is

0 0: ext*, xfs, jfs, reiserfs, ocfs2, gfs2, nilfs, exofs, udf, ubifs,
     minix, sysv, ufs, msdos, vfat, hfs+
0 1: ramfs, shmem, hugetlbfs, jffs2, omfs, hfs[*], apparently nfs as well
hell knows: ncpfs, fuse, ecryptfs, coda, cifs, ceph, btrfs, affs
1 1: (unless I'm misreading it) logfs
completely FUBAR wrt fstat(): hostfs[**]
-EEXIST on rename(): cgroup
-EINVAL on rename(): hpfs
server ought to fail such rename(): 9p
apparently fails rename(): smbfs
completely broken rename(): pohmelfs[***]

[*] yes, different from hfs+; the code is clearly broken, since it simply
does unlink() on target, without even verifying that it's empty.  And
yes, it's trivial fs corruption...
[**] even open() + unlink() + fstat() will report original st_nlink, etc.
[***] new_dir is target's _parent_ directory and it's not required to be
empty; it's never going to be NULL, while we are at it.  Code makes no
sense...

The variant with st_nlink getting to 0 in both cases is definitely the most
common and at least for local filesystems I think it should be mandatory.
I.e. ramfs and friends, jffs2, omfs and hfs should all switch to it.

Comments would be welcome; I really don't know the protocols of most of
the network filesystems well enough to tell what'll happen in these
situations.
				Al, digging through i_nlink code audit...
