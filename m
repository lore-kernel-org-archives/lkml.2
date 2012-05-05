Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2EEHNi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 03:13:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43700 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753092Ab2EEHNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 03:13:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18I811iwCAIh5dr8+5OYsnU4wP00iWQ5I7vbuhgxA
	jgCx5JR6xxoFGr
Message-ID: <1336201977.7346.22.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 05 May 2012 09:12:57 +0200
In-Reply-To: <1336198093.7346.11.camel@marge.simpson.net>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
	 <1336014721.7370.32.camel@marge.simpson.net>
	 <1336057018.8119.46.camel@marge.simpson.net>
	 <1336105676.7356.42.camel@marge.simpson.net>
	 <m1aa1oidmn.fsf@fess.ebiederm.org>
	 <1336124716.25479.36.camel@marge.simpson.net>
	 <m1vckcdoey.fsf@fess.ebiederm.org>
	 <1336142995.25479.49.camel@marge.simpson.net>
	 <m1zk9oc61j.fsf@fess.ebiederm.org>
	 <1336150643.7502.4.camel@marge.simpson.net>
	 <m1fwbfd71h.fsf@fess.ebiederm.org>
	 <1336197362.7346.9.camel@marge.simpson.net>
	 <1336198093.7346.11.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-05 at 08:08 +0200, Mike Galbraith wrote:

> egrep 'synchronize|rcu_barrier' /trace 
> 
>           vsftpd-7981  [003] ....   577.164997: synchronize_sched <-switch_task_namespaces
>           vsftpd-7981  [003] ....   577.164998: _cond_resched <-synchronize_sched
>           vsftpd-7981  [003] ....   577.164998: wait_rcu_gp <-synchronize_sched
>           vsftpd-7982  [003] ....   577.166583: synchronize_sched <-switch_task_namespaces
>           vsftpd-7982  [003] ....   577.166583: _cond_resched <-synchronize_sched

> vsftpd-7977  [003] ....   577.171519: rcu_barrier_sched <-rcu_barrier
>           vsftpd-7977  [003] ....   577.171519: _rcu_barrier.isra.31 <-rcu_barrier_sched
>           vsftpd-7977  [003] ....   577.171519: mutex_lock <-_rcu_barrier.isra.31
>           vsftpd-7977  [003] ....   577.171520: __init_waitqueue_head <-_rcu_barrier.isra.31
>           vsftpd-7977  [003] ....   577.171520: on_each_cpu <-_rcu_barrier.isra.31
>           vsftpd-7977  [003] d...   577.171532: rcu_barrier_func <-on_each_cpu
>           vsftpd-7977  [003] d...   577.171532: call_rcu_sched <-rcu_barrier_func
>           vsftpd-7977  [003] ....   577.171533: wait_for_completion <-_rcu_barrier.isra.31
>      ksoftirqd/3-16    [003] ..s.   577.171691: rcu_barrier_callback <-__rcu_process_callbacks
>           vsftpd-7977  [003] ....   577.176443: mutex_unlock <-_rcu_barrier.isra.31
...

