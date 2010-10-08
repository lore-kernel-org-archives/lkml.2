Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab0JHVeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:34:37 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53014 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab0JHVee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:34:34 -0400
Date: Fri, 8 Oct 2010 16:34:29 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Russ Anderson <rja@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: [BUG] x86: bootmem broken on SGI UV
Message-ID: <20101008213429.GB7223@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	[BUG] x86: bootmem broken on SGI UV

Recent community kernels do not boot on SGI UV x86 hardware with
more than one socket.  I suspect the problem is due to recent 
bootmem/e820 changes.

What is happening is the e280 table defines a memory range.

 BIOS-e820: 0000000100000000 - 0000001080000000 (usable)

The SRAT table shows that memory range is spread over two nodes.

 SRAT: Node 0 PXM 0 100000000-800000000
 SRAT: Node 1 PXM 1 800000000-1000000000
 SRAT: Node 0 PXM 0 1000000000-1080000000

Previously, the kernel early_node_map[] would show three entries
with the proper node.
                                                                                
[    0.000000]     0: 0x00100000 -> 0x00800000
[    0.000000]     1: 0x00800000 -> 0x01000000
[    0.000000]     0: 0x01000000 -> 0x01080000

The problem is recent community kernel early_node_map[] shows 
only two entries with the node 0 entry overlapping the node 1
entry.

    0: 0x00100000 -> 0x01080000
    1: 0x00800000 -> 0x01000000

