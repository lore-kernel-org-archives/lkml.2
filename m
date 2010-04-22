Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab0DVG0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:26:47 -0400
Received: from lazybastard.de ([212.112.238.170]:46448 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab0DVG0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:26:46 -0400
Date: Thu, 22 Apr 2010 08:26:31 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100422062631.GC27309@logfs.org>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422055448.GA27309@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I think this is bad enough that you should be involved.  32a88aa1 broke
a number of filesystems in a way that sync() would return 0 without
doing any work.  Even politicians are better at keeping the promises.

This is caused by the two-liner in __sync_filesystem:
	if (!sb->s_bdi)
		return 0;
s_bdi is set implicitly for all filesystems using set_bdev_super(), so
most block device based filesystems are safe.  There are, however, a
number of odd-balls around:

On Thu, 22 April 2010 07:54:48 +0200, Jörn Engel wrote:
> 
> 9p	no s_bdi
> afs	no s_bdi
> ceph	creates its own s_bdi
> cifs	no s_bdi
> coda	no s_bdi
> ecryptfs no s_bdi
> exofs	no s_bdi
> fuse	creates its own s_bdi?
> gfs2	creates its own s_bdi?
> jffs2	patch exists
> logfs	fixed now
> ncpfs	no s_bdi
> nfs	creates its own s_bdi
> ocfs2	no s_bdi
> smbfs	no s_bdi
> ubifs	creates its own s_bdi

Obviously this list should get checked and all affected filesystems get
repaired.  Additionally we should add an assertion and BUG() or refuse
to mount or something.  My original patch to that extend was this:

diff --git a/fs/super.c b/fs/super.c
index f35ac60..e8af253 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -954,6 +954,8 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	if (error < 0)
 		goto out_free_secdata;
 	BUG_ON(!mnt->mnt_sb);
+	BUG_ON(!mnt->mnt_sb->s_bdi &&
+			(mnt->mnt_sb->s_bdev || mnt->mnt_sb->s_mtd));
 
  	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
  	if (error)
  		goto out_sb;

The real problem is finding a condition that has neither false positives
nor false negatives.  The "(mnt->mnt_sb->s_bdev || mnt->mnt_sb->s_mtd)"
part takes care of false positives like tmpfs, but it would catch none
of the network filesystems.  Should we instead annotate tmpfs and friends
with something like sb->s_dont_need_bdi?  It is the only way I can think
of not to miss something.

Jörn

-- 
People will accept your ideas much more readily if you tell them
that Benjamin Franklin said it first.
-- unknown

