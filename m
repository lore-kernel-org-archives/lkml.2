Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab1KOSQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:16:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38567 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab1KOSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:16:06 -0500
Date: Tue, 15 Nov 2011 19:15:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeff Mahoney <jeffm@suse.com>
Subject: Re: kernel 3.1.1 / 3.1.0 reiserfs locking problems
Message-ID: <20111115181553.GA3234@somewhere>
References: <4EAE5DE3.2020205@t-online.de>
 <CA+55aFzuWD1xRhQNLfe0ey_-1vACwY=ofD5PXSzL_5UeDRbk8g@mail.gmail.com>
 <4EC27039.6010904@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC27039.6010904@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 02:59:21PM +0100, Knut Petersen wrote:
> Am 31.10.2011 16:08, schrieb Linus Torvalds:
> 
> With kernel 3.1.1 there is another reiserfs related lock probleme:
> 
> Nov 15 11:37:27 golem kernel: [ 1986.896976]
> Nov 15 11:37:27 golem kernel: [ 1986.896979] =================================
> Nov 15 11:37:27 golem kernel: [ 1986.896990] [ INFO: inconsistent lock state ]
> Nov 15 11:37:27 golem kernel: [ 1986.896997] 3.1.1-main #8
> Nov 15 11:37:27 golem kernel: [ 1986.897001] ---------------------------------
> Nov 15 11:37:27 golem kernel: [ 1986.897007] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> Nov 15 11:37:27 golem kernel: [ 1986.897016] kswapd0/16 [HC0[0]:SC0[0]:HE1:SE1] takes:
> Nov 15 11:37:27 golem kernel: [ 1986.897023]  (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c01f8bd4>] reiserfs_write_lock+0x20/0x2a
> Nov 15 11:37:27 golem kernel: [ 1986.897044] {RECLAIM_FS-ON-W} state was registered at:
> Nov 15 11:37:27 golem kernel: [ 1986.897050]   [<c014a5b9>] mark_held_locks+0xae/0xd0
> Nov 15 11:37:27 golem kernel: [ 1986.897060]   [<c014aab3>] lockdep_trace_alloc+0x7d/0x91
> Nov 15 11:37:27 golem kernel: [ 1986.897068]   [<c0190ee0>] kmem_cache_alloc+0x1a/0x93
> Nov 15 11:37:27 golem kernel: [ 1986.897078]   [<c01e7728>] reiserfs_alloc_inode+0x13/0x3d
> Nov 15 11:37:27 golem kernel: [ 1986.897088]   [<c01a5b06>] alloc_inode+0x14/0x5f
> Nov 15 11:37:27 golem kernel: [ 1986.897097]   [<c01a5cb9>] iget5_locked+0x62/0x13a
> Nov 15 11:37:27 golem kernel: [ 1986.897106]   [<c01e99e0>] reiserfs_fill_super+0x410/0x8b9
> Nov 15 11:37:27 golem kernel: [ 1986.897114]   [<c01953da>] mount_bdev+0x10b/0x159
> Nov 15 11:37:27 golem kernel: [ 1986.897123]   [<c01e764d>] get_super_block+0x10/0x12
> Nov 15 11:37:27 golem kernel: [ 1986.897131]   [<c0195b38>] mount_fs+0x59/0x12d
> Nov 15 11:37:27 golem kernel: [ 1986.897138]   [<c01a80d1>] vfs_kern_mount+0x45/0x7a
> Nov 15 11:37:27 golem kernel: [ 1986.897147]   [<c01a83e3>] do_kern_mount+0x2f/0xb0
> Nov 15 11:37:27 golem kernel: [ 1986.897155]   [<c01a987a>] do_mount+0x5c2/0x612
> Nov 15 11:37:27 golem kernel: [ 1986.897163]   [<c01a9a72>] sys_mount+0x61/0x8f
> Nov 15 11:37:27 golem kernel: [ 1986.897170]   [<c044060c>] sysenter_do_call+0x12/0x32

The most straightforward way to solve this is to unlock before getting the superblock
inode:

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 14363b9..463c203 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1762,9 +1762,11 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	}
 	args.objectid = REISERFS_ROOT_OBJECTID;
 	args.dirid = REISERFS_ROOT_PARENT_OBJECTID;
+	reiserfs_write_unlock(s);
 	root_inode =
 	    iget5_locked(s, REISERFS_ROOT_OBJECTID, reiserfs_find_actor,
 			 reiserfs_init_locked_inode, (void *)(&args));
+	reiserfs_write_lock(s);
 	if (!root_inode) {
 		SWARN(silent, s, "jmacd-10", "get root inode failed");
 		goto error;

But may be there are other iget5_locked in the path that I missed.

Note this should be a harmless warning because I guess the filesystem can't be
used for memory reclaim before it is actually mounted. But still this is
annoying and the above fix is one more hack to cope with the fact we need to
hold the lock from the mount path early even if we don't need it. That's
because many helpers used there assume the lock is always taken when they
are called. This assumption come from the bkl times.

So probably I should try to clean up this a bit to solve it in a less
dirty way. I'll try to come with something soon.
