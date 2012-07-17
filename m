Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2GQJEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:04:07 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34105 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2GQJED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:04:03 -0400
Message-ID: <50052A7C.4040104@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 17:03:56 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        paul@paulmenage.org
Subject: [PATCH 1/5] cpusets: add basic variables
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071709-2000-0000-0000-0000084C23A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

Add the variables we need for the implementation of dynamical domain
flags.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/sched.h |   22 ++++++++++++++++++++++
 kernel/cpuset.c       |    7 +++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ddc1225..9164309 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -922,8 +922,30 @@ static inline unsigned int group_first_cpu(struct sched_group *group)
 	return cpumask_first(sched_group_cpus(group));
 }
 
+enum {
+#ifdef CONFIG_SCHED_SMT
+	SMT_DDF,
+#endif
+#ifdef CONFIG_SCHED_MC
+	MC_DDF,
+#endif
+#ifdef CONFIG_SCHED_BOOK
+	BOOK_DDF,
+#endif
+	CPU_DDF,
+	MAX_DDF,
+};
+
 struct sched_domain_attr {
 	int relax_domain_level;
+	/*
+	 * dynamical domain flag array cover all level, only useful if
+	 * enable_ddf is 1.
+	 * the static domain flags will be replaced by ddf on each domain
+	 * level dynamically in set_domain_attribute.
+	 */
+	u64 ddf[MAX_DDF];
+	int enable_ddf;
 };
 
 #define SD_ATTR_INIT	(struct sched_domain_attr) {	\
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 0cbc631..35fb585 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -105,6 +105,13 @@ struct cpuset {
 	/* for custom sched domain */
 	int relax_domain_level;
 
+	/*
+	 * dynamical domain flag configuration for cpuset, see struct
+	 * sched_domain_attr for detail.
+	 */
+	u64 ddf[MAX_DDF];
+	int enable_ddf;
+
 	/* used for walking a cpuset hierarchy */
 	struct list_head stack_list;
 };
-- 
1.7.4.1

