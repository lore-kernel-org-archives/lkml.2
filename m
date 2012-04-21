Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2DUHNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 03:13:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab2DUHNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 03:13:50 -0400
Message-ID: <1334992426.5428.7.camel@marge.simpson.net>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
From: Mike Galbraith <mgalbraith@suse.de>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Rientjes <rientjes@google.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 21 Apr 2012 09:13:46 +0200
In-Reply-To: <4F9259C2.9040305@huawei.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
	 <20120420175751.GF32324@google.com>
	 <1334986264.5428.1.camel@marge.simpson.net> <4F9259C2.9040305@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-21 at 14:54 +0800, Li Zefan wrote:

> forgot rcu_read_unlock() ?

Eek, we don't need another one of those. Thanks.

> Otherwise Acked-by: Li Zefan <lizefan@huawei.com>

cgroups: disallow attaching kthreadd or PF_THREAD_BOUND threads

Allowing kthreadd to be moved to a non-root group makes no sense, it being
a global resource, and needlessly leads unsuspecting users toward trouble.

1. An RT workqueue worker thread spawned in a task group with no rt_runtime
allocated is not schedulable.  Simple user error, but harmful to the box.

2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
rendering the cpuset immortal.

Save the user some unexpected trouble, just say no.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,6 +60,7 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/kthread.h>
 
 #include <linux/atomic.h>
 
@@ -2172,6 +2173,18 @@ static int attach_task_by_pid(struct cgr
 
 	if (threadgroup)
 		tsk = tsk->group_leader;
+
+	/*
+	 * Workqueue threads may acquire PF_THREAD_BOUND and become
+	 * trapped in a cpuset, or RT worker may be born in a cgroup
+	 * with no rt_runtime allocated.  Just say no.
+	 */
+	if (tsk == kthreadd_task || (tsk->flags & PF_THREAD_BOUND)) {
+		ret = -EINVAL;
+		rcu_read_unlock();
+		goto out_unlock_cgroup;
+	}
+
 	get_task_struct(tsk);
 	rcu_read_unlock();
 



