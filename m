Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab2GEXMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:12:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50320 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab2GEXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:12:31 -0400
Date: Thu, 5 Jul 2012 16:10:34 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 0/6] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120705231034.GA16931@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

These patches introduce KGDB FIQ debugger support. The idea (and some
code, of course) comes from Google's FIQ debugger[1]. There are some
differences (mostly implementation details, feature-wise they're almost
equivalent, or can be made equivalent, if desired).

The FIQ debugger is a facility that can be used to debug situations
when the kernel stuck in uninterruptable sections, e.g. the kernel
infinitely loops or deadlocked in an interrupt or with interrupts
disabled. On some development boards there is even a special NMI
button, which is very useful for debugging weird kernel hangs.

And FIQ is basically an NMI, it has a higher priority than IRQs, and
upon IRQ exception FIQs are not disabled. It is still possible to
disable FIQs (as well as some "NMIs" on other architectures), but via
special means.

So, here FIQs and NMIs are synonyms, but in the code I use NMI term
for arch-independent code, and FIQs for ARM code.

A few years ago KDB wasn't yet ready for production, or even not
well-known, so originally Google implemented its own FIQ debugger
that included its own shell, ring-buffer, commands, dumping,
backtracing logic and whatnot. This is very much like PowerPC's xmon
(arch/powerpc/xmon), except that xmon was there for a decade, so it
even predates KDB.

Anyway, nowadays KGDB/KDB is the cross-platform debugger, and the
only feature that was missing is NMI handling. This is now fixed for
ARM.

There a few differences comparing to the original (Google's) FIQ
debugger:

- Doing stuff in FIQ context is dangerous, as there we are not allowed
  to cause aborts or faults. In the original FIQ debugger there was a
  "signal" software-induced interrupt, upon exit from FIQ it would fire,
  and we would continue to execute "dangerous" commands from there.

  In KGDB/KDB we don't use signal interrupts. We can do easier:
  set up a breakpoint, continue, and you'll trap into KGDB again
  in a safe context.

  It works for most cases, but I can imagine cases when you can't
  set up a breakpoint. For these cases we'd better introduce a
  KDB command "exit_nmi", that will rise the SW IRQ, after which
  we're allowed to do anything.

- KGDB/KDB FIQ debugger shell is synchronous. In Google's version
  you could have a dedicated shell always running in the FIQ context,
  so when you type something on a serial line, you won't actually cause
  any debugging actions, FIQ would save the characters in its own
  buffer and continue execution normally. But when you hit return key
  after the command, then the command is executed.

  In KGDB/KDB FIQ debugger it is different. When you start any activity
  on the FIQ-enabled serial console, you'll enter KGDB and kernel will
  stop until you instruct it to continue.

  This might look as a drastic change, but it is not. There is actually
  no difference whether you have sync or async shell, or at least I
  couldn't find any use-case where this would matter at all. Anyways,
  it is still possible to do async shell in KDB, just don't see any
  need for this.

- Original FIQ debugger used a custom FIQ vector handling code, w/
  a lot of logic in it. In this approach I'm using the fact that
  FIQs are basically IRQs, except that we there are a bit more
  registers banked, and we can actually trap from the IRQ context.

  But this all does not prevent us from using a simple jump-table
  based approach as used in the generic ARM entry code. So, here
  I just reuse the generic approach.

Note that I testing the code on a modelled ARM machine (QEMU Versatile),
so there might be some issues on a real HW, but it works in QEMU tho. :-)

Assuming you have QEMU >= 1.1.0, you can easily play with the code
using ARM/versatile defconfig and command like this:

  qemu-system-arm -nographic -machine versatilepb \
  	-kernel linux/arch/arm/boot/zImage  \
  	-append "console=ttyAMA0 kgdboc=ttyAMA0 kgdb_fiq.enable=1"

TODO:

1. alignment_trap macro uses local label, so we have to put the label
   into each file that use the macro. We can get rid of the label;
