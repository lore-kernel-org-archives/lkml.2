Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2GCRlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:41:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64438 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2GCRlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:41:02 -0400
Message-ID: <1341337257.2406.1.camel@nayuki.kepstin.ca>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Date: Tue, 03 Jul 2012 13:40:57 -0400
In-Reply-To: <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
References: <20120702224648.GA20361@tassilo.jf.intel.com>
	 <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
	 <1341323230.3292.10.camel@nayuki.kepstin.ca>
	 <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 10:07 -0700, Linus Torvalds wrote:
> On Tue, Jul 3, 2012 at 6:47 AM, Calvin Walton <calvin.walton@kepstin.ca> wrote:
> >
> > I'm seeing the same issue, so I've given this a try. Here are the
> > messages printed when floppy debugging is enabled:
> >
> > [    0.714318] floppy0: reschedule timeout lock fdc
> > [   20.729798] floppy0: reschedule timeout do wakeup
> 
> Ok, that 20 s timeout is a hint.
> 
> 20s is the floppy "max timeout" value, and it's used in various
> places. HOWEVER. The "lock fdc" case absolutely should not be using
> that timeout. It should use the floppy "UDP->timeout" value, which
> should be just 3s. Which is still a long time, but not nearly as long
> as that.
> 
> Can you add a DPRINT() to the lock_fdc() function just before calling
> reschedule_timeout() to print out what the "drive" is?

Ok, here's the dmesg output that I get:

[    0.661966] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.682589] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.703303] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.703599] Non-volatile memory driver v1.3
[    0.714316] floppy0: lock_fdc: -1 (out of 8)
[    0.714462] ------------[ cut here ]------------
[    0.714606] WARNING: at drivers/block/floppy.c:880 lock_fdc.isra.30+0x156/0x170()
[    0.717372] Hardware name: EX58-DS4
[    0.717511] Modules linked in:
[    0.717649] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc4-00230-g15114c7-dirty #21
[    0.717872] Call Trace:
[    0.718010]  [<ffffffff810686aa>] warn_slowpath_common+0x7a/0xb0
[    0.718154]  [<ffffffff810686f5>] warn_slowpath_null+0x15/0x20
[    0.718306]  [<ffffffff813e3d96>] lock_fdc.isra.30+0x156/0x170
[    0.718448]  [<ffffffff813e46f1>] user_reset_fdc+0x11/0x80
[    0.718592]  [<ffffffff81cbb854>] floppy_init+0x7d7/0xe15
[    0.718737]  [<ffffffff81cbb07d>] ? set_cmos+0x6e/0x6e
[    0.718879]  [<ffffffff810001ba>] do_one_initcall+0x3a/0x160
[    0.719024]  [<ffffffff81c95c4f>] kernel_init+0x101/0x185
[    0.719169]  [<ffffffff81c955c5>] ? do_early_param+0x87/0x87
[    0.719317]  [<ffffffff81760d94>] kernel_thread_helper+0x4/0x10
[    0.719460]  [<ffffffff81c95b4e>] ? start_kernel+0x32f/0x32f
[    0.719604]  [<ffffffff81760d90>] ? gs_change+0xb/0xb
[    0.719748] ---[ end trace 16b38434e9defc9e ]---
[    0.719888] floppy0: reschedule timeout lock fdc
[    1.651398] Refined TSC clocksource calibration: 2698.759 MHz.
[    1.651551] Switching to clocksource tsc
[   20.729857] floppy0: reschedule timeout do wakeup
[   20.730009] floppy0: no floppy controllers found
[   20.730578] loop: module loaded
[   20.730746] ahci 0000:00:1f.2: version 3.0
[   20.730782] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X

when using this debugging patch:

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cce7df3..8a41259 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -876,6 +876,9 @@ static int lock_fdc(int drive, bool interruptible)
 
 	command_status = FD_COMMAND_NONE;
 
+	DPRINT("lock_fdc: %d (out of %d)\n", drive, N_DRIVE);
+	WARN_ON_ONCE(drive < 0 || drive >= N_DRIVE);
+
 	reschedule_timeout(drive, "lock fdc");
 	set_fdc(drive);
 	return 0;

-- 
Calvin Walton <calvin.walton@kepstin.ca>

