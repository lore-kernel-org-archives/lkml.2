Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0HYFEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 01:04:43 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:40854 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab0HYFEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 01:04:41 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
To: Valerie Aurora <vaurora@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20100824204839.GB28718@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell> <6820.1282094632@jrobl> <20100818185542.GA10850@shell> <16318.1282181699@jrobl> <20100824000505.GA20909@shell> <6881.1282616917@jrobl> <20100824204839.GB28718@shell>
Date: Wed, 25 Aug 2010 14:03:50 +0900
Message-ID: <6246.1282712630@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> No, that's not a sufficient description and leaves open questions
> about all sorts of deadlocks and race conditions.  For example,
> inotify events occur while holding locks only on one layer.  You
> obviously need to lock the top layer to update the inheritance and
> parent-child relationships.  Now you are locking the lower layer first
> and the top layer second, which is the reverse of the usual order.

I don't agree about deadlock and race condition.
When user modifies the dir hierarchy on the layer directly during
aufs_rename() is running, aufs will detect it after lock_rename().
It behaves like this.
- decide the layer where actual rename operates. create the dir
  hierarchy on it if necessary.
- lock_rename() for the layer
- calls ->rename()
or
- if the renaming file exists on the lower readonly layer, aufs will
  copyup it to the upper writable layer as the rename target name.
  In this case, ->rename() is not called.

If a user changes the dir hierarchy directly on the layer before
aufs_rename(), then the notify event tells aufs it and aufs gets the
latetst hierarchy.

If it happens before lock_rename() in aufs_rename(), aufs verifies the
relationship between the target child and the locked dir. if it differs,
return EBUSY. Of course, lock_rename() follows the "ancestors first"
order described in Documentation/filesystem/directory-locking.


> around on the lower layer is safe.  In general, your first task is to
> show a global lock ordering to prove lack of deadlocks (which I don't
> think you should spend time on because most VFS experts think it is
> impossible to do with two read-write layers).

Since you may not read this anymore and other people doesn't seem to
be intrested in aufs, it may not be meaningful to write down about
locking in aufs. But I will try.

At first,
- since aufs is FS, it has its own super_block, dentry and inode.
- super_block, dentry and inode in aufs have private data which contains
  rwsem.
- the locking order for these rwsem is child-first.
- aufs specifies FS_RENAME_DOES_D_MOVE.

locking order in aufs_rename
+ down_read() for aufs sb
  protects sb from branch-add, delete.
+ two down_write()s for src and dest child
  protects them from other processes in aufs.
+ down_write() for the dst_parent.
+ decide the layer where we will operate, by comparing the index of
  layers where the targets exist and the layer attribute (ro, rw).
+ copyup the dest dir hierarchy if necessary, by repeating
  - dget_parent(), down/up_read() for the parent (in aufs)
  - mutex_lock() for the dir (on the layer) to mkdir the non-existing
    child dir on the layer and verify the parent-child relationship.
  - mkdir and setattr on the layer.
  - mutex_unlock() the dir on the layer.
+ test they are rename-able
  if it is a dir, it must be empty (logically) or must not have children
  on the multiple branches.
+ if src_parent and dst_parent differ, down_write both. up_write for
  dst_parent may be necessary to keep the "child-first" rule in aufs.

(from here the "sub-VFS" characteristic of aufs appears)
+ lock_rename() on the layer
  and verify the every relationships between child and parent.
+ test the src_child is deletable.
+ test the dst_child is add-able or deletable if it exists.
+ vfs_rename() on the layer or copyup src_child as a dst_child name.
+ unlock_rename() on the layer

(return to aufs world)
+ d_drop() dst_child if necessary.
+ d_move()
+ up_write() for src_parent and dst_parent
+ up_write() fot src_child and dst_child
+ up_read() for aufs sb

Strictly speaking, there are more things which aufs_rename() handles
such as inode attributes, whiteout, opaque-dir, internal pointers to the
object on the layer, temporary dir-name. But they are unrelated to the
locking order essentially. So I didn't describe about them.


Thank you reading this long mail.


J. R. Okajima
