Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2JIMUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:20:36 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:43597 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2JIMUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:20:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344211200"; 
   d="scan'208";a="15036284"
Date: Tue, 9 Oct 2012 13:19:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 00/10] x86: Use BRK to pre mapping page table to make
 xen happy
In-Reply-To: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1210091316570.29539@kaball.uk.xensource.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Yinghai Lu wrote:
> on top of tip/x86/mm2
> 
> 1. use brk to mapping final page table
> 2. remove early_ioremap in page table accessing.
> 
> v1-v2: changes, update xen interface about pagetable_reserve, so not
>    use pgt_buf_* in xen code directly.
> 
> could be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm
> 
> Yinghai Lu (10):
>   x86, mm: align start address to correct big page size
>   x86, mm: Use big page size for small memory range
>   x86, mm: get early page table from BRK
>   x86, mm: Don't clear page table if next range is ram
>   x86, mm: Remove early_memremap workaround for page table accessing
>   x86, mm: only keep initial mapping for ram
>   x86, xen, mm: Do not need to check if page table is ioremap
>   x86, xen, mm: fix mapping_pagetable_reserve logic
>   x86, mm: Hide pgt_buf_* into internal to xen
>   x86, mm: Add early_pgt_buf_*
> 
>  arch/x86/include/asm/init.h          |    5 ++
>  arch/x86/include/asm/pgtable.h       |    1 +
>  arch/x86/include/asm/pgtable_types.h |    1 -
>  arch/x86/include/asm/x86_init.h      |    2 +-
>  arch/x86/kernel/setup.c              |    2 +
>  arch/x86/kernel/x86_init.c           |    3 +-
>  arch/x86/mm/init.c                   |   73 ++++++++++++++++++++++++---
>  arch/x86/mm/init_32.c                |    9 +++-
>  arch/x86/mm/init_64.c                |   91 ++++++++++++----------------------
>  arch/x86/xen/mmu.c                   |   26 +++------
>  10 files changed, 125 insertions(+), 88 deletions(-)
> 
> -- 
> 1.7.7
> 

I agree with Peter that this series is going in the right direction.
However if I give more than 4G of RAM to the VM I get a panic at boot:

[    0.000000] Linux version 3.6.0-rc7+ (sstabellini@st22) (gcc version 4.4.5 (Debian 4.4.5-8) ) #532 SMP Tue Oct 9 12:15:32 UTC 2012
[    0.000000] Command line: root=/dev/xvda1 textmode=1 xencons=xvc0 debug loglevel=9 earlyprintk=xen
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x00000001387fffff] usable
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x138800 max_arch_pfn = 0x400000000
[    0.000000] e820: last_pfn = 0x100000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x02781fff]
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 24576
[    0.000000] calculate_table_space_size: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] calculate_table_space_size: [mem 0x00100000-0x1387fffff]
[    0.000000]  [mem 0x00100000-0x1387fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x137e33000-0x1387fffff]
[    0.000000]  [mem 0x137e33000-0x1387fffff] page 4k
[    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory
[    0.000000] Pid: 0, comm: swapper Not tainted 3.6.0-rc7+ #532
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8196f86d>] panic+0xc4/0x1da
[    0.000000]  [<ffffffff81005429>] ? pte_mfn_to_pfn+0x19/0x100
[    0.000000]  [<ffffffff819150c1>] alloc_low_page+0xc1/0xd0
[    0.000000]  [<ffffffff8218b197>] phys_pmd_init+0x1f5/0x2af
[    0.000000]  [<ffffffff8100987f>] ? __raw_callee_save_xen_restore_fl+0x11/0x1e
[    0.000000]  [<ffffffff81005125>] ? __raw_callee_save_xen_pud_val+0x11/0x1e
[    0.000000]  [<ffffffff8218b44a>] phys_pud_init+0x1f9/0x2af
[    0.000000]  [<ffffffff8100a8f9>] ? get_phys_to_machine+0x9/0x70
[    0.000000]  [<ffffffff8100508f>] ? __raw_callee_save_xen_pgd_val+0x11/0x1e
[    0.000000]  [<ffffffff8218b5c8>] kernel_physical_mapping_init+0xc8/0x187
[    0.000000]  [<ffffffff8218aba0>] ? T.620+0x208/0x21c
[    0.000000]  [<ffffffff81914f41>] init_memory_mapping+0x81/0x140
[    0.000000]  [<ffffffff8215ab94>] init_mem_mapping+0x119/0x242
[    0.000000]  [<ffffffff8214c3bc>] setup_arch+0x707/0xb42
[    0.000000]  [<ffffffff8196fa59>] ? printk+0x4d/0x4f
[    0.000000]  [<ffffffff82145ab1>] start_kernel+0xd9/0x3b8
[    0.000000]  [<ffffffff82145356>] x86_64_start_reservations+0x131/0x136
[    0.000000]  [<ffffffff8214931e>] xen_start_kernel+0x68f/0x696
