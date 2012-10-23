Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2JWK5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:57:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45833 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2JWK5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:57:16 -0400
Date: Tue, 23 Oct 2012 12:57:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20121023105709.GA27126@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: fd0587339d80dd2fea5ead7f734676c9c618eace Documentation: Reflect the new location of the NMI watchdog info

Two small fixes.

 Thanks,

	Ingo

------------------>
Jean Delvare (1):
      Documentation: Reflect the new location of the NMI watchdog info

Michal Hocko (1):
      nohz: Fix idle ticks in cpu summary line of /proc/stat


 Documentation/00-INDEX |  4 ++--
 fs/proc/stat.c         | 14 ++++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 49c0513..fec55dc 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -210,6 +210,8 @@ local_ops.txt
 	- semantics and behavior of local atomic operations.
 lockdep-design.txt
 	- documentation on the runtime locking correctness validator.
+lockup-watchdogs.txt
+	- info on soft and hard lockup detectors (aka nmi_watchdog).
 logo.gif
 	- full colour GIF image of Linux logo (penguin - Tux).
 logo.txt
@@ -240,8 +242,6 @@ netlabel/
 	- directory with information on the NetLabel subsystem.
 networking/
 	- directory with info on various aspects of networking with Linux.
-nmi_watchdog.txt
-	- info on NMI watchdog for SMP systems.
 nommu-mmap.txt
 	- documentation about no-mmu memory mapping support.
 numastat.txt
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
