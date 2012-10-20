Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab2JTTGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 15:06:51 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:54188 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2JTTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 15:06:24 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com A3EB783304
From: Andrea Righi <andrea@betterlinux.com>
To: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrea Righi <andrea@betterlinux.com>
Subject: [PATCH v2 2/3] cpusets: add load avgerage interface
Date: Sat, 20 Oct 2012 21:06:01 +0200
Message-Id: <1350759962-7092-3-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
References: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new file loadavg to report the load average of the cpus assigned
to the cpuset cgroup.

The load average is reported using the typical three values as they
appear in /proc/loadavg, averaged over 1, 5 and 15 minutes.

Example:
  # cat /sys/fs/cgroup/cpuset/foo/cpuset.loadavg
  3.98 2.64 1.20

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 kernel/cpuset.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f33c715..1bb10d1 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1465,6 +1465,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_LOADAVG,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
@@ -1686,6 +1687,107 @@ static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
 	return 0;
 }
 
+/*
+ * XXX: move all of this to a better place and unify the different
+ * re-definition of these macros.
+ */
+#define LOAD_INT(x) ((x) >> FSHIFT)
+#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
+
+static void cpuset_show_loadavg(struct seq_file *m, const struct cpuset *cs)
+{
+	unsigned long avnrun[3] = {};
+	int cpu;
+
+	/*
+	 * The global load average is an exponentially decaying average of:
+	 *
+	 *   x(t) = nr_running(t) + nr_uninterruptible(t)
+	 *
+	 * The global load average of the system is evaluated as:
+	 *
+	 *   load(t) = load(t - 1) * exp_k + x(t) * (1 - exp_k)
+	 *
+	 * So, the load average of a cpuset with N CPUS can be evaluated as:
+	 *
+	 *   load_cs(t) = load_cs(t - 1) * exp_k + x_cs(t) * (1 - exp_k),
+	 *   x_cs(t) = \sum{i = 1}^{N} x_i(t)
+	 *
+	 * This is equivalent to the sum of all the partial load averages of
+	 * each CPU assigned to the cpuset:
+	 *
+	 *   load_cs(t) = \sum{i = 1}^{N} load_i(t)
+	 *
+	 * Proof:
+	 *
+	 *   load_1(t) = load_1(t - 1) * exp_k + x_1(t) * (1 - exp_k)
+	 *   load_2(t) = load_2(t - 1) * exp_k + x_2(t) * (1 - exp_k)
+	 *   ...
+	 *   load_N(t) = load_N(t - 1) * exp_k + x_N(t) * (1 - exp_k)
+	 *
+	 *   ===>
+	 *
+	 *   load_1(t) = x_1(1) * (1 - exp_k) * exp_k^{t - 1} +
+	 *               x_1(2) * (1 - exp_k) * exp_k^{t - 2} +
+	 *               ... +
+	 *               x_1(t)(1 - exp_k)
+	 *   load_2(t) = x_2(1) * (1 - exp_k) * exp_k^{t - 1} +
+	 *               x_2(2) * (1 - exp_k) * exp_k^{t - 2} +
+	 *               ... +
+	 *               x_2(t)(1 - exp_k)
+	 *   ...
+	 *   load_N(t) = x_N(1) * (1 - exp_k) * exp_k^{t - 1} +
+	 *               x_N(2) * (1 - exp_k) * exp_k^{t - 2} +
+	 *               ... +
+	 *               x_N(t)(1 - exp_k)
+	 *
+	 *   ===>
+	 *
+	 *   load_1(t) + load_2(t) + ... + load_N(t) =
+	 *       \sum_{i = 1}^{N} x_i(1) * (1 - exp_k) * exp_k^{t - 1} +
+	 *       \sum_{i = 1}^{N} x_i(2) * (1 - exp_k) * exp_k^{t - 2} +
+	 *       ... +
+	 *       \sum_{i = 1}^{N} x_i(t) * (1 - exp_k) = load_cs(t)
+	 */
+	for_each_cpu(cpu, cs->cpus_allowed) {
+		unsigned long cpu_avnrun[3];
+		int i;
+
+		get_cpu_avenrun(cpu_avnrun, cpu, FIXED_1/200, 0);
+
+		for (i = 0; i < ARRAY_SIZE(cpu_avnrun); i++)
+			avnrun[i] += cpu_avnrun[i];
+	}
+	/*
+	 * TODO: also report nr_running/nr_threads and last_pid, producing the
+	 * same output as /proc/loadavg.
+	 *
+	 * For nr_running we can just sum the nr_running_cpu() of the cores
+	 * assigned to this cs; what should we report in nr_threads? maybe
+	 * cgroup_task_count()? and what about last_pid?
+	 */
+	seq_printf(m, "%lu.%02lu %lu.%02lu %lu.%02lu\n",
+		   LOAD_INT(avnrun[0]), LOAD_FRAC(avnrun[0]),
+		   LOAD_INT(avnrun[1]), LOAD_FRAC(avnrun[1]),
+		   LOAD_INT(avnrun[2]), LOAD_FRAC(avnrun[2]));
+}
+
+static int cpuset_read_seq_string(struct cgroup *cont, struct cftype *cft,
+			       struct seq_file *m)
+{
+	struct cpuset *cs = cgroup_cs(cont);
+	cpuset_filetype_t type = cft->private;
+
+	switch (type) {
+	case FILE_LOADAVG:
+		cpuset_show_loadavg(m, cs);
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+}
 
 /*
  * for the common functions, 'private' gives the type of file
@@ -1780,6 +1882,12 @@ static struct cftype files[] = {
 		.private = FILE_MEMORY_PRESSURE_ENABLED,
 	},
 
+	{
+		.name = "loadavg",
+		.read_seq_string = cpuset_read_seq_string,
+		.private = FILE_LOADAVG,
+	},
+
 	{ }	/* terminate */
 };
 
-- 
1.7.10.4

