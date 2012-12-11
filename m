Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2LKTvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:51:07 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58286 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754446Ab2LKTuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:50:07 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        johnstul@us.ibm.com, viro@zeniv.linux.org.uk, peterz@infradead.org,
        mingo@redhat.com, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH 4/4] Convert timer list to be a proper seq_file.
Date: Tue, 11 Dec 2012 13:50:05 -0600
Message-Id: <1355255405-32758-5-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1355255405-32758-4-git-send-email-nzimmer@sgi.com>
References: <1355255405-32758-1-git-send-email-nzimmer@sgi.com>
 <1355255405-32758-2-git-send-email-nzimmer@sgi.com>
 <1355255405-32758-3-git-send-email-nzimmer@sgi.com>
 <1355255405-32758-4-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert /proc/timer_list to a proper seq_file with its own iterator.  This is a
little more complex given that we have to make two passes with two seperate
headers.

CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 kernel/time/timer_list.c |   88 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index b3dc3d6..6a2cfc2 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -253,38 +253,102 @@ static int timer_list_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.7\n");
-	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
-	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
-	SEQ_printf(m, "\n");
-
-	for_each_online_cpu(cpu)
+	if (v == (void *)1) {
+		SEQ_printf(m, "Timer List Version: v0.7\n");
+		SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n",
+			   HRTIMER_MAX_CLOCK_BASES);
+		SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+		SEQ_printf(m, "\n");
+	} else if (v < (void *)(nr_cpu_ids + 2)) {
+		cpu = (unsigned long)(v - 2);
 		print_cpu(m, cpu, now);
-
+	}
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	timer_list_show_tickdevices_header(m);
-	for_each_online_cpu(cpu)
+	else if (v == (void *)nr_cpu_ids + 2) {
+		timer_list_show_tickdevices_header(m);
+	} else {
+		cpu = (unsigned long)(v - 3 - nr_cpu_ids);
 		print_tickdevice(m, tick_get_device(cpu), cpu);
+	}
 #endif
-
 	return 0;
 }
 
+
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	unsigned long n = *offset;
+
+	if (n == 0)
+		return (void *) 1;
+
+	if (n < nr_cpu_ids + 1) {
+		n--;
+		if (n > 0)
+			n = cpumask_next(n - 1, cpu_online_mask);
+		else
+			n = cpumask_first(cpu_online_mask);
+		*offset = n + 1;
+		return (void *)(unsigned long)(n + 2);
+	}
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	if (n == nr_cpu_ids + 1)
+		return (void *) (nr_cpu_ids + 2);
+
+	if (n < nr_cpu_ids * 2 + 2) {
+		n -= (nr_cpu_ids + 2);
+		if (n > 0)
+			n = cpumask_next(n - 1, cpu_online_mask);
+		else
+			n = cpumask_first(cpu_online_mask);
+		*offset = n + 2 + nr_cpu_ids;
+		return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
+	}
+#endif
+
+	return NULL;
+}
+
+static void *timer_list_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return timer_list_start(file, offset);
+}
+
+static void timer_list_stop(struct seq_file *file, void *data)
+{
+}
+
+static const struct seq_operations timer_list_sops = {
+	.start = timer_list_start,
+	.next = timer_list_next,
+	.stop = timer_list_stop,
+	.show = timer_list_show,
+};
+
 void sysrq_timer_list_show(void)
 {
 	timer_list_show(NULL, NULL);
 }
 
+static int timer_list_release(struct inode *inode, struct file *filep)
+{
+	seq_release(inode, filep);
+
+	return 0;
+}
+
 static int timer_list_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, timer_list_show, NULL);
+	return seq_open(filp, &timer_list_sops);
 }
 
 static const struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= timer_list_release,
 };
 
 static int __init init_timer_list_procfs(void)
-- 
1.6.0.2

