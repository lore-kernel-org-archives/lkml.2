Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828Ab2B2GPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:15:11 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:37580 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab2B2GPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:15:09 -0500
Date: Wed, 29 Feb 2012 08:15:06 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: sam@ravnborg.org, tj@kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120228.175659.40937269571989661.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1202290814280.23308@math.ut.ee>
References: <20120227.163044.2168482307021109001.davem@davemloft.net> <20120228.161023.117381282430807415.davem@davemloft.net> <alpine.SOC.1.00.1202282333580.3974@math.ut.ee> <20120228.175659.40937269571989661.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Tried it, no obvious results in dmesg, except the crash is in a slightly 
> > different location.
> 
> Interesting, the corruption is a little bit different this time, yet similar
> to the ones we saw previously:
> 
> > [    0.000000] TPC: <strcmp+0x8/0x60>
>  ...
> > [    0.000000] i0: 000000007fcf3c80 i1: fffff8007fcec480 i2: 0000000001010101 i3: 0000000080808080
> > [    0.000000] i4: fffff8007fcb8ccd i5: 0000000000028337 i6: 0000000000763231 i7: 0000000000606250
> 
> This is strcmp(0x000000007fcf3c80, 0xfffff8007fcec480), the first arg is
> a bad pointer, somehow the top virtual address bits have been zero'd out.
> 
> It comes from dp->full_name, so something walked all over the beginning
> of a device_node object.
> 
> Let's see if we can figure out anything else about the nature of the
> corruption, please add this patch on top.

