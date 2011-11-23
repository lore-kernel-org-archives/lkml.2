Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1KWNU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:20:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab1KWNUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:20:55 -0500
Message-ID: <4ECCF318.3070000@redhat.com>
Date: Wed, 23 Nov 2011 14:20:24 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
CC: Nitin Gupta <ngupta@vflare.org>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: zram deadlock detected
References: <20111113131649.GB31690@smp.if.uj.edu.pl> <4EC0F04F.8010403@redhat.com>
In-Reply-To: <4EC0F04F.8010403@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 11:41 AM, Jerome Marchand wrote:
> On 11/13/2011 02:16 PM, Witold Baryluk wrote:
>> Hi,
>>
>> just moments after seting size to 256MB (on 512 machine),
>> mkswap /dev/zram0 and swapon -p 10 /dev/zram0 of 256MB zram
>> when system was under high cpu/mem load, I got warning from lockdep.
>> (I was upgrading system, and it was slow because of excessive swaping
>> so I was thinking that enabling zram will help - and it helped, disk swaping
>> stoped and  upgrade processed much smoother and faster, maybe 10 times faster),
>>
> Hi Witold,
> 
> Thank you for your feedback. It looks to me that we used a GFP_KERNEL allocation
> somewhere when we should have used GFP_NOFS or even GFP_NOIO.

I now think this is a false positive. The mentioned IN-RECLAIM_FS-R lock can only
happen when the device has been swapped on, at which point the initialization of
the device (where the RECLAIM_FS-ON-W is taken) has been already done.
I don't how to shut the warning, though. Lockdep is not that well documented.

On a related note, while investigating this issue, I noticed a suspicious allocation
in zram_init_device():

zram->compress_buffer = (void *)__get_free_pages(__GFP_ZERO, 1);

It does not precise any kind of permission such as GFP_KERNEL. I don't know what
kind of allocation is performed in such a case, but I know it looks wrong.

Thanks,
Jerome

