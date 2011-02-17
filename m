Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1BQRgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:36:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51856 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1BQRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:36:25 -0500
Date: Thu, 17 Feb 2011 17:36:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Liu <lingjiujianke@gmail.com>, randy.dunlap@oracle.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dchinner@redhat.com, liuqi <liuqi@thunderst.com>
Subject: Re: [PATCH] code cleanup on fs/super.c
Message-ID: <20110217173615.GJ22723@ZenIV.linux.org.uk>
References: <AANLkTi=50m7xULN+Mob1942b+qBEgMcqUPDWSd3inan6@mail.gmail.com>
 <AANLkTim2fg5OUw2aZXA-4V4O7PUQ6T4mhoWxvjNdtYcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim2fg5OUw2aZXA-4V4O7PUQ6T4mhoWxvjNdtYcc@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 08:20:31AM -0800, Linus Torvalds wrote:
> On Thu, Feb 17, 2011 at 12:59 AM, Steven Liu <lingjiujianke@gmail.com> wrote:
> >
> > ? Clean up the unsed code on fs/super.c, all filesystem using mount_bdev
> > ? and mount_nodev to replace get_sb_bdev and get_sb_nodev.
> 
> There might easily be external modules that still use this.

*nod*

They would be trivial to convert from ->get_sb() to ->mount(), but until
we are ready to remove the former (next cycle, once ->mnt_devname stuff
gets tested and merged) there's no real reason to remove them.  Precisely
because the remaining instances of get_sb_bdev() and friends will be
trivial to remove when the time comes; it's not something that will be
an obstacle to transition.

Typical conversion looks so:
-static int minix_get_sb(struct file_system_type *fs_type,
-       int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+static struct dentry *minix_mount(struct file_system_type *fs_type,
+       int flags, const char *dev_name, void *data)
 {
-       return get_sb_bdev(fs_type, flags, dev_name, data, minix_fill_super,
-                          mnt);
+       return mount_bdev(fs_type, flags, dev_name, data, minix_fill_super);
 }
 
 static struct file_system_type minix_fs_type = {
        .owner          = THIS_MODULE,
        .name           = "minix",
-       .get_sb         = minix_get_sb,
+       .mount          = minix_mount,

IOW, take foo_get_sb(), lose the vfsmount argument, call mount_bdev() instead
of get_sb_bdev() and you've got your replacement ->mount() instance.

The trickier conversions are for filesystems that may return a subtree
or mess with something unexpected in *mnt (like several nfs variants
do with mnt_devname, for very bad reasons).  But those won't be using
get_sb_bdev().  IOW, keeping that around until we are finished with
->mount() is not going to cause us any trouble.

Right now the only surviving in-tree ->get_sb() instances are in nfs
due to mnt_devname abuse.  Once these are gone, ->get_sb() will be,
and a good riddance - it was a bad API choice.  Mine, at that ;-/

Basically, we used to have ->read_super(), which filled a superblock
allocated by VFS code.  Filesystem type flags were used by VFS to
decide what to do before calling ->read_super() (basically "does
that want block device or is it anonymous").  It returned NULL or
the same struct super_block * it received to fill.

Then we switched to ->get_sb(), which asked for allocation itself and
did things like opening block device/grabbing anon device as well, so
that VFS code around mount() path could be nice and fs_type-agnostic.

That's when get_sb_bdev() et.al. had appeared - they did work common
for e.g. fs on block device, with callback provided by the caller to
do the rest of work.

We still were returning struct super_block *.  Note, however, that this
was *NOT* a superblock constructor - we were allowed to return a new
reference to existing superblock as well (and that was immediately used
for things like procfs, etc.)

About the same time we got vfsmount tree - each contained a reference
to superblock and root of dentry subtree on it.  mount --bind allowed
to create a new vfsmount with ->mnt_root pointing at the root of subtree
smaller than the entire dentry tree for ->mnt_sb, but normal mount
still gave us the whole thing.  Not a problem, we just set ->mnt_root
to ->mnt_sb->s_root when we mounted a filesystem.

Then NFS folks had come and said "we want mount() to give us a subtree
of existing superblock".  Now ->mnt_root could not be derived from
->mnt_sb.  Original proposal, IIRC, was to have root dentry returned
via struct dentry **, which was ugly.  I proposed to avoid the problems
with returning two values (superblock + dentry) by passing vfsmount we were
going to put them into anyway.

What I had missed at the time was that while ->mnt_root could not be
derived from ->mnt_sb, there was another property that still held:
mnt->mnt_root->d_sb == mnt->mnt_sb.  And that held for all vfsmounts,
full tree or not.  In other words, we didn't need to return the pair;
we just needed to turn the thing over and return *dentry*, deriving
superblock from it.  No need to pass half-filled vfsmount to fs code,
no need to call helper to set it, no need to do direct assignments
if we want a smaller subtree.

Alas, we went with "let's pass struct vfsmount * to be filled" variant.
Of course, the structure passed is the structure abused, so we ended up
growing very odd uses of those half-filled vfsmounts.  Fortunately,
most turned out to be easy to get rid of.  The only tricky one is what
nfs ended up doing, but there's a sane solution for that one (still
needs to be merged).

So right now we have
	* much saner interface available and used by almost everything in
tree.
	* ->get_sb() still there for the sake of NFS; out-of-tree users
are strongly[1] recommended to convert to ->mount().
	* ->get_sb() is going away very soon.
	* common boilerplates for use in ->get_sb() are left around until
then.

[1] well, as strong as I can feel about out-of-tree users, which is not
a damn lot.
