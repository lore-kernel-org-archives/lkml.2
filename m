Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0HRX3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:29:42 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:56685 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030Ab0HRX3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:29:38 -0400
Date: Thu, 19 Aug 2010 09:29:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        npiggin@kernel.dk, a.p.zijlstra@chello.nl
Subject: Re: [bug] radix_tree_gang_lookup_tag_slot() looping endlessly
Message-ID: <20100818232917.GN7362@dastard>
References: <20100818135651.GK7362@dastard>
 <20100818173708.GB15010@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818173708.GB15010@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 07:37:09PM +0200, Jan Kara wrote:
>   Hi,
> 
> On Wed 18-08-10 23:56:51, Dave Chinner wrote:
> > I'm seeing a livelock with the new writeback sync livelock avoidance
> > code. The problem is that the radix tree lookup via
> > pagevec_lookup_tag()->find_get_pages_tag() is getting stuck in
> > radix_tree_gang_lookup_tag_slot() and never exitting.
>   Is this pagevec_lookup_tag() from write_cache_pages() which was called
> for fsync() or so? 

Called from a direct IO doing a cache flush-invalidate call
across the range the direct IO spans.

fsstress      R  running task        0  2514   2513 0x00000008
 ffff88007da5fa98 ffffffff8110c0d5 ffff88007da5fc28 ffff880078f0c418
 ffff88007da5fbc8 ffffffff8110ae7b ffff88007da5fb08 0000000000000297
 ffffffffffffffff 0000000100000000 ffff88007da5fb20 00000002810d79ae
Call Trace:
 [<ffffffff8110c0d5>] ? pagevec_lookup_tag+0x25/0x40
 [<ffffffff8110ae7b>] write_cache_pages+0x10b/0x490
 [<ffffffff81109d30>] ? __writepage+0x0/0x50
 [<ffffffff813fc1fe>] ? do_raw_spin_unlock+0x5e/0xb0
 [<ffffffff8110c7dc>] ? release_pages+0x20c/0x270
 [<ffffffff813fc2a4>] ? do_raw_spin_lock+0x54/0x160
 [<ffffffff813f0ca2>] ? radix_tree_gang_lookup_slot+0x72/0xb0
 [<ffffffff8110b227>] generic_writepages+0x27/0x30
 [<ffffffff8130fc5d>] xfs_vm_writepages+0x5d/0x80
 [<ffffffff8110b254>] do_writepages+0x24/0x40
 [<ffffffff8110237b>] __filemap_fdatawrite_range+0x5b/0x60
 [<ffffffff811023da>] filemap_write_and_wait_range+0x5a/0x80
 [<ffffffff81103117>] generic_file_aio_read+0x417/0x6d0
 [<ffffffff81315f7c>] xfs_file_aio_read+0x15c/0x310
 [<ffffffff811456da>] do_sync_read+0xda/0x120
 [<ffffffff813c36ff>] ? security_file_permission+0x6f/0x80
 [<ffffffff81145a25>] vfs_read+0xc5/0x180
 [<ffffffff81146151>] sys_read+0x51/0x80
 [<ffffffff81036032>] system_call_fastpath+0x16/0x1b

>From the writeback tracing, it shows it stuck like with his writeback control:

fsstress-2514  [001] 950360.214327: wbc_writepage: bdi 253:0: towrt=9223372036854775807 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x79000 end=0x7fffffffffffffff
fsstress-2514  [001] 950360.214348: wbc_writepage: bdi 253:0: towrt=9223372036854775806 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x79000 end=0x7fffffffffffffff


> > The reproducer I'm running is xfstests 013 on 2.6.35-rc1 with some
> > pending XFS changes available here:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git for-oss
> > 
> > It's 100% reproducable, and a regression against 2.6.35 patched wth exactly
> > the same extra XFS commits as the above branch.
>   Hmm, what HW config do you have?

It's a VM started with:

$ cat /vm-images/vm-2/run-vm-2.sh 
#!/bin/sh
sudo /usr/bin/kvm \
        -kvm-shadow-memory 16 \
        -no-fd-bootchk \
        -localtime \
        -boot c \
        -serial pty \
        -nographic \
        -alt-grab \
        -smp 2 -m 2048 \
        -hda /vm-images/vm-2/root.img \
        -drive file=/vm-images/vm-2/vm-2-test.img,if=virtio,cache=none \
        -drive file=/vm-images/vm-2/vm-2-scratch.img,if=virtio,cache=none \
        -net nic,vlan=0,macaddr=00:e4:b6:63:63:6e,model=virtio \
        -net tap,vlan=0,script=/vm-images/qemu-ifup,downscript=no \
        -kernel /vm-images/vm-2/vmlinuz \
        -append "console=ttyS0,115200 root=/dev/sda1"


> I didn't hit the livelock and I've been
> running xfstests several times with the livelock avoidance patch.

Christoph hasn't seen it either.

> Hmm,
> looking at the code maybe what you describe could happen if we remove the
> page from page cache but leave a dangling tag in the radix tree... But
> remove_from_page_cache() is called with tree_lock held and it removes all
> tags from the index we just remove so it shouldn't really happen.

This might be a stupid question, but here goes anyway. I know the
slot contents are protected on lookup by rcu_read_lock() and
rcu_dereference_raw(), but what protects the tags on read? AFAICT,
they are being looked up without any locking, memory barriers, etc
w.r.t. deletion. i.e. I cannot see how a tag lookup is prevented
from racing with the propagation of a tag removal back up the tree
(which is done under the tree lock). What am I missing?

> Could
> you dump more info about the inode this happens on? Like the i_size, the
> index we stall at... Thanks.

>From the writeback tracing I know that the index is different for
every stall, and given that it is fsstress producing the hang I'd
guess the inode is different every time, too. I'll try to get more
data on this later today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
