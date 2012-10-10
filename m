Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2JJMO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:14:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2JJMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:14:27 -0400
Date: Wed, 10 Oct 2012 05:14:02 -0700
From: tip-bot for Michal Hocko <mhocko@suse.cz>
Message-ID: <tip-7386cdbf2f57ea8cff3c9fde93f206e58b9fe13f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        schwidefsky@de.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        tglx@linutronix.de, mhocko@suse.cz
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, mhocko@suse.cz
In-Reply-To: <20121010061820.8999.57245.stgit@srivatsabhat.in.ibm.com>
References: <20121010061820.8999.57245.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] nohz: Fix idle ticks in cpu summary line of /
 proc/stat
Git-Commit-ID: 7386cdbf2f57ea8cff3c9fde93f206e58b9fe13f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 10 Oct 2012 05:14:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7386cdbf2f57ea8cff3c9fde93f206e58b9fe13f
Gitweb:     http://git.kernel.org/tip/7386cdbf2f57ea8cff3c9fde93f206e58b9fe13f
Author:     Michal Hocko <mhocko@suse.cz>
AuthorDate: Wed, 10 Oct 2012 11:51:09 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 10 Oct 2012 14:05:21 +0200

nohz: Fix idle ticks in cpu summary line of /proc/stat

Git commit 09a1d34f8535ecf9 "nohz: Make idle/iowait counter update
conditional" introduced a bug in regard to cpu hotplug. The effect is
that the number of idle ticks in the cpu summary line in /proc/stat is
still counting ticks for offline cpus.

Reproduction is easy, just start a workload that keeps all cpus busy,
switch off one or more cpus and then watch the idle field in top.
On a dual-core with one cpu 100% busy and one offline cpu you will get
something like this:

%Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,
%0.0 st

The problem is that an offline cpu still has ts->idle_active == 1.
To fix this we should make sure that the cpu is online when calling
get_cpu_idle_time_us and get_cpu_iowait_time_us.

[Srivatsa: Rebased to current mainline]

Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20121010061820.8999.57245.stgit@srivatsabhat.in.ibm.com
Cc: deepthi@linux.vnet.ibm.com
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/proc/stat.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 64c3b31..e296572 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -45,10 +45,13 @@ static cputime64_t get_iowait_time(int cpu)
 
 static u64 get_idle_time(int cpu)
 {
-	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
+	u64 idle, idle_time = -1ULL;
+
+	if (cpu_online(cpu))
+		idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL)
-		/* !NO_HZ so we can rely on cpustat.idle */
+		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
 	else
 		idle = usecs_to_cputime64(idle_time);
@@ -58,10 +61,13 @@ static u64 get_idle_time(int cpu)
 
 static u64 get_iowait_time(int cpu)
 {
-	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+	u64 iowait, iowait_time = -1ULL;
+
+	if (cpu_online(cpu))
+		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
 
 	if (iowait_time == -1ULL)
-		/* !NO_HZ so we can rely on cpustat.iowait */
+		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
 		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	else
 		iowait = usecs_to_cputime64(iowait_time);