This results in the range 0x800000 -> 0x1000000 getting freed twice
(by free_all_memory_core_early()) resulting in nasty warnings.

 Queued invalidation will be enabled to support x2apic and Intr-remapping.
 BUG: Bad page state in process swapper  pfn:800000
 page:ffffea001c000000 count:0 mapcount:0 mapping:(null) index:0x0
 page flags: 0x60000000080000(buddy)
 Pid: 0, comm: swapper Not tainted 2.6.36-rc6-next-20101006-medusa #23
 Call Trace:
  [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
  [<ffffffff810a61d8>] bad_page+0xeb/0xfd
  [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
  [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
  [<ffffffff810a7cf8>] __free_pages+0x22/0x24
  [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
  [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
  [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
  [<ffffffff81398dbc>] ? _etext+0x0/0x24
  [<ffffffff8169f5ea>] mem_init+0x1e/0xec
  [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
  [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
  [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
  [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
 Disabling lock debugging due to kernel taint

Shortly there after the kernel dies trying to get a page off the
freelist.

 Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.99 BogoMIPS (lpj=10667996)
 pid_max: default: 32768 minimum: 301
 general protection fault: 0000 [#1] SMP
 last sysfs file:
 CPU 0
 Modules linked in:
 
 Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23 /Stoutland Platform
 RIP: 0010:[<ffffffff810a5557>]  [<ffffffff810a5557>] __rmqueue+0x7c/0x311
 RSP: 0000:ffffffff816019b8  EFLAGS: 00010002
 RAX: dead000000200200 RBX: dead000000200200 RCX: ffffea0037fe4e28
 RDX: dead000000100100 RSI: ffff880ffffda010 RDI: 0000000000000006
 RBP: ffffffff816019f8 R08: 0000000000000001 R09: ffff880ffffda078
 R10: 0000000000000000 R11: 0000000000000000 R12: dead000000100100
 R13: ffffea0037fe4e00 R14: 0000000000000286 R15: ffff880ffffd9e00
 FS:  0000000000000000(0000) GS:ffff880075c00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 0000000001604000 CR4: 00000000000006b0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process swapper (pid: 0, threadinfo ffffffff81600000, task ffffffff8160c020)
 Stack:
  0000000000000000 ffff880ffffd9e00 0000000000000000 ffffea0037fe5bf0
 <0> ffff880075c16158 0000000000000003 0000000000000286 ffff880ffffd9e00
 <0> ffffffff81601b28 ffffffff810a81d4 ffff88107ffd8e00 ffffffff81600000
 Call Trace:
  [<ffffffff810a81d4>] get_page_from_freelist+0x2f7/0x787
  [<ffffffff810a6bd7>] ? zone_watermark_ok+0x25/0xb8
  [<ffffffff810a8a3c>] __alloc_pages_nodemask+0x160/0x6ac
  [<ffffffff810a8a3c>] ? __alloc_pages_nodemask+0x160/0x6ac
  [<ffffffff811d7f2b>] ? cpumask_next_and+0x2d/0x3e
  [<ffffffff810d2aa2>] alloc_page_interleave+0x36/0x80
  [<ffffffff810d2bcf>] alloc_pages_current+0x7c/0xd1
  [<ffffffff8102f1f9>] __change_page_attr_set_clr+0x75f/0xc1f
  [<ffffffff810c8635>] ? vm_unmap_aliases+0x179/0x188
  [<ffffffff8102f830>] change_page_attr_set_clr+0x177/0x3ed
  [<ffffffff8102fe40>] ? set_memory_nx+0x3b/0x3d
  [<ffffffff8102fc2a>] set_memory_x+0x3b/0x3d
  [<ffffffff8169931b>] efi_enter_virtual_mode+0x22a/0x269
  [<ffffffff81689d99>] start_kernel+0x377/0x3ea
  [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
  [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
  [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
 Code: 0f 84 a9 00 00 00 48 8b 4c 0a 68 49 bc 00 01 10 00 00 00 ad de 48 bb 00 02 20 00 00 00 ad de 4c 8d 69 d8 49 8b 55 28 49 8b 45 30 <48> 89 42 08 48 89 10 4d 89 65 28 49 89 5d 30 0f ba 71 d8 13 b8
 RIP  [<ffffffff810a5557>] __rmqueue+0x7c/0x311
  RSP <ffffffff816019b8>
 ---[ end trace 4eaa2a86a8e2da22 ]---
 Kernel panic - not syncing: Attempted to kill the idle task!
   

I have not tracked the exact change that caused the regression, but suspect
it involves the recent bootmem/e820 changes.

Attached is the full boot output.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="output.2.6.36-rc6.fail"

ELILO boot:

Loading kernel bzImage-uv2...  done
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.36-rc6-next-20101006-medusa (rja@gulag1) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #23 SMP Fri Oct 8 09:28:47 CDT 2010
Command line: BOOT_IMAGE=net0:bzImage-uv2  kdb=on nobau pcie_aspm=off add_efi_memmap cgroup_disable=memory console=ttyS0,115200n8 earlyprintk=ttyS0,115200n8 root=/dev/sda5 log_buf_len=4M processor.max_cstate=1 stop_machine.lazy=1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 0000000000090000 (ACPI NVS)
 BIOS-e820: 0000000000090000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 0000000075fb6000 (usable)
 BIOS-e820: 0000000075fb6000 - 0000000075fd3000 (unusable)
 BIOS-e820: 0000000075fd3000 - 00000000766b6000 (usable)
 BIOS-e820: 00000000766b6000 - 00000000766e6000 (unusable)
 BIOS-e820: 00000000766e6000 - 0000000076837000 (usable)
 BIOS-e820: 0000000076837000 - 0000000076838000 (reserved)
 BIOS-e820: 0000000076838000 - 0000000078b43000 (usable)
 BIOS-e820: 0000000078b43000 - 0000000078b4b000 (reserved)
 BIOS-e820: 0000000078b4b000 - 0000000078b5a000 (unusable)
 BIOS-e820: 0000000078b5a000 - 0000000078b93000 (reserved)
 BIOS-e820: 0000000078b93000 - 0000000078be3000 (unusable)
 BIOS-e820: 0000000078be3000 - 0000000078c33000 (reserved)
 BIOS-e820: 0000000078c33000 - 0000000078d06000 (ACPI NVS)
 BIOS-e820: 0000000078d06000 - 0000000078d0d000 (ACPI data)
 BIOS-e820: 0000000078d0d000 - 0000000078d33000 (ACPI NVS)
 BIOS-e820: 0000000078d33000 - 0000000078d53000 (ACPI data)
 BIOS-e820: 0000000078d53000 - 000000007cdb4000 (usable)
 BIOS-e820: 000000007cdb4000 - 000000007cdb5000 (reserved)
 BIOS-e820: 000000007cdb5000 - 000000007cdc1000 (usable)
 BIOS-e820: 000000007cdc1000 - 000000007ce41000 (reserved)
 BIOS-e820: 000000007ce41000 - 000000007f000000 (usable)
 BIOS-e820: 0000000080000000 - 0000000090000000 (reserved)
 BIOS-e820: 00000000f4000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000feb00000 - 00000000fec00000 (reserved)
 BIOS-e820: 0000000100000000 - 0000001080000000 (usable)
 BIOS-e820: 00000f7c00000000 - 00000f7c03d00000 (reserved)
 BIOS-e820: 00000f7c03e00000 - 00000f7c04000000 (reserved)
 BIOS-e820: 00000f7e00000000 - 00000f7e02000000 (reserved)
bootconsole [earlyser0] enabled
NX (Execute Disable) protection: active
EFI v2.10 by INTEL
 ACPI 2.0=0x78d52014  SMBIOS=0x78c0f000  UVsystab=0x78b44000
Kernel-defined memdesc doesn't match the one from EFI!
EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
EFI: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x000000000000e000) (0MB)
EFI: mem02: type=3, attr=0xf, range=[0x000000000000e000-0x0000000000010000) (0MB)
EFI: mem03: type=7, attr=0xf, range=[0x0000000000010000-0x000000000005f000) (0MB)
EFI: mem04: type=4, attr=0xf, range=[0x000000000005f000-0x0000000000060000) (0MB)
EFI: mem05: type=3, attr=0xf, range=[0x0000000000060000-0x000000000008f000) (0MB)
EFI: mem06: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
EFI: mem07: type=3, attr=0xf, range=[0x0000000000090000-0x00000000000a0000) (0MB)
EFI: mem08: type=2, attr=0xf, range=[0x0000000000100000-0x0000000000900000) (8MB)
EFI: mem09: type=7, attr=0xf, range=[0x0000000000900000-0x0000000000c00000) (3MB)
EFI: mem10: type=3, attr=0xf, range=[0x0000000000c00000-0x0000000001000000) (4MB)
EFI: mem11: type=7, attr=0xf, range=[0x0000000001000000-0x0000000010000000) (240MB)
EFI: mem12: type=3, attr=0xf, range=[0x0000000010000000-0x0000000010052000) (0MB)
EFI: mem13: type=7, attr=0xf, range=[0x0000000010052000-0x00000000722c5000) (1570MB)
EFI: mem14: type=4, attr=0xf, range=[0x00000000722c5000-0x00000000722c6000) (0MB)
EFI: mem15: type=7, attr=0xf, range=[0x00000000722c6000-0x00000000722de000) (0MB)
EFI: mem16: type=4, attr=0xf, range=[0x00000000722de000-0x0000000072305000) (0MB)
EFI: mem17: type=7, attr=0xf, range=[0x0000000072305000-0x0000000072306000) (0MB)
EFI: mem18: type=4, attr=0xf, range=[0x0000000072306000-0x0000000072307000) (0MB)
EFI: mem19: type=7, attr=0xf, range=[0x0000000072307000-0x000000007230a000) (0MB)
EFI: mem20: type=4, attr=0xf, range=[0x000000007230a000-0x000000007230b000) (0MB)
EFI: mem21: type=7, attr=0xf, range=[0x000000007230b000-0x000000007232e000) (0MB)
EFI: mem22: type=4, attr=0xf, range=[0x000000007232e000-0x0000000072355000) (0MB)
EFI: mem23: type=7, attr=0xf, range=[0x0000000072355000-0x0000000072356000) (0MB)
EFI: mem24: type=4, attr=0xf, range=[0x0000000072356000-0x0000000072357000) (0MB)
EFI: mem25: type=7, attr=0xf, range=[0x0000000072357000-0x000000007235a000) (0MB)
EFI: mem26: type=4, attr=0xf, range=[0x000000007235a000-0x000000007235b000) (0MB)
EFI: mem27: type=7, attr=0xf, range=[0x000000007235b000-0x000000007237e000) (0MB)
EFI: mem28: type=4, attr=0xf, range=[0x000000007237e000-0x00000000723a5000) (0MB)
EFI: mem29: type=7, attr=0xf, range=[0x00000000723a5000-0x00000000723a6000) (0MB)
EFI: mem30: type=4, attr=0xf, range=[0x00000000723a6000-0x00000000723a7000) (0MB)
EFI: mem31: type=7, attr=0xf, range=[0x00000000723a7000-0x00000000723aa000) (0MB)
EFI: mem32: type=4, attr=0xf, range=[0x00000000723aa000-0x00000000723ab000) (0MB)
EFI: mem33: type=7, attr=0xf, range=[0x00000000723ab000-0x00000000723ce000) (0MB)
EFI: mem34: type=4, attr=0xf, range=[0x00000000723ce000-0x00000000723f5000) (0MB)
EFI: mem35: type=7, attr=0xf, range=[0x00000000723f5000-0x00000000723f6000) (0MB)
EFI: mem36: type=4, attr=0xf, range=[0x00000000723f6000-0x00000000723f7000) (0MB)
EFI: mem37: type=7, attr=0xf, range=[0x00000000723f7000-0x00000000723fa000) (0MB)
EFI: mem38: type=4, attr=0xf, range=[0x00000000723fa000-0x00000000723fb000) (0MB)
EFI: mem39: type=7, attr=0xf, range=[0x00000000723fb000-0x000000007241e000) (0MB)
EFI: mem40: type=4, attr=0xf, range=[0x000000007241e000-0x0000000072445000) (0MB)
EFI: mem41: type=7, attr=0xf, range=[0x0000000072445000-0x0000000072446000) (0MB)
EFI: mem42: type=4, attr=0xf, range=[0x0000000072446000-0x0000000072447000) (0MB)
EFI: mem43: type=7, attr=0xf, range=[0x0000000072447000-0x000000007244a000) (0MB)
EFI: mem44: type=4, attr=0xf, range=[0x000000007244a000-0x000000007244b000) (0MB)
EFI: mem45: type=7, attr=0xf, range=[0x000000007244b000-0x000000007246e000) (0MB)
EFI: mem46: type=4, attr=0xf, range=[0x000000007246e000-0x0000000072495000) (0MB)
EFI: mem47: type=7, attr=0xf, range=[0x0000000072495000-0x0000000072496000) (0MB)
EFI: mem48: type=4, attr=0xf, range=[0x0000000072496000-0x0000000072497000) (0MB)
EFI: mem49: type=7, attr=0xf, range=[0x0000000072497000-0x000000007249a000) (0MB)
EFI: mem50: type=4, attr=0xf, range=[0x000000007249a000-0x000000007249b000) (0MB)
EFI: mem51: type=7, attr=0xf, range=[0x000000007249b000-0x00000000724be000) (0MB)
EFI: mem52: type=4, attr=0xf, range=[0x00000000724be000-0x00000000724e5000) (0MB)
EFI: mem53: type=7, attr=0xf, range=[0x00000000724e5000-0x00000000724e6000) (0MB)
EFI: mem54: type=4, attr=0xf, range=[0x00000000724e6000-0x00000000724e7000) (0MB)
EFI: mem55: type=7, attr=0xf, range=[0x00000000724e7000-0x00000000724ea000) (0MB)
EFI: mem56: type=4, attr=0xf, range=[0x00000000724ea000-0x00000000724eb000) (0MB)
EFI: mem57: type=7, attr=0xf, range=[0x00000000724eb000-0x000000007250e000) (0MB)
EFI: mem58: type=4, attr=0xf, range=[0x000000007250e000-0x0000000072535000) (0MB)
EFI: mem59: type=7, attr=0xf, range=[0x0000000072535000-0x0000000072536000) (0MB)
EFI: mem60: type=4, attr=0xf, range=[0x0000000072536000-0x0000000072537000) (0MB)
EFI: mem61: type=7, attr=0xf, range=[0x0000000072537000-0x000000007253a000) (0MB)
EFI: mem62: type=4, attr=0xf, range=[0x000000007253a000-0x000000007253b000) (0MB)
EFI: mem63: type=7, attr=0xf, range=[0x000000007253b000-0x000000007255e000) (0MB)
EFI: mem64: type=4, attr=0xf, range=[0x000000007255e000-0x0000000072585000) (0MB)
EFI: mem65: type=7, attr=0xf, range=[0x0000000072585000-0x0000000072586000) (0MB)
EFI: mem66: type=4, attr=0xf, range=[0x0000000072586000-0x0000000072587000) (0MB)
EFI: mem67: type=7, attr=0xf, range=[0x0000000072587000-0x000000007258a000) (0MB)
EFI: mem68: type=4, attr=0xf, range=[0x000000007258a000-0x000000007258b000) (0MB)
EFI: mem69: type=7, attr=0xf, range=[0x000000007258b000-0x00000000725ae000) (0MB)
EFI: mem70: type=4, attr=0xf, range=[0x00000000725ae000-0x00000000725d5000) (0MB)
EFI: mem71: type=7, attr=0xf, range=[0x00000000725d5000-0x00000000725d6000) (0MB)
EFI: mem72: type=4, attr=0xf, range=[0x00000000725d6000-0x00000000725d7000) (0MB)
EFI: mem73: type=7, attr=0xf, range=[0x00000000725d7000-0x00000000725da000) (0MB)
EFI: mem74: type=4, attr=0xf, range=[0x00000000725da000-0x00000000725db000) (0MB)
EFI: mem75: type=7, attr=0xf, range=[0x00000000725db000-0x00000000725fe000) (0MB)
EFI: mem76: type=4, attr=0xf, range=[0x00000000725fe000-0x0000000072625000) (0MB)
EFI: mem77: type=7, attr=0xf, range=[0x0000000072625000-0x0000000072626000) (0MB)
EFI: mem78: type=4, attr=0xf, range=[0x0000000072626000-0x0000000072627000) (0MB)
EFI: mem79: type=7, attr=0xf, range=[0x0000000072627000-0x000000007262a000) (0MB)
EFI: mem80: type=4, attr=0xf, range=[0x000000007262a000-0x000000007262b000) (0MB)
EFI: mem81: type=7, attr=0xf, range=[0x000000007262b000-0x000000007264e000) (0MB)
EFI: mem82: type=4, attr=0xf, range=[0x000000007264e000-0x0000000072675000) (0MB)
EFI: mem83: type=7, attr=0xf, range=[0x0000000072675000-0x0000000072676000) (0MB)
EFI: mem84: type=4, attr=0xf, range=[0x0000000072676000-0x0000000072677000) (0MB)
EFI: mem85: type=7, attr=0xf, range=[0x0000000072677000-0x000000007267a000) (0MB)
EFI: mem86: type=4, attr=0xf, range=[0x000000007267a000-0x000000007267b000) (0MB)
EFI: mem87: type=7, attr=0xf, range=[0x000000007267b000-0x000000007269e000) (0MB)
EFI: mem88: type=4, attr=0xf, range=[0x000000007269e000-0x00000000726c5000) (0MB)
EFI: mem89: type=7, attr=0xf, range=[0x00000000726c5000-0x00000000726c6000) (0MB)
EFI: mem90: type=4, attr=0xf, range=[0x00000000726c6000-0x00000000726c7000) (0MB)
EFI: mem91: type=7, attr=0xf, range=[0x00000000726c7000-0x00000000726ca000) (0MB)
EFI: mem92: type=4, attr=0xf, range=[0x00000000726ca000-0x00000000726cb000) (0MB)
EFI: mem93: type=7, attr=0xf, range=[0x00000000726cb000-0x00000000726ee000) (0MB)
EFI: mem94: type=4, attr=0xf, range=[0x00000000726ee000-0x0000000072715000) (0MB)
EFI: mem95: type=7, attr=0xf, range=[0x0000000072715000-0x0000000072716000) (0MB)
EFI: mem96: type=4, attr=0xf, range=[0x0000000072716000-0x0000000072717000) (0MB)
EFI: mem97: type=7, attr=0xf, range=[0x0000000072717000-0x000000007271a000) (0MB)
EFI: mem98: type=4, attr=0xf, range=[0x000000007271a000-0x000000007271b000) (0MB)
EFI: mem99: type=7, attr=0xf, range=[0x000000007271b000-0x000000007273e000) (0MB)
EFI: mem100: type=4, attr=0xf, range=[0x000000007273e000-0x0000000072765000) (0MB)
EFI: mem101: type=7, attr=0xf, range=[0x0000000072765000-0x0000000072766000) (0MB)
EFI: mem102: type=4, attr=0xf, range=[0x0000000072766000-0x0000000072767000) (0MB)
EFI: mem103: type=7, attr=0xf, range=[0x0000000072767000-0x000000007276a000) (0MB)
EFI: mem104: type=4, attr=0xf, range=[0x000000007276a000-0x000000007276b000) (0MB)
EFI: mem105: type=7, attr=0xf, range=[0x000000007276b000-0x000000007278e000) (0MB)
EFI: mem106: type=4, attr=0xf, range=[0x000000007278e000-0x00000000727b5000) (0MB)
EFI: mem107: type=7, attr=0xf, range=[0x00000000727b5000-0x00000000727b6000) (0MB)
EFI: mem108: type=4, attr=0xf, range=[0x00000000727b6000-0x00000000727b7000) (0MB)
EFI: mem109: type=7, attr=0xf, range=[0x00000000727b7000-0x00000000727ba000) (0MB)
EFI: mem110: type=4, attr=0xf, range=[0x00000000727ba000-0x00000000727bb000) (0MB)
EFI: mem111: type=7, attr=0xf, range=[0x00000000727bb000-0x00000000727de000) (0MB)
EFI: mem112: type=4, attr=0xf, range=[0x00000000727de000-0x0000000072805000) (0MB)
EFI: mem113: type=7, attr=0xf, range=[0x0000000072805000-0x0000000072806000) (0MB)
EFI: mem114: type=4, attr=0xf, range=[0x0000000072806000-0x0000000072807000) (0MB)
EFI: mem115: type=7, attr=0xf, range=[0x0000000072807000-0x000000007280a000) (0MB)
EFI: mem116: type=4, attr=0xf, range=[0x000000007280a000-0x000000007280b000) (0MB)
EFI: mem117: type=7, attr=0xf, range=[0x000000007280b000-0x000000007282e000) (0MB)
EFI: mem118: type=4, attr=0xf, range=[0x000000007282e000-0x0000000072855000) (0MB)
EFI: mem119: type=7, attr=0xf, range=[0x0000000072855000-0x0000000072856000) (0MB)
EFI: mem120: type=4, attr=0xf, range=[0x0000000072856000-0x0000000072857000) (0MB)
EFI: mem121: type=7, attr=0xf, range=[0x0000000072857000-0x000000007285a000) (0MB)
EFI: mem122: type=4, attr=0xf, range=[0x000000007285a000-0x000000007285b000) (0MB)
EFI: mem123: type=7, attr=0xf, range=[0x000000007285b000-0x000000007287e000) (0MB)
EFI: mem124: type=4, attr=0xf, range=[0x000000007287e000-0x00000000728a5000) (0MB)
EFI: mem125: type=7, attr=0xf, range=[0x00000000728a5000-0x00000000728a6000) (0MB)
EFI: mem126: type=4, attr=0xf, range=[0x00000000728a6000-0x00000000728a7000) (0MB)
EFI: mem127: type=7, attr=0xf, range=[0x00000000728a7000-0x00000000728aa000) (0MB)
EFI: mem128: type=4, attr=0xf, range=[0x00000000728aa000-0x00000000728ab000) (0MB)
EFI: mem129: type=7, attr=0xf, range=[0x00000000728ab000-0x00000000728ce000) (0MB)
EFI: mem130: type=4, attr=0xf, range=[0x00000000728ce000-0x00000000728f5000) (0MB)
EFI: mem131: type=7, attr=0xf, range=[0x00000000728f5000-0x00000000728f6000) (0MB)
EFI: mem132: type=4, attr=0xf, range=[0x00000000728f6000-0x00000000728f7000) (0MB)
EFI: mem133: type=7, attr=0xf, range=[0x00000000728f7000-0x00000000728fa000) (0MB)
EFI: mem134: type=4, attr=0xf, range=[0x00000000728fa000-0x00000000728fb000) (0MB)
EFI: mem135: type=7, attr=0xf, range=[0x00000000728fb000-0x000000007291e000) (0MB)
EFI: mem136: type=4, attr=0xf, range=[0x000000007291e000-0x0000000072945000) (0MB)
EFI: mem137: type=7, attr=0xf, range=[0x0000000072945000-0x0000000072946000) (0MB)
EFI: mem138: type=4, attr=0xf, range=[0x0000000072946000-0x0000000072947000) (0MB)
EFI: mem139: type=7, attr=0xf, range=[0x0000000072947000-0x000000007294a000) (0MB)
EFI: mem140: type=4, attr=0xf, range=[0x000000007294a000-0x000000007294b000) (0MB)
EFI: mem141: type=7, attr=0xf, range=[0x000000007294b000-0x000000007296e000) (0MB)
EFI: mem142: type=4, attr=0xf, range=[0x000000007296e000-0x0000000072995000) (0MB)
EFI: mem143: type=7, attr=0xf, range=[0x0000000072995000-0x0000000072996000) (0MB)
EFI: mem144: type=4, attr=0xf, range=[0x0000000072996000-0x0000000072997000) (0MB)
EFI: mem145: type=7, attr=0xf, range=[0x0000000072997000-0x000000007299a000) (0MB)
EFI: mem146: type=4, attr=0xf, range=[0x000000007299a000-0x000000007299b000) (0MB)
EFI: mem147: type=7, attr=0xf, range=[0x000000007299b000-0x00000000729be000) (0MB)
EFI: mem148: type=4, attr=0xf, range=[0x00000000729be000-0x00000000729e5000) (0MB)
EFI: mem149: type=7, attr=0xf, range=[0x00000000729e5000-0x00000000729e6000) (0MB)
EFI: mem150: type=4, attr=0xf, range=[0x00000000729e6000-0x00000000729e7000) (0MB)
EFI: mem151: type=7, attr=0xf, range=[0x00000000729e7000-0x00000000729ea000) (0MB)
EFI: mem152: type=4, attr=0xf, range=[0x00000000729ea000-0x00000000729eb000) (0MB)
EFI: mem153: type=7, attr=0xf, range=[0x00000000729eb000-0x0000000072a0e000) (0MB)
EFI: mem154: type=4, attr=0xf, range=[0x0000000072a0e000-0x0000000072a35000) (0MB)
EFI: mem155: type=7, attr=0xf, range=[0x0000000072a35000-0x0000000072a36000) (0MB)
EFI: mem156: type=4, attr=0xf, range=[0x0000000072a36000-0x0000000072a37000) (0MB)
EFI: mem157: type=7, attr=0xf, range=[0x0000000072a37000-0x0000000072a3a000) (0MB)
EFI: mem158: type=4, attr=0xf, range=[0x0000000072a3a000-0x0000000072a3b000) (0MB)
EFI: mem159: type=7, attr=0xf, range=[0x0000000072a3b000-0x0000000072a5e000) (0MB)
EFI: mem160: type=4, attr=0xf, range=[0x0000000072a5e000-0x0000000072a85000) (0MB)
EFI: mem161: type=7, attr=0xf, range=[0x0000000072a85000-0x0000000072a86000) (0MB)
EFI: mem162: type=4, attr=0xf, range=[0x0000000072a86000-0x0000000072a87000) (0MB)
EFI: mem163: type=7, attr=0xf, range=[0x0000000072a87000-0x0000000072a8a000) (0MB)
EFI: mem164: type=4, attr=0xf, range=[0x0000000072a8a000-0x0000000072a8b000) (0MB)
EFI: mem165: type=7, attr=0xf, range=[0x0000000072a8b000-0x0000000072aae000) (0MB)
EFI: mem166: type=4, attr=0xf, range=[0x0000000072aae000-0x0000000072ad5000) (0MB)
EFI: mem167: type=7, attr=0xf, range=[0x0000000072ad5000-0x0000000072ad6000) (0MB)
EFI: mem168: type=4, attr=0xf, range=[0x0000000072ad6000-0x0000000072ad7000) (0MB)
EFI: mem169: type=7, attr=0xf, range=[0x0000000072ad7000-0x0000000072ada000) (0MB)
EFI: mem170: type=4, attr=0xf, range=[0x0000000072ada000-0x0000000072adb000) (0MB)
EFI: mem171: type=7, attr=0xf, range=[0x0000000072adb000-0x0000000072afe000) (0MB)
EFI: mem172: type=4, attr=0xf, range=[0x0000000072afe000-0x0000000072b25000) (0MB)
EFI: mem173: type=7, attr=0xf, range=[0x0000000072b25000-0x0000000072b26000) (0MB)
EFI: mem174: type=4, attr=0xf, range=[0x0000000072b26000-0x0000000072b27000) (0MB)
EFI: mem175: type=7, attr=0xf, range=[0x0000000072b27000-0x0000000072b2a000) (0MB)
EFI: mem176: type=4, attr=0xf, range=[0x0000000072b2a000-0x0000000072b2b000) (0MB)
EFI: mem177: type=7, attr=0xf, range=[0x0000000072b2b000-0x0000000072b4e000) (0MB)
EFI: mem178: type=4, attr=0xf, range=[0x0000000072b4e000-0x0000000072b75000) (0MB)
EFI: mem179: type=7, attr=0xf, range=[0x0000000072b75000-0x0000000072b76000) (0MB)
EFI: mem180: type=4, attr=0xf, range=[0x0000000072b76000-0x0000000072b77000) (0MB)
EFI: mem181: type=7, attr=0xf, range=[0x0000000072b77000-0x0000000072b7a000) (0MB)
EFI: mem182: type=4, attr=0xf, range=[0x0000000072b7a000-0x0000000072b7b000) (0MB)
EFI: mem183: type=7, attr=0xf, range=[0x0000000072b7b000-0x0000000072b9e000) (0MB)
EFI: mem184: type=4, attr=0xf, range=[0x0000000072b9e000-0x0000000072bc5000) (0MB)
EFI: mem185: type=7, attr=0xf, range=[0x0000000072bc5000-0x0000000072bc6000) (0MB)
EFI: mem186: type=4, attr=0xf, range=[0x0000000072bc6000-0x0000000072bc7000) (0MB)
EFI: mem187: type=7, attr=0xf, range=[0x0000000072bc7000-0x0000000072bca000) (0MB)
EFI: mem188: type=4, attr=0xf, range=[0x0000000072bca000-0x0000000072bcb000) (0MB)
EFI: mem189: type=7, attr=0xf, range=[0x0000000072bcb000-0x0000000072bee000) (0MB)
EFI: mem190: type=4, attr=0xf, range=[0x0000000072bee000-0x0000000072c15000) (0MB)
EFI: mem191: type=7, attr=0xf, range=[0x0000000072c15000-0x0000000072c16000) (0MB)
EFI: mem192: type=4, attr=0xf, range=[0x0000000072c16000-0x0000000072c17000) (0MB)
EFI: mem193: type=7, attr=0xf, range=[0x0000000072c17000-0x0000000072c1a000) (0MB)
EFI: mem194: type=4, attr=0xf, range=[0x0000000072c1a000-0x0000000072c1b000) (0MB)
EFI: mem195: type=7, attr=0xf, range=[0x0000000072c1b000-0x0000000072c3e000) (0MB)
EFI: mem196: type=4, attr=0xf, range=[0x0000000072c3e000-0x0000000072c65000) (0MB)
EFI: mem197: type=7, attr=0xf, range=[0x0000000072c65000-0x0000000072c66000) (0MB)
EFI: mem198: type=4, attr=0xf, range=[0x0000000072c66000-0x0000000072c67000) (0MB)
EFI: mem199: type=7, attr=0xf, range=[0x0000000072c67000-0x0000000072c6a000) (0MB)
EFI: mem200: type=4, attr=0xf, range=[0x0000000072c6a000-0x0000000072c6b000) (0MB)
EFI: mem201: type=7, attr=0xf, range=[0x0000000072c6b000-0x0000000072c8e000) (0MB)
EFI: mem202: type=4, attr=0xf, range=[0x0000000072c8e000-0x0000000072cb5000) (0MB)
EFI: mem203: type=7, attr=0xf, range=[0x0000000072cb5000-0x0000000072cb6000) (0MB)
EFI: mem204: type=4, attr=0xf, range=[0x0000000072cb6000-0x0000000072cb7000) (0MB)
EFI: mem205: type=7, attr=0xf, range=[0x0000000072cb7000-0x0000000072cba000) (0MB)
EFI: mem206: type=4, attr=0xf, range=[0x0000000072cba000-0x0000000072cbb000) (0MB)
EFI: mem207: type=7, attr=0xf, range=[0x0000000072cbb000-0x0000000072cde000) (0MB)
EFI: mem208: type=4, attr=0xf, range=[0x0000000072cde000-0x0000000072d05000) (0MB)
EFI: mem209: type=7, attr=0xf, range=[0x0000000072d05000-0x0000000072d06000) (0MB)
EFI: mem210: type=4, attr=0xf, range=[0x0000000072d06000-0x0000000072d07000) (0MB)
EFI: mem211: type=7, attr=0xf, range=[0x0000000072d07000-0x0000000072d0a000) (0MB)
EFI: mem212: type=4, attr=0xf, range=[0x0000000072d0a000-0x0000000072d0b000) (0MB)
EFI: mem213: type=7, attr=0xf, range=[0x0000000072d0b000-0x0000000072d2e000) (0MB)
EFI: mem214: type=4, attr=0xf, range=[0x0000000072d2e000-0x0000000072d55000) (0MB)
EFI: mem215: type=7, attr=0xf, range=[0x0000000072d55000-0x0000000072d56000) (0MB)
EFI: mem216: type=4, attr=0xf, range=[0x0000000072d56000-0x0000000072d57000) (0MB)
EFI: mem217: type=7, attr=0xf, range=[0x0000000072d57000-0x0000000072d5a000) (0MB)
EFI: mem218: type=4, attr=0xf, range=[0x0000000072d5a000-0x0000000072d5b000) (0MB)
EFI: mem219: type=7, attr=0xf, range=[0x0000000072d5b000-0x0000000072d7e000) (0MB)
EFI: mem220: type=4, attr=0xf, range=[0x0000000072d7e000-0x0000000072da5000) (0MB)
EFI: mem221: type=7, attr=0xf, range=[0x0000000072da5000-0x0000000072da6000) (0MB)
EFI: mem222: type=4, attr=0xf, range=[0x0000000072da6000-0x0000000072da7000) (0MB)
EFI: mem223: type=7, attr=0xf, range=[0x0000000072da7000-0x0000000072daa000) (0MB)
EFI: mem224: type=4, attr=0xf, range=[0x0000000072daa000-0x0000000072dab000) (0MB)
EFI: mem225: type=7, attr=0xf, range=[0x0000000072dab000-0x0000000072dce000) (0MB)
EFI: mem226: type=4, attr=0xf, range=[0x0000000072dce000-0x0000000072df5000) (0MB)
EFI: mem227: type=7, attr=0xf, range=[0x0000000072df5000-0x0000000072df6000) (0MB)
EFI: mem228: type=4, attr=0xf, range=[0x0000000072df6000-0x0000000072df7000) (0MB)
EFI: mem229: type=7, attr=0xf, range=[0x0000000072df7000-0x0000000072dfa000) (0MB)
EFI: mem230: type=4, attr=0xf, range=[0x0000000072dfa000-0x0000000072dfb000) (0MB)
EFI: mem231: type=7, attr=0xf, range=[0x0000000072dfb000-0x0000000072e1e000) (0MB)
EFI: mem232: type=4, attr=0xf, range=[0x0000000072e1e000-0x0000000072e45000) (0MB)
EFI: mem233: type=7, attr=0xf, range=[0x0000000072e45000-0x0000000072e46000) (0MB)
EFI: mem234: type=4, attr=0xf, range=[0x0000000072e46000-0x0000000072e47000) (0MB)
EFI: mem235: type=7, attr=0xf, range=[0x0000000072e47000-0x0000000072e4a000) (0MB)
EFI: mem236: type=4, attr=0xf, range=[0x0000000072e4a000-0x0000000072e4b000) (0MB)
EFI: mem237: type=7, attr=0xf, range=[0x0000000072e4b000-0x0000000072e6e000) (0MB)
EFI: mem238: type=4, attr=0xf, range=[0x0000000072e6e000-0x0000000072e95000) (0MB)
EFI: mem239: type=7, attr=0xf, range=[0x0000000072e95000-0x0000000072e96000) (0MB)
EFI: mem240: type=4, attr=0xf, range=[0x0000000072e96000-0x0000000072e97000) (0MB)
EFI: mem241: type=7, attr=0xf, range=[0x0000000072e97000-0x0000000072e9a000) (0MB)
EFI: mem242: type=4, attr=0xf, range=[0x0000000072e9a000-0x0000000072e9b000) (0MB)
EFI: mem243: type=7, attr=0xf, range=[0x0000000072e9b000-0x0000000072ebe000) (0MB)
EFI: mem244: type=4, attr=0xf, range=[0x0000000072ebe000-0x0000000072ee5000) (0MB)
EFI: mem245: type=7, attr=0xf, range=[0x0000000072ee5000-0x0000000072ee6000) (0MB)
EFI: mem246: type=4, attr=0xf, range=[0x0000000072ee6000-0x0000000072ee7000) (0MB)
EFI: mem247: type=7, attr=0xf, range=[0x0000000072ee7000-0x0000000072eea000) (0MB)
EFI: mem248: type=4, attr=0xf, range=[0x0000000072eea000-0x0000000072eeb000) (0MB)
EFI: mem249: type=7, attr=0xf, range=[0x0000000072eeb000-0x0000000072f0e000) (0MB)
EFI: mem250: type=4, attr=0xf, range=[0x0000000072f0e000-0x0000000072f35000) (0MB)
EFI: mem251: type=7, attr=0xf, range=[0x0000000072f35000-0x0000000072f36000) (0MB)
EFI: mem252: type=4, attr=0xf, range=[0x0000000072f36000-0x0000000072f37000) (0MB)
EFI: mem253: type=7, attr=0xf, range=[0x0000000072f37000-0x0000000072f3a000) (0MB)
EFI: mem254: type=4, attr=0xf, range=[0x0000000072f3a000-0x0000000072f3b000) (0MB)
EFI: mem255: type=7, attr=0xf, range=[0x0000000072f3b000-0x0000000072f5e000) (0MB)
EFI: mem256: type=4, attr=0xf, range=[0x0000000072f5e000-0x0000000072f85000) (0MB)
EFI: mem257: type=7, attr=0xf, range=[0x0000000072f85000-0x0000000072f86000) (0MB)
EFI: mem258: type=4, attr=0xf, range=[0x0000000072f86000-0x0000000072f87000) (0MB)
EFI: mem259: type=7, attr=0xf, range=[0x0000000072f87000-0x0000000072f8a000) (0MB)
EFI: mem260: type=4, attr=0xf, range=[0x0000000072f8a000-0x0000000072f8b000) (0MB)
EFI: mem261: type=7, attr=0xf, range=[0x0000000072f8b000-0x0000000072fae000) (0MB)
EFI: mem262: type=4, attr=0xf, range=[0x0000000072fae000-0x0000000072fd4000) (0MB)
EFI: mem263: type=7, attr=0xf, range=[0x0000000072fd4000-0x0000000072fd5000) (0MB)
EFI: mem264: type=4, attr=0xf, range=[0x0000000072fd5000-0x0000000072fd6000) (0MB)
EFI: mem265: type=7, attr=0xf, range=[0x0000000072fd6000-0x0000000072fd9000) (0MB)
EFI: mem266: type=4, attr=0xf, range=[0x0000000072fd9000-0x0000000072fda000) (0MB)
EFI: mem267: type=7, attr=0xf, range=[0x0000000072fda000-0x0000000073049000) (0MB)
EFI: mem268: type=2, attr=0xf, range=[0x0000000073049000-0x0000000074049000) (16MB)
EFI: mem269: type=1, attr=0xf, range=[0x0000000074049000-0x0000000074086000) (0MB)
EFI: mem270: type=4, attr=0xf, range=[0x0000000074086000-0x00000000740b8000) (0MB)
EFI: mem271: type=2, attr=0xf, range=[0x00000000740b8000-0x00000000740bc000) (0MB)
EFI: mem272: type=4, attr=0xf, range=[0x00000000740bc000-0x000000007423e000) (1MB)
EFI: mem273: type=7, attr=0xf, range=[0x000000007423e000-0x000000007426e000) (0MB)
EFI: mem274: type=4, attr=0xf, range=[0x000000007426e000-0x0000000074271000) (0MB)
EFI: mem275: type=7, attr=0xf, range=[0x0000000074271000-0x0000000074272000) (0MB)
EFI: mem276: type=4, attr=0xf, range=[0x0000000074272000-0x0000000074273000) (0MB)
EFI: mem277: type=7, attr=0xf, range=[0x0000000074273000-0x0000000074279000) (0MB)
EFI: mem278: type=4, attr=0xf, range=[0x0000000074279000-0x000000007427a000) (0MB)
EFI: mem279: type=7, attr=0xf, range=[0x000000007427a000-0x00000000742dc000) (0MB)
EFI: mem280: type=2, attr=0xf, range=[0x00000000742dc000-0x00000000742e5000) (0MB)
EFI: mem281: type=4, attr=0xf, range=[0x00000000742e5000-0x00000000742e6000) (0MB)
EFI: mem282: type=2, attr=0xf, range=[0x00000000742e6000-0x00000000742e7000) (0MB)
EFI: mem283: type=7, attr=0xf, range=[0x00000000742e7000-0x00000000742e8000) (0MB)
EFI: mem284: type=4, attr=0xf, range=[0x00000000742e8000-0x00000000742f0000) (0MB)
EFI: mem285: type=7, attr=0xf, range=[0x00000000742f0000-0x00000000742f1000) (0MB)
EFI: mem286: type=4, attr=0xf, range=[0x00000000742f1000-0x00000000742f2000) (0MB)
EFI: mem287: type=7, attr=0xf, range=[0x00000000742f2000-0x00000000742f3000) (0MB)
EFI: mem288: type=2, attr=0xf, range=[0x00000000742f3000-0x00000000742f8000) (0MB)
EFI: mem289: type=4, attr=0xf, range=[0x00000000742f8000-0x0000000074320000) (0MB)
EFI: mem290: type=3, attr=0xf, range=[0x0000000074320000-0x0000000074332000) (0MB)
EFI: mem291: type=2, attr=0xf, range=[0x0000000074332000-0x0000000074335000) (0MB)
EFI: mem292: type=4, attr=0xf, range=[0x0000000074335000-0x0000000074349000) (0MB)
EFI: mem293: type=2, attr=0xf, range=[0x0000000074349000-0x000000007434d000) (0MB)
EFI: mem294: type=4, attr=0xf, range=[0x000000007434d000-0x000000007434e000) (0MB)
EFI: mem295: type=2, attr=0xf, range=[0x000000007434e000-0x000000007434f000) (0MB)
EFI: mem296: type=4, attr=0xf, range=[0x000000007434f000-0x0000000075fb6000) (28MB)
EFI: mem297: type=5, attr=0x800000000000000f, range=[0x0000000075fb6000-0x0000000075fd3000) (0MB)
EFI: mem298: type=4, attr=0xf, range=[0x0000000075fd3000-0x00000000761ca000) (1MB)
EFI: mem299: type=3, attr=0xf, range=[0x00000000761ca000-0x00000000761ce000) (0MB)
EFI: mem300: type=4, attr=0xf, range=[0x00000000761ce000-0x0000000076235000) (0MB)
EFI: mem301: type=3, attr=0xf, range=[0x0000000076235000-0x0000000076237000) (0MB)
EFI: mem302: type=4, attr=0xf, range=[0x0000000076237000-0x000000007623a000) (0MB)
EFI: mem303: type=3, attr=0xf, range=[0x000000007623a000-0x0000000076252000) (0MB)
EFI: mem304: type=4, attr=0xf, range=[0x0000000076252000-0x0000000076257000) (0MB)
EFI: mem305: type=3, attr=0xf, range=[0x0000000076257000-0x000000007625b000) (0MB)
EFI: mem306: type=4, attr=0xf, range=[0x000000007625b000-0x000000007625c000) (0MB)
EFI: mem307: type=3, attr=0xf, range=[0x000000007625c000-0x000000007625e000) (0MB)
EFI: mem308: type=4, attr=0xf, range=[0x000000007625e000-0x000000007625f000) (0MB)
EFI: mem309: type=3, attr=0xf, range=[0x000000007625f000-0x0000000076261000) (0MB)
EFI: mem310: type=4, attr=0xf, range=[0x0000000076261000-0x0000000076262000) (0MB)
EFI: mem311: type=3, attr=0xf, range=[0x0000000076262000-0x0000000076269000) (0MB)
EFI: mem312: type=4, attr=0xf, range=[0x0000000076269000-0x000000007626b000) (0MB)
EFI: mem313: type=3, attr=0xf, range=[0x000000007626b000-0x000000007626f000) (0MB)
EFI: mem314: type=4, attr=0xf, range=[0x000000007626f000-0x0000000076270000) (0MB)
EFI: mem315: type=3, attr=0xf, range=[0x0000000076270000-0x0000000076288000) (0MB)
EFI: mem316: type=4, attr=0xf, range=[0x0000000076288000-0x0000000076289000) (0MB)
EFI: mem317: type=3, attr=0xf, range=[0x0000000076289000-0x000000007628d000) (0MB)
EFI: mem318: type=4, attr=0xf, range=[0x000000007628d000-0x0000000076290000) (0MB)
EFI: mem319: type=3, attr=0xf, range=[0x0000000076290000-0x0000000076298000) (0MB)
EFI: mem320: type=4, attr=0xf, range=[0x0000000076298000-0x0000000076299000) (0MB)
EFI: mem321: type=3, attr=0xf, range=[0x0000000076299000-0x000000007629c000) (0MB)
EFI: mem322: type=4, attr=0xf, range=[0x000000007629c000-0x000000007629d000) (0MB)
EFI: mem323: type=3, attr=0xf, range=[0x000000007629d000-0x00000000762ad000) (0MB)
EFI: mem324: type=4, attr=0xf, range=[0x00000000762ad000-0x00000000762b0000) (0MB)
EFI: mem325: type=3, attr=0xf, range=[0x00000000762b0000-0x00000000762b8000) (0MB)
EFI: mem326: type=4, attr=0xf, range=[0x00000000762b8000-0x00000000762b9000) (0MB)
EFI: mem327: type=3, attr=0xf, range=[0x00000000762b9000-0x00000000762d1000) (0MB)
EFI: mem328: type=4, attr=0xf, range=[0x00000000762d1000-0x000000007667b000) (3MB)
EFI: mem329: type=3, attr=0xf, range=[0x000000007667b000-0x0000000076681000) (0MB)
EFI: mem330: type=4, attr=0xf, range=[0x0000000076681000-0x000000007668e000) (0MB)
EFI: mem331: type=3, attr=0xf, range=[0x000000007668e000-0x00000000766b6000) (0MB)
EFI: mem332: type=5, attr=0x800000000000000f, range=[0x00000000766b6000-0x00000000766e6000) (0MB)
EFI: mem333: type=4, attr=0xf, range=[0x00000000766e6000-0x00000000766e7000) (0MB)
EFI: mem334: type=3, attr=0xf, range=[0x00000000766e7000-0x0000000076714000) (0MB)
EFI: mem335: type=4, attr=0xf, range=[0x0000000076714000-0x0000000076715000) (0MB)
EFI: mem336: type=3, attr=0xf, range=[0x0000000076715000-0x0000000076718000) (0MB)
EFI: mem337: type=4, attr=0xf, range=[0x0000000076718000-0x0000000076719000) (0MB)
EFI: mem338: type=3, attr=0xf, range=[0x0000000076719000-0x000000007672a000) (0MB)
EFI: mem339: type=4, attr=0xf, range=[0x000000007672a000-0x0000000076731000) (0MB)
EFI: mem340: type=3, attr=0xf, range=[0x0000000076731000-0x0000000076736000) (0MB)
EFI: mem341: type=4, attr=0xf, range=[0x0000000076736000-0x0000000076737000) (0MB)
EFI: mem342: type=3, attr=0xf, range=[0x0000000076737000-0x000000007673d000) (0MB)
EFI: mem343: type=4, attr=0xf, range=[0x000000007673d000-0x0000000076787000) (0MB)
EFI: mem344: type=3, attr=0xf, range=[0x0000000076787000-0x0000000076789000) (0MB)
EFI: mem345: type=4, attr=0xf, range=[0x0000000076789000-0x0000000076790000) (0MB)
EFI: mem346: type=3, attr=0xf, range=[0x0000000076790000-0x000000007679a000) (0MB)
EFI: mem347: type=4, attr=0xf, range=[0x000000007679a000-0x000000007679e000) (0MB)
EFI: mem348: type=3, attr=0xf, range=[0x000000007679e000-0x00000000767ab000) (0MB)
EFI: mem349: type=4, attr=0xf, range=[0x00000000767ab000-0x00000000767b2000) (0MB)
EFI: mem350: type=3, attr=0xf, range=[0x00000000767b2000-0x00000000767b3000) (0MB)
EFI: mem351: type=4, attr=0xf, range=[0x00000000767b3000-0x00000000767b5000) (0MB)
EFI: mem352: type=3, attr=0xf, range=[0x00000000767b5000-0x00000000767ba000) (0MB)
EFI: mem353: type=4, attr=0xf, range=[0x00000000767ba000-0x00000000767be000) (0MB)
EFI: mem354: type=2, attr=0xf, range=[0x00000000767be000-0x00000000767c3000) (0MB)
EFI: mem355: type=4, attr=0xf, range=[0x00000000767c3000-0x00000000767c7000) (0MB)
EFI: mem356: type=2, attr=0xf, range=[0x00000000767c7000-0x00000000767c8000) (0MB)
EFI: mem357: type=4, attr=0xf, range=[0x00000000767c8000-0x0000000076809000) (0MB)
EFI: mem358: type=3, attr=0xf, range=[0x0000000076809000-0x000000007681c000) (0MB)
EFI: mem359: type=4, attr=0xf, range=[0x000000007681c000-0x000000007681e000) (0MB)
EFI: mem360: type=3, attr=0xf, range=[0x000000007681e000-0x0000000076826000) (0MB)
EFI: mem361: type=4, attr=0xf, range=[0x0000000076826000-0x0000000076827000) (0MB)
EFI: mem362: type=3, attr=0xf, range=[0x0000000076827000-0x0000000076829000) (0MB)
EFI: mem363: type=4, attr=0xf, range=[0x0000000076829000-0x000000007682e000) (0MB)
EFI: mem364: type=2, attr=0xf, range=[0x000000007682e000-0x0000000076836000) (0MB)
EFI: mem365: type=4, attr=0xf, range=[0x0000000076836000-0x0000000076837000) (0MB)
EFI: mem366: type=6, attr=0x800000000000000f, range=[0x0000000076837000-0x0000000076838000) (0MB)
EFI: mem367: type=4, attr=0xf, range=[0x0000000076838000-0x000000007683b000) (0MB)
EFI: mem368: type=3, attr=0xf, range=[0x000000007683b000-0x000000007683d000) (0MB)
EFI: mem369: type=4, attr=0xf, range=[0x000000007683d000-0x000000007685f000) (0MB)
EFI: mem370: type=3, attr=0xf, range=[0x000000007685f000-0x000000007686d000) (0MB)
EFI: mem371: type=4, attr=0xf, range=[0x000000007686d000-0x0000000076883000) (0MB)
EFI: mem372: type=3, attr=0xf, range=[0x0000000076883000-0x0000000076888000) (0MB)
EFI: mem373: type=4, attr=0xf, range=[0x0000000076888000-0x00000000768c1000) (0MB)
EFI: mem374: type=3, attr=0xf, range=[0x00000000768c1000-0x00000000768c3000) (0MB)
EFI: mem375: type=4, attr=0xf, range=[0x00000000768c3000-0x00000000768c4000) (0MB)
EFI: mem376: type=3, attr=0xf, range=[0x00000000768c4000-0x00000000768f4000) (0MB)
EFI: mem377: type=4, attr=0xf, range=[0x00000000768f4000-0x00000000768f5000) (0MB)
EFI: mem378: type=3, attr=0xf, range=[0x00000000768f5000-0x0000000076901000) (0MB)
EFI: mem379: type=4, attr=0xf, range=[0x0000000076901000-0x0000000076905000) (0MB)
EFI: mem380: type=3, attr=0xf, range=[0x0000000076905000-0x000000007690d000) (0MB)
EFI: mem381: type=4, attr=0xf, range=[0x000000007690d000-0x000000007690e000) (0MB)
EFI: mem382: type=3, attr=0xf, range=[0x000000007690e000-0x0000000076925000) (0MB)
EFI: mem383: type=4, attr=0xf, range=[0x0000000076925000-0x0000000076929000) (0MB)
EFI: mem384: type=3, attr=0xf, range=[0x0000000076929000-0x000000007696a000) (0MB)
EFI: mem385: type=4, attr=0xf, range=[0x000000007696a000-0x000000007696d000) (0MB)
EFI: mem386: type=3, attr=0xf, range=[0x000000007696d000-0x0000000076983000) (0MB)
EFI: mem387: type=4, attr=0xf, range=[0x0000000076983000-0x0000000076984000) (0MB)
EFI: mem388: type=3, attr=0xf, range=[0x0000000076984000-0x0000000076986000) (0MB)
EFI: mem389: type=4, attr=0xf, range=[0x0000000076986000-0x0000000076987000) (0MB)
EFI: mem390: type=3, attr=0xf, range=[0x0000000076987000-0x0000000076988000) (0MB)
EFI: mem391: type=4, attr=0xf, range=[0x0000000076988000-0x0000000076989000) (0MB)
EFI: mem392: type=3, attr=0xf, range=[0x0000000076989000-0x0000000076999000) (0MB)
EFI: mem393: type=4, attr=0xf, range=[0x0000000076999000-0x0000000076d99000) (4MB)
EFI: mem394: type=3, attr=0xf, range=[0x0000000076d99000-0x0000000076d9e000) (0MB)
EFI: mem395: type=4, attr=0xf, range=[0x0000000076d9e000-0x0000000076dbb000) (0MB)
EFI: mem396: type=3, attr=0xf, range=[0x0000000076dbb000-0x0000000076dbe000) (0MB)
EFI: mem397: type=4, attr=0xf, range=[0x0000000076dbe000-0x0000000076e08000) (0MB)
EFI: mem398: type=3, attr=0xf, range=[0x0000000076e08000-0x0000000076e0d000) (0MB)
EFI: mem399: type=4, attr=0xf, range=[0x0000000076e0d000-0x0000000076e14000) (0MB)
EFI: mem400: type=3, attr=0xf, range=[0x0000000076e14000-0x0000000076e36000) (0MB)
EFI: mem401: type=4, attr=0xf, range=[0x0000000076e36000-0x0000000076ea5000) (0MB)
EFI: mem402: type=3, attr=0xf, range=[0x0000000076ea5000-0x0000000076ea7000) (0MB)
EFI: mem403: type=4, attr=0xf, range=[0x0000000076ea7000-0x0000000076ea8000) (0MB)
EFI: mem404: type=3, attr=0xf, range=[0x0000000076ea8000-0x0000000076eb7000) (0MB)
EFI: mem405: type=4, attr=0xf, range=[0x0000000076eb7000-0x0000000076ebe000) (0MB)
EFI: mem406: type=3, attr=0xf, range=[0x0000000076ebe000-0x0000000076ec0000) (0MB)
EFI: mem407: type=4, attr=0xf, range=[0x0000000076ec0000-0x0000000076f42000) (0MB)
EFI: mem408: type=3, attr=0xf, range=[0x0000000076f42000-0x0000000076f43000) (0MB)
EFI: mem409: type=4, attr=0xf, range=[0x0000000076f43000-0x0000000078b43000) (28MB)
EFI: mem410: type=6, attr=0x800000000000000f, range=[0x0000000078b43000-0x0000000078b4b000) (0MB)
EFI: mem411: type=5, attr=0x800000000000000f, range=[0x0000000078b4b000-0x0000000078b5a000) (0MB)
EFI: mem412: type=6, attr=0x800000000000000f, range=[0x0000000078b5a000-0x0000000078b93000) (0MB)
EFI: mem413: type=5, attr=0x800000000000000f, range=[0x0000000078b93000-0x0000000078b94000) (0MB)
EFI: mem414: type=5, attr=0x800000000000000f, range=[0x0000000078b94000-0x0000000078be3000) (0MB)
EFI: mem415: type=0, attr=0xf, range=[0x0000000078be3000-0x0000000078c0d000) (0MB)
EFI: mem416: type=0, attr=0xf, range=[0x0000000078c0d000-0x0000000078c33000) (0MB)
EFI: mem417: type=10, attr=0xf, range=[0x0000000078c33000-0x0000000078cfd000) (0MB)
EFI: mem418: type=10, attr=0xf, range=[0x0000000078cfd000-0x0000000078d06000) (0MB)
EFI: mem419: type=9, attr=0xf, range=[0x0000000078d06000-0x0000000078d0d000) (0MB)
EFI: mem420: type=10, attr=0xf, range=[0x0000000078d0d000-0x0000000078d33000) (0MB)
EFI: mem421: type=9, attr=0xf, range=[0x0000000078d33000-0x0000000078d53000) (0MB)
EFI: mem422: type=4, attr=0xf, range=[0x0000000078d53000-0x000000007cdb4000) (64MB)
EFI: mem423: type=6, attr=0x800000000000000f, range=[0x000000007cdb4000-0x000000007cdb5000) (0MB)
EFI: mem424: type=4, attr=0xf, range=[0x000000007cdb5000-0x000000007cdc1000) (0MB)
EFI: mem425: type=6, attr=0x800000000000000f, range=[0x000000007cdc1000-0x000000007ce41000) (0MB)
EFI: mem426: type=4, attr=0xf, range=[0x000000007ce41000-0x000000007f000000) (33MB)
EFI: mem427: type=7, attr=0xf, range=[0x0000000100000000-0x0000001080000000) (63488MB)
EFI: mem428: type=11, attr=0x8000000000000001, range=[0x0000000080000000-0x0000000090000000) (256MB)
EFI: mem429: type=11, attr=0x8000000000000001, range=[0x00000000f4000000-0x00000000fc000000) (128MB)
EFI: mem430: type=11, attr=0x8000000000000001, range=[0x00000000feb00000-0x00000000fec00000) (1MB)
EFI: mem431: type=11, attr=0x8000000000000001, range=[0x00000f7c00000000-0x00000f7c03d00000) (61MB)
EFI: mem432: type=11, attr=0x8000000000000001, range=[0x00000f7c03e00000-0x00000f7c04000000) (2MB)
EFI: mem433: type=11, attr=0x8000000000000001, range=[0x00000f7e00000000-0x00000f7e02000000) (32MB)
DMI 2.4 present.
No AGP bridge found
last_pfn = 0x1080000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
x2apic enabled by BIOS, switching to x2apic ops
last_pfn = 0x7f000 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff8800000fe1b0] fe1b0
init_memory_mapping: 0000000000000000-000000007f000000
init_memory_mapping: 0000000100000000-0000001080000000
ACPI: RSDP 0000000078d52014 00024 (v02    SGI)
ACPI: XSDT 0000000078d52120 0006C (v01    SGI      UVH 00000002      01000013)
ACPI: FACP 0000000078d51000 000F4 (v04    SGI      UVH 00000002 MSFT 01000013)
ACPI: DSDT 0000000078d3d000 06CE0 (v02    SGI      UVH 00000002 MSFT 01000013)
ACPI: FACS 0000000078d0d000 00040
ACPI: SSDT 0000000078d4b000 05C12 (v01  INTEL    SGIUV 00000003 INTL 20061109)
ACPI: HPET 0000000078d4a000 00038 (v01    SGI      UVH 00000002 MSFT 01000013)
ACPI: SLIT 0000000078d48000 00030 (v01    SGI      UVH 00000002 MSFT 00000001)
ACPI: APIC 0000000078d46000 00118 (v02    SGI      UVH 00000002 MSFT 00000001)
ACPI: SRAT 0000000078d44000 001F0 (v02    SGI      UVH 00000002 MSFT 00000001)
ACPI: MCFG 0000000078d3c000 0004C (v01    SGI      UVH 00000002 MSFT 00000001)
ACPI: SPCR 0000000078d34000 00050 (v01 INSYDE INSYDE   00000001    ? 00000001)
ACPI: DMAR 0000000078d33000 000D4 (v01    SGI      UVH 00000002 MSFT 01000013)
Setting APIC routing to UV large system.
SRAT: PXM 0 -> APIC 0x0000 -> Node 0
SRAT: PXM 0 -> APIC 0x0004 -> Node 0
SRAT: PXM 0 -> APIC 0x0006 -> Node 0
SRAT: PXM 0 -> APIC 0x0010 -> Node 0
SRAT: PXM 0 -> APIC 0x0012 -> Node 0
SRAT: PXM 0 -> APIC 0x0016 -> Node 0
SRAT: PXM 1 -> APIC 0x0020 -> Node 1
SRAT: PXM 1 -> APIC 0x0024 -> Node 1
SRAT: PXM 1 -> APIC 0x0026 -> Node 1
SRAT: PXM 1 -> APIC 0x0030 -> Node 1
SRAT: PXM 1 -> APIC 0x0032 -> Node 1
SRAT: PXM 1 -> APIC 0x0036 -> Node 1
SRAT: Node 0 PXM 0 0-80000000
SRAT: Node 0 PXM 0 100000000-800000000
SRAT: Node 1 PXM 1 800000000-1000000000
SRAT: Node 0 PXM 0 1000000000-1080000000
SRAT: Node 0 [0,80000000) + [100000000,800000000) -> [0,800000000)
Initmem setup node 0 0000000000000000-0000001080000000
  NODE_DATA [000000107ffd8000 - 000000107fffefff]
Initmem setup node 1 0000000800000000-0000001000000000
  NODE_DATA [0000000ffffd9000 - 0000000fffffffff]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x01080000
Movable zone start PFN for each node
early_node_map[11] active PFN ranges
    0: 0x00000010 -> 0x0000008f
    0: 0x00000090 -> 0x000000a0
    0: 0x00000100 -> 0x00075fb6
    0: 0x00075fd3 -> 0x000766b6
    0: 0x000766e6 -> 0x00076837
    0: 0x00076838 -> 0x00078b43
    0: 0x00078d53 -> 0x0007cdb4
    0: 0x0007cdb5 -> 0x0007cdc1
    0: 0x0007ce41 -> 0x0007f000
    0: 0x00100000 -> 0x01080000
    1: 0x00800000 -> 0x01000000
ACPI: PM-Timer IO Port: 0x408
Setting APIC routing to UV large system.
ACPI: X2APIC (apic_id[0x00] uid[0x00] enabled)
ACPI: X2APIC (apic_id[0x04] uid[0x01] enabled)
ACPI: X2APIC (apic_id[0x06] uid[0x02] enabled)
ACPI: X2APIC (apic_id[0x10] uid[0x03] enabled)
ACPI: X2APIC (apic_id[0x12] uid[0x04] enabled)
ACPI: X2APIC (apic_id[0x16] uid[0x05] enabled)
ACPI: X2APIC (apic_id[0x20] uid[0x06] enabled)
ACPI: X2APIC (apic_id[0x24] uid[0x07] enabled)
ACPI: X2APIC (apic_id[0x26] uid[0x08] enabled)
ACPI: X2APIC (apic_id[0x30] uid[0x09] enabled)
ACPI: X2APIC (apic_id[0x32] uid[0x0a] enabled)
ACPI: X2APIC (apic_id[0x36] uid[0x0b] enabled)
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec02000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec02000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 12 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000008f000 - 0000000000090000
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
PM: Registered nosave memory: 0000000075fb6000 - 0000000075fd3000
PM: Registered nosave memory: 00000000766b6000 - 00000000766e6000
PM: Registered nosave memory: 0000000076837000 - 0000000076838000
PM: Registered nosave memory: 0000000078b43000 - 0000000078b4b000
PM: Registered nosave memory: 0000000078b4b000 - 0000000078b5a000
PM: Registered nosave memory: 0000000078b5a000 - 0000000078b93000
PM: Registered nosave memory: 0000000078b93000 - 0000000078be3000
PM: Registered nosave memory: 0000000078be3000 - 0000000078c33000
PM: Registered nosave memory: 0000000078c33000 - 0000000078d06000
PM: Registered nosave memory: 0000000078d06000 - 0000000078d0d000
PM: Registered nosave memory: 0000000078d0d000 - 0000000078d33000
PM: Registered nosave memory: 0000000078d33000 - 0000000078d53000
PM: Registered nosave memory: 000000007cdb4000 - 000000007cdb5000
PM: Registered nosave memory: 000000007cdc1000 - 000000007ce41000
PM: Registered nosave memory: 000000007f000000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 0000000090000000
PM: Registered nosave memory: 0000000090000000 - 00000000f4000000
PM: Registered nosave memory: 00000000f4000000 - 00000000fc000000
PM: Registered nosave memory: 00000000fc000000 - 00000000feb00000
PM: Registered nosave memory: 00000000feb00000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at 90000000 (gap: 90000000:64000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:2
PERCPU: Embedded 27 pages/cpu @ffff880075c00000 s80896 r8192 d21504 u262144
pcpu-alloc: s80896 r8192 d21504 u262144 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 -- -- [1] 06 07 08 09 10 11 -- --
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 24809640
Policy zone: Normal
Kernel command line: BOOT_IMAGE=net0:bzImage-uv2  kdb=on nobau pcie_aspm=off add_efi_memmap cgroup_disable=memory console=ttyS0,115200n8 earlyprintk=ttyS0,115200n8 root=/dev/sda5 log_buf_len=4M processor.max_cstate=1 stop_machine.lazy=1
PCIe ASPM is disabled
Disabling memory control group subsystem
log_buf_len: 4194304
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Queued invalidation will be enabled to support x2apic and Intr-remapping.
BUG: Bad page state in process swapper  pfn:800000
page:ffffea001c000000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Not tainted 2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
Disabling lock debugging due to kernel taint
BUG: Bad page state in process swapper  pfn:800400
page:ffffea001c00e000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:800800
page:ffffea001c01c000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:800c00
page:ffffea001c02a000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:801000
page:ffffea001c038000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:801400
page:ffffea001c046000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:801800
page:ffffea001c054000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:801c00
page:ffffea001c062000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:802000
page:ffffea001c070000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:802400
page:ffffea001c07e000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:802800
page:ffffea001c08c000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:802c00
page:ffffea001c09a000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:803000
page:ffffea001c0a8000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:803400
page:ffffea001c0b6000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:803800
page:ffffea001c0c4000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:803c00
page:ffffea001c0d2000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:804000
page:ffffea001c0e0000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:804400
page:ffffea001c0ee000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:804800
page:ffffea001c0fc000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:804c00
page:ffffea001c10a000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:805000
page:ffffea001c118000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:805400
page:ffffea001c126000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:805800
page:ffffea001c134000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:805c00
page:ffffea001c142000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:806000
page:ffffea001c150000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:806400
page:ffffea001c15e000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:806800
page:ffffea001c16c000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:806c00
page:ffffea001c17a000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:807000
page:ffffea001c188000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:807400
page:ffffea001c196000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:807800
page:ffffea001c1a4000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:807c00
page:ffffea001c1b2000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:808000
page:ffffea001c1c0000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:808400
page:ffffea001c1ce000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:808800
page:ffffea001c1dc000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:808c00
page:ffffea001c1ea000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:809000
page:ffffea001c1f8000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:809400
page:ffffea001c206000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:809800
page:ffffea001c214000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:809c00
page:ffffea001c222000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80a000
page:ffffea001c230000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80a400
page:ffffea001c23e000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80a800
page:ffffea001c24c000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80ac00
page:ffffea001c25a000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80b000
page:ffffea001c268000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80b400
page:ffffea001c276000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80b800
page:ffffea001c284000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80bc00
page:ffffea001c292000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80c000
page:ffffea001c2a0000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80c400
page:ffffea001c2ae000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80c800
page:ffffea001c2bc000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80cc00
page:ffffea001c2ca000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80d000
page:ffffea001c2d8000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80d400
page:ffffea001c2e6000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80d800
page:ffffea001c2f4000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80dc00
page:ffffea001c302000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80e000
page:ffffea001c310000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80e400
page:ffffea001c31e000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80e800
page:ffffea001c32c000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
BUG: Bad page state in process swapper  pfn:80ec00
page:ffffea001c33a000 count:0 mapcount:0 mapping:(null) index:0x0
page flags: 0x60000000080000(buddy)
Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff810a590f>] ? dump_page+0xc7/0xcc
 [<ffffffff810a61d8>] bad_page+0xeb/0xfd
 [<ffffffff810a6a27>] free_pages_prepare+0x68/0xa3
 [<ffffffff810a7a39>] __free_pages_ok+0x1d/0xf6
 [<ffffffff810a7cf8>] __free_pages+0x22/0x24
 [<ffffffff816c7871>] __free_pages_bootmem+0x55/0x57
 [<ffffffff816a7b48>] free_all_memory_core_early+0xeb/0x156
 [<ffffffff816a07a7>] numa_free_all_bootmem+0x7f/0x8b
 [<ffffffff81398dbc>] ? _etext+0x0/0x24
 [<ffffffff8169f5ea>] mem_init+0x1e/0xec
 [<ffffffff81689bea>] start_kernel+0x1c8/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
Memory: 97544788k/69206016k available (3683k kernel code, 2116928k absent, -32553696k reserved, 2920k data, 2232k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=12, Nodes=2
Hierarchical RCU implementation.
        RCU-based detection of stalled CPUs is disabled.
NR_IRQS:262400 nr_irqs:1184
Extended CMOS year: 2000
Console: colour dummy device 80x25
console [ttyS0] enabled, bootconsole disabled
console [ttyS0] enabled, bootconsole disabled
Fast TSC calibration using PIT
Detected 2666.999 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.99 BogoMIPS (lpj=10667996)
pid_max: default: 32768 minimum: 301
general protection fault: 0000 [#1] SMP
last sysfs file:
CPU 0
Modules linked in:

Pid: 0, comm: swapper Tainted: G    B       2.6.36-rc6-next-20101006-medusa #23 /Stoutland Platform
RIP: 0010:[<ffffffff810a5557>]  [<ffffffff810a5557>] __rmqueue+0x7c/0x311
RSP: 0000:ffffffff816019b8  EFLAGS: 00010002
RAX: dead000000200200 RBX: dead000000200200 RCX: ffffea0037fe4e28
RDX: dead000000100100 RSI: ffff880ffffda010 RDI: 0000000000000006
RBP: ffffffff816019f8 R08: 0000000000000001 R09: ffff880ffffda078
R10: 0000000000000000 R11: 0000000000000000 R12: dead000000100100
R13: ffffea0037fe4e00 R14: 0000000000000286 R15: ffff880ffffd9e00
FS:  0000000000000000(0000) GS:ffff880075c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001604000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81600000, task ffffffff8160c020)
Stack:
 0000000000000000 ffff880ffffd9e00 0000000000000000 ffffea0037fe5bf0
<0> ffff880075c16158 0000000000000003 0000000000000286 ffff880ffffd9e00
<0> ffffffff81601b28 ffffffff810a81d4 ffff88107ffd8e00 ffffffff81600000
Call Trace:
 [<ffffffff810a81d4>] get_page_from_freelist+0x2f7/0x787
 [<ffffffff810a6bd7>] ? zone_watermark_ok+0x25/0xb8
 [<ffffffff810a8a3c>] __alloc_pages_nodemask+0x160/0x6ac
 [<ffffffff810a8a3c>] ? __alloc_pages_nodemask+0x160/0x6ac
 [<ffffffff811d7f2b>] ? cpumask_next_and+0x2d/0x3e
 [<ffffffff810d2aa2>] alloc_page_interleave+0x36/0x80
 [<ffffffff810d2bcf>] alloc_pages_current+0x7c/0xd1
 [<ffffffff8102f1f9>] __change_page_attr_set_clr+0x75f/0xc1f
 [<ffffffff810c8635>] ? vm_unmap_aliases+0x179/0x188
 [<ffffffff8102f830>] change_page_attr_set_clr+0x177/0x3ed
 [<ffffffff8102fe40>] ? set_memory_nx+0x3b/0x3d
 [<ffffffff8102fc2a>] set_memory_x+0x3b/0x3d
 [<ffffffff8169931b>] efi_enter_virtual_mode+0x22a/0x269
 [<ffffffff81689d99>] start_kernel+0x377/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d
Code: 0f 84 a9 00 00 00 48 8b 4c 0a 68 49 bc 00 01 10 00 00 00 ad de 48 bb 00 02 20 00 00 00 ad de 4c 8d 69 d8 49 8b 55 28 49 8b 45 30 <48> 89 42 08 48 89 10 4d 89 65 28 49 89 5d 30 0f ba 71 d8 13 b8
RIP  [<ffffffff810a5557>] __rmqueue+0x7c/0x311
 RSP <ffffffff816019b8>
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Pid: 0, comm: swapper Tainted: G    B D     2.6.36-rc6-next-20101006-medusa #23
Call Trace:
 [<ffffffff81393b39>] panic+0x8c/0x1aa
 [<ffffffff8104ba30>] do_exit+0x78/0x74f
 [<ffffffff813961ff>] ? _raw_spin_unlock_irqrestore+0x35/0x37
 [<ffffffff81049224>] ? kmsg_dump+0x16f/0x189
 [<ffffffff81006c53>] oops_end+0xc8/0xd0
 [<ffffffff81006e66>] die+0x55/0x5e
 [<ffffffff81004a28>] do_general_protection+0x13e/0x146
 [<ffffffff813968b5>] general_protection+0x25/0x30
 [<ffffffff810a5557>] ? __rmqueue+0x7c/0x311
 [<ffffffff810a6bd7>] ? zone_watermark_ok+0x25/0xb8
 [<ffffffff810a81d4>] get_page_from_freelist+0x2f7/0x787
 [<ffffffff810a6bd7>] ? zone_watermark_ok+0x25/0xb8
 [<ffffffff810a8a3c>] __alloc_pages_nodemask+0x160/0x6ac
 [<ffffffff810a8a3c>] ? __alloc_pages_nodemask+0x160/0x6ac
 [<ffffffff811d7f2b>] ? cpumask_next_and+0x2d/0x3e
 [<ffffffff810d2aa2>] alloc_page_interleave+0x36/0x80
 [<ffffffff810d2bcf>] alloc_pages_current+0x7c/0xd1
 [<ffffffff8102f1f9>] __change_page_attr_set_clr+0x75f/0xc1f
 [<ffffffff810c8635>] ? vm_unmap_aliases+0x179/0x188
 [<ffffffff8102f830>] change_page_attr_set_clr+0x177/0x3ed
 [<ffffffff8102fe40>] ? set_memory_nx+0x3b/0x3d
 [<ffffffff8102fc2a>] set_memory_x+0x3b/0x3d
 [<ffffffff8169931b>] efi_enter_virtual_mode+0x22a/0x269
 [<ffffffff81689d99>] start_kernel+0x377/0x3ea
 [<ffffffff81689140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816892af>] x86_64_start_reservations+0xb6/0xba
 [<ffffffff81689401>] x86_64_start_kernel+0x14e/0x15d

--NzB8fVQJ5HfG6fxh--
