Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2D0GEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:04:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44895 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2D0GEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:04:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F9A366E.9020307@jp.fujitsu.com>
Date: Fri, 27 Apr 2012 15:02:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: [RFC][PATCH 7/9 v2] cgroup: avoid attaching task to a cgroup under
 rmdir()
References: <4F9A327A.6050409@jp.fujitsu.com>
In-Reply-To: <4F9A327A.6050409@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

attach_task() is done under cgroup_mutex() but ->pre_destroy() callback
in rmdir() isn't called under cgroup_mutex().

It's better to avoid attaching a task to a cgroup which
is under pre_destroy(). Considering memcg, the attached task may
increase resource usage after memcg's pre_destroy() confirms that
memcg is empty. This is not good.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/cgroup.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ad8eae5..7a3076b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1953,6 +1953,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	if (cgrp == oldcgrp)
 		return 0;
 
+	if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
+		return -EBUSY;
+
 	tset.single.task = tsk;
 	tset.single.cgrp = oldcgrp;
 
@@ -4181,7 +4184,6 @@ again:
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * In general, subsystem has no css->refcnt after pre_destroy(). But
@@ -4193,6 +4195,7 @@ again:
 	 * and css_tryget() and cgroup_wakeup_rmdir_waiter() implementation.
 	 */
 	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
+	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * Call pre_destroy handlers of subsys. Notify subsystems
-- 
1.7.4.1


