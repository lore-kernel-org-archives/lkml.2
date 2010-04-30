Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477Ab0D3UEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:04:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20294 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab0D3UEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:04:47 -0400
Date: Fri, 30 Apr 2010 10:52:25 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: USB mass storage kernel panic after two days sleep/wakeup
In-reply-to: <1272452239.8054.1.camel@ben-desktop>
To: Bin Shi <Bin.Shi@csr.com>, linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vbyv9nzg7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1272452239.8054.1.camel@ben-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 12:57:19 +0200, Bin Shi <Bin.Shi@csr.com> wrote:
> I am developing ARM1136 platform with USB otg. Test case shows kernel
> panic after almost two whole days sleep/wakeup with usb mass storage
> plugin, also with audio playback and sd copy, which means high load for
> testing.

First of, is the "almost two whole days" some kind of magic barrier?  Can
you reproduce the bug after a shorter sleep?

Second of, defining DEBUG, VERBOSE_DEBUG and DUMP_MSGS at the beginning
of file_storage.c (definitions of later two are commented near the
beginning of the file).

And lastly, some time ago I did some remodelling in file_storage.c.  Those
could be a cause of problems.  Could you try reverting all my changes
(do a "git log --author=Nazarewicz" to find those) and then try to reproduce
the bug.  This may limit us to only a handful of commits.

On the other hand, file_storage does nothing on suspend and resume -- gadget
data is changed only in fsg_bind() and fsg_unbind() -- so it may be a problem
somewhere completely elsewhere.

