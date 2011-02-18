Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1BRSVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:21:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40598 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1BRSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:21:51 -0500
Date: Fri, 18 Feb 2011 18:21:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, liuqi <liuqi@thunderst.com>,
        LiDongyang <jerry87905@gmail.com>
Subject: Re: [PATCH 1/2] add ->mount function introduction into
 Documentation/filesystems/porting
Message-ID: <20110218182148.GM22723@ZenIV.linux.org.uk>
References: <AANLkTinY6VHGGokQ1e0YzO-jpvyjR1QrS6nwLm3TG=D5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinY6VHGGokQ1e0YzO-jpvyjR1QrS6nwLm3TG=D5@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 12:17:44AM +0800, Steven Liu wrote:
> +the VFS will call the appropriate get_sb() or mount() method for
> +the specific filesystem. The dentry for the mount point will then
> +be updated to point to the root inode for the new filesystem.

What do you mean, "updated"?  What happens is this
	* filesystem driver will get the arguments of mount(2) telling
what to mount and return you a reference to dentry in the root of
the (sub)tree you have asked for.  Depending on the filesystem type
and argument it might be on an already existing fs or on a new one.
In the latter case filesystem driver will take care of creating a new fs
(getting superblock allocated, filled, etc.)
	* VFS will create a new vfsmount refering to that subtree and
attach it to the mountpoint you have given.

> +The mount() method must determine if the block device specified
> +in the dev_name and fs_type contains a filesystem of the type the method
> +supports. If it succeeds in opening the named block device, it initializes a
> +struct super_block descriptor for the filesystem contained by the block device.
> +On failure it returns an error.

No.  Interpretation of ->mount() arguments is entirely up to ->mount().
Many filesystem types interpret dev_name as pathname of block device to be
opened, with the filesystem backed by that device.  It is by no means
mandatory, _even_ _for_ _block-based_ _fs_.  There are filesystems that
choose to do it differently.  What you've described is mount_bdev().

->mount() is NOT a superblock constructor.  It may have to create one,
but that's up to fs.  For everybody outside its job is to give you
a dentry (sub)tree.  If it's going to be on a new superblock, so be it,
but that's really not a concern of VFS.  It _will_ grab a reference to
whatever superblock these dentries live on and that reference will be
kept as long as vfsmount lives, but that's just a "don't shut that
one down as long as you want that dentry tree around" thing.

Note that even mount_bdev() may return an old struct super_block.  Mount
e.g. ext2 from the same device twice (with the same flags) and you'll get
two vfsmounts with identical ->mnt_root/->mnt_sb.  Things like e.g. sysfs
*always* return the same superblock.  Things like nfs are in between -
depending on what options you give you might end up with an old superblock
or with a new one.  Note that depending on the options you may get a new
subtree backed by old superblock.

If you are looking for superblock constructor, it's sget().  It finds a
superblock of given type satisfying given condition or creates a new one.
In any case, a reference to superblock is returned to caller locked.
grep and you'll see how it's used; that'll give you the instances of
->mount/->get_sb and helpers used by such.

Again, as far as VFS is concerned, the main purpose of ->mount() is to give
it a tree to attach; creation of new superblock is a common side effect,
but that's really up to fs.  Hell, it doesn't even have to be of the same
type - see e.g. what cpuset is doing.  And yes, it's perfectly legitimate.

> +Usually, a filesystem uses one of the generic mount() implementations
> +and provides a fill_super() method instead.

s/method/callback/

> The generic methods are:
s/methods/helpers/
> +  mount_bdev: mount a filesystem residing on a block device
> +
> +  mount_nodev: mount a filesystem that is not backed by a device
> +
> +  mount_single: mount a filesystem which shares the instance between
> +  	all mounts


FWIW, file_system_type is a bit odd.  I'm not sure it's worth messing with,
but essentially what we have there is a mix of several things.
	a) ->kill_sb() and "behaviour" flags are really properties of
individual superblock.  ->kill_sb probably belongs in ->super_operations.
	b) (name, ->mount, ->owner) triple is how VFS finds which ->mount()
to call when asked to mount fs of this type and what module to pin down
for the duration.  It's what /proc/filesystems refers to and "is that a block
one?" flag is relevant only for that (the only effect is whether we slap
"nodev" in the corresponding line of /proc/filesystems or put spaces in there -
really)
	c) type for the purposes of sget().  This is a dynamic object -
collection of all superblocks of the same type.  ->name and ->owner are
relevant here as well.  Note that it's *NOT* necessary the same one we
talked to when we did mount(2) - see cpuset again, or weirder nfs ones.
The latter add superblocks into _usual_ nfs types, so you end up with
e.g. crossing server device boundary on nfs4, stepping into automount point
and calling vfs_kern_mount() on nfs4_xdev_fs_type.  It calls nfs4_xdev_mount(),
which will do sget() in nfs4_fs_type.  As the result, you get a superblock
of a different type - nfs4.  As the matter of fact,

struct file_system_type nfs4_xdev_fs_type = {
        .mount          = nfs4_xdev_mount,
};

would suffice - the rest of its initializer is pure fluff.  It's &nfs4_fs_type
that will be in s->s_type and it's nfs4_fs_type ->kill_sb() that will be
called, etc.  Doesn't even need a name, since we never register it and refer
to the sucker directly...

It's probably not worth the effort trying to separate these objects.  We'd
need more boilerplate code for very little additional clarity in the area
that isn't particulary tricky to start with.
