Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0EIPZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:25:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:40382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab0EIPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:24:28 -0400
Date: Sun, 9 May 2010 08:26:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
Subject: [PATCH v2  7/8] ondemand: Solve a big performance issue by counting
 IOWAIT time as busy
Message-ID: <20100509082606.3d9f00d0@infradead.org>
In-Reply-To: <20100509082126.4a080d46@infradead.org>
References: <20100509082126.4a080d46@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

The ondemand cpufreq governor uses CPU busy time (e.g. not-idle time) as
a measure for scaling the CPU frequency up or down.
If the CPU is busy, the CPU frequency scales up, if it's idle, the CPU
frequency scales down. Effectively, it uses the CPU busy time as proxy
variable for the more nebulous "how critical is performance right now"
question.

This algorithm falls flat on its face in the light of workloads where
you're alternatingly disk and CPU bound, such as the ever popular
"git grep", but also things like startup of programs and maildir using
email clients... much to the chagarin of Andrew Morton.

This patch changes the ondemand algorithm to count iowait time as busy,
not idle, time. As shown in the breakdown cases above, iowait is performance
critical often, and by counting iowait, the proxy variable becomes a more
accurate representation of the "how critical is performance" question.

The problem and fix are both verified with the "perf timechar" tool.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Jones <davej@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
---

 drivers/cpufreq/cpufreq_ondemand.c |   30 +++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -73,6 +73,7 @@ enum {DBS_NORMAL_SAMPLE, DBS_SUB_SAMPLE}
 
 struct cpu_dbs_info_s {
 	cputime64_t prev_cpu_idle;
+	cputime64_t prev_cpu_iowait;
 	cputime64_t prev_cpu_wall;
 	cputime64_t prev_cpu_nice;
 	struct cpufreq_policy *cur_policy;
@@ -148,6 +149,16 @@ static inline cputime64_t get_cpu_idle_t
 	return idle_time;
 }
 
+static inline cputime64_t get_cpu_iowait_time(unsigned int cpu, cputime64_t *wall)
+{
+	u64 iowait_time = get_cpu_iowait_time_us(cpu, wall);
+
+	if (iowait_time == -1ULL)
+		return 0;
+
+	return iowait_time;
+}
+
 /*
  * Find right freq to be set now with powersave_bias on.
  * Returns the freq_hi to be used right now and will set freq_hi_jiffies,
@@ -465,14 +476,15 @@ static void dbs_check_cpu(struct cpu_dbs
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
-		cputime64_t cur_wall_time, cur_idle_time;
-		unsigned int idle_time, wall_time;
+		cputime64_t cur_wall_time, cur_idle_time, cur_iowait_time;
+		unsigned int idle_time, wall_time, iowait_time;
 		unsigned int load, load_freq;
 		int freq_avg;
 
 		j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
 
 		cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
+		cur_iowait_time = get_cpu_iowait_time(j, &cur_wall_time);
 
 		wall_time = (unsigned int) cputime64_sub(cur_wall_time,
 				j_dbs_info->prev_cpu_wall);
@@ -482,6 +494,10 @@ static void dbs_check_cpu(struct cpu_dbs
 				j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
+		iowait_time = (unsigned int) cputime64_sub(cur_iowait_time,
+				j_dbs_info->prev_cpu_iowait);
+		j_dbs_info->prev_cpu_iowait = cur_iowait_time;
+
 		if (dbs_tuners_ins.ignore_nice) {
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
@@ -499,6 +515,16 @@ static void dbs_check_cpu(struct cpu_dbs
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
+		/*
+		 * For the purpose of ondemand, waiting for disk IO is an
+		 * indication that you're performance critical, and not that
+		 * the system is actually idle. So subtract the iowait time
+		 * from the cpu idle time.
+		 */
+
+		if (idle_time >= iowait_time)
+			idle_time -= iowait_time;
+
 		if (unlikely(!wall_time || wall_time < idle_time))
 			continue;
 
_