Ok, so CLONE_NEWPID | SIGCHLD + waitpid is a bad idea given extreme
unmount synchronization, but why does it take four softirqs?  Seems this
could have gone a lot faster. 

          vsftpd-7977  [003] ....   577.192773: do_wait <-sys_wait4
          vsftpd-7977  [003] ....   577.192773: add_wait_queue <-do_wait
          vsftpd-7977  [003] ....   577.192773: _raw_spin_lock_irqsave <-add_wait_queue
          vsftpd-7977  [003] d...   577.192773: _raw_spin_unlock_irqrestore <-add_wait_queue
          vsftpd-7977  [003] ....   577.192774: _raw_read_lock <-do_wait
          vsftpd-7977  [003] ....   577.192774: wait_consider_task <-do_wait
          vsftpd-7977  [003] ....   577.192774: __task_pid_nr_ns <-wait_consider_task
          vsftpd-7977  [003] ....   577.192774: pid_nr_ns <-__task_pid_nr_ns
          vsftpd-7977  [003] ....   577.192774: thread_group_times <-wait_consider_task
          vsftpd-7977  [003] ....   577.192775: thread_group_cputime <-thread_group_times
          vsftpd-7977  [003] ....   577.192775: task_sched_runtime <-thread_group_cputime
          vsftpd-7977  [003] ....   577.192775: task_rq_lock <-task_sched_runtime
          vsftpd-7977  [003] ....   577.192775: _raw_spin_lock_irqsave <-task_rq_lock
          vsftpd-7977  [003] d...   577.192775: _raw_spin_lock <-task_rq_lock
          vsftpd-7977  [003] d...   577.192776: _raw_spin_unlock_irqrestore <-task_sched_runtime
          vsftpd-7977  [003] ....   577.192776: nsecs_to_jiffies <-thread_group_times
          vsftpd-7977  [003] ....   577.192776: _raw_spin_lock_irq <-wait_consider_task
          vsftpd-7977  [003] ....   577.192776: release_task <-wait_consider_task
          vsftpd-7977  [003] ....   577.192776: proc_flush_task <-release_task
          vsftpd-7977  [003] ....   577.192777: d_hash_and_lookup <-proc_flush_task
          vsftpd-7977  [003] ....   577.192777: full_name_hash <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.192777: d_lookup <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.192777: __d_lookup <-d_lookup
          vsftpd-7977  [003] ....   577.192778: d_hash_and_lookup <-proc_flush_task
          vsftpd-7977  [003] ....   577.192778: full_name_hash <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.192778: d_lookup <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.192778: __d_lookup <-d_lookup
          vsftpd-7977  [003] ....   577.192779: d_hash_and_lookup <-proc_flush_task
          vsftpd-7977  [003] ....   577.192779: full_name_hash <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.192779: d_lookup <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.192780: __d_lookup <-d_lookup
          vsftpd-7977  [003] ....   577.192780: d_hash_and_lookup <-proc_flush_task
          vsftpd-7977  [003] ....   577.192780: full_name_hash <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.192780: d_lookup <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.192780: __d_lookup <-d_lookup
          vsftpd-7977  [003] ....   577.192781: pid_ns_release_proc <-proc_flush_task
          vsftpd-7977  [003] ....   577.192781: kern_unmount <-pid_ns_release_proc
          vsftpd-7977  [003] ....   577.192781: mnt_make_shortterm <-kern_unmount
          vsftpd-7977  [003] ....   577.192781: vfsmount_lock_global_lock_online <-mnt_make_shortterm
          vsftpd-7977  [003] ....   577.192781: _raw_spin_lock <-vfsmount_lock_global_lock_online
          vsftpd-7977  [003] ....   577.192782: vfsmount_lock_global_unlock_online <-mnt_make_shortterm
          vsftpd-7977  [003] ....   577.192782: mntput <-kern_unmount
          vsftpd-7977  [003] ....   577.192782: mntput_no_expire <-mntput
          vsftpd-7977  [003] ....   577.192782: vfsmount_lock_local_lock <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192782: vfsmount_lock_global_lock_online <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192783: _raw_spin_lock <-vfsmount_lock_global_lock_online
          vsftpd-7977  [003] ....   577.192783: mnt_get_count <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192783: vfsmount_lock_global_unlock_online <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192784: mnt_get_writers.isra.12 <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192784: __fsnotify_vfsmount_delete <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192784: fsnotify_clear_marks_by_mount <-__fsnotify_vfsmount_delete
          vsftpd-7977  [003] ....   577.192784: _raw_spin_lock <-fsnotify_clear_marks_by_mount
          vsftpd-7977  [003] ....   577.192784: dput <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192784: _raw_spin_lock <-dput
          vsftpd-7977  [003] ....   577.192785: free_vfsmnt <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192785: kfree <-free_vfsmnt
          vsftpd-7977  [003] ....   577.192785: __phys_addr <-kfree
          vsftpd-7977  [003] ....   577.192785: __slab_free <-kfree
          vsftpd-7977  [003] ....   577.192785: free_debug_processing <-__slab_free
          vsftpd-7977  [003] d...   577.192786: check_slab <-free_debug_processing
          vsftpd-7977  [003] d...   577.192786: slab_pad_check.part.42 <-check_slab
          vsftpd-7977  [003] d...   577.192786: on_freelist <-free_debug_processing
          vsftpd-7977  [003] d...   577.192786: check_object <-free_debug_processing
          vsftpd-7977  [003] d...   577.192787: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.192787: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.192787: set_track <-free_debug_processing
          vsftpd-7977  [003] d...   577.192787: dump_trace <-save_stack_trace
          vsftpd-7977  [003] d...   577.192788: print_context_stack <-dump_trace
          vsftpd-7977  [003] d...   577.192791: init_object <-free_debug_processing
          vsftpd-7977  [003] ....   577.192791: _raw_spin_lock_irqsave <-__slab_free
          vsftpd-7977  [003] d...   577.192791: _raw_spin_unlock_irqrestore <-__slab_free
          vsftpd-7977  [003] ....   577.192792: mnt_free_id.isra.20 <-free_vfsmnt
          vsftpd-7977  [003] ....   577.192792: _raw_spin_lock <-mnt_free_id.isra.20
          vsftpd-7977  [003] ....   577.192792: free_percpu <-free_vfsmnt
          vsftpd-7977  [003] ....   577.192792: _raw_spin_lock_irqsave <-free_percpu
          vsftpd-7977  [003] d...   577.192792: pcpu_free_area <-free_percpu
          vsftpd-7977  [003] d...   577.192793: pcpu_chunk_slot <-pcpu_free_area
          vsftpd-7977  [003] d...   577.192793: pcpu_chunk_relocate <-pcpu_free_area
          vsftpd-7977  [003] d...   577.192794: pcpu_chunk_slot <-pcpu_chunk_relocate
          vsftpd-7977  [003] d...   577.192794: _raw_spin_unlock_irqrestore <-free_percpu
          vsftpd-7977  [003] ....   577.192794: kmem_cache_free <-free_vfsmnt
          vsftpd-7977  [003] ....   577.192794: __phys_addr <-kmem_cache_free
          vsftpd-7977  [003] ....   577.192794: __slab_free <-kmem_cache_free
          vsftpd-7977  [003] ....   577.192794: free_debug_processing <-__slab_free
          vsftpd-7977  [003] d...   577.192795: check_slab <-free_debug_processing
          vsftpd-7977  [003] d...   577.192795: slab_pad_check.part.42 <-check_slab
          vsftpd-7977  [003] d...   577.192795: on_freelist <-free_debug_processing
          vsftpd-7977  [003] d...   577.192796: check_object <-free_debug_processing
          vsftpd-7977  [003] d...   577.192796: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.192796: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.192796: set_track <-free_debug_processing
          vsftpd-7977  [003] d...   577.192797: dump_trace <-save_stack_trace
          vsftpd-7977  [003] d...   577.192797: print_context_stack <-dump_trace
          vsftpd-7977  [003] d...   577.192800: init_object <-free_debug_processing
          vsftpd-7977  [003] ....   577.192800: deactivate_super <-mntput_no_expire
          vsftpd-7977  [003] ....   577.192800: down_write <-deactivate_super
          vsftpd-7977  [003] ....   577.192801: _cond_resched <-down_write
          vsftpd-7977  [003] ....   577.192801: deactivate_locked_super <-deactivate_super
          vsftpd-7977  [003] ....   577.192801: proc_kill_sb <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.192801: kill_anon_super <-proc_kill_sb
          vsftpd-7977  [003] ....   577.192801: generic_shutdown_super <-kill_anon_super
          vsftpd-7977  [003] ....   577.192802: shrink_dcache_for_umount <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.192802: down_read_trylock <-shrink_dcache_for_umount
          vsftpd-7977  [003] ....   577.192802: shrink_dcache_for_umount_subtree <-shrink_dcache_for_umount
          vsftpd-7977  [003] ....   577.192802: dentry_lru_prune <-shrink_dcache_for_umount_subtree
          vsftpd-7977  [003] ....   577.192802: __d_shrink <-shrink_dcache_for_umount_subtree
          vsftpd-7977  [003] ....   577.192803: iput <-shrink_dcache_for_umount_subtree
          vsftpd-7977  [003] ....   577.192803: _raw_spin_lock <-_atomic_dec_and_lock
          vsftpd-7977  [003] ....   577.192803: generic_delete_inode <-iput
          vsftpd-7977  [003] ....   577.192803: evict <-iput
          vsftpd-7977  [003] ....   577.192804: _raw_spin_lock <-evict
          vsftpd-7977  [003] ....   577.192804: proc_evict_inode <-evict
          vsftpd-7977  [003] ....   577.192804: truncate_inode_pages <-proc_evict_inode
          vsftpd-7977  [003] ....   577.192804: truncate_inode_pages_range <-truncate_inode_pages
          vsftpd-7977  [003] ....   577.192804: end_writeback <-proc_evict_inode
          vsftpd-7977  [003] ....   577.192804: _cond_resched <-end_writeback
          vsftpd-7977  [003] ....   577.192805: _raw_spin_lock_irq <-end_writeback
          vsftpd-7977  [003] ....   577.192805: _cond_resched <-end_writeback
          vsftpd-7977  [003] ....   577.192805: put_pid <-proc_evict_inode
          vsftpd-7977  [003] ....   577.192805: put_pid: put_pid: NULL
          vsftpd-7977  [003] ....   577.192806: pde_put <-proc_evict_inode
          vsftpd-7977  [003] ....   577.192806: __remove_inode_hash <-evict
          vsftpd-7977  [003] ....   577.192806: _raw_spin_lock <-__remove_inode_hash
          vsftpd-7977  [003] ....   577.192806: _raw_spin_lock <-__remove_inode_hash
          vsftpd-7977  [003] ....   577.192806: _raw_spin_lock <-evict
          vsftpd-7977  [003] ....   577.192807: wake_up_bit <-evict
          vsftpd-7977  [003] ....   577.192807: bit_waitqueue <-wake_up_bit
          vsftpd-7977  [003] ....   577.192807: __phys_addr <-bit_waitqueue
          vsftpd-7977  [003] ....   577.192807: __wake_up_bit <-wake_up_bit
          vsftpd-7977  [003] ....   577.192807: destroy_inode <-evict
          vsftpd-7977  [003] ....   577.192807: __destroy_inode <-destroy_inode
          vsftpd-7977  [003] ....   577.192808: inode_has_buffers <-__destroy_inode
          vsftpd-7977  [003] ....   577.192808: __fsnotify_inode_delete <-__destroy_inode
          vsftpd-7977  [003] ....   577.192808: fsnotify_clear_marks_by_inode <-__fsnotify_inode_delete
          vsftpd-7977  [003] ....   577.192808: _raw_spin_lock <-fsnotify_clear_marks_by_inode
          vsftpd-7977  [003] ....   577.192808: proc_destroy_inode <-destroy_inode
          vsftpd-7977  [003] ....   577.192808: call_rcu_sched <-proc_destroy_inode
          vsftpd-7977  [003] ....   577.192809: __call_rcu <-call_rcu_sched
          vsftpd-7977  [003] ....   577.192809: d_free <-shrink_dcache_for_umount_subtree
          vsftpd-7977  [003] ....   577.192809: __d_free <-d_free
          vsftpd-7977  [003] ....   577.192809: kmem_cache_free <-__d_free
          vsftpd-7977  [003] ....   577.192809: __phys_addr <-kmem_cache_free
          vsftpd-7977  [003] ....   577.192810: __slab_free <-kmem_cache_free
          vsftpd-7977  [003] ....   577.192810: free_debug_processing <-__slab_free
          vsftpd-7977  [003] d...   577.192810: check_slab <-free_debug_processing
          vsftpd-7977  [003] d...   577.192811: slab_pad_check.part.42 <-check_slab
          vsftpd-7977  [003] d...   577.192811: on_freelist <-free_debug_processing
          vsftpd-7977  [003] d...   577.192812: check_object <-free_debug_processing
          vsftpd-7977  [003] d...   577.192812: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.192812: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.192812: set_track <-free_debug_processing
          vsftpd-7977  [003] d...   577.192813: dump_trace <-save_stack_trace
          vsftpd-7977  [003] d...   577.192813: print_context_stack <-dump_trace
          vsftpd-7977  [003] d...   577.192817: init_object <-free_debug_processing
          vsftpd-7977  [003] ....   577.192817: sync_filesystem <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.192817: __sync_filesystem <-sync_filesystem
          vsftpd-7977  [003] ....   577.192818: __sync_filesystem <-sync_filesystem
          vsftpd-7977  [003] ....   577.192818: fsnotify_unmount_inodes <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.192818: _raw_spin_lock <-fsnotify_unmount_inodes
          vsftpd-7977  [003] ....   577.192818: evict_inodes <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.192818: _raw_spin_lock <-evict_inodes
          vsftpd-7977  [003] ....   577.192818: dispose_list <-evict_inodes
          vsftpd-7977  [003] ....   577.192819: _raw_spin_lock <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.192819: up_write <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.192819: free_anon_bdev <-kill_anon_super
          vsftpd-7977  [003] ....   577.192819: _raw_spin_lock <-free_anon_bdev
          vsftpd-7977  [003] ....   577.192820: proc_kill_sb: put_pid_ns: 0xffff8801dc56b990 count:2->1
          vsftpd-7977  [003] ....   577.192820: unregister_shrinker <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.192820: down_write <-unregister_shrinker
          vsftpd-7977  [003] ....   577.192820: _cond_resched <-down_write
          vsftpd-7977  [003] ....   577.192821: up_write <-unregister_shrinker
          vsftpd-7977  [003] ....   577.192821: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.192821: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.192821: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.192821: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192821: _cond_resched <-mutex_lock
          vsftpd-7977  [003] ....   577.192822: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192822: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192822: smp_call_function <-on_each_cpu
          vsftpd-7977  [003] ....   577.192822: smp_call_function_many <-smp_call_function
          vsftpd-7977  [003] ....   577.192822: _raw_spin_lock_irqsave <-smp_call_function_many
          vsftpd-7977  [003] d...   577.192823: _raw_spin_unlock_irqrestore <-smp_call_function_many
          vsftpd-7977  [003] ....   577.192823: native_send_call_func_ipi <-smp_call_function_many
          vsftpd-7977  [003] ....   577.192823: flat_send_IPI_allbutself <-native_send_call_func_ipi
          vsftpd-7977  [003] d...   577.192832: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.192833: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] d...   577.192833: __call_rcu <-call_rcu_sched
          vsftpd-7977  [003] ....   577.192833: wait_for_completion <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.192833: wait_for_common <-wait_for_completion
          vsftpd-7977  [003] ....   577.192834: _cond_resched <-wait_for_common
          vsftpd-7977  [003] ....   577.192834: _raw_spin_lock_irq <-wait_for_common
          vsftpd-7977  [003] ....   577.192834: schedule_timeout <-wait_for_common
          vsftpd-7977  [003] ....   577.192834: schedule <-schedule_timeout
          vsftpd-7977  [003] ....   577.192834: __schedule <-schedule
          vsftpd-7977  [003] ....   577.192835: rcu_note_context_switch <-__schedule
          vsftpd-7977  [003] ....   577.192835: rcu_sched_qs <-rcu_note_context_switch
          vsftpd-7977  [003] ....   577.192835: _raw_spin_lock_irq <-__schedule
          vsftpd-7977  [003] d...   577.192835: deactivate_task <-__schedule
          vsftpd-7977  [003] d...   577.192835: dequeue_task <-deactivate_task
          vsftpd-7977  [003] d...   577.192835: update_rq_clock <-dequeue_task
          vsftpd-7977  [003] d...   577.192836: dequeue_task_fair <-dequeue_task
          vsftpd-7977  [003] d...   577.192836: update_curr <-dequeue_task_fair
          vsftpd-7977  [003] d...   577.192836: clear_buddies <-dequeue_task_fair
          vsftpd-7977  [003] d...   577.192836: hrtick_update <-dequeue_task_fair
          vsftpd-7977  [003] d...   577.192836: idle_balance <-__schedule
          vsftpd-7977  [003] d...   577.192837: _raw_spin_lock <-idle_balance
          vsftpd-7977  [003] d...   577.192837: put_prev_task_fair <-__schedule
          vsftpd-7977  [003] d...   577.192837: pick_next_task_fair <-__schedule
          vsftpd-7977  [003] d...   577.192837: pick_next_task_stop <-__schedule
          vsftpd-7977  [003] d...   577.192838: pick_next_task_rt <-__schedule
          vsftpd-7977  [003] d...   577.192838: pick_next_task_fair <-__schedule
          vsftpd-7977  [003] d...   577.192838: pick_next_task_idle <-__schedule
          vsftpd-7977  [003] d...   577.192838: calc_load_account_idle <-pick_next_task_idle
          <idle>-0     [003] d...   577.192839: finish_task_switch <-__schedule
          <idle>-0     [003] ....   577.192839: tick_nohz_idle_enter <-cpu_idle
          <idle>-0     [003] ....   577.192839: set_cpu_sd_state_idle <-tick_nohz_idle_enter
          <idle>-0     [003] d...   577.192839: tick_nohz_stop_sched_tick.isra.9 <-tick_nohz_idle_enter
          <idle>-0     [003] d...   577.192839: ktime_get <-tick_nohz_stop_sched_tick.isra.9
          <idle>-0     [003] ....   577.192840: local_touch_nmi <-cpu_idle
          <idle>-0     [003] d...   577.192840: enter_idle <-cpu_idle
