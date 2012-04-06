Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab2DFXcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:32:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:40546 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2DFXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:32:07 -0400
Date: Sat, 7 Apr 2012 01:32:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer updates for 3.4-rc
Message-ID: <alpine.LFD.2.02.1204070131010.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

Thanks,

	tglx

------------------>
Martin Schwidefsky (1):
      proc: stats: Use arch_idle_time for idle and iowait times if available

Sasikantha babu (1):
      itimer: Schedule silent NULL pointer fixup in setitimer() for removal

Thomas Gleixner (1):
      tick: Document TICK_ONESHOT config option


 Documentation/feature-removal-schedule.txt |    8 ++++++
 fs/proc/stat.c                             |   34 +++++++++++++++++++++++-----
 kernel/itimer.c                            |    5 +++-
 kernel/time/Kconfig                        |    4 +++
 4 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0cad480..32fae81 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -529,3 +529,11 @@ When:	3.5
 Why:	The old kmap_atomic() with two arguments is deprecated, we only
 	keep it for backward compatibility for few cycles and then drop it.
 Who:	Cong Wang <amwang@redhat.com>
+
+----------------------------
+
+What:	setitimer accepts user NULL pointer (value)
+When:	3.6
+Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
+	violates the spec.
+Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
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
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 22000c3..c70369a 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -284,8 +284,11 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
 	if (value) {
 		if(copy_from_user(&set_buffer, value, sizeof(set_buffer)))
 			return -EFAULT;
-	} else
+	} else {
 		memset((char *) &set_buffer, 0, sizeof(set_buffer));
+		WARN_ONCE(1, "setitimer: new_value pointer is NULL."
+			  " Misfeature support will be removed\n");
+	}
 
 	error = do_setitimer(which, &set_buffer, ovalue ? &get_buffer : NULL);
 	if (error || !ovalue)
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 2cf9cc7..a20dc8a 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -1,6 +1,10 @@
 #
 # Timer subsystem related configuration options
 #
+
+# Core internal switch. Selected by NO_HZ / HIGH_RES_TIMERS. This is
+# only related to the tick functionality. Oneshot clockevent devices
+# are supported independ of this.
 config TICK_ONESHOT
 	bool
 
