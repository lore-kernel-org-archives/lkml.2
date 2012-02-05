Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2BEW4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:56:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45709 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2BEW4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:56:08 -0500
MIME-Version: 1.0
In-Reply-To: <4F2EED22.3070901@t-online.de>
References: <4F2EED22.3070901@t-online.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 Feb 2012 14:55:47 -0800
X-Google-Sender-Auth: j_A_ACZz_BdHbz3B9OcUhMk8QUY
Message-ID: <CA+55aFzPiy5RB+B70gPGX7sSJvcwqHuwL9F=SGMZBG58CuX9pQ@mail.gmail.com>
Subject: Re: [BUG 3.3-rc2] spinlock trylock failure on UP on CPU#0
To: Knut Petersen <Knut_Petersen@t-online.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, interesting. You're triggering the issue because you have a UP
build with the spinlock debugging code enabled.

On Sun, Feb 5, 2012 at 12:57 PM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
> Booting  23783f817bceedd6d4e549385e3f400ea64059e5 I get the following trace
> an AOpen i915GMm-hfs with Pentium-M Dothan:

This is probably the same "technically legal" code that LOCKDEP also
is unhappy about - the nested fast path release. We do a trylock on
the queue lock while we already are holding the queue lock
recursively.

Jens, Tejun - the crazy-ass games that this code is playing is clearly
messing not just with lockdep, it's messing with some very reasonable
spinlock sanity checks on UP (which just boil down to "a spinlock
should never have contention on UP")

Any chance of sanitizing this all?

                       Linus

> [   12.526390] BUG: spinlock trylock failure on UP on CPU#0, scsi_id/543
> [   12.528009]  lock: f4ed8830, .magic: dead4ead, .owner: scsi_id/543, .owner_cpu: 0
> [   12.528009] Pid: 543, comm: scsi_id Not tainted 3.3.0-rc2-main+ #21
> [   12.528009] Call Trace:
> [   12.528009]  [<c043e56d>] spin_dump+0x6c/0x76
> [   12.528009]  [<c043e594>] spin_bug+0x1d/0x21
> [   12.528009]  [<c027739a>] do_raw_spin_trylock+0x33/0x38
> [   12.528009]  [<c04429c2>] _raw_spin_trylock+0x17/0x63
> [   12.528009]  [<c025fafa>] put_io_context+0xa1/0x10a
> [   12.528009]  [<c0269d85>] __cfq_slice_expired+0x2f6/0x319
> [   12.528009]  [<c026a8b2>] cfq_dispatch_requests+0x39/0x714
> [   12.528009]  [<c025b328>] elv_drain_elevator+0x3f/0x7d
> [   12.528009]  [<c025b3f0>] __elv_add_request+0x8a/0x169
> [   12.528009]  [<c02604a4>] blk_execute_rq_nowait+0x88/0xab
> [   12.528009]  [<c0260573>] blk_execute_rq+0xac/0xcd
> [   12.528009]  [<c0263cf5>] sg_io+0x23c/0x325
> [   12.528009]  [<c02642a3>] scsi_cmd_ioctl+0x1b1/0x332
> [   12.528009]  [<c0264452>] scsi_cmd_blk_ioctl+0x2e/0x38
> [   12.528009]  [<c035c15e>] sd_ioctl+0xd4/0xf4
> [   12.528009]  [<c02618ce>] __blkdev_driver_ioctl+0x26/0x2e
> [   12.528009]  [<c026226a>] blkdev_ioctl+0x70e/0x728
> [   12.528009]  [<c01b3f87>] block_ioctl+0x31/0x39
> [   12.528009]  [<c019ebb9>] do_vfs_ioctl+0x47b/0x4af
> [   12.528009]  [<c019ec2e>] sys_ioctl+0x41/0x63
> [   12.528009]  [<c0442c05>] syscall_call+0x7/0xb
>
> cu,
>  -kp