...
          <idle>-0     [003] d...   577.192840: rcu_idle_enter <-cpu_idle
          <idle>-0     [003] d...   577.192841: rcu_idle_enter_common <-rcu_idle_enter
          <idle>-0     [003] d...   577.192841: rcu_cpu_has_callbacks <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.192841: rcu_pending <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.192841: __rcu_pending <-rcu_pending
          <idle>-0     [003] d...   577.192842: raise_softirq <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.192842: __raise_softirq_irqoff <-raise_softirq
          <idle>-0     [003] d...   577.192842: wakeup_softirqd <-raise_softirq
          <idle>-0     [003] d...   577.192842: wake_up_process <-wakeup_softirqd
...
     ksoftirqd/3-16    [003] d...   577.192853: finish_task_switch <-__schedule
     ksoftirqd/3-16    [003] d...   577.192853: __do_softirq <-run_ksoftirqd
     ksoftirqd/3-16    [003] ..s.   577.192853: rcu_process_callbacks <-__do_softirq
     ksoftirqd/3-16    [003] ..s.   577.192853: __rcu_process_callbacks <-rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.192853: rcu_process_gp_end <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] d.s.   577.192854: _raw_spin_trylock <-rcu_process_gp_end
     ksoftirqd/3-16    [003] d.s.   577.192854: __rcu_process_gp_end.isra.5 <-rcu_process_gp_end
     ksoftirqd/3-16    [003] d.s.   577.192854: _raw_spin_unlock_irqrestore <-rcu_process_gp_end
     ksoftirqd/3-16    [003] ..s.   577.192855: check_for_new_grace_period <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] d.s.   577.192855: _raw_spin_trylock <-check_for_new_grace_period
     ksoftirqd/3-16    [003] d.s.   577.192855: __note_new_gpnum.isra.27 <-check_for_new_grace_period
     ksoftirqd/3-16    [003] d.s.   577.192855: _raw_spin_unlock_irqrestore <-check_for_new_grace_period
     ksoftirqd/3-16    [003] ..s.   577.192855: __rcu_process_callbacks <-rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.192855: force_quiescent_state <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.192856: rcu_process_gp_end <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.192856: check_for_new_grace_period <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.192856: rcu_bh_qs <-__do_softirq
     ksoftirqd/3-16    [003] d.s.   577.192856: __local_bh_enable <-__do_softirq
     ksoftirqd/3-16    [003] ....   577.192856: _cond_resched <-run_ksoftirqd
     ksoftirqd/3-16    [003] ....   577.192857: rcu_note_context_switch <-run_ksoftirqd
     ksoftirqd/3-16    [003] ....   577.192857: rcu_sched_qs <-rcu_note_context_switch
     ksoftirqd/3-16    [003] ....   577.192857: kthread_should_stop <-run_ksoftirqd
     ksoftirqd/3-16    [003] ....   577.192857: schedule_preempt_disabled <-run_ksoftirqd
     ksoftirqd/3-16    [003] ....   577.192857: schedule <-schedule_preempt_disabled
     ksoftirqd/3-16    [003] ....   577.192858: __schedule <-schedule