Here it is - triggers this time:

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.2.0-rc3-00076-g7bd0b0f-dirty (mroos@korvits) (gcc version 4.6.2 (Debian 4.6.2-14) ) #85 SMP Wed Feb 29 08:06:38 EET 2012
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:b6:ee:e2
[    0.000000] Kernel: Using 4 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF BUG: Bogus full_name pointer [0000000000730e08]
[    0.000000] OF BUG: np[fffff8007fcf3f40] np->name[fffff8007fcf3ec0] np->type[0000000000756bf8] np->phandle[0xf0029c88]
[    0.000000] OF BUG: np->name(SUNW,Ultra-Enterprise) np->type(<NULL>)
[    0.000000] OF BUG: Bogus full_name pointer [0000000000730e08]
[    0.000000] OF BUG: np[fffff8007fcf3f40] np->name[fffff8007fcf3ec0] np->type[0000000000756bf8] np->phandle[0xf0029c88]
[    0.000000] OF BUG: np->name(SUNW,Ultra-Enterprise) np->type(<NULL>)
[    0.000000] OF BUG: Bogus full_name pointer [0000000000730e08]
[    0.000000] OF BUG: np[fffff8007fcf3f40] np->name[fffff8007fcf3ec0] np->type[0000000000756bf8] np->phandle[0xf0029c88]
[    0.000000] OF BUG: np->name(SUNW,Ultra-Enterprise) np->type(<NULL>)
[    0.000000] OF BUG: Bogus full_name pointer [000000007fcf3c80]
[    0.000000] OF BUG: np[fffff8007fceacc0] np->name[          (null)] np->type[          (null)] np->phandle[0x00000001]
[    0.000000] OF BUG: np->name((null)) np->type((null))
[    0.000000] Unable to handle kernel paging request at virtual address 000000007fcf2000
[    0.000000] tsk->{mm,active_mm}->context = 0000000000000000
[    0.000000] tsk->{mm,active_mm}->pgd = fffff800007db7d0
[    0.000000]               \|/ ____ \|/
[    0.000000]               "@'/ .. \`@"
[    0.000000]               /_| \__/ |_\
[    0.000000]                  \__U_/
[    0.000000] swapper(0): Oops [#1]
[    0.000000] TSTATE: 0000004480e01600 TPC: 000000000057b4c8 TNPC: 000000000057b4cc Y: 00000037    Not tainted
[    0.000000] TPC: <strcmp+0x8/0x60>
[    0.000000] g0: 000000000077f7f0 g1: 0000000000000000 g2: 0000000000000000 g3: 0000000000787950
[    0.000000] g4: 000000000077f350 g5: 0000000000000000 g6: 0000000000760000 g7: 0000000000000040
[    0.000000] o0: 000000000000003f o1: 0000000000763930 o2: 0000000000000003 o3: 00000000007879e4
[    0.000000] o4: 000000000080ee45 o5: 000000000080ee1b sp: 0000000000763181 ret_pc: 000000000069cad0
[    0.000000] RPC: <printk+0x24/0x38>
[    0.000000] l0: 0000000001028000 l1: fffff8007fcbc380 l2: 8000000000000000 l3: 0800000000000000
[    0.000000] l4: 0000000000000080 l5: 0000000000000002 l6: 0000000000000000 l7: 0020280000000000
[    0.000000] i0: 000000007fcf3c80 i1: fffff8007fcec480 i2: 0000000000000000 i3: 0000000000000000
[    0.000000] i4: 0000000000000001 i5: 0000000000028337 i6: 0000000000763231 i7: 0000000000606278
[    0.000000] I7: <of_find_node_by_path+0x58/0xe0>
[    0.000000] Call Trace:
[    0.000000]  [0000000000606278] of_find_node_by_path+0x58/0xe0
[    0.000000]  [0000000000606e6c] of_alias_scan+0xcc/0x1c0
[    0.000000]  [00000000007c328c] of_pdt_build_devicetree+0x90/0xa0
[    0.000000]  [00000000007b0680] prom_build_devicetree+0x10/0x3c
[    0.000000]  [00000000007b4614] paging_init+0x59c/0x6bc
[    0.000000]  [00000000007afffc] setup_arch+0xf8/0x110
[    0.000000]  [00000000007ae514] start_kernel+0x84/0x32c
[    0.000000]  [0000000000691928] tlb_fixup_done+0xa0/0xa8
[    0.000000]  [0000000000000000]           (null)
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Caller[0000000000606278]: of_find_node_by_path+0x58/0xe0
[    0.000000] Caller[0000000000606e6c]: of_alias_scan+0xcc/0x1c0
[    0.000000] Caller[00000000007c328c]: of_pdt_build_devicetree+0x90/0xa0
[    0.000000] Caller[00000000007b0680]: prom_build_devicetree+0x10/0x3c
[    0.000000] Caller[00000000007b4614]: paging_init+0x59c/0x6bc
[    0.000000] Caller[00000000007afffc]: setup_arch+0xf8/0x110
[    0.000000] Caller[00000000007ae514]: start_kernel+0x84/0x32c
[    0.000000] Caller[0000000000691928]: tlb_fixup_done+0xa0/0xa8
[    0.000000] Caller[0000000000000000]:           (null)
[    0.000000] Instruction DUMP: 01000000  9de3bf50  82102000 <c40e0001> c60e4001  80a08003  12400008  82006001  80a0a000 
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] Call Trace:
[    0.000000]  [000000000069c85c] panic+0x68/0x1e4
[    0.000000]  [0000000000461a30] do_exit+0x230/0x2c0
[    0.000000]  [00000000004292c0] die_if_kernel+0x180/0x260
[    0.000000]  [000000000069c284] unhandled_fault+0x8c/0x98
[    0.000000]  [0000000000445778] do_kernel_fault+0xd8/0x100
[    0.000000]  [000000000044584c] do_sparc64_fault+0xac/0x540
[    0.000000]  [0000000000407948] sparc64_realfault_common+0x10/0x20
[    0.000000]  [000000000057b4c8] strcmp+0x8/0x60
[    0.000000]  [0000000000606278] of_find_node_by_path+0x58/0xe0
[    0.000000]  [0000000000606e6c] of_alias_scan+0xcc/0x1c0
[    0.000000]  [00000000007c328c] of_pdt_build_devicetree+0x90/0xa0
[    0.000000]  [00000000007b0680] prom_build_devicetree+0x10/0x3c
[    0.000000]  [00000000007b4614] paging_init+0x59c/0x6bc
[    0.000000]  [00000000007afffc] setup_arch+0xf8/0x110
[    0.000000]  [00000000007ae514] start_kernel+0x84/0x32c
[    0.000000]  [0000000000691928] tlb_fixup_done+0xa0/0xa8
[    0.000000] Press Stop-A (L1-A) to return to the boot prom

-- 
Meelis Roos (mroos@linux.ee)
