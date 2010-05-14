Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0ENO4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:56:25 -0400
Received: from mail.codelabs.ch ([217.150.249.120]:34181 "EHLO
	fenrir.codelabs.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0ENO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:56:23 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 May 2010 10:56:22 EDT
Message-ID: <4BED6318.6060105@codelabs.ch>
Date: Fri, 14 May 2010 16:50:00 +0200
From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: michael-dev@fami-braun.de, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [BUG] SLOB breaks Crypto
References: <4B9E38AF.70309@fami-braun.de> <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com> <4BA29A19.2050307@fami-braun.de> <20100319003351.GC20227@gondor.apana.org.au>
In-Reply-To: <20100319003351.GC20227@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Herbert Xu wrote:
> On Thu, Mar 18, 2010 at 10:24:41PM +0100, michael-dev@fami-braun.de wrote:
>> Pekka Enberg schrieb:
>>> Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
>>> CONFIG_SLUB_DEBUG_ON?
>> no, these options have not been / are not enabled.
> 
> Can you please try it with those options enabled? That will tell
> us if there is some latent bug in the crypto layer that only shows
> up right away under SLOB.

I was able reproduced the issue with the current crypto-2.6 tree 180ce7e...

The issue does not show up with CONFIG_DEBUG_SLAB nor CONFIG_SLUB and
CONFIG_SLUB_DEBUG_ON. It seems the issues is really related to hmac.
Loading tcrypt with modes not using hmac seem to run fine. During my
tests the system freezes eventually when doing multiple modprobes of
tcrypt like this:

modprobe tcrypt mode=100

I get multiple OOPses with a subsequent panic looking like this:

[  409.631551] BUG: unable to handle kernel NULL pointer dereference at
00000090
[  409.631645] IP: [<f883a278>] hmac_setkey+0x38/0x140 [hmac]
[  409.631705] *pde = 00000000
[  409.631757] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  409.631857] last sysfs file: /sys/class/power_supply/AC/online
[  409.631891] Modules linked in: tcrypt(+) hmac netconsole loop
ide_cd_mod cdrom ide_pci_generic ehci_hcd uhci_hcd piix usbcore [last
unloaded: scsi_wait_scan]
[  409.632019]
[  409.632019] Pid: 5184, comm: modprobe Not tainted 2.6.33-g180ce7e #5
      /Latitude D600
