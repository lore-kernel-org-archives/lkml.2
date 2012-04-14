Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2DNWSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 18:18:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33798 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2DNWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 18:18:40 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 15:18:18 -0700
X-Google-Sender-Auth: oUt84DgWaJsFvUaGcSnTuoyl-0o
Message-ID: <CA+55aFxToKG2gMqHnUgjkGTr--X4FK9yzX7n0yc9xKuUGGRKmA@mail.gmail.com>
Subject: USB storage SCSI EH oops
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I got the appended NULL pointer dereference with current -git (plus
the RCU patches I'm testing, but they seem unrelated)..

The stack still has signs of some USB urb dequeue, so I suspect that
is related, even if it isn't in the actual stack frame trace (and this
is an example of why stack traces using pure frame pointer information
may not always be a good idea - the stale stack things that show up
can be interesting).

It triggered when I inserted a SD-card into my Dell monitor - as I
decided to finally try to use that reader. Obviously there's some
problem with it, but oopsing certainly isn't the solution.

The NULL pointer dereference is the "rq_disk->private_data" access -
it looks like rq_disk is NULL. This is all part of the whole
scsi_cmd_to_driver() thing.

I've added to the participants list the relevant parties, but I really
think the bug was introduced in commit 18a4d0a22ed6 ("[SCSI] Handle
disk devices which can not process medium access commands") which is
new since 3.3. That's the thing that added that whole
"scsi_cmd_to_driver()" call to the error path, and I suspect that the
problem is that it's simply not appropriate at that level. Presumably
the whole "rq_disk" thing is only set up much later, after the disk
has actually been recognized.

Please check this out asap.

                     Linus

---

  usb 2-1.4.1.1: reset high-speed USB device number 7 using ehci_hcd
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000220
  IP: [<ffffffff813e43c1>] scsi_send_eh_cmnd+0x41/0x2d0
  PGD 0
  Oops: 0000 [#1] PREEMPT SMP
  CPU 2
  Pid: 18579, comm: scsi_eh_9 Not tainted
3.4.0-rc2-00348-g7bcaa30035d1 #14 System manufacturer System Prod
  RIP: 0010:[<ffffffff813e43c1>]  [<ffffffff813e43c1>]
scsi_send_eh_cmnd+0x41/0x2d0
  RSP: 0018:ffff8801fb1e1cf0  EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffff880220914800 RCX: 0000000000000006
  RDX: ffffffff81d95668 RSI: ffff8801fb1e1d00 RDI: ffff880220914800
  RBP: ffff8801fb1e1dc0 R08: 0000000000000000 R09: dead000000100100
  R10: 0000000000000001 R11: 0000000000000001 R12: ffff8801fb1e1e90
  R13: ffff8801fb1e1d70 R14: 0000000000000006 R15: ffffffff81d95668
  FS:  0000000000000000(0000) GS:ffff88023fc40000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 0000000000000220 CR3: 0000000001c0b000 CR4: 00000000000007e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process scsi_eh_9 (pid: 18579, threadinfo ffff8801fb1e0000, task
ffff880231cc5e00)
  Stack:
   000009c4fb1e1d10 ffffffff81444f2e 0000000000000000 0000000000000082
   ffff8801fb1e1d60 ffffffff814458cb ffff8801fb1e0000 ffff8801ffffff98
   ffff880236875240 ffff88023263cdc8 7fffffffffffffff ffff88023263cdd0
  Call Trace:
   [<ffffffff81444f2e>] ? unlink_async+0x7e/0x80
   [<ffffffff814458cb>] ? ehci_urb_dequeue+0x8b/0xf0
   [<ffffffff816ae161>] ? wait_for_common+0x121/0x150
   [<ffffffff813e46e5>] scsi_eh_tur+0x25/0x80
   [<ffffffff813e47b0>] scsi_eh_test_devices+0x70/0x190
   [<ffffffff813e5679>] scsi_error_handler+0x419/0x480
   [<ffffffff813e5260>] ? scsi_eh_get_sense+0x100/0x100
   [<ffffffff813e5260>] ? scsi_eh_get_sense+0x100/0x100
   [<ffffffff8104ad96>] kthread+0x96/0xa0
   [<ffffffff816b1854>] kernel_thread_helper+0x4/0x10
   [<ffffffff8104ad00>] ? kthread_flush_work_fn+0x10/0x10
   [<ffffffff816b1850>] ? gs_change+0xb/0xb
  Code: d6 41 54 4c 8d 6d b0 53 48 89 fb 48 81 ec a8 00 00 00 89 8d 34
ff ff ff 48 8b 87 80 00 00 00 89 d1
  RIP  [<ffffffff813e43c1>] scsi_send_eh_cmnd+0x41/0x2d0
   RSP <ffff8801fb1e1cf0>
  CR2: 0000000000000220
  ---[ end trace e9fb437b88cc7b45 ]---
