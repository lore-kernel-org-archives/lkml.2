Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966400Ab0CPOsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:48:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:44597 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966383Ab0CPOsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:48:13 -0400
Date: Tue, 16 Mar 2010 14:47:20 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B9F48AD.4000404@cn.fujitsu.com>
References: <4B9F48AD.4000404@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix tracepoints & lockdep false positive
Message-ID: <tip-7f5b774275df8c76a959eae7488128b637fcbfc8@git.kernel.org>
Git-Commit-ID: 7f5b774275df8c76a959eae7488128b637fcbfc8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 14:47:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f5b774275df8c76a959eae7488128b637fcbfc8
Gitweb:     http://git.kernel.org/tip/7f5b774275df8c76a959eae7488128b637fcbfc8
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 16 Mar 2010 17:00:29 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 10:10:40 +0100

rcu: Fix tracepoints & lockdep false positive

tracepoint.h uses rcu_dereference(), which triggers this warning:

[    0.701161] ===================================================
[    0.702211] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.702716] ---------------------------------------------------
[    0.703203] include/trace/events/workqueue.h:68 invoked rcu_dereference_check() without protection!
[    0.703971] [ 0.703990] other info that might help us debug this:
[    0.703993]
[    0.705590]
[    0.705604] rcu_scheduler_active = 1, debug_locks = 0
[    0.706712] 1 lock held by swapper/1:
[    0.707229]  #0:  (cpu_add_remove_lock){+.+.+.}, at: [<c0142f54>] cpu_maps_update_begin+0x14/0x20
[    0.710097]
[    0.710106] stack backtrace:
[    0.712602] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-tip-01613-g72662bb #168
[    0.713231] Call Trace:
[    0.713997]  [<c017174d>] lockdep_rcu_dereference+0x9d/0xb0
[    0.714746]  [<c015a117>] create_workqueue_thread+0x107/0x110
[    0.715353]  [<c015aee0>] ? worker_thread+0x0/0x340
[    0.715845]  [<c015a8e8>] __create_workqueue_key+0x138/0x240
[    0.716427]  [<c0142f92>] ? cpu_maps_update_done+0x12/0x20
[    0.717012]  [<c086b12f>] init_workqueues+0x6f/0x80
[    0.717530]  [<c08576d2>] kernel_init+0x102/0x1f0
[    0.717570]  [<c08575d0>] ? kernel_init+0x0/0x1f0
[    0.718944]  [<c01030fa>] kernel_thread_helper+0x6/0x10

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B9F48AD.4000404@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/tracepoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index f59604e..78b4bd3 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -49,7 +49,7 @@ struct tracepoint {
 		void **it_func;						\
 									\
 		rcu_read_lock_sched_notrace();				\
-		it_func = rcu_dereference((tp)->funcs);			\
+		it_func = rcu_dereference_sched((tp)->funcs);		\
 		if (it_func) {						\
 			do {						\
 				((void(*)(proto))(*it_func))(args);	\
