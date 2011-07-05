Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1GERU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:20:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53312 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab1GERU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:20:56 -0400
Date: Tue, 5 Jul 2011 18:20:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        Peter Kruse <pk@q-leap.de>, linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
Message-ID: <20110705172043.GA15147@csn.ul.ie>
References: <alpine.DEB.2.00.1102171102520.11140@router.home>
 <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de>
 <4D6648B5.1090306@q-leap.com>
 <4DA4692D.7080207@q-leap.de>
 <alpine.DEB.2.00.1104121306581.14692@router.home>
 <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com>
 <4DA54D2A.3050206@q-leap.de>
 <alpine.DEB.2.00.1104131116330.19493@router.home>
 <4E09BEA1.1080501@q-leap.de>
 <alpine.DEB.2.00.1107051013500.16869@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107051013500.16869@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 10:18:44AM -0500, Christoph Lameter wrote:
> On Tue, 28 Jun 2011, Peter Kruse wrote:
> 
> > the server crashed again, I attach the dmesg and kern.log that
> > contain some call traces.  Could you have a look again?
> > This time the server runs 2.6.32.29.
> 
> These are messages about a hung task. I do not see any page allocation
> failures in this log anymore. Mel can you have a look. Could it be that
> something holds up reclaim?

This is a new issue to me and I see it's against 2.6.32.29 which
isn't even the latest stable 2.6.32 so I don't think I'll be able to
dedicate a lot of time to this.

If kswapd is stuck in a loop, it's possible that it's stuck trying to
shrink slab, failing and unable to free the associated pages. sysrq+m
might have given a hint but I also see some worrying things like this
while glancing through the traces;

Jun 28 09:01:14 beosrv1-t kernel: [3702691.182966] dsmc          R  running task        0 27835      1 0x00020000
Jun 28 09:01:14 beosrv1-t kernel: [3702691.183139]  ffff88006ad6b728 0000000000000082 ffffffff8100b92e ffff88006ad6b728
Jun 28 09:01:14 beosrv1-t kernel: [3702691.183423]  000000000000dd08 ffff88006ad6bfd8 00000000000115c0 00000000000115c0
Jun 28 09:01:14 beosrv1-t kernel: [3702691.183707]  0000000000000000 ffffffffa00ef883 ffff880a18d5b810 ffff88006eccc770
Jun 28 09:01:14 beosrv1-t kernel: [3702691.183990] Call Trace:
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184060]  [<ffffffff8100b92e>] ? apic_timer_interrupt+0xe/0x20
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184149]  [<ffffffffa00ef883>] ? xfs_reclaim_inode+0x0/0xef [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184237]  [<ffffffffa00f0370>] ? xfs_inode_ag_iterator+0x6f/0xaf [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184327]  [<ffffffffa00ef883>] ? xfs_reclaim_inode+0x0/0xef [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184406]  [<ffffffff81034ad5>] __cond_resched+0x25/0x31
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184483]  [<ffffffff813dd3d3>] ? _cond_resched+0x0/0x2f
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184560]  [<ffffffff813dd3f7>] _cond_resched+0x24/0x2f
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184637]  [<ffffffff810779cb>] shrink_slab+0x10d/0x154
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184713]  [<ffffffff81078694>] try_to_free_pages+0x221/0x31c
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184791]  [<ffffffff810757de>] ? isolate_pages_global+0x0/0x1f0
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184869]  [<ffffffff8107260d>] __alloc_pages_nodemask+0x3fd/0x600
Jun 28 09:01:14 beosrv1-t kernel: [3702691.184948]  [<ffffffff81094d83>] kmem_getpages+0x5c/0x127
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185024]  [<ffffffff81094f6d>] fallback_alloc+0x11f/0x195
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185102]  [<ffffffff8109510c>] ____cache_alloc_node+0x129/0x138
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185180]  [<ffffffff81095ad5>] kmem_cache_alloc+0xd1/0xfe
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185268]  [<ffffffffa00e5aab>] kmem_zone_alloc+0x67/0xaf [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185358]  [<ffffffffa00cbdb1>] xfs_inode_alloc+0x24/0xcd [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185448]  [<ffffffffa00c0473>] ? xfs_dir_lookup+0xfc/0x153 [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185539]  [<ffffffffa00cc10c>] xfs_iget+0x2b2/0x472 [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185628]  [<ffffffffa00e3b1a>] xfs_lookup+0x7d/0xae [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185715]  [<ffffffffa00ebf43>] xfs_vn_lookup+0x3f/0x7e [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185793]  [<ffffffff810a2d29>] do_lookup+0xd5/0x1b9
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185869]  [<ffffffff810a4f35>] __link_path_walk+0x92e/0xdea
Jun 28 09:01:14 beosrv1-t kernel: [3702691.185946]  [<ffffffff810a2cb7>] ? do_lookup+0x63/0x1b9
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186024]  [<ffffffff810a5639>] path_walk+0x69/0xd4
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186100]  [<ffffffff810a5783>] do_path_lookup+0x29/0x51
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186176]  [<ffffffff810a61ab>] user_path_at+0x52/0x93
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186261]  [<ffffffffa00a4cff>] ? posix_acl_access_exists+0x2e/0x38 [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186351]  [<ffffffffa00f0988>] ? xfs_vn_listxattr+0xbd/0x100 [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186430]  [<ffffffff810a61bd>] ? user_path_at+0x64/0x93
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186506]  [<ffffffff8109e40e>] vfs_fstatat+0x35/0x62
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186592]  [<ffffffffa00f073c>] ? xfs_xattr_put_listent_sizes+0x0/0x30 [xfs]
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186688]  [<ffffffff8109e454>] vfs_lstat+0x19/0x1b
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186765]  [<ffffffff8102afbb>] sys32_lstat64+0x1a/0x34
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186841]  [<ffffffff810a2b18>] ? path_put+0x2c/0x30
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186917]  [<ffffffff810b3594>] ? sys_llistxattr+0x4d/0x5c
Jun 28 09:01:14 beosrv1-t kernel: [3702691.186995]  [<ffffffff8102a0d3>] ia32_sysret+0x0/0x5

That looks like XFS could be recursing into itself but maybe it copes
with that and bails - I'm not familiar enough with XFS to know if it
copes with this properly.

There are also patches that should be in 2.6.32.29 like [e52af507:
xfs: Non-blocking inode locking in IO completion] which talks
about deadlocks during IO completion but the kernel name is
2.6.32.29-ql-server-20. Does that include this patch or is it some
other fork?

What seems more plausible is 2.6.32.29 is missing patches like this
[081003ff: xfs: properly account for reclaimed inodes] which sounds
like a very similar problem to what is happening here. There is a good
chance this problem is already fixed but wasn't backported to 2.6.32.x
unfortunately.

-- 
Mel Gorman
SUSE Labs
