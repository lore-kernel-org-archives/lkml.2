Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2JRQ60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:58:26 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:3753 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab2JRQ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:58:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,608,1344211200"; 
   d="scan'208";a="15260966"
Date: Thu, 18 Oct 2012 17:57:57 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jacob Shin <jacob.shin@amd.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
In-Reply-To: <20121018162611.GA11556@jshin-Toonie>
Message-ID: <alpine.DEB.2.02.1210181754290.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com> <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com> <alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
 <20121018162611.GA11556@jshin-Toonie>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,
thanks for testing!

Yinghai, it might be useful for you to try your patch series on Xen.
It is pretty simple, considering that you only need the hypervisor.
Just follow these steps:

- clone the xen-unstable git mirror
git clone git://xenbits.xen.org/xen.git

- compile and install xen
make xen
cp xen/xen.gz /boot

- add an entry to grub2.cfg
see the following example, note the multiboot line and the placeholder
argument after vmlinuz:

menuentry 'GNU/Linux, with Linux 2.6.32.40-pv' --class gnu-linux --class gnu --class os {
        recordfail
        insmod part_msdos
        insmod ext2
        search --no-floppy --fs-uuid --set=root 016e7c8a-4bdd-4873-92dd-d71171a49d6d
        set root='(/dev/sda,msdos2)'
        search --no-floppy --fs-uuid --set=root 016e7c8a-4bdd-4873-92dd-d71171a49d6d
        multiboot /boot/xen-4.2-unstable.gz
        module /boot/vmlinuz-2.6.32.40-pv placeholder root=UUID=016e7c8a-4bdd-4873-92dd-d71171a49d6d dom0_mem=1024 console=tty  quiet splash vt.handoff=7
        module /boot/initrd.img-2.6.32.40-pv
}

- reboot and enjoy!