2. Need per-machine kgdb_arch_enable_nmi(), probably will introduce
   a pointer to a func;
3. Since console interrupt is actually is overtaken by NMI handler, we
   should make serial/uart drivers stop using TX interrupts. This my
   homework to think how to do it better. Currently, we would just
   better not use console= and kgdboc= on the same tty (but it still
   works, just might cause troubles if you hit TX interrupt);
4. Address any comments. :-)

Thanks!

--
 arch/arm/Kconfig                            |   14 +++
 arch/arm/common/vic.c                       |   28 +++++
 arch/arm/include/asm/hardware/vic.h         |    2 +
 arch/arm/include/asm/kgdb.h                 |    8 ++
 arch/arm/kernel/Makefile                    |    1 +
 arch/arm/kernel/entry-armv.S                |  167 +-------------------------
 arch/arm/kernel/entry-header.S              |  170 +++++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq.c                  |   78 ++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S            |   80 +++++++++++++
 arch/arm/mach-versatile/Makefile            |    1 +
 arch/arm/mach-versatile/include/mach/irqs.h |    1 +
 arch/arm/mach-versatile/kgdb_fiq.c          |   40 +++++++
 include/linux/kgdb.h                        |    9 ++
 kernel/debug/debug_core.c                   |   12 +-
 kernel/debug/kdb/kdb_debugger.c             |    4 +
 15 files changed, 448 insertions(+), 167 deletions(-)

p.s.

[1] Original Google's FIQ debugger, fiq_* files:
http://android.git.linaro.org/gitweb?p=kernel/common.git;a=tree;f=arch/arm/common;hb=refs/heads/android-3.4
And board support as an example of using it:
http://nv-tegra.nvidia.com/gitweb/?p=linux-2.6.git;a=commitdiff;h=461cb80c16e4e266ab6207a00767b59212148086

pp.s. If anyone curious, typical NMI entry looks like this
(I also executed a bit of commands):

Entering kdb (current=0xc781bd60, pid 1) due to NonMaskable Interrupt @ 0xc01510d0

