Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab2BMJUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:20:42 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:33922 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab2BMJUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:20:39 -0500
Date: Mon, 13 Feb 2012 11:20:36 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120213080618.GA11077@ponder.secretlab.ca>
Message-ID: <alpine.SOC.1.00.1202131119040.1488@math.ut.ee>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Try the following patch.  I suspect the new of_alias_scan() isn't careful
> enough about which properties it dereferences:
> 
> ---
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 133908a..9188caa 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1174,6 +1174,10 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  		    !strcmp(pp->name, "linux,phandle"))
>  			continue;
>  
> +		/* Check for null value or non-strings (no null termination) */
> +		if (!pp->value || strnlen(pp->value, pp->length) == pp->length)
> +			continue;
> +
>  		np = of_find_node_by_path(pp->value);
>  		if (!np)
>  			continue;
> 

Yes, it probably gets past this problem but oopses in a different place:

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-rc3-00188-g3ec1e88-dirty (mroos@korvits) (gcc version 4.6.2 (Debian 42
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:b6:ee:e2
[    0.000000] Kernel: Using 4 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] Unable to handle kernel NULL pointer dereference
[    0.000000] tsk->{mm,active_mm}->context = 0000000000000000
[    0.000000] tsk->{mm,active_mm}->pgd = fffff800008c77d0
[    0.000000]               \|/ ____ \|/
[    0.000000]               "@'/ .. \`@"
[    0.000000]               /_| \__/ |_\
[    0.000000]                  \__U_/
[    0.000000] swapper(0): Oops [#1]
[    0.000000] TSTATE: 0000000080e01606 TPC: 0000000000645810 TNPC: 0000000000645814 Y: 00000037    Not d
[    0.000000] TPC: <of_find_node_by_phandle+0x30/0x60>
[    0.000000] g0: 0000000000837b88 g1: 00000000fffff800 g2: 0000000000000000 g3: 0000000000000002
[    0.000000] g4: 0000000000853fd0 g5: 0000000000000000 g6: 0000000000834000 g7: 0000000000000050
[    0.000000] o0: 0000000000876cf0 o1: fffff8007fcc0900 o2: 0000000001010101 o3: 0000000080808080
[    0.000000] o4: 000000000000000e o5: 000000000086c000 sp: 0000000000837301 ret_pc: 00000000006457e8
[    0.000000] RPC: <of_find_node_by_phandle+0x8/0x60>
[    0.000000] l0: 0000000000808fd8 l1: 0000000000876d28 l2: 000000000072a800 l3: 0000000000000080
[    0.000000] l4: 0000000000000013 l5: 0000000000000013 l6: 0000000000000000 l7: 0000000000000281
[    0.000000] i0: 00000000f005de3c i1: ffffffffffdc1428 i2: 0000000000000100 i3: 0000000000000004
[    0.000000] i4: 0000000000000050 i5: 0000000000876c00 i6: 00000000008373b1 i7: 000000000088cd10
[    0.000000] I7: <of_console_init+0xa4/0x144>
[    0.000000] Call Trace:
[    0.000000]  [000000000088cd10] of_console_init+0xa4/0x144
[    0.000000]  [000000000088c548] prom_build_devicetree+0x18/0x3c
[    0.000000]  [00000000008904d4] paging_init+0x59c/0x6bc
[    0.000000]  [000000000088bebc] setup_arch+0xf8/0x110
[    0.000000]  [000000000088a51c] start_kernel+0x8c/0x34c
[    0.000000]  [00000000006fbf28] tlb_fixup_done+0xa0/0xa8
[    0.000000]  [0000000000000000]           (null)
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Caller[000000000088cd10]: of_console_init+0xa4/0x144
[    0.000000] Caller[000000000088c548]: prom_build_devicetree+0x18/0x3c
[    0.000000] Caller[00000000008904d4]: paging_init+0x59c/0x6bc
[    0.000000] Caller[000000000088bebc]: setup_arch+0xf8/0x110
[    0.000000] Caller[000000000088a51c]: start_kernel+0x8c/0x34c
[    0.000000] Caller[00000000006fbf28]: tlb_fixup_done+0xa0/0xa8
[    0.000000] Caller[0000000000000000]:           (null)
[    0.000000] Instruction DUMP: 901760f0  02c70007  901760f0 <c2072010> 80a04018  324ffffc  f85f2050  9 
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] Press Stop-A (L1-A) to return to the boot prom

-- 
Meelis Roos (mroos@linux.ee)