On Thu, 18 Oct 2012, Jacob Shin wrote:
> On Thu, Oct 18, 2012 at 05:17:28PM +0100, Stefano Stabellini wrote:
> > On Thu, 11 Oct 2012, Yinghai Lu wrote:
> > > On Wed, Oct 10, 2012 at 9:40 AM, Stefano Stabellini
> > > <stefano.stabellini@eu.citrix.com> wrote:
> > > >
> > > > So you are missing the Xen patches entirely in this iteration of the
> > > > series?
> > > 
> > > please check updated for-x86-mm branch.
> > > 
> > > [PATCH -v4 00/15] x86: Use BRK to pre mapping page table to make xen happy
> > > 
> > > on top of current linus/master and tip/x86/mm2, but please zap last
> > > patch in that branch.
> > > 
> > > 1. use brk to mapping first PMD_SIZE range.
> > > 2. top down to initialize page table range by range.
> > > 3. get rid of calculate page table, and find_early_page_table.
> > > 4. remove early_ioremap in page table accessing.
> > > 
> > > v2: changes, update xen interface about pagetable_reserve, so not
> > >    use pgt_buf_* in xen code directly.
> > > v3: use range top-down to initialize page table, so will not use
> > >    calculating/find early table anymore.
> > >    also reorder the patches sequence.
> > > v4: add mapping_mark_page_ro to fix xen, also move pgt_buf_* to init.c
> > >     and merge alloc_low_page()
> > > 
> > > could be found at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> > > for-x86-mm
> > 
> > I find that patch series are easier to review than having to checkout
> > your code and read the commit messages. Please post your patch series to
> > the LKML next time.
> > 
> > In any case, regarding "x86, xen: Add xen_mapping_mark_page_ro": please
> > take Peter's feedback into account; mark_page_ro is not a good name for
> > a pvops.
> > Also I don't believe that this call is actually needed, see below.
> > 
> > Regarding "x86, mm: setup page table in top-down": if you mark the
> > pagetable page RO in alloc_low_page, won't the entire thing crash as
> > soon as you try to write to it? You are supposed to mark it RO after
> > filling up the pagetable page and before hooking it into the live
> > pagetable.
> > However contrary to my expectations, I did a quick test and it seems to
> > be working, that is probably due to a bug: maybe __pa or lookup_address
> > don't work correctly when called so early?
> 
> Hi Yinghai, I just tried it and dom0 died during init_memory_mapping, here
> is the Oops snippet, full logs are attached:
> 
> e820: last_pfn = 0x22f000 max_arch_pfn = 0x400000000
> e820: last_pfn = 0xcff00 max_arch_pfn = 0x400000000
> initial memory mapped: [mem 0x00000000-0x022affff]
> Base memory trampoline at [ffff880000096000] 96000 size 24576
> init_memory_mapping: [mem 0x00000000-0x000fffff]
>  [mem 0x00000000-0x000fffff] page 4k
> init_memory_mapping: [mem 0x21fe00000-0x21fe77fff]
>  [mem 0x21fe00000-0x21fe77fff] page 4k
> init_memory_mapping: [mem 0x21c000000-0x21fdfffff]
>  [mem 0x21c000000-0x21fdfffff] page 4k
> init_memory_mapping: [mem 0x200000000-0x21bffffff]
>  [mem 0x200000000-0x21bffffff] page 4k
> init_memory_mapping: [mem 0x00100000-0xcec6dfff]
>  [mem 0x00100000-0xcec6dfff] page 4k
> init_memory_mapping: [mem 0xcf5f4000-0xcf5f4fff]
>  [mem 0xcf5f4000-0xcf5f4fff] page 4k
> init_memory_mapping: [mem 0xcf7fb000-0xcfc19fff]
>  [mem 0xcf7fb000-0xcfc19fff] page 4k
> init_memory_mapping: [mem 0xcfef4000-0xcfefffff]
>  [mem 0xcfef4000-0xcfefffff] page 4k
> init_memory_mapping: [mem 0x100001000-0x1ffffffff]
>  [mem 0x100001000-0x1ffffffff] page 4k
> PGD 0 
> Oops: 0003 [#1] SMP 
> Modules linked in:
> CPU 0 
> Pid: 0, comm: swapper Not tainted 3.6.0+ #3 AMD Pike/Pike
> RIP: e030:[<ffffffff81cd778a>]  [<ffffffff81cd778a>] xen_set_pte_init+0x1/0x9
> RSP: e02b:ffffffff81c01ae8  EFLAGS: 00010086
> RAX: 80000001913d1063 RBX: ffff88021f63b1c8 RCX: 8000000000000163
> RDX: 00000000000001ff RSI: 80000001913d1063 RDI: ffff88021f63b1c8
> RBP: ffffffff81c01af8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 000000011b039000
> R13: 000000000000003a R14: 000000011b03a000 R15: 000000011b039000
> FS:  0000000000000000(0000) GS:ffffffff81cbe000(0000) knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000001c0b000 CR4: 0000000000000660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> Process swapper (pid: 0, threadinfo ffffffff81c00000, task ffffffff81c13410)
> Stack:
>  ffffffff81c01af8 ffffffff810330f5 ffffffff81c01b58 ffffffff816aa9f3
>  8000000000000163 ffff88021f63c000 0000000200000000 000000011b039000
>  ffffffff81c01b38 0000000000000000 000000011b000000 ffff88021f7146c0
> Call Trace:
>  [<ffffffff810330f5>] ? set_pte+0xb/0xd
>  [<ffffffff816aa9f3>] phys_pte_init+0xd4/0x106
>  [<ffffffff816aabe0>] phys_pmd_init+0x1bb/0x215
>  [<ffffffff816aadf3>] phys_pud_init+0x1b9/0x218
>  [<ffffffff816aaeff>] kernel_physical_mapping_init+0xad/0x14a
>  [<ffffffff81682a1a>] init_memory_mapping+0x275/0x303
>  [<ffffffff81ce6e62>] init_range_memory_mapping+0x8b/0xc8
>  [<ffffffff81ce6f91>] init_mem_mapping+0xf2/0x162
>  [<ffffffff81cd9d74>] setup_arch+0x682/0xaac
>  [<ffffffff816af4ab>] ? printk+0x48/0x4a
>  [<ffffffff81cd3868>] start_kernel+0x8e/0x3d8
>  [<ffffffff81cd32d3>] x86_64_start_reservations+0xae/0xb2
>  [<ffffffff81cd6dbc>] xen_start_kernel+0x63d/0x63f
> Code: 00 00 48 c7 c7 f2 a8 aa 81 e8 ee 61 36 ff c7 05 59 10 06 00 01 00 00 00 5d c3 55 48 89 f7 48 89 e5 e8 95 cf 32 ff 31 c0 5d c3 55 <48> 89 37 48 89 e5 5d c3 55 48 89 e5 41 57 41 56 45 31 f6 41 55 
>  RSP <ffffffff81c01ae8>
> CR2: 0000000000000000
> ---[ end trace c2b54da46b5614cf ]---

