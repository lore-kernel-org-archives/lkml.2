Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807Ab2C3OBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:01:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760180Ab2C3OA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:00:56 -0400
Date: Fri, 30 Mar 2012 06:58:25 -0700
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
Message-ID: <tip-cb85a6ed67e979c59a29b7b4e8217e755b951cf4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        schwidefsky@de.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        tglx@linutronix.de, mhocko@suse.cz
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, mhocko@suse.cz
In-Reply-To: <20120330122308.18720283@de.ibm.com>
References: <20120330122308.18720283@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] proc: stats:
  Use arch_idle_time for idle and iowait times if available
Git-Commit-ID: cb85a6ed67e979c59a29b7b4e8217e755b951cf4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 30 Mar 2012 06:58:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb85a6ed67e979c59a29b7b4e8217e755b951cf4
Gitweb:     http://git.kernel.org/tip/cb85a6ed67e979c59a29b7b4e8217e755b951cf4
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 30 Mar 2012 12:23:08 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 30 Mar 2012 15:43:33 +0200

proc: stats: Use arch_idle_time for idle and iowait times if available

Git commit a25cac5198d4ff28 "proc: Consider NO_HZ when printing idle and
iowait times" changes the code for /proc/stat to use get_cpu_idle_time_us
and get_cpu_iowait_time_us if the system is running with nohz enabled.
For architectures which define arch_idle_time (currently s390 only)
this is a change for the worse. The result of arch_idle_time is supposed
to be the exact sleep time of the target cpu and should be used instead
of the value kept by the scheduler.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120330122308.18720283@de.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/stat.c |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6a0c62d..64c3b31 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -18,19 +18,39 @@
 #ifndef arch_irq_stat
 #define arch_irq_stat() 0
 #endif
-#ifndef arch_idle_time
-#define arch_idle_time(cpu) 0
-#endif
+
+#ifdef arch_idle_time
+
+static cputime64_t get_idle_time(int cpu)
+{
+	cputime64_t idle;
+
+	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
+		idle += arch_idle_time(cpu);
+	return idle;
+}
+
+static cputime64_t get_iowait_time(int cpu)
+{
+	cputime64_t iowait;
+
+	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
+		iowait += arch_idle_time(cpu);
+	return iowait;
+}
+
+#else
 
 static u64 get_idle_time(int cpu)
 {
 	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
 
-	if (idle_time == -1ULL) {
+	if (idle_time == -1ULL)
 		/* !NO_HZ so we can rely on cpustat.idle */
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
-		idle += arch_idle_time(cpu);
-	} else
+	else
 		idle = usecs_to_cputime64(idle_time);
 
 	return idle;
@@ -49,6 +69,8 @@ static u64 get_iowait_time(int cpu)
 	return iowait;
 }
 
+#endif
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
