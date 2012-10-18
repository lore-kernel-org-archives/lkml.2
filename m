Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2JRJKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:10:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:49477 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab2JRJJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:09:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="207567131"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org, rjw@sisk.pl
Cc: Rik van Riel <riel@redhat.com>,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH V2 1/4] x86,idle: Quickly notice prediction failure for repeat mode
Date: Thu, 18 Oct 2012 17:12:21 -0400
Message-Id: <1350594744-22353-2-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1350594744-22353-1-git-send-email-youquan.song@intel.com>
References: <1350594744-22353-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prediction for future is difficult and when the cpuidle governor prediction 
fails and govenor possibly choose the shallower C-state than it should. How to 
quickly notice and find the failure becomes important for power saving.    

cpuidle menu governor has a method to predict the repeat pattern if there are 8
C-states residency which are continuous and the same or very close, so it will
predict the next C-states residency will keep same residency time.

There is a real case that turbostat utility (tools/power/x86/turbostat) 
at kernel 3.3 or early. turbostat utility will read 10 registers one by one at
Sandybridge, so it will generate 10 IPIs to wake up idle CPUs. So cpuidle menu
 governor will predict it is repeat mode and there is another IPI wake up idle
 CPU soon, so it keeps idle CPU stay at C1 state even though CPU is totally 
idle. However, in the turbostat, following 10 registers reading is sleep 5 
seconds by default, so the idle CPU will keep at C1 for a long time though it is
 idle until break event occurs.
In a idle Sandybridge system, run "./turbostat -v", we will notice that deep 
C-state dangles between "70% ~ 99%". After patched the kernel, we will notice
deep C-state stays at >99.98%.

In the patch, a timer is added when menu governor detects a repeat mode and
choose a shallow C-state. The timer is set to a time out value that greater
than predicted time, and we conclude repeat mode prediction failure if timer is
triggered. When repeat mode happens as expected, the timer is not triggered
and CPU waken up from C-states and it will cancel the timer initiatively. 
When repeat mode does not happen, the timer will be time out and menu governor 
will quickly notice that the repeat mode prediction fails and then re-evaluates 
deeper C-states possibility.

Below is another case which will clearly show the patch much benefit:

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include <time.h>
#include <pthread.h>

volatile int * shutdown;
volatile long * count;
int delay = 20;
int loop = 8;

void usage(void)
{
	fprintf(stderr,
		"Usage: idle_predict [options]\n"
		"  --help	-h  Print this help\n"
		"  --thread	-n  Thread number\n"
		"  --loop     	-l  Loop times in shallow Cstate\n"
		"  --delay	-t  Sleep time (uS)in shallow Cstate\n");
}

void *simple_loop() {
	int idle_num = 1;
	while (!(*shutdown)) {
		*count = *count + 1;
	
		if (idle_num % loop)
			usleep(delay);
		else {
			/* sleep 1 second */
			usleep(1000000);
			idle_num = 0;
		}
		idle_num++;
	}

}

static void sighand(int sig)
{
	*shutdown = 1;
}

int main(int argc, char *argv[])
{
	sigset_t sigset;
	int signum = SIGALRM;
	int i, c, er = 0, thread_num = 8;
	pthread_t pt[1024];

	static char optstr[] = "n:l:t:h:";

	while ((c = getopt(argc, argv, optstr)) != EOF)
		switch (c) {
			case 'n':
				thread_num = atoi(optarg);
				break;
			case 'l':
				loop = atoi(optarg);
				break;
			case 't':
				delay = atoi(optarg);
				break;
			case 'h':
			default:
				usage();
				exit(1);
		}

	printf("thread=%d,loop=%d,delay=%d\n",thread_num,loop,delay);
	count = malloc(sizeof(long));
	shutdown = malloc(sizeof(int));
	*count = 0;
	*shutdown = 0;

	sigemptyset(&sigset);
	sigaddset(&sigset, signum);
	sigprocmask (SIG_BLOCK, &sigset, NULL);
	signal(SIGINT, sighand);
	signal(SIGTERM, sighand);

	for(i = 0; i < thread_num ; i++)
		pthread_create(&pt[i], NULL, simple_loop, NULL);

	for (i = 0; i < thread_num; i++)
		pthread_join(pt[i], NULL);

	exit(0);
}

Get powertop V2 from git://github.com/fenrus75/powertop, build powertop.
After build the above test application, then run it.
Test plaform can be Intel Sandybridge or other recent platforms.
#./idle_predict -l 10 &
#./powertop

We will find that deep C-state will dangle between 40%~100% and much time spent
on C1 state. It is because menu governor wrongly predict that repeat mode
is kept, so it will choose the C1 shallow C-state even though it has chance to
sleep 1 second in deep C-state.
 
While after patched the kernel, we find that deep C-state will keep >99.6%. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/cpuidle/governors/menu.c |   75 +++++++++++++++++++++++++++++++++++---
 include/linux/tick.h             |    6 +++
 kernel/time/tick-sched.c         |    4 ++
 3 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 5b1f2c3..37c0ff6 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -28,6 +28,13 @@
 #define MAX_INTERESTING 50000
 #define STDDEV_THRESH 400
 
