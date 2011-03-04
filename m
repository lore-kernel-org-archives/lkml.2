Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1CDGzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:55:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38202 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1CDGzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:55:46 -0500
Date: Fri, 4 Mar 2011 06:55:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Bob Copeland <me@bobcopeland.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: omfs fixes
Message-ID: <20110304065542.GT22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
 <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk>
 <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
 <87tyfk7x0c.fsf@devron.myhome.or.jp>
 <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
 <87lj0v9984.fsf@devron.myhome.or.jp>
 <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
 <20110303225702.GQ22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303225702.GQ22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:57:02PM +0000, Al Viro wrote:

> BTW, I suspect that another exception among the local filesystems (affs)
> is actually leaking blocks on rmdir.  Need to experiment to verify that,
> but it smells like another genuine bug.

affs turned out to be OK; it uses rather convoluted scheme for link counter
(and uses i_nlink == 0 as trigger for freeing inode), and it actually
works fine.  Directories: 1 as long as they are alive, 0 once they are
doomed.  Everything else: 1 if there's exactly one link, 0 once it's doomed,
2 when there's more than 1 link.  It works.

omfs, however, is _not_ OK in several respects.  There's no i_nlink races,
since everything has one parent and rename() gets away with its playing with
link count of old_inode (and it's more complicated than in case of ext*,
BTW).  However,
	a) it gives all live directories i_nlink == 2.  Should be 1, since it's
really "can't tell how many".
	b) it uses i_nlink == 0 as indication of doomed inode.  And on
rmdir() it drives i_nlink to 0, so that works.  On overwriting directory
rename(), OTOH, it leaves i_nlink at 1 and leaks the sucker.  Blocks
are not freed.
	c) readdir() is really not well.  Directories on omfs are hash
tables - array of pointers to chains, indexed by hash function of name.
If we run into an entry that is too long for what remains in the buffer,
we keep scanning the chain.  And if something past it will turn out to
be short enough, we'll advance file->f_pos and keep going.  Moreover,
if the _last_ one in chain happens to be short enough, we'll spill over
to the next chain, completely forgetting what had been missed in the
previous one.
	d) rename playing odd games with link count of old inode is not
a bug; it's too convoluted for no good reason, but at least it's correct.
Failing to mark old_inode dirty after updating ->i_ctime in there, OTOH,
is racy.

I've pushed fixes for (b), (c) and (d) into #i_nlink and I think that (a)
needs to be dealt with as well, but that one is less nasty.  Bob, do you
prefer that to go through your tree or should it go straight to Linus?
It's in git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ i_nlink,
Al Viro (4):
      omfs: rename() needs to mark old_inode dirty after ctime update
      omfs: stop playing silly buggers with omfs_unlink() in ->rename()
      omfs: merge unlink() and rmdir(), close leak in rename()
      omfs: make readdir stop when filldir says so
 fs/omfs/dir.c |   66 +++++++++++++++++---------------------------------------
 1 files changed, 20 insertions(+), 46 deletions(-)
