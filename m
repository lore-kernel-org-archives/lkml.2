Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0GUUDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:03:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0GUUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:03:05 -0400
Date: Wed, 21 Jul 2010 16:55:47 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] floppy: use single threaded workqueue
Message-ID: <20100721195547.GA3448@amt.cnet>
References: <20100609183449.110905403@vyatta.com>
 <alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>
 <20100609115403.75ebb6cb@nehalam>
 <alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org>
 <20100611103223.799d3ce0@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611103223.799d3ce0@nehalam>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 10:32:23AM -0700, Stephen Hemminger wrote:
> Fix races between timers and bottom half by using delayed work
> and a single threaded queue.
> 
> Still needs more testing.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> ---
>  drivers/block/floppy.c |  172 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 94 insertions(+), 78 deletions(-)

Stephen,

Can confirm this fixes the following oops seen under KVM guests.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000035
IP: [<ffffffff812141f0>] setup_rw_floppy+0x229/0x2ca
PGD 284b8067 PUD 3d79f067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/resource
CPU 1
Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables
scsi_wait_scan uhci_hcd ohci_hcd ehci_hcd

Pid: 28, comm: events/1 Not tainted 2.6.35-rc5-35033-g14e84ff #221
/Bochs RIP: 0010:[<ffffffff812141f0>]  [<ffffffff812141f0>] setup_rw_floppy+0x229/0x2ca
RSP: 0018:ffff88003e1a1e60  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000009 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000286 RDI: 0000000000000000
RBP: 00000000000000da R08: 0000000000000000 R09: ffffffff81214bdb
R10: 0000000000000000 R11: ffffffff817f7660 R12: 0000000000000000
R13: 0000000000000008 R14: ffffffff81214bdb R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880001a40000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000035 CR3: 000000003a428000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/1 (pid: 28, threadinfo ffff88003e1a0000, task
ffff88003e19a8f0)
Stack:
 0000000000000000 ffff88003e1a1ef8 ffffffff81692f00 ffff880001a56680
<0> ffff88003e19a8f0 ffffffff810466f1 0000000000000000 ffff88003e19a8f0
<0> ffffffff810495ad ffff88003e1a1ea8 ffff88003e1a1ea8 ffff88003e1a1ef8
Call Trace:
 [<ffffffff810466f1>] ? worker_thread+0x150/0x1f0
 [<ffffffff810495ad>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff810465a1>] ? worker_thread+0x0/0x1f0
 [<ffffffff810492bf>] ? kthread+0x79/0x81
 [<ffffffff81002be4>] ? kernel_thread_helper+0x4/0x10