Pid: 1, comm:              swapper
CPU: 0    Not tainted  (3.5.0-rc4+ #214)
PC is at __delay+0x0/0xc
LR is at panic+0x180/0x1b0
pc : [<c01510d0>]    lr : [<c0286b64>]    psr: 20000013
sp : c7823f24  ip : c7823f24  fp : c7823f38
r10: c02f35c4  r9 : 00000000  r8 : c0377988
r7 : 00000320  r6 : 000002bc  r5 : 00000040  r4 : 00000000
r3 : c0020f4c  r2 : 000002ce  r1 : ffffffff  r0 : 0000e2e1
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 00093177  Table: 00004000  DAC: 00000017
Backtrace:
[<c00173a4>] (dump_backtrace+0x0/0x10c) from [<c02867f4>] (dump_stack+0x18/0x1c)
 r6:0000000f r5:c0361d58 r4:c7823edc
[<c02867dc>] (dump_stack+0x0/0x1c) from [<c001506c>] (show_regs+0x44/0x50)
[<c0015028>] (show_regs+0x0/0x50) from [<c0287474>] (kdb_dumpregs+0x30/0x58)
 r4:c0383330
[<c0287444>] (kdb_dumpregs+0x0/0x58) from [<c00606e4>] (kdb_local.isra.5+0x354/0x5ec)
 r6:c0385534 r5:c7823edc r4:00000008
[<c0060390>] (kdb_local.isra.5+0x0/0x5ec) from [<c0060a28>] (kdb_main_loop+0xac/0x1bc)
[<c006097c>] (kdb_main_loop+0x0/0x1bc) from [<c0063020>] (kdb_stub+0x2e0/0x3e8)
 r8:c0385820 r7:c0364004 r6:c0382cb4 r5:c03857c8 r4:c7823e7c
[<c0062d40>] (kdb_stub+0x0/0x3e8) from [<c0059868>] (kgdb_cpu_enter.constprop.9+0x13c/0x4f8)
[<c005972c>] (kgdb_cpu_enter.constprop.9+0x0/0x4f8) from [<c0059f2c>] (kgdb_handle_exception+0x8c/0xa0)
[<c0059ea0>] (kgdb_handle_exception+0x0/0xa0) from [<c0008614>] (kgdb_fiq_do_handle+0x58/0x7c)
 r8:c0377988 r7:c7823f10 r6:ffffffff r5:c7823edc r4:c7822000
[<c00085bc>] (kgdb_fiq_do_handle+0x0/0x7c) from [<c0018df4>] (__fiq_svc+0x34/0x40)
Exception stack(0xc7823edc to 0xc7823f24)
3ec0:                                                                0000e2e1
3ee0: ffffffff 000002ce c0020f4c 00000000 00000040 000002bc 00000320 c0377988
3f00: 00000000 c02f35c4 c7823f38 c7823f24 c7823f24 c0286b64 c01510d0 20000013
3f20: ffffffff
 r5:20000013 r4:c01510d0
[<c02869e4>] (panic+0x0/0x1b0) from [<c0334d94>] (mount_block_root+0xe0/0x194)
 r3:00000000 r2:00000000 r1:c7823f50 r0:c02f355c
 r7:c789a000
[<c0334cb4>] (mount_block_root+0x0/0x194) from [<c0335030>] (mount_root+0xec/0x114)
[<c0334f44>] (mount_root+0x0/0x114) from [<c03351c0>] (prepare_namespace+0x168/0x1bc)
 r7:00000013 r6:c0025c0c r5:c0351b24 r4:c0377440
[<c0335058>] (prepare_namespace+0x0/0x1bc) from [<c03349e4>] (kernel_init+0xd0/0xfc)
 r5:c0351b24 r4:c0351b24
[<c0334914>] (kernel_init+0x0/0xfc) from [<c0025c0c>] (do_exit+0x0/0x2d8)
 r5:c0334914 r4:00000000
more>
kdb> md c01510d0
0xc01510d0 e2500001 8afffffd e1a0f00e e254c001   ..P...........T.
0xc01510e0 9a000033 e11c0004 0a000028 e1510004   3.......(.....Q.
0xc01510f0 e3a03000 3a00000b e16f2f14 e16fcf11   .0.....:./o...o.
0xc0151100 e042200c e3a0c001 e1a0c21c e1a02214   . B.........."..
0xc0151110 e1510002 2183300c 20511002 11b0c0ac   ..Q..0.!..Q ....
0xc0151120 e1a020a2 1afffff9 e3510000 e3a02000   . ........Q.. ..
0xc0151130 01500004 31a01000 31a0f00e e3a0c102   ..P....1...1....
0xc0151140 e1b00080 e0b11001 0a000005 31510004   ..............Q1
kdb> bp __delay
Instruction(i) BP #0 at 0xc01510d0 (__delay)
    is enabled  addr at 00000000c01510d0, hardtype=0 installed=0

kdb> go __delay

Entering kdb (current=0xc781bd60, pid 1) due to Breakpoint @ 0xc01510d0
kdb> bt
Stack traceback for pid 1
0xc781bd60        1        0  1    0   R  0xc781bf1c *swapper
Backtrace:
[<c00173a4>] (dump_backtrace+0x0/0x10c) from [<c0017804>] (show_stack+0x18/0x1c)
 r6:0000000f r5:c0361d58 r4:c0383330
[<c00177ec>] (show_stack+0x0/0x1c) from [<c006202c>] (kdb_show_stack+0x78/0x88)
[<c0061fb4>] (kdb_show_stack+0x0/0x88) from [<c00620c0>] (kdb_bt1.isra.0+0x84/0xd8)
 r8:00000032 r7:00000000 r6:00000000 r5:ffffffff r4:c781bd60
[<c006203c>] (kdb_bt1.isra.0+0x0/0xd8) from [<c00623b8>] (kdb_bt+0x2a4/0x348)
 r7:00000001 r6:00000000 r5:c03857d0 r4:c03856fc
[<c0062114>] (kdb_bt+0x0/0x348) from [<c005fdbc>] (kdb_parse+0x2cc/0x4f4)
 r8:00000032 r7:c03856fc r6:c02fa1f8 r5:c0383614 r4:00000009
[<c005faf0>] (kdb_parse+0x0/0x4f4) from [<c0060588>] (kdb_local.isra.5+0x1f8/0x5ec)
[<c0060390>] (kdb_local.isra.5+0x0/0x5ec) from [<c0060a28>] (kdb_main_loop+0xac/0x1bc)
[<c006097c>] (kdb_main_loop+0x0/0x1bc) from [<c0063020>] (kdb_stub+0x2e0/0x3e8)
 r8:c0385820 r7:c0364004 r6:c0382cb4 r5:c03857c8 r4:c7823de0
[<c0062d40>] (kdb_stub+0x0/0x3e8) from [<c0059868>] (kgdb_cpu_enter.constprop.9+0x13c/0x4f8)
[<c005972c>] (kgdb_cpu_enter.constprop.9+0x0/0x4f8) from [<c0059f2c>] (kgdb_handle_exception+0x8c/0xa0)
[<c0059ea0>] (kgdb_handle_exception+0x0/0xa0) from [<c0018ae0>] (kgdb_brk_fn+0x20/0x28)
 r8:c0377988 r7:00000000 r6:60000093 r5:c01510d0 r4:c7823edc
[<c0018ac0>] (kgdb_brk_fn+0x0/0x28) from [<c00084f0>] (do_undefinstr+0xdc/0x1a8)
[<c0008414>] (do_undefinstr+0x0/0x1a8) from [<c0013e1c>] (__und_svc+0x3c/0x60)
Exception stack(0xc7823edc to 0xc7823f24)
3ec0:                                                                0000e2e1
3ee0: ffffffff 000002ce c0020f4c 00000000 00000040 000002bc 00000320 c0377988
3f00: 00000000 c02f35c4 c7823f38 c7823f24 c7823f24 c0286b64 c01510d0 20000013
3f20: ffffffff
 r7:c7823f10 r6:ffffffff r5:20000013 r4:c01510d4
[<c02869e4>] (panic+0x0/0x1b0) from [<c0334d94>] (mount_block_root+0xe0/0x194)
 r3:00000000 r2:00000000 r1:c7823f50 r0:c02f355c
 r7:c789a000
[<c0334cb4>] (mount_block_root+0x0/0x194) from [<c0335030>] (mount_root+0xec/0x114)
[<c0334f44>] (mount_root+0x0/0x114) from [<c03351c0>] (prepare_namespace+0x168/0x1bc)
 r7:00000013 r6:c0025c0c r5:c0351b24 r4:c0377440
[<c0335058>] (prepare_namespace+0x0/0x1bc) from [<c03349e4>] (kernel_init+0xd0/0xfc)
 r5:c0351b24 r4:c0351b24
[<c0334914>] (kernel_init+0x0/0xfc) from [<c0025c0c>] (do_exit+0x0/0x2d8)
 r5:c0334914 r4:00000000
kdb>
kdb> ps
15 sleeping system daemon (state M) processes suppressed,
use 'ps A' to see all.
Task Addr       Pid   Parent [*] cpu State Thread     Command
0xc781bd60        1        0  1    0   R  0xc781bf1c *swapper

0xc781bd60        1        0  1    0   R  0xc781bf1c *swapper
0xc789dd60       13        2  0    0   R  0xc789df1c  kworker/0:1
0xc789d580       16        2  0    0   R  0xc789d73c  kworker/u:1
0xc796cd60       23        2  0    0   R  0xc796cf1c  deferwq

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
