Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab0DVJ2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 05:28:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64032 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0DVJ2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 05:28:52 -0400
Message-ID: <4BD01740.7050805@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 17:30:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "containers@lists.osdl.org" <containers@lists.osdl.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/5] sched: Fix an RCU warning in print_task()
References: <4BD016F4.8060108@cn.fujitsu.com>
In-Reply-To: <4BD016F4.8060108@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_PROVE_RCU=y, a warning can be triggered:

  $ cat /proc/sched_debug

...
kernel/cgroup.c:1649 invoked rcu_dereference_check() without protection!
...

Both cgroup_path() and task_group() should be called with either
rcu_read_lock or cgroup_mutex held.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched_debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 9cf1baf..87a330a 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -114,7 +114,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	{
 		char path[64];
 
+		rcu_read_lock();
 		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
+		rcu_read_unlock();
 		SEQ_printf(m, " %s", path);
 	}
 #endif
-- 
1.6.3

