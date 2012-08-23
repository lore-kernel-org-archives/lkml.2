Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2HWXO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:14:56 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50040 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab2HWXOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:14:48 -0400
Subject: [PATCH RFC 3/3] Modify the amount of stealtime that the kernel
 reports via the /proc interface.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com
Date: Thu, 23 Aug 2012 18:14:42 -0500
Message-ID: <20120823231442.11681.24650.stgit@lambeau>
In-Reply-To: <20120823231346.11681.1502.stgit@lambeau>
References: <20120823231346.11681.1502.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082323-8974-0000-0000-00000C841584
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stealtime will be adjusted based on the cpu entitlement setting.  The user
will supply the cpu_entitlement which is the percentage of cpu the guest can
expect to receive.  The expected steal time is based on the expected steal
percentage which is 100 - cpu_entitlement.  If steal_time is less than the
expected steal time that is reported steal_time is changed to 0 no other fields
are changed.  If the steal_time is greater than the expected_steal then the
difference is reported.  By default the cpu_entitlement will be 100% and the
steal time will be reported without any modification.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 fs/proc/stat.c              |   70 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/kernel_stat.h |    2 +
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index cf66665..efbaa03 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -73,6 +73,68 @@ static u64 get_iowait_time(int cpu)
 
 #endif
 
+/*
+ * This function will alter the steal time value that is written out
+ * to /proc/stat.  The cpu_entitlement is set by the user/admin and is
+ * meant to reflect the percentage of the processor that is expected to
+ * be used.  So as long as the amount of steal time is less than the
+ * expected steal time (based on cpu_entitlement) then report steal time
+ * as zero.
+ */
+static void kstat_adjust_steal_time(int currcpu)
+{
+	int j;
+	u64 cpustat_delta[NR_STATS];
+	u64 total_elapsed_time;
+	int expected_steal_pct;
+	u64 expected_steal;
+	u64 *currstat, *prevstat;
+
+	/*
+	 * if cpu_entitlement = 100% then the expected steal time is 0
+	 * so we don't need to do any adjustments to the fields.
+	 */
+	if (cpu_entitlement == 100) {
+		kcpustat_cpu(currcpu).cpustat[CPUTIME_ADJ_STEAL] =
+			kcpustat_cpu(currcpu).cpustat[CPUTIME_STEAL];
+		return;
+	}
+	/*
+	 * For the user it is more intuitive to think in terms of
+	 * cpu entitlement.  To do the calculations it is easier to
+	 * think in terms of allowed steal time.  So convert the percentage
+	 * from cpu_entitlement to expected_steal_percent.
+	 */
+	expected_steal_pct = 100 - cpu_entitlement;
+
+	total_elapsed_time = 0;
+	/* determine the total time elapsed between calls */
+	currstat = kcpustat_cpu(currcpu).cpustat;
+	prevstat = kcpustat_cpu(currcpu).prev_cpustat;
+	for (j = CPUTIME_USER; j < CPUTIME_GUEST; j++) {
+		cpustat_delta[j] = currstat[j] - prevstat[j];
+		prevstat[j] = currstat[j];
+		total_elapsed_time = total_elapsed_time + cpustat_delta[j];
+	}
+
+	/*
+	 * calculate the amount of expected steal time.  Add 5 as a
+	 * rounding factor.
+	 */
+
+	expected_steal = (total_elapsed_time * expected_steal_pct + 5) / 100;
+	if (cpustat_delta[CPUTIME_STEAL] < expected_steal)
+		cpustat_delta[CPUTIME_STEAL] = 0;
+	else
+		cpustat_delta[CPUTIME_STEAL] -= expected_steal;
+
+	/* Adjust the steal time accordingly */
+	currstat[CPUTIME_ADJ_STEAL] = prevstat[CPUTIME_ADJ_STEAL]
+					+ cpustat_delta[CPUTIME_STEAL];
+	prevstat[CPUTIME_ADJ_STEAL] = currstat[CPUTIME_ADJ_STEAL];
+}
+
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -90,7 +152,11 @@ static int show_stat(struct seq_file *p, void *v)
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
+
 	for_each_possible_cpu(i) {
+		/* adjust the steal time based on the processor entitlement */
+		kstat_adjust_steal_time(i);
+
 		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
 		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
 		system += kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
@@ -98,7 +164,7 @@ static int show_stat(struct seq_file *p, void *v)
 		iowait += get_iowait_time(i);
 		irq += kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
 		softirq += kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
+		steal += kcpustat_cpu(i).cpustat[CPUTIME_ADJ_STEAL];
 		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
 		sum += kstat_cpu_irqs_sum(i);
@@ -135,7 +201,7 @@ static int show_stat(struct seq_file *p, void *v)
 		iowait = get_iowait_time(i);
 		irq = kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
 		softirq = kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
+		steal = kcpustat_cpu(i).cpustat[CPUTIME_ADJ_STEAL];
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
 		seq_printf(p, "cpu%d", i);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index bbe5d15..a4f6d1c 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -27,11 +27,13 @@ enum cpu_usage_stat {
 	CPUTIME_STEAL,
 	CPUTIME_GUEST,
 	CPUTIME_GUEST_NICE,
+	CPUTIME_ADJ_STEAL,
 	NR_STATS,
 };
 
 struct kernel_cpustat {
 	u64 cpustat[NR_STATS];
+	u64 prev_cpustat[NR_STATS];
 };
 
 struct kernel_stat {

