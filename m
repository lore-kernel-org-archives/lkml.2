Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1GED6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 23:58:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57736 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1GED6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 23:58:41 -0400
Date: Tue, 5 Jul 2011 11:58:13 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
Message-ID: <20110705035813.GC4656@localhost.localdomain>
References: <20110621071649.862846205@google.com>
 <4E01BE6B.2090701@jp.fujitsu.com>
 <1308830816.1022.112.camel@twins>
 <20110623124310.GA15430@elte.hu>
 <4E041C6A.4000701@jp.fujitsu.com>
 <20110626103526.GA11093@elte.hu>
 <20110629040521.GG4186@localhost.localdomain>
 <20110701122824.GE28008@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20110701122824.GE28008@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-05 11:57:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-05 11:58:02,
	Serialize complete at 2011-07-05 11:58:02
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 02:28:24PM +0200, Ingo Molnar wrote:
> 
> * Hu Tao <hutao@cn.fujitsu.com> wrote:
> 
> > > Yeah, these numbers look pretty good. Note that the percentages 
> > > in the third column (the amount of time that particular event was 
> > > measured) is pretty low, and it would be nice to eliminate it: 
> > > i.e. now that we know the ballpark figures do very precise 
> > > measurements that do not over-commit the PMU.
> > > 
> > > One such measurement would be:
> > > 
> > > 	-e cycles -e instructions -e branches
> > > 
> > > This should also bring the stddev percentages down i think, to 
> > > below 0.1%.
> > > 
> > > Another measurement would be to test not just the feature-enabled 
> > > but also the feature-disabled cost - so that we document the 
> > > rough overhead that users of this new scheduler feature should 
> > > expect.
> > > 
> > > Organizing it into neat before/after numbers and percentages, 
> > > comparing it with noise (stddev) [i.e. determining that the 
> > > effect we measure is above noise] and putting it all into the 
> > > changelog would be the other goal of these measurements.
> > 
> > Hi Ingo,
> > 
> > I've tested pipe-test-100k in the following cases: base(no patch), 
> > with patch but feature-disabled, with patch and several 
> > periods(quota set to be a large value to avoid processes 
> > throttled), the result is:
> > 
> > 
> >                                             cycles                   instructions            branches
> > -------------------------------------------------------------------------------------------------------------------
> > base                                        7,526,317,497           8,666,579,347            1,771,078,445
> > +patch, cgroup not enabled                  7,610,354,447 (1.12%)   8,569,448,982 (-1.12%)   1,751,675,193 (-0.11%)
> > +patch, 10000000000/1000(quota/period)      7,856,873,327 (4.39%)   8,822,227,540 (1.80%)    1,801,766,182 (1.73%)
> > +patch, 10000000000/10000(quota/period)     7,797,711,600 (3.61%)   8,754,747,746 (1.02%)    1,788,316,969 (0.97%)
> > +patch, 10000000000/100000(quota/period)    7,777,784,384 (3.34%)   8,744,979,688 (0.90%)    1,786,319,566 (0.86%)
> > +patch, 10000000000/1000000(quota/period)   7,802,382,802 (3.67%)   8,755,638,235 (1.03%)    1,788,601,070 (0.99%)
> > -------------------------------------------------------------------------------------------------------------------
> 
> ok, i had a quick look at the stddev numbers as well and most seem 
> below the 0.1 range, well below the effects you managed to measure. 
> So i think this table is pretty accurate and we can rely on it for 
> analysis.
> 
> So we've got a +1.1% incrase in overhead with cgroups disabled, while 
> the instruction count went down by 1.1%. Is this expected? If you 
> profile stalled cycles and use perf diff between base and patched 
> kernels, does it show you some new hotspot that causes the overhead?

perf diff shows 0.43% increase in sched_clock, and 0.98% decrease in
pipe_unlock. the complete output is attached.

> 
> To better understand the reasons behind that result, could you try to 
> see whether the cycles count is stable across reboots as well, or 
> does it vary beyond the ~1% value that you measure?
> 
> One thing that can help validating the measurements is to do:
> 
>   echo 1 > /proc/sys/vm/drop_caches
> 
> Before testing. This helps re-establish the whole pagecache layout 
> (which gives a lot of the across-boot variability of such 
> measurements).

