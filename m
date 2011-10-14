Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab1JNQ2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:28:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:34494 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1JNQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:28:48 -0400
From: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, "Seger, Mark" <mark.seger@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 17:27:59 +0100
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Topic: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Index: AcyKd8AVvlcpk1ulR4SQSNW1pz5ofwAFXSag
Message-ID: <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
 <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9EGSvxQ020150

Eric,

Got the system ready and ran the tests.

This is a DL980 128 CPCUS, 256GB memory.

[root@linuxbeast ~]# cat /proc/cpuinfo | grep processor | wc -l
128

[root@linuxbeast ~]# uname -a
Linux linuxbeast.gse.mvlabs.corp.hp.com 2.6.32-131.6.1.el6.x86_64 #1 SMP Mon Jun 20 14:15:38 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux

In this example we take >4ms per read. We are spending most of the time in 

    35.09%        t  [kernel.kallsyms]  [k] kstat_irqs_cpu
    32.13%        t  [kernel.kallsyms]  [k] find_next_bit
    24.32%        t  [kernel.kallsyms]  [k] show_stat
     1.98%        t  [kernel.kallsyms]  [k] vsnprintf
     1.63%        t  [kernel.kallsyms]  [k] format_decode
     1.23%        t  [kernel.kallsyms]  [k] number

Thanks

