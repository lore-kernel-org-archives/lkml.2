Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2KINTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:19:16 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:59002 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472Ab2KINTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:19:14 -0500
Message-ID: <1352467148.1895.20.camel@x61.thuisdomein>
Subject: mfd: lpc_ich: NULL pointer dereference at (second) module removal
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 09 Nov 2012 14:19:08 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Nov 2012 13:19:08.0835 (UTC) FILETIME=[CD02D730:01CDBE7C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) I can trigger a NULL pointer dereference if I remove the lpc_ich
module. This seems to only happen if I remove it for the second time
(ie, remove the module, insert it and remove it again). This happens
both on i686 and x86_64 (different setups, as inserting the module
triggers different messages about the initialization of the MFD cells on
these machines). Both machines are running v3.6.6.

1) On x86_64 the Oops looks like this:
[...]
<6>[11783.359637] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
<6>[11783.360477] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<4>[11783.360492] ACPI Warning: 0x0000000000001028-0x000000000000102f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20120711/utaddress-251)
<6>[11783.360498] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[11783.360503] ACPI Warning: 0x0000000000001180-0x00000000000011bf SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20120711/utaddress-251)
<6>[11783.360507] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[11783.360509] lpc_ich: Resource conflict(s) found affecting gpio_ich
[modprobe -r lcp_ich must have been done in these two seconds]
<1>[11785.617128] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
<1>[11785.617181] IP: [<ffffffffa01ad09d>] mfd_remove_devices_fn+0x1d/0x40 [mfd_core]
<4>[11785.617222] PGD 22c787067 PUD 1b52e3067 PMD 0 
<4>[11785.617256] Oops: 0000 [#1] SMP 
<4>[11785.617282] Modules linked in: lpc_ich(-) mfd_core fuse rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables btusb bluetooth snd_hda_codec_analog iTCO_wdt iTCO_vendor_support arc4 ppdev coretemp kvm_intel kvm snd_hda_intel microcode snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm pcspkr i2c_i801 iwl4965 iwlegacy mac80211 cfg80211 snd_page_alloc snd_timer e1000e thinkpad_acpi parport_pc snd parport soundcore rfkill uinput firewire_ohci sdhci_pci sdhci mmc_core firewire_core crc_itu_t yenta_socket i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: mfd_core]
<4>[11785.617753] CPU 1 
<4>[11785.617767] Pid: 4597, comm: modprobe Not tainted 3.6.6-0.rc1.1.local0.fc17.x86_64 #1 LENOVO 76735GG/76735GG
<4>[11785.617818] RIP: 0010:[<ffffffffa01ad09d>]  [<ffffffffa01ad09d>] mfd_remove_devices_fn+0x1d/0x40 [mfd_core]
<4>[11785.617866] RSP: 0018:ffff8801b53a9d38  EFLAGS: 00010246
<4>[11785.617894] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000016
<4>[11785.617927] RDX: 0000000000000000 RSI: ffff8801b53a9d90 RDI: ffff8802125e13f0
<4>[11785.617961] RBP: ffff8801b53a9d38 R08: 0000000000000000 R09: 0000000000000000
<4>[11785.617994] R10: ffffffff811fcc7b R11: ffffffff811fcca8 R12: ffff8801b53a9d90
<4>[11785.618035] R13: ffffffffa01ad080 R14: ffffffffa04d9000 R15: 0000000000000000
<4>[11785.618073] FS:  00007ff464170740(0000) GS:ffff88023bd00000(0000) knlGS:0000000000000000
<4>[11785.618073] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[11785.618073] CR2: 0000000000000010 CR3: 00000001b536b000 CR4: 00000000000007e0
<4>[11785.618073] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[11785.618073] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[11785.618073] Process modprobe (pid: 4597, threadinfo ffff8801b53a8000, task ffff880210c2ae20)
<4>[11785.618073] Stack:
<4>[11785.618073]  ffff8801b53a9d78 ffffffff813b9956 ffff880230253f00 ffff880217523028
<4>[11785.618073]  ffffffff81a1876e ffff8802302cc000 ffffffffa04d9000 ffff8802302cc000
<4>[11785.618073]  ffff8801b53a9d98 ffffffffa01ad075 ffff8801b53a9db8 0000000000000000
<4>[11785.618073] Call Trace:
<4>[11785.618073]  [<ffffffff813b9956>] device_for_each_child+0x36/0x70
<4>[11785.618073]  [<ffffffffa01ad075>] mfd_remove_devices+0x25/0x30 [mfd_core]
<4>[11785.618073]  [<ffffffffa04d63c8>] lpc_ich_remove+0x15/0x21 [lpc_ich]
<4>[11785.618073]  [<ffffffff812ff4af>] pci_device_remove+0x3f/0x110
<4>[11785.618073]  [<ffffffff813bda4c>] __device_release_driver+0x7c/0xe0
<4>[11785.618073]  [<ffffffff813be618>] driver_detach+0xb8/0xc0
<4>[11785.618073]  [<ffffffff813bd882>] bus_remove_driver+0x92/0x110
<4>[11785.618073]  [<ffffffff813beb12>] driver_unregister+0x62/0xa0
<4>[11785.618073]  [<ffffffff812fe9a4>] pci_unregister_driver+0x44/0xa0
<4>[11785.618073]  [<ffffffffa04d63e4>] lpc_ich_exit+0x10/0xc2c [lpc_ich]
<4>[11785.618073]  [<ffffffff810bc9ae>] sys_delete_module+0x16e/0x2d0
<4>[11785.618073]  [<ffffffff8107ba40>] ? task_work_run+0x30/0x90
<4>[11785.618073]  [<ffffffff810d718c>] ? __audit_syscall_entry+0xcc/0x300
<4>[11785.618073]  [<ffffffff81621929>] system_call_fastpath+0x16/0x1b
<4>[11785.618073] Code: c8 20 e1 48 8b 7d f8 e8 62 a0 fc e0 c9 c3 55 48 89 e5 66 66 66 66 90 48 89 f8 48 8d 7f f0 48 8b 90 a0 02 00 00 48 8b 06 48 85 c0 <48> 8b 52 10 74 05 48 39 d0 76 03 48 89 16 e8 e0 31 21 e1 31 c0 
<1>[11785.618073] RIP  [<ffffffffa01ad09d>] mfd_remove_devices_fn+0x1d/0x40 [mfd_core]
<4>[11785.618073]  RSP <ffff8801b53a9d38>
<4>[11785.618073] CR2: 0000000000000010
<4>[11786.188559] ---[ end trace 52236a6f1bf2e1e5 ]---
[...]

