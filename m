Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2GQJEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:04:13 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55340 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2GQJEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:04:09 -0400
Message-ID: <50052A81.1000600@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 17:04:01 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        paul@paulmenage.org
Subject: [PATCH 2/5] cpusets: add functions and code for initialization
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071709-9574-0000-0000-0000039B99CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

Add the functions and code which will do initialization for dynamical
domain flags.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/sched.h |   10 ++++++++--
 kernel/cpuset.c       |    8 ++++++--
 kernel/sched/core.c   |    2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9164309..3c91116 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -948,10 +948,16 @@ struct sched_domain_attr {
 	int enable_ddf;
 };
 
-#define SD_ATTR_INIT	(struct sched_domain_attr) {	\
-	.relax_domain_level = -1,			\
+static inline void sd_attr_init(struct sched_domain_attr *attr)
+{
+	int i;
+	attr->relax_domain_level = -1;
+	for (i = 0; i < MAX_DDF; i++)
+		attr->ddf[i] = 0;
+	attr->enable_ddf = 0;
 }
 
+
 extern int sched_domain_level_max;
 
 struct sched_domain {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 35fb585..67ee111 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -588,7 +588,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 
 		dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
 		if (dattr) {
-			*dattr = SD_ATTR_INIT;
+			sd_attr_init(dattr);
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
 		cpumask_copy(doms[0], top_cpuset.cpus_allowed);
@@ -697,7 +697,7 @@ restart:
 
 		cpumask_clear(dp);
 		if (dattr)
-			*(dattr + nslot) = SD_ATTR_INIT;
+			sd_attr_init(dattr + nslot);
 		for (j = i; j < csn; j++) {
 			struct cpuset *b = csa[j];
 
@@ -1834,6 +1834,7 @@ static void cpuset_post_clone(struct cgroup *cgroup)
 
 static struct cgroup_subsys_state *cpuset_create(struct cgroup *cont)
 {
+	int i;
 	struct cpuset *cs;
 	struct cpuset *parent;
 
@@ -1859,6 +1860,9 @@ static struct cgroup_subsys_state *cpuset_create(struct cgroup *cont)
 	nodes_clear(cs->mems_allowed);
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
+	for (i = 0; i < MAX_DDF; i++)
+		cs->ddf[i] = 0;
+	cs->enable_ddf = 0;
 
 	cs->parent = parent;
 	number_of_cpusets++;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3987b9d..3f9d368 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7087,7 +7087,7 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
 	if (!new && !cur)
 		return 1;
 
-	tmp = SD_ATTR_INIT;
+	sd_attr_init(&tmp);
 	return !memcmp(cur ? (cur + idx_cur) : &tmp,
 			new ? (new + idx_new) : &tmp,
 			sizeof(struct sched_domain_attr));
-- 
1.7.4.1