I have tested three times for base and +patch,cgroup not enabled
repectively (each time reboot, drop_caches then perf). the data
seems stable comparing to those in the table above, see below:


                    cycles                   instructions
------------------------------------------------------------------
base                7,526,317,497            8,666,579,347
base, drop_caches   7,518,958,711 (-0.10%)   8,634,136,901(-0.37%)
base, drop_caches   7,526,419,287 (+0.00%)   8,641,162,766(-0.29%)
base, drop_caches   7,491,864,402 (-0.46%)   8,624,760,925(-0.48%)


                                       cycles                   instructions
--------------------------------------------------------------------------------------
+patch, cgroup disabled                7,610,354,447            8,569,448,982
+patch, cgroup disabled, drop_caches   7,574,623,093 (-0.47%)   8,572,061,001 (+0.03%)
+patch, cgroup disabled, drop_caches   7,594,083,776 (-0.21%)   8,574,447,382 (+0.06%)
+patch, cgroup disabled, drop_caches   7,584,913,316 (-0.33%)   8,574,734,269 (+0.06%)






perf diff output:

# Baseline  Delta          Shared Object                       Symbol
# ........ ..........  .................  ...........................
#
     0.00%    +10.07%  [kernel.kallsyms]  [k] __lock_acquire
     0.00%     +5.90%  [kernel.kallsyms]  [k] lock_release
     0.00%     +4.86%  [kernel.kallsyms]  [k] trace_hardirqs_off_caller
     0.00%     +4.06%  [kernel.kallsyms]  [k] debug_smp_processor_id
     0.00%     +4.00%  [kernel.kallsyms]  [k] lock_acquire
     0.00%     +3.81%  [kernel.kallsyms]  [k] lock_acquired
     0.00%     +3.71%  [kernel.kallsyms]  [k] lock_is_held
     0.00%     +3.04%  [kernel.kallsyms]  [k] validate_chain
     0.00%     +2.68%  [kernel.kallsyms]  [k] check_chain_key
     0.00%     +2.41%  [kernel.kallsyms]  [k] trace_hardirqs_off
     0.00%     +2.01%  [kernel.kallsyms]  [k] trace_hardirqs_on_caller
     2.04%     -0.09%  pipe-test-100k     [.] main
     0.00%     +1.79%  [kernel.kallsyms]  [k] add_preempt_count
     0.00%     +1.67%  [kernel.kallsyms]  [k] lock_release_holdtime
     0.00%     +1.67%  [kernel.kallsyms]  [k] mutex_lock_nested
     0.00%     +1.61%  [kernel.kallsyms]  [k] pipe_read
     0.00%     +1.58%  [kernel.kallsyms]  [k] local_clock
     1.13%     +0.43%  [kernel.kallsyms]  [k] sched_clock
     0.00%     +1.52%  [kernel.kallsyms]  [k] sub_preempt_count
     0.00%     +1.39%  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     1.14%     +0.15%  libc-2.12.so       [.] __GI___libc_read
     0.00%     +1.21%  [kernel.kallsyms]  [k] mark_lock
     0.00%     +1.06%  [kernel.kallsyms]  [k] __mutex_unlock_slowpath
     0.00%     +1.03%  [kernel.kallsyms]  [k] match_held_lock
     0.00%     +0.96%  [kernel.kallsyms]  [k] copy_user_generic_string
     0.00%     +0.93%  [kernel.kallsyms]  [k] schedule
     0.00%     +0.76%  [kernel.kallsyms]  [k] __list_del_entry
     0.00%     +0.73%  [kernel.kallsyms]  [k] enqueue_entity
     0.00%     +0.68%  [kernel.kallsyms]  [k] cpuacct_charge
     0.00%     +0.62%  [kernel.kallsyms]  [k] trace_preempt_off
     0.00%     +0.59%  [kernel.kallsyms]  [k] vfs_write
     0.00%     +0.56%  [kernel.kallsyms]  [k] trace_preempt_on
     0.00%     +0.56%  [kernel.kallsyms]  [k] system_call
     0.00%     +0.55%  [kernel.kallsyms]  [k] sys_read
     0.00%     +0.54%  [kernel.kallsyms]  [k] pipe_write
     0.00%     +0.53%  [kernel.kallsyms]  [k] get_parent_ip
     0.00%     +0.53%  [kernel.kallsyms]  [k] vfs_read
     0.00%     +0.53%  [kernel.kallsyms]  [k] put_lock_stats
     0.56%     -0.03%  [kernel.kallsyms]  [k] intel_pmu_enable_all
     0.00%     +0.51%  [kernel.kallsyms]  [k] fsnotify
     0.72%     -0.23%  libc-2.12.so       [.] __GI___libc_write
     0.00%     +0.49%  [kernel.kallsyms]  [k] do_sync_write
     0.00%     +0.48%  [kernel.kallsyms]  [k] trace_hardirqs_on
     0.00%     +0.48%  [kernel.kallsyms]  [k] do_sync_read
     0.00%     +0.45%  [kernel.kallsyms]  [k] dequeue_entity
     0.00%     +0.44%  [kernel.kallsyms]  [k] select_task_rq_fair
     0.00%     +0.44%  [kernel.kallsyms]  [k] update_curr
     0.00%     +0.43%  [kernel.kallsyms]  [k] fget_light
     0.00%     +0.42%  [kernel.kallsyms]  [k] do_raw_spin_trylock
     0.00%     +0.42%  [kernel.kallsyms]  [k] in_lock_functions
     0.00%     +0.40%  [kernel.kallsyms]  [k] find_next_bit
     0.50%     -0.11%  [kernel.kallsyms]  [k] intel_pmu_disable_all
     0.00%     +0.39%  [kernel.kallsyms]  [k] __list_add
     0.00%     +0.38%  [kernel.kallsyms]  [k] enqueue_task
     0.00%     +0.38%  [kernel.kallsyms]  [k] __might_sleep
     0.00%     +0.38%  [kernel.kallsyms]  [k] kill_fasync
     0.00%     +0.36%  [kernel.kallsyms]  [k] check_flags
     0.00%     +0.36%  [kernel.kallsyms]  [k] _raw_spin_unlock
     0.00%     +0.34%  [kernel.kallsyms]  [k] pipe_iov_copy_from_user
     0.00%     +0.33%  [kernel.kallsyms]  [k] check_preempt_curr
     0.00%     +0.32%  [kernel.kallsyms]  [k] system_call_after_swapgs
     0.00%     +0.32%  [kernel.kallsyms]  [k] mark_held_locks
     0.00%     +0.31%  [kernel.kallsyms]  [k] touch_atime
     0.00%     +0.30%  [kernel.kallsyms]  [k] account_entity_enqueue
     0.00%     +0.30%  [kernel.kallsyms]  [k] set_next_entity
     0.00%     +0.30%  [kernel.kallsyms]  [k] place_entity
     0.00%     +0.29%  [kernel.kallsyms]  [k] try_to_wake_up
     0.00%     +0.29%  [kernel.kallsyms]  [k] check_preempt_wakeup
     0.00%     +0.28%  [kernel.kallsyms]  [k] debug_lockdep_rcu_enabled
     0.00%     +0.28%  [kernel.kallsyms]  [k] cpumask_next_and
     0.00%     +0.28%  [kernel.kallsyms]  [k] __wake_up_common
     0.00%     +0.27%  [kernel.kallsyms]  [k] rb_erase
     0.00%     +0.26%  [kernel.kallsyms]  [k] ttwu_stat
     0.00%     +0.25%  [kernel.kallsyms]  [k] _raw_spin_unlock_irq
     0.00%     +0.25%  [kernel.kallsyms]  [k] pick_next_task_fair
     0.00%     +0.25%  [kernel.kallsyms]  [k] update_cfs_shares
     0.00%     +0.25%  [kernel.kallsyms]  [k] sysret_check
     0.00%     +0.25%  [kernel.kallsyms]  [k] lockdep_sys_exit_thunk
     0.00%     +0.25%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
     0.00%     +0.24%  [kernel.kallsyms]  [k] get_lock_stats
     0.00%     +0.24%  [kernel.kallsyms]  [k] put_prev_task_fair
     0.00%     +0.24%  [kernel.kallsyms]  [k] trace_hardirqs_on_thunk
     0.00%     +0.24%  [kernel.kallsyms]  [k] __perf_event_task_sched_out
     0.00%     +0.24%  [kernel.kallsyms]  [k] ret_from_sys_call
     0.00%     +0.23%  [kernel.kallsyms]  [k] rcu_note_context_switch
     0.00%     +0.23%  [kernel.kallsyms]  [k] update_stats_wait_end
     0.00%     +0.23%  [kernel.kallsyms]  [k] file_update_time
     0.35%     -0.12%  libc-2.12.so       [.] __write_nocancel
     0.00%     +0.22%  [kernel.kallsyms]  [k] rw_verify_area
     0.00%     +0.21%  [kernel.kallsyms]  [k] mutex_unlock
     0.00%     +0.20%  [kernel.kallsyms]  [k] system_call_fastpath
     0.00%     +0.20%  [kernel.kallsyms]  [k] sys_write
     0.09%     +0.11%  [kernel.kallsyms]  [k] update_cfs_load
     0.00%     +0.20%  [kernel.kallsyms]  [k] time_hardirqs_off
     0.10%     +0.10%  [kernel.kallsyms]  [k] x86_pmu_disable
     0.00%     +0.19%  [kernel.kallsyms]  [k] clear_buddies
     0.00%     +0.19%  [kernel.kallsyms]  [k] activate_task
     0.00%     +0.18%  [kernel.kallsyms]  [k] enqueue_task_fair
     0.00%     +0.18%  [kernel.kallsyms]  [k] _raw_spin_lock
     0.00%     +0.18%  [kernel.kallsyms]  [k] ttwu_do_wakeup
     0.00%     +0.17%  [kernel.kallsyms]  [k] __srcu_read_lock
     0.00%     +0.17%  [kernel.kallsyms]  [k] prepare_to_wait
     0.00%     +0.16%  [kernel.kallsyms]  [k] debug_mutex_lock_common
     0.00%     +0.16%  [kernel.kallsyms]  [k] ttwu_activate
     0.00%     +0.16%  [kernel.kallsyms]  [k] time_hardirqs_on
     0.00%     +0.16%  [kernel.kallsyms]  [k] pipe_wait
     0.00%     +0.16%  [kernel.kallsyms]  [k] preempt_schedule
     0.00%     +0.16%  [kernel.kallsyms]  [k] debug_mutex_free_waiter
     0.00%     +0.15%  [kernel.kallsyms]  [k] __rcu_read_unlock
     0.00%     +0.14%  [kernel.kallsyms]  [k] account_cfs_rq_runtime
     0.00%     +0.14%  [kernel.kallsyms]  [k] perf_pmu_rotate_start
     0.00%     +0.14%  [kernel.kallsyms]  [k] pipe_lock
     0.00%     +0.14%  [kernel.kallsyms]  [k] __perf_event_task_sched_in
     0.00%     +0.14%  [kernel.kallsyms]  [k] __srcu_read_unlock
     0.00%     +0.13%  [kernel.kallsyms]  [k] perf_ctx_unlock
     0.00%     +0.13%  [kernel.kallsyms]  [k] __rcu_read_lock
     0.00%     +0.13%  [kernel.kallsyms]  [k] account_entity_dequeue
     0.00%     +0.12%  [kernel.kallsyms]  [k] __fsnotify_parent
     0.00%     +0.12%  [kernel.kallsyms]  [k] sched_clock_cpu
     0.00%     +0.12%  [kernel.kallsyms]  [k] current_fs_time
     0.00%     +0.11%  [kernel.kallsyms]  [k] _raw_spin_lock_irq
     0.00%     +0.11%  [kernel.kallsyms]  [k] mutex_remove_waiter
     0.00%     +0.11%  [kernel.kallsyms]  [k] autoremove_wake_function
     0.00%     +0.10%  [kernel.kallsyms]  [k] hrtick_start_fair
     0.08%     +0.03%  pipe-test-100k     [.] read@plt
     0.00%     +0.10%  [kernel.kallsyms]  [k] __bfs
     0.00%     +0.10%  [kernel.kallsyms]  [k] mnt_want_write
     0.00%     +0.09%  [kernel.kallsyms]  [k] __dequeue_entity
     0.00%     +0.09%  [kernel.kallsyms]  [k] do_raw_spin_unlock
     0.00%     +0.08%  [kernel.kallsyms]  [k] lockdep_sys_exit
     0.00%     +0.08%  [kernel.kallsyms]  [k] rb_next
     0.00%     +0.08%  [kernel.kallsyms]  [k] debug_mutex_unlock
     0.00%     +0.08%  [kernel.kallsyms]  [k] rb_insert_color
     0.00%     +0.08%  [kernel.kallsyms]  [k] update_rq_clock
     0.00%     +0.08%  [kernel.kallsyms]  [k] dequeue_task_fair
     0.00%     +0.07%  [kernel.kallsyms]  [k] finish_wait
     0.00%     +0.07%  [kernel.kallsyms]  [k] wakeup_preempt_entity
     0.00%     +0.07%  [kernel.kallsyms]  [k] debug_mutex_add_waiter
     0.00%     +0.07%  [kernel.kallsyms]  [k] ttwu_do_activate.clone.3
     0.00%     +0.07%  [kernel.kallsyms]  [k] generic_pipe_buf_map
     0.00%     +0.06%  [kernel.kallsyms]  [k] __wake_up_sync_key
     0.00%     +0.06%  [kernel.kallsyms]  [k] __mark_inode_dirty
     0.04%     +0.02%  [kernel.kallsyms]  [k] intel_pmu_nhm_enable_all
     0.00%     +0.05%  [kernel.kallsyms]  [k] timespec_trunc
     0.00%     +0.05%  [kernel.kallsyms]  [k] dequeue_task
     0.00%     +0.05%  [kernel.kallsyms]  [k] perf_pmu_disable
     0.00%     +0.05%  [kernel.kallsyms]  [k] apic_timer_interrupt
     0.00%     +0.05%  [kernel.kallsyms]  [k] current_kernel_time
     0.05%             pipe-test-100k     [.] write@plt
     0.00%     +0.05%  [kernel.kallsyms]  [k] generic_pipe_buf_confirm
     0.00%     +0.04%  [kernel.kallsyms]  [k] __rcu_pending
     0.00%     +0.04%  [kernel.kallsyms]  [k] generic_pipe_buf_unmap
     0.00%     +0.04%  [kernel.kallsyms]  [k] anon_pipe_buf_release
     0.00%     +0.04%  [kernel.kallsyms]  [k] finish_task_switch
     0.00%     +0.04%  [kernel.kallsyms]  [k] perf_event_context_sched_in
     0.00%     +0.04%  [kernel.kallsyms]  [k] update_process_times
     0.00%     +0.04%  [kernel.kallsyms]  [k] do_timer
     0.00%     +0.04%  [kernel.kallsyms]  [k] trace_hardirqs_off_thunk
     0.00%     +0.03%  [kernel.kallsyms]  [k] run_timer_softirq
     0.00%     +0.02%  [kernel.kallsyms]  [k] default_wake_function
     0.00%     +0.02%  [kernel.kallsyms]  [k] hrtimer_interrupt
     0.00%     +0.02%  [kernel.kallsyms]  [k] timerqueue_add
     0.00%     +0.02%  [kernel.kallsyms]  [k] __do_softirq
     0.00%     +0.02%  [kernel.kallsyms]  [k] set_next_buddy
     0.00%     +0.02%  [kernel.kallsyms]  [k] resched_task
     0.00%     +0.02%  [kernel.kallsyms]  [k] task_tick_fair
     0.00%     +0.02%  [kernel.kallsyms]  [k] restore
     0.00%     +0.02%  [kernel.kallsyms]  [k] irq_exit
     0.00%     +0.02%  [e1000e]           [k] e1000_watchdog
     0.00%     +0.01%  [kernel.kallsyms]  [k] account_process_tick
     0.00%     +0.01%  [kernel.kallsyms]  [k] update_vsyscall
     0.00%     +0.01%  [kernel.kallsyms]  [k] rcu_enter_nohz
     0.00%     +0.01%  [kernel.kallsyms]  [k] hrtimer_run_pending
     0.00%     +0.01%  [kernel.kallsyms]  [k] calc_global_load
     0.00%     +0.01%  [kernel.kallsyms]  [k] account_system_time
     0.00%     +0.01%  [kernel.kallsyms]  [k] __run_hrtimer
     0.99%     -0.98%  [kernel.kallsyms]  [k] pipe_unlock
     0.00%     +0.01%  [kernel.kallsyms]  [k] irq_enter
     0.00%     +0.01%  [kernel.kallsyms]  [k] scheduler_tick
     0.00%     +0.01%  [kernel.kallsyms]  [k] mnt_want_write_file
     0.00%     +0.01%  [kernel.kallsyms]  [k] hrtimer_run_queues
     0.01%             [kernel.kallsyms]  [k] sched_avg_update
     0.00%             [kernel.kallsyms]  [k] rcu_check_callbacks
     0.00%             [kernel.kallsyms]  [k] task_waking_fair
     0.00%             [kernel.kallsyms]  [k] trace_softirqs_off
     0.00%             [kernel.kallsyms]  [k] call_softirq
     0.00%             [kernel.kallsyms]  [k] find_busiest_group
     0.00%             [kernel.kallsyms]  [k] exit_idle
     0.00%             [kernel.kallsyms]  [k] enqueue_hrtimer
     0.00%             [kernel.kallsyms]  [k] hrtimer_forward
     0.02%     -0.02%  [kernel.kallsyms]  [k] x86_pmu_enable
     0.01%             [kernel.kallsyms]  [k] do_softirq
     0.00%             [kernel.kallsyms]  [k] calc_delta_mine
     0.00%             [kernel.kallsyms]  [k] sched_slice
     0.00%             [kernel.kallsyms]  [k] tick_sched_timer
     0.00%             [kernel.kallsyms]  [k] irq_work_run
     0.00%             [kernel.kallsyms]  [k] ktime_get
     0.00%             [kernel.kallsyms]  [k] update_cpu_load
     0.00%             [kernel.kallsyms]  [k] __remove_hrtimer
     0.00%             [kernel.kallsyms]  [k] rcu_exit_nohz
     0.00%             [kernel.kallsyms]  [k] clockevents_program_event





