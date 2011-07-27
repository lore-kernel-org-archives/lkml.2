Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1G0QbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:31:05 -0400
Received: from mail0.scram.de ([78.47.204.202]:39428 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab1G0QbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:31:03 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jul 2011 12:31:03 EDT
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -3.107
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
Message-ID: <4E303AA3.3090507@scram.de>
Date: Wed, 27 Jul 2011 18:19:47 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        linux-kernel@vger.kernel.org
Subject: BUG: Unaligned kernel access on ssb_sprom->il0mac causes kernel Oops
 on bcm47xx
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting a current OpenWRT version on a modified MN-700 router fails.
Using a JTAG adapter, I was able to retrieve the Oops below from the 
routers memory. The culprit code that triggers an unaligned access is in 
drivers/ssb/pci.h, sprom_extract_r123:

for (i = 0; i < 3; i++) {
                 v = in[SPOFF(loc[0]) + i];
                 *(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
         }

out->il0mac is misaligned as struct ssb_sprom is defined as:

struct ssb_sprom {
         u8 revision;
         u8 il0mac[6];           /* MAC address for 802.11b/g */
	[...]
}

It looks like there might be an HW interrupt while the kernel is in the 
misalignment handler. The problem immediately disappears if il0mac[6] is 
properly aligned.

Thanks,
Jochen

# ksymoops -m System.map -t none < Z
ksymoops 2.4.11 on sparc64 2.6.32-5-sparc64.  Options used
      -V (default)
      -k /proc/ksyms (default)
      -l /proc/modules (default)
      -o /lib/modules/2.6.32-5-sparc64/ (default)
      -m System.map (specified)
      -t none

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
<1>CPU 0 Unable to handle kernel paging request at virtual address 
00000008, epc == 8003ad68, ra == 8003ad38
<4>Cpu 0
<4>$ 0   : 00000000 10000000 00000000 00000013
<4>$ 4   : 0000801b 8081dd00 00000000 38850080
<4>$ 8   : 8081b96c 00000001 38850080 0000801b
<4>$12   : 000003ff 8022f8d0 00000001 8022f8c8
<4>$16   : 8081dc40 80818888 8081dd18 80270000
<4>$20   : 00000000 00000001 802c0000 00000001
<4>$24   : 00000000 80016560
<4>$28   : 8081a000 8081b958 80270000 8003ad38
<4>Hi    : 000005df
<4>Lo    : 000568e6
<4>epc   : 8003ad68 0x8003ad68
Using defaults from ksymoops -a sparc
<4>Status: 10000002    KERNEL EXL
<4>Cause : 00800008
<4>        00000000 00000001 38850080 0000801b 80270000 8002822c 
00000000 1c5fe1a8
<4>        802c0000 80270000 8081baa0 00000000 802c0000 80047aa8 
80273520 1b6c36ca
<4>        003d0000 802757b0 802be1e0 00000001 1c5fe1a8 00000000 
00000000 80275bb4
<4>        00000007 00000000 8081bc40 8000c730 00000001 00000000 
8081b9f0 8081b9f0
<4>Call Trace:[<80016590>] 0x80016590
<4>[<800281d4>] 0x800281d4
<4>[<8002822c>] 0x8002822c
<4>[<80047aa8>] 0x80047aa8
<4>[<8000c730>] 0x8000c730
<4>[<800500a8>] 0x800500a8
<4>[<801805cc>] 0x801805cc
<4>[<80052e80>] 0x80052e80
<4>[<801805cc>] 0x801805cc
<4>[<8004fa0c>] 0x8004fa0c
<4>[<8011ac18>] 0x8011ac18
<4>[<80006dd0>] 0x80006dd0
<4>[<800022a0>] 0x800022a0
<4>[<800051a4>] 0x800051a4
<4>[<800226c0>] 0x800226c0
<4>[<801805cc>] 0x801805cc
<4>[<801805cc>] 0x801805cc
<4>[<80228068>] 0x80228068
<4>[<8000c314>] 0x8000c314
<4>[<80180bf0>] 0x80180bf0
<4>[<80005ab4>] 0x80005ab4
<4>[<8001cd44>] 0x8001cd44
<4>[<801805cc>] 0x801805cc
<4>[<80228068>] 0x80228068
<4>[<80180bf0>] 0x80180bf0
<4>[<8017f6ec>] 0x8017f6ec
<4>[<801805cc>] 0x801805cc
<4>[<8017d918>] 0x8017d918
<4>Code: 27a80014  50600014  8c520008 <8c450008> 02a5282b  50a00003 
8c450004  0800eb6d  8c520008
Error (Oops_bfd_perror): /tmp/ksymoops.FY6Yx3 Invalid bfd target


 >>RA;  8003ad38 <run_posix_cpu_timers+3a8/808>
 >>$13; 8022f8d0 <degrade_factor+0/28>
 >>$15; 8022f8c8 <degrade_zero_ticks+0/8>
 >>$19; 80270000 <__nosave_begin+0/0>
 >>$22; 802c0000 <futex_queues+690/800>
 >>$25; 80016560 <task_tick_fair+0/140>
 >>$30; 80270000 <__nosave_begin+0/0>
 >>$31; 8003ad38 <run_posix_cpu_timers+3a8/808>

 >>???; 8003ad68 <run_posix_cpu_timers+3d8/808>   <=====

Trace; 80016590 <task_tick_fair+30/140>
Trace; 800281d4 <run_local_timers+10/20>
Trace; 8002822c <update_process_times+48/60>
Trace; 80047aa8 <tick_nohz_handler+ac/124>
Trace; 8000c730 <c0_compare_interrupt+74/98>
Trace; 800500a8 <handle_irq_event_percpu+5c/2b4>
Trace; 801805cc <ssb_pci_get_invariants+0/698>
Trace; 80052e80 <handle_percpu_irq+58/8c>
Trace; 801805cc <ssb_pci_get_invariants+0/698>
Trace; 8004fa0c <generic_handle_irq+3c/4c>
Trace; 8011ac18 <number.clone.6+1b8/360>
Trace; 80006dd0 <do_IRQ+1c/2c>
Trace; 800022a0 <plat_irq_dispatch+40/c0>
Trace; 800051a4 <ret_from_irq+0/4>
Trace; 800226c0 <__do_softirq+100/18c>
Trace; 801805cc <ssb_pci_get_invariants+0/698>
Trace; 801805cc <ssb_pci_get_invariants+0/698>
Trace; 80228068 <ssb_pcihost_probe+0/118>
Trace; 8000c314 <do_ade+264/380>
Trace; 80180bf0 <ssb_pci_get_invariants+624/698>
Trace; 80005ab4 <handle_adel_int+2c/58>
Trace; 8001cd44 <vprintk+348/3a8>
Trace; 801805cc <ssb_pci_get_invariants+0/698>
Trace; 80228068 <ssb_pcihost_probe+0/118>
Trace; 80180bf0 <ssb_pci_get_invariants+624/698>
Trace; 8017f6ec <sprom_extract_r123+24/248>
Trace; 801805cc <ssb_pci_get_invariants+0/698>
Trace; 8017d918 <ssb_fetch_invariants+34/7c>

<0>Kernel panic - not syncing: Fatal exception in interrupt

2 errors issued.  Results may not be reliable.
