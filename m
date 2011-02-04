Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1BDUl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:41:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37003 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1BDUl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=M2aEEzmU6A/15BD49C6gMXN9/b9I+tzy2b/nls9tqbM0oPgcEDxFjg9epJa1Tbqmum
         BZClXHSwXYebs/bd8XgFEoqiX/3eD0BaLjdCRGhBtOeiW5v/Pg6p9tM7mym6QegK3af7
         HFjdWns6bQwKM/Kink/C/iyJCx1pV2o0REs4w=
MIME-Version: 1.0
Date: Fri, 4 Feb 2011 20:41:24 +0000
Message-ID: <AANLkTi=utOj-x6tdPUyRMgKUEH1enmeTfiE3uAYvCbFj@mail.gmail.com>
Subject: [PATCH V1 0/3] drivers/staging: kztmem: dynamic page cache/swap
From: Matt <jackdachef@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-mm <linux-mm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

thank you so much for posting kztmem !

This finally makes Cleancache's functionality usable for desktop and
other small device (non-enterprise) users (especially regarding
frontswap) :)

1) short general statement about kztmem

I found its functionality quite interesting right from the start
"page-granularity victim cache for clean
pages that the kernel's pageframe replacement algorithm (PFRA) would like
to keep around, but can't since there isn't enough memory." but saw no
features yet that could be activated at that time via kernel config.

It's somewhat puzzling why no one has followed your post yet with an
comment, review, etc. - there seems to be so much potential for a lot
of usage cases.

2) feedback

2.1) In the last few days I got the following kind of WARNINGs:

WARNING: at kernel/softirq.c:159 local_bh_enable+0xba/0x110()

as far as I know I also seemed to get those (in total at maximum 2-3
during a day's runtime) after running some heavy rsync usage or
especially
sync && sdparm -C sync /dev/sda

I also observed that it takes some time until volumes (which use
kztmem's ephemeral nodes) are unmounted - probably due to emptying
slub/slab taking longer - so this should be normal.

2.2) a user (32bit box) who's running a pretty similar kernel to mine
(details later) has had some assert_spinlocks thrown while
testing it out:

http://forums.gentoo.org/viewtopic-p-6563655.html#6563655

are those serious or anything to get concerned about in terms of data
safety or integrity ?

2.3) rsync-operations seemed to speed up quite noticably to say the
least (significantly)

usual operations include

(1) around 500 GiB for a
small job and

2) around 900 GiB for a total job for syncing/comparing) (around
800,000 files - several small ones)

for these there are always several MiBs or GiBs of changed data in
different directories per operation.

I'm usually running the (1) operation [for the directories known to
change a lot] and then (2) for the whole backup-job.

In the past follow-up rsync-jobs where shortened (due to data kept in
the cache) by around 1-2 minutes max.

But when using kztmem that seemed to be cut even more - one-way
backup-jobs (run for the first time with empty cache):

e.g.
job (1) 4-5 minutes [ext4 -> ext4]
job (2) 4-5 minutes [ext4 -> ext4]

on the same drive

would e.g. lead to

job (1) 4-5 minutes [ext4 -> ext4]
job (2) 2-3 minutes [ext4 -> ext4]

so job (2) could be cut by 1-2 minutes. Unmounting the drive/partition
would throw away ephemeral pool data but subsequent backup-jobs on
additional drives/partitions with the same data
still would be faster than without kztmem - sometimes to the point
that job (2) [this backup job is done one several drives with either
ext4 or xfs partitions] would be shorted to 50 seconds or less.

This "speedup effect" wasn't so dramatic in the past (without kztmem).

I also included the "zram: [PATCH 0/7][v2] zram_xvmalloc: 64K page
fixes and optimizations" patch so that also might have made a change
in tweaking xvmalloc and thus kztmem even more.


more feedback:

2.3)  Today I just enabled several debug-features in the kernel and
got the following:

