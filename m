Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2EPO5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:57:25 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35592 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab2EPO5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:57:24 -0400
Date: Wed, 16 May 2012 07:57:17 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <20120516075717.18402f00@nehalam.linuxnetplumber.net>
In-Reply-To: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 09:36:51 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> There are several races in floppy driver between bottom half 
> (scheduled_work) and timers (fd_timeout, fd_timer). Due to slowness of the 
> actual floppy devices, those races are never (at least to my knowledge) 
> triggered on a bare floppy metal. However on virtualized (emulated) floppy 
> drives, which are of course magnitudes faster than the real ones, these 
> races trigger reliably. They usually exhibit themselves as NULL pointer 
> dereferences during DMA setup, such as
> 
> 	BUG: unable to handle kernel NULL pointer dereference at 0000000a
> 	[ ... snip ... ]
> 	EIP: 0060:[<c02053d5>] EFLAGS: 00010293 CPU: 0
> 	EAX: ffffe000 EBX: 0000000a ECX: 00000000 EDX: 0000000a
> 	ESI: c05d2718 EDI: 00000000 EBP: 00000000 ESP: f540fe44
> 	 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> 	Process swapper (pid: 0, ti=f540e000 task=c082d5a0 task.ti=c0826000)
> 	Stack:
> 	 ffffe000 00001ffc 00000000 00000000 00000000 c05d2718 c0708b40 f540fe80
> 	 c020470f c05d2718 c0708b40 00000000 f540fe80 0000000a f540fee4 00000000
> 	 c0708b40 f540fee4 00000000 00000000 c020526b 00000000 c05d2718 c0708b40
> 	Call Trace:
> 	 [<c020470f>] dump_trace+0xaf/0x110
> 	 [<c020526b>] show_trace_log_lvl+0x4b/0x60
> 	 [<c0205298>] show_trace+0x18/0x20
> 	 [<c05c5811>] dump_stack+0x6d/0x72
> 	 [<c0248527>] warn_slowpath_common+0x77/0xb0
> 	 [<c02485f3>] warn_slowpath_fmt+0x33/0x40
> 	 [<f7ec593c>] setup_DMA+0x14c/0x210 [floppy]
> 	 [<f7ecaa95>] setup_rw_floppy+0x105/0x190 [floppy]
> 	 [<c0256d08>] run_timer_softirq+0x168/0x2a0
> 	 [<c024e762>] __do_softirq+0xc2/0x1c0
> 	 [<c02042ed>] do_softirq+0x7d/0xb0
> 	 [<f54d8a00>] 0xf54d89ff
> 
> but other instances can be easily seen as well. This can be observed at 
> least under VMWare, VirtualBox and KVM.
> 
> This patch converts all the timers and bottom halfs to be processed in a 
> single workqueue. This aproach has been already discussed back in 2010 and 
> Acked by Linus [1], but it then never made it to the tree.
> 
> This all is based on original idea and code of Stephen Hemminger.  I have 
> ported original Stepen's code to the current state of the floppy driver, 
> and performed quite some testing (on real hardware), which didn't reveal 
> any issues (this includes not only writing and reading data, but also 
> formatting (unfortunately I didn't find any Double-Density disks any 
> more)). Ability to handle errors properly (supplying known bad floppies) 
> has also been verified.
> 
> [1] http://kerneltrap.org/mailarchive/linux-kernel/2010/6/11/4582092
> 
> Based-on-patch-by: Stephen Hemminger <shemminger@vyatta.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Thanks, the hold up for me was always finding real working floppy
drive to test.