[root@linuxbeast ~]# perf record ./t
Opened, read and closed 8640 times and read total of 72521754 bytes
[ perf record: Woken up 5 times to write data ]
[ perf record: Captured and wrote 1.422 MB perf.data (~62126 samples) ]
[root@linuxbeast ~]# perf report --stdio
# Events: 36K cycles
#
# Overhead  Command      Shared Object                         Symbol
# ........  .......  .................  .............................
#
    35.09%        t  [kernel.kallsyms]  [k] kstat_irqs_cpu
    32.13%        t  [kernel.kallsyms]  [k] find_next_bit
    24.32%        t  [kernel.kallsyms]  [k] show_stat
     1.98%        t  [kernel.kallsyms]  [k] vsnprintf
     1.63%        t  [kernel.kallsyms]  [k] format_decode
     1.23%        t  [kernel.kallsyms]  [k] number
     0.92%        t  [kernel.kallsyms]  [k] memcpy_c
     0.42%        t  [kernel.kallsyms]  [k] seq_printf
     0.26%        t  [kernel.kallsyms]  [k] put_dec_trunc
     0.26%        t  [kernel.kallsyms]  [k] _spin_lock
     0.16%        t  [kernel.kallsyms]  [k] put_dec
     0.15%        t  [kernel.kallsyms]  [k] arch_irq_stat_cpu
     0.14%        t  [kernel.kallsyms]  [k] scheduler_tick
     0.12%        t  [kernel.kallsyms]  [k] nr_running
     0.10%        t  [kernel.kallsyms]  [k] jiffies_64_to_clock_t
     0.08%        t  [kernel.kallsyms]  [k] dyntick_save_progress_counter
     0.06%        t  [kernel.kallsyms]  [k] nr_iowait
     0.05%        t  [kernel.kallsyms]  [k] nr_context_switches
     0.05%        t  [kernel.kallsyms]  [k] _spin_lock_irqsave
     0.04%        t  [kernel.kallsyms]  [k] rcu_process_gp_end
     0.04%        t  [kernel.kallsyms]  [k] account_system_time
     0.04%        t  [kernel.kallsyms]  [k] native_write_msr_safe
     0.04%        t  [kernel.kallsyms]  [k] memcpy
     0.03%        t  [kernel.kallsyms]  [k] update_vsyscall
     0.03%        t  [kernel.kallsyms]  [k] task_tick_fair
     0.03%        t  [kernel.kallsyms]  [k] __do_softirq
     0.02%        t  [kernel.kallsyms]  [k] apic_timer_interrupt
     0.02%        t  [kernel.kallsyms]  [k] ktime_get
     0.02%        t  [kernel.kallsyms]  [k] _spin_unlock_irqrestore
     0.02%        t  [kernel.kallsyms]  [k] check_for_new_grace_period
     0.02%        t  [kernel.kallsyms]  [k] __sched_text_end
     0.02%        t  [kernel.kallsyms]  [k] tick_do_update_jiffies64
     0.02%        t  [kernel.kallsyms]  [k] copy_user_generic_string
     0.02%        t  [kernel.kallsyms]  [k] run_timer_softirq
     0.02%        t  [kernel.kallsyms]  [k] rcu_process_callbacks
     0.02%        t  [kernel.kallsyms]  [k] __rcu_process_callbacks
     0.02%        t  [kernel.kallsyms]  [k] kfree
     0.02%        t  [kernel.kallsyms]  [k] __rcu_pending
     0.02%        t  [kernel.kallsyms]  [k] avtab_search_node
     0.01%        t  [kernel.kallsyms]  [k] rcu_process_dyntick
     0.01%        t  [kernel.kallsyms]  [k] force_quiescent_state
     0.01%        t  [kernel.kallsyms]  [k] irq_exit
     0.01%        t  [kernel.kallsyms]  [k] update_wall_time
     0.01%        t  [kernel.kallsyms]  [k] tg_shares_up
     0.01%        t  [kernel.kallsyms]  [k] acct_update_integrals
     0.01%        t  [kernel.kallsyms]  [k] __percpu_counter_add
     0.01%        t  [kernel.kallsyms]  [k] raise_softirq
     0.01%        t  [kernel.kallsyms]  [k] perf_event_do_pending
     0.01%        t  [kernel.kallsyms]  [k] update_curr
     0.01%        t  [kernel.kallsyms]  [k] tick_sched_timer
     0.01%        t  [kernel.kallsyms]  [k] avc_has_perm_noaudit
     0.01%        t  [kernel.kallsyms]  [k] run_posix_cpu_timers
     0.01%        t  [kernel.kallsyms]  [k] current_kernel_time
     0.01%        t  [kernel.kallsyms]  [k] update_cpu_load
     0.01%        t  [kernel.kallsyms]  [k] hrtimer_interrupt
     0.01%        t  [kernel.kallsyms]  [k] native_read_tsc
     0.01%        t  [kernel.kallsyms]  [k] vfs_read
     0.01%        t  [kernel.kallsyms]  [k] __call_rcu
     0.01%        t  [kernel.kallsyms]  [k] putname
     0.01%        t  [kernel.kallsyms]  [k] __d_lookup
     0.01%        t  [kernel.kallsyms]  [k] rb_erase
     0.01%        t  [kernel.kallsyms]  [k] rb_next
     0.01%        t  [kernel.kallsyms]  [k] rcu_check_callbacks
     0.01%        t  [kernel.kallsyms]  [k] inode_has_perm
     0.01%        t  [kernel.kallsyms]  [k] proc_reg_release
     0.01%        t  [kernel.kallsyms]  [k] __link_path_walk
     0.01%        t  [kernel.kallsyms]  [k] perf_event_task_tick
     0.00%        t  [kernel.kallsyms]  [k] __remove_hrtimer
     0.00%        t  [kernel.kallsyms]  [k] task_of
     0.00%        t  [kernel.kallsyms]  [k] irq_enter
     0.00%        t  [kernel.kallsyms]  [k] rb_insert_color
     0.00%        t  [kernel.kallsyms]  [k] rcu_start_gp
     0.00%        t  [kernel.kallsyms]  [k] alloc_fd
     0.00%        t  [kernel.kallsyms]  [k] path_init
     0.00%        t  [kernel.kallsyms]  [k] read_tsc
     0.00%        t  [kernel.kallsyms]  [k] rcu_irq_enter
     0.00%        t  [kernel.kallsyms]  [k] _read_lock
     0.00%        t  [kernel.kallsyms]  [k] sysret_check
     0.00%        t  [kernel.kallsyms]  [k] expand_files
     0.00%        t  [kernel.kallsyms]  [k] file_move
     0.00%        t  [kernel.kallsyms]  [k] update_process_times
     0.00%        t  [kernel.kallsyms]  [k] __kmalloc
     0.00%        t  [kernel.kallsyms]  [k] __run_hrtimer
     0.00%        t  [kernel.kallsyms]  [k] hweight64
     0.00%        t  [kernel.kallsyms]  [k] audit_syscall_entry
     0.00%        t  [kernel.kallsyms]  [k] lookup_mnt
     0.00%        t  [kernel.kallsyms]  [k] perf_pmu_disable
     0.00%        t  [kernel.kallsyms]  [k] kmem_cache_alloc
     0.00%        t  [kernel.kallsyms]  [k] getname
     0.00%        t  [kernel.kallsyms]  [k] mutex_lock
     0.00%        t  [kernel.kallsyms]  [k] restore_args
     0.00%        t  [kernel.kallsyms]  [k] x86_pmu_disable
     0.00%        t  [kernel.kallsyms]  [k] ima_counts_get
     0.00%        t  [kernel.kallsyms]  [k] call_rcu_sched
     0.00%        t  [kernel.kallsyms]  [k] rcu_implicit_dynticks_qs
     0.00%        t  [kernel.kallsyms]  [k] security_file_alloc
     0.00%        t  [kernel.kallsyms]  [k] memset_c
     0.00%        t  [kernel.kallsyms]  [k] lapic_next_event
     0.00%        t  [kernel.kallsyms]  [k] kmem_cache_free
     0.00%        t  [kernel.kallsyms]  [k] tick_program_event
     0.00%        t  [kernel.kallsyms]  [k] __tcp_select_window
     0.00%        t  [kernel.kallsyms]  [k] __dentry_open
     0.00%        t  [kernel.kallsyms]  [k] _local_bh_enable
     0.00%        t  [kernel.kallsyms]  [k] __smp_call_function_single
     0.00%        t  [kernel.kallsyms]  [k] sched_clock_tick
     0.00%        t  [kernel.kallsyms]  [k] call_softirq
     0.00%        t  [kernel.kallsyms]  [k] _spin_lock_irq
     0.00%        t  [kernel.kallsyms]  [k] _atomic_dec_and_lock
     0.00%        t  [kernel.kallsyms]  [k] hrtimer_forward
     0.00%        t  [kernel.kallsyms]  [k] account_process_tick
     0.00%        t  [kernel.kallsyms]  [k] clockevents_program_event
     0.00%        t  [kernel.kallsyms]  [k] sysret_careful
     0.00%        t  [kernel.kallsyms]  [k] x86_pmu_enable