[  370.631193] ------------[ cut here ]------------
[  370.631208] WARNING: at kernel/softirq.c:159 local_bh_enable+0xba/0x110()
[  370.631212] Hardware name: ipower G3710
[  370.631214] Modules linked in: radeon ttm drm_kms_helper
cfbcopyarea cfbimgblt cfbfillrect ipt_REJECT ipt_LOG xt_limit
xt_tcpudp xt_state nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp iptable_filter
ipt_addrtype xt_iprange xt_DSCP xt_dscp ip_tables ip6table_filter
xt_conntrack xt_hashlimit xt_string xt_NFQUEUE xt_connmark
nf_conntrack xt_mark xt_multiport xt_owner ip6_tables x_tables it87
hwmon_vid coretemp e1000e i2c_i801 wmi shpchp libphy e1000
scsi_wait_scan sl811_hcd ohci_hcd ssb usb_storage ehci_hcd [last
unloaded: tg3]
[  370.631296] Pid: 10246, comm: svn Not tainted
2.6.37-plus_v13_kztram_coordinate-flush_inode-integrity_debug #1
[  370.631300] Call Trace:
[  370.631308]  [<ffffffff8104f40a>] warn_slowpath_common+0x7a/0xb0
[  370.631318]  [<ffffffff816087a5>] ? kztmem_flush_page+0x75/0x90
[  370.631320]  [<ffffffff8104f455>] warn_slowpath_null+0x15/0x20
[  370.631322]  [<ffffffff8105566a>] local_bh_enable+0xba/0x110
[  370.631324]  [<ffffffff816087a5>] kztmem_flush_page+0x75/0x90
[  370.631326]  [<ffffffff816087f3>] kztmem_cleancache_flush_page+0x33/0x40
[  370.631329]  [<ffffffff810f66f6>] __cleancache_flush_page+0x76/0x90
[  370.631332]  [<ffffffff810b6f86>] __remove_from_page_cache+0xb6/0x170
[  370.631335]  [<ffffffff810b7082>] remove_from_page_cache+0x42/0x70
[  370.631337]  [<ffffffff810c23e9>] truncate_inode_page+0x79/0x100
[  370.631339]  [<ffffffff810c2763>] truncate_inode_pages_range+0x2f3/0x4b0
[  370.631343]  [<ffffffff8114b297>] ? __dquot_initialize+0x37/0x1d0
[  370.631345]  [<ffffffff810c2930>] truncate_inode_pages+0x10/0x20
[  370.631348]  [<ffffffff811c987c>] ext4_evict_inode+0x7c/0x2d0
[  370.631351]  [<ffffffff8110fc82>] evict+0x22/0xb0
[  370.631353]  [<ffffffff8110ff9d>] iput+0x1bd/0x2a0
[  370.631355]  [<ffffffff8110b678>] dentry_iput+0x98/0xf0
[  370.631357]  [<ffffffff8110bfc3>] d_kill+0x53/0x80
[  370.631359]  [<ffffffff8110c5f0>] dput+0x60/0x150
[  370.631361]  [<ffffffff811071ad>] sys_renameat+0x1fd/0x260
[  370.631365]  [<ffffffff81048f21>] ? get_parent_ip+0x11/0x50
[  370.631367]  [<ffffffff81048ffd>] ? sub_preempt_count+0x9d/0xd0
[  370.631369]  [<ffffffff810fa2d8>] ? fput+0x178/0x230
[  370.631373]  [<ffffffff810027ec>] ? sysret_check+0x27/0x62
[  370.631376]  [<ffffffff81082a35>] ? trace_hardirqs_on_caller+0x145/0x190
[  370.631379]  [<ffffffff81107226>] sys_rename+0x16/0x20
[  370.631381]  [<ffffffff810027bb>] system_call_fastpath+0x16/0x1b
[  370.631382] ---[ end trace 4ab50eb51e4ed1c2 ]---
[  370.631399]
[  370.631399] =================================
[  370.631401] [ INFO: inconsistent lock state ]
[  370.631402] 2.6.37-plus_v13_kztram_coordinate-flush_inode-integrity_debug #1
[  370.631403] ---------------------------------
[  370.631404] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[  370.631406] svn/10246 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  370.631408]  (&(&inode->i_data.tree_lock)->rlock){+.?...}, at:
[<ffffffff810b707a>] remove_from_page_cache+0x3a/0x70
[  370.631411] {IN-SOFTIRQ-W} state was registered at:
[  370.631412]   [<ffffffff81080547>] __lock_acquire+0x6f7/0x1cb0
[  370.631415]   [<ffffffff81082037>] lock_acquire+0x57/0x70
[  370.631417]   [<ffffffff8179a1d1>] _raw_spin_lock_irqsave+0x41/0x60
[  370.631420]   [<ffffffff810c02fd>] test_clear_page_writeback+0x5d/0x180
[  370.631422]   [<ffffffff810b61af>] end_page_writeback+0x1f/0x60
[  370.631424]   [<ffffffff8112330d>] end_buffer_async_write+0x17d/0x260
[  370.631427]   [<ffffffff8112109b>] end_bio_bh_io_sync+0x2b/0x50
[  370.631429]   [<ffffffff81125628>] bio_endio+0x18/0x30
[  370.631432]   [<ffffffff815c41ea>] dec_pending+0x1da/0x330
[  370.631435]   [<ffffffff815c456e>] clone_endio+0x9e/0xd0
[  370.631436]   [<ffffffff81125628>] bio_endio+0x18/0x30
[  370.631438]   [<ffffffff815c41ea>] dec_pending+0x1da/0x330
[  370.631440]   [<ffffffff815c456e>] clone_endio+0x9e/0xd0
[  370.631442]   [<ffffffff81125628>] bio_endio+0x18/0x30
[  370.631444]   [<ffffffff815cd6f9>] crypt_dec_pending+0x69/0xa0
[  370.631447]   [<ffffffff815cdd6c>] crypt_endio+0x5c/0x110
[  370.631448]   [<ffffffff81125628>] bio_endio+0x18/0x30
[  370.631450]   [<ffffffff813b8edb>] req_bio_endio+0x8b/0xf0
[  370.631454]   [<ffffffff813b9acf>] blk_update_request+0xef/0x4d0
[  370.631456]   [<ffffffff813b9edf>] blk_update_bidi_request+0x2f/0x90
[  370.631458]   [<ffffffff813ba78a>] blk_end_bidi_request+0x2a/0x80
[  370.631460]   [<ffffffff813ba81b>] blk_end_request+0xb/0x10
[  370.631462]   [<ffffffff814b38c7>] scsi_io_completion+0x97/0x540
[  370.631465]   [<ffffffff814abe0f>] scsi_finish_command+0xaf/0xe0
[  370.631467]   [<ffffffff814b36dd>] scsi_softirq_done+0x9d/0x130
[  370.631469]   [<ffffffff813c01f5>] blk_done_softirq+0x85/0xa0
[  370.631472]   [<ffffffff81055c1b>] __do_softirq+0xcb/0x160
[  370.631474]   [<ffffffff8100368c>] call_softirq+0x1c/0x30
[  370.631476]   [<ffffffff81005955>] do_softirq+0x85/0xc0
[  370.631478]   [<ffffffff81055dc5>] irq_exit+0x95/0xa0
[  370.631480]   [<ffffffff810054b6>] do_IRQ+0x76/0xf0
[  370.631482]   [<ffffffff8179af13>] ret_from_intr+0x0/0xf
[  370.631484]   [<ffffffff815e66e3>] cpuidle_idle_call+0x93/0x110
[  370.631487]   [<ffffffff81000bdb>] cpu_idle+0x9b/0x100
[  370.631489]   [<ffffffff817813fb>] rest_init+0xcb/0xe0
[  370.631492]   [<ffffffff81d0aa52>] start_kernel+0x3b6/0x3c1
[  370.631495]   [<ffffffff81d0a135>] x86_64_start_reservations+0x132/0x136
[  370.631498]   [<ffffffff81d0a22e>] x86_64_start_kernel+0xf5/0xfc
[  370.631500] irq event stamp: 49838
[  370.631501] hardirqs last  enabled at (49835): [<ffffffff810f220e>]
kmem_cache_free+0x9e/0xf0
[  370.631505] hardirqs last disabled at (49836): [<ffffffff8179a152>]
_raw_spin_lock_irq+0x12/0x50
[  370.631507] softirqs last  enabled at (49838): [<ffffffff816087a5>]
kztmem_flush_page+0x75/0x90
[  370.631509] softirqs last disabled at (49837): [<ffffffff8160875a>]
kztmem_flush_page+0x2a/0x90
[  370.631511]
[  370.631512] other info that might help us debug this:
[  370.631513] 4 locks held by svn/10246:
[  370.631514]  #0:  (&type->s_vfs_rename_key){+.+.+.}, at:
[<ffffffff811031ac>] lock_rename+0x3c/0xf0
[  370.631518]  #1:  (&sb->s_type->i_mutex_key#8/1){+.+.+.}, at:
[<ffffffff81103223>] lock_rename+0xb3/0xf0
[  370.631522]  #2:  (&sb->s_type->i_mutex_key#8/2){+.+.+.}, at:
[<ffffffff81103239>] lock_rename+0xc9/0xf0
[  370.631527]  #3:  (&(&inode->i_data.tree_lock)->rlock){+.?...}, at:
[<ffffffff810b707a>] remove_from_page_cache+0x3a/0x70
[  370.631530]
[  370.631531] stack backtrace:
[  370.631532] Pid: 10246, comm: svn Tainted: G        W
2.6.37-plus_v13_kztram_coordinate-flush_inode-integrity_debug #1
[  370.631534] Call Trace:
[  370.631536]  [<ffffffff8107fa40>] print_usage_bug+0x170/0x180
[  370.631538]  [<ffffffff8107fdca>] mark_lock+0x37a/0x400
[  370.631540]  [<ffffffff810828bf>] mark_held_locks+0x6f/0xa0
[  370.631543]  [<ffffffff81055632>] ? local_bh_enable+0x82/0x110
[  370.631545]  [<ffffffff81082a35>] trace_hardirqs_on_caller+0x145/0x190
[  370.631547]  [<ffffffff816087a5>] ? kztmem_flush_page+0x75/0x90
[  370.631549]  [<ffffffff81082a8d>] trace_hardirqs_on+0xd/0x10
[  370.631551]  [<ffffffff81055632>] local_bh_enable+0x82/0x110
[  370.631553]  [<ffffffff816087a5>] kztmem_flush_page+0x75/0x90
[  370.631555]  [<ffffffff816087f3>] kztmem_cleancache_flush_page+0x33/0x40
[  370.631557]  [<ffffffff810f66f6>] __cleancache_flush_page+0x76/0x90
[  370.631559]  [<ffffffff810b6f86>] __remove_from_page_cache+0xb6/0x170
[  370.631561]  [<ffffffff810b7082>] remove_from_page_cache+0x42/0x70
[  370.631563]  [<ffffffff810c23e9>] truncate_inode_page+0x79/0x100
[  370.631565]  [<ffffffff810c2763>] truncate_inode_pages_range+0x2f3/0x4b0
[  370.631568]  [<ffffffff8114b297>] ? __dquot_initialize+0x37/0x1d0
[  370.631570]  [<ffffffff810c2930>] truncate_inode_pages+0x10/0x20
[  370.631572]  [<ffffffff811c987c>] ext4_evict_inode+0x7c/0x2d0
[  370.631574]  [<ffffffff8110fc82>] evict+0x22/0xb0
[  370.631576]  [<ffffffff8110ff9d>] iput+0x1bd/0x2a0
[  370.631578]  [<ffffffff8110b678>] dentry_iput+0x98/0xf0
[  370.631581]  [<ffffffff8110bfc3>] d_kill+0x53/0x80
[  370.631582]  [<ffffffff8110c5f0>] dput+0x60/0x150
[  370.631584]  [<ffffffff811071ad>] sys_renameat+0x1fd/0x260
[  370.631587]  [<ffffffff81048f21>] ? get_parent_ip+0x11/0x50
[  370.631589]  [<ffffffff81048ffd>] ? sub_preempt_count+0x9d/0xd0
[  370.631591]  [<ffffffff810fa2d8>] ? fput+0x178/0x230
[  370.631593]  [<ffffffff810027ec>] ? sysret_check+0x27/0x62
[  370.631596]  [<ffffffff81082a35>] ? trace_hardirqs_on_caller+0x145/0x190
[  370.631598]  [<ffffffff81107226>] sys_rename+0x16/0x20
[  370.631600]  [<ffffffff810027bb>] system_call_fastpath+0x16/0x1b