...
     ksoftirqd/3-16    [003] d...   577.192861: calc_load_account_idle <-pick_next_task_idle
          <idle>-0     [003] d...   577.192861: finish_task_switch <-__schedule
          <idle>-0     [003] ....   577.192862: tick_nohz_idle_enter <-cpu_idle
          <idle>-0     [003] ....   577.192862: set_cpu_sd_state_idle <-tick_nohz_idle_enter
          <idle>-0     [003] d...   577.192862: tick_nohz_stop_sched_tick.isra.9 <-tick_nohz_idle_enter
          <idle>-0     [003] d...   577.192862: ktime_get <-tick_nohz_stop_sched_tick.isra.9
          <idle>-0     [003] ....   577.192863: local_touch_nmi <-cpu_idle
          <idle>-0     [003] d...   577.192863: enter_idle <-cpu_idle
          <idle>-0     [003] d...   577.192863: atomic_notifier_call_chain <-enter_idle
          <idle>-0     [003] d...   577.192863: notifier_call_chain <-atomic_notifier_call_chain
          <idle>-0     [003] d...   577.192863: rcu_idle_enter <-cpu_idle
          <idle>-0     [003] d...   577.192863: rcu_idle_enter_common <-rcu_idle_enter
          <idle>-0     [003] d...   577.192864: rcu_cpu_has_callbacks <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.192864: cpuidle_idle_call <-cpu_idle
          <idle>-0     [003] d...   577.192864: cpuidle_get_driver <-cpuidle_idle_call
          <idle>-0     [003] d...   577.192864: mwait_idle <-cpu_idle
          <idle>-0     [003] d...   577.196356: smp_apic_timer_interrupt <-apic_timer_interrupt
          <idle>-0     [003] d...   577.196356: native_apic_mem_write <-smp_apic_timer_interrupt
          <idle>-0     [003] d...   577.196357: irq_enter <-smp_apic_timer_interrupt
          <idle>-0     [003] d...   577.196357: rcu_irq_enter <-irq_enter
          <idle>-0     [003] d...   577.196357: rcu_idle_exit_common <-rcu_irq_enter
          <idle>-0     [003] d...   577.196357: hrtimer_cancel <-rcu_idle_exit_common
