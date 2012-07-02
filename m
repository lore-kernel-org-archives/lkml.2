Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2GBNdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2GBNdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:33:15 -0400
Date: Mon, 2 Jul 2012 09:33:08 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Joe Thornber <ejt@redhat.com>,
        LVM general discussion and development 
	<linux-lvm@redhat.com>,
        amwang@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: Regression with FALLOC_FL_PUNCH_HOLE in 3.5-rc kernel
Message-ID: <20120702133308.GB785@redhat.com>
References: <4FEEE5E5.5060800@redhat.com>
 <alpine.LSU.2.00.1206301217590.1728@eggly.anvils>
 <4FEF66C4.20001@redhat.com>
 <alpine.LSU.2.00.1206301541280.1919@eggly.anvils>
 <4FF04950.30503@redhat.com>
 <alpine.LSU.2.00.1207011112250.1799@eggly.anvils>
 <4FF0AEA9.3090900@redhat.com>
 <4FF0C91B.8050700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF0C91B.8050700@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure why you're testing such old kernels without regard for fixes
(likely just a hopeful bisect?).

In any case, you definitely need this commit (was also marked for
stable): 0c535e0 v3.3-rc7 dm io: fix discard support


On Sun, Jul 01 2012 at  6:03pm -0400,
Zdenek Kabelac <zkabelac@redhat.com> wrote:

> 
> I've enabled more kernel debugging tools - and this came out when
> running test suite:
> 
> Unsure if this could be source of troubles?
> 
> kernel BUG at arch/x86/mm/physaddr.c:18!
> invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> CPU 1
> Modules linked in: dm_mirror dm_region_hash dm_log aes_generic tun
> bridge stp llc psmouse serio_raw cryptomgr aead arc4 crypto_algapi
> sr_mod cdrom iwl3945 iwl_legacy mac80211 cfg80211 crypto e1000e
> evdev loop dm_mod autofs4
> 
> Pid: 8, comm: kworker/1:0 Not tainted 3.1.0-rc1-00009-gdfaa2ef #30
> LENOVO 6464CTO/6464CTO
> RIP: 0010:[<ffffffff81021f00>]  [<ffffffff81021f00>] __phys_addr+0x60/0x70
> RSP: 0018:ffff880136e41aa0  EFLAGS: 00010213
> RAX: ffff87ffffffffff RBX: ffff880136e41ba0 RCX: ffff880136e41b3c
> RDX: ffff880136e41b48 RSI: ffff880136e41b40 RDI: 0000000000000000
> RBP: ffff880136e41aa0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff880136e41b40
> R13: ffff880136e41b48 R14: ffff880136e41b3c R15: ffff88011e9bec40
> FS:  0000000000000000(0000) GS:ffff880137400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f34760df0c0 CR3: 0000000001604000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kworker/1:0 (pid: 8, threadinfo ffff880136e40000, task ffff880136e3e090)
> Stack:
>  ffff880136e41ad0 ffffffffa0013f3d 0000000000000800 ffff880136e41ba0
>  ffff88011eae6800 ffff880136e41c10 ffff880136e41b80 ffffffffa001437e
>  00000000239a96d0 0000000000000000 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffffa0013f3d>] km_get_page+0x2d/0xa0 [dm_mod]
>  [<ffffffffa001437e>] dispatch_io+0x1ae/0x250 [dm_mod]
>  [<ffffffffa0013e90>] ? vm_next_page+0x20/0x20 [dm_mod]
>  [<ffffffffa0013f10>] ? vm_get_page+0x60/0x60 [dm_mod]
>  [<ffffffffa013dab0>] ? mirror_flush+0x120/0x120 [dm_mirror]
>  [<ffffffffa0014627>] dm_io+0xe7/0x1f0 [dm_mod]
>  [<ffffffffa0013f10>] ? vm_get_page+0x60/0x60 [dm_mod]
>  [<ffffffffa0013e90>] ? vm_next_page+0x20/0x20 [dm_mod]
>  [<ffffffffa013e204>] do_writes+0x324/0x650 [dm_mirror]
>  [<ffffffffa013e085>] ? do_writes+0x1a5/0x650 [dm_mirror]
>  [<ffffffffa013dab0>] ? mirror_flush+0x120/0x120 [dm_mirror]
>  [<ffffffffa013e9f4>] do_mirror+0x104/0x230 [dm_mirror]
>  [<ffffffff81050177>] process_one_work+0x197/0x460
>  [<ffffffff81050116>] ? process_one_work+0x136/0x460
>  [<ffffffffa013e8f0>] ? do_reads+0x180/0x180 [dm_mirror]
>  [<ffffffff81050986>] worker_thread+0x126/0x2d0
>  [<ffffffff81050860>] ? manage_workers.isra.28+0x1f0/0x1f0
>  [<ffffffff81056066>] kthread+0x96/0xa0
>  [<ffffffff8133b614>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8133405d>] ? retint_restore_args+0xe/0xe
>  [<ffffffff81055fd0>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff8133b610>] ? gs_change+0xb/0xb
> Code: ff ff 87 ff ff 48 39 c7 76 21 0f b6 0d a3 61 62 00 48 b8 00 00
> 00 00 00 78 00 00 48 01 f8 48 89 c2 48 d3 ea 48 85 d2 74 d0 0f 0b
> <0f> 0b 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 66 90 83 f9 01 49 ba
> RIP  [<ffffffff81021f00>] __phys_addr+0x60/0x70
>  RSP <ffff880136e41aa0>
> ---[ end trace 040dfd9d68fccabc ]---
> 
> 
> 
> Zdenek
