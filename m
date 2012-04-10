Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2DJJxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:53:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44208 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2DJJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:53:08 -0400
Message-ID: <4F840300.3090101@suse.cz>
Date: Tue, 10 Apr 2012 11:53:04 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: i915: NULL pointer dereference in pagevec_move_tail
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in today's -next I see:
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff810e3990>] pagevec_move_tail+0x30/0x30
PGD 1bf4fc067 PUD 1bf4f0067 PMD 0
Oops: 0000 [#1] SMP
CPU 0
Modules linked in: pl2303 usbserial microcode

Pid: 4260, comm: X Not tainted 3.4.0-rc2-next-20120410_64+ #1683 To Be
Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff810e3990>]  [<ffffffff810e3990>]
pagevec_move_tail+0x30/0x30
RSP: 0018:ffff8801bf7f1ca0  EFLAGS: 00010202
RAX: ffff8801c1502b60 RBX: 0000000000000008 RCX: ffff8801c286a000
RDX: 0000000000000000 RSI: 0000000000000819 RDI: 0000000000000000
RBP: ffff8801bf7f1cc8 R08: 0000000000000001 R09: ffff8801bf7f1fd8
R10: ffff8801bf7f1fd8 R11: ffff880000000000 R12: ffff8801bf6cbe00
R13: 0000000000000008 R14: ffff8801bfdf6138 R15: ffff8801c2def000
FS:  00007fd1d3d9f880(0000) GS:ffff8801cbc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001bff5b000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 4260, threadinfo ffff8801bf7f0000, task ffff8801c28ea640)
Stack:
 ffffffff81345290 ffff8801bf7f1cc8 ffff8801bf6cbe00 0000000000000000
 ffff8801c286a000 ffff8801bf7f1cf8 ffffffff813486fd ffff8801bf7f1cf8
 ffff8801bf6cbe00 ffff8801c286a000 000000000000000a ffff8801bf7f1d18
Call Trace:
 [<ffffffff81345290>] ? i915_gem_object_put_pages_gtt+0x90/0x180
 [<ffffffff813486fd>] i915_gem_object_unbind+0xad/0x1e0
 [<ffffffff8134884a>] i915_gem_free_object_tail+0x1a/0xd0
 [<ffffffff8134b391>] i915_gem_free_object+0x51/0x60
 [<ffffffff8131faa5>] drm_gem_object_free+0x25/0x40
 [<ffffffff81320120>] drm_gem_handle_delete+0xf0/0x120
 [<ffffffff813203a3>] drm_gem_close_ioctl+0x23/0x30
 [<ffffffff8131e20c>] drm_ioctl+0x43c/0x510
 [<ffffffff81086472>] ? enqueue_hrtimer+0x22/0x50
 [<ffffffff81320380>] ? drm_gem_destroy+0x50/0x50
 [<ffffffff81086e9f>] ? hrtimer_start_range_ns+0xf/0x20
 [<ffffffff811325d7>] do_vfs_ioctl+0x97/0x580
 [<ffffffff81121ead>] ? vfs_read+0xfd/0x180
 [<ffffffff81132b0a>] sys_ioctl+0x4a/0x80
 [<ffffffff816359e2>] system_call_fastpath+0x16/0x1b
Code: 32 0e 81 48 89 e5 48 83 ec 10 48 8d 55 fc c7 45 fc 00 00 00 00 e8
e1 fe ff ff 48 63 45 fc 65 48 01 04 25 b0 e3 00 00 c9 c3 66 90 <48> f7
07 00 c
0f
RIP  [<ffffffff810e3990>] pagevec_move_tail+0x30/0x30
 RSP <ffff8801bf7f1ca0>
CR2: 0000000000000000

This is G33:
00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
Express Integrated Graphics Controller [8086:29c2] (rev 02) (prog-if 00
[VGA controller])
        Subsystem: Intel Corporation 82G33/G31 Express Integrated
Graphics Controller [8086:29c2]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4179
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: i915
00: 86 80 c2 29 07 04 90 00 02 00 00 03 00 00 00 00
10: 00 00 b8 fe 01 ec 00 00 08 00 00 d0 00 00 a0 fe
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c2 29
30: 00 00 00 00 90 00 00 00 00 00 00 00 05 01 00 00
40: 09 00 0b 01 00 00 00 00 01 00 00 00 00 00 00 00
50: 00 00 30 02 c9 03 00 00 00 00 00 00 00 00 80 af
60: 00 00 02 02 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 05 d0 01 00 0c 30 e0 fe 79 41 00 00 00 00 00 00
a0: 11 11 00 00 00 00 06 03 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 01 02 00
e0: 00 00 00 00 00 00 00 00 00 80 00 00 00 00 00 00
f0: 10 00 00 00 00 00 00 00 90 0f 03 00 e4 e0 5b af


thanks,
-- 
js
suse labs

