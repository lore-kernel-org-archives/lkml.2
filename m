Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab1KLKjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 05:39:46 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52942 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1KLKjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 05:39:44 -0500
MIME-Version: 1.0
In-Reply-To: <20111112104859.7744b282@sf.home>
References: <20111112104859.7744b282@sf.home>
Date: Sat, 12 Nov 2011 18:39:42 +0800
Message-ID: <CAJd=RBDkxC0-oq9-L08H+mE0W47M8peONRB9M_Gz4+ZpDnrhAQ@mail.gmail.com>
Subject: Re: khugepaged blocks suspend2ram (3.2.0-rc1-00252-g8f042aa)
From: Hillf Danton <dhillf@gmail.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 3:48 PM, Sergei Trofimovich <slyich@gmail.com> wrote:
> $ cat /sys/kernel/mm/transparent_hugepage/enabled
> [always] madvise never
>
> $ echo mem > /sys/power/state
>
> [ 4036.239222] PM: Syncing filesystems ... done.
> [ 4040.198755] PM: Preparing system for mem sleep
> [ 4040.625898] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 4040.637103] Freezing remaining freezable tasks ...
> [ 4060.646142] Freezing of tasks failed after 20.00 seconds (1 tasks refusing to freeze, wq_busy=0):
> [ 4060.646180] khugepaged      S 0000000000000000     0   514      2 0x00800000
> [ 4060.646194]  ffff88007b231c70 0000000000000046 ffff88007b231c00 ffffffff00000000
> [ 4060.646209]  ffff88007bb40000 0000000000010ac0 ffff88007b231fd8 ffff88007b230000
> [ 4060.646222]  0000000000010ac0 0000000000004000 ffff88007b231fd8 0000000000010ac0
> [ 4060.646235] Call Trace:
> [ 4060.646254]  [<ffffffff810af8b1>] ? try_to_free_pages+0x71/0x80
> [ 4060.646265]  [<ffffffff8103eaf1>] ? get_parent_ip+0x11/0x50
> [ 4060.646275]  [<ffffffff8103ec9d>] ? add_preempt_count+0x9d/0xd0
> [ 4060.646286]  [<ffffffff81432f3a>] schedule+0x3a/0x50
> [ 4060.646294]  [<ffffffff81433408>] schedule_timeout+0x158/0x230
> [ 4060.646304]  [<ffffffff81052db0>] ? init_timer_deferrable_key+0x20/0x20
> [ 4060.646314]  [<ffffffff81433539>] schedule_timeout_interruptible+0x19/0x20
> [ 4060.646324]  [<ffffffff810de107>] khugepaged_alloc_hugepage+0xc7/0xf0
> [ 4060.646334]  [<ffffffff81063700>] ? wake_up_bit+0x40/0x40
> [ 4060.646344]  [<ffffffff814351f2>] ? _raw_spin_unlock_irqrestore+0x12/0x40
> [ 4060.646353]  [<ffffffff810de5ad>] khugepaged+0x9d/0x1240
> [ 4060.646364]  [<ffffffff81063700>] ? wake_up_bit+0x40/0x40
> [ 4060.646372]  [<ffffffff810de510>] ? prepare_pmd_huge_pte.clone.29+0x60/0x60
> [ 4060.646382]  [<ffffffff81063266>] kthread+0x96/0xa0
> [ 4060.646392]  [<ffffffff81436f54>] kernel_thread_helper+0x4/0x10
> [ 4060.646403]  [<ffffffff810631d0>] ? kthread_worker_fn+0x190/0x190
> [ 4060.646412]  [<ffffffff81436f50>] ? gs_change+0xb/0xb
> [ 4060.646521]
> [ 4060.646525] Restarting tasks ... done.
> [ 4060.660646] video LNXVIDEO:00: Restoring backlight state
>
> $ echo never > /sys/kernel/mm/transparent_hugepage/enabled
> $ cat /sys/kernel/mm/transparent_hugepage/enabled
> always madvise [never]
>
> $ echo mem > /sys/power/state
> suspended/resumed fine
>
> $ uname -a
> Linux sf 3.2.0-rc1-00252-g8f042aa #159 SMP PREEMPT Sat Nov 12 09:28:53 FET 2011 x86_64 Intel(R) Core(TM)2 Duo CPU U7600 @ 1.20GHz GenuineIntel GNU/Linux
>
> Tried to reproduce 2 times. Both are successful
>

Hi  Sergei

Would you please try the recent approach, at

            https://lkml.org/lkml/2011/11/9/312

Best regards
Hillf
8<--------------------------

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: thp: reduce khugepaged freezing latency

Use wait_event_freezable_timeout() instead of
schedule_timeout_interruptible() to avoid missing freezer wakeups. A
try_to_freeze() would have been needed in the
khugepaged_alloc_hugepage tight loop too in case of the allocation
failing repeatedly, and wait_event_freezable_timeout will provide it
too.

khugepaged would still freeze just fine by trying again the next
minute but it's better if it freezes immediately.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
