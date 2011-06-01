Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1FAPl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:41:58 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54229 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751638Ab1FAPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:41:56 -0400
Date: Wed, 1 Jun 2011 17:41:54 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com
Subject: zaurus 3.0-rc1 Oops (fail GFP_DMA allocations when ZONE_DMA is not
	configured)
Message-ID: <20110601154154.GB26197@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!
The 3.0-rc1 no longer boots on spitz see the attached Oops.

The bisecting pointed to this commit, reverting it machine boots again.

commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac
Author: David Rientjes <rientjes@google.com>
Date:   Tue May 24 17:12:35 2011 -0700

    mm: fail GFP_DMA allocations when ZONE_DMA is not configured
    
    The page allocator will improperly return a page from ZONE_NORMAL even
    when __GFP_DMA is passed if CONFIG_ZONE_DMA is disabled.  The caller
    expects DMA memory, perhaps for ISA devices with 16-bit address registers,
    and may get higher memory resulting in undefined behavior.
    
    This patch causes the page allocator to return NULL in such circumstances
    with a warning emitted to the kernel log on the first occurrence.
    
    Signed-off-by: David Rientjes <rientjes@google.com>
    Cc: Mel Gorman <mel@csn.ul.ie>
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Rik van Riel <riel@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 01e6b61..10a8c6d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2247,6 +2247,10 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 
        if (should_fail_alloc_page(gfp_mask, order))
                return NULL;
+#ifndef CONFIG_ZONE_DMA
+       if (WARN_ON_ONCE(gfp_mask & __GFP_DMA))
+               return NULL;
+#endif
 
        /*
         * Check the zones suitable for the gfp_mask contain at least one

-- 
metan

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="oops.txt"

pcmcia_socket pcmcia_socket1: pccard: PCMCIA card inserted into slot 1
pcmcia 1.0: pcmcia: registering new device pcmcia1.0 (IRQ: 202)
mmc0: new SD card at address 0002
scsi0 : pata_pcmcia
ata1: PATA max PIO0 cmd 0xc4840000 ctl 0xc484000e irq 202
mmcblk0: mmc0:0002 00000 1.90 GiB
 mmcblk0: p1
ata1.00: CFA: LEXAR ATA FLASH, 20051220, max MWDMA4
ata1.00: 16128000 sectors, multi 0: LBA
ata1.00: configured for PIO0
scsi 0:0:0:0: Direct-Access     ATA      LEXAR ATA FLASH  2005 PQ: 0 ANSI: 5
------------[ cut here ]------------
WARNING: at mm/page_alloc.c:2251 __alloc_pages_nodemask+0x90/0x5a0()
Modules linked in:
---[ end trace a76f77d0364258f5 ]---
sd 0:0:0:0: [sda] READ CAPACITY(16) failed
sd 0:0:0:0: [sda]  Result: hostbyte=0x00 driverbyte=0x04
sd 0:0:0:0: [sda] Sense not available.
sd 0:0:0:0: [sda] READ CAPACITY failed
sd 0:0:0:0: [sda]  Result: hostbyte=0x00 driverbyte=0x04
sd 0:0:0:0: [sda] Sense not available.
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Asking for cache data failed
sd 0:0:0:0: [sda] Assuming drive cache: write through
wm8750-codec 0-001b: asoc: failed to add kcontrol Differential Mux
sd 0:0:0:0: [sda] READ CAPACITY(16) failed
sd 0:0:0:0: [sda]  Result: hostbyte=0x00 driverbyte=0x04
wm8750-codec 0-001b: asoc: failed to add kcontrol Out3 Mux
sd 0:0:0:0: [sda] Sense not available.
wm8750-codec 0-001b: asoc: failed to add kcontrol Right Line Mux
sd 0:0:0:0: [sda] READ CAPACITY failed
sd 0:0:0:0: [sda]
wm8750-codec 0-001b: asoc: failed to add kcontrol Left Line Mux
Result: hostbyte=0x00 driverbyte=0x04
sd 0:0:0:0: [sda] Sense not available.
wm8750-codec 0-001b: asoc: failed to add kcontrol Right PGA Mux
sd 0:0:0:0: [sda] Asking for cache data failed
wm8750-codec 0-001b: asoc: failed to add kcontrol Left PGA Mux
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI removable disk
asoc: wm8750-hifi <-> pxa2xx-i2s mapping ok
ALSA device list:
  #0: Spitz
TCP cubic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
XScale iWMMXt coprocessor detected.
pxa-rtc pxa-rtc: setting system clock to 2011-06-01 10:31:14 UTC (1306924274)
Waiting 1sec before mounting root device...
Unable to handle kernel NULL pointer dereference at virtual address 000001d4
pgd = c0004000
[000001d4] *pgd=00000000
Internal error: Oops: f5 [#1] PREEMPT
Modules linked in:
CPU: 0    Tainted: G        W    (3.0.0-rc1 #16)
PC is at blkdev_get+0x31c/0x3bc
LR is at blkdev_get+0x2f4/0x3bc
pc : [<c00ccdac>]    lr : [<c00ccd84>]    psr: 60000013
sp : c3831e30  ip : 9e370001  fp : c3831e44
r10: c34041b0  r9 : 00000000  r8 : 00000083
r7 : c03298b0  r6 : fffffffa  r5 : c34041a0  r4 : c3404340
r3 : 00000000  r2 : 00000000  r1 : c3404364  r0 : c03ca188
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0000397f  Table: a0004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc3830278)
Stack: (0xc3831e30 to 0xc3832000)
1e20:                                     c34041a0 c3404364 c3831e44 00000000
1e40: c3831ecc 00800001 00000000 00000001 c3831e68 c34041a0 00000083 c03298b0
1e60: 00008000 c03298b0 c38ff820 00000000 00000000 c00ccf2c c380f6e0 00000083
1e80: 00008000 c00a1aac ffffff9c c38147b8 00000000 c0341da8 c034246c 0000000a
1ea0: c38ff840 000000d0 c380f750 c380f6e0 c03298b0 c03298b0 00008000 00000000
1ec0: 00000000 c00f4414 c00f53e8 00008000 c38ff840 c00a0684 c03298b0 00008000
1ee0: c380f6e0 c03298b0 c38ff840 c00baa34 c03298b0 c38ff820 00000000 c38ff840
1f00: 00008000 c00baab0 00000000 00000020 c38ff840 00008000 00008000 c00bb214
1f20: 0000000a c00827f4 00000000 0000000a c380f0a0 c3407100 c3826000 c02dd6bb
1f40: 00000000 00008000 c02dd6bb 00000000 00000000 c00bb300 00000000 c02e7875
1f60: c02e7a04 00000000 c38ff840 c38ff820 00008000 c3823000 c3823000 00008000
1f80: c001cd7c c0008bb4 00000000 00000000 00000000 c0055f60 00000080 c0345d0c
1fa0: c0023870 c3823000 c004187c c02dd6bb 00800001 c0336b60 c001cd91 c0023870
1fc0: 00000013 00000000 00000000 c0008ee4 fffffffe 00002710 ffffff9c c0336b00
1fe0: c001c564 c0008400 00000000 c0008300 c0023870 c0023870 00000000 00000000
Code: e5933000 e3130002 0a000000 eb0677da (e59931d4)
---[ end trace a76f77d0364258f7 ]---
Kernel panic - not syncing: Attempted to kill init!

--SUOF0GtieIMvvwua--
