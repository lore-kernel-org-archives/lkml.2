Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1BRCpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:45:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33058 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab1BRCpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GbswVuBlFbXH2F8NXf4zcj8ih63gLa3RRwrW/pZXapHvWtDQ5XIepQcbgOAXu1v1A2
         J29Yc2Pp5vDdY0bDpEy4p1fX7SlVRhOwSiGezQ15ckYaXWHO9PvNC5qyiXmFc+ACgyqf
         3vMdCkFzWDf+9mcPEaSRv6SAZJNW/KWj7OesY=
MIME-Version: 1.0
In-Reply-To: <20110217173615.GJ22723@ZenIV.linux.org.uk>
References: <AANLkTi=50m7xULN+Mob1942b+qBEgMcqUPDWSd3inan6@mail.gmail.com>
	<AANLkTim2fg5OUw2aZXA-4V4O7PUQ6T4mhoWxvjNdtYcc@mail.gmail.com>
	<20110217173615.GJ22723@ZenIV.linux.org.uk>
Date: Fri, 18 Feb 2011 10:45:12 +0800
Message-ID: <AANLkTinN1CamMpKZ5O3nDeV+LXpcMVZpxT59J7mJ5HQo@mail.gmail.com>
Subject: Re: [PATCH] code cleanup on fs/super.c
From: Steven Liu <lingjiujianke@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, randy.dunlap@oracle.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dchinner@redhat.com, liuqi <liuqi@thunderst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  AI Viro,

     I have saw this message, :)

     I think the nfs is using fs_type->get_sb, but it isn't using
get_sb_bdev(or get_sb_nodev) .
     So if the nfs cannot let
     struct dentry *(*mount) (struct file_system_type *, int,
               const char *, void *);
     to replace

     int (*get_sb) (struct file_system_type *, int,
               const char *, void *, struct vfsmount *);
     Now, this patch cannot influence nfs normal use.
     Because get_sb is not must use get_sb_bdev or get_sb_nodev to get mnt,
     All the filesystem are using mount_bdev mount_nodev now, but it
isn't called
     by get_sb,is called by *mount. Do you agreed with me?



Best Regards


LiuQi


2011/2/18 Al Viro <viro@zeniv.linux.org.uk>:
> On Thu, Feb 17, 2011 at 08:20:31AM -0800, Linus Torvalds wrote:
>> On Thu, Feb 17, 2011 at 12:59 AM, Steven Liu <lingjiujianke@gmail.com> wrote:
>> >
>> > ? Clean up the unsed code on fs/super.c, all filesystem using mount_bdev
>> > ? and mount_nodev to replace get_sb_bdev and get_sb_nodev.
>>
>> There might easily be external modules that still use this.
>
> *nod*
>
> They would be trivial to convert from ->get_sb() to ->mount(), but until
> we are ready to remove the former (next cycle, once ->mnt_devname stuff
> gets tested and merged) there's no real reason to remove them.  Precisely
> because the remaining instances of get_sb_bdev() and friends will be
> trivial to remove when the time comes; it's not something that will be
> an obstacle to transition.
>
> Typical conversion looks so:
> -static int minix_get_sb(struct file_system_type *fs_type,
> -       int flags, const char *dev_name, void *data, struct vfsmount *mnt)
> +static struct dentry *minix_mount(struct file_system_type *fs_type,
> +       int flags, const char *dev_name, void *data)
>  {
> -       return get_sb_bdev(fs_type, flags, dev_name, data, minix_fill_super,
> -                          mnt);
> +       return mount_bdev(fs_type, flags, dev_name, data, minix_fill_super);
>  }
>
>  static struct file_system_type minix_fs_type = {
>        .owner          = THIS_MODULE,
>        .name           = "minix",
> -       .get_sb         = minix_get_sb,
> +       .mount          = minix_mount,
>
> IOW, take foo_get_sb(), lose the vfsmount argument, call mount_bdev() instead
> of get_sb_bdev() and you've got your replacement ->mount() instance.
>
> The trickier conversions are for filesystems that may return a subtree
> or mess with something unexpected in *mnt (like several nfs variants
> do with mnt_devname, for very bad reasons).  But those won't be using
> get_sb_bdev().  IOW, keeping that around until we are finished with
> ->mount() is not going to cause us any trouble.
>
> Right now the only surviving in-tree ->get_sb() instances are in nfs
> due to mnt_devname abuse.  Once these are gone, ->get_sb() will be,
> and a good riddance - it was a bad API choice.  Mine, at that ;-/
>
> Basically, we used to have ->read_super(), which filled a superblock
> allocated by VFS code.  Filesystem type flags were used by VFS to
> decide what to do before calling ->read_super() (basically "does
> that want block device or is it anonymous").  It returned NULL or
> the same struct super_block * it received to fill.
>
> Then we switched to ->get_sb(), which asked for allocation itself and
> did things like opening block device/grabbing anon device as well, so
> that VFS code around mount() path could be nice and fs_type-agnostic.
>
> That's when get_sb_bdev() et.al. had appeared - they did work common
> for e.g. fs on block device, with callback provided by the caller to
> do the rest of work.
>
> We still were returning struct super_block *.  Note, however, that this
> was *NOT* a superblock constructor - we were allowed to return a new
> reference to existing superblock as well (and that was immediately used
> for things like procfs, etc.)
>
> About the same time we got vfsmount tree - each contained a reference
> to superblock and root of dentry subtree on it.  mount --bind allowed
> to create a new vfsmount with ->mnt_root pointing at the root of subtree
> smaller than the entire dentry tree for ->mnt_sb, but normal mount
> still gave us the whole thing.  Not a problem, we just set ->mnt_root
> to ->mnt_sb->s_root when we mounted a filesystem.
>
> Then NFS folks had come and said "we want mount() to give us a subtree
> of existing superblock".  Now ->mnt_root could not be derived from
> ->mnt_sb.  Original proposal, IIRC, was to have root dentry returned
> via struct dentry **, which was ugly.  I proposed to avoid the problems
> with returning two values (superblock + dentry) by passing vfsmount we were
> going to put them into anyway.
>
> What I had missed at the time was that while ->mnt_root could not be
> derived from ->mnt_sb, there was another property that still held:
> mnt->mnt_root->d_sb == mnt->mnt_sb.  And that held for all vfsmounts,
> full tree or not.  In other words, we didn't need to return the pair;
> we just needed to turn the thing over and return *dentry*, deriving
> superblock from it.  No need to pass half-filled vfsmount to fs code,
> no need to call helper to set it, no need to do direct assignments
> if we want a smaller subtree.
>
> Alas, we went with "let's pass struct vfsmount * to be filled" variant.
> Of course, the structure passed is the structure abused, so we ended up
> growing very odd uses of those half-filled vfsmounts.  Fortunately,
> most turned out to be easy to get rid of.  The only tricky one is what
> nfs ended up doing, but there's a sane solution for that one (still
> needs to be merged).
>
> So right now we have
>        * much saner interface available and used by almost everything in
> tree.
>        * ->get_sb() still there for the sake of NFS; out-of-tree users
> are strongly[1] recommended to convert to ->mount().
>        * ->get_sb() is going away very soon.
>        * common boilerplates for use in ->get_sb() are left around until
> then.
>
> [1] well, as strong as I can feel about out-of-tree users, which is not
> a damn lot.
>
