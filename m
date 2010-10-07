Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0JGVfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:35:54 -0400
Received: from www.tglx.de ([62.245.132.106]:54869 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0JGVfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:35:53 -0400
Date: Thu, 7 Oct 2010 23:35:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Airlie <airlied@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
In-Reply-To: <alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com> <alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Thomas Gleixner wrote:
> On Thu, 7 Oct 2010, Dave Airlie wrote:
> Oct  7 22:24:19 ionos kernel: Console: switching to colour VGA+ 80x25
> Oct  7 22:24:22 ionos kernel: drm: unregistered panic notifier
> Oct  7 22:24:22 ionos kernel: vga_switcheroo: disabled
> Oct  7 22:24:22 ionos kernel: BUG: sleeping function called from invalid context at /home/tglx/work/kernel/git/linux-2.6/arch/x86/mm/fault.c:1074
> Oct  7 22:24:22 ionos kernel: in_atomic(): 0, irqs_disabled(): 1, pid: 2681, name: udevd
> Oct  7 22:24:22 ionos kernel: Pid: 2681, comm: udevd Not tainted 2.6.36-rc7 #4
> Oct  7 22:24:22 ionos kernel: Call Trace:
> Oct  7 22:24:22 ionos kernel: [<ffffffff8103d3d1>] __might_sleep+0xed/0xef
> Oct  7 22:24:22 ionos kernel: [<ffffffff81452d81>] do_page_fault+0x1b2/0x2bb
> Oct  7 22:24:22 ionos kernel: [<ffffffff8144ff55>] page_fault+0x25/0x30
> Oct  7 22:24:22 ionos kernel: [<ffffffff8106af14>] ? lock_hrtimer_base+0x22/0x50
> Oct  7 22:24:22 ionos kernel: [<ffffffff8106af5e>] hrtimer_get_remaining+0x1c/0x46
> Oct  7 22:24:22 ionos kernel: [<ffffffff8105119d>] itimer_get_remtime+0x16/0x3c
> 
> That means that the hrtimer in the shared signal handler is corrupted. Uurg.
> 
> Oct  7 22:24:22 ionos kernel: [<ffffffff8106d127>] ? abort_creds+0x1a/0x1c
> Oct  7 22:24:22 ionos kernel: [<ffffffff81051445>] do_setitimer+0x97/0x1e7
> Oct  7 22:24:22 ionos kernel: [<ffffffff81051674>] alarm_setitimer+0x3a/0x60
> Oct  7 22:24:22 ionos kernel: [<ffffffff8105a248>] sys_alarm+0xe/0x12
> Oct  7 22:24:22 ionos kernel: [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
> Oct  7 22:24:22 ionos kernel: BUG: unable to handle kernel paging request at 00000000934a2400
> 
> Something is fishy here. That's not a kernel address

I tried the patch you pointed me to on IRC:

http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=dab8dcfa3c8e3b021a138bee7c17791b4991ba55

The first test worked fine. But after I added some debugging I got
another weird corruption this time on the first unload:

Oct  7 23:21:24 ionos kernel: Console: switching to colour VGA+ 80x25
Oct  7 23:21:31 ionos kernel: drm: unregistered panic notifier
Oct  7 23:21:31 ionos kernel: vga_switcheroo: disabled
Oct  7 23:21:31 ionos kernel: [drm:drm_mm_takedown] *ERROR* Memory manager not clean. Delaying takedown

That one scares me :)

Oct  7 23:21:31 ionos kernel: [drm] Module unloaded
Oct  7 23:21:32 ionos kernel: BUG: sleeping function called from invalid context at /home/tglx/work/kernel/git/linux-2.6/arch/x86/mm/fault.c:1074
Oct  7 23:21:32 ionos kernel: in_atomic(): 0, irqs_disabled(): 1, pid: 1243, name: dbus-daemon
Oct  7 23:21:32 ionos kernel: Pid: 1243, comm: dbus-daemon Not tainted 2.6.36-rc7+ #6
Oct  7 23:21:32 ionos kernel: Call Trace:
Oct  7 23:21:32 ionos kernel: [<ffffffff8103d3d1>] __might_sleep+0xed/0xef
Oct  7 23:21:32 ionos kernel: [<ffffffff81452d81>] do_page_fault+0x1b2/0x2bb
Oct  7 23:21:32 ionos kernel: [<ffffffff8144ff55>] page_fault+0x25/0x30
Oct  7 23:21:32 ionos kernel: [<ffffffff813988bd>] ? sock_alloc_send_pskb+0xd6/0x2eb
Oct  7 23:21:32 ionos kernel: [<ffffffff8110044d>] ? __kmalloc_node_track_caller+0x149/0x154
Oct  7 23:21:32 ionos kernel: [<ffffffff813988bd>] ? sock_alloc_send_pskb+0xd6/0x2eb
Oct  7 23:21:32 ionos kernel: [<ffffffff8139cc02>] __alloc_skb+0x83/0x141
Oct  7 23:21:32 ionos kernel: [<ffffffff813988bd>] sock_alloc_send_pskb+0xd6/0x2eb
Oct  7 23:21:32 ionos kernel: [<ffffffff81039551>] ? __wake_up_common+0x4e/0x84
Oct  7 23:21:32 ionos kernel: [<ffffffff81399130>] ? cred_to_ucred+0x6d/0x79
Oct  7 23:21:32 ionos kernel: [<ffffffff81398ae7>] sock_alloc_send_skb+0x15/0x17
Oct  7 23:21:32 ionos kernel: [<ffffffff81425818>] unix_stream_sendmsg+0x11c/0x2c3
Oct  7 23:21:32 ionos kernel: [<ffffffff81394921>] __sock_sendmsg+0x6b/0x77
Oct  7 23:21:32 ionos kernel: [<ffffffff81396cc3>] ? sock_aio_write+0x0/0xd4
Oct  7 23:21:32 ionos kernel: [<ffffffff81396d83>] sock_aio_write+0xc0/0xd4
Oct  7 23:21:32 ionos kernel: [<ffffffff8110be39>] do_sync_readv_writev+0xc1/0x100
Oct  7 23:21:32 ionos kernel: [<ffffffff8110bba3>] ? might_fault+0x21/0x23
Oct  7 23:21:32 ionos kernel: [<ffffffff8110bbd4>] ? copy_from_user+0x2f/0x31
Oct  7 23:21:32 ionos kernel: [<ffffffff811d0379>] ? security_file_permission+0x2e/0x33
Oct  7 23:21:32 ionos kernel: [<ffffffff8110cb2e>] do_readv_writev+0xa7/0x129
Oct  7 23:21:32 ionos kernel: [<ffffffff8111bcfc>] ? d_kill+0x3e/0x46
Oct  7 23:21:32 ionos kernel: [<ffffffff8110d7f6>] ? fput+0x214/0x223
Oct  7 23:21:32 ionos kernel: [<ffffffff8110cbf3>] vfs_writev+0x43/0x4e
Oct  7 23:21:32 ionos kernel: [<ffffffff8110cce3>] sys_writev+0x4a/0x93
Oct  7 23:21:32 ionos kernel: [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Oct  7 23:21:32 ionos kernel: BUG: unable to handle kernel paging request at 00000037362e313a

We are again dereferencing a user space address.

Thanks,

	tglx