> 
> Jerome
> 
>>
>> This is part of dmesg
>>
>> [ 4882.866060] Adding 262140k swap on /dev/zram0.  Priority:10 extents:1 across:262140k SS
>> [ 4882.910497] 
>> [ 4882.910503] =================================
>> [ 4882.910506] [ INFO: inconsistent lock state ]
>> [ 4882.910510] 3.2.0-rc1-t43-devel-smp-00091-g5e442a4-dirty #15
>> [ 4882.910513] ---------------------------------
>> [ 4882.910516] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
>> [ 4882.910520] kswapd0/561 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> [ 4882.910524]  (&zram->init_lock){+++++-}, at: [<e1948317>] zram_make_request+0x37/0xd0 [zram]
>> [ 4882.910538] {RECLAIM_FS-ON-W} state was registered at:
>> [ 4882.910541]   [<c10a2fa6>] mark_held_locks+0x66/0xf0
>> [ 4882.910550]   [<c10a306c>] __lockdep_trace_alloc+0x3c/0x70
>> [ 4882.910556]   [<c10a374b>] lockdep_trace_alloc+0x4b/0x70
>> [ 4882.910561]   [<c111b27b>] __alloc_pages_nodemask+0x5b/0x7d0
>> [ 4882.910568]   [<c111ba6c>] __get_free_pages+0x1c/0x30
>> [ 4882.910573]   [<c1156339>] kmalloc_order_trace+0x29/0x150
>> [ 4882.910579]   [<e1948137>] zram_init_device+0xa7/0x250 [zram]
>> [ 4882.910585]   [<e19483a5>] zram_make_request+0xc5/0xd0 [zram]
>> [ 4882.910591]   [<c12d465f>] generic_make_request.part.50+0x5f/0x90
>> [ 4882.910598]   [<c12d7477>] generic_make_request+0x57/0x60
>> [ 4882.910604]   [<c12d74e4>] submit_bio+0x64/0xf0
>> [ 4882.910609]   [<c1198201>] submit_bh+0xd1/0x100
>> [ 4882.910615]   [<c119ae34>] block_read_full_page+0x254/0x3e0
>> [ 4882.910621]   [<c119fa04>] blkdev_readpage+0x14/0x20
>> [ 4882.910626]   [<c111daf3>] read_pages+0xc3/0xe0
>> [ 4882.910631]   [<c111de44>] __do_page_cache_readahead+0x1b4/0x1e0
>> [ 4882.910636]   [<c111def5>] force_page_cache_readahead+0x85/0xb0
>> [ 4882.910642]   [<c111e34a>] page_cache_sync_readahead+0x5a/0x70
>> [ 4882.910647]   [<c11147f2>] do_generic_file_read.constprop.29+0x322/0x4f0
>> [ 4882.910655]   [<c11156d9>] generic_file_aio_read+0xd9/0x290
>> [ 4882.910660]   [<c116853c>] do_sync_read+0xac/0xe0
>> [ 4882.910667]   [<c116908c>] vfs_read+0x8c/0x160
>> [ 4882.910672]   [<c116919d>] sys_read+0x3d/0x70
>> [ 4882.910677]   [<c177add8>] sysenter_do_call+0x12/0x38
>> [ 4882.910686] irq event stamp: 10471779
>> [ 4882.910688] hardirqs last  enabled at (10471779): [<c1772c16>] _raw_spin_unlock_irqrestore+0x36/0x70
>> [ 4882.910697] hardirqs last disabled at (10471778): [<c17731d9>] _raw_spin_lock_irqsave+0x29/0xa0
>> [ 4882.910703] softirqs last  enabled at (10466064): [<c106cefc>] irq_exit+0xac/0xb0
>> [ 4882.910711] softirqs last disabled at (10466063): [<c177b50b>] do_IRQ+0x4b/0xc0
>> [ 4882.910716] 
>> [ 4882.910717] other info that might help us debug this:
>> [ 4882.910720]  Possible unsafe locking scenario:
>> [ 4882.910721] 
>> [ 4882.910724]        CPU0
>> [ 4882.910726]        ----
>> [ 4882.910728]   lock(&zram->init_lock);
>> [ 4882.910732]   <Interrupt>
>> [ 4882.910734]     lock(&zram->init_lock);
>> [ 4882.910739] 
>> [ 4882.910740]  *** DEADLOCK ***
>> [ 4882.910741] 
>> [ 4882.910744] no locks held by kswapd0/561.
>> [ 4882.910746] 
>> [ 4882.910747] stack backtrace:
>> [ 4882.910752] Pid: 561, comm: kswapd0 Tainted: G         C   3.2.0-rc1-t43-devel-smp-00091-g5e442a4-dirty #15
>> [ 4882.910756] Call Trace:
>> [ 4882.910763]  [<c1759fd2>] ? printk+0x1d/0x1f
>> [ 4882.910768]  [<c175ae94>] print_usage_bug+0x150/0x15a
>> [ 4882.910774]  [<c10a13d0>] ? print_irq_inversion_bug.part.31+0x1c0/0x1c0
>> [ 4882.910779]  [<c175aefc>] mark_lock_irq+0x5e/0x117
>> [ 4882.910784]  [<c10a2cc1>] mark_lock+0xe1/0x1c0
>> [ 4882.910790]  [<c1091f45>] ? local_clock+0x65/0x70
>> [ 4882.910795]  [<c10a2e5d>] mark_irqflags+0xbd/0x1a0
>> [ 4882.910800]  [<c10a4cca>] __lock_acquire+0x47a/0x800
>> [ 4882.910805]  [<c10a5697>] lock_acquire+0x87/0x1b0
>> [ 4882.910811]  [<e1948317>] ? zram_make_request+0x37/0xd0 [zram]
>> [ 4882.910816]  [<c12d6ff6>] ? generic_make_request_checks+0xc6/0x4f0
>> [ 4882.910821]  [<c1771ac0>] down_read+0x50/0x8a
>> [ 4882.910826]  [<e1948317>] ? zram_make_request+0x37/0xd0 [zram]
>> [ 4882.910832]  [<e1948317>] zram_make_request+0x37/0xd0 [zram]
>> [ 4882.910837]  [<c12d465f>] generic_make_request.part.50+0x5f/0x90
>> [ 4882.910842]  [<c12d7477>] generic_make_request+0x57/0x60
>> [ 4882.910847]  [<c12d74e4>] submit_bio+0x64/0xf0
>> [ 4882.910852]  [<c111bb12>] ? account_page_writeback+0x12/0x20
>> [ 4882.910857]  [<c111ca56>] ? test_set_page_writeback+0xc6/0x160
>> [ 4882.910862]  [<c1146800>] ? get_swap_bio+0x80/0x80
>> [ 4882.910867]  [<c114696a>] swap_writepage+0x6a/0xb0
>> [ 4882.910873]  [<c1122c23>] pageout+0x123/0x2d0
>> [ 4882.910879]  [<c113f5a2>] ? page_unlock_anon_vma+0x12/0x20
>> [ 4882.910884]  [<c11411f5>] ? try_to_unmap_anon+0xc5/0x100
>> [ 4882.910889]  [<c1146a6a>] ? __add_to_swap_cache+0x6a/0xa0
>> [ 4882.910894]  [<c112591e>] shrink_page_list+0x46e/0x540
>> [ 4882.910899]  [<c1125d4d>] shrink_inactive_list+0x12d/0x510
>> [ 4882.910904]  [<c10a327b>] ? trace_hardirqs_on+0xb/0x10
>> [ 4882.910910]  [<c1123118>] ? get_scan_count+0x208/0x300
>> [ 4882.910914]  [<c11261df>] shrink_list+0xaf/0x100
>> [ 4882.910919]  [<c11262d1>] shrink_zone+0xa1/0x1a0
>> [ 4882.910924]  [<c11267bd>] balance_pgdat+0x3ed/0x580
>> [ 4882.910930]  [<c1126a43>] kswapd+0xf3/0x260
>> [ 4882.910934]  [<c1126950>] ? balance_pgdat+0x580/0x580
>> [ 4882.910940]  [<c108a49d>] kthread+0x6d/0x80
>> [ 4882.910945]  [<c108a430>] ? __init_kthread_worker+0x60/0x60
>> [ 4882.910949]  [<c177b37a>] kernel_thread_helper+0x6/0x10
>>
>> System works without problem later on. I also disabled
>> later zram (swapoff + rmmod) and enabled it again (modprobe + set size + mkswap + swapon),
>> and also not find any problem.
>>
>> I'm not sure if this is regression, because I run UP kernel without
>> debuging or lockdep normally.  I use SMP with full debuging
>> only from time to time.
>>
>> Full dmesg
>> http://smp.if.uj.edu.pl/~baryluk/linux-kernel/2011-11-13/deadlock-zram-3.2.0-rc1-t43-devel-smp-00091-g5e442a4-dirty.txt
>>
>> Full config
>> http://smp.if.uj.edu.pl/~baryluk/linux-kernel/2011-11-13/config-3.2.0-rc1-t43-devel-smp-00091-g5e442a4-dirty
>>
>>
>> It is 32-bit Intel,  on Debian GNU/Linux unstable with gcc 4.6.2-4 -march=pentium-m
>> SMP config of course.
>>
>> Any ideas?
>>
>> Regards,
>> Witek
>>
>>
> 