...
          <idle>-0     [003] d.h.   577.196366: update_process_times <-tick_sched_timer
          <idle>-0     [003] d.h.   577.196366: account_process_tick <-update_process_times
          <idle>-0     [003] d.h.   577.196367: run_local_timers <-update_process_times
          <idle>-0     [003] d.h.   577.196367: hrtimer_run_queues <-run_local_timers
          <idle>-0     [003] d.h.   577.196367: raise_softirq <-run_local_timers
          <idle>-0     [003] d.h.   577.196367: __raise_softirq_irqoff <-raise_softirq
          <idle>-0     [003] d.h.   577.196368: rcu_check_callbacks <-update_process_times
          <idle>-0     [003] d.h.   577.196368: rcu_sched_qs <-rcu_check_callbacks
          <idle>-0     [003] d.h.   577.196368: rcu_bh_qs <-rcu_check_callbacks
          <idle>-0     [003] d.h.   577.196369: rcu_pending <-rcu_check_callbacks
          <idle>-0     [003] d.h.   577.196369: __rcu_pending <-rcu_pending
          <idle>-0     [003] d.h.   577.196369: raise_softirq <-rcu_check_callbacks
          <idle>-0     [003] d.h.   577.196369: __raise_softirq_irqoff <-raise_softirq
...
          <idle>-0     [003] d...   577.196376: do_softirq <-irq_exit
          <idle>-0     [003] d...   577.196376: __do_softirq <-call_softirq
          <idle>-0     [003] ..s.   577.196376: run_timer_softirq <-__do_softirq
          <idle>-0     [003] ..s.   577.196377: hrtimer_run_pending <-run_timer_softirq
          <idle>-0     [003] ..s.   577.196377: _raw_spin_lock_irq <-run_timer_softirq
          <idle>-0     [003] ..s.   577.196377: rcu_bh_qs <-__do_softirq
          <idle>-0     [003] ..s.   577.196378: rcu_process_callbacks <-__do_softirq
          <idle>-0     [003] ..s.   577.196378: __rcu_process_callbacks <-rcu_process_callbacks
          <idle>-0     [003] ..s.   577.196378: rcu_process_gp_end <-__rcu_process_callbacks
          <idle>-0     [003] d.s.   577.196378: _raw_spin_trylock <-rcu_process_gp_end
          <idle>-0     [003] d.s.   577.196379: __rcu_process_gp_end.isra.5 <-rcu_process_gp_end
          <idle>-0     [003] d.s.   577.196379: _raw_spin_unlock_irqrestore <-rcu_process_gp_end
          <idle>-0     [003] ..s.   577.196379: check_for_new_grace_period <-__rcu_process_callbacks
          <idle>-0     [003] ..s.   577.196380: _raw_spin_lock_irqsave <-__rcu_process_callbacks
          <idle>-0     [003] d.s.   577.196380: rcu_start_gp <-__rcu_process_callbacks
