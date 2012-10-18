Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2JRQ0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:26:21 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9073 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496Ab2JRQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:26:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371Id6eahc85fh1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839hd25hd2bhf0ah107ah1288h12a5h12bdh137ah1441h34h1155h)
X-WSS-ID: 0MC3KBO-02-3UT-02
X-M-MSG: 
Date: Thu, 18 Oct 2012 11:26:11 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
Message-ID: <20121018162611.GA11556@jshin-Toonie>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
 <alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
 <CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
 <alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Oct 18, 2012 at 05:17:28PM +0100, Stefano Stabellini wrote:
> On Thu, 11 Oct 2012, Yinghai Lu wrote:
> > On Wed, Oct 10, 2012 at 9:40 AM, Stefano Stabellini
> > <stefano.stabellini@eu.citrix.com> wrote:
> > >
> > > So you are missing the Xen patches entirely in this iteration of the
> > > series?
> > 
> > please check updated for-x86-mm branch.
> > 
> > [PATCH -v4 00/15] x86: Use BRK to pre mapping page table to make xen happy
> > 
> > on top of current linus/master and tip/x86/mm2, but please zap last
> > patch in that branch.
> > 
> > 1. use brk to mapping first PMD_SIZE range.
> > 2. top down to initialize page table range by range.
> > 3. get rid of calculate page table, and find_early_page_table.
> > 4. remove early_ioremap in page table accessing.
> > 
> > v2: changes, update xen interface about pagetable_reserve, so not
> >    use pgt_buf_* in xen code directly.
> > v3: use range top-down to initialize page table, so will not use
> >    calculating/find early table anymore.
> >    also reorder the patches sequence.
> > v4: add mapping_mark_page_ro to fix xen, also move pgt_buf_* to init.c
> >     and merge alloc_low_page()
> > 
> > could be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> > for-x86-mm
> 
> I find that patch series are easier to review than having to checkout
> your code and read the commit messages. Please post your patch series to
> the LKML next time.
> 
> In any case, regarding "x86, xen: Add xen_mapping_mark_page_ro": please
> take Peter's feedback into account; mark_page_ro is not a good name for
> a pvops.
> Also I don't believe that this call is actually needed, see below.
> 
> Regarding "x86, mm: setup page table in top-down": if you mark the
> pagetable page RO in alloc_low_page, won't the entire thing crash as
> soon as you try to write to it? You are supposed to mark it RO after
> filling up the pagetable page and before hooking it into the live
> pagetable.
> However contrary to my expectations, I did a quick test and it seems to
> be working, that is probably due to a bug: maybe __pa or lookup_address
> don't work correctly when called so early?

Hi Yinghai, I just tried it and dom0 died during init_memory_mapping, here
is the Oops snippet, full logs are attached:

e820: last_pfn = 0x22f000 max_arch_pfn = 0x400000000
e820: last_pfn = 0xcff00 max_arch_pfn = 0x400000000
initial memory mapped: [mem 0x00000000-0x022affff]
Base memory trampoline at [ffff880000096000] 96000 size 24576
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
init_memory_mapping: [mem 0x21fe00000-0x21fe77fff]
 [mem 0x21fe00000-0x21fe77fff] page 4k
init_memory_mapping: [mem 0x21c000000-0x21fdfffff]
 [mem 0x21c000000-0x21fdfffff] page 4k
init_memory_mapping: [mem 0x200000000-0x21bffffff]
 [mem 0x200000000-0x21bffffff] page 4k
init_memory_mapping: [mem 0x00100000-0xcec6dfff]
 [mem 0x00100000-0xcec6dfff] page 4k
init_memory_mapping: [mem 0xcf5f4000-0xcf5f4fff]
 [mem 0xcf5f4000-0xcf5f4fff] page 4k
init_memory_mapping: [mem 0xcf7fb000-0xcfc19fff]
 [mem 0xcf7fb000-0xcfc19fff] page 4k
