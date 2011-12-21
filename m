Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1LUEX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:23:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16408 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1LUEXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:23:54 -0500
Message-ID: <4EF15F42.4070104@oracle.com>
Date: Tue, 20 Dec 2011 22:23:30 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, davem@davemloft.net
Subject: Re: [Resend] 3.2-rc6+: Reported regressions from 3.0 and 3.1
References: <201112210054.46995.rjw@sisk.pl> <CA+55aFzee7ORKzjZ-_PrVy796k2ASyTe_Odz=ji7f1VzToOkKw@mail.gmail.com>
In-Reply-To: <CA+55aFzee7ORKzjZ-_PrVy796k2ASyTe_Odz=ji7f1VzToOkKw@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EF15F48.00C1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 08:31 PM, Linus Torvalds wrote:
> On Tue, Dec 20, 2011 at 3:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>> Subject    : [BUG] deadlock: jfs (3.2.0-rc4-00154-g8e8da02)
>> Submitter  : Nico Schottelius <nico-linux-20111201@schottelius.org>
>> Date       : 2011-12-06 10:05
>> Message-ID : 20111206100533.GB6161@schottelius.org
>> References : http://marc.info/?l=linux-kernel&m=132317917827825&w=2
> 
> That's an odd bug-report. I think Nico should try to cut-and-paste
> more of the relevant problem..
> 
> It's all there in the attached xz-file, but I doubt anybody followed
> up on it because it's so hidden..
> 
> Unpacked, and added Dave and jfs-discussion to the cc:
> 
>     [ 6281.127353] =================================
>     [ 6281.127355] [ INFO: inconsistent lock state ]
>     [ 6281.127358] 3.2.0-rc4-00154-g8e8da02 #91
>     [ 6281.127360] ---------------------------------
>     [ 6281.127363] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
>     [ 6281.127366] kswapd0/30 [HC0[0]:SC0[0]:HE1:SE1] takes:
>     [ 6281.127368]  (&jfs_ip->rdwrlock#2){++++?+}, at:
> [<ffffffffa01958d7>] jfs_get_block+0x57/0x220 [jfs]
>     [ 6281.127381] {RECLAIM_FS-ON-W} state was registered at:
>     [ 6281.127383]   [<ffffffff810a2c71>] mark_held_locks+0x61/0x140
>     [ 6281.127392]   [<ffffffff810a3401>] lockdep_trace_alloc+0x71/0xd0
>     [ 6281.127399]   [<ffffffff8115daed>] kmem_cache_alloc+0x2d/0x170
>     [ 6281.127406]   [<ffffffff8124d7d6>] radix_tree_preload+0x66/0xf0
>     [ 6281.127414]   [<ffffffff81110e93>] add_to_page_cache_locked+0x73/0x170
>     [ 6281.127422]   [<ffffffff81110fb1>] add_to_page_cache_lru+0x21/0x50
>     [ 6281.127428]   [<ffffffff8111112a>] do_read_cache_page+0x6a/0x170
>     [ 6281.127434]   [<ffffffff8111127c>] read_cache_page_async+0x1c/0x20
>     [ 6281.127441]   [<ffffffff8111128e>] read_cache_page+0xe/0x20
>     [ 6281.127446]   [<ffffffffa01ae406>] __get_metapage+0x1c6/0x5c0 [jfs]
>     [ 6281.127455]   [<ffffffffa01a018a>] diWrite+0xea/0x7f0 [jfs]
>     [ 6281.127461]   [<ffffffffa01b3b04>] txCommit+0x1d4/0xe40 [jfs]
>     [ 6281.127468]   [<ffffffffa01982e3>] jfs_unlink+0x2a3/0x390 [jfs]
>     [ 6281.127474]   [<ffffffff8118255f>] vfs_unlink+0x9f/0x110
>     [ 6281.127479]   [<ffffffff8118277a>] do_unlinkat+0x1aa/0x1d0
>     [ 6281.127482]   [<ffffffff81184236>] sys_unlink+0x16/0x20
>     [ 6281.127486]   [<ffffffff8143e202>] system_call_fastpath+0x16/0x1b
>     [ 6281.127491] irq event stamp: 26965295
>     [ 6281.127493] hardirqs last  enabled at (26965295):
> [<ffffffff8111a3d5>] clear_page_dirty_for_io+0x105/0x130
>     [ 6281.127498] hardirqs last disabled at (26965294):
> [<ffffffff8111a378>] clear_page_dirty_for_io+0xa8/0x130
>     [ 6281.127503] softirqs last  enabled at (26964300):
> [<ffffffff8106cda7>] __do_softirq+0x137/0x2a0
>     [ 6281.127508] softirqs last disabled at (26964283):
> [<ffffffff814404fc>] call_softirq+0x1c/0x30
>     [ 6281.127513]
>     [ 6281.127514] other info that might help us debug this:
>     [ 6281.127516]  Possible unsafe locking scenario:
>     [ 6281.127517]
>     [ 6281.127518]        CPU0
>     [ 6281.127519]        ----
>     [ 6281.127521]   lock(&jfs_ip->rdwrlock);
>     [ 6281.127524]   <Interrupt>
>     [ 6281.127525]     lock(&jfs_ip->rdwrlock);
>     [ 6281.127528]
>     [ 6281.127529]  *** DEADLOCK ***
>     [ 6281.127529]
>     [ 6281.127531] no locks held by kswapd0/30.
>     [ 6281.127533]
>     [ 6281.127533] stack backtrace:
>     [ 6281.127536] Pid: 30, comm: kswapd0 Tainted: G         C
> 3.2.0-rc4-00154-g8e8da02 #91
>     [ 6281.127539] Call Trace:
>     [ 6281.127545]  [<ffffffff8143374c>] print_usage_bug.part.34+0x285/0x294
>     [ 6281.127552]  [<ffffffff8102494f>] ? save_stack_trace+0x2f/0x50
>     [ 6281.127559]  [<ffffffff8109ffe0>] mark_lock+0x540/0x600
>     [ 6281.127564]  [<ffffffff8109ef60>] ?
> print_irq_inversion_bug.part.31+0x1f0/0x1f0
>     [ 6281.127568]  [<ffffffff810a0677>] __lock_acquire+0x5d7/0x1d10
>     [ 6281.127573]  [<ffffffff81118394>] ? free_pcppages_bulk+0x34/0x430
>     [ 6281.127580]  [<ffffffffa01958d7>] ? jfs_get_block+0x57/0x220 [jfs]
>     [ 6281.127584]  [<ffffffff810a23a2>] lock_acquire+0x92/0x160
>     [ 6281.127590]  [<ffffffffa01958d7>] ? jfs_get_block+0x57/0x220 [jfs]
>     [ 6281.127595]  [<ffffffff811a5253>] ? create_empty_buffers+0x53/0xe0
>     [ 6281.127600]  [<ffffffff8108e77f>] down_write_nested+0x2f/0x60
>     [ 6281.127606]  [<ffffffffa01958d7>] ? jfs_get_block+0x57/0x220 [jfs]
>     [ 6281.127612]  [<ffffffffa01958d7>] jfs_get_block+0x57/0x220 [jfs]
>     [ 6281.127616]  [<ffffffff8143d24b>] ? _raw_spin_unlock+0x2b/0x60
>     [ 6281.127620]  [<ffffffff811a65d1>] __block_write_full_page+0x101/0x3a0
>     [ 6281.127625]  [<ffffffff811a5fe0>] ? block_read_full_page+0x3d0/0x3d0
>     [ 6281.127631]  [<ffffffffa0195880>] ? jfs_writepage+0x20/0x20 [jfs]
>     [ 6281.127637]  [<ffffffff811a6954>] block_write_full_page_endio+0xe4/0x130
>     [ 6281.127642]  [<ffffffff811a69b5>] block_write_full_page+0x15/0x20
>     [ 6281.127651]  [<ffffffffa0195878>] jfs_writepage+0x18/0x20 [jfs]
>     [ 6281.127657]  [<ffffffff8112427c>] shrink_page_list+0x56c/0x980
>     [ 6281.127662]  [<ffffffff8111e596>] ? __pagevec_release+0x26/0x40
>     [ 6281.127666]  [<ffffffff81124ac2>] shrink_inactive_list+0x152/0x4f0
>     [ 6281.127670]  [<ffffffff8112563c>] shrink_zone+0x47c/0x5c0
>     [ 6281.127673]  [<ffffffff81122fef>] ? shrink_slab+0x1ff/0x380
>     [ 6281.127678]  [<ffffffff8143945b>] ? __schedule+0x35b/0xa30
>     [ 6281.127682]  [<ffffffff811269c5>] balance_pgdat+0x4e5/0x6d0
>     [ 6281.127685]  [<ffffffff81126d28>] kswapd+0x178/0x440
>     [ 6281.127691]  [<ffffffff81089840>] ? __init_waitqueue_head+0x60/0x60
>     [ 6281.127695]  [<ffffffff81126bb0>] ? balance_pgdat+0x6d0/0x6d0
>     [ 6281.127699]  [<ffffffff81088e97>] kthread+0xa7/0xb0
>     [ 6281.127703]  [<ffffffff810a2efd>] ? trace_hardirqs_on+0xd/0x10
>     [ 6281.127707]  [<ffffffff81440404>] kernel_thread_helper+0x4/0x10
>     [ 6281.127711]  [<ffffffff8143d838>] ? retint_restore_args+0x13/0x13
>     [ 6281.127715]  [<ffffffff81088df0>] ? __init_kthread_worker+0x70/0x70
>     [ 6281.127719]  [<ffffffff81440400>] ? gs_change+0x13/0x13
> 
> Hmm?
> 
>                         Linus

I don't think this is a regression.  It's been seen before, but the
patch never got submitted, or was lost somewhere. I believe this
will fix it.

vfs: __read_cache_page should use gfp argument rather than GFP_KERNEL

lockdep reports a deadlock in jfs because a special inode's rw semaphore
is taken recursively. The mapping's gfp mask is GFP_NOFS, but is not used
when __read_cache_page() calls add_to_page_cache_lru().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

diff --git a/mm/filemap.c b/mm/filemap.c
index c106d3b..c9ea3df 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1828,7 +1828,7 @@ repeat:
 		page = __page_cache_alloc(gfp | __GFP_COLD);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
-		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		err = add_to_page_cache_lru(page, mapping, index, gfp);
 		if (unlikely(err)) {
 			page_cache_release(page);
 			if (err == -EEXIST)