...
          <idle>-0     [003] d...   577.196387: force_qs_rnp <-force_quiescent_state
          <idle>-0     [003] d...   577.196388: _raw_spin_lock_irqsave <-force_qs_rnp
          <idle>-0     [003] d...   577.196388: dyntick_save_progress_counter <-force_qs_rnp
          <idle>-0     [003] d...   577.196388: dyntick_save_progress_counter <-force_qs_rnp
          <idle>-0     [003] d...   577.196389: dyntick_save_progress_counter <-force_qs_rnp
          <idle>-0     [003] d...   577.196389: dyntick_save_progress_counter <-force_qs_rnp
          <idle>-0     [003] d...   577.196390: rcu_report_qs_rnp <-force_qs_rnp
          <idle>-0     [003] d...   577.196390: _raw_spin_unlock_irqrestore <-rcu_report_qs_rnp
          <idle>-0     [003] d...   577.196390: _raw_spin_lock <-force_quiescent_state
          <idle>-0     [003] d...   577.196391: _raw_spin_unlock_irqrestore <-force_quiescent_state
          <idle>-0     [003] d...   577.196391: rcu_cpu_has_callbacks <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.196391: raise_softirq <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.196391: __raise_softirq_irqoff <-raise_softirq
          <idle>-0     [003] d...   577.196392: wakeup_softirqd <-raise_softirq
          <idle>-0     [003] d...   577.196392: wake_up_process <-wakeup_softirqd
