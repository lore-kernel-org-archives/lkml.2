Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab1EQXMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:12:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58363 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab1EQXMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=we6CMepr+epHddSSUZ4ZHOJ8F2P4q8AVEn71oRJUvchqbUQMXJZuN7U3aBgnaJKxEu
         1er36lmqQ8IHDVALYBpsB6PK9LRgaZL9DBKKClfejpy5tfil1AIlltzHcUS7yFI8uWP+
         Nyt5fClHgBy+EJSD7Hf0SQkg6XYrr3Z0CFCxg=
Date: Wed, 18 May 2011 01:12:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: BUG: NULL pointer deref in tty port / uart
Message-ID: <20110517231229.GB1776@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This happens in latest linus tree (v2.6.39-rc7) and I don't know the
earliest kernel that has this bug. I tested down to 2.6.36 which has
the same issue.

To reproduce, do the following steps, with a tty dev matching an 
unplugged serial line:

	echo 1 > /dev/ttyS4 # which blocks

And on another console:

	cat /dev/ttyS4 # which blocks

Then Ctrl + C the echo in the first console. This produces the
following trace:

[ 1494.395774] BUG: unable to handle kernel NULL pointer dereference at 00000000000001e0
[ 1494.400002] IP: [<ffffffff8143bb5b>] uart_dtr_rts+0x9b/0x180
[ 1494.400002] PGD 7a6ce067 PUD 761d3067 PMD 0 
[ 1494.400002] Oops: 0000 [#1] PREEMPT SMP 
[ 1494.400002] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[ 1494.400002] CPU 3 
[ 1494.400002] Modules linked in:
[ 1494.400002] 
[ 1494.400002] Pid: 1336, comm: cat Not tainted 2.6.39-rc7+ #14 Dell Inc. PowerEdge SC1430/0TW856
[ 1494.400002] RIP: 0010:[<ffffffff8143bb5b>]  [<ffffffff8143bb5b>] uart_dtr_rts+0x9b/0x180
[ 1494.400002] RSP: 0018:ffff8800761a5ab8  EFLAGS: 00010297
[ 1494.400002] RAX: ffffffff82059a80 RBX: ffff88007b160aa0 RCX: 0000000000000006
[ 1494.400002] RDX: 0000000000000000 RSI: ffff88007a656588 RDI: ffffffff8143bb23
[ 1494.400002] RBP: ffff8800761a5ad8 R08: 0000000000000000 R09: 0000000000000002
[ 1494.400002] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff82acf9a0
[ 1494.400002] R13: 0000000000000000 R14: ffff88007b160af0 R15: ffff88007a655ee0
[ 1494.400002] FS:  00007f708de3c720(0000) GS:ffff88007fcc0000(0000) knlGS:0000000000000000
[ 1494.400002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1494.400002] CR2: 00000000000001e0 CR3: 0000000079e77000 CR4: 00000000000006e0
[ 1494.400002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1494.400002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1494.400002] Process cat (pid: 1336, threadinfo ffff8800761a4000, task ffff88007a655ee0)
[ 1494.400002] Stack:
[ 1494.400002]  ffff88007b160aa0 ffff88007b160aa0 ffff8800794d3180 ffff88007a49d000
[ 1494.400002]  ffff8800761a5b88 ffffffff81426a84 ffff88007b160ab0 0000000081092de0
[ 1494.400002]  ffff8800761a5b18 ffff88007a655ee0 ffffffff819c13b5 ffff88007b160c18
[ 1494.400002] Call Trace:
[ 1494.400002]  [<ffffffff81426a84>] tty_port_block_til_ready+0x1d4/0x350
[ 1494.400002]  [<ffffffff819c13b5>] ? __mutex_unlock_slowpath+0xf5/0x170
[ 1494.400002]  [<ffffffff81092f4d>] ? trace_hardirqs_on_caller+0x13d/0x180
[ 1494.400002]  [<ffffffff8107a980>] ? wake_up_bit+0x40/0x40
[ 1494.400002]  [<ffffffff814390e0>] uart_open+0x160/0x1f0
[ 1494.400002]  [<ffffffff8141eb42>] tty_open+0x232/0x580
[ 1494.400002]  [<ffffffff81150d74>] chrdev_open+0x154/0x310
[ 1494.400002]  [<ffffffff81150c20>] ? cdev_put+0x30/0x30
[ 1494.400002]  [<ffffffff81149c27>] __dentry_open+0x187/0x440
[ 1494.400002]  [<ffffffff8114b531>] nameidata_to_filp+0x71/0x80
[ 1494.400002]  [<ffffffff8115a3db>] do_last+0xfb/0x970
[ 1494.400002]  [<ffffffff8115c446>] path_openat+0xc6/0x3d0
[ 1494.400002]  [<ffffffff8111423e>] ? might_fault+0x4e/0xa0
[ 1494.400002]  [<ffffffff8115c78d>] do_filp_open+0x3d/0xa0
[ 1494.400002]  [<ffffffff819c2f20>] ? _raw_spin_unlock+0x30/0x60
[ 1494.400002]  [<ffffffff8116a49d>] ? alloc_fd+0x19d/0x200
[ 1494.400002]  [<ffffffff8114b63c>] do_sys_open+0xfc/0x1d0
[ 1494.400002]  [<ffffffff8114b72b>] sys_open+0x1b/0x20
[ 1494.400002]  [<ffffffff819c8afb>] system_call_fastpath+0x16/0x1b
[ 1494.400002] Code: 75 33 4c 8b a3 a0 02 00 00 4c 8b 2b 49 8b 84 24 c8 00 00 00 48 85 c0 74 12 0f bf 50 42 41 3b 94 24 f4 00 00 00 0f 84 b5 00 00 00 
[ 1494.400002]  f6 85 e0 01 00 00 02 74 63 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d 
[ 1494.400002] RIP  [<ffffffff8143bb5b>] uart_dtr_rts+0x9b/0x180
[ 1494.400002]  RSP <ffff8800761a5ab8>
[ 1494.400002] CR2: 00000000000001e0
