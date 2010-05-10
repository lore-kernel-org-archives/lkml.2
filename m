Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0EJFyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:54:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:33889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab0EJFyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:54:50 -0400
Date: Mon, 10 May 2010 05:54:19 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, davej@redhat.com,
       riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, davej@redhat.com,
       riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100509082606.3d9f00d0@infradead.org>
References: <20100509082606.3d9f00d0@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] ondemand: Solve a big performance issue by counting IOWAIT time as busy
Message-ID: <tip-6b8fcd9029f217a9ecce822db645e19111c11080@git.kernel.org>
Git-Commit-ID: 6b8fcd9029f217a9ecce822db645e19111c11080
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:54:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b8fcd9029f217a9ecce822db645e19111c11080
Gitweb:     http://git.kernel.org/tip/6b8fcd9029f217a9ecce822db645e19111c11080
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sun, 9 May 2010 08:26:06 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 May 2010 19:35:27 +0200

ondemand: Solve a big performance issue by counting IOWAIT time as busy

The ondemand cpufreq governor uses CPU busy time (e.g. not-idle
time) as a measure for scaling the CPU frequency up or down.
If the CPU is busy, the CPU frequency scales up, if it's idle,
the CPU frequency scales down. Effectively, it uses the CPU busy
time as proxy variable for the more nebulous "how critical is
performance right now" question.

This algorithm falls flat on its face in the light of workloads
where you're alternatingly disk and CPU bound, such as the ever
popular "git grep", but also things like startup of programs and
maildir using email clients... much to the chagarin of Andrew
Morton.

This patch changes the ondemand algorithm to count iowait time
as busy, not idle, time. As shown in the breakdown cases above,
iowait is performance critical often, and by counting iowait,
the proxy variable becomes a more accurate representation of the
"how critical is performance" question.

The problem and fix are both verified with the "perf timechar"
tool.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Jones <davej@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100509082606.3d9f00d0@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/cpufreq/cpufreq_ondemand.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index bd444dc..ed472f8 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -73,6 +73,7 @@ enum {DBS_NORMAL_SAMPLE, DBS_SUB_SAMPLE};
 
 struct cpu_dbs_info_s {
 	cputime64_t prev_cpu_idle;
+	cputime64_t prev_cpu_iowait;
 	cputime64_t prev_cpu_wall;
 	cputime64_t prev_cpu_nice;
 	struct cpufreq_policy *cur_policy;
@@ -148,6 +149,16 @@ static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
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
@@ -470,14 +481,15 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
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
@@ -487,6 +499,10 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 				j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
+		iowait_time = (unsigned int) cputime64_sub(cur_iowait_time,
+				j_dbs_info->prev_cpu_iowait);
+		j_dbs_info->prev_cpu_iowait = cur_iowait_time;
+
 		if (dbs_tuners_ins.ignore_nice) {
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
@@ -504,6 +520,16 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
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
 
