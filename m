Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2CON2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 09:28:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46208 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2CON2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 09:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqcGcfYzjrvRU-z=mUSq+wgqfBqdM51shV5gk4ohfe5Wng@mail.gmail.com>
References: <CA+1xoqcGcfYzjrvRU-z=mUSq+wgqfBqdM51shV5gk4ohfe5Wng@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 15 Mar 2012 15:28:17 +0200
Message-ID: <CA+1xoqdeuorMi+=EZLpyrBN9L+J2o4SF-8meY=5Qypze9XrpiQ@mail.gmail.com>
Subject: Re: ntp: BUG: spinlock lockup on CPU#1
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 3:23 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Hi all,
>
> I was doing some more fuzzing with trinity in a KVM tools guest, using
> today's linux-next, when I've experienced a complete system lockup
> (just in the guest ofcourse). After a bit I got the spew at the bottom
> of this mail.
>
> From what I can tell from the logs, there were several threads waiting
> on syscall results, and I suspect that the adjtimex() call on CPU3 is
> somehow responsible for this lockup.

Oh, and I'm not sure if it's related or not, but I've started seeing
the following spew every time I start fuzzing:

[   47.105987] ------------[ cut here ]------------
[   47.106021] WARNING: at kernel/time/clockevents.c:209
clockevents_program_event+0xf2/0x100()
[   47.107463] Pid: 3091, comm: trinity Not tainted
3.3.0-rc7-next-20120315-sasha-00002-g91cfd71 #51
[   47.107463] Call Trace:
[   47.107463]  <IRQ>  [<ffffffff8110e4d2>] ?
clockevents_program_event+0xf2/0x100
[   47.107463]  [<ffffffff810b1c25>] warn_slowpath_common+0x75/0xb0
[   47.107463]  [<ffffffff810b1d25>] warn_slowpath_null+0x15/0x20
[   47.107463]  [<ffffffff8110e4d2>] clockevents_program_event+0xf2/0x100
[   47.107463]  [<ffffffff8111009f>] tick_program_event+0x1f/0x30
[   47.107463]  [<ffffffff810db57a>] hrtimer_interrupt+0x12a/0x220
[   47.107463]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   47.107463]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[   47.107463]  <EOI>  [<ffffffff8270a9f4>] ? retint_restore_args+0x13/0x13
[   47.107463]  [<ffffffff811c2090>] ? arch_local_irq_restore+0x10/0x20
[   47.107463]  [<ffffffff811c7755>] __slab_alloc.clone.45+0x635/0x660
[   47.107463]  [<ffffffff810ec255>] ? sched_clock_local+0x25/0x90
[   47.107463]  [<ffffffff811fd892>] ? __d_alloc+0x32/0x1a0
[   47.107463]  [<ffffffff811c802f>] kmem_cache_alloc+0x15f/0x180
[   47.107463]  [<ffffffff811fd892>] ? __d_alloc+0x32/0x1a0
[   47.107463]  [<ffffffff811fd892>] __d_alloc+0x32/0x1a0
[   47.107463]  [<ffffffff811fda43>] d_alloc+0x23/0x80
[   47.107463]  [<ffffffff811ef2d8>] d_alloc_and_lookup+0x28/0x80
[   47.107463]  [<ffffffff811fe500>] ? d_lookup+0x30/0x50
[   47.107463]  [<ffffffff811f12b4>] do_lookup+0x2b4/0x3b0
[   47.107463]  [<ffffffff811f2294>] path_lookupat+0x134/0x820
[   47.107463]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   47.107463]  [<ffffffff811f29ac>] do_path_lookup+0x2c/0xc0
[   47.107463]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   47.107463]  [<ffffffff811f2ed4>] user_path_at_empty+0x54/0xa0
[   47.107463]  [<ffffffff8119ee07>] ? might_fault+0x97/0xa0
[   47.107463]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   47.107463]  [<ffffffff810dff71>] ? lg_local_unlock+0x51/0x80
[   47.107463]  [<ffffffff811e8e43>] ? cp_new_stat+0xf3/0x110
[   47.107463]  [<ffffffff811f2f2c>] user_path_at+0xc/0x10
[   47.107463]  [<ffffffff811e91ef>] vfs_fstatat+0x3f/0x80
[   47.107463]  [<ffffffff811e9269>] vfs_lstat+0x19/0x20
[   47.107463]  [<ffffffff811e938f>] sys_newlstat+0x1f/0x40
[   47.107463]  [<ffffffff81885e0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   47.107463]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   47.107463] ---[ end trace 0ada3703f333fa52 ]---
