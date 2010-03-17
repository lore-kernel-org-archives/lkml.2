Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0CQC1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:27:00 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:44359 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0CQC06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f0T+8Z4X062tW4goSvC8RYNUkWBhqIsV/uOVpQT05uMmKYsSOQvJdUgzyosJpAV1qa
         G1jrX19J2+suSCZGMJ9NOfoiqvWbH9nE/drqelqNJ+veWJczNiRxOmV5Clq7g/GgMLrU
         hERM8Ur/7qR/Qpo/ryk/CfKmlgE7J9Zwo7gWw=
MIME-Version: 1.0
In-Reply-To: <20100316170808.GA29400@redhat.com>
References: <20100316170808.GA29400@redhat.com>
Date: Wed, 17 Mar 2010 11:26:58 +0900
Message-ID: <28c262361003161926w2323e4fcnd51e9802681f7b4b@mail.gmail.com>
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
From: Minchan Kim <minchan.kim@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: cl@linux-foundation.org, lee.schermerhorn@hp.com, rientjes@google.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 2:08 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> In 2.6.34-rc1, removing vhost_net module causes an oops in sync_mm_rss
> (called from do_exit) when workqueue is destroyed. This does not happen on
> net-next, or with vhost on top of to 2.6.33.
>
> The issue seems to be introduced by
> 34e55232e59f7b19050267a05ff1226e5cd122a5: that commit added function
> sync_mm_rss that is passed task->mm, and dereferences it without
> checking. If task is a kernel thread, mm might be NULL.
> I think this might also happen e.g. with aio.
>
> This patch fixes the oops by calling sync_mm_rss when task->mm
> is set to NULL. I also added BUG_ON to detect any other cases
> where counters get incremented while mm is NULL.
>
> The oops I observed looks like this:
>
> BUG: unable to handle kernel NULL pointer dereference at 00000000000002a8
> IP: [<ffffffff810b436d>] sync_mm_rss+0x33/0x6f
> PGD 0
> Oops: 0002 [#1] SMP
> last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> CPU 2
> Modules linked in: vhost_net(-) tun bridge stp sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table kvm_intel kvm i5000_edac edac_core rtc_cmos bnx2 button i2c_i801 i2c_core rtc_core e1000e sg joydev ide_cd_mod serio_raw pcspkr rtc_lib cdrom virtio_net virtio_blk virtio_pci virtio_ring virtio af_packet e1000 shpchp aacraid uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
>
> Pid: 2046, comm: vhost Not tainted 2.6.34-rc1-vhost #25 System Planar/IBM System x3550 -[7978B3G]-
> RIP: 0010:[<ffffffff810b436d>]  [<ffffffff810b436d>] sync_mm_rss+0x33/0x6f
> RSP: 0018:ffff8802379b7e60  EFLAGS: 00010202
> RAX: 0000000000000008 RBX: ffff88023f2390c0 RCX: 0000000000000000
> RDX: ffff88023f2396b0 RSI: 0000000000000000 RDI: ffff88023f2390c0
> RBP: ffff8802379b7e60 R08: 0000000000000000 R09: 0000000000000000
> R10: ffff88023aecfbc0 R11: 0000000000013240 R12: 0000000000000000
> R13: ffffffff81051a6c R14: ffffe8ffffc0f540 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff880001e80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000000002a8 CR3: 000000023af23000 CR4: 00000000000406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process vhost (pid: 2046, threadinfo ffff8802379b6000, task ffff88023f2390c0)
> Stack:
>  ffff8802379b7ee0 ffffffff81040687 ffffe8ffffc0f558 ffffffffa00a3e2d
> <0> 0000000000000000 ffff88023f2390c0 ffffffff81055817 ffff8802379b7e98
> <0> ffff8802379b7e98 0000000100000286 ffff8802379b7ee0 ffff88023ad47d78
> Call Trace:
>  [<ffffffff81040687>] do_exit+0x147/0x6c4
>  [<ffffffffa00a3e2d>] ? handle_rx_net+0x0/0x17 [vhost_net]
>  [<ffffffff81055817>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffff81051a6c>] ? worker_thread+0x0/0x229
>  [<ffffffff810553c9>] kthreadd+0x0/0xf2
>  [<ffffffff810038d4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81055342>] ? kthread+0x0/0x87
>  [<ffffffff810038d0>] ? kernel_thread_helper+0x0/0x10
> Code: 00 8b 87 6c 02 00 00 85 c0 74 14 48 98 f0 48 01 86 a0 02 00 00 c7 87 6c 02 00 00 00 00 00 00 8b 87 70 02 00 00 85 c0 74 14 48 98 <f0> 48 01 86 a8 02 00 00 c7 87 70 02 00 00 00 00 00 00 8b 87 74
> RIP  [<ffffffff810b436d>] sync_mm_rss+0x33/0x6f
>  RSP <ffff8802379b7e60>
> CR2: 00000000000002a8
> ---[ end trace 41603ba922beddd2 ]---
> Fixing recursive fault but reboot is needed!
>
> (note: handle_rx_net is a work item using workqueue in question).
> sync_mm_rss+0x33/0x6f gave me a hint. I also tried reverting
> 34e55232e59f7b19050267a05ff1226e5cd122a5 and the oops goes away.
>
> The module in question calls use_mm and later unuse_mm from a kernel
> thread.  It is when this kernel thread is destroyed that the crash
> happens.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nice catch.

-- 
Kind regards,
Minchan Kim