and perf stat outputs:



base, drop_caches:

 Performance counter stats for './pipe-test-100k' (50 runs):

       3841.033842 task-clock                #    0.576 CPUs utilized            ( +-  0.06% )
           200,008 context-switches          #    0.052 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 56.54% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.16% )
     7,518,958,711 cycles                    #    1.958 GHz                      ( +-  0.09% )
     2,676,161,995 stalled-cycles-frontend   #   35.59% frontend cycles idle     ( +-  0.17% )
     1,152,912,513 stalled-cycles-backend    #   15.33% backend  cycles idle     ( +-  0.31% )
     8,634,136,901 instructions              #    1.15  insns per cycle        
                                             #    0.31  stalled cycles per insn  ( +-  0.08% )
     1,764,912,243 branches                  #  459.489 M/sec                    ( +-  0.08% )
        35,531,303 branch-misses             #    2.01% of all branches          ( +-  0.12% )

       6.669821483 seconds time elapsed                                          ( +-  0.03% )



base, drop_caches:

 Performance counter stats for './pipe-test-100k' (50 runs):

       3840.203514 task-clock                #    0.576 CPUs utilized            ( +-  0.06% )
           200,009 context-switches          #    0.052 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 60.19% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.18% )
     7,526,419,287 cycles                    #    1.960 GHz                      ( +-  0.08% )
     2,681,342,567 stalled-cycles-frontend   #   35.63% frontend cycles idle     ( +-  0.15% )
     1,159,603,323 stalled-cycles-backend    #   15.41% backend  cycles idle     ( +-  0.36% )
     8,641,162,766 instructions              #    1.15  insns per cycle        
                                             #    0.31  stalled cycles per insn  ( +-  0.07% )
     1,766,192,649 branches                  #  459.922 M/sec                    ( +-  0.07% )
        35,520,560 branch-misses             #    2.01% of all branches          ( +-  0.11% )

       6.667852851 seconds time elapsed                                          ( +-  0.03% )