...
          <idle>-0     [003] .N..   577.196403: __schedule <-schedule
          <idle>-0     [003] .N..   577.196403: rcu_note_context_switch <-__schedule
          <idle>-0     [003] .N..   577.196403: rcu_sched_qs <-rcu_note_context_switch
          <idle>-0     [003] .N..   577.196403: _raw_spin_lock_irq <-__schedule
          <idle>-0     [003] dN..   577.196404: put_prev_task_idle <-__schedule
          <idle>-0     [003] dN..   577.196404: pick_next_task_fair <-__schedule
          <idle>-0     [003] dN..   577.196404: clear_buddies <-pick_next_task_fair
          <idle>-0     [003] dN..   577.196405: set_next_entity <-pick_next_task_fair
          <idle>-0     [003] dN..   577.196405: update_stats_wait_end <-set_next_entity
     ksoftirqd/3-16    [003] d...   577.196406: finish_task_switch <-__schedule
     ksoftirqd/3-16    [003] d...   577.196406: __do_softirq <-run_ksoftirqd
     ksoftirqd/3-16    [003] ..s.   577.196406: rcu_process_callbacks <-__do_softirq
     ksoftirqd/3-16    [003] ..s.   577.196407: __rcu_process_callbacks <-rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196407: rcu_process_gp_end <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196407: check_for_new_grace_period <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196408: rcu_report_qs_rdp.isra.29 <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196408: _raw_spin_lock_irqsave <-rcu_report_qs_rdp.isra.29
     ksoftirqd/3-16    [003] d.s.   577.196408: rcu_report_qs_rnp <-rcu_report_qs_rdp.isra.29
     ksoftirqd/3-16    [003] d.s.   577.196408: _raw_spin_unlock_irqrestore <-rcu_report_qs_rnp
     ksoftirqd/3-16    [003] ..s.   577.196409: __rcu_process_callbacks <-rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196409: force_quiescent_state <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196409: rcu_process_gp_end <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196410: check_for_new_grace_period <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196410: rcu_bh_qs <-__do_softirq
     ksoftirqd/3-16    [003] d.s.   577.196410: __local_bh_enable <-__do_softirq
     ksoftirqd/3-16    [003] ....   577.196410: _cond_resched <-run_ksoftirqd
     ksoftirqd/3-16    [003] ....   577.196411: rcu_note_context_switch <-run_ksoftirqd
     ksoftirqd/3-16    [003] ....   577.196411: rcu_sched_qs <-rcu_note_context_switch
     ksoftirqd/3-16    [003] ....   577.196411: kthread_should_stop <-run_ksoftirqd
     ksoftirqd/3-16    [003] ....   577.196412: schedule_preempt_disabled <-run_ksoftirqd
     ksoftirqd/3-16    [003] ....   577.196412: schedule <-schedule_preempt_disabled
     ksoftirqd/3-16    [003] ....   577.196412: __schedule <-schedule
     ksoftirqd/3-16    [003] ....   577.196412: rcu_note_context_switch <-__schedule
...
     ksoftirqd/3-16    [003] d...   577.196417: pick_next_task_idle <-__schedule
     ksoftirqd/3-16    [003] d...   577.196417: calc_load_account_idle <-pick_next_task_idle
          <idle>-0     [003] d...   577.196418: finish_task_switch <-__schedule
          <idle>-0     [003] ....   577.196418: tick_nohz_idle_enter <-cpu_idle
          <idle>-0     [003] ....   577.196419: set_cpu_sd_state_idle <-tick_nohz_idle_enter
          <idle>-0     [003] d...   577.196419: tick_nohz_stop_sched_tick.isra.9 <-tick_nohz_idle_enter
          <idle>-0     [003] d...   577.196419: ktime_get <-tick_nohz_stop_sched_tick.isra.9
          <idle>-0     [003] ....   577.196420: local_touch_nmi <-cpu_idle
          <idle>-0     [003] d...   577.196420: enter_idle <-cpu_idle
          <idle>-0     [003] d...   577.196420: atomic_notifier_call_chain <-enter_idle
          <idle>-0     [003] d...   577.196420: notifier_call_chain <-atomic_notifier_call_chain
          <idle>-0     [003] d...   577.196421: rcu_idle_enter <-cpu_idle
          <idle>-0     [003] d...   577.196421: rcu_idle_enter_common <-rcu_idle_enter
          <idle>-0     [003] d...   577.196421: rcu_cpu_has_callbacks <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.196421: rcu_sched_qs <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.196422: force_quiescent_state <-rcu_idle_enter_common
          <idle>-0     [003] d...   577.196422: _raw_spin_trylock <-force_quiescent_state
          <idle>-0     [003] d...   577.196422: _raw_spin_lock <-force_quiescent_state
          <idle>-0     [003] d...   577.196423: force_qs_rnp <-force_quiescent_state
          <idle>-0     [003] d...   577.196423: _raw_spin_lock_irqsave <-force_qs_rnp
          <idle>-0     [003] d...   577.196423: rcu_implicit_dynticks_qs <-force_qs_rnp
          <idle>-0     [003] d...   577.196424: rcu_report_qs_rnp <-force_qs_rnp
          <idle>-0     [003] d...   577.196424: _raw_spin_lock <-rcu_report_qs_rnp
          <idle>-0     [003] d...   577.196424: _raw_spin_lock <-rcu_report_qs_rnp
          <idle>-0     [003] d...   577.196425: rcu_start_gp <-rcu_report_qs_rnp
          <idle>-0     [003] d...   577.196425: _raw_spin_unlock_irqrestore <-rcu_start_gp
          <idle>-0     [003] d...   577.196425: _raw_spin_lock_irqsave <-force_qs_rnp
          <idle>-0     [003] d...   577.196426: _raw_spin_unlock_irqrestore <-force_qs_rnp
          <idle>-0     [003] d...   577.196426: _raw_spin_lock <-force_quiescent_state
          <idle>-0     [003] d...   577.196426: rcu_start_gp <-force_quiescent_state
