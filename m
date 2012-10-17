Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2JQCYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:24:19 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39820 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2JQCYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:24:15 -0400
Subject: [PATCH RFC V2 1/5] Alter the amount of steal time reported by the
 guest.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com,
        anthony@codemonkey.ws
Date: Tue, 16 Oct 2012 21:24:01 -0500
Message-ID: <20121017022400.16949.75591.stgit@lambeau>
In-Reply-To: <20121017022249.16949.2775.stgit@lambeau>
References: <20121017022249.16949.2775.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101702-9264-0000-0000-000002824168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the amount of stealtime that the kernel reports via the /proc interface.
Steal time will now be broken down into steal_time and consigned_time.
Consigned_time will represent the amount of time that is expected to be lost
due to overcommitment of the physical cpu or by using cpu capping.  The amount
consigned_time will be passed in using an ioctl.  The time will be expressed in
the number of nanoseconds to be lost in during the fixed period.  The fixed period
is currently 1/10th of a second.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 fs/proc/stat.c              |    9 +++++++--
 include/linux/kernel_stat.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index e296572..cb7fe80 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -82,7 +82,7 @@ static int show_stat(struct seq_file *p, void *v)
 	int i, j;
 	unsigned long jif;
 	u64 user, nice, system, idle, iowait, irq, softirq, steal;
-	u64 guest, guest_nice;
+	u64 guest, guest_nice, consign;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
@@ -90,10 +90,11 @@ static int show_stat(struct seq_file *p, void *v)
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = 0;
-	guest = guest_nice = 0;
+	guest = guest_nice = consign = 0;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
+
 	for_each_possible_cpu(i) {
 		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
 		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
@@ -105,6 +106,7 @@ static int show_stat(struct seq_file *p, void *v)
 		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		consign += kcpustat_cpu(i).cpustat[CPUTIME_CONSIGN];
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -128,6 +130,7 @@ static int show_stat(struct seq_file *p, void *v)
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(consign));
 	seq_putc(p, '\n');
 
 	for_each_online_cpu(i) {
@@ -142,6 +145,7 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		consign = kcpustat_cpu(i).cpustat[CPUTIME_CONSIGN];
 		seq_printf(p, "cpu%d", i);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
@@ -153,6 +157,7 @@ static int show_stat(struct seq_file *p, void *v)
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(consign));
 		seq_putc(p, '\n');
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 36d12f0..c0b0095 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -27,6 +27,7 @@ enum cpu_usage_stat {
 	CPUTIME_STEAL,
 	CPUTIME_GUEST,
 	CPUTIME_GUEST_NICE,
+	CPUTIME_CONSIGN,
 	NR_STATS,
 };
 

