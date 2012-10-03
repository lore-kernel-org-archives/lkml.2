Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2JCXH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:07:56 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:47090 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab2JCXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:07:18 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 33C7B8217E
From: Andrea Righi <andrea@betterlinux.com>
To: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrea Righi <andrea@betterlinux.com>
Subject: [PATCH RFC 2/3] cpusets: add load avgerage interface
Date: Thu,  4 Oct 2012 01:05:11 +0200
Message-Id: <1349305512-3428-3-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
References: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
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
 kernel/cpuset.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f33c715..fef6d3e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1465,6 +1465,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_LOADAVG,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
@@ -1686,6 +1687,57 @@ static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
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
@@ -1780,6 +1832,12 @@ static struct cftype files[] = {
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
1.7.9.5