> [   73.112109] PM-pm_s_done: (73112086)
> [    4.811657] PM-pm_w_initiate: (4811631)
> [    5.111843] usbcd_set_mode: in device mode
> [    5.111880] usbcd_start_controller, the cmd is 0x80001
> [    5.112227] SIRFSOC-FB: LCD resumed
> [    5.112374] SiRFSoC Backlight: Resumed
> [    5.121778] soc-audio soc-audio: scheduling resume work
> [    5.148505] Restarting tasks ... Suspended. Trying resume.
> <6>soc-audio soc-audio: starting resume work
> [    5.209285] soc-audio soc-audio: resume work completed
> Done.^M
> [    5.260771] done.
> Woken Up
> Received Event 3
> SLEPT FOR 186 SECONDS IN SESSION 806
> [    5.419961] Unable to handle kernel NULL pointer dereference at
> virtual address 0000001c
> [    5.425234] pgd = c3bdc000
> [    5.427918] [0000001c] *pgd=c3357031, *pte=00000000, *ppte=00000000
> [    5.434175] Internal error: Oops: 17 [#1] PREEMPT
> [    5.438852] Modules linked in: g_file_storage(-) sirfsoc_gps
> rtc1_sirfsoc sirfsoc_wdt sirfsoc_uspserial g_usbdrv ehci_hcd usbcore
> snd_soc_cb_modac_ts snd_soc_modac snd_soc_sirfsoc_i2s
> snd_soc_ts_stream_mode snd_soc_sirfsoc snd_soc_core snd_pcm snd_timer
> snd soundcore snd_page_alloc [last unloaded: g_file_storage]
> [    5.466551] CPU: 0    Not tainted  (2.6.28-default #1)
> [    5.471729] PC is at fsg_setup+0x18/0x3ac [g_file_storage]
> [    5.477204] LR is at pcd_do_gadget_setup+0x38/0x50 [g_usbdrv]
> [    5.482869] pc : [<bf683aa4>]    lr : [<bf09490c>]    psr: a0000193
> [    5.482881] sp : c3375da8  ip : 00000000  fp : c3375dcc
> [    5.494320] r10: c48d81ac  r9 : 00000001  r8 : 00000000
> [    5.499529] r7 : bf09ab58  r6 : 00000000  r5 : 00000000  r4 :
> ffc24028
> [    5.506040] r3 : bf683a8c  r2 : ffc24028  r1 : ffc24028  r0 :
> bf09ab60
> [    5.512552] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
> Segment user
> [    5.519755] Control: 00c5387d  Table: c3bdc008  DAC: 00000015
> [    5.525484] Process rmmod (pid: 25101, stack limit = 0xc3374260)
> [    5.531472] Stack: (0xc3375da8 to 0xc3376000)
> [    5.535808] 5da0:                   bf09ab58 c3a71400 00000000
> bf09ab58 00000000 00000001
> [    5.544053] 5dc0: c3375de4 c3375dd0 bf09490c bf683a98 ffc24028
> c3a71400 c3375e24 c3375de8
> [    5.552299] 5de0: bf095768 bf0948e0 c00bc7bc c00bc744 00000000
> 00000081 c3375e3c bf09ab20
> [    5.560545] 5e00: 1f202f28 00000081 0000000a 00000000 c3374000
> bece4e04 c3375e44 c3375e28
> [    5.568791] 5e20: bf094094 bf0954dc c39036a0 00000000 00000000
> 0000000a c3375e64 c3375e48
> [    5.577037] 5e40: c00cb480 bf09403c c3374000 c031449c c39036a0
> 0000000a c3375e84 c3375e68
> [    5.585283] 5e60: c00cd578 c00cb450 0000000a c034a8d4 00000000
> 00000001 c3375ea4 c3375e88
> [    5.593529] 5e80: c0087058 c00cd4d8 ffffffff f9020000 bf686190
> 00000001 c3375f14 c3375ea8
> [    5.601775] 5ea0: c0087a64 c008700c c3800120 0183af40 00000015
> 00000003 c3374000 bf09ab20
> [    5.610021] 5ec0: bf686190 bf09ab60 bf09ab58 c3374000 bece4e04
> c3375f14 c3375eb0 c3375ef0
> [    5.618267] 5ee0: bf096b14 bf09665c 40000013 ffffffff c394a3c0
> 00000880 bf6862a0 c3374000
> [    5.626513] 5f00: c3375f34 c3374000 c3375f2c c3375f18 bf683f3c
> bf0965b8 00000000 00000880
> [    5.634759] 5f20: c3375fa4 c3375f30 c00c7b6c bf683f0c c008d00c
> 69665f67 735f656c 61726f74
> [    5.643005] 5f40: c3006567 00000200 00000000 40158000 c00bb900
> ffffffff bece4e08 00000880
> [    5.651251] 5f60: 00000000 00000000 000000cc 00ce4e04 bf6862a0
> 00000880 c3375f7c 00000000
> [    5.659497] 5f80: ffffffff 735f656c 61726f74 00006567 00000081
> c0087f84 00000000 c3375fa8
> [    5.667743] 5fa0: c0087e00 c00c79ec 735f656c 61726f74 bece4aa8
> 00000880 00000000 69665f67
> [    5.675989] 5fc0: 735f656c 61726f74 00006567 00000081 00000000
> 000000cc bece4e04 00000002
> [    5.684235] 5fe0: bece4aa8 bece4a98 00022a40 40158c50 60000010
> bece4aa8 00000000 00000000
> [    5.692482] Backtrace:
> [    5.694915] [<bf683a8c>] (fsg_setup+0x0/0x3ac [g_file_storage]) from
> [<bf09490c>] (pcd_do_gadget_setup+0x38/0x50 [g_usbdrv])
> [    5.706115]  r9:00000001 r8:00000000 r7:bf09ab58 r6:00000000
> r5:c3a71400
> [    5.712620] r4:bf09ab58
> [    5.715225] [<bf0948d4>] (pcd_do_gadget_setup+0x0/0x50 [g_usbdrv])
> from [<bf095768>] (pcd_intr_handler+0x298/0x8f4[g_usbdrv])
> [    5.726596]  r5:c3a71400 r4:ffc24028
> [    5.730154] [<bf0954d0>] (pcd_intr_handler+0x0/0x8f4 [g_usbdrv]) from
> [<bf094094>] (usbcd_irq_handler+0x64/0x9c [g_usbdrv])
> [    5.741265] [<bf094030>] (usbcd_irq_handler+0x0/0x9c [g_usbdrv]) from
> [<c00cb480>] (handle_IRQ_event+0x3c/0x74)
> [    5.751335]  r7:0000000a r6:00000000 r5:00000000 r4:c39036a0
> [    5.756975] [<c00cb444>] (handle_IRQ_event+0x0/0x74) from
> [<c00cd578>] (handle_level_irq+0xac/0x154)
> [    5.766090]  r7:0000000a r6:c39036a0 r5:c031449c r4:c3374000
> [    5.771732] [<c00cd4cc>] (handle_level_irq+0x0/0x154) from
> [<c0087058>] (__exception_text_start+0x58/0x8c)
> [    5.781366]  r7:00000001 r6:00000000 r5:c034a8d4 r4:0000000a
> [    5.787007] [<c0087000>] (__exception_text_start+0x0/0x8c) from
> [<c0087a64>] (__irq_svc+0x44/0x88)
> [    5.795952] Exception stack(0xc3375ea8 to 0xc3375ef0)
> [    5.800981] 5ea0:                   c3800120 0183af40 00000015
> 00000003 c3374000 bf09ab20
> [    5.809227] 5ec0: bf686190 bf09ab60 bf09ab58 c3374000 bece4e04
> c3375f14 c3375eb0 c3375ef0
> [    5.817473] 5ee0: bf096b14 bf09665c 40000013
> ffffffff
> [    5.825721]  r7:00000001 r6:bf686190 r5:f9020000 r4:ffffffff
> [    5.831362] [<bf0965ac>] (usb_gadget_unregister_driver+0x0/0x118
> [g_usbdrv]) from [<bf683f3c>] (fsg_cleanup+0x3c/0x68 [g_file_storage])
> [    5.843517]  r9:c3374000 r8:c3375f34 r7:c3374000 r6:bf6862a0
> r5:00000880
> [    5.850025] r4:c394a3c0
> [    5.852629] [<bf683f00>] (fsg_cleanup+0x0/0x68 [g_file_storage]) from
> [<c00c7b6c>] (sys_delete_module+0x18c/0x220)
> [    5.862959]  r5:00000880 r4:00000000
> [    5.866517] [<c00c79e0>] (sys_delete_module+0x0/0x220) from
> [<c0087e00>] (ret_fast_syscall+0x0/0x2c)
> [    5.875632]  r8:c0087f84 r7:00000081 r6:00006567 r5:61726f74
> r4:735f656c
> [    5.882314] Code: e24cb004 e59050e0 e1a04001 e3a0c000 (e595301c)
> [    5.888639] Kernel panic - not syncing: Fatal exception in interrupt
>
>
> After trace break site, it was found that at addr 3aa4, r5 has value
> 0x0, that load 0x0+0x1c(#28) address to r3, while 0x1c could not be
> accessed. In function fsg_setup(), struct fsg_dev
> *fsg=get_gadget_data(gadget) makes the error, which gadget->dev being
> NULL value.
>
> 00003a8c <fsg_setup>:
>      3a8c:       e1a0c00d        mov     ip, sp
>      3a90:       e92ddbf0        push    {r4, r5, r6, r7, r8, r9, fp,
> ip, lr, pc}
>      3a94:       e24cb004        sub     fp, ip, #4      ; 0x4
>      3a98:       e59050e0        ldr     r5, [r0, #224]
>      3a9c:       e1a04001        mov     r4, r1
>      3aa0:       e3a0c000        mov     ip, #0  ; 0x0
>      3aa4:       e595301c        ldr     r3, [r5, #28]
>      3aa8:       e5951018        ldr     r1, [r5, #24]
>      3aac:       e2833001        add     r3, r3, #1      ; 0x1
>      3ab0:       e5d40006        ldrb    r0, [r4, #6]
>      3ab4:       e5d42007        ldrb    r2, [r4, #7]
>      3ab8:       e585301c        str     r3, [r5, #28]
>      3abc:       e581c014        str     ip, [r1, #20]
>      3ac0:       e5953018        ldr     r3, [r5, #24]
>      3ac4:       e1808402        orr     r8, r0, r2, lsl #8
>      3ac8:       e583c004        str     ip, [r3, #4]
>      3acc:       e5d46000        ldrb    r6, [r4]
>      3ad0:       e2063060        and     r3, r6, #96     ; 0x60
>      3ad4:       e3530020        cmp     r3, #32 ; 0x20
>      3ad8:       0a000030        beq     3ba0 <fsg_setup+0x114>

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