I don't know if all of those are related to kztmem but most of them
mention kztmem and some cleancache

If those are serious and need valid debug data - I might need to
re-compile the current debug-kernel (I used some pretty ricer-ish
optimized flags).

These seemingly got triggered by some emerge-operations (I'm currently
re-emerging my core system [emerge -e system]) which in the past
proved useful in detection data corruptions or some
issues in filesystems and related parts.


2.4) I'm running a heavy patched (2.6.37) kernel with (potentially to
be included) features for 2.6.39 or 2.6.40
(http://forums.gentoo.org/viewtopic-t-862105.html)

most notable of those:
‣ dm crypt: scale to multiple CPUs
‣ f_madivse(DONTNEED) support (or what its name is - which is supposed
to be useful for rsync-operations)
‣ ck-patchset
(• most notable mm-lru_cache_add_lru_tail, mm-kswapd_inherit_prio-1
and mm-idleprio_prio-1)
‣ io-less dirty throttling
‣ mmu preemptibility v6
‣ memory compaction replacing lumpy reclaim
‣ Prevent kswapd dumping excessive amounts (or what its current name is)
‣ 2.6.38's CFS / autogroup cgroup feature
‣ inode data integrity patches
‣ coordinate flush requests
∘ (most of those also available in the zen-kernel.org (a
community-driven kernel-patchset) - except coordinate flush-requests,
kztmem and dm-crypt multicpu-scaling)


There was significant stuttering of sound playback (via alsa -> jack)
in the past without this kernel during CPU-intensive  or i/o heavy
workloads and also the GUI tended to be not responsive to input (from
the mouse or keyboard) :

This almost got minimized to a short stop of sound (1-2 seconds)
compared to minutes in the past of heavy swapping

Adding kztmem to the equation: so far there are no more interruptions
in sound, movie, etc. playback anymore - the GUI also seems to stay
quite responsive at heavy CPU load (15-30 - so 1500 - 3000%) or
rsyncing / copying large files.

All partitions use cryptsetup/encryption with PCRYPT enabled.

This is a core i7 860 box, btw, with 6 GiB of RAM

So kztmem also seems to help where low latency needs to be met, e.g. pro-audio.



I observed some kind of strange behavior of the kernel:

echo "13" > /proc/sys/vm/page-cluster seemed to help "a lot" for
swapping operations

‣ so - more aggressive swapping than way too conservative/cautious
seemed to be better in these cases - the kernel seems to rely on swap
usage with desktop configurations:
‣ I've set
echo "50" > /proc/sys/vm/vfs_cache_pressure
since this is supposed to keep inodes longer in cache and therefore
improves directory lookups, file-operations with nautilus/dolphin,
etc.


Frontswap which is supposed to be kind of "emergency swap disk" seems
to help a lot when the kernel needs to swap pages
‣ referring to http://marc.info/?l=linux-kernel&m=129683713531791&w=2 slide 51
this manifests itself in the LACK of interrupted webradio streaming,
video playback, jerkiness of the GUI (e.g. not reacting for 2-10
minutes during swapping and appearing like hardlocked).
So productivity is improved quite a lot.


3) Questions:

Questions:
• What exactly is kztmem?
∘ is it a tmem similar functionality like provided in the project
"Xen's Transcent Memory"
∘ and zmem is simply a "plugin" for memory compression support to tmem
? (is that what zcache does ?)

• so simplified (superficially without taking into account advantages
or certain unique characteristics) some equivalents:
∘ frontswap == ramzswap
∘ kztmem == zcache
∘ cleancache == is the "core", "mastermind" or "hypervisor" behind all
this, making frontswap and kztmem kind of "plugins" for it ?

• Is kztmem using a similar mechanism like in slides 43-44
http://marc.info/?l=linux-kernel&m=129683713531791&w=2  ? So the
"fallow" memory (or here ephemeral memory) would be stored in
ephemeral pools and only visible to cleancache ?
Making Cleancache sort of the "hypervisor" ?

So kztmem (or more accurately: cleancache) is open for adding more
functionality in the future ?

• What are advantages of kztmem compared to ramzswap ("compcache") &
zcache ? From what I understood - it's more dynamic in it's nature
than compcache & zcache: they need to preallocate predetermined amount
of memory, several "ram-drives" would be needed for SMP-scalability
∘ whereas this (pre-allocated RAM and multiple "ram-drives" aren't
needed for kztmem, cleancache and frontswap since cleancache,
frontswap & kztmem are concurrency-safe and dynamic (according to
documentation) ?

• Coming back to usage of compcache - how about the problem of 60%
memory fragmentation (according to compcache/zcache wiki,
http://code.google.com/p/compcache/wiki/Fragmentation) ?
Could the situation be improved with in-kernel "memory compaction" ?
I'm not a developer so I don't know exactly how lumpy reclaim/memory
compaction and xvmalloc would interact with each other

 - Is it a problem of xvmalloc or how ramzswap/zcache fundamentally
work (e.g. pre-allocating memory and not reclaiming it) ?

• According to the Documentation you posted "e.g. a ram-based FS such
as tmpfs should not enable cleancache" - so it's not using block i/o
layer ? what are the performance or other advantages of that approach
?

• Is there support for XFS or reiserfs - how difficult would it be to add that ?

• Very interesting would be: support for FUSE (taking into account zfs
and ntfs3g, etc.) - would that be possible ?

• Was there testing done on 32bit boxes ? How about alternative
architectures such as ARM, PPC, etc. ?
∘ I'm especially interested in ARM since surely a lot on the
(Linux-kernel) mailing list know CyanogenMod or at least have heard or
read about it: it includes (compcache / ramzswap)
since kztmem, cleancache and frontswap seem to be a kind of evolution
of ramzswap and zcache that should speed those little devices even
more.
Are there any benchmarks available for such small devices ? Will there
be / Is there a port of cleancache, kztmem and frontswap available for
2.6.32* kernels ? (most android devices are currently running those)

• Considerung UP boxes - is the usage even beneficial on those ?
∘ If not - why not (written in the documentation) - due to missing raw
CPU power ?

• How is the scaling ? In case of Multiprocessors  - are the
operations/parallelism or concurrency, how it's called, realized
through "work queues" - (there have been lots of changes recently in
the kernel [2.6.37, 2.6.38]).  ?

And in case of RAID sets - does scaling of kztmem, cleancache,
frontswap even apply to those or would that rather be handled by the
"dm crypt: scale to multiple CPUs" patchset and dedicated hardware
raid cards - so no involvement
at all of kztmem ?

• Are there higher latencies during high memory pressure or high CPU
load situations, e.g. where the latencies would even go down below
without usage of kztmem ?

• The compression algorithm in use seems to be lzo. Are any additional
selectable compressions planned such as lzf, gzip - maybe even bzip2 ?
- Would they be selectable via Kconfig ?
∘ are these threaded / scaling with multiple processors - e.g. like pcrypt ?

• "Exactly how much memory it provides is entirely dynamic and
random." - can maximum limits be set ? ("watermarks" ? - if that is
the correct term)
How efficient is the algorithm ? What is it based on ?


• Can the operations be sped up even more using spice() system call or
something similar (if existant) - if even applicable ?

• Are userland hooks planned ? e.g. for other virtualization solutions
such as KVM, qemu, etc.

• How about deduplication support for the ephemeral (filesystem) pools?
∘ in my (humble) opinion this might be really useful - since in the
future there will be more and more CPU power but due to available RAM
not growing as linear (or fast) as CPU's power this could be a kind of
compensation to gain more memory
∘ would that work with "Kernel Samepage Merging"?
∘ is KSM even similar to tmem's deduplication functionality (tmem -
which is used or planned for Xen)
Referring to http://marc.info/?l=linux-kernel&m=129683713531791&w=2
slides 20 to 21 on the presentation deduplication would seem much more
efficient than KSM.