base, drop_caches:

 Performance counter stats for './pipe-test-100k' (50 runs):

       3827.952520 task-clock                #    0.575 CPUs utilized            ( +-  0.06% )
           200,009 context-switches          #    0.052 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 56.54% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.17% )
     7,491,864,402 cycles                    #    1.957 GHz                      ( +-  0.08% )
     2,664,949,808 stalled-cycles-frontend   #   35.57% frontend cycles idle     ( +-  0.16% )
     1,140,326,742 stalled-cycles-backend    #   15.22% backend  cycles idle     ( +-  0.31% )
     8,624,760,925 instructions              #    1.15  insns per cycle        
                                             #    0.31  stalled cycles per insn  ( +-  0.07% )
     1,761,666,011 branches                  #  460.211 M/sec                    ( +-  0.07% )
        34,655,390 branch-misses             #    1.97% of all branches          ( +-  0.12% )

       6.657224884 seconds time elapsed                                          ( +-  0.03% )




+patch, cgroup disabled, drop_caches:

 Performance counter stats for './pipe-test-100k' (50 runs):

       3857.191852 task-clock                #    0.576 CPUs utilized            ( +-  0.09% )
           200,008 context-switches          #    0.052 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 42.86% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.19% )
     7,574,623,093 cycles                    #    1.964 GHz                      ( +-  0.10% )
     2,758,696,094 stalled-cycles-frontend   #   36.42% frontend cycles idle     ( +-  0.15% )
     1,239,909,382 stalled-cycles-backend    #   16.37% backend  cycles idle     ( +-  0.38% )
     8,572,061,001 instructions              #    1.13  insns per cycle        
                                             #    0.32  stalled cycles per insn  ( +-  0.08% )
     1,750,572,714 branches                  #  453.846 M/sec                    ( +-  0.08% )
        36,051,335 branch-misses             #    2.06% of all branches          ( +-  0.13% )

       6.691634724 seconds time elapsed                                          ( +-  0.04% )



