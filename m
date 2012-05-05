Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2EEF4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 01:56:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33124 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751971Ab2EEF4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 01:56:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/VM+5mGIHVq2K0CxEJ9x1qFHheHiHNCBiKS7/6Lz
	nGYgAlbmoeebX1
Message-ID: <1336197362.7346.9.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Sat, 05 May 2012 07:56:02 +0200
In-Reply-To: <m1fwbfd71h.fsf@fess.ebiederm.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 13:29 -0700, Eric W. Biederman wrote:

> Shrug.  I have skimmed through all of that code and I don't see anything
> obvious.  I guess it would take a few more data points to figure out
> where we are sleeping for a jiffy or two while we are reaping children.

GrimReaper meets SynchroZilla

          vsftpd-7977  [003] ....   577.171463: sys_wait4 <-system_call_fastpath
          vsftpd-7977  [003] ....   577.171463: do_wait <-sys_wait4
          vsftpd-7977  [003] ....   577.171463: add_wait_queue <-do_wait
          vsftpd-7977  [003] ....   577.171463: _raw_spin_lock_irqsave <-add_wait_queue
          vsftpd-7977  [003] d...   577.171463: _raw_spin_unlock_irqrestore <-add_wait_queue
          vsftpd-7977  [003] ....   577.171464: _raw_read_lock <-do_wait
          vsftpd-7977  [003] ....   577.171464: wait_consider_task <-do_wait
          vsftpd-7977  [003] ....   577.171464: wait_consider_task <-do_wait
          vsftpd-7977  [003] ....   577.171464: wait_consider_task <-do_wait
          vsftpd-7977  [003] ....   577.171465: __task_pid_nr_ns <-wait_consider_task
          vsftpd-7977  [003] ....   577.171465: pid_nr_ns <-__task_pid_nr_ns
          vsftpd-7977  [003] ....   577.171465: thread_group_times <-wait_consider_task
          vsftpd-7977  [003] ....   577.171466: thread_group_cputime <-thread_group_times
          vsftpd-7977  [003] ....   577.171466: task_sched_runtime <-thread_group_cputime
          vsftpd-7977  [003] ....   577.171466: task_rq_lock <-task_sched_runtime
          vsftpd-7977  [003] ....   577.171466: _raw_spin_lock_irqsave <-task_rq_lock
          vsftpd-7977  [003] d...   577.171467: _raw_spin_lock <-task_rq_lock
          vsftpd-7977  [003] d...   577.171467: _raw_spin_unlock_irqrestore <-task_sched_runtime
          vsftpd-7977  [003] ....   577.171467: nsecs_to_jiffies <-thread_group_times
          vsftpd-7977  [003] ....   577.171467: _raw_spin_lock_irq <-wait_consider_task
          vsftpd-7977  [003] ....   577.171468: release_task <-wait_consider_task
          vsftpd-7977  [003] ....   577.171468: proc_flush_task <-release_task
          vsftpd-7977  [003] ....   577.171470: d_hash_and_lookup <-proc_flush_task
          vsftpd-7977  [003] ....   577.171470: full_name_hash <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.171470: d_lookup <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.171470: __d_lookup <-d_lookup
          vsftpd-7977  [003] ....   577.171471: d_hash_and_lookup <-proc_flush_task
          vsftpd-7977  [003] ....   577.171471: full_name_hash <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.171471: d_lookup <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.171472: __d_lookup <-d_lookup
          vsftpd-7977  [003] ....   577.171472: d_hash_and_lookup <-proc_flush_task
          vsftpd-7977  [003] ....   577.171472: full_name_hash <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.171472: d_lookup <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.171473: __d_lookup <-d_lookup
          vsftpd-7977  [003] ....   577.171473: d_hash_and_lookup <-proc_flush_task
          vsftpd-7977  [003] ....   577.171473: full_name_hash <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.171473: d_lookup <-d_hash_and_lookup
          vsftpd-7977  [003] ....   577.171473: __d_lookup <-d_lookup
          vsftpd-7977  [003] ....   577.171474: pid_ns_release_proc <-proc_flush_task
          vsftpd-7977  [003] ....   577.171474: kern_unmount <-pid_ns_release_proc
          vsftpd-7977  [003] ....   577.171474: mnt_make_shortterm <-kern_unmount
          vsftpd-7977  [003] ....   577.171474: vfsmount_lock_global_lock_online <-mnt_make_shortterm
          vsftpd-7977  [003] ....   577.171474: _raw_spin_lock <-vfsmount_lock_global_lock_online
          vsftpd-7977  [003] ....   577.171475: vfsmount_lock_global_unlock_online <-mnt_make_shortterm
          vsftpd-7977  [003] ....   577.171475: mntput <-kern_unmount
          vsftpd-7977  [003] ....   577.171475: mntput_no_expire <-mntput
          vsftpd-7977  [003] ....   577.171476: vfsmount_lock_local_lock <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171476: vfsmount_lock_global_lock_online <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171476: _raw_spin_lock <-vfsmount_lock_global_lock_online
          vsftpd-7977  [003] ....   577.171476: mnt_get_count <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171477: vfsmount_lock_global_unlock_online <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171477: mnt_get_writers.isra.12 <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171477: __fsnotify_vfsmount_delete <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171477: fsnotify_clear_marks_by_mount <-__fsnotify_vfsmount_delete
          vsftpd-7977  [003] ....   577.171478: _raw_spin_lock <-fsnotify_clear_marks_by_mount
          vsftpd-7977  [003] ....   577.171478: dput <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171478: _raw_spin_lock <-dput
          vsftpd-7977  [003] ....   577.171478: free_vfsmnt <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171478: kfree <-free_vfsmnt
          vsftpd-7977  [003] ....   577.171479: __phys_addr <-kfree
          vsftpd-7977  [003] ....   577.171479: __slab_free <-kfree
          vsftpd-7977  [003] ....   577.171479: free_debug_processing <-__slab_free
          vsftpd-7977  [003] d...   577.171479: check_slab <-free_debug_processing
          vsftpd-7977  [003] d...   577.171479: slab_pad_check.part.42 <-check_slab
          vsftpd-7977  [003] d...   577.171480: on_freelist <-free_debug_processing
          vsftpd-7977  [003] d...   577.171480: check_object <-free_debug_processing
          vsftpd-7977  [003] d...   577.171480: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.171480: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.171481: set_track <-free_debug_processing
          vsftpd-7977  [003] d...   577.171481: dump_trace <-save_stack_trace
          vsftpd-7977  [003] d...   577.171481: print_context_stack <-dump_trace
          vsftpd-7977  [003] d...   577.171484: init_object <-free_debug_processing
          vsftpd-7977  [003] ....   577.171485: _raw_spin_lock_irqsave <-__slab_free
          vsftpd-7977  [003] d...   577.171485: _raw_spin_unlock_irqrestore <-__slab_free
          vsftpd-7977  [003] ....   577.171485: mnt_free_id.isra.20 <-free_vfsmnt
          vsftpd-7977  [003] ....   577.171485: _raw_spin_lock <-mnt_free_id.isra.20
          vsftpd-7977  [003] ....   577.171486: free_percpu <-free_vfsmnt
          vsftpd-7977  [003] ....   577.171486: _raw_spin_lock_irqsave <-free_percpu
          vsftpd-7977  [003] d...   577.171486: pcpu_free_area <-free_percpu
          vsftpd-7977  [003] d...   577.171487: pcpu_chunk_slot <-pcpu_free_area
          vsftpd-7977  [003] d...   577.171487: pcpu_chunk_relocate <-pcpu_free_area
          vsftpd-7977  [003] d...   577.171488: pcpu_chunk_slot <-pcpu_chunk_relocate
          vsftpd-7977  [003] d...   577.171488: _raw_spin_unlock_irqrestore <-free_percpu
          vsftpd-7977  [003] ....   577.171488: kmem_cache_free <-free_vfsmnt
          vsftpd-7977  [003] ....   577.171488: __phys_addr <-kmem_cache_free
          vsftpd-7977  [003] ....   577.171489: __slab_free <-kmem_cache_free
          vsftpd-7977  [003] ....   577.171489: free_debug_processing <-__slab_free
          vsftpd-7977  [003] d...   577.171489: check_slab <-free_debug_processing
          vsftpd-7977  [003] d...   577.171489: slab_pad_check.part.42 <-check_slab
          vsftpd-7977  [003] d...   577.171489: on_freelist <-free_debug_processing
          vsftpd-7977  [003] d...   577.171490: check_object <-free_debug_processing
          vsftpd-7977  [003] d...   577.171490: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.171490: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.171491: set_track <-free_debug_processing
          vsftpd-7977  [003] d...   577.171491: dump_trace <-save_stack_trace
          vsftpd-7977  [003] d...   577.171491: print_context_stack <-dump_trace
          vsftpd-7977  [003] d...   577.171494: init_object <-free_debug_processing
          vsftpd-7977  [003] ....   577.171495: deactivate_super <-mntput_no_expire
          vsftpd-7977  [003] ....   577.171495: down_write <-deactivate_super
          vsftpd-7977  [003] ....   577.171495: _cond_resched <-down_write
          vsftpd-7977  [003] ....   577.171495: deactivate_locked_super <-deactivate_super
          vsftpd-7977  [003] ....   577.171496: proc_kill_sb <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.171496: kill_anon_super <-proc_kill_sb
          vsftpd-7977  [003] ....   577.171496: generic_shutdown_super <-kill_anon_super
          vsftpd-7977  [003] ....   577.171496: shrink_dcache_for_umount <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.171496: down_read_trylock <-shrink_dcache_for_umount
          vsftpd-7977  [003] ....   577.171497: shrink_dcache_for_umount_subtree <-shrink_dcache_for_umount
          vsftpd-7977  [003] ....   577.171497: dentry_lru_prune <-shrink_dcache_for_umount_subtree
          vsftpd-7977  [003] ....   577.171498: __d_shrink <-shrink_dcache_for_umount_subtree
          vsftpd-7977  [003] ....   577.171498: iput <-shrink_dcache_for_umount_subtree
          vsftpd-7977  [003] ....   577.171498: _raw_spin_lock <-_atomic_dec_and_lock
          vsftpd-7977  [003] ....   577.171499: generic_delete_inode <-iput
          vsftpd-7977  [003] ....   577.171499: evict <-iput
          vsftpd-7977  [003] ....   577.171499: _raw_spin_lock <-evict
          vsftpd-7977  [003] ....   577.171500: proc_evict_inode <-evict
          vsftpd-7977  [003] ....   577.171500: truncate_inode_pages <-proc_evict_inode
          vsftpd-7977  [003] ....   577.171500: truncate_inode_pages_range <-truncate_inode_pages
          vsftpd-7977  [003] ....   577.171501: end_writeback <-proc_evict_inode
          vsftpd-7977  [003] ....   577.171501: _cond_resched <-end_writeback
          vsftpd-7977  [003] ....   577.171501: _raw_spin_lock_irq <-end_writeback
          vsftpd-7977  [003] ....   577.171501: _cond_resched <-end_writeback
          vsftpd-7977  [003] ....   577.171501: put_pid <-proc_evict_inode
          vsftpd-7977  [003] ....   577.171502: put_pid: put_pid: NULL
          vsftpd-7977  [003] ....   577.171502: pde_put <-proc_evict_inode
          vsftpd-7977  [003] ....   577.171502: __remove_inode_hash <-evict
          vsftpd-7977  [003] ....   577.171503: _raw_spin_lock <-__remove_inode_hash
          vsftpd-7977  [003] ....   577.171503: _raw_spin_lock <-__remove_inode_hash
          vsftpd-7977  [003] ....   577.171503: _raw_spin_lock <-evict
          vsftpd-7977  [003] ....   577.171504: wake_up_bit <-evict
          vsftpd-7977  [003] ....   577.171504: bit_waitqueue <-wake_up_bit
          vsftpd-7977  [003] ....   577.171504: __phys_addr <-bit_waitqueue
          vsftpd-7977  [003] ....   577.171504: __wake_up_bit <-wake_up_bit
          vsftpd-7977  [003] ....   577.171504: destroy_inode <-evict
          vsftpd-7977  [003] ....   577.171505: __destroy_inode <-destroy_inode
          vsftpd-7977  [003] ....   577.171505: inode_has_buffers <-__destroy_inode
          vsftpd-7977  [003] ....   577.171505: __fsnotify_inode_delete <-__destroy_inode
          vsftpd-7977  [003] ....   577.171505: fsnotify_clear_marks_by_inode <-__fsnotify_inode_delete
          vsftpd-7977  [003] ....   577.171505: _raw_spin_lock <-fsnotify_clear_marks_by_inode
          vsftpd-7977  [003] ....   577.171506: proc_destroy_inode <-destroy_inode
          vsftpd-7977  [003] ....   577.171506: call_rcu_sched <-proc_destroy_inode
          vsftpd-7977  [003] ....   577.171506: __call_rcu <-call_rcu_sched
          vsftpd-7977  [003] ....   577.171506: d_free <-shrink_dcache_for_umount_subtree
          vsftpd-7977  [003] ....   577.171507: __d_free <-d_free
          vsftpd-7977  [003] ....   577.171507: kmem_cache_free <-__d_free
          vsftpd-7977  [003] ....   577.171507: __phys_addr <-kmem_cache_free
          vsftpd-7977  [003] ....   577.171507: __slab_free <-kmem_cache_free
          vsftpd-7977  [003] ....   577.171507: free_debug_processing <-__slab_free
          vsftpd-7977  [003] d...   577.171508: check_slab <-free_debug_processing
          vsftpd-7977  [003] d...   577.171508: slab_pad_check.part.42 <-check_slab
          vsftpd-7977  [003] d...   577.171508: on_freelist <-free_debug_processing
          vsftpd-7977  [003] d...   577.171509: check_object <-free_debug_processing
          vsftpd-7977  [003] d...   577.171509: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.171510: check_bytes_and_report <-check_object
          vsftpd-7977  [003] d...   577.171510: set_track <-free_debug_processing
          vsftpd-7977  [003] d...   577.171510: dump_trace <-save_stack_trace
          vsftpd-7977  [003] d...   577.171510: print_context_stack <-dump_trace
          vsftpd-7977  [003] d...   577.171514: init_object <-free_debug_processing
          vsftpd-7977  [003] ....   577.171515: sync_filesystem <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.171515: __sync_filesystem <-sync_filesystem
          vsftpd-7977  [003] ....   577.171515: __sync_filesystem <-sync_filesystem
          vsftpd-7977  [003] ....   577.171516: fsnotify_unmount_inodes <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.171516: _raw_spin_lock <-fsnotify_unmount_inodes
          vsftpd-7977  [003] ....   577.171516: evict_inodes <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.171516: _raw_spin_lock <-evict_inodes
          vsftpd-7977  [003] ....   577.171516: dispose_list <-evict_inodes
          vsftpd-7977  [003] ....   577.171517: _raw_spin_lock <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.171517: up_write <-generic_shutdown_super
          vsftpd-7977  [003] ....   577.171517: free_anon_bdev <-kill_anon_super
          vsftpd-7977  [003] ....   577.171517: _raw_spin_lock <-free_anon_bdev
          vsftpd-7977  [003] ....   577.171518: proc_kill_sb: put_pid_ns: 0xffff8801dc56f320 count:2->1
          vsftpd-7977  [003] ....   577.171518: unregister_shrinker <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.171518: down_write <-unregister_shrinker
          vsftpd-7977  [003] ....   577.171518: _cond_resched <-down_write
          vsftpd-7977  [003] ....   577.171519: up_write <-unregister_shrinker
          vsftpd-7977  [003] ....   577.171519: rcu_barrier <-deactivate_locked_super
          vsftpd-7977  [003] ....   577.171519: rcu_barrier_sched <-rcu_barrier
          vsftpd-7977  [003] ....   577.171519: _rcu_barrier.isra.31 <-rcu_barrier_sched
          vsftpd-7977  [003] ....   577.171519: mutex_lock <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.171520: _cond_resched <-mutex_lock
          vsftpd-7977  [003] ....   577.171520: __init_waitqueue_head <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.171520: on_each_cpu <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.171520: smp_call_function <-on_each_cpu
          vsftpd-7977  [003] ....   577.171521: smp_call_function_many <-smp_call_function
          vsftpd-7977  [003] ....   577.171521: _raw_spin_lock_irqsave <-smp_call_function_many
          vsftpd-7977  [003] d...   577.171521: _raw_spin_unlock_irqrestore <-smp_call_function_many
          vsftpd-7977  [003] ....   577.171522: native_send_call_func_ipi <-smp_call_function_many
          vsftpd-7977  [003] ....   577.171522: flat_send_IPI_allbutself <-native_send_call_func_ipi
          vsftpd-7977  [003] d...   577.171532: rcu_barrier_func <-on_each_cpu
          vsftpd-7977  [003] d...   577.171532: call_rcu_sched <-rcu_barrier_func
          vsftpd-7977  [003] d...   577.171533: __call_rcu <-call_rcu_sched
          vsftpd-7977  [003] ....   577.171533: wait_for_completion <-_rcu_barrier.isra.31
          vsftpd-7977  [003] ....   577.171533: wait_for_common <-wait_for_completion
          vsftpd-7977  [003] ....   577.171533: _cond_resched <-wait_for_common
          vsftpd-7977  [003] ....   577.171533: _raw_spin_lock_irq <-wait_for_common
          vsftpd-7977  [003] ....   577.171534: schedule_timeout <-wait_for_common
          vsftpd-7977  [003] ....   577.171534: schedule <-schedule_timeout
          vsftpd-7977  [003] ....   577.171534: __schedule <-schedule