...
          <idle>-0     [003] dN..   577.196443: clear_buddies <-pick_next_task_fair
          <idle>-0     [003] dN..   577.196443: set_next_entity <-pick_next_task_fair
          <idle>-0     [003] dN..   577.196443: update_stats_wait_end <-set_next_entity
     ksoftirqd/3-16    [003] d...   577.196444: finish_task_switch <-__schedule
     ksoftirqd/3-16    [003] d...   577.196444: __do_softirq <-run_ksoftirqd
     ksoftirqd/3-16    [003] ..s.   577.196444: rcu_process_callbacks <-__do_softirq
     ksoftirqd/3-16    [003] ..s.   577.196445: __rcu_process_callbacks <-rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196445: rcu_process_gp_end <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196445: check_for_new_grace_period <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196446: rcu_report_qs_rdp.isra.29 <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196446: _raw_spin_lock_irqsave <-rcu_report_qs_rdp.isra.29
     ksoftirqd/3-16    [003] d.s.   577.196446: rcu_report_qs_rnp <-rcu_report_qs_rdp.isra.29
     ksoftirqd/3-16    [003] d.s.   577.196446: _raw_spin_unlock_irqrestore <-rcu_report_qs_rnp
     ksoftirqd/3-16    [003] ..s.   577.196447: put_cred_rcu <-__rcu_process_callbacks
     ksoftirqd/3-16    [003] ..s.   577.196447: key_put <-put_cred_rcu
     ksoftirqd/3-16    [003] ..s.   577.196447: key_put <-put_cred_rcu
     ksoftirqd/3-16    [003] ..s.   577.196448: release_tgcred.isra.11 <-put_cred_rcu
     ksoftirqd/3-16    [003] ..s.   577.196448: call_rcu_sched <-release_tgcred.isra.11
     ksoftirqd/3-16    [003] ..s.   577.196448: __call_rcu <-call_rcu_sched
     ksoftirqd/3-16    [003] ..s.   577.196449: free_uid <-put_cred_rcu
     ksoftirqd/3-16    [003] ..s.   577.196449: kmem_cache_free <-put_cred_rcu
     ksoftirqd/3-16    [003] ..s.   577.196449: __phys_addr <-kmem_cache_free
     ksoftirqd/3-16    [003] ..s.   577.196450: __slab_free <-kmem_cache_free
     ksoftirqd/3-16    [003] ..s.   577.196450: free_debug_processing <-__slab_free
     ksoftirqd/3-16    [003] d.s.   577.196450: check_slab <-free_debug_processing
     ksoftirqd/3-16    [003] d.s.   577.196451: slab_pad_check.part.42 <-check_slab
     ksoftirqd/3-16    [003] d.s.   577.196451: on_freelist <-free_debug_processing
     ksoftirqd/3-16    [003] d.s.   577.196451: check_object <-free_debug_processing
     ksoftirqd/3-16    [003] d.s.   577.196452: check_bytes_and_report <-check_object
     ksoftirqd/3-16    [003] d.s.   577.196452: check_bytes_and_report <-check_object
     ksoftirqd/3-16    [003] d.s.   577.196452: set_track <-free_debug_processing
     ksoftirqd/3-16    [003] d.s.   577.196453: dump_trace <-save_stack_trace
     ksoftirqd/3-16    [003] d.s.   577.196453: print_context_stack <-dump_trace
     ksoftirqd/3-16    [003] d.s.   577.196458: init_object <-free_debug_processing
     ksoftirqd/3-16    [003] ..s.   577.196458: delayed_put_pid <-__rcu_process_callbacks
...
     ksoftirqd/3-16    [003] d...   577.196570: pick_next_task_fair <-__schedule
     ksoftirqd/3-16    [003] d...   577.196570: clear_buddies <-pick_next_task_fair
     ksoftirqd/3-16    [003] d...   577.196570: set_next_entity <-pick_next_task_fair
     ksoftirqd/3-16    [003] d...   577.196570: update_stats_wait_end <-set_next_entity
          vsftpd-7977  [003] d...   577.196571: finish_task_switch <-__schedule
          vsftpd-7977  [003] ....   577.196571: _raw_spin_lock_irq <-wait_for_common
          vsftpd-7977  [003] ....   577.196571: mutex_unlock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.196572: put_filesystem <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.196572: put_super <-deactivate_locked_super


