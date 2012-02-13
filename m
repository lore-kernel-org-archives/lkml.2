Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2BMIGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 03:06:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59762 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2BMIGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 03:06:21 -0500
Date: Mon, 13 Feb 2012 01:06:18 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Meelis Roos <mroos@linux.ee>
Cc: Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120213080618.GA11077@ponder.secretlab.ca>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 09:45:40AM +0200, Meelis Roos wrote:
> (Resend with proper To-s for OF people)
> 
> This is my first post-3.2 test on 2-CPU Sun Enterprise 3500 (PCI+SBus 
> IO). prtconf is also below. Something OF-related seems to be happening 
> here.
> 
> [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
> [    0.000000] PROMLIB: Root node compatible:
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.3.0-rc3-00188-g3ec1e88 (mroos@korvits) (gcc version 4.6.2 (Debian 4.6.2-14) ) #64 SMP Sun Feb 12 22:26:40 EET 2012
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] bootconsole [earlyprom0] enabled
> [    0.000000] ARCH: SUN4U
> [    0.000000] Ethernet address: 08:00:20:b6:ee:e2
> [    0.000000] Kernel: Using 4 locked TLB entries for main kernel image.
> [    0.000000] Remapping the kernel... done.
> [    0.000000] Unable to handle kernel NULL pointer dereference
> [    0.000000] tsk->{mm,active_mm}->context = 0000000000000000
> [    0.000000] tsk->{mm,active_mm}->pgd = fffff800008c77d0
> [    0.000000]               \|/ ____ \|/
> [    0.000000]               "@'/ .. \`@"
> [    0.000000]               /_| \__/ |_\
> [    0.000000]                  \__U_/
> [    0.000000] swapper(0): Oops [#1]
> [    0.000000] TSTATE: 0000000080e01607 TPC: 00000000006459a0 TNPC: 0000000000645964 Y: 00000037    Not tainted
> [    0.000000] TPC: <of_find_node_by_path+0x60/0x80>
> [    0.000000] g0: 0000000000000000 g1: 0000000000000001 g2: 00000000000000ff g3: 00000000000000f0
> [    0.000000] g4: 0000000000853fd0 g5: 0000000000000000 g6: 0000000000834000 g7: 0000000000000050
> [    0.000000] o0: 0000000000000001 o1: fffff8007fced7c0 o2: 0000000001010101 o3: 0000000080808080
> [    0.000000] o4: fffff8007fcc0a4d o5: 00000000000199b5 sp: 0000000000837231 ret_pc: 0000000000645970
> [    0.000000] RPC: <of_find_node_by_path+0x30/0x80>
> [    0.000000] l0: 00000000008ab400 l1: fffff8007fcc1f40 l2: 000000000085c5ec l3: 0000000000000025
> [    0.000000] l4: 00000000005c0400 l5: 00000000008fa5e6 l6: 0000000000000006 l7: 0028280000000000
> [    0.000000] i0: fffff8007fced7c0 i1: 0000000000808fd8 i2: 0000000001010101 i3: 0000000080808080
> [    0.000000] i4: 0000000000876c00 i5: 0000000000000050 i6: 00000000008372e1 i7: 000000000064684c
> [    0.000000] I7: <of_alias_scan+0xcc/0x1c0>
> [    0.000000] Call Trace:
> [    0.000000]  [000000000064684c] of_alias_scan+0xcc/0x1c0
> [    0.000000]  [00000000008a0350] of_pdt_build_devicetree+0x90/0xa0
> [    0.000000]  [000000000088c540] prom_build_devicetree+0x10/0x3c
> [    0.000000]  [00000000008904d4] paging_init+0x59c/0x6bc
> [    0.000000]  [000000000088bebc] setup_arch+0xf8/0x110
> [    0.000000]  [000000000088a51c] start_kernel+0x8c/0x34c

Try the following patch.  I suspect the new of_alias_scan() isn't careful
enough about which properties it dereferences:

---

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 133908a..9188caa 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1174,6 +1174,10 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 		    !strcmp(pp->name, "linux,phandle"))
 			continue;
 
+		/* Check for null value or non-strings (no null termination) */
+		if (!pp->value || strnlen(pp->value, pp->length) == pp->length)
+			continue;
+
 		np = of_find_node_by_path(pp->value);
 		if (!np)
 			continue;

