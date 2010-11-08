Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0KHRXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:23:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43130 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0KHRXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:23:01 -0500
MIME-Version: 1.0
X-Originating-IP: [172.22.89.164]
In-Reply-To: <1289236230.15376.7.camel@edumazet-laptop>
References: <20100604092025.GA96690@trillian.comsick.at> <1275656014.2482.169.camel@edumazet-laptop>
 <20100604161644.GA98048@trillian.local> <20100606095640.GA4436@trillian.comsick.at>
 <1275820945.5238.987.camel@edumazet-laptop> <AANLkTimf5iZV2ytoymCXJ=B2Vgowr6qb6u2nBg+RtBUg@mail.gmail.com>
 <1282769089.2681.159.camel@edumazet-laptop> <AANLkTi=TU8d8tsp28qN-Rz9z0hTcH7hRE=d8W4GKhrkk@mail.gmail.com>
 <AANLkTi=jLwvU=EWR51Y=TQ5JYVp_DqeTx0Ocbt=NEC1-@mail.gmail.com>
 <1283718304.3402.370.camel@edumazet-laptop> <AANLkTi=F+KLSgyy=OG_504HUXnyburGAad25qy1BwLvE@mail.gmail.com>
 <1289236230.15376.7.camel@edumazet-laptop>
From: =?UTF-8?B?TmlraGlsIFNldGhpICjgpKjgpL/gpJbgpL/gpLIg4KS44KWH4KSg4KWAKQ==?= 
	<nikhil@sethi.ws>
Date: Mon, 8 Nov 2010 09:22:18 -0800
Message-ID: <AANLkTin2hvdGVvPMfSzz54S-u=QgoAYeGA-fvtX77r29@mail.gmail.com>
Subject: Re: [2.6.35-rc1] page alloc failure order:1, mode:0x4020
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Michael Guntsche <mike@it-loops.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I said, this seems like a regression in 2.6.36 from 2.6.35 (which
is why I emailed after 2 months :) ). You mentioned earlier in the
thread that you were going to submit the patch to head, if there is a
separate bug/thread tracking that, I can send followups to that.

I believe I have the right patch:

*** 225,234 ****
  	int error = 0, i;
  	u32 size;

!
! 	common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN +
! 				     ah->caps.rx_status_len,
! 				     min(common->cachelsz, (u16)64));

  	ath9k_hw_set_rx_bufsize(ah, common->rx_bufsize -
  				    ah->caps.rx_status_len);
--- 225,234 ----
  	int error = 0, i;
  	u32 size;

! 	size = roundup(IEEE80211_MAX_MPDU_LEN + ah->caps.rx_status_len,
!                        min(common->cachelsz, (u16)64));
!         common->rx_bufsize = min_t(u32, size,
!                                    SKB_MAX_ORDER(NET_SKB_PAD +
common->cachelsz, 0));

  	ath9k_hw_set_rx_bufsize(ah, common->rx_bufsize -
  				    ah->caps.rx_status_len);