#
# (For a higher level overview, try: perf report --sort comm,dso)
#
(END)

[root@linuxbeast ~]# strace -c -T ./t
Opened, read and closed 8640 times and read total of 72446400 bytes
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 99.99   35.195100        4073      8641           read
  0.01    0.002183           0      8642           close
  0.00    0.001260           0      8642           open
  0.00    0.000032          32         1           write
  0.00    0.000000           0         3           fstat
  0.00    0.000000           0         9           mmap
  0.00    0.000000           0         3           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         1           brk
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00   35.198575                 25946         1 total
[root@linuxbeast ~]#


-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Friday, October 14, 2011 9:47 AM
To: Seger, Mark
Cc: Oberman, Laurence (HAS GSE); linux-kernel@vger.kernel.org; Cabaniols, Sebastien
Subject: RE: Regression in reading /proc/stat in the newer kernels with large SMP and NUMA configurations

Le vendredi 14 octobre 2011 Ã  14:36 +0100, Seger, Mark a Ã©crit :

> For me the easiest reproducer, which admittedly doesn't show any
> deeper analysis, is to just run "cat /proc/stat>/dev/null" in a loop
> and time it.

OK, but you already provided a global number.

We would like to check where in kernel cpu time is consumed.
Maybe something really obvious could pop out.

"perf" is provided in kernel sources, and really is a piece of cake.

cd tools/perf ; make 



2x4x2 means : Two sockets, 4 cores per physical package, 2 threads per
core.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
