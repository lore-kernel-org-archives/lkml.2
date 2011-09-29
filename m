Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1I2I5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:57:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39863 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab1I2I5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:57:36 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzjAinwRcw-xd4U8tR+bDdpf2h2kP=cEd5hw+K6ZPt3QQ@mail.gmail.com>
References: <20110929070940.GA2838@udknight.homenetwork>
	<CA+55aFzjAinwRcw-xd4U8tR+bDdpf2h2kP=cEd5hw+K6ZPt3QQ@mail.gmail.com>
Date: Thu, 29 Sep 2011 16:57:34 +0800
Message-ID: <CADi559EcS_iyXgw4qZm5RFVZG2oWiFQ-4w489FEn6YGdViPaXg@mail.gmail.com>
Subject: Re: [PATCH] init:main.c: start 'usermodehelper_enable()' a little early
From: wang yanqing <udknight@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I also want to fix the *really* problem,and this
is the call trace:
[    0.542894] msgmni has been set to 1740
[    0.543128] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.543138] io scheduler noop registered
[    0.543140] io scheduler deadline registered
[    0.543151] io scheduler cfq registered (default)
[    0.543488] Pid: 1, comm: swapper Not tainted 3.1.0-rc8NX3+ #13
[    0.543490] Call Trace:
[    0.543499]  [<c11728dd>] uvesafb_exec+0x12d/0x238
[    0.543504]  [<c12aaeff>] uvesafb_probe+0x7e/0xb1e
[    0.543510]  [<c11be53f>] platform_drv_probe+0xc/0xe
[    0.543513]  [<c11bd75d>] driver_probe_device+0x81/0xfd
[    0.543516]  [<c11bd862>] __device_attach+0x2a/0x2e
[    0.543520]  [<c11bcd64>] bus_for_each_drv+0x3d/0x67
[    0.543523]  [<c11bd8d5>] device_attach+0x50/0x6b
[    0.543526]  [<c11bd838>] ? __driver_attach+0x5f/0x5f
[    0.543529]  [<c11bcbef>] bus_probe_device+0x18/0x2d
[    0.543531]  [<c11bc0fc>] device_add+0x37a/0x4b2
[    0.543535]  [<c13ff1e0>] ? parse_early_options+0x1c/0x1c
[    0.543538]  [<c11bb26d>] ? dev_set_name+0x14/0x16
[    0.543541]  [<c11beab2>] platform_device_add+0xe4/0x12b
[    0.543544]  [<c13ff1e0>] ? parse_early_options+0x1c/0x1c
[    0.543547]  [<c12aaadd>] uvesafb_init+0x307/0x354
[    0.543550]  [<c13ff1e0>] ? parse_early_options+0x1c/0x1c
[    0.543554]  [<c1001159>] do_one_initcall+0x71/0x113
[    0.543557]  [<c12aa7d6>] ? uvesafb_is_valid_mode+0x56/0x56
[    0.543560]  [<c13ff1e0>] ? parse_early_options+0x1c/0x1c
[    0.543562]  [<c13ff264>] kernel_init+0x84/0xfd
[    0.543565]  [<c12bc4b6>] kernel_thread_helper+0x6/0xd
[    0.543709] v86d used greatest stack depth: 7028 bytes left
[    0.583239] uvesafb: NVIDIA Corporation, GT216 Board - 0696a290,
Chip Rev   , OEM: NVIDIA, VBE v3.0
[    0.606852] uvesafb: protected mode interface info at c000:d350
[    0.606854] uvesafb: pmi: set display start = c00cd3b3, set palette
= c00cd40e
[    0.606856] uvesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6
3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da
[    0.610376] uvesafb: VBIOS/hardware doesn't support DDC transfers
[    0.610378] uvesafb: no monitor limits have been set, default
refresh rate will be used
[    0.610528] uvesafb: scrolling: ypan using protected mode
interface, yres_virtual=4915
[    0.739820] Console: switching to colour frame buffer device 80x30
[    0.740634] uvesafb: framebuffer at 0xcf000000, mapped to
0xf8480000, using 6144k, total 14336k
[    0.740636] fb0: VESA VGA frame buffer device

maybe uvesafb has some specific thing that it requires a userspace
helper application called 'v86d' to work!
I will try to make uvesafb workaround it, but i don't know whether it
will work, and splash boot *really* need
early init.

On Thu, Sep 29, 2011 at 3:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 29, 2011 at 12:09 AM, wangyanqing <udknight@gmail.com> wrote:
>> commit d5767c53535ac79758084773418e0ad186aba4a2 move 'usermodehelper_enable()'
>> to end of rest_init, then I get failed to let uvesafb work on my computer, and
>> lose the splash boot.So maybe we could start usermodehelper_enable a little early
>> to make some task work that need eary init with the help of user mode.
>
> Grr. Initcalls *really* shouldn't depend on usermode helpers.
>
> That said, I'm not entirely shocked if they do. But could you try to
> describe *which* initcall it is? The call trace should tell you?
>
> I'm not saying the patch is wrong (and it may be what we have to do at
> this point), but I do think it would be even better if we could fix
> the real problem of initcalls calling usermode helpers instead...
>
>           Linus
>
