Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2GVRef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 13:34:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56217 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2GVReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 13:34:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120722100920.GZ31729@ZenIV.linux.org.uk>
References: <20120722100920.GZ31729@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 Jul 2012 10:34:10 -0700
X-Google-Sender-Auth: i8cPy2-hQ7tYioKHDx28noNeFcI
Message-ID: <CA+55aFzG9gzWRLvZMb6RnKua0=RHxBFisYSCVDNhjHBq7oq2yw@mail.gmail.com>
Subject: Re: [git pull] vfs.git; pile 1
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not pulling this until the mess with the NFS tree is sorted out.
Apparently you rebased your (public!) VFS tree, and now half of your
old pre-rebase patches are in the NFS tree.

Rebasing public trees IS NOT A VALID OPERATION! Exactly because of
messes like this.

So no. No way am I pulling a big VFS tree that apparently has random
unknown aliased commits in other trees.

                  Linus

On Sun, Jul 22, 2012 at 3:09 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> This one is *big* and changes quite a few things around VFS.  What's in there:
>
>         * the first of two really major architecture changes - death to
> open intents.  The former is finally there; it was very long in making,
> but with Miklos getting through really hard and messy final push in
> fs/namei.c, we finally have it.  Unlike his variant, this one doesn't
> introduce struct opendata; what we have instead is ->atomic_open()
> taking preallocated struct file * and passing everything via its fields.
> Instead of returning struct file *, it returns -E... on error, 0 on success
> and 1 in "deal with it yourself" case (e.g. symlink found on server,
> etc.).  See comments before fs/namei.c:atomic_open().  That made a lot of
> goodies finally possible and quite a few are in that pile: ->lookup(),
> ->d_revalidate() and ->create() do not get struct nameidata * anymore;
> ->lookup() and ->d_revalidate() get lookup flags instead, ->create()
> gets "do we want it exclusive" flag.  With the introduction of new helper
> (kern_path_locked()) we are rid of all struct nameidata instances outside
> of fs/namei.c; it's still visible in namei.h, but not for long.  Come the
> next cycle, declaration will move either to fs/internal.h or to fs/namei.c
> itself. [me, miklos, hch]
>
>         * the second major change: behaviour of final fput().  Now we
> have __fput() done without any locks held by caller *and* not from deep
> in call stack.  That obviously lifts a lot of constraints on the locking
> in there.  Moreover, it's legal now to call fput() from atomic contexts
> (which has immediately simplified life for aio.c).  We also don't need
> anti-recursion logics in __scm_destroy() anymore.  There is a price,
> though - the damn thing has become partially asynchronous.  For fput()
> from normal process we are guaranteed that pending __fput() will be done
> before the caller returns to userland, exits or gets stopped for ptrace.
> For kernel threads and atomic contexts it's done via schedule_work(),
> so theoretically we might need a way to make sure it's finished; so far
> only one such place had been found, but there might be more.  There's
> flush_delayed_fput() (do all pending __fput()) and there's __fput_sync()
> (fput() analog doing __fput() immediately).  I hope we won't need them
> often; see warnings in fs/file_table.c for details. [me, based on task_work
> series from Oleg merged last cycle]
>
>         * sync series from Jan
>
>         * large part of "death to sync_supers()" work from Artem; the only
> bits missing here are exofs and ext4 ones.  As far as I understand, those
> are going via the exofs and ext4 trees resp.; once they are in, we can
> put ->write_super() to the rest, along with the thread calling it.
>
>         * preparatory bits from unionmount series (from dhowells).
>
>         * assorted cleanups and fixes all over the place, as usual.
>
> This is not the last pile for this cycle; there's at least jlayton's
> ESTALE work and fsfreeze series (the latter - in dire need of
> fixes, so I'm not sure it'll make the cut this cycle).  I'll
> probably throw symlink/hardlink restrictions stuff from Kees into
> the next pile, too.  Plus there's a lot of misc patches I hadn't
> thrown into that one - it's large enough as it is...
>
> Please, pull from the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
>
> Shortlog:
> Al Viro (61):
>       get rid of ->mnt_longterm
>       get rid of magic in proc_namespace.c
>       qnx6: don't bother with ->i_dentry in inode-freeing callback
>       cifs: don't bother with ->i_dentry in ->destroy_inode()
>       adfs: don't bother with ->i_dentry in ->destroy_inode()
>       vfs: update documentation on ->i_dentry handling
>       affs: get rid of open-coded list_for_each_entry()
>       affs: unobfuscate affs_fix_dcache()
>       ocfs2: use list_for_each_entry in ocfs2_find_local_alias()
>       ext4: get rid of open-coded d_find_any_alias()
>       vfs: switch i_dentry/d_alias to hlist
>       coda: use list_for_each_entry
>       namei.c: let follow_link() do put_link() on failure
>       ->atomic_open() prototype change - pass int * instead of bool *
>       don't modify od->filp at all
>       make ->atomic_open() return int
>       kill opendata->{mnt,dentry}
>       kill struct opendata
>       fs/namei.c: get do_last() and friends return int
>       make finish_no_open() return int
>       switch do_dentry_open() to returning int
>       fold __dentry_open() into its sole caller
>       do_dentry_open(): take initialization of file->f_path to caller
>       switch nfs_lookup_check_intent() away from nameidata
>       nfs_lookup_verify_inode() - nd is *always* non-NULL here
>       fs/nfs/dir.c: switch to passing nd->flags instead of nd wherever possible
>       stop passing nameidata * to ->d_revalidate()
>       fs/namei.c: don't pass nameidata to d_revalidate()
>       fs/namei.c: don't pass namedata to lookup_dcache()
>       stop passing nameidata to ->lookup()
>       fs/namei.c: don't pass nameidata to __lookup_hash() and lookup_real()
>       don't pass nameidata to ->create()
>       don't pass nameidata * to vfs_create()
>       get rid of kern_path_parent()
>       sysfs: switch to ->s_d_op and ->d_release()
>       sysfs: just use d_materialise_unique()
>       __d_unalias() should refuse to move mountpoints
>       debugfs: make sure that debugfs_create_file() gets used only for regulars
>       debugfs: fold debugfs_create_by_name() into the only caller
>       debugfs: get rid of useless arguments to debugfs_{mkdir,symlink}
>       mark_files_ro(): don't bother with mntget/mntput
>       do_dentry_open(): close the race with mark_files_ro() in failure exit
>       signal: make sure we don't get stopped with pending task_work
>       trimming task_work: kill ->data
>       trim task_work: get rid of hlist
>       merge task_work and rcu_head, get rid of separate allocation for keyring case
>       move exit_task_work() past exit_files() et.al.
>       deal with task_work callbacks adding more work
>       switch fput to task_work_add
>       aio: now fput() is OK from interrupt context; get rid of manual delayed __fput()
>       get rid of ->scm_work_list
>       hold task_lock around checks in keyctl
>       unobfuscate follow_up() a bit
>       tidy up namei.c a bit
>       don't expose I_NEW inodes via dentry->d_inode
>       ecryptfs: don't reinvent the wheels, please - use struct completion
>       zoran: don't bother with struct file * in zoran_map
>       spufs: shift dget/mntget towards dentry_open()
>       switch dentry_open() to struct path, make it grab references itself
>       btrfs: switch btrfs_ioctl_balance() to mnt_want_write_file()
>       ext4: switch EXT4_IOC_RESIZE_FS to mnt_want_write_file()
>
> Andrew Morton (1):
>       notify_change(): check that i_mutex is held
>
> Artem Bityutskiy (23):
>       affs: stop setting bm_flags
>       affs: remove useless superblock writeout on unmount
>       affs: remove useless superblock writeout on remount
>       affs: re-structure superblock locking a bit
>       affs: stop using lock_super
>       affs: introduce VFS superblock object back-reference
>       affs: get rid of affs_sync_super
>       hfsplus: make hfsplus_sync_fs static
>       hfsplus: amend debugging print
>       hfsplus: remove useless check
>       hfsplus: get rid of write_super
>       hfs: push lock_super down
>       hfs: get rid of lock_super
>       hfs: remove extra mdb write on unmount
>       hfs: simplify a bit checking for R/O
>       hfs: introduce VFS superblock object back-reference
>       hfs: get rid of hfs_sync_super
>       fs/sysv: remove useless write_super call
>       fs/sysv: remove another useless write_super call
>       fs/sysv: stop using write_super and s_dirt
>       fs/ufs: remove extra superblock write on unmount
>       fs/ufs: re-arrange the code a bit
>       fs/ufs: get rid of write_super
>
> Christoph Hellwig (2):
>       fs: move path_put on failure out of ->follow_link
>       fs: add nd_jump_link
>
> David Howells (6):
>       VFS: Fix the banner comment on lookup_open()
>       VFS: Make chown() and lchown() call fchownat()
>       VFS: Make clone_mnt()/copy_tree()/collect_mounts() return errors
>       VFS: Comment mount following code
>       VFS: Pass mount flags to sget()
>       VFS: Split inode_permission()
>
> Eric Sandeen (3):
>       vfs: allow custom EOF in generic_file_llseek code
>       ext4: use core vfs llseek code for dir seeks
>       ext3: pass custom EOF to generic_file_llseek_size()
>
> Jan Kara (8):
>       vfs: Move noop_backing_dev_info check from sync into writeback
>       quota: Split dquot_quota_sync() to writeback and cache flushing part
>       quota: Move quota syncing to ->sync_fs method
>       vfs: Reorder operations during sys_sync
>       vfs: Create function for iterating over block devices
>       vfs: Make sys_sync writeout also block device inodes
>       vfs: Remove unnecessary flushing of block devices
>       vfs: Avoid unnecessary WB_SYNC_NONE writeback during sys_sync and reorder sync passes
>
> Julia Lawall (1):
>       fs/direct-io.c: adjust suspicious bit operation
>
> Miklos Szeredi (21):
>       vfs: do_last(): inline lookup_slow()
>       vfs: do_last(): separate O_CREAT specific code
>       vfs: do_last(): common slow lookup
>       vfs: add lookup_open()
>       vfs: lookup_open(): expand lookup_hash()
>       vfs: add i_op->atomic_open()
>       nfs: implement i_op->atomic_open()
>       nfs: clean up ->create in nfs_rpc_ops
>       nfs: don't use nd->intent.open.flags
>       nfs: don't use intents for checking atomic open
>       fuse: implement i_op->atomic_open()
>       cifs: implement i_op->atomic_open()
>       ceph: remove unused arg from ceph_lookup_open()
>       ceph: implement i_op->atomic_open()
>       9p: implement i_op->atomic_open()
>       vfs: remove open intents from nameidata
>       vfs: do_last(): clean up error handling
>       vfs: do_last(): clean up labels
>       vfs: do_last(): clean up bool
>       vfs: do_last(): clean up retry
>       vfs: move O_DIRECT check to common code
