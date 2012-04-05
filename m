Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2DEErR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:47:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab2DEErQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:47:16 -0400
Message-ID: <1333601231.7783.31.camel@marge.simpson.net>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
From: Mike Galbraith <mgalbraith@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Date: Thu, 05 Apr 2012 06:47:11 +0200
In-Reply-To: <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
	 <1333535915.7188.18.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
	 <1333542649.7188.40.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com>
	 <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(replaces bouncy CC)

On Wed, 2012-04-04 at 16:09 -0700, Tejun Heo wrote:

> I don't see much problem with the proposed solution and am gonna take
> it unless there are pretty good reasons not to.

Below is user interface only patchlet.  I find it cleaner than the
cpuset,cpu variant, but don't have strong feelings either way.

If this one don't fly, I'll just declare buglet immortal, he ain't worth
near the electrons he's already wasted ;-) 

cgroups: disallow attaching kthreadd 

Allowing kthreadd to be moved to a non-root group makes no sense, it being
a global resource, and needlessly leads unsuspecting users toward trouble.

1. An RT workqueue worker thread spawned in a task group with no rt_runtime
allocated is not schedulable.  Simple user error, but harmful to the box.

2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
rendering the cpuset immortal.

Save the user some unexpected trouble, just say no.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
---
 kernel/cgroup.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,6 +60,7 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/kthread.h>
 
 #include <linux/atomic.h>
 
@@ -2172,6 +2181,17 @@ static int attach_task_by_pid(struct cgr
 
 	if (threadgroup)
 		tsk = tsk->group_leader;
+
+	/*
+	 * Workqueue threads may acquire PF_THREAD_BOUND and become
+	 * trapped in a cpuset, or RT worker may be born in a cgroup
+	 * with no rt_runtime allocated.  Just say no.
+	 */
+	if (tsk == kthreadd_task) {
+		ret = -EINVAL;
+		goto out_unlock_cgroup;
+	}
+
 	get_task_struct(tsk);
 	rcu_read_unlock();
 