2010/11/8 Eric Dumazet <eric.dumazet@gmail.com>:
> Le lundi 08 novembre 2010 à 08:25 -0800, Nikhil Sethi (निखिल सेठी) a
> écrit :
>> Thanks Eric, for all the help.
>> I get very occasional errors with vanilla 2.6.36 kernel with your
>> patch. Error messages are slightly different, and very rare compared
>> to without your patch. 2.6.35.7 seems fine, and does not show this
>> error.
>>
>> rsync: page allocation failure. order:1, mode:0x4020
>> Pid: 31479, comm: rsync Not tainted 2.6.36-rc1 #1
>> Call Trace:
>>  [<c0246b2c>] ? __alloc_pages_nodemask+0x3f1/0x52e
>>  [<c0261330>] ? __slab_alloc+0x40f/0x45a
>>  [<c02617ca>] ? __kmalloc_track_caller+0x91/0x97
>>  [<d09db01a>] ? ath_rxbuf_alloc+0x1a/0x78 [ath]
>>  [<d09db01a>] ? ath_rxbuf_alloc+0x1a/0x78 [ath]
>>  [<c033a8d0>] ? __alloc_skb+0x57/0x100
>>  [<d09db01a>] ? ath_rxbuf_alloc+0x1a/0x78 [ath]
>>  [<d0b01f2e>] ? ath_rx_tasklet+0x680/0xcfe [ath9k]
>>  [<c02234ae>] ? __queue_work+0xe4/0x1a2
>>  [<d0b00244>] ? ath9k_tasklet+0xd0/0x134 [ath9k]
>>  [<c0219a43>] ? tasklet_action+0x5f/0x65
>>  [<c0219cf4>] ? __do_softirq+0x60/0xc6
>>  [<c0219d88>] ? do_softirq+0x2e/0x30
>>  [<c0219e7b>] ? irq_exit+0x54/0x56
>>  [<c02038e0>] ? do_IRQ+0x3a/0x72
>>  [<c0202bc9>] ? common_interrupt+0x29/0x30
>>  [<c02d89a0>] ? cfq_may_queue+0x0/0x92
>>  [<c02d1567>] ? get_request+0x121/0x23e
>>  [<c02d16a4>] ? get_request_wait+0x20/0xfd
>>  [<c02d8f16>] ? cfq_merge+0x0/0x69
>>  [<c02cfd40>] ? elv_merge+0x14b/0x170
>>  [<c02d2375>] ? __make_request+0x71/0x364
>>  [<c02d1fe2>] ? generic_make_request+0x14f/0x318
>>  [<c0243fb1>] ? mempool_alloc+0x35/0xb9
>>  [<c02d21e9>] ? submit_bio+0x3e/0x90
>>  [<c0281c14>] ? bio_alloc_bioset+0x33/0x9e
>>  [<c027e780>] ? submit_bh+0xbc/0xec
>>  [<c027f4e2>] ? ll_rw_block+0x72/0x74
>>  [<c027f504>] ? __breadahead+0x20/0x30
>>  [<c02a3a8f>] ? __ext4_get_inode_loc+0x308/0x416
>>  [<c02a8154>] ? ext4_iget+0x52/0x652
>>  [<c02aa327>] ? ext4_lookup+0x65/0xbf
>>  [<c026a6bb>] ? d_alloc_and_lookup+0x30/0x58
>>  [<c026b84a>] ? do_lookup+0xc5/0xfe
>>  [<c026c239>] ? link_path_walk+0x4d1/0x8d6
>>  [<c026c722>] ? path_walk+0x48/0xa9
>>  [<c026c7be>] ? do_path_lookup+0x3b/0x3f
>>  [<c026d06d>] ? user_path_at+0x30/0x64
>>  [<c0266446>] ? cp_new_stat64+0xee/0x100
>>  [<c026664a>] ? vfs_fstatat+0x25/0x63
>>  [<c02666c9>] ? vfs_lstat+0x13/0x15
>>  [<c02666da>] ? sys_lstat64+0xf/0x23
>>  [<c02141ed>] ? switched_to_idle+0x1a/0x43
>>  [<c0393395>] ? syscall_call+0x7/0xb
>>  [<c0390000>] ? quirk_ich7_lpc+0x46/0x4d
>> Mem-Info:
>> DMA per-cpu:
>> CPU    0: hi:    0, btch:   1 usd:   0
>> Normal per-cpu:
>> CPU    0: hi:   90, btch:  15 usd:  84
>> active_anon:14957 inactive_anon:15137 isolated_anon:0
>>  active_file:11820 inactive_file:11640 isolated_file:0
>>  unevictable:470 dirty:1378 writeback:0 unstable:0
>>  free:975 slab_reclaimable:5606 slab_unreclaimable:2343
>>  mapped:2786 shmem:72 pagetables:394 bounce:0
>> DMA free:1000kB min:124kB low:152kB high:184kB active_anon:2896kB
>> inactive_anon:3552kB active_file:2116kB inactive_file:1768kB
>> unevictable:348kB isolated(anon):0kB isolated(file):0kB
>> present:15864kB mlocked:348kB dirty:16kB writeback:0kB mapped:228kB
>> shmem:32kB slab_reclaimable:1136kB slab_unreclaimable:608kB
>> kernel_stack:144kB pagetables:52kB unstable:0kB bounce:0kB
>> writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
>> lowmem_reserve[]: 0 238 238
>> Normal free:2900kB min:1908kB low:2384kB high:2860kB
>> active_anon:56932kB inactive_anon:56996kB active_file:45164kB
>> inactive_file:44792kB unevictable:1532kB isolated(anon):0kB
>> isolated(file):0kB present:243840kB mlocked:1532kB dirty:5496kB
>> writeback:0kB mapped:10916kB shmem:256kB slab_reclaimable:21288kB
>> slab_unreclaimable:8764kB kernel_stack:1056kB pagetables:1524kB
>> unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
>> all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0
>> DMA: 6*4kB 14*8kB 16*16kB 1*32kB 1*64kB 0*128kB 0*256kB 1*512kB
>> 0*1024kB 0*2048kB 0*4096kB = 1000kB
>> Normal: 691*4kB 17*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
>> 0*1024kB 0*2048kB 0*4096kB = 2900kB
>> 28310 total pagecache pages
>> 4385 pages in swap cache
>> Swap cache stats: add 144387, delete 140002, find 98398/115667
>> Free swap  = 889116kB
>> Total swap = 1023996kB
>> 65535 pages RAM
>> 1245 pages reserved
>> 27369 pages shared
>> 42219 pages non-shared
>> SLUB: Unable to allocate memory on node -1 (gfp=0x20)
>>   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default
>> order: 3, min order: 1
>>   node 0: slabs: 133, objs: 529, free: 0
>> skbuff alloc of size 3872 failed
>> rsync: page allocation failure. order:1, mode:0x4020
>> Pid: 31479, comm: rsync Not tainted 2.6.36-rc1 #1
>> Call Trace:
>>  [<c0246b2c>] ? __alloc_pages_nodemask+0x3f1/0x52e
>>  [<c0261330>] ? __slab_alloc+0x40f/0x45a
>>  [<c02617ca>] ? __kmalloc_track_caller+0x91/0x97
>>  [<d09db01a>] ? ath_rxbuf_alloc+0x1a/0x78 [ath]
>>  [<d09db01a>] ? ath_rxbuf_alloc+0x1a/0x78 [ath]
>>  [<c033a8d0>] ? __alloc_skb+0x57/0x100
>>  [<d09db01a>] ? ath_rxbuf_alloc+0x1a/0x78 [ath]
>>  [<d0b01f2e>] ? ath_rx_tasklet+0x680/0xcfe [ath9k]
>>  [<c02234ae>] ? __queue_work+0xe4/0x1a2
>>  [<d0b00244>] ? ath9k_tasklet+0xd0/0x134 [ath9k]
>>  [<c0219a43>] ? tasklet_action+0x5f/0x65
>>  [<c0219cf4>] ? __do_softirq+0x60/0xc6
>>  [<c0219d88>] ? do_softirq+0x2e/0x30
>>  [<c0219e7b>] ? irq_exit+0x54/0x56
>>  [<c02038e0>] ? do_IRQ+0x3a/0x72
>>  [<c0202bc9>] ? common_interrupt+0x29/0x30
>>  [<c02d89a0>] ? cfq_may_queue+0x0/0x92
>>  [<c02d1567>] ? get_request+0x121/0x23e
>>  [<c02d16a4>] ? get_request_wait+0x20/0xfd
>>  [<c02d8f16>] ? cfq_merge+0x0/0x69
>>  [<c02cfd40>] ? elv_merge+0x14b/0x170
>>  [<c02d2375>] ? __make_request+0x71/0x364
>>  [<c02d1fe2>] ? generic_make_request+0x14f/0x318
>>  [<c0243fb1>] ? mempool_alloc+0x35/0xb9
>>  [<c02d21e9>] ? submit_bio+0x3e/0x90
>>  [<c0281c14>] ? bio_alloc_bioset+0x33/0x9e
>>  [<c027e780>] ? submit_bh+0xbc/0xec
>>  [<c027f4e2>] ? ll_rw_block+0x72/0x74
>>  [<c027f504>] ? __breadahead+0x20/0x30
>>  [<c02a3a8f>] ? __ext4_get_inode_loc+0x308/0x416
>>  [<c02a8154>] ? ext4_iget+0x52/0x652
>>  [<c02aa327>] ? ext4_lookup+0x65/0xbf
>>  [<c026a6bb>] ? d_alloc_and_lookup+0x30/0x58
>>  [<c026b84a>] ? do_lookup+0xc5/0xfe
>>  [<c026c239>] ? link_path_walk+0x4d1/0x8d6
>>  [<c026c722>] ? path_walk+0x48/0xa9
>>  [<c026c7be>] ? do_path_lookup+0x3b/0x3f
>>  [<c026d06d>] ? user_path_at+0x30/0x64
>>  [<c0266446>] ? cp_new_stat64+0xee/0x100
>>  [<c026664a>] ? vfs_fstatat+0x25/0x63
>>  [<c02666c9>] ? vfs_lstat+0x13/0x15
>>  [<c02666da>] ? sys_lstat64+0xf/0x23
>>  [<c02141ed>] ? switched_to_idle+0x1a/0x43
>>  [<c0393395>] ? syscall_call+0x7/0xb
>>  [<c0390000>] ? quirk_ich7_lpc+0x46/0x4d
>> Mem-Info:
>> DMA per-cpu:
>> CPU    0: hi:    0, btch:   1 usd:   0
>> Normal per-cpu:
>> CPU    0: hi:   90, btch:  15 usd:  84
>> active_anon:14957 inactive_anon:15137 isolated_anon:0
>>  active_file:11820 inactive_file:11640 isolated_file:0
>>  unevictable:470 dirty:1378 writeback:0 unstable:0
>>  free:975 slab_reclaimable:5606 slab_unreclaimable:2343
>>  mapped:2786 shmem:72 pagetables:394 bounce:0
>> DMA free:1000kB min:124kB low:152kB high:184kB active_anon:2896kB
>> inactive_anon:3552kB active_file:2116kB inactive_file:1768kB
>> unevictable:348kB isolated(anon):0kB isolated(file):0kB
>> present:15864kB mlocked:348kB dirty:16kB writeback:0kB mapped:228kB
>> shmem:32kB slab_reclaimable:1136kB slab_unreclaimable:608kB
>> kernel_stack:144kB pagetables:52kB unstable:0kB bounce:0kB
>> writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
>> lowmem_reserve[]: 0 238 238
>> Normal free:2900kB min:1908kB low:2384kB high:2860kB
>> active_anon:56932kB inactive_anon:56996kB active_file:45164kB
>> inactive_file:44792kB unevictable:1532kB isolated(anon):0kB
>> isolated(file):0kB present:243840kB mlocked:1532kB dirty:5496kB
>> writeback:0kB mapped:10916kB shmem:256kB slab_reclaimable:21288kB
>> slab_unreclaimable:8764kB kernel_stack:1056kB pagetables:1524kB
>> unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
>> all_unreclaimable? no
>> lowmem_reserve[]: 0 0 0
>> DMA: 6*4kB 14*8kB 16*16kB 1*32kB 1*64kB 0*128kB 0*256kB 1*512kB
>> 0*1024kB 0*2048kB 0*4096kB = 1000kB
>> Normal: 691*4kB 17*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
>> 0*1024kB 0*2048kB 0*4096kB = 2900kB
>> 28310 total pagecache pages
>> 4385 pages in swap cache
>> Swap cache stats: add 144387, delete 140002, find 98398/115667
>> Free swap  = 889116kB
>> Total swap = 1023996kB
>> 65535 pages RAM
>> 1245 pages reserved
>> 27369 pages shared
>> 42219 pages non-shared
>> SLUB: Unable to allocate memory on node -1 (gfp=0x20)
>>   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default
>> order: 3, min order: 1
>>   node 0: slabs: 133, objs: 529, free: 0
>> skbuff alloc of size 3872 failed
>>
>> 2010/9/5 Eric Dumazet <eric.dumazet@gmail.com>
>> >
>> > Le dimanche 05 septembre 2010 à 08:51 -0700, Nikhil Sethi (निखिल सेठी) a
>> > écrit :
>> > > This came back. Here is the dmesg output. It might be the problem only
>> > > happens if I have wmm_enabled=1 in my hostapd.conf. That is the only
>> > > thing that I changed yesterday, and today I saw these messages in my
>> > > logs. I will try to conform this.
>> > >
>> > >
>> > > I am running 2.6.35.4 with this patch:
>> > >
>> > >
>> > > *** 225,234 ****
>> > >    int error = 0, i;
>> > >    u32 size;
>> > >
>> > > !
>> > > ! common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN +
>> > > !     ah->caps.rx_status_len,
>> > > !     min(common->cachelsz, (u16)64));
>> > >
>> > >    ath9k_hw_set_rx_bufsize(ah, common->rx_bufsize -
>> > >       ah->caps.rx_status_len);
>> > > --- 225,234 ----
>> > >    int error = 0, i;
>> > >    u32 size;
>> > >
>> > > ! size = roundup(IEEE80211_MAX_MPDU_LEN + ah->caps.rx_status_len,
>> > > !                        min(common->cachelsz, (u16)64));
>> > > !         common->rx_bufsize = min_t(u32, size,
>> > > !                                    SKB_MAX_ORDER(NET_SKB_PAD +
>> > > common->cachelsz, 0));
>
>
> Its very hard to follow this thread, with a message every two months.
>
>
> As I said, this patch got a min_t() instead of max_t()
>
> http://kerneltrap.org/mailarchive/linux-kernel/2010/8/25/4611322
>
> If you still have kmalloc-8192 allocations, I suspect you dont use right
> patch.
>
>
>
>