+patch, cgroup disabled, drop_caches:

 Performance counter stats for './pipe-test-100k' (50 runs):

       3867.143019 task-clock                #    0.577 CPUs utilized            ( +-  0.10% )
           200,008 context-switches          #    0.052 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 56.54% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.17% )
     7,594,083,776 cycles                    #    1.964 GHz                      ( +-  0.12% )
     2,775,221,867 stalled-cycles-frontend   #   36.54% frontend cycles idle     ( +-  0.19% )
     1,251,931,725 stalled-cycles-backend    #   16.49% backend  cycles idle     ( +-  0.36% )
     8,574,447,382 instructions              #    1.13  insns per cycle        
                                             #    0.32  stalled cycles per insn  ( +-  0.09% )
     1,751,600,855 branches                  #  452.944 M/sec                    ( +-  0.09% )
        36,098,438 branch-misses             #    2.06% of all branches          ( +-  0.16% )

       6.698065282 seconds time elapsed                                          ( +-  0.05% )



+patch, cgroup disabled, drop_caches:

 Performance counter stats for './pipe-test-100k' (50 runs):

       3857.654582 task-clock                #    0.577 CPUs utilized            ( +-  0.10% )
           200,009 context-switches          #    0.052 M/sec                    ( +-  0.00% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 78.57% )
               135 page-faults               #    0.000 M/sec                    ( +-  0.23% )
     7,584,913,316 cycles                    #    1.966 GHz                      ( +-  0.11% )
     2,771,130,327 stalled-cycles-frontend   #   36.53% frontend cycles idle     ( +-  0.17% )
     1,263,203,011 stalled-cycles-backend    #   16.65% backend  cycles idle     ( +-  0.40% )
     8,574,734,269 instructions              #    1.13  insns per cycle        
                                             #    0.32  stalled cycles per insn  ( +-  0.09% )
     1,751,597,037 branches                  #  454.058 M/sec                    ( +-  0.09% )
        36,113,467 branch-misses             #    2.06% of all branches          ( +-  0.14% )

       6.688379749 seconds time elapsed                                          ( +-  0.04% )

