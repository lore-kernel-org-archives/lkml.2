Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1KRPju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:39:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32885 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab1KRPjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:39:48 -0500
MIME-Version: 1.0
In-Reply-To: <1321629441.7080.15.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	<1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	<1321435455.5072.64.camel@marge.simson.net>
	<1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	<1321495153.5100.7.camel@marge.simson.net>
	<1321629267.7080.13.camel@marge.simson.net>
	<1321629441.7080.15.camel@marge.simson.net>
Date: Fri, 18 Nov 2011 23:39:46 +0800
Message-ID: <CAJd=RBDYmffOoUFt3LuzTUhYgkJhTHzUTxZjcyqoB37j21x7bw@mail.gmail.com>
Subject: Re: [patch 1/6] sched: use rt.nr_cpus_allowed to recover
 select_task_rq() cycles
From: Hillf Danton <dhillf@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAIFdwrn011374

On Fri, Nov 18, 2011 at 11:17 PM, Mike Galbraith <efault@gmx.de> wrote:
>
> rt.nr_cpus_allowed is always available, use it to bail from select_task_rq()
> when only one cpu can be used, and saves some cycles for pinned tasks.
>
> taskset -c 3 pipe-test
>
>   PerfTop:     997 irqs/sec  kernel:89.5%  exact:  0.0% [1000Hz cycles],  (all, CPU: 3)
> ------------------------------------------------------------------------------------------------
>
>             Virgin                                    Patched
>             samples  pcnt function                    samples  pcnt function
>             _______ _____ ___________________________ _______ _____ ___________________________
>
>             2880.00 10.2% __schedule                  3136.00 11.3% __schedule
>             1634.00  5.8% pipe_read                   1615.00  5.8% pipe_read
>             1458.00  5.2% system_call                 1534.00  5.5% system_call
>             1382.00  4.9% _raw_spin_lock_irqsave      1412.00  5.1% _raw_spin_lock_irqsave
>             1202.00  4.3% pipe_write                  1255.00  4.5% copy_user_generic_string
>             1164.00  4.1% copy_user_generic_string    1241.00  4.5% __switch_to
>             1097.00  3.9% __switch_to                  929.00  3.3% mutex_lock
>              872.00  3.1% mutex_lock                   846.00  3.0% mutex_unlock
>              687.00  2.4% mutex_unlock                 804.00  2.9% pipe_write
>              682.00  2.4% native_sched_clock           713.00  2.6% native_sched_clock
>              643.00  2.3% system_call_after_swapgs     653.00  2.3% _raw_spin_unlock_irqrestore
>              617.00  2.2% sched_clock_local            633.00  2.3% fsnotify
>              612.00  2.2% fsnotify                     605.00  2.2% sched_clock_local
>              596.00  2.1% _raw_spin_unlock_irqrestore  593.00  2.1% system_call_after_swapgs
>              542.00  1.9% sysret_check                 559.00  2.0% sysret_check
>              467.00  1.7% fget_light                   472.00  1.7% fget_light
>              462.00  1.6% finish_task_switch           461.00  1.7% finish_task_switch
>              437.00  1.5% vfs_write                    442.00  1.6% vfs_write
>              431.00  1.5% do_sync_write                428.00  1.5% do_sync_write
> *             413.00  1.5% select_task_rq_fair          404.00  1.5% _raw_spin_lock_irq
>              386.00  1.4% update_curr                  402.00  1.4% update_curr
>              385.00  1.4% rw_verify_area               389.00  1.4% do_sync_read
>              377.00  1.3% _raw_spin_lock_irq           378.00  1.4% vfs_read
>              369.00  1.3% do_sync_read                 340.00  1.2% pipe_iov_copy_from_user
>              360.00  1.3% vfs_read                     316.00  1.1% __wake_up_sync_key
>              342.00  1.2% hrtick_start_fair            313.00  1.1% __wake_up_common
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
>

Acked-by: Hillf Danton <dhillf@gmail.com>

> ---
>  kernel/sched_fair.c |    3 +++
>  kernel/sched_rt.c   |    3 +++
>  2 files changed, 6 insertions(+)
>
> Index: linux-3.2.git/kernel/sched_fair.c
> ===================================================================
> --- linux-3.2.git.orig/kernel/sched_fair.c
> +++ linux-3.2.git/kernel/sched_fair.c
> @@ -2340,6 +2340,9 @@ select_task_rq_fair(struct task_struct *
>        int want_sd = 1;
>        int sync = wake_flags & WF_SYNC;
>
> +       if (p->rt.nr_cpus_allowed < 2)
> +               return prev_cpu;
> +
>        if (sd_flag & SD_BALANCE_WAKE) {
>                if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
>                        want_affine = 1;
> Index: linux-3.2.git/kernel/sched_rt.c
> ===================================================================
> --- linux-3.2.git.orig/kernel/sched_rt.c
> +++ linux-3.2.git/kernel/sched_rt.c
> @@ -999,6 +999,9 @@ select_task_rq_rt(struct task_struct *p,
>
>        cpu = task_cpu(p);
>
> +       if (p->rt.nr_cpus_allowed < 2)
> +               goto out;
> +
>        /* For anything but wake ups, just return the task_cpu */
>        if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
>                goto out;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
