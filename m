Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab0DHXxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:53:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42087 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933505Ab0DHXxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:53:09 -0400
Date: Fri, 9 Apr 2010 01:47:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100408234721.GB25834@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
	hannes@cmpxchg.org
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
 <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic>
 <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
 <20100408210035.GA25834@a1.tnic>
 <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, Apr 08, 2010 at 04:16:23PM -0700

> > And this happens quite often - I changed the WARN_ONCE to WARN and can't
> > start kvm, iceowl (mozilla calendar) and the console-kit-daemon craps up
> > upon boot too:
> 
> Hmm. I tried console-kit-daemon, which I had installed, but didn't get 
> anything like that. Probably some setup difference.
> 
> I also went through every user of 'vm_area_cachep', and saw nothing 
> suspicious at least for the mmu case (I didn't check the nommu.c code). I 
> must have missed something.
> 
> One thing you could do is to add some more debugging info when that "no 
> anon_vma" warning happens. In particular, if you still have the SLUB 
> debugging on, you could try to do that
> 
> 	page = virt_to_head_page(vma);
> 	object_err(vm_area_cachep, page, (void *)vma, "NULL anon_vma");
> 
> and it should give you _which_ routine did the kmem_cache_alloc() for the 
> vma that doesn't have an anon_vma.

Yep, looks good: its mmap_region()...


[   88.237326] ------------[ cut here ]------------
[   88.237377] WARNING: at mm/memory.c:3110 handle_mm_fault+0x43/0x6ab()
[   88.237403] Hardware name: System Product Name
[   88.237428] Mapping with no anon_vma
[   88.237451] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 ohci_hcd edac_core serial_core pcspkr k10temp
[   88.237938] Pid: 1978, comm: console-kit-dae Not tainted 2.6.34-rc3-00290-g2156db9-dirty #9
[   88.237980] Call Trace:
[   88.239269]  [<ffffffff81037ec0>] warn_slowpath_common+0x7c/0x94
[   88.239320]  [<ffffffff81037f2f>] warn_slowpath_fmt+0x41/0x43
[   88.239378]  [<ffffffff810b8582>] handle_mm_fault+0x43/0x6ab
[   88.239440]  [<ffffffff8101f3b2>] do_page_fault+0x30b/0x32d
[   88.239471]  [<ffffffff810615e6>] ? put_lock_stats+0xe/0x27
[   88.239517]  [<ffffffff81062a6d>] ? lock_release_holdtime+0x104/0x109
[   88.239548]  [<ffffffff813f9463>] ? error_sti+0x5/0x6
[   88.239597]  [<ffffffff813f7e52>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   88.239626]  [<ffffffff813f927f>] page_fault+0x1f/0x30
[   88.239674] ---[ end trace 42d53170a0d3ccef ]---
[   88.239699] =============================================================================
[   88.239750] BUG vm_area_struct: NULL anon_vma
[   88.239790] -----------------------------------------------------------------------------
[   88.239794] 
[   88.239805] INFO: Allocated in mmap_region+0x23d/0x500 age=2 cpu=0 pid=1978
[   88.239815] INFO: Slab 0xffffea0007a0f0e8 objects=17 used=1 fp=0xffff88022dfbb0f0 flags=0x80000000000000c2
[   88.239823] INFO: Object 0xffff88022dfbb000 @offset=0 fp=0xffff88022dfbb0f0
[   88.239827] 
[   88.239832]   Object 0xffff88022dfbb000:  00 32 53 2b 02 88 ff ff 00 20 ab 29 d1 7f 00 00 .2S+..ÿÿ..«)Ñ...
[   88.239861]   Object 0xffff88022dfbb010:  00 30 ac 29 d1 7f 00 00 e0 81 2b 2c 02 88 ff ff .0¬)Ñ...à.+,..ÿÿ
[   88.239886]   Object 0xffff88022dfbb020:  25 00 00 00 00 00 00 80 73 00 10 00 00 00 00 00 %.......s.......
[   88.239910]   Object 0xffff88022dfbb030:  10 82 2b 2c 02 88 ff ff 00 00 00 00 00 00 00 00 ..+,..ÿÿ........
[   88.239966]   Object 0xffff88022dfbb040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[   88.240016]   Object 0xffff88022dfbb050:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[   88.240077]   Object 0xffff88022dfbb060:  00 00 00 00 00 00 00 00 10 a0 1c 2c 02 88 ff ff ...........,..ÿÿ
[   88.240160]   Object 0xffff88022dfbb070:  10 a0 1c 2c 02 88 ff ff 00 00 00 00 00 00 00 00 ...,..ÿÿ........
[   88.240225]   Object 0xffff88022dfbb080:  00 00 00 00 00 00 00 00 b2 9a 12 fd 07 00 00 00 ........²..ý....
[   88.240294]   Object 0xffff88022dfbb090:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[   88.240352]   Object 0xffff88022dfbb0a0:  00 00 00 00 00 00 00 00                         ........        
[   88.240442]  Redzone 0xffff88022dfbb0a8:  cc cc cc cc cc cc cc cc                         ÌÌÌÌÌÌÌÌ        
[   88.240509]  Padding 0xffff88022dfbb0e8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[   88.240567] Pid: 1978, comm: console-kit-dae Tainted: G        W  2.6.34-rc3-00290-g2156db9-dirty #9
[   88.240578] Call Trace:
[   88.240593]  [<ffffffff810cd802>] print_trailer+0x139/0x142
[   88.240607]  [<ffffffff810cd845>] object_err+0x3a/0x42
[   88.240617]  [<ffffffff810b85e2>] handle_mm_fault+0xa3/0x6ab
[   88.240641]  [<ffffffff8101f3b2>] do_page_fault+0x30b/0x32d
[   88.240652]  [<ffffffff810615e6>] ? put_lock_stats+0xe/0x27
[   88.240663]  [<ffffffff81062a6d>] ? lock_release_holdtime+0x104/0x109
[   88.240685]  [<ffffffff813f9463>] ? error_sti+0x5/0x6
[   88.240695]  [<ffffffff813f7e52>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   88.240707]  [<ffffffff813f927f>] page_fault+0x1f/0x30
[   93.841666] ------------[ cut here ]------------
[   93.841716] WARNING: at mm/memory.c:3110 handle_mm_fault+0x43/0x6ab()
[   93.841741] Hardware name: System Product Name
[   93.841766] Mapping with no anon_vma
[   93.841793] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 ohci_hcd edac_core serial_core pcspkr k10temp
[   93.842339] Pid: 2050, comm: iceowl-bin Tainted: G        W  2.6.34-rc3-00290-g2156db9-dirty #9
[   93.842383] Call Trace:
[   93.842424]  [<ffffffff81037ec0>] warn_slowpath_common+0x7c/0x94
[   93.842457]  [<ffffffff81037f2f>] warn_slowpath_fmt+0x41/0x43
[   93.842492]  [<ffffffff810b8582>] handle_mm_fault+0x43/0x6ab
[   93.842527]  [<ffffffff8101f3b2>] do_page_fault+0x30b/0x32d
[   93.842561]  [<ffffffff810615e6>] ? put_lock_stats+0xe/0x27
[   93.842593]  [<ffffffff81062a6d>] ? lock_release_holdtime+0x104/0x109
[   93.842627]  [<ffffffff813f9463>] ? error_sti+0x5/0x6
[   93.842660]  [<ffffffff813f7e52>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   93.842694]  [<ffffffff813f927f>] page_fault+0x1f/0x30
[   93.842724] ---[ end trace 42d53170a0d3ccf0 ]---
[   93.842750] =============================================================================
[   93.842794] BUG vm_area_struct: NULL anon_vma
[   93.842822] -----------------------------------------------------------------------------
[   93.842827] 
[   93.842889] INFO: Allocated in mmap_region+0x23d/0x500 age=1 cpu=2 pid=2050
[   93.842918] INFO: Slab 0xffffea00079b84b8 objects=17 used=7 fp=0xffff88022c6f1690 flags=0x80000000000000c2
[   93.842961] INFO: Object 0xffff88022c6f15a0 @offset=1440 fp=0xffff88022c6f1690
[   93.842965] 
[   93.843005] Bytes b4 0xffff88022c6f1590:  48 d9 fc ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a HÙüÿ....ZZZZZZZZ
[   93.843466]   Object 0xffff88022c6f15a0:  00 78 b4 2e 02 88 ff ff 00 80 ce 49 5f 7f 00 00 .x´...ÿÿ..ÎI_...
[   93.843877]   Object 0xffff88022c6f15b0:  00 90 4e 4a 5f 7f 00 00 c0 13 6f 2c 02 88 ff ff ..NJ_...À.o,..ÿÿ
[   93.844391]   Object 0xffff88022c6f15c0:  25 00 00 00 00 00 00 80 73 00 10 00 00 00 00 00 %.......s.......
[   93.844794]   Object 0xffff88022c6f15d0:  e0 94 4a 2c 02 88 ff ff 00 00 00 00 00 00 00 00 à.J,..ÿÿ........
[   93.845198]   Object 0xffff88022c6f15e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[   93.845665]   Object 0xffff88022c6f15f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[   93.846076]   Object 0xffff88022c6f1600:  00 00 00 00 00 00 00 00 30 2d ec 2a 02 88 ff ff ........0-ì*..ÿÿ
[   93.846518]   Object 0xffff88022c6f1610:  30 2d ec 2a 02 88 ff ff 00 00 00 00 00 00 00 00 0-ì*..ÿÿ........
[   93.846931]   Object 0xffff88022c6f1620:  00 00 00 00 00 00 00 00 e8 9c f4 f5 07 00 00 00 ........è.ôõ....
[   93.847372]   Object 0xffff88022c6f1630:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[   93.847787]   Object 0xffff88022c6f1640:  00 00 00 00 00 00 00 00                         ........        
[   93.848194]  Redzone 0xffff88022c6f1648:  cc cc cc cc cc cc cc cc                         ÌÌÌÌÌÌÌÌ        
[   93.848635]  Padding 0xffff88022c6f1688:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[   93.849036] Pid: 2050, comm: iceowl-bin Tainted: G        W  2.6.34-rc3-00290-g2156db9-dirty #9
[   93.849078] Call Trace:
[   93.849111]  [<ffffffff810cd802>] print_trailer+0x139/0x142
[   93.849142]  [<ffffffff810cd845>] object_err+0x3a/0x42
[   93.849174]  [<ffffffff810b85e2>] handle_mm_fault+0xa3/0x6ab
[   93.849204]  [<ffffffff8101f3b2>] do_page_fault+0x30b/0x32d
[   93.849237]  [<ffffffff810615e6>] ? put_lock_stats+0xe/0x27
[   93.849301]  [<ffffffff81062a6d>] ? lock_release_holdtime+0x104/0x109
[   93.849337]  [<ffffffff813f9463>] ? error_sti+0x5/0x6
[   93.849370]  [<ffffffff813f7e52>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   93.849418]  [<ffffffff813f927f>] page_fault+0x1f/0x30


-- 
Regards/Gruss,
Boris.
