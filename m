Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2J1Xdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:33:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42189 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756996Ab2J1X2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:25 -0400
Message-Id: <20121028231548.468654149@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:13 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Hocko <mhocko@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 037/105] nohz: Fix idle ticks in cpu summary line of /proc/stat
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/proc/stat.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -24,11 +24,14 @@
 
 static cputime64_t get_idle_time(int cpu)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
+	u64 idle_time = -1ULL;
 	cputime64_t idle;
 
+	if (cpu_online(cpu))
+		idle_time = get_cpu_idle_time_us(cpu, NULL);
+
 	if (idle_time == -1ULL) {
-		/* !NO_HZ so we can rely on cpustat.idle */
+		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
 		idle = kstat_cpu(cpu).cpustat.idle;
 		idle = cputime64_add(idle, arch_idle_time(cpu));
 	} else
@@ -39,11 +42,14 @@ static cputime64_t get_idle_time(int cpu
 
 static cputime64_t get_iowait_time(int cpu)
 {
-	u64 iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+	u64 iowait_time = -1ULL;
 	cputime64_t iowait;
 
+	if (cpu_online(cpu))
+		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+
 	if (iowait_time == -1ULL)
-		/* !NO_HZ so we can rely on cpustat.iowait */
+		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
 		iowait = kstat_cpu(cpu).cpustat.iowait;
 	else
 		iowait = usecs_to_cputime64(iowait_time);


