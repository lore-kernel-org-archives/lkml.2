Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab2KZRLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:11:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635Ab2KZRLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        deepthi@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 179/270] nohz: Fix idle ticks in cpu summary line of /proc/stat
Date: Mon, 26 Nov 2012 14:57:49 -0200
Message-Id: <1353949160-26803-180-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit 7386cdbf2f57ea8cff3c9fde93f206e58b9fe13f upstream.

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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/proc/stat.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

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
-- 
1.7.9.5

