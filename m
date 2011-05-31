Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1EaR1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:27:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64699 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1EaR1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=q2SVqtVpMHLti7jG4mJem71R4KlMha5dTHT8gm1yn8QfaquqwLD2geuaJlkksO/awP
         eInahzrOGIDcJm+GWJM7GymGe2u65NCUhuO83py2LrgE/tWK3gym5ptV7Det7W0nBwld
         InYJOWjTmlCxz9o84zobkrYeqrckljq1QxqpQ=
Date: Tue, 31 May 2011 20:26:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
Message-ID: <20110531172651.GA4478@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap __set_task_cpu() with RCU read-side critical section. 
__set_task_cpu() calls task_group() that performs rcu dereference check in 
task_subsys_state_check(), causing:

 [  152.262791] kernel/sched.c:619 invoked rcu_dereference_check() without protection!
 [  152.262795] 
 [  152.262841] stack backtrace:
 [  152.262846] Pid: 16, comm: watchdog/1 Not tainted 3.0.0-rc1-dbg-00441-g1d5f9cc-dirty #599
 [  152.262851] Call Trace:
 [  152.262860]  [<ffffffff8106e17b>] lockdep_rcu_dereference+0xa7/0xaf
 [  152.262868]  [<ffffffff810369f4>] set_task_cpu+0x1ed/0x3ce
 [  152.262876]  [<ffffffff8123a5d7>] ? plist_check_head+0x94/0x98
 [  152.262883]  [<ffffffff8123a72d>] ? plist_del+0x82/0x89
 [  152.262889]  [<ffffffff8102b139>] ? dequeue_task_rt+0x33/0x38
 [  152.262895]  [<ffffffff8102e3ac>] ? dequeue_task+0x82/0x89
 [  152.262902]  [<ffffffff81036fc0>] push_rt_task.part.131+0x1bb/0x247
 [  152.262909]  [<ffffffff81037138>] post_schedule_rt+0x1b/0x24
 [  152.262918]  [<ffffffff81477c1c>] schedule+0x989/0xa9e
 [  152.262923]  [<ffffffff814775e6>] ? schedule+0x353/0xa9e
 [  152.262931]  [<ffffffff8147de58>] ? sub_preempt_count+0x8f/0xa3
 [  152.262938]  [<ffffffff8109fd2c>] ? watchdog_enable+0x195/0x195
 [  152.262946]  [<ffffffff810072e5>] ? native_sched_clock+0x38/0x65
 [  152.262953]  [<ffffffff81062c0c>] ? cpu_clock+0x4a/0x5f
 [  152.262958]  [<ffffffff8109fd2c>] ? watchdog_enable+0x195/0x195
 [  152.262965]  [<ffffffff81071a15>] ? trace_hardirqs_on_caller+0x10d/0x131
 [  152.262971]  [<ffffffff81071a46>] ? trace_hardirqs_on+0xd/0xf
 [  152.262977]  [<ffffffff8109fd2c>] ? watchdog_enable+0x195/0x195
 [  152.262983]  [<ffffffff8109fd94>] watchdog+0x68/0xab
 [  152.262990]  [<ffffffff8105cb82>] kthread+0x9a/0xa2
 [  152.262999]  [<ffffffff81481e24>] kernel_thread_helper+0x4/0x10
 [  152.263005]  [<ffffffff8102d6bf>] ? finish_task_switch+0x76/0xf0
 [  152.263012]  [<ffffffff8147b258>] ? retint_restore_args+0x13/0x13
 [  152.263019]  [<ffffffff8105cae8>] ? __init_kthread_worker+0x53/0x53
 [  152.263024]  [<ffffffff81481e20>] ? gs_change+0x13/0x13


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cbb3a0e..cf0dd8a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2212,7 +2212,9 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
 	}
 
+	rcu_read_lock();
 	__set_task_cpu(p, new_cpu);
+	rcu_read_unlock();
 }
 
 struct migration_arg {

