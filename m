Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0FNBzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 21:55:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59896 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0FNBzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 21:55:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C158BCF.6000303@jp.fujitsu.com>
Date: Mon, 14 Jun 2010 10:54:23 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com> <4C11FFC0.1030006@jp.fujitsu.com> <4C1275BF.3070605@zytor.com>
In-Reply-To: <4C1275BF.3070605@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/12 2:43), H. Peter Anvin wrote:
> On 06/11/2010 02:20 AM, Kenji Kaneshige wrote:
>> If the physical address is too high to be handled by ioremap() in
>> x86_32 PAE (e.g. more than 36-bit physical address), ioremap() must
>> return error (NULL). However, current x86 ioremap try to map this too
>> high physical address, and it causes unexpected behavior.
>
> What unexpected behavior?

My expectation:
The ioremap() function returns NULL if the specified physical address
is too high to handle.

Actual result (unexpected behavior):
Kernel hangup. This happens even with [PATCH 1/4] applied. I'm attaching
the console log messages at the bottom of this e-mail.

>                           It is perfectly legitimately to map such a
> high address in PAE mode.  We have a 36-bit kernel-imposed limit on
> *RAM* in 32-bit mode (because we can't manage more than that), but there
> is no reason it should apply to I/O.
>

Do you mean x86 linux can map physical address higher than 36-bit for I/O?
My understanding is as follows.
- Architectural limit of physical address in x86 32-bit mode is 40-bit
   (depnds on processor version).
- The maximum physical address supported by current x86 linux kernel in
   32-bit mode is 36-bit.
On my environment, physical address higher than 40-bit (ex. 0xfc00001c000)
is assigned to some PCI devices. I think there is no way to handle such
high physical address in 32-bit mode.

Thanks,
Kenji Kaneshige

======================================================================
Console Messages (2.6.34 + [PATCH 1/4] applied) after modprobe ioatdma
======================================================================
ioatdma: Intel(R) QuickData Technology Driver 4.00
ioatdma 0000:00:16.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ioatdma 0000:00:16.0: setting latency timer to 64
modprobe:5619 freeing invalid memtype 1c000-20000
ioatdma 0000:00:16.0: PCI INT A disabled
ioatdma 0000:00:16.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ioatdma 0000:00:16.1: setting latency timer to 64
ioatdma 0000:00:16.1: (26) exceeds max supported channels (4)
ioatdma 0000:00:16.1: channel enumeration error
ioatdma 0000:00:16.1: Intel(R) I/OAT DMA Engine init failed
modprobe:5619 freeing invalid memtype 18000-1c000
ioatdma 0000:00:16.1: PCI INT B disabled
ioatdma 0000:00:16.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ioatdma 0000:00:16.2: setting latency timer to 64
ioatdma 0000:00:16.2: (20) exceeds max supported channels (4)
   alloc irq_desc for 80 on node -1
   alloc kstat_irqs on node -1
ioatdma 0000:00:16.2: irq 80 for MSI/MSI-X
BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:5619]
Modules linked in: ioatdma(+) autofs4 sunrpc cpufreq_ondemand acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_mod e1000e igb iTCO_wdt dca sg iTCO_vendor_support i2c_i801 i2c_core pcspkr ext4 mbcache jbd2 sd_mod crc_t10dif mptsas mptscsih lpfc scsi_transport_fc mptbase scsi_tgt scsi_transport_sas [last unloaded: microcode]
Modules linked in: ioatdma(+) autofs4 sunrpc cpufreq_ondemand acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_mod e1000e igb iTCO_wdt dca sg iTCO_vendor_support i2c_i801 i2c_core pcspkr ext4 mbcache jbd2 sd_mod crc_t10dif mptsas mptscsih lpfc scsi_transport_fc mptbase scsi_tgt scsi_transport_sas [last unloaded: microcode]

Pid: 5619, comm: modprobe Not tainted 2.6.34-kk #20 SB/PRIMEQUEST 1800E
EIP: 0060:[<c07ed5e8>] EFLAGS: 00000202 CPU: 0
EIP is at _raw_spin_lock_bh+0x18/0x20
EAX: e3608000 EBX: e305fb5c ECX: 0000007d EDX: 00000001
ESI: 0000007d EDI: e305fa94 EBP: e3609d18 ESP: e3609ccc
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process modprobe (pid: 5619, ti=e3608000 task=e167fab0 task.ti=e3608000)
Stack:
  e305fa94 fe577cc6 205f9002 00000000 c05e5377 000fffff 01000000 00000257
<0> e3f25240 fffff000 0000ffff 00000001 00000001 e3609dae 000fffff e305fb5c
<0> ffffe000 00000000 e305fa94 e3609dbc fe578512 205f9000 00000000 e34e0c00
Call Trace:
  [<fe577cc6>] ? ioat2_alloc_and_lock+0x26/0x280 [ioatdma]
  [<c05e5377>] ? __domain_mapping+0x177/0x260
  [<fe578512>] ? ioat2_dma_prep_memcpy_lock+0x52/0x3c0 [ioatdma]
  [<c05e7339>] ? __intel_map_single+0x169/0x230
  [<c05e7456>] ? intel_map_page+0x56/0x70
  [<fe575762>] ? dma_map_single_attrs.clone.1+0x62/0x80 [ioatdma]
  [<fe57cd29>] ? ioat_dma_self_test+0xf4/0x248 [ioatdma]
  [<c049c048>] ? devm_request_threaded_irq+0x78/0xa0
  [<fe57da6c>] ? ioat3_dma_self_test+0x8/0x16 [ioatdma]
  [<fe57cb1c>] ? ioat_probe+0x2d7/0x343 [ioatdma]
  [<fe57d092>] ? ioat3_dma_probe+0x145/0x1d1 [ioatdma]
  [<fe57c7e0>] ? ioat_pci_probe+0x14b/0x181 [ioatdma]
  [<c05cd92b>] ? local_pci_probe+0xb/0x10
  [<c05ce937>] ? pci_device_probe+0xc7/0xf0
  [<c0672d17>] ? driver_probe_device+0x87/0x290
  [<c05cd9d0>] ? pci_match_device+0x10/0xb0
  [<c0672f99>] ? __driver_attach+0x79/0x80
  [<c0672f20>] ? __driver_attach+0x0/0x80
  [<c0672112>] ? bus_for_each_dev+0x52/0x80
  [<c0672b06>] ? driver_attach+0x16/0x20
  [<c0672f20>] ? __driver_attach+0x0/0x80
  [<c06724bf>] ? bus_add_driver+0x1cf/0x320
  [<c05ce810>] ? pci_device_remove+0x0/0x40
  [<c0673223>] ? driver_register+0x63/0x120
  [<fe584000>] ? ioat_init_module+0x0/0x79 [ioatdma]
  [<c05ceb5d>] ? __pci_register_driver+0x3d/0xb0
  [<fe584062>] ? ioat_init_module+0x62/0x79 [ioatdma]
  [<c040112f>] ? do_one_initcall+0x2f/0x1c0
  [<c047bb23>] ? sys_init_module+0xb3/0x220
  [<c07ee2f0>] ? do_device_not_available+0x0/0x60
  [<c07ee335>] ? do_device_not_available+0x45/0x60
  [<c0402f1f>] ? sysenter_do_call+0x12/0x28