Advantages for the deduplication funcationality would be that:
• several filesystems that contain lot of similar files / content
could be crammed much better into the SLAB (ext4's "Shrinking the size
of ext4_inode_info" patchset also does a step in this direction)
• going one step further in the future would be to use the (already)
deduplicated data of e.g. btrfs and put it in a deduplicated state in
the RAM (if that makes sense - at all)




Kztmem seems to be quite useful on memory constrained devices:
performance improvements / advantages:

• There seems to be memory overcommitment in general with the
linux-kernel which is quite a nice feature (is this also enabled in
general on Android ?)
so using some of the principles that apply to a virtualization
environment with the hypervisor and the VMs

gaining significantly more memory and even performance on memory
constrained devices would be a very nice bonus
(http://marc.info/?l=linux-kernel&m=129683713531791&w=2 slides 56 to
64 on the presentation).

• Potentially multiplying available RAM on small devices where RAM
still might be quite expensive (e.g. android mobile devices) having a
kind of "software" in-kernel solution for that would potentiate
the usability for the mentioned devices a lot.


A community example would be the so-called
http://forum.xda-developers.com/showthread.php?t=811660 "Super
Optimized Kernel".
>From my experience the device is really much more responsive, etc.
Right now it's using ramzwap but replacing that with cleancache,
frontswap & kztmem, surely would make it run even better.



OK, that's all that has come to my mind so far

The mail has gotten somewhat large but I hope it's still well readable & useful

Thanks again for cleancache, kztmem and frontswap !

Regards

Matt
