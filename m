Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1ECOS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:18:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45767 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1ECOSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:18:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: 2.6.39-rc5-mmotm0429 - lockdep splat in fsck/acpi
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304432140_4857P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 May 2011 10:15:41 -0400
Message-ID: <11287.1304432141@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DC00E0E.0054,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304432140_4857P
Content-Type: text/plain; charset=us-ascii

No, I have no idea how a path invoked by fsck and a path invoked by acpi
managed to cross paths. Lot of scheduler and acpi function names in the
tracebacks, so, tossing it to everybody plausible in MAINTAINERS.

Saw this during boot this morning:

[   87.294863] =======================================================
[   87.295177] [ INFO: possible circular locking dependency detected ]
[   87.295402] 2.6.39-rc5-mmotm0429 #1
[   87.295531] -------------------------------------------------------
[   87.295727] fsck/3150 is trying to acquire lock:
[   87.295727]  (rcu_node_level_0){..-...}, at: [<ffffffff810904a8>] rcu_read_unlock_special+0x8c/0x1d5
[   87.295727] 
[   87.295727] but task is already holding lock:
[   87.295727]  (&rq->lock){-.-.-.}, at: [<ffffffff81031dfb>] scheduler_ipi+0x34/0x5d
[   87.295727] 
[   87.295727] which lock already depends on the new lock.
[   87.295727] 
[   87.295727] 
[   87.295727] the existing dependency chain (in reverse order) is:
[   87.295727] 
[   87.295727] -> #2 (&rq->lock){-.-.-.}:
[   87.295727]        [<ffffffff810670e1>] check_prevs_add+0x8b/0x104
[   87.295727]        [<ffffffff810674c9>] validate_chain+0x36f/0x3ab
[   87.295727]        [<ffffffff81067b93>] __lock_acquire+0x369/0x3e2
[   87.295727]        [<ffffffff81068137>] lock_acquire+0xfc/0x14c
[   87.295727]        [<ffffffff81567951>] _raw_spin_lock+0x36/0x45
[   87.295727]        [<ffffffff81027df9>] __task_rq_lock+0x8b/0xd3
[   87.295727]        [<ffffffff81032fd1>] wake_up_new_task+0x41/0x108
[   87.295727]        [<ffffffff81037714>] do_fork+0x265/0x33f
[   87.295727]        [<ffffffff81007d02>] kernel_thread+0x6b/0x6d
[   87.295727]        [<ffffffff81538bbd>] rest_init+0x21/0xd2
[   87.295727]        [<ffffffff81b20b4f>] start_kernel+0x3bb/0x3c6
[   87.295727]        [<ffffffff81b2029f>] x86_64_start_reservations+0xaf/0xb3
[   87.295727]        [<ffffffff81b20393>] x86_64_start_kernel+0xf0/0xf7
[   87.295727] 
[   87.295727] -> #1 (&p->pi_lock){-.-.-.}:
[   87.295727]        [<ffffffff810670e1>] check_prevs_add+0x8b/0x104
[   87.295727]        [<ffffffff810674c9>] validate_chain+0x36f/0x3ab
[   87.295727]        [<ffffffff81067b93>] __lock_acquire+0x369/0x3e2
[   87.295727]        [<ffffffff81068137>] lock_acquire+0xfc/0x14c
[   87.295727]        [<ffffffff81567a4a>] _raw_spin_lock_irqsave+0x44/0x57
[   87.295727]        [<ffffffff81032de1>] try_to_wake_up+0x29/0x1aa
[   87.295727]        [<ffffffff81032f8e>] wake_up_process+0x10/0x12
[   87.295727]        [<ffffffff8108ff01>] rcu_cpu_kthread_timer+0x44/0x58
[   87.295727]        [<ffffffff810452ce>] call_timer_fn+0xac/0x1e9
[   87.295727]        [<ffffffff810455b5>] run_timer_softirq+0x1aa/0x1f2
[   87.295727]        [<ffffffff8103e4cf>] __do_softirq+0x109/0x26a
[   87.295727]        [<ffffffff8156f5cc>] call_softirq+0x1c/0x30
[   87.295727]        [<ffffffff81003207>] do_softirq+0x44/0xf1
[   87.295727]        [<ffffffff8103e901>] irq_exit+0x58/0xc8
[   87.295727]        [<ffffffff81017f5a>] smp_apic_timer_interrupt+0x79/0x87
[   87.295727]        [<ffffffff8156f153>] apic_timer_interrupt+0x13/0x20
[   87.295727]        [<ffffffff81059935>] up+0x55/0x5d
[   87.295727]        [<ffffffff81251dcd>] acpi_os_signal_semaphore+0x1c/0x27
[   87.295727]        [<ffffffff8127459c>] acpi_ut_release_mutex+0x59/0x5d
[   87.295727]        [<ffffffff8126bbb9>] acpi_ns_walk_namespace+0x94/0x17b
[   87.295727]        [<ffffffff8125f202>] acpi_ev_install_space_handler+0x20f/0x225
[   87.295727]        [<ffffffff8125f256>] acpi_ev_install_region_handlers+0x3e/0x77
[   87.295727]        [<ffffffff81272d50>] acpi_enable_subsystem+0x64/0x8b
[   87.295727]        [<ffffffff81b41721>] acpi_bus_init+0x18/0x12a
[   87.295727]        [<ffffffff81b418a1>] acpi_init+0x6e/0xb4
[   87.295727]        [<ffffffff8100020a>] do_one_initcall+0x7a/0x130
[   87.295727]        [<ffffffff81b20c3b>] kernel_init+0xe1/0x15b
[   87.295727]        [<ffffffff8156f4d4>] kernel_thread_helper+0x4/0x10
[   87.295727] 
[   87.295727] -> #0 (rcu_node_level_0){..-...}:
[   87.295727]        [<ffffffff81066eb0>] check_prev_add+0x68/0x20e
[   87.295727]        [<ffffffff810670e1>] check_prevs_add+0x8b/0x104
[   87.295727]        [<ffffffff810674c9>] validate_chain+0x36f/0x3ab
[   87.295727]        [<ffffffff81067b93>] __lock_acquire+0x369/0x3e2
[   87.295727]        [<ffffffff81068137>] lock_acquire+0xfc/0x14c
[   87.295727]        [<ffffffff81567951>] _raw_spin_lock+0x36/0x45
[   87.295727]        [<ffffffff810904a8>] rcu_read_unlock_special+0x8c/0x1d5
[   87.295727]        [<ffffffff81090640>] __rcu_read_unlock+0x4f/0xd7
[   87.295727]        [<ffffffff81027bb3>] rcu_read_unlock+0x21/0x23
[   87.295727]        [<ffffffff8102cc14>] cpuacct_charge+0x6c/0x75
[   87.295727]        [<ffffffff81030c3f>] update_curr+0x101/0x12e
[   87.295727]        [<ffffffff81031149>] check_preempt_wakeup+0xf7/0x23b
[   87.295727]        [<ffffffff8102ac93>] check_preempt_curr+0x2b/0x68
[   87.295727]        [<ffffffff81031cb9>] ttwu_do_wakeup+0x76/0x128
[   87.295727]        [<ffffffff81031dc2>] ttwu_do_activate.constprop.63+0x57/0x5c
[   87.295727]        [<ffffffff81031e0f>] scheduler_ipi+0x48/0x5d
[   87.295727]        [<ffffffff810177d5>] smp_reschedule_interrupt+0x16/0x18
[   87.295727]        [<ffffffff8156f273>] reschedule_interrupt+0x13/0x20
[   87.295727]        [<ffffffff810b6411>] rcu_read_unlock+0x21/0x23
[   87.295727]        [<ffffffff810b70dc>] find_get_page+0xa9/0xb9
[   87.295727]        [<ffffffff810b7840>] do_generic_file_read.constprop.13+0xae/0x46a
[   87.295727]        [<ffffffff810b8640>] generic_file_aio_read+0x1cd/0x232
[   87.295727]        [<ffffffff810f595d>] do_sync_read+0xba/0xfa
[   87.295727]        [<ffffffff810f60d7>] vfs_read+0xde/0x129
[   87.295727]        [<ffffffff810f6167>] sys_read+0x45/0x69
[   87.295727]        [<ffffffff8156e73b>] system_call_fastpath+0x16/0x1b
[   87.295727] 
[   87.295727] other info that might help us debug this:
[   87.295727] 
[   87.295727] Chain exists of:
[   87.295727]   rcu_node_level_0 --> &p->pi_lock --> &rq->lock
[   87.295727] 
[   87.295727]  Possible unsafe locking scenario:
[   87.295727] 
[   87.295727]        CPU0                    CPU1
[   87.295727]        ----                    ----
[   87.295727]   lock(&rq->lock);
[   87.295727]                                lock(&p->pi_lock);
[   87.295727]                                lock(&rq->lock);
[   87.295727]   lock(rcu_node_level_0);
[   87.295727] 
[   87.295727]  *** DEADLOCK ***
[   87.295727] 
[   87.295727] 1 lock held by fsck/3150:
[   87.295727]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff81031dfb>] scheduler_ipi+0x34/0x5d
[   87.295727] 
[   87.295727] stack backtrace:
[   87.295727] Pid: 3150, comm: fsck Not tainted 2.6.39-rc5-mmotm0429 #1
[   87.295727] Call Trace:
[   87.295727]  <IRQ>  [<ffffffff815486ed>] print_circular_bug+0xc8/0xd9
[   87.295727]  [<ffffffff81066eb0>] check_prev_add+0x68/0x20e
[   87.295727]  [<ffffffff812d863a>] ? scsi_request_fn+0x30d/0x3de
[   87.295727]  [<ffffffff810670e1>] check_prevs_add+0x8b/0x104
[   87.295727]  [<ffffffff810674c9>] validate_chain+0x36f/0x3ab
[   87.295727]  [<ffffffff81067b93>] __lock_acquire+0x369/0x3e2
[   87.295727]  [<ffffffff810685f5>] ? trace_hardirqs_on_caller+0xfd/0x13b
[   87.295727]  [<ffffffff81567fb0>] ? _raw_spin_unlock_irqrestore+0x7b/0x80
[   87.295727]  [<ffffffff810904a8>] ? rcu_read_unlock_special+0x8c/0x1d5
[   87.295727]  [<ffffffff81068137>] lock_acquire+0xfc/0x14c
[   87.295727]  [<ffffffff810904a8>] ? rcu_read_unlock_special+0x8c/0x1d5
[   87.295727]  [<ffffffff81567951>] _raw_spin_lock+0x36/0x45
[   87.295727]  [<ffffffff810904a8>] ? rcu_read_unlock_special+0x8c/0x1d5
[   87.295727]  [<ffffffff810904a8>] rcu_read_unlock_special+0x8c/0x1d5
[   87.295727]  [<ffffffff81067f37>] ? __lock_release+0x8c/0x9c
[   87.295727]  [<ffffffff81090640>] __rcu_read_unlock+0x4f/0xd7
[   87.295727]  [<ffffffff81027bb3>] rcu_read_unlock+0x21/0x23
[   87.295727]  [<ffffffff8102cc14>] cpuacct_charge+0x6c/0x75
[   87.295727]  [<ffffffff81030c3f>] update_curr+0x101/0x12e
[   87.295727]  [<ffffffff81031149>] check_preempt_wakeup+0xf7/0x23b
[   87.295727]  [<ffffffff8102ac93>] check_preempt_curr+0x2b/0x68
[   87.295727]  [<ffffffff81031cb9>] ttwu_do_wakeup+0x76/0x128
[   87.295727]  [<ffffffff81031dc2>] ttwu_do_activate.constprop.63+0x57/0x5c
[   87.295727]  [<ffffffff81031e0f>] scheduler_ipi+0x48/0x5d
[   87.295727]  [<ffffffff810177d5>] smp_reschedule_interrupt+0x16/0x18
[   87.295727]  [<ffffffff8156f273>] reschedule_interrupt+0x13/0x20
[   87.295727]  <EOI>  [<ffffffff8109041d>] ? rcu_read_unlock_special+0x1/0x1d5
[   87.295727]  [<ffffffff81090640>] ? __rcu_read_unlock+0x4f/0xd7
[   87.295727]  [<ffffffff810b6411>] rcu_read_unlock+0x21/0x23
[   87.295727]  [<ffffffff810b70dc>] find_get_page+0xa9/0xb9
[   87.295727]  [<ffffffff810b7840>] do_generic_file_read.constprop.13+0xae/0x46a
[   87.295727]  [<ffffffff810b8640>] generic_file_aio_read+0x1cd/0x232
[   87.295727]  [<ffffffff810f595d>] do_sync_read+0xba/0xfa
[   87.295727]  [<ffffffff810f5cc8>] ? rw_verify_area+0x13e/0x161
[   87.295727]  [<ffffffff810f60d7>] vfs_read+0xde/0x129
[   87.295727]  [<ffffffff810f6167>] sys_read+0x45/0x69
[   87.295727]  [<ffffffff8156e73b>] system_call_fastpath+0x16/0x1b


--==_Exmh_1304432140_4857P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwA4McC3lWbTT17ARAvd1AJoDoOxKFqKlVHcMuxmhmYW0/qRxdgCfbPL5
fSbEAq2M0+G7z3y7dzzDRSA=
=6ZsM
-----END PGP SIGNATURE-----

--==_Exmh_1304432140_4857P--