(Note that v3.6.6-rc1 should be identical to v3.6.6.)

2) Poking at mfd-core.o with gdb learns us:
$ gdb mfd-core.o
Reading symbols from [...]/drivers/mfd/mfd-core.o...done.
(gdb) disassemble /m mfd_remove_devices_fn
Dump of assembler code for function mfd_remove_devices_fn:
[...]
208		const struct mfd_cell *cell = mfd_get_cell(pdev);
209		atomic_t **usage_count = c;
210	
211		/* find the base address of usage_count pointers (for freeing) */
212		if (!*usage_count || (cell->usage_count < *usage_count))
   0x0000000000000097 <+23>:	mov    (%rsi),%rax
   0x000000000000009a <+26>:	test   %rax,%rax
   0x000000000000009d <+29>:	mov    0x10(%rdx),%rdx
   0x00000000000000a1 <+33>:	je     0xa8 <mfd_remove_devices_fn+40>
   0x00000000000000a3 <+35>:	cmp    %rdx,%rax
   0x00000000000000a6 <+38>:	jbe    0xab <mfd_remove_devices_fn+43>
[...]
(gdb) printf "0x%0x\n", (size_t) &((struct mfd_cell *)0)->usage_count
0x10

3) So to me it looks like "cell" is NULL here, and we oops when we're
trying to access "cell->usage_count" (which will then be at offset
0x10). I have no idea how this can happen.

4) Side note: why does the kernel print offsets in hex and gdb in
decimal? (Of course, here it's trivial to realize that 0x1d is 29.)


Paul Bolle