[  409.632019] EIP: 0060:[<f883a278>] EFLAGS: 00010282 CPU: 0
[  409.632019] EIP is at hmac_setkey+0x38/0x140 [hmac]
[  409.632019] EAX: e0254734 EBX: e025476c ECX: 00000090 EDX: e0254820
[  409.632019] ESI: 00000040 EDI: e02547c4 EBP: e1dc3cb4 ESP: e1dc3c94
[  409.632019]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  409.632019] Process modprobe (pid: 5184, ti=e1dc2000 task=e538b000
task.ti=e1dc2000)
[  409.632019] Stack:
[  409.632019]  e0254668 e0254820 00000010 c043a348 00000010 e538b87c
c043a348
[  409.632019] <0> e1dc3cd8 c020f3d6 00000010 e0254734 e538b87c c04945b4
e1e47000 00000000
[  409.632019] <0> c043a348 e1dc3ce0 c020f3fb e1dc3d00 c020eb4b 00000010
ebe26380 00000008
[  409.632019] Call Trace:
[  409.632019]  [<c020f3d6>] ? crypto_shash_setkey+0x96/0xa0
[  409.632019]  [<c020f3fb>] ? shash_async_setkey+0xb/0x10
[  409.632019]  [<c020eb4b>] ? crypto_ahash_setkey+0x8b/0x90
[  409.632019]  [<c0211056>] ? test_hash+0x176/0x620
[  409.632019]  [<c012a754>] ? _local_bh_enable+0x24/0x80
[  409.632019]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  409.632019]  [<c0186fce>] ? slob_page_alloc+0x20e/0x240
[  409.632019]  [<c018758d>] ? slob_alloc+0x10d/0x1f0
[  409.632019]  [<c0187791>] ? __kmalloc_node+0xa1/0xc0
[  409.632019]  [<c02095e1>] ? crypto_create_tfm+0x41/0xc0
[  409.632019]  [<c020a77a>] ? crypto_spawn_tfm2+0x3a/0x60
[  409.632019]  [<f883a4f6>] ? hmac_init_tfm+0x26/0x5c [hmac]
[  409.632019]  [<c0209620>] ? crypto_create_tfm+0x80/0xc0
[  409.632019]  [<c0211535>] ? alg_test_hash+0x35/0x70
[  409.632019]  [<c021320f>] ? alg_find_test+0x3f/0x70
[  409.632019]  [<c0213299>] ? alg_test+0x59/0x180
[  409.632019]  [<f8865a55>] ? do_test+0xec5/0x14ec [tcrypt]
[  409.632019]  [<f886a0c1>] ? tcrypt_mod_init+0xc1/0xce [tcrypt]
[  409.632019]  [<f886a000>] ? tcrypt_mod_init+0x0/0xce [tcrypt]
[  409.632019]  [<c0101023>] ? do_one_initcall+0x23/0x170
[  409.632019]  [<c013f7fa>] ? blocking_notifier_call_chain+0x1a/0x20
[  409.632019]  [<c0151a02>] ? sys_init_module+0xb2/0x220
[  409.632019]  [<c017c974>] ? sys_mmap_pgoff+0xe4/0xf0
[  409.632019]  [<c0102ad0>] ? sysenter_do_call+0x12/0x26
[  409.632019] Code: 55 ec 8b 50 34 8d 4a d4 8b 72 14 8b 59 24 89 5d f0
8b 52 1c 8b 49 28 8d 10 38 f7 d2 21 d3 8d 3c 0b 8d 54 0f 07 83 e2 f8 8b
0a <8b> 11 83 c2 0f 83 e2 f8 83 c2 10 29 d4 8d 54 24 13 83 e2 f0 89
[  409.632019] EIP: [<f883a278>] hmac_setkey+0x38/0x140 [hmac] SS:ESP
0068:e1dc3c94
[  409.632019] CR2: 0000000000000090
[  474.594010] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:5184]
[  474.594010] Modules linked in: tcrypt(+) hmac netconsole loop
ide_cd_mod cdrom ide_pci_generic ehci_hcd uhci_hcd piix usbcore [last
unloaded: scsi_wait_scan]
[  474.594010] Modules linked in: tcrypt(+) hmac netconsole loop
ide_cd_mod cdrom ide_pci_generic ehci_hcd uhci_hcd piix usbcore [last
unloaded: scsi_wait_scan]
[  474.594010]
[  474.594010] Pid: 5184, comm: modprobe Tainted: G      D
2.6.33-g180ce7e #5       /Latitude D600
[  474.594010] EIP: 0060:[<c01180f0>] EFLAGS: 00000246 CPU: 0
[  474.594010] EIP is at __bad_area_nosemaphore+0x20/0x180
[  474.594010] EAX: e538b000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[  474.594010] ESI: e1dc39f0 EDI: 00000000 EBP: e1dc39a8 ESP: e1dc38f8
[  474.594010]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  474.594010] Process modprobe (pid: 5184, ti=e1dc2000 task=e538b000
task.ti=e1dc2000)
[  474.594010] Stack:
[  474.594010]  c0104c8e e1dc3920 e1dc3920 00000000 e1dc3920 c0105e5f
[  474.594010] <0> e538b000 c048dde0 e1dc3934 c0157bbd 0000193c c048dde0
00000000 e1dc394c
[  474.594010] <0> c0104784 e1dc3980 e1dc3980 e1dc394c c012aaaa e1dc3978
c01042a2 0000006e
[  474.594010] Call Trace:
[  474.594010]  [<c0104c8e>] ? timer_interrupt+0x1e/0x60
[  474.594010]  [<c0155be6>] ? handle_IRQ_event+0x36/0xd0
[  474.594010]  [<c0105c6d>] ? mask_and_ack_8259A+0x7d/0x110
[  474.594010]  [<c0105e5f>] ? enable_8259A_irq+0x4f/0x70
[  474.594010]  [<c0157bbd>] ? handle_level_irq+0x10d/0x130
[  474.594010]  [<c0104784>] ? handle_irq+0x34/0x60
[  474.594010]  [<c012aaaa>] ? irq_exit+0x5a/0x90
[  474.594010]  [<c01042a2>] ? do_IRQ+0x42/0xb0
[  474.594010]  [<c0102fe9>] ? common_interrupt+0x29/0x30
[  474.594010]  [<c0118262>] ? bad_area_nosemaphore+0x12/0x20
[  474.594010]  [<c011862c>] ? do_page_fault+0x23c/0x2e0
[  474.594010]  [<c01042a2>] ? do_IRQ+0x42/0xb0
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c03838fe>] ? error_code+0x5e/0x64
[  474.594010]  [<c0150000>] ? load_module+0x280/0x1890
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c015928c>] ? __rcu_process_callbacks+0xdc/0x410
[  474.594010]  [<c01595d2>] ? rcu_process_callbacks+0x12/0x30
[  474.594010]  [<c012a827>] ? __do_softirq+0x77/0x100
[  474.594010]  [<c0105c5b>] ? mask_and_ack_8259A+0x6b/0x110
[  474.594010]  [<c0105e5f>] ? enable_8259A_irq+0x4f/0x70
[  474.594010]  [<c012a8dd>] ? do_softirq+0x2d/0x40
[  474.594010]  [<c012aabd>] ? irq_exit+0x6d/0x90
[  474.594010]  [<c01042a2>] ? do_IRQ+0x42/0xb0
[  474.594010]  [<c0102fe9>] ? common_interrupt+0x29/0x30
[  474.594010]  [<c0120000>] ? proc_sched_show_task+0x1f0/0x600
[  474.594010]  [<c010571b>] ? oops_end+0x4b/0xb0
[  474.594010]  [<c011802e>] ? no_context+0xbe/0x160
[  474.594010]  [<c011811f>] ? __bad_area_nosemaphore+0x4f/0x180
[  474.594010]  [<c0287a53>] ? extract_buf+0x73/0xc0
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c01182aa>] ? bad_area+0x3a/0x50
[  474.594010]  [<c0118685>] ? do_page_fault+0x295/0x2e0
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c03838fe>] ? error_code+0x5e/0x64
[  474.594010]  [<c018007b>] ? pcpu_get_vm_areas+0x4cb/0x500
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<f883a278>] ? hmac_setkey+0x38/0x140 [hmac]
[  474.594010]  [<c020f3d6>] ? crypto_shash_setkey+0x96/0xa0
[  474.594010]  [<c020f3fb>] ? shash_async_setkey+0xb/0x10
[  474.594010]  [<c020eb4b>] ? crypto_ahash_setkey+0x8b/0x90
[  474.594010]  [<c0211056>] ? test_hash+0x176/0x620
[  474.594010]  [<c012a754>] ? _local_bh_enable+0x24/0x80
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c018758d>] ? slob_alloc+0x10d/0x1f0
[  474.594010]  [<c0187791>] ? __kmalloc_node+0xa1/0xc0
[  474.594010]  [<c02095e1>] ? crypto_create_tfm+0x41/0xc0
[  474.594010]  [<c020a77a>] ? crypto_spawn_tfm2+0x3a/0x60
[  474.594010]  [<f883a4f6>] ? hmac_init_tfm+0x26/0x5c [hmac]
[  474.594010]  [<c0209620>] ? crypto_create_tfm+0x80/0xc0
[  474.594010]  [<c0211535>] ? alg_test_hash+0x35/0x70
[  474.594010]  [<c021320f>] ? alg_find_test+0x3f/0x70
[  474.594010]  [<c0213299>] ? alg_test+0x59/0x180
[  474.594010]  [<f8865a55>] ? do_test+0xec5/0x14ec [tcrypt]
[  474.594010]  [<f886a0c1>] ? tcrypt_mod_init+0xc1/0xce [tcrypt]
[  474.594010]  [<f886a000>] ? tcrypt_mod_init+0x0/0xce [tcrypt]
[  474.594010]  [<c0101023>] ? do_one_initcall+0x23/0x170
[  474.594010]  [<c013f7fa>] ? blocking_notifier_call_chain+0x1a/0x20
[  474.594010]  [<c0151a02>] ? sys_init_module+0xb2/0x220
[  474.594010]  [<c017c974>] ? sys_mmap_pgoff+0xe4/0xf0
[  474.594010]  [<c0102ad0>] ? sysenter_do_call+0x12/0x26
[  474.594010] Code: 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 81 ec b0
00 00 00 89 75 f8 89 c6 a1 98 80 48 c0 f6 c2 04 89 5d f4 89 cb 89 7d fc
89 d7 <89> 85 70 ff ff ff 74 20 fb 89 f0 e8 80 fc ff ff 74 24 8b
[  474.594010] Call Trace:
[  474.594010]  [<c0104c8e>] ? timer_interrupt+0x1e/0x60
[  474.594010]  [<c0155be6>] ? handle_IRQ_event+0x36/0xd0
[  474.594010]  [<c0105c6d>] ? mask_and_ack_8259A+0x7d/0x110
[  474.594010]  [<c0105e5f>] ? enable_8259A_irq+0x4f/0x70
[  474.594010]  [<c0157bbd>] ? handle_level_irq+0x10d/0x130
[  474.594010]  [<c0104784>] ? handle_irq+0x34/0x60
[  474.594010]  [<c012aaaa>] ? irq_exit+0x5a/0x90
[  474.594010]  [<c01042a2>] ? do_IRQ+0x42/0xb0
[  474.594010]  [<c0102fe9>] ? common_interrupt+0x29/0x30
[  474.594010]  [<c0118262>] bad_area_nosemaphore+0x12/0x20
[  474.594010]  [<c011862c>] do_page_fault+0x23c/0x2e0
[  474.594010]  [<c01042a2>] ? do_IRQ+0x42/0xb0
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c03838fe>] error_code+0x5e/0x64
[  474.594010]  [<c0150000>] ? load_module+0x280/0x1890
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c015928c>] ? __rcu_process_callbacks+0xdc/0x410
[  474.594010]  [<c01595d2>] rcu_process_callbacks+0x12/0x30
[  474.594010]  [<c012a827>] __do_softirq+0x77/0x100
[  474.594010]  [<c0105c5b>] ? mask_and_ack_8259A+0x6b/0x110
[  474.594010]  [<c0105e5f>] ? enable_8259A_irq+0x4f/0x70
[  474.594010]  [<c012a8dd>] do_softirq+0x2d/0x40
[  474.594010]  [<c012aabd>] irq_exit+0x6d/0x90
[  474.594010]  [<c01042a2>] do_IRQ+0x42/0xb0
[  474.594010]  [<c0102fe9>] common_interrupt+0x29/0x30
[  474.594010]  [<c0120000>] ? proc_sched_show_task+0x1f0/0x600
[  474.594010]  [<c010571b>] ? oops_end+0x4b/0xb0
[  474.594010]  [<c011802e>] no_context+0xbe/0x160
[  474.594010]  [<c011811f>] __bad_area_nosemaphore+0x4f/0x180
[  474.594010]  [<c0287a53>] ? extract_buf+0x73/0xc0
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c01182aa>] bad_area+0x3a/0x50
[  474.594010]  [<c0118685>] do_page_fault+0x295/0x2e0
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c03838fe>] error_code+0x5e/0x64
[  474.594010]  [<c018007b>] ? pcpu_get_vm_areas+0x4cb/0x500
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<f883a278>] ? hmac_setkey+0x38/0x140 [hmac]
[  474.594010]  [<c020f3d6>] crypto_shash_setkey+0x96/0xa0
[  474.594010]  [<c020f3fb>] shash_async_setkey+0xb/0x10
[  474.594010]  [<c020eb4b>] crypto_ahash_setkey+0x8b/0x90
[  474.594010]  [<c0211056>] test_hash+0x176/0x620
[  474.594010]  [<c012a754>] ? _local_bh_enable+0x24/0x80
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c0186fce>] ? slob_page_alloc+0x20e/0x240
[  474.594010]  [<c018758d>] ? slob_alloc+0x10d/0x1f0
[  474.594010]  [<c0187791>] ? __kmalloc_node+0xa1/0xc0
[  474.594010]  [<c02095e1>] ? crypto_create_tfm+0x41/0xc0
[  474.594010]  [<c020a77a>] ? crypto_spawn_tfm2+0x3a/0x60
[  474.594010]  [<f883a4f6>] ? hmac_init_tfm+0x26/0x5c [hmac]
[  474.594010]  [<c0209620>] ? crypto_create_tfm+0x80/0xc0
[  474.594010]  [<c0211535>] alg_test_hash+0x35/0x70
[  474.594010]  [<c021320f>] ? alg_find_test+0x3f/0x70
[  474.594010]  [<c0213299>] alg_test+0x59/0x180
[  474.594010]  [<f8865a55>] do_test+0xec5/0x14ec [tcrypt]
[  474.594010]  [<f886a0c1>] tcrypt_mod_init+0xc1/0xce [tcrypt]
[  474.594010]  [<f886a000>] ? tcrypt_mod_init+0x0/0xce [tcrypt]
[  474.594010]  [<c0101023>] do_one_initcall+0x23/0x170
[  474.594010]  [<c013f7fa>] ? blocking_notifier_call_chain+0x1a/0x20
[  474.594010]  [<c0151a02>] sys_init_module+0xb2/0x220
[  474.594010]  [<c0102ad0>] sysenter_do_call+0x12/0x26
[  474.594010] Kernel panic - not syncing: softlockup: hung tasks
[  474.594010] Pid: 5184, comm: modprobe Tainted: G      D
2.6.33-g180ce7e #5
[  474.594010] Call Trace:
[  474.594010]  [<c0381525>] ? printk+0x18/0x1b
[  474.594010]  [<c0381452>] panic+0x4d/0x108
[  474.594010]  [<c015552e>] softlockup_tick+0x14e/0x1a0
[  474.594010]  [<c0130247>] run_local_timers+0x17/0x20
[  474.594010]  [<c013027e>] update_process_times+0x2e/0x70
[  474.594010]  [<c0148c4b>] tick_sched_timer+0x5b/0xb0
[  474.594010]  [<c013df0a>] ? __remove_hrtimer+0x2a/0x90
[  474.594010]  [<c0148bf0>] ? tick_sched_timer+0x0/0xb0
[  474.594010]  [<c013e070>] __run_hrtimer+0x50/0x120
[  474.594010]  [<c013e3d1>] hrtimer_interrupt+0x111/0x2f0
[  474.594010]  [<c0104c8e>] timer_interrupt+0x1e/0x60
[  474.594010]  [<c0155be6>] handle_IRQ_event+0x36/0xd0
[  474.594010]  [<c0105c6d>] ? mask_and_ack_8259A+0x7d/0x110
[  474.594010]  [<c0157b2d>] handle_level_irq+0x7d/0x130
[  474.594010]  [<c0104784>] handle_irq+0x34/0x60
[  474.594010]  [<c0104299>] do_IRQ+0x39/0xb0
[  474.594010]  [<c01487b7>] ? tick_program_event+0x17/0x20
[  474.594010]  [<c013e464>] ? hrtimer_interrupt+0x1a4/0x2f0
[  474.594010]  [<c0225720>] ? search_extable+0x30/0x40
[  474.594010]  [<c0102fe9>] common_interrupt+0x29/0x30
[  474.594010]  [<c01180f0>] ? __bad_area_nosemaphore+0x20/0x180
[  474.594010]  [<c0104c8e>] ? timer_interrupt+0x1e/0x60
[  474.594010]  [<c0155be6>] ? handle_IRQ_event+0x36/0xd0
[  474.594010]  [<c0105c6d>] ? mask_and_ack_8259A+0x7d/0x110
[  474.594010]  [<c0105e5f>] ? enable_8259A_irq+0x4f/0x70
[  474.594010]  [<c0157bbd>] ? handle_level_irq+0x10d/0x130
[  474.594010]  [<c0104784>] ? handle_irq+0x34/0x60
[  474.594010]  [<c012aaaa>] ? irq_exit+0x5a/0x90
[  474.594010]  [<c01042a2>] ? do_IRQ+0x42/0xb0
[  474.594010]  [<c0102fe9>] ? common_interrupt+0x29/0x30
[  474.594010]  [<c0118262>] bad_area_nosemaphore+0x12/0x20
[  474.594010]  [<c011862c>] do_page_fault+0x23c/0x2e0
[  474.594010]  [<c01042a2>] ? do_IRQ+0x42/0xb0
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c03838fe>] error_code+0x5e/0x64
[  474.594010]  [<c0150000>] ? load_module+0x280/0x1890
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c015928c>] ? __rcu_process_callbacks+0xdc/0x410
[  474.594010]  [<c01595d2>] rcu_process_callbacks+0x12/0x30
[  474.594010]  [<c012a827>] __do_softirq+0x77/0x100
[  474.594010]  [<c0105c5b>] ? mask_and_ack_8259A+0x6b/0x110
[  474.594010]  [<c0105e5f>] ? enable_8259A_irq+0x4f/0x70
[  474.594010]  [<c012a8dd>] do_softirq+0x2d/0x40
[  474.594010]  [<c012aabd>] irq_exit+0x6d/0x90
[  474.594010]  [<c01042a2>] do_IRQ+0x42/0xb0
[  474.594010]  [<c0102fe9>] common_interrupt+0x29/0x30
[  474.594010]  [<c0120000>] ? proc_sched_show_task+0x1f0/0x600
[  474.594010]  [<c010571b>] ? oops_end+0x4b/0xb0
[  474.594010]  [<c011802e>] no_context+0xbe/0x160
[  474.594010]  [<c011811f>] __bad_area_nosemaphore+0x4f/0x180
[  474.594010]  [<c0287a53>] ? extract_buf+0x73/0xc0
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c01182aa>] bad_area+0x3a/0x50
[  474.594010]  [<c0118685>] do_page_fault+0x295/0x2e0
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<c03838fe>] error_code+0x5e/0x64
[  474.594010]  [<c018007b>] ? pcpu_get_vm_areas+0x4cb/0x500
[  474.594010]  [<c01183f0>] ? do_page_fault+0x0/0x2e0
[  474.594010]  [<f883a278>] ? hmac_setkey+0x38/0x140 [hmac]
[  474.594010]  [<c020f3d6>] crypto_shash_setkey+0x96/0xa0
[  474.594010]  [<c020eb4b>] crypto_ahash_setkey+0x8b/0x90
[  474.594010]  [<c0211056>] test_hash+0x176/0x620
[  474.594010]  [<c012a754>] ? _local_bh_enable+0x24/0x80
[  474.594010]  [<c0108441>] ? native_sched_clock+0x21/0x80
[  474.594010]  [<c0186fce>] ? slob_page_alloc+0x20e/0x240
[  474.594010]  [<c018758d>] ? slob_alloc+0x10d/0x1f0

The offending line (hmac_setkey+0x38/0x140) in crypto/hmac.c is:

(gdb) list *(hmac_setkey+0x38)
0x278 is in hmac_setkey
(/home/ken/projects/kernel/crypto-2.6/crypto/hmac.c:59).
54
crypto_tfm_ctx_alignment());
55              struct crypto_shash *hash = ctx->hash;
56              struct {
57                      struct shash_desc shash;
58                      char ctx[crypto_shash_descsize(hash)];
59              } desc;
60              unsigned int i;
61
62              desc.shash.tfm = hash;
63              desc.shash.flags = crypto_shash_get_flags(parent) &
(gdb)

Regards,
Adrian
