Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2GQJEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:04:42 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33564 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2GQJEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:04:38 -0400
Message-ID: <50052A9D.3040001@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 17:04:29 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        paul@paulmenage.org
Subject: [PATCH 5/5] cpusets: add the configuration facility
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071709-8256-0000-0000-000003588962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

Add the facility for user to configure the dynamical domain flags and
enable/disable it.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/cpuset.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 066c61c..5ff649d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1506,6 +1506,17 @@ typedef enum {
 	FILE_MEM_HARDWALL,
 	FILE_SCHED_LOAD_BALANCE,
 	FILE_SCHED_RELAX_DOMAIN_LEVEL,
+#ifdef CONFIG_SCHED_SMT
+	FILE_SCHED_SMT_DDF,
+#endif
+#ifdef CONFIG_SCHED_MC
+	FILE_SCHED_MC_DDF,
+#endif
+#ifdef CONFIG_SCHED_BOOK
+	FILE_SCHED_BOOK_DDF,
+#endif
+	FILE_SCHED_CPU_DDF,
+	FILE_SCHED_ENABLE_DDF,
 	FILE_MEMORY_PRESSURE_ENABLED,
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
@@ -1549,6 +1560,27 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		break;
+#ifdef CONFIG_SCHED_SMT
+	case FILE_SCHED_SMT_DDF:
+		retval = update_ddf(SMT_DDF, cs, val);
+		break;
+#endif
+#ifdef CONFIG_SCHED_MC
+	case FILE_SCHED_MC_DDF:
+		retval = update_ddf(MC_DDF, cs, val);
+		break;
+#endif
+#ifdef CONFIG_SCHED_BOOK
+	case FILE_SCHED_BOOK_DDF:
+		retval = update_ddf(BOOK_DDF, cs, val);
+		break;
+#endif
+	case FILE_SCHED_CPU_DDF:
+		retval = update_ddf(CPU_DDF, cs, val);
+		break;
+	case FILE_SCHED_ENABLE_DDF:
+		retval = enable_ddf(cs, val);
+		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -1708,6 +1740,22 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
 		return is_spread_page(cs);
 	case FILE_SPREAD_SLAB:
 		return is_spread_slab(cs);
+#ifdef CONFIG_SCHED_SMT
+	case FILE_SCHED_SMT_DDF:
+		return cs->ddf[SMT_DDF];
+#endif
+#ifdef CONFIG_SCHED_MC
+	case FILE_SCHED_MC_DDF:
+		return cs->ddf[MC_DDF];
+#endif
+#ifdef CONFIG_SCHED_BOOK
+	case FILE_SCHED_BOOK_DDF:
+		return cs->ddf[BOOK_DDF];
+#endif
+	case FILE_SCHED_CPU_DDF:
+		return cs->ddf[CPU_DDF];
+	case FILE_SCHED_ENABLE_DDF:
+		return cs->enable_ddf;
 	default:
 		BUG();
 	}
@@ -1788,6 +1836,43 @@ static struct cftype files[] = {
 		.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
 	},
 
+#ifdef CONFIG_SCHED_SMT
+	{
+		.name = "sched_smt_domain_flag",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_SMT_DDF,
+	},
+#endif
+#ifdef CONFIG_SCHED_MC
+	{
+		.name = "sched_mc_domain_flag",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_MC_DDF,
+	},
+#endif
+#ifdef CONFIG_SCHED_BOOK
+	{
+		.name = "sched_book_domain_flag",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_BOOK_DDF,
+	},
+#endif
+	{
+		.name = "sched_cpu_domain_flag",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_CPU_DDF,
+	},
+	{
+		.name = "sched_enable_domain_flag",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_ENABLE_DDF,
+	},
+
 	{
 		.name = "memory_migrate",
 		.read_u64 = cpuset_read_u64,
-- 
1.7.4.1

