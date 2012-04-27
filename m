Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2D0GGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:06:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35633 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2D0GGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:06:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F9A36DE.30301@jp.fujitsu.com>
Date: Fri, 27 Apr 2012 15:04:14 +0900
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
Subject: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a cgroup
 being destroyed
References: <4F9A327A.6050409@jp.fujitsu.com>
In-Reply-To: <4F9A327A.6050409@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ->pre_destroy() is called, it should be guaranteed that
new child cgroup is not created under a cgroup, where pre_destroy()
is running. If not, ->pre_destroy() must check children and
return -EBUSY, which causes warning.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/cgroup.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7a3076b..003ceed 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3970,6 +3970,15 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	mutex_lock(&cgroup_mutex);
 
+	/*
+	 * prevent making child cgroup when ->pre_destroy() is running.
+	 */
+	if (test_bit(CGRP_WAIT_ON_RMDIR, &parent->flags)) {
+		mutex_unlock(&cgroup_mutex);
+		atomic_dec(&sb->s_active);
+		return -EBUSY;
+	}
+
 	init_cgroup_housekeeping(cgrp);
 
 	cgrp->parent = parent;
-- 
1.7.4.1


