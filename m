Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2KZNIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:08:41 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51431 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2KZNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:08:39 -0500
MIME-Version: 1.0
In-Reply-To: <20120823141422.444396696@google.com>
References: <20120823141422.444396696@google.com>
Date: Mon, 26 Nov 2012 18:38:38 +0530
Message-ID: <CABb+yY2Cr=mvVW=m12uOaLTydE8j3iB2m0wrVt0gOrO3tz+mZA@mail.gmail.com>
Subject: Re: [patch 00/16] sched: per-entity load-tracking
From: Jassi Brar <jassisinghbrar@gmail.com>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Aug 23, 2012 at 7:44 PM,  <pjt@google.com> wrote:
> Hi all,
>
> Please find attached the latest version for CFS load-tracking.
>
> It implements load-tracking on a per-sched_entity (currently SCHED_NORMAL, but
> could be extended to RT as well) basis. This results in a bottom-up
> load-computation in which entities contribute to their parents' load, as
> opposed to the current top-down where the parent averages its children.  In
> particular this allows us to correctly migrate load with their accompanying
> entities and provides the necessary inputs for intelligent load-balancing and
> power-management.
>
> We've been running this internally for some time now and modulo any gremlins
> from rebasing it, I think things have been shaken out and we're touching
> mergeable state.
>
> Special thanks to Namhyung Kim and Peter Zijlstra for comments on the last
> round series.
>
> For more background and prior discussion please review the previous posting:
> https://lkml.org/lkml/2012/6/27/644
>
The patchset introduces 64-bit atomic ops, which would need
init_atomic64_lock() already called, but that is an initcall made too
late. Should we consider calling init_atomic64_lock() sooner in
start_kernel()?

As an example of breakage, I see the following dump with
CONFIG_DEBUG_SPINLOCK on an OMAP based Pandaboard.
   ........
    Calibrating delay loop...
    BUG: spinlock bad magic on CPU#0, swapper/0/0
     lock: atomic64_lock+0x0/0x400, .magic: 00000000, .owner:
<none>/-1, .owner_cpu: 0
    [<c001f734>] (unwind_backtrace+0x0/0x13c) from [<c06a8f4c>]
(dump_stack+0x20/0x24)
    [<c06a8f4c>] (dump_stack+0x20/0x24) from [<c0359118>] (spin_dump+0x84/0x98)
    [<c0359118>] (spin_dump+0x84/0x98) from [<c0359158>] (spin_bug+0x2c/0x30)
    [<c0359158>] (spin_bug+0x2c/0x30) from [<c03593c8>]
(do_raw_spin_lock+0x1c0/0x200)
    [<c03593c8>] (do_raw_spin_lock+0x1c0/0x200) from [<c06acfbc>]
(_raw_spin_lock_irqsave+0x64/0x70)
    [<c06acfbc>] (_raw_spin_lock_irqsave+0x64/0x70) from [<c03675f4>]
(atomic64_read+0x30/0x54)
    [<c03675f4>] (atomic64_read+0x30/0x54) from [<c008f9dc>]
(update_cfs_rq_blocked_load+0x64/0x140)
    [<c008f9dc>] (update_cfs_rq_blocked_load+0x64/0x140) from
[<c0093c88>] (task_tick_fair+0x2a4/0x798)
    [<c0093c88>] (task_tick_fair+0x2a4/0x798) from [<c008b7e8>]
(scheduler_tick+0xd4/0x10c)
    [<c008b7e8>] (scheduler_tick+0xd4/0x10c) from [<c00644d4>]
(update_process_times+0x6c/0x7c)
    [<c00644d4>] (update_process_times+0x6c/0x7c) from [<c00a67a0>]
(tick_periodic+0x58/0xd4)
    [<c00a67a0>] (tick_periodic+0x58/0xd4) from [<c00a68dc>]
(tick_handle_periodic+0x28/0x9c)
    [<c00a68dc>] (tick_handle_periodic+0x28/0x9c) from [<c002e780>]
(omap2_gp_timer_interrupt+0x34/0x44)
    [<c002e780>] (omap2_gp_timer_interrupt+0x34/0x44) from
[<c00d004c>] (handle_irq_event_percpu+0x78/0x29c)
    [<c00d004c>] (handle_irq_event_percpu+0x78/0x29c) from
[<c00d02bc>] (handle_irq_event+0x4c/0x6c)
    [<c00d02bc>] (handle_irq_event+0x4c/0x6c) from [<c00d3490>]
(handle_fasteoi_irq+0xcc/0x1a4)
    [<c00d3490>] (handle_fasteoi_irq+0xcc/0x1a4) from [<c00cf90c>]
(generic_handle_irq+0x30/0x40)
    [<c00cf90c>] (generic_handle_irq+0x30/0x40) from [<c0016480>]
(handle_IRQ+0x5c/0xbc)
    [<c0016480>] (handle_IRQ+0x5c/0xbc) from [<c0008538>]
(gic_handle_irq+0x38/0x6c)
    [<c0008538>] (gic_handle_irq+0x38/0x6c) from [<c06add24>]
(__irq_svc+0x44/0x7c)
    Exception stack(0xc0a0ff00 to 0xc0a0ff48)
    ff00: 0000001a ffff6a00 c0a100c0 ffff6a00 00000000 00000000
c0ac0280 00000000
    ff20: c0ac030c 410fc0f0 c0a100c0 c0a0ffb4 c0a0fe80 c0a0ff48
c0a100c0 c06a5110
    ff40: 60000053 ffffffff
    [<c06add24>] (__irq_svc+0x44/0x7c) from [<c06a5110>]
(calibrate_delay+0x37c/0x528)
    [<c06a5110>] (calibrate_delay+0x37c/0x528) from [<c09977f0>]
(start_kernel+0x270/0x310)
    [<c09977f0>] (start_kernel+0x270/0x310) from [<80008078>] (0x80008078)
    1590.23 BogoMIPS (lpj=6213632)
    .....


Thanks.