init_memory_mapping: [mem 0xcfef4000-0xcfefffff]
 [mem 0xcfef4000-0xcfefffff] page 4k
init_memory_mapping: [mem 0x100001000-0x1ffffffff]
 [mem 0x100001000-0x1ffffffff] page 4k
PGD 0 
Oops: 0003 [#1] SMP 
Modules linked in:
CPU 0 
Pid: 0, comm: swapper Not tainted 3.6.0+ #3 AMD Pike/Pike
RIP: e030:[<ffffffff81cd778a>]  [<ffffffff81cd778a>] xen_set_pte_init+0x1/0x9
RSP: e02b:ffffffff81c01ae8  EFLAGS: 00010086
RAX: 80000001913d1063 RBX: ffff88021f63b1c8 RCX: 8000000000000163
RDX: 00000000000001ff RSI: 80000001913d1063 RDI: ffff88021f63b1c8
RBP: ffffffff81c01af8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 000000011b039000
R13: 000000000000003a R14: 000000011b03a000 R15: 000000011b039000
FS:  0000000000000000(0000) GS:ffffffff81cbe000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000001c0b000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
Process swapper (pid: 0, threadinfo ffffffff81c00000, task ffffffff81c13410)
Stack:
 ffffffff81c01af8 ffffffff810330f5 ffffffff81c01b58 ffffffff816aa9f3
 8000000000000163 ffff88021f63c000 0000000200000000 000000011b039000
 ffffffff81c01b38 0000000000000000 000000011b000000 ffff88021f7146c0
Call Trace:
 [<ffffffff810330f5>] ? set_pte+0xb/0xd
 [<ffffffff816aa9f3>] phys_pte_init+0xd4/0x106
 [<ffffffff816aabe0>] phys_pmd_init+0x1bb/0x215
 [<ffffffff816aadf3>] phys_pud_init+0x1b9/0x218
 [<ffffffff816aaeff>] kernel_physical_mapping_init+0xad/0x14a
 [<ffffffff81682a1a>] init_memory_mapping+0x275/0x303
 [<ffffffff81ce6e62>] init_range_memory_mapping+0x8b/0xc8
 [<ffffffff81ce6f91>] init_mem_mapping+0xf2/0x162
 [<ffffffff81cd9d74>] setup_arch+0x682/0xaac
 [<ffffffff816af4ab>] ? printk+0x48/0x4a
 [<ffffffff81cd3868>] start_kernel+0x8e/0x3d8
 [<ffffffff81cd32d3>] x86_64_start_reservations+0xae/0xb2
 [<ffffffff81cd6dbc>] xen_start_kernel+0x63d/0x63f
Code: 00 00 48 c7 c7 f2 a8 aa 81 e8 ee 61 36 ff c7 05 59 10 06 00 01 00 00 00 5d c3 55 48 89 f7 48 89 e5 e8 95 cf 32 ff 31 c0 5d c3 55 <48> 89 37 48 89 e5 5d c3 55 48 89 e5 41 57 41 56 45 31 f6 41 55 
 RSP <ffffffff81c01ae8>
CR2: 0000000000000000
---[ end trace c2b54da46b5614cf ]---

> 
> In any case we don't care about that because if we assume that
> alloc_low_pages will always return a page from a range that is already
> mapped, then we do not need this pvop anymore. That's because
> xen_alloc_pte_init, xen_alloc_pmd_init, etc, will mark the page RO
> before hooking it into the pagetable automatically.
> Sorry for I misled you last time.
> 
> Let me repeat it again:
> Can we assume that the page returned by alloc_low_pages is already mapped?
> 
> Yes? In that case let's get rid of mark_page_ro and everything should
> work.
> 
> It is worth stating it in clear letters in a comment on top of
> alloc_low_pages:
> 
> "This function always returns a page from a memory range already
> mapped."
> 

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset="us-ascii"; name="dom0.txt"
Content-Disposition: attachment; filename="dom0.txt"
Content-Description: dom0.txt

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.6.0+ (jshin@jshin-Pike) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #3 SMP Fri Oct 12 16:22:42 CDT 2012
Command line: placeholder root=/dev/sda1 ro
Freeing 9c-100 pfn range: 100 pages freed
1-1 mapping on 9c->100
Freeing cec6e-cf5f4 pfn range: 2438 pages freed
1-1 mapping on cec6e->cf5f4
Freeing cf5f5-cf7fb pfn range: 518 pages freed
1-1 mapping on cf5f5->cf7fb
Freeing cfc1a-cfef4 pfn range: 730 pages freed
1-1 mapping on cfc1a->cfef4
Freeing cff00-100001 pfn range: 196865 pages freed
1-1 mapping on cff00->100001
Released 200651 pages of unused memory
Set 200651 page(s) to 1-1 mapping
Populating 1eeead-21fe78 pfn range: 200651 pages added
e820: BIOS-provided physical RAM map:
Xen: [mem 0x0000000000000000-0x000000000009bfff] usable
Xen: [mem 0x000000000009cc00-0x00000000000fffff] reserved
Xen: [mem 0x0000000000100000-0x00000000cec6dfff] usable
Xen: [mem 0x00000000cec6e000-0x00000000cedf1fff] reserved
Xen: [mem 0x00000000cedf2000-0x00000000cf149fff] ACPI NVS
Xen: [mem 0x00000000cf14a000-0x00000000cf5f3fff] reserved
Xen: [mem 0x00000000cf5f4000-0x00000000cf5f4fff] usable
Xen: [mem 0x00000000cf5f5000-0x00000000cf7fafff] ACPI NVS
Xen: [mem 0x00000000cf7fb000-0x00000000cfc19fff] usable
Xen: [mem 0x00000000cfc1a000-0x00000000cfef3fff] reserved
Xen: [mem 0x00000000cfef4000-0x00000000cfefffff] usable
Xen: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
Xen: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
Xen: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
Xen: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
Xen: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
Xen: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
Xen: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
Xen: [mem 0x00000000fef00000-0x00000000ffffffff] reserved
Xen: [mem 0x0000000100001000-0x000000022effffff] usable
NX (Execute Disable) protection: active
DMI 2.7 present.
DMI: AMD Pike/Pike, BIOS WPK2919N_Weekly_12_09_19 09/17/2012
e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x22f000 max_arch_pfn = 0x400000000
e820: last_pfn = 0xcff00 max_arch_pfn = 0x400000000
initial memory mapped: [mem 0x00000000-0x022affff]
Base memory trampoline at [ffff880000096000] 96000 size 24576
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
init_memory_mapping: [mem 0x21fe00000-0x21fe77fff]
 [mem 0x21fe00000-0x21fe77fff] page 4k
init_memory_mapping: [mem 0x21c000000-0x21fdfffff]
 [mem 0x21c000000-0x21fdfffff] page 4k
init_memory_mapping: [mem 0x200000000-0x21bffffff]
 [mem 0x200000000-0x21bffffff] page 4k
init_memory_mapping: [mem 0x00100000-0xcec6dfff]
 [mem 0x00100000-0xcec6dfff] page 4k
init_memory_mapping: [mem 0xcf5f4000-0xcf5f4fff]
 [mem 0xcf5f4000-0xcf5f4fff] page 4k
init_memory_mapping: [mem 0xcf7fb000-0xcfc19fff]
 [mem 0xcf7fb000-0xcfc19fff] page 4k
init_memory_mapping: [mem 0xcfef4000-0xcfefffff]
 [mem 0xcfef4000-0xcfefffff] page 4k
init_memory_mapping: [mem 0x100001000-0x1ffffffff]
 [mem 0x100001000-0x1ffffffff] page 4k
PGD 0 
Oops: 0003 [#1] SMP 
Modules linked in:
CPU 0 
Pid: 0, comm: swapper Not tainted 3.6.0+ #3 AMD Pike/Pike
RIP: e030:[<ffffffff81cd778a>]  [<ffffffff81cd778a>] xen_set_pte_init+0x1/0x9
RSP: e02b:ffffffff81c01ae8  EFLAGS: 00010086
RAX: 80000001913d1063 RBX: ffff88021f63b1c8 RCX: 8000000000000163
RDX: 00000000000001ff RSI: 80000001913d1063 RDI: ffff88021f63b1c8
RBP: ffffffff81c01af8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 000000011b039000
R13: 000000000000003a R14: 000000011b03a000 R15: 000000011b039000
FS:  0000000000000000(0000) GS:ffffffff81cbe000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000001c0b000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
Process swapper (pid: 0, threadinfo ffffffff81c00000, task ffffffff81c13410)
Stack:
 ffffffff81c01af8 ffffffff810330f5 ffffffff81c01b58 ffffffff816aa9f3
 8000000000000163 ffff88021f63c000 0000000200000000 000000011b039000
 ffffffff81c01b38 0000000000000000 000000011b000000 ffff88021f7146c0
Call Trace:
 [<ffffffff810330f5>] ? set_pte+0xb/0xd
 [<ffffffff816aa9f3>] phys_pte_init+0xd4/0x106
 [<ffffffff816aabe0>] phys_pmd_init+0x1bb/0x215
 [<ffffffff816aadf3>] phys_pud_init+0x1b9/0x218
 [<ffffffff816aaeff>] kernel_physical_mapping_init+0xad/0x14a
 [<ffffffff81682a1a>] init_memory_mapping+0x275/0x303
 [<ffffffff81ce6e62>] init_range_memory_mapping+0x8b/0xc8
 [<ffffffff81ce6f91>] init_mem_mapping+0xf2/0x162
 [<ffffffff81cd9d74>] setup_arch+0x682/0xaac
 [<ffffffff816af4ab>] ? printk+0x48/0x4a
 [<ffffffff81cd3868>] start_kernel+0x8e/0x3d8
 [<ffffffff81cd32d3>] x86_64_start_reservations+0xae/0xb2
 [<ffffffff81cd6dbc>] xen_start_kernel+0x63d/0x63f
Code: 00 00 48 c7 c7 f2 a8 aa 81 e8 ee 61 36 ff c7 05 59 10 06 00 01 00 00 00 5d c3 55 48 89 f7 48 89 e5 e8 95 cf 32 ff 31 c0 5d c3 55 <48> 89 37 48 89 e5 5d c3 55 48 89 e5 41 57 41 56 45 31 f6 41 55 
 RSP <ffffffff81c01ae8>
CR2: 0000000000000000
---[ end trace c2b54da46b5614cf ]---

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset="us-ascii"; name="xen.txt"
Content-Disposition: attachment; filename="xen.txt"
Content-Description: xen.txt

 __  __            _  _    _____                    _        _     _      
 \ \/ /___ _ __   | || |  |___ /    _   _ _ __  ___| |_ __ _| |__ | | ___ 
  \  // _ \ '_ \  | || |_   |_ \ __| | | | '_ \/ __| __/ _` | '_ \| |/ _ \
  /  \  __/ | | | |__   _| ___) |__| |_| | | | \__ \ || (_| | |_) | |  __/
 /_/\_\___|_| |_|    |_|(_)____/    \__,_|_| |_|___/\__\__,_|_.__/|_|\___|
                                                                          
(XEN) Xen version 4.3-unstable (jshin@) (gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3) Thu Oct 18 10:52:04 CDT 2012
(XEN) Latest ChangeSet: Mon Oct 15 16:51:44 2012 +0100 26061:c1c549c4fe9e
(XEN) Bootloader: GRUB 1.99-21ubuntu3.4
(XEN) Command line: placeholder noreboot cpuinfo vpmu
(XEN) Video information:
(XEN)  VGA is text mode 80x25, font 8x16
(XEN)  VBE/DDC methods: V2; EDID transfer time: 1 seconds
(XEN) Disc information:
(XEN)  Found 1 MBR signatures
(XEN)  Found 1 EDD information structures
(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009cc00 (usable)
(XEN)  000000000009cc00 - 00000000000a0000 (reserved)
(XEN)  00000000000e0000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 00000000cec6e000 (usable)
(XEN)  00000000cec6e000 - 00000000cedf2000 (reserved)
(XEN)  00000000cedf2000 - 00000000cf14a000 (ACPI NVS)
(XEN)  00000000cf14a000 - 00000000cf5f4000 (reserved)
(XEN)  00000000cf5f4000 - 00000000cf5f5000 (usable)
(XEN)  00000000cf5f5000 - 00000000cf7fb000 (ACPI NVS)
(XEN)  00000000cf7fb000 - 00000000cfc1a000 (usable)
(XEN)  00000000cfc1a000 - 00000000cfef4000 (reserved)
(XEN)  00000000cfef4000 - 00000000cff00000 (usable)
(XEN)  00000000f8000000 - 00000000fc000000 (reserved)
(XEN)  00000000fec00000 - 00000000fec01000 (reserved)
(XEN)  00000000fec10000 - 00000000fec11000 (reserved)
(XEN)  00000000fec20000 - 00000000fec21000 (reserved)
(XEN)  00000000fed00000 - 00000000fed01000 (reserved)
(XEN)  00000000fed61000 - 00000000fed71000 (reserved)
(XEN)  00000000fed80000 - 00000000fed90000 (reserved)
(XEN)  00000000fef00000 - 0000000100000000 (reserved)
(XEN)  0000000100001000 - 000000022f000000 (usable)
(XEN) ACPI: RSDP 000F0490, 0024 (r2 ALASKA)
(XEN) ACPI: XSDT CF133070, 005C (r1 ALASKA    A M I  1072009 AMI     10013)
(XEN) ACPI: FACP CF13EDF0, 010C (r5 ALASKA    A M I  1072009 AMI     10013)
(XEN) ACPI Warning (tbfadt-0232): FADT (revision 5) is longer than ACPI 2.0 version, truncating length 0x10C to 0xF4 [20070126]
(XEN) ACPI Warning (tbfadt-0444): Optional field "Pm2ControlBlock" has zero address or length: 0000000000000000/1 [20070126]
(XEN) ACPI: DSDT CF133160, BC89 (r2 ALASKA    A M I        0 INTL 20051117)
(XEN) ACPI: FACS CF143080, 0040
(XEN) ACPI: APIC CF13EF00, 009E (r3 ALASKA    A M I  1072009 AMI     10013)
(XEN) ACPI: FPDT CF13EFA0, 0044 (r1 ALASKA    A M I  1072009 AMI     10013)
(XEN) ACPI: MCFG CF13EFE8, 003C (r1 ALASKA    A M I  1072009 MSFT    10013)
(XEN) ACPI: HPET CF13F028, 0038 (r1 ALASKA    A M I  1072009 AMI         5)
(XEN) ACPI: SSDT CF13F060, 167C (r1 AMD    POWERNOW        1 AMD         1)
(XEN) ACPI: IVRS CF1406E0, 00D8 (r1  AMD     RD890S   202031 AMD         0)
(XEN) System RAM: 8160MB (8356052kB)
(XEN) No NUMA configuration found
(XEN) Faking a node at 0000000000000000-000000022f000000
(XEN) Domain heap initialised
(XEN) found SMP MP-table at 000fd820
(XEN) DMI 2.7 present.
(XEN) Using APIC driver default
(XEN) ACPI: PM-Timer IO Port: 0x808
(XEN) ACPI: ACPI SLEEP INFO: pm1x_cnt[804,0], pm1x_evt[800,0]
(XEN) ACPI: 32/64X FACS address mismatch in FADT - cf143080/0000000000000000, using 32
(XEN) ACPI:                  wakeup_vec[cf14308c], vec_size[20]
(XEN) ACPI: Local APIC address 0xfee00000
(XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
(XEN) Processor #16 5:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
(XEN) Processor #17 5:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
(XEN) Processor #18 5:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
(XEN) Processor #19 5:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
(XEN) Processor #20 5:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x06] lapic_id[0x15] enabled)
(XEN) Processor #21 5:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] enabled)
(XEN) Processor #22 5:2 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] enabled)
(XEN) Processor #23 5:2 APIC version 16
(XEN) ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
(XEN) ACPI: IOAPIC (id[0x09] address[0xfec00000] gsi_base[0])
(XEN) IOAPIC[0]: apic_id 9, version 33, address 0xfec00000, GSI 0-23
(XEN) ACPI: IOAPIC (id[0x0a] address[0xfec20000] gsi_base[24])
(XEN) IOAPIC[1]: apic_id 10, version 33, address 0xfec20000, GSI 24-55
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
(XEN) ACPI: IRQ0 used by override.
(XEN) ACPI: IRQ2 used by override.
(XEN) ACPI: IRQ9 used by override.
(XEN) Enabling APIC mode:  Flat.  Using 2 I/O APICs
(XEN) ACPI: HPET id: 0x43538210 base: 0xfed00000
(XEN) Table is not found!
(XEN) Using ACPI (MADT) for SMP configuration information
(XEN) SMP: Allowing 8 CPUs (0 hotplug CPUs)
(XEN) IRQ limits: 56 GSI, 1496 MSI/MSI-X
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Initializing CPU#0
(XEN) Detected 3492.408 MHz processor.
(XEN) Initing memory sharing.
(XEN) CPU: L1 I cache 64K (64 bytes/line), D cache 16K (64 bytes/line)
(XEN) CPU: L2 Cache: 2048K (64 bytes/line)
(XEN) CPU 0(8) -> Processor 0, Compute Unit 0
(XEN) xstate_init: using cntxt_size: 0x3c0 and states: 0x4000000000000007
(XEN) AMD Fam15h machine check reporting enabled
(XEN) PCI: MCFG configuration 0: base e0000000 segment 0000 buses 00 - ff
(XEN) PCI: Not using MCFG for segment 0000 bus 00-ff
(XEN) AMD-Vi: IOMMU 0 Enabled.
(XEN) AMD-Vi: Enabling global vector map
(XEN) I/O virtualisation enabled
(XEN)  - Dom0 mode: Relaxed
(XEN) CPU0: AMD Eng Sample, 1D358151W8K54_40/35/22_2/8      stepping 00
(XEN) ENABLING IO-APIC IRQs
(XEN)  -> Using new ACK method
(XEN) ..TIMER: vector=0xF0 apic1=0 pin1=2 apic2=-1 pin2=-1
(XEN) Platform timer is 14.318MHz HPET
(XEN) Allocated console ring of 64 KiB.
(XEN) HVM: ASIDs enabled.
(XEN) SVM: Supported advanced features:
(XEN)  - Nested Page Tables (NPT)
(XEN)  - Last Branch Record (LBR) Virtualisation
(XEN)  - Next-RIP Saved on #VMEXIT
(XEN)  - VMCB Clean Bits
(XEN)  - DecodeAssists
(XEN)  - Pause-Intercept Filter
(XEN)  - TSC Rate MSR
(XEN) HVM: SVM enabled
(XEN) HVM: Hardware Assisted Paging (HAP) detected
(XEN) HVM: HAP page sizes: 4kB, 2MB, 1GB
(XEN) Booting processor 1/17 eip 8c000
(XEN) Initializing CPU#1
(XEN) CPU: L1 I cache 64K (64 bytes/line), D cache 16K (64 bytes/line)
(XEN) CPU: L2 Cache: 2048K (64 bytes/line)
(XEN) CPU 1(8) -> Processor 0, Compute Unit 0
(XEN) CPU1: AMD Eng Sample, 1D358151W8K54_40/35/22_2/8      stepping 00
(XEN) microcode: collect_cpu_info: patch_id=0x600081e
(XEN) Booting processor 2/18 eip 8c000
(XEN) Initializing CPU#2
(XEN) CPU: L1 I cache 64K (64 bytes/line), D cache 16K (64 bytes/line)
(XEN) CPU: L2 Cache: 2048K (64 bytes/line)
(XEN) CPU 2(8) -> Processor 0, Compute Unit 1
(XEN) CPU2: AMD Eng Sample, 1D358151W8K54_40/35/22_2/8      stepping 00
(XEN) microcode: collect_cpu_info: patch_id=0x600081e
(XEN) Booting processor 3/19 eip 8c000
(XEN) Initializing CPU#3
(XEN) CPU: L1 I cache 64K (64 bytes/line), D cache 16K (64 bytes/line)
(XEN) CPU: L2 Cache: 2048K (64 bytes/line)
(XEN) CPU 3(8) -> Processor 0, Compute Unit 1
(XEN) CPU3: AMD Eng Sample, 1D358151W8K54_40/35/22_2/8      stepping 00
(XEN) microcode: collect_cpu_info: patch_id=0x600081e
(XEN) Booting processor 4/20 eip 8c000
(XEN) Initializing CPU#4
(XEN) CPU: L1 I cache 64K (64 bytes/line), D cache 16K (64 bytes/line)
(XEN) CPU: L2 Cache: 2048K (64 bytes/line)
(XEN) CPU 4(8) -> Processor 0, Compute Unit 2
(XEN) CPU4: AMD Eng Sample, 1D358151W8K54_40/35/22_2/8      stepping 00
(XEN) microcode: collect_cpu_info: patch_id=0x600081e
(XEN) Booting processor 5/21 eip 8c000
(XEN) Initializing CPU#5
(XEN) CPU: L1 I cache 64K (64 bytes/line), D cache 16K (64 bytes/line)
(XEN) CPU: L2 Cache: 2048K (64 bytes/line)
(XEN) CPU 5(8) -> Processor 0, Compute Unit 2
(XEN) CPU5: AMD Eng Sample, 1D358151W8K54_40/35/22_2/8      stepping 00
(XEN) microcode: collect_cpu_info: patch_id=0x600081e
(XEN) Booting processor 6/22 eip 8c000
(XEN) Initializing CPU#6
(XEN) CPU: L1 I cache 64K (64 bytes/line), D cache 16K (64 bytes/line)
(XEN) CPU: L2 Cache: 2048K (64 bytes/line)
(XEN) CPU 6(8) -> Processor 0, Compute Unit 3
(XEN) CPU6: AMD Eng Sample, 1D358151W8K54_40/35/22_2/8      stepping 00
(XEN) microcode: collect_cpu_info: patch_id=0x600081e
(XEN) Booting processor 7/23 eip 8c000
(XEN) Initializing CPU#7
(XEN) CPU: L1 I cache 64K (64 bytes/line), D cache 16K (64 bytes/line)
(XEN) CPU: L2 Cache: 2048K (64 bytes/line)
(XEN) CPU 7(8) -> Processor 0, Compute Unit 3
(XEN) CPU7: AMD Eng Sample, 1D358151W8K54_40/35/22_2/8      stepping 00
(XEN) Brought up 8 CPUs
(XEN) microcode: collect_cpu_info: patch_id=0x600081e
(XEN) ACPI sleep modes: S3
(XEN) MCA: Use hw thresholding to adjust polling frequency
(XEN) mcheck_poll: Machine check polling timer started.
(XEN) *** LOADING DOMAIN 0 ***
(XEN) elf_parse_binary: phdr: paddr=0x1000000 memsz=0xb9d000
(XEN) elf_parse_binary: phdr: paddr=0x1c00000 memsz=0xbd0e8
(XEN) elf_parse_binary: phdr: paddr=0x1cbe000 memsz=0x14100
(XEN) elf_parse_binary: phdr: paddr=0x1cd3000 memsz=0x5dd000
(XEN) elf_parse_binary: memory: 0x1000000 -> 0x22b0000
(XEN) elf_xen_parse_note: GUEST_OS = "linux"
(XEN) elf_xen_parse_note: GUEST_VERSION = "2.6"
(XEN) elf_xen_parse_note: XEN_VERSION = "xen-3.0"
(XEN) elf_xen_parse_note: VIRT_BASE = 0xffffffff80000000
(XEN) elf_xen_parse_note: ENTRY = 0xffffffff81cd3210
(XEN) elf_xen_parse_note: HYPERCALL_PAGE = 0xffffffff81001000
(XEN) elf_xen_parse_note: FEATURES = "!writable_page_tables|pae_pgdir_above_4gb"
(XEN) elf_xen_parse_note: PAE_MODE = "yes"
(XEN) elf_xen_parse_note: LOADER = "generic"
(XEN) elf_xen_parse_note: unknown xen elf note (0xd)
(XEN) elf_xen_parse_note: SUSPEND_CANCEL = 0x1
(XEN) elf_xen_parse_note: HV_START_LOW = 0xffff800000000000
(XEN) elf_xen_parse_note: PADDR_OFFSET = 0x0
(XEN) elf_xen_addr_calc_check: addresses:
(XEN)     virt_base        = 0xffffffff80000000
(XEN)     elf_paddr_offset = 0x0
(XEN)     virt_offset      = 0xffffffff80000000
(XEN)     virt_kstart      = 0xffffffff81000000
(XEN)     virt_kend        = 0xffffffff822b0000
(XEN)     virt_entry       = 0xffffffff81cd3210
(XEN)     p2m_base         = 0xffffffffffffffff
(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x22b0000
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   0000000220000000->0000000224000000 (2010797 pages to be allocated)
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: ffffffff81000000->ffffffff822b0000
(XEN)  Init. ramdisk: ffffffff822b0000->ffffffff822b0000
(XEN)  Phys-Mach map: ffffffff822b0000->ffffffff83227568
(XEN)  Start info:    ffffffff83228000->ffffffff832284b4
(XEN)  Page tables:   ffffffff83229000->ffffffff83246000
(XEN)  Boot stack:    ffffffff83246000->ffffffff83247000
(XEN)  TOTAL:         ffffffff80000000->ffffffff83400000
(XEN)  ENTRY ADDRESS: ffffffff81cd3210
(XEN) Dom0 has maximum 8 VCPUs
(XEN) elf_load_binary: phdr 0 at 0xffffffff81000000 -> 0xffffffff81b9d000
(XEN) elf_load_binary: phdr 1 at 0xffffffff81c00000 -> 0xffffffff81cbd0e8
(XEN) elf_load_binary: phdr 2 at 0xffffffff81cbe000 -> 0xffffffff81cd2100
(XEN) elf_load_binary: phdr 3 at 0xffffffff81cd3000 -> 0xffffffff81d71000
(XEN) Scrubbing Free RAM: .done.
(XEN) Initial low memory virq threshold set at 0x4000 pages.
(XEN) Std. Loglevel: All
(XEN) Guest Loglevel: All
(XEN) Xen is relinquishing VGA console.
(XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch input to Xen)
(XEN) Freed 244kB init memory.
(XEN) Domain 0 crashed: 'noreboot' set - not rebooting.

--82I3+IH0IqGh5yIs--