+/* 60 * 60 > STDDEV_THRESH * INTERVALS = 400 * 8 */
+#define MAX_DEVIATION 60
+
+static DEFINE_PER_CPU(struct hrtimer, menu_hrtimer);
+static DEFINE_PER_CPU(int, hrtimer_status);
+/* menu hrtimer mode */
+enum {MENU_HRTIMER_STOP, MENU_HRTIMER_REPEAT};
 
 /*
  * Concepts and ideas behind the menu governor
@@ -191,17 +198,42 @@ static u64 div_round64(u64 dividend, u32 divisor)
 	return div_u64(dividend + (divisor / 2), divisor);
 }
 
+/* Cancel the hrtimer if it is not triggered yet */
+void menu_hrtimer_cancel(void)
+{
+	int cpu = smp_processor_id();
+	struct hrtimer *hrtmr = &per_cpu(menu_hrtimer, cpu);
+
+	/* The timer is still not time out*/
+	if (per_cpu(hrtimer_status, cpu)) {
+		hrtimer_cancel(hrtmr);
+		per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_STOP;
+	}
+}
+EXPORT_SYMBOL_GPL(menu_hrtimer_cancel);
+
+/* Call back for hrtimer is triggered */
+static enum hrtimer_restart menu_hrtimer_notify(struct hrtimer *hrtimer)
+{
+	int cpu = smp_processor_id();
+
+	per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_STOP;
+
+	return HRTIMER_NORESTART;
+}
+
 /*
  * Try detecting repeating patterns by keeping track of the last 8
  * intervals, and checking if the standard deviation of that set
  * of points is below a threshold. If it is... then use the
  * average of these 8 points as the estimated value.
  */
-static void detect_repeating_patterns(struct menu_device *data)
+static int detect_repeating_patterns(struct menu_device *data)
 {
 	int i;
 	uint64_t avg = 0;
 	uint64_t stddev = 0; /* contains the square of the std deviation */
+	int ret = 0;
 
 	/* first calculate average and standard deviation of the past */
 	for (i = 0; i < INTERVALS; i++)
@@ -210,7 +242,7 @@ static void detect_repeating_patterns(struct menu_device *data)
 
 	/* if the avg is beyond the known next tick, it's worthless */
 	if (avg > data->expected_us)
-		return;
+		return 0;
 
 	for (i = 0; i < INTERVALS; i++)
 		stddev += (data->intervals[i] - avg) *
@@ -223,8 +255,12 @@ static void detect_repeating_patterns(struct menu_device *data)
 	 * repeating pattern and predict we keep doing this.
 	 */
 
-	if (avg && stddev < STDDEV_THRESH)
+	if (avg && stddev < STDDEV_THRESH) {
 		data->predicted_us = avg;
+		ret = 1;
+	}
+
+	return ret;
 }
 
 /**
@@ -240,6 +276,9 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	int i;
 	int multiplier;
 	struct timespec t;
+	int repeat = 0, low_predicted = 0;
+	int cpu = smp_processor_id();
+	struct hrtimer *hrtmr = &per_cpu(menu_hrtimer, cpu);
 
 	if (data->needs_update) {
 		menu_update(drv, dev);
@@ -274,7 +313,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
-	detect_repeating_patterns(data);
+	repeat = detect_repeating_patterns(data);
 
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
@@ -295,8 +334,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 
 		if (s->disabled || su->disable)
 			continue;
-		if (s->target_residency > data->predicted_us)
+		if (s->target_residency > data->predicted_us) {
+			low_predicted = 1;
 			continue;
+		}
 		if (s->exit_latency > latency_req)
 			continue;
 		if (s->exit_latency * multiplier > data->predicted_us)
@@ -309,6 +350,27 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		}
 	}
 
+	/* not deepest C-state chosen for low predicted residency */
+	if (low_predicted) {
+		unsigned int timer_us = 0;
+
+		/*
+		 * Set a timer to detect whether this sleep is much
+		 * longer than repeat mode predicted.  If the timer
+		 * triggers, the code will evaluate whether to put
+		 * the CPU into a deeper C-state.
+		 * The timer is cancelled on CPU wakeup.
+		 */
+		timer_us = 2 * (data->predicted_us + MAX_DEVIATION);
+
+		if (repeat && (4 * timer_us < data->expected_us)) {
+			hrtimer_start(hrtmr, ns_to_ktime(1000 * timer_us),
+				HRTIMER_MODE_REL_PINNED);
+			/* In repeat case, menu hrtimer is started */
+			per_cpu(hrtimer_status, cpu) = MENU_HRTIMER_REPEAT;
+		}
+	}
+
 	return data->last_state_idx;
 }
 
@@ -399,6 +461,9 @@ static int menu_enable_device(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev)
 {
 	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
+	struct hrtimer *t = &per_cpu(menu_hrtimer, dev->cpu);
+	hrtimer_init(t, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	t->function = menu_hrtimer_notify;
 
 	memset(data, 0, sizeof(struct menu_device));
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index f37fceb..8867424 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -142,4 +142,10 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
+# ifdef CONFIG_CPU_IDLE_GOV_MENU
+extern void menu_hrtimer_cancel(void);
+# else
+static inline void menu_hrtimer_cancel(void) { return -1; }
+# endif /* CONFIG_CPU_IDLE_GOV_MENU */
+
 #endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3a9e5d5..dff6d13 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -525,6 +525,8 @@ void tick_nohz_irq_exit(void)
 	if (!ts->inidle)
 		return;
 
+	/* Cancel the timer because CPU already waken up from the C-states*/
+	menu_hrtimer_cancel();
 	__tick_nohz_idle_enter(ts);
 }
 
@@ -621,6 +623,8 @@ void tick_nohz_idle_exit(void)
 
 	ts->inidle = 0;
 
+	/* Cancel the timer because CPU already waken up from the C-states*/
+	menu_hrtimer_cancel();
 	if (ts->idle_active || ts->tick_stopped)
 		now = ktime_get();
 
-- 
1.7.7.4

