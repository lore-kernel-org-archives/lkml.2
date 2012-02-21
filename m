Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2BURav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:30:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44131 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2BURau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:30:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.129.228 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Tue, 21 Feb 2012 09:30:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] percpu: use raw_local_irq_* in _this_cpu op
Message-ID: <20120221173042.GC12236@google.com>
References: <1329296078-17751-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329296078-17751-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 04:54:38PM +0800, Ming Lei wrote:
> It doesn't make sense to trace irq off or do irq flags
> lock proving inside 'this_cpu' operations, so replace local_irq_*
> with raw_local_irq_* in 'this_cpu' op.
> 
> Also the patch fixes onelockdep warning[1] by the replacement, see
> below:
> 
> In commit: 933393f58fef9963eac61db8093689544e29a600(percpu:
> Remove irqsafe_cpu_xxx variants), local_irq_save/restore(flags) are
> added inside this_cpu_inc operation, so that trace_hardirqs_off_caller
> will be called by trace_hardirqs_on_caller directly because
> __debug_atomic_inc is implemented as this_cpu_inc, which may trigger
> the lockdep warning[1], for example in the below ARM scenary:
> 
> 	kernel_thread_helper	/*irq disabled*/
> 		->trace_hardirqs_on_caller	/*hardirqs_enabled was set*/
> 			->trace_hardirqs_off_caller	/*hardirqs_enabled cleared*/
> 				__this_cpu_add(redundant_hardirqs_on)
> 			->trace_hardirqs_off_caller	/*irq disabled, so call here*/
> 
> The 'unannotated irqs-on' warning will be triggered somewhere because
> irq is just enabled after the irq trace in kernel_thread_helper.
> 
> [1],
> [    0.162841] ------------[ cut here ]------------
> [    0.167694] WARNING: at kernel/lockdep.c:3493 check_flags+0xc0/0x1d0()
> [    0.174468] Modules linked in:
> [    0.177703] Backtrace:
> [    0.180328] [<c00171f0>] (dump_backtrace+0x0/0x110) from [<c0412320>] (dump_stack+0x18/0x1c)
> [    0.189086]  r6:c051f778 r5:00000da5 r4:00000000 r3:60000093
> [    0.195007] [<c0412308>] (dump_stack+0x0/0x1c) from [<c00410e8>] (warn_slowpath_common+0x54/0x6c)
> [    0.204223] [<c0041094>] (warn_slowpath_common+0x0/0x6c) from [<c0041124>] (warn_slowpath_null+0x24/0x2c)
> [    0.214111]  r8:00000000 r7:00000000 r6:ee069598 r5:60000013 r4:ee082000
> [    0.220825] r3:00000009
> [    0.223693] [<c0041100>] (warn_slowpath_null+0x0/0x2c) from [<c0088f38>] (check_flags+0xc0/0x1d0)
> [    0.232910] [<c0088e78>] (check_flags+0x0/0x1d0) from [<c008d348>] (lock_acquire+0x4c/0x11c)
> [    0.241668] [<c008d2fc>] (lock_acquire+0x0/0x11c) from [<c0415aa4>] (_raw_spin_lock+0x3c/0x74)
> [    0.250610] [<c0415a68>] (_raw_spin_lock+0x0/0x74) from [<c010a844>] (set_task_comm+0x20/0xc0)
> [    0.259521]  r6:ee069588 r5:ee0691c0 r4:ee082000
> [    0.264404] [<c010a824>] (set_task_comm+0x0/0xc0) from [<c0060780>] (kthreadd+0x28/0x108)
> [    0.272857]  r8:00000000 r7:00000013 r6:c0044a08 r5:ee0691c0 r4:ee082000
> [    0.279571] r3:ee083fe0
> [    0.282470] [<c0060758>] (kthreadd+0x0/0x108) from [<c0044a08>] (do_exit+0x0/0x6dc)
> [    0.290405]  r5:c0060758 r4:00000000
> [    0.294189] ---[ end trace 1b75b31a2719ed1c ]---
> [    0.299041] possible reason: unannotated irqs-on.
> [    0.303955] irq event stamp: 5
> [    0.307159] hardirqs last  enabled at (4): [<c001331c>] no_work_pending+0x8/0x2c
> [    0.314880] hardirqs last disabled at (5): [<c0089b08>] trace_hardirqs_on_caller+0x60/0x26c
> [    0.323547] softirqs last  enabled at (0): [<c003f754>] copy_process+0x33c/0xef4
> [    0.331207] softirqs last disabled at (0): [<  (null)>]   (null)
> [    0.337585] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Applied to for-3.3-fixes.  Thank you.

-- 
tejun
