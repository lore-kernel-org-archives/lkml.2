Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2GQJE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:04:27 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59140 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2GQJER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:04:17 -0400
Message-ID: <50052A89.3070304@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 17:04:09 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        paul@paulmenage.org
Subject: [PATCH 4/5] cpusets: add fundamental functions for recording
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071709-5816-0000-0000-0000039EE239
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

Add the fundamental functions which will help to record the status of
dynamical domain flags for cpuset.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/cpuset.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index def8080..066c61c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1189,6 +1189,37 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 }
 
 /*
+ * update the ddf of cs according to level and rebuild domain
+ * if ddf enabled.
+ */
+static int update_ddf(int level, struct cpuset *cs, u64 val)
+{
+	if (!is_sched_load_balance(cs))
+		return -EINVAL;
+
+	cs->ddf[level] = val;
+	if (cs->enable_ddf)
+		async_rebuild_sched_domains();
+
+	return 0;
+}
+
+/* enable or disable ddf supporting and rebuild domain */
+static int enable_ddf(struct cpuset *cs, u64 val)
+{
+	if (!is_sched_load_balance(cs))
+		return -EINVAL;
+
+	if ((val != 0 && val != 1) || cs->enable_ddf == val)
+		return -EINVAL;
+
+	cs->enable_ddf = val;
+	async_rebuild_sched_domains();
+
+	return 0;
+}
+
+/*
  * cpuset_change_flag - make a task's spread flags the same as its cpuset's
  * @tsk: task to be updated
  * @scan: struct cgroup_scanner containing the cgroup of the task
-- 
1.7.4.1

