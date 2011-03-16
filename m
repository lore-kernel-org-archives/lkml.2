Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab1CPGTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:19:33 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25024 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab1CPGTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:19:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAK7wf015LK5JgWdsb2JhbACmDBUBARYmJcEJDYVVBA
Date: Wed, 16 Mar 2011 17:19:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110316061917.GA30195@dastard>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315213248.GL22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 09:32:48PM +0000, Al Viro wrote:
> 	Let's try to start pushing early in the window this time...
> There are several big ones in that:
> 	* pathname resolution rewrite: trailing symlink resolution is
> iterative in all cases, overall structure simplified a _lot_, do_lookup()
> turned into something readable, knowledge of RCU stuff localized, do_last()
> returned to handling non-create cases as well, NEED_REVAL_DOT got a lot
> saner.
> 	* open-by-fhandle series by Aneesh
> 	* O_PATH descriptors (basically, "location in namespace, not actually
> opened from fs POV, can be dup'ed/passed around/etc. and used as starting
> points in ...at(2) kind of syscalls, but not used for any IO; that stuff
> allows to do sane pathname resolution in userland and avoids the need to
> add fsckloads of extra syscalls in open-by-fhandle series).
> 
> There will be more pull requests; this is just taking care of really
> heavy-weight stuff.
> 
> Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

I think there's something not quite right in this tree. xfstests 005
(nested symlink test) fails on both ext4 and XFS with the following:

[   47.457457] EXT4-fs (vda): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   48.694685] ------------[ cut here ]------------
[   48.695168] kernel BUG at fs/dcache.c:436!
[   48.695568] invalid opcode: 0000 [#1] SMP 
[   48.695997] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/virtio2/block/vdb/removable
[   48.696835] CPU 0 
[   48.697021] Modules linked in:
[   48.697332] 
[   48.697332] Pid: 5851, comm: ln Not tainted 2.6.38-dgc+ #1096 Bochs Bochs
[   48.697332] RIP: 0010:[<ffffffff8118141a>]  [<ffffffff8118141a>] dput+0x28a/0x290
[   48.697332] RSP: 0018:ffff880079cf9ca8  EFLAGS: 00010246
[   48.697332] RAX: 0000000000000000 RBX: ffff8800710c38b0 RCX: 0000000000000000
[   48.697332] RDX: ffff88007f20ed20 RSI: ffff8800710c3928 RDI: 0000000000000246
[   48.697332] RBP: ffff880079cf9cd8 R08: 0000000000000000 R09: 0000000000000000
[   48.697332] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffd8
[   48.697332] R13: ffff880079cde4c0 R14: ffff8800710c3910 R15: 0000000000000001
[   48.697332] FS:  00007fba3bcaf700(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
[   48.697332] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   48.697332] CR2: 00007fba3b8047d0 CR3: 0000000078415000 CR4: 00000000000006f0
[   48.697332] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   48.697332] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   48.697332] Process ln (pid: 5851, threadinfo ffff880079cf8000, task ffff880079cde4c0)
[   48.697332] Stack:
[   48.697332]  ffff880079cf9dd8 ffff880079cf9d38 ffffffffffffffd8 ffff880079cde4c0
[   48.697332]  ffffffffffffffd8 0000000000000001 ffff880079cf9cf8 ffffffff8117352a
[   48.697332]  ffff880079cf9dd8 ffff880079cf9dd8 ffff880079cf9d98 ffffffff8117796b
[   48.697332] Call Trace:
[   48.697332]  [<ffffffff8117352a>] path_put+0x1a/0x30
[   48.697332]  [<ffffffff8117796b>] path_lookupat+0x2cb/0x770
[   48.697332]  [<ffffffff81177e43>] do_path_lookup+0x33/0x80
[   48.697332]  [<ffffffff81178ac9>] user_path_at+0x59/0xb0
[   48.697332]  [<ffffffff81b434a0>] ? do_page_fault+0x230/0x4e0
[   48.697332]  [<ffffffff8116d83c>] vfs_fstatat+0x4c/0x90
[   48.697332]  [<ffffffff8116d9ab>] vfs_stat+0x1b/0x20
[   48.697332]  [<ffffffff8116d9d4>] sys_newstat+0x24/0x50
[   48.697332]  [<ffffffff81b3eb09>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   48.697332]  [<ffffffff8103cf42>] system_call_fastpath+0x16/0x1b
[   48.697332] Code: 48 89 93 d0 00 00 00 4c 89 a0 d8 01 00 00 48 8b 83 b0 00 00 00 ff 80 e8 01 00 00 ff 05 54 4a df 00 e8 6b e4 9b 00 e9 77 fe ff ff <0f> 0b eb fe 66  
[   48.697332] RIP  [<ffffffff8118141a>] dput+0x28a/0x290
[   48.697332]  RSP <ffff880079cf9ca8>
[   48.719193] ---[ end trace bdba6e6dd185beb8 ]---

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
