Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0JOUIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:08:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41010 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab0JOUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:08:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 15 Oct 2010 22:08:33 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: cpufreq: circular lock dependency
To: cpufreq@vger.kernel.org
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <tkrat.91982a9a79eb3b59@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Google says this is an old bug.

Got it today when I switched from ondemand to performance by
# echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
for each of cpu0,1,2,3.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.36-rc7 #8
-------------------------------------------------------
cpufreq-hi/11879 is trying to acquire lock:
(s_active#93){++++.+}, at: [<ffffffff810f9314>] sysfs_hash_and_remove+0x53/0x77

but task is already holding lock:
(dbs_mutex){+.+.+.}, at: [<ffffffffa0235f5b>] cpufreq_governor_dbs+0x372/0x423 [cpufreq_ondemand]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (dbs_mutex){+.+.+.}:
[<ffffffff8105c704>] lock_acquire+0x5a/0x71
[<ffffffff8133f214>] mutex_lock_nested+0x5c/0x2fa
[<ffffffffa0235c67>] cpufreq_governor_dbs+0x7e/0x423 [cpufreq_ondemand]
[<ffffffff812b6d23>] __cpufreq_governor+0xaa/0xe7
[<ffffffff812b6e64>] __cpufreq_set_policy+0x104/0x142
[<ffffffff812b878f>] store_scaling_governor+0x185/0x1c5
[<ffffffff812b7d0d>] store+0x5f/0x84
[<ffffffff810f9b00>] sysfs_write_file+0xf1/0x126
[<ffffffff810ac246>] vfs_write+0xae/0x135
[<ffffffff810ac391>] sys_write+0x47/0x6e
[<ffffffff8100202b>] system_call_fastpath+0x16/0x1b

-> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}:
[<ffffffff8105c704>] lock_acquire+0x5a/0x71
[<ffffffff8133f74a>] down_write+0x3f/0x60
[<ffffffff812b6bee>] lock_policy_rwsem_write+0x48/0x78
[<ffffffff812b7cee>] store+0x40/0x84
[<ffffffff810f9b00>] sysfs_write_file+0xf1/0x126
[<ffffffff810ac246>] vfs_write+0xae/0x135
[<ffffffff810ac391>] sys_write+0x47/0x6e
[<ffffffff8100202b>] system_call_fastpath+0x16/0x1b

-> #0 (s_active#93){++++.+}:
[<ffffffff8105bfe7>] __lock_acquire+0x1169/0x182c
[<ffffffff8105c704>] lock_acquire+0x5a/0x71
[<ffffffff810fafcb>] sysfs_addrm_finish+0xd0/0x13f
[<ffffffff810f9314>] sysfs_hash_and_remove+0x53/0x77
[<ffffffff810fc324>] sysfs_remove_group+0x90/0xc8
[<ffffffffa0235f72>] cpufreq_governor_dbs+0x389/0x423 [cpufreq_ondemand]
[<ffffffff812b6d23>] __cpufreq_governor+0xaa/0xe7
[<ffffffff812b6e4e>] __cpufreq_set_policy+0xee/0x142
[<ffffffff812b878f>] store_scaling_governor+0x185/0x1c5
[<ffffffff812b7d0d>] store+0x5f/0x84
[<ffffffff810f9b00>] sysfs_write_file+0xf1/0x126
[<ffffffff810ac246>] vfs_write+0xae/0x135
[<ffffffff810ac391>] sys_write+0x47/0x6e
[<ffffffff8100202b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

4 locks held by cpufreq-hi/11879:
#0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff810f9a48>] sysfs_write_file+0x39/0x126
#1:  (s_active#92){.+.+.+}, at: [<ffffffff810f9ae5>] sysfs_write_file+0xd6/0x126
#2:  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<ffffffff812b6bee>] lock_policy_rwsem_write+0x48/0x78
#3:  (dbs_mutex){+.+.+.}, at: [<ffffffffa0235f5b>] cpufreq_governor_dbs+0x372/0x423 [cpufreq_ondemand]

stack backtrace:
Pid: 11879, comm: cpufreq-hi Not tainted 2.6.36-rc7 #8
Call Trace:
[<ffffffff8105a93c>] print_circular_bug+0xb3/0xc2
[<ffffffff8105bfe7>] __lock_acquire+0x1169/0x182c
[<ffffffff8102c70c>] ? get_parent_ip+0x11/0x42
[<ffffffff81058be7>] ? lockdep_init_map+0x9f/0x4fe
[<ffffffff8105c704>] lock_acquire+0x5a/0x71
[<ffffffff810f9314>] ? sysfs_hash_and_remove+0x53/0x77
[<ffffffff8104bc6d>] ? __init_waitqueue_head+0x35/0x48
[<ffffffff810fafcb>] sysfs_addrm_finish+0xd0/0x13f
[<ffffffff810f9314>] ? sysfs_hash_and_remove+0x53/0x77
[<ffffffff8133f45b>] ? mutex_lock_nested+0x2a3/0x2fa
[<ffffffff8105a007>] ? mark_held_locks+0x4d/0x6b
[<ffffffff810f9314>] sysfs_hash_and_remove+0x53/0x77
[<ffffffff810fc324>] sysfs_remove_group+0x90/0xc8
[<ffffffffa0235f72>] cpufreq_governor_dbs+0x389/0x423 [cpufreq_ondemand]
[<ffffffff8104f76a>] ? up_read+0x1e/0x38
[<ffffffff8102c70c>] ? get_parent_ip+0x11/0x42
[<ffffffff812b6d23>] __cpufreq_governor+0xaa/0xe7
[<ffffffff812b6e4e>] __cpufreq_set_policy+0xee/0x142
[<ffffffff812b878f>] store_scaling_governor+0x185/0x1c5
[<ffffffff812b85bd>] ? handle_update+0x0/0xe
[<ffffffff8133f74a>] ? down_write+0x3f/0x60
[<ffffffff812b7d0d>] store+0x5f/0x84
[<ffffffff810f9b00>] sysfs_write_file+0xf1/0x126
[<ffffffff810ac246>] vfs_write+0xae/0x135
[<ffffffff810ac391>] sys_write+0x47/0x6e
[<ffffffff8100202b>] system_call_fastpath+0x16/0x1b



-- 
Stefan Richter
-=====-==-=- =-=- -====
http://arcgraph.de/sr/

