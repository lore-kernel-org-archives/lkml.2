Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2JZAGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:06:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:52675 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2JZAGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, deepthi@linux.vnet.ibm.com
Subject: [ 03/42] nohz: Fix idle ticks in cpu summary line of /proc/stat
Date: Thu, 25 Oct 2012 17:05:11 -0700
Message-Id: <20121026000125.142547174@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/stat.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -45,10 +45,13 @@ static cputime64_t get_iowait_time(int c
 
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


