Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab0FBVWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:22:12 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45286 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932958Ab0FBVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:35 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/11] x86, UV: BAU tunables into a debugfs file
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNx-0004Zx-Uo@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:01 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make the Broadcast Assist Unit driver's nine tuning values variable
by making them accessible through a read/write debugfs file.

The file will normally be mounted as /sys/kernel/debug/sgi_uv/bau_tunables.
The tunables are kept in each cpu's per-cpu BAU structure.

The patch also does a little name improvement, and corrects the reset of
two destination timeout counters.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |   53 +++++--
 arch/x86/kernel/tlb_uv.c         |  281 +++++++++++++++++++++++++++++++++------
 2 files changed, 278 insertions(+), 56 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -8,6 +8,7 @@
  */
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
+#include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
@@ -42,12 +43,22 @@ static int timeout_base_ns[] = {
 		167772160
 };
 static int timeout_us;
+static int nobau;
 
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD	0x000000000bUL
-
-static int uv_bau_max_concurrent __read_mostly;
+/* tunables: */
+static int max_bau_concurrent = MAX_BAU_CONCURRENT;
+static int max_bau_concurrent_constant = MAX_BAU_CONCURRENT;
+static int plugged_delay = PLUGGED_DELAY;
+static int plugsb4reset = PLUGSB4RESET;
+static int timeoutsb4reset = TIMEOUTSB4RESET;
+static int ipi_reset_limit = IPI_RESET_LIMIT;
+static int complete_threshold = COMPLETE_THRESHOLD;
+static int congested_response_us = CONGESTED_RESPONSE_US;
+static int congested_reps = CONGESTED_REPS;
+static int congested_period = CONGESTED_PERIOD;
+static struct dentry *tunables_dir;
+static struct dentry *tunables_file;
 
-static int nobau;
 static int __init setup_nobau(char *arg)
 {
 	nobau = 1;
@@ -539,23 +550,24 @@ const struct cpumask *uv_flush_send_and_
 	unsigned long index;
 	cycles_t time1;
 	cycles_t time2;
+	cycles_t elapsed;
 	struct ptc_stats *stat = &per_cpu(ptcstats, bcp->cpu);
 	struct bau_control *smaster = bcp->socket_master;
 	struct bau_control *hmaster = bcp->uvhub_master;
 
 	/*
-	 * Spin here while there are hmaster->max_concurrent or more active
+	 * Spin here while there are hmaster->max_bau_concurrent or more active
 	 * descriptors. This is the per-uvhub 'throttle'.
 	 */
 	if (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
 			&hmaster->active_descriptor_count,
-			hmaster->max_concurrent)) {
+			hmaster->max_bau_concurrent)) {
 		stat->s_throttles++;
 		do {
 			cpu_relax();
 		} while (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
 			&hmaster->active_descriptor_count,
-			hmaster->max_concurrent));
+			hmaster->max_bau_concurrent));
 	}
 
 	while (hmaster->uvhub_quiesce)
@@ -609,9 +621,9 @@ const struct cpumask *uv_flush_send_and_
 			 * that case hardware immediately returns the ERROR
 			 * that looks like a destination timeout.
 			 */
-			udelay(TIMEOUT_DELAY);
+			udelay(bcp->plugged_delay);
 			bcp->plugged_tries++;
-			if (bcp->plugged_tries >= PLUGSB4RESET) {
+			if (bcp->plugged_tries >= bcp->plugsb4reset) {
 				bcp->plugged_tries = 0;
 				quiesce_local_uvhub(hmaster);
 				spin_lock(&hmaster->queue_lock);
@@ -623,10 +635,10 @@ const struct cpumask *uv_flush_send_and_
 				stat->s_resets_plug++;
 			}
 		} else if (completion_status == FLUSH_RETRY_TIMEOUT) {
-			hmaster->max_concurrent = 1;
+			hmaster->max_bau_concurrent = 1;
 			bcp->timeout_tries++;
 			udelay(TIMEOUT_DELAY);
-			if (bcp->timeout_tries >= TIMEOUTSB4RESET) {
+			if (bcp->timeout_tries >= bcp->timeoutsb4reset) {
 				bcp->timeout_tries = 0;
 				quiesce_local_uvhub(hmaster);
 				spin_lock(&hmaster->queue_lock);
@@ -638,7 +650,7 @@ const struct cpumask *uv_flush_send_and_
 				stat->s_resets_timeout++;
 			}
 		}
-		if (bcp->ipi_attempts >= 3) {
+		if (bcp->ipi_attempts >= bcp->ipi_reset_limit) {
 			bcp->ipi_attempts = 0;
 			completion_status = FLUSH_GIVEUP;
 			break;
@@ -648,9 +660,14 @@ const struct cpumask *uv_flush_send_and_
 		 (completion_status == FLUSH_RETRY_TIMEOUT));
 	time2 = get_cycles();
 
-	if ((completion_status == FLUSH_COMPLETE) && (bcp->conseccompletes > 5)
-	    && (hmaster->max_concurrent < hmaster->max_concurrent_constant))
-			hmaster->max_concurrent++;
+	bcp->plugged_tries = 0;
+	bcp->timeout_tries = 0;
+
+	if ((completion_status == FLUSH_COMPLETE) &&
+	    (bcp->conseccompletes > bcp->complete_threshold) &&
+	    (hmaster->max_bau_concurrent <
+					hmaster->max_bau_concurrent_constant))
+			hmaster->max_bau_concurrent++;
 
 	/*
 	 * hold any cpu not timing out here; no other cpu currently held by
@@ -661,9 +678,10 @@ const struct cpumask *uv_flush_send_and_
 	atomic_dec(&hmaster->active_descriptor_count);
 
 	/* guard against cycles wrap */
-	if (time2 > time1)
-		stat->s_time += (time2 - time1);
-	else
+	if (time2 > time1) {
+		elapsed = time2 - time1;
+		stat->s_time += elapsed;
+	} else
 		stat->s_requestor--; /* don't count this one */
 	if (completion_status == FLUSH_COMPLETE && try > 1)
 		stat->s_retriesok++;
@@ -730,10 +748,12 @@ const struct cpumask *uv_flush_tlb_other
 	struct ptc_stats *stat;
 	struct bau_control *bcp;
 
+	/* kernel was booted 'nobau' */
 	if (nobau)
 		return cpumask;
 
 	bcp = &per_cpu(bau_control, cpu);
+
 	/*
 	 * Each sending cpu has a per-cpu mask which it fills from the caller's
 	 * cpu mask.  Only remote cpus are converted to uvhubs and copied.
@@ -970,6 +990,7 @@ static int uv_ptc_seq_show(struct seq_fi
 			   stat->s_resets_plug, stat->s_resets_timeout,
 			   stat->s_giveup, stat->s_stimeout,
 			   stat->s_busy, stat->s_throttles);
+
 		/* destination side statistics */
 		seq_printf(file,
 			   "%lx %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld\n",
@@ -986,9 +1007,28 @@ static int uv_ptc_seq_show(struct seq_fi
 }
 
 /*
+ * Display the tunables thru debugfs
+ */
+static ssize_t tunables_read(struct file *file, char __user *userbuf,
+						size_t count, loff_t *ppos)
+{
+	char buf[300];
+	int ret;
+
+	ret = snprintf(buf, 300, "%s %s %s\n%d %d %d %d %d %d %d %d %d\n",
+		"max_bau_concurrent plugged_delay plugsb4reset",
+		"timeoutsb4reset ipi_reset_limit complete_threshold",
+		"congested_response_us congested_reps congested_period",
+		max_bau_concurrent, plugged_delay, plugsb4reset,
+		timeoutsb4reset, ipi_reset_limit, complete_threshold,
+		congested_response_us, congested_reps, congested_period);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, ret);
+}
+
+/*
  * -1: resetf the statistics
  *  0: display meaning of the statistics
- * >0: maximum concurrent active descriptors per uvhub (throttle)
  */
 static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
 				 size_t count, loff_t *data)
@@ -997,7 +1037,6 @@ static ssize_t uv_ptc_proc_write(struct 
 	long input_arg;
 	char optstr[64];
 	struct ptc_stats *stat;
-	struct bau_control *bcp;
 
 	if (count == 0 || count > sizeof(optstr))
 		return -EINVAL;
@@ -1078,24 +1117,149 @@ static ssize_t uv_ptc_proc_write(struct 
 			stat = &per_cpu(ptcstats, cpu);
 			memset(stat, 0, sizeof(struct ptc_stats));
 		}
-	} else {
-		uv_bau_max_concurrent = input_arg;
-		bcp = &per_cpu(bau_control, smp_processor_id());
-		if (uv_bau_max_concurrent < 1 ||
-		    uv_bau_max_concurrent > bcp->cpus_in_uvhub) {
-			printk(KERN_DEBUG
-				"Error: BAU max concurrent %d; %d is invalid\n",
-				bcp->max_concurrent, uv_bau_max_concurrent);
-			return -EINVAL;
-		}
-		printk(KERN_DEBUG "Set BAU max concurrent:%d\n",
-		       uv_bau_max_concurrent);
-		for_each_present_cpu(cpu) {
-			bcp = &per_cpu(bau_control, cpu);
-			bcp->max_concurrent = uv_bau_max_concurrent;
+	}
+
+	return count;
+}
+
+static int local_atoi(const char *name)
+{
+	int val = 0;
+
+	for (;; name++) {
+		switch (*name) {
+		case '0' ... '9':
+			val = 10*val+(*name-'0');
+			break;
+		default:
+			return val;
 		}
 	}
+}
+
+/*
+ * set the tunables
+ * 0 values reset them to defaults
+ */
+static ssize_t tunables_write(struct file *file, const char __user *user,
+				 size_t count, loff_t *data)
+{
+	int cpu;
+	int cnt = 0;
+	int val;
+	char *p;
+	char *q;
+	char instr[64];
+	struct bau_control *bcp;
 
+	if (count == 0 || count > sizeof(instr)-1)
+		return -EINVAL;
+	if (copy_from_user(instr, user, count))
+		return -EFAULT;
+
+	instr[count] = '\0';
+	/* count the fields */
+	p = instr + strspn(instr, WHITESPACE);
+	q = p;
+	for (; *p; p = q + strspn(q, WHITESPACE)) {
+		q = p + strcspn(p, WHITESPACE);
+		cnt++;
+		if (q == p)
+			break;
+	}
+	if (cnt != 9) {
+		printk(KERN_INFO "bau tunable error: should be 9 numbers\n");
+		return -EINVAL;
+	}
+
+	p = instr + strspn(instr, WHITESPACE);
+	q = p;
+	for (cnt = 0; *p; p = q + strspn(q, WHITESPACE), cnt++) {
+		q = p + strcspn(p, WHITESPACE);
+		val = local_atoi(p);
+		switch (cnt) {
+		case 0:
+			if (val == 0) {
+				max_bau_concurrent = MAX_BAU_CONCURRENT;
+				max_bau_concurrent_constant =
+							MAX_BAU_CONCURRENT;
+				continue;
+			}
+			bcp = &per_cpu(bau_control, smp_processor_id());
+			if (val < 1 || val > bcp->cpus_in_uvhub) {
+				printk(KERN_DEBUG
+				"Error: BAU max concurrent %d is invalid\n",
+				val);
+				return -EINVAL;
+			}
+			max_bau_concurrent = val;
+			max_bau_concurrent_constant = val;
+			continue;
+		case 1:
+			if (val == 0)
+				plugged_delay = PLUGGED_DELAY;
+			else
+				plugged_delay = val;
+			continue;
+		case 2:
+			if (val == 0)
+				plugsb4reset = PLUGSB4RESET;
+			else
+				plugsb4reset = val;
+			continue;
+		case 3:
+			if (val == 0)
+				timeoutsb4reset = TIMEOUTSB4RESET;
+			else
+				timeoutsb4reset = val;
+			continue;
+		case 4:
+			if (val == 0)
+				ipi_reset_limit = IPI_RESET_LIMIT;
+			else
+				ipi_reset_limit = val;
+			continue;
+		case 5:
+			if (val == 0)
+				complete_threshold = COMPLETE_THRESHOLD;
+			else
+				complete_threshold = val;
+			continue;
+		case 6:
+			if (val == 0)
+				congested_response_us = CONGESTED_RESPONSE_US;
+			else
+				congested_response_us = val;
+			continue;
+		case 7:
+			if (val == 0)
+				congested_reps = CONGESTED_REPS;
+			else
+				congested_reps = val;
+			continue;
+		case 8:
+			if (val == 0)
+				congested_period = CONGESTED_PERIOD;
+			else
+				congested_period = val;
+			continue;
+		}
+		if (q == p)
+			break;
+	}
+	for_each_present_cpu(cpu) {
+		bcp = &per_cpu(bau_control, cpu);
+		bcp->max_bau_concurrent = max_bau_concurrent;
+		bcp->max_bau_concurrent_constant = max_bau_concurrent;
+		bcp->plugged_delay = plugged_delay;
+		bcp->plugsb4reset = plugsb4reset;
+		bcp->timeoutsb4reset = timeoutsb4reset;
+		bcp->ipi_reset_limit = ipi_reset_limit;
+		bcp->complete_threshold = complete_threshold;
+		bcp->congested_response_us = congested_response_us;
+		bcp->congested_reps = congested_reps;
+		bcp->congested_period = congested_period;
+	}
 	return count;
 }
 
@@ -1111,6 +1275,11 @@ static int uv_ptc_proc_open(struct inode
 	return seq_open(file, &uv_ptc_seq_ops);
 }
 
+static int tunables_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
 static const struct file_operations proc_uv_ptc_operations = {
 	.open		= uv_ptc_proc_open,
 	.read		= seq_read,
@@ -1119,6 +1288,12 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
+static const struct file_operations tunables_fops = {
+	.open		= tunables_open,
+	.read		= tunables_read,
+	.write		= tunables_write,
+};
+
 static int __init uv_ptc_init(void)
 {
 	struct proc_dir_entry *proc_uv_ptc;
@@ -1133,6 +1308,20 @@ static int __init uv_ptc_init(void)
 		       UV_PTC_BASENAME);
 		return -EINVAL;
 	}
+
+	tunables_dir = debugfs_create_dir(UV_BAU_TUNABLES_DIR, NULL);
+	if (!tunables_dir) {
+		printk(KERN_ERR "unable to create debugfs directory %s\n",
+		       UV_BAU_TUNABLES_DIR);
+		return -EINVAL;
+	}
+	tunables_file = debugfs_create_file(UV_BAU_TUNABLES_FILE, 0600,
+			tunables_dir, NULL, &tunables_fops);
+	if (!tunables_file) {
+		printk(KERN_ERR "unable to create debugfs file %s\n",
+		       UV_BAU_TUNABLES_FILE);
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1336,15 +1525,12 @@ static void uv_init_per_cpu(int nuvhubs)
 		bcp = &per_cpu(bau_control, cpu);
 		memset(bcp, 0, sizeof(struct bau_control));
 		spin_lock_init(&bcp->masks_lock);
-		bcp->max_concurrent = uv_bau_max_concurrent;
 		pnode = uv_cpu_hub_info(cpu)->pnode;
 		uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
 		bdp = &uvhub_descs[uvhub];
 		bdp->num_cpus++;
 		bdp->uvhub = uvhub;
 		bdp->pnode = pnode;
-		/* time interval to catch a hardware stay-busy bug */
-		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
 		/* kludge: assume uv_hub.h is constant */
 		socket = (cpu_physical_id(cpu)>>5)&1;
 		if (socket >= bdp->num_sockets)
@@ -1380,6 +1566,21 @@ static void uv_init_per_cpu(int nuvhubs)
 		}
 	}
 	kfree(uvhub_descs);
+	for_each_present_cpu(cpu) {
+		bcp = &per_cpu(bau_control, cpu);
+		/* time interval to catch a hardware stay-busy bug */
+		bcp->timeout_interval = microsec_2_cycles(2*timeout_us);
+		bcp->max_bau_concurrent = max_bau_concurrent;
+		bcp->max_bau_concurrent_constant = max_bau_concurrent;
+		bcp->plugged_delay = plugged_delay;
+		bcp->plugsb4reset = plugsb4reset;
+		bcp->timeoutsb4reset = timeoutsb4reset;
+		bcp->ipi_reset_limit = ipi_reset_limit;
+		bcp->complete_threshold = complete_threshold;
+		bcp->congested_response_us = congested_response_us;
+		bcp->congested_reps = congested_reps;
+		bcp->congested_period = congested_period;
+	}
 }
 
 /*
@@ -1404,7 +1605,7 @@ static int __init uv_bau_init(void)
 		zalloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
 				       GFP_KERNEL, cpu_to_node(cur_cpu));
 
-	uv_bau_max_concurrent = MAX_BAU_CONCURRENT;
+	max_bau_concurrent = MAX_BAU_CONCURRENT;
 	uv_nshift = uv_hub_info->m_val;
 	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nuvhubs = uv_num_possible_blades();
@@ -1437,4 +1638,4 @@ static int __init uv_bau_init(void)
 	return 0;
 }
 core_initcall(uv_bau_init);
-core_initcall(uv_ptc_init);
+fs_initcall(uv_ptc_init);
Index: 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100531.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -45,10 +45,14 @@
 #define UV_DESC_BASE_PNODE_SHIFT	49
 #define UV_PAYLOADQ_PNODE_SHIFT		49
 #define UV_PTC_BASENAME			"sgi_uv/ptc_statistics"
+#define UV_BAU_BASENAME			"sgi_uv/bau_tunables"
+#define UV_BAU_TUNABLES_DIR		"sgi_uv"
+#define UV_BAU_TUNABLES_FILE		"bau_tunables"
+#define WHITESPACE			" \t\n"
 #define uv_physnodeaddr(x)		((__pa((unsigned long)(x)) & uv_mmask))
 #define UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT 15
 #define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT 16
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x000000000bUL
+#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x0000000009UL
 /* [19:16] SOFT_ACK timeout period  19: 1 is urgency 7  17:16 1 is multiplier */
 #define BAU_MISC_CONTROL_MULT_MASK 3
 
@@ -70,25 +74,23 @@
 #define DESC_STATUS_DESTINATION_TIMEOUT	2
 #define DESC_STATUS_SOURCE_TIMEOUT	3
 
+#define TIMEOUT_DELAY			10
 /*
- * source side threshholds at which message retries print a warning
- */
-#define SOURCE_TIMEOUT_LIMIT		20
-#define DESTINATION_TIMEOUT_LIMIT	20
-
-/*
- * misc. delays, in microseconds
+ * delay for 'plugged' timeout retries, in microseconds
  */
-#define THROTTLE_DELAY			10
-#define TIMEOUT_DELAY			10
-#define BIOS_TO				1000
-/* BIOS is assumed to set the destination timeout to 1003520 nanoseconds */
+#define PLUGGED_DELAY			10
 
 /*
  * threshholds at which to use IPI to free resources
  */
+/* after this # consecutive 'plugged' timeouts, use IPI to release resources */
 #define PLUGSB4RESET 100
-#define TIMEOUTSB4RESET 100
+/* after this many consecutive timeouts, use IPI to release resources */
+#define TIMEOUTSB4RESET 1
+/* at this number uses of IPI to release resources, giveup the request */
+#define IPI_RESET_LIMIT 1
+/* after this # consecutive successes, bump up the throttle if it was lowered */
+#define COMPLETE_THRESHOLD 5
 
 /*
  * number of entries in the destination side payload queue
@@ -108,6 +110,13 @@
 #define FLUSH_COMPLETE			4
 
 /*
+ * tuning the action when the numalink network is extremely delayed
+ */
+#define CONGESTED_RESPONSE_US 1000 /* 'long' response time, in microseconds */
+#define CONGESTED_REPS 10 /* long delays averaged over this many broadcasts */
+#define CONGESTED_PERIOD 30 /* time for the bau to be disabled, in seconds */
+
+/*
  * Distribution: 32 bytes (256 bits) (bytes 0-0x1f of descriptor)
  * If the 'multilevel' flag in the header portion of the descriptor
  * has been set to 0, then endpoint multi-unicast mode is selected.
@@ -323,14 +332,13 @@ struct bau_control {
 	struct bau_control *uvhub_master;
 	struct bau_control *socket_master;
 	unsigned long timeout_interval;
+	unsigned long set_bau_on_time;
 	atomic_t active_descriptor_count;
-	int max_concurrent;
-	int max_concurrent_constant;
-	int retry_message_scans;
 	int plugged_tries;
 	int timeout_tries;
 	int ipi_attempts;
 	int conseccompletes;
+	int set_bau_off;
 	short cpu;
 	short uvhub_cpu;
 	short uvhub;
@@ -343,6 +351,19 @@ struct bau_control {
 	spinlock_t masks_lock;
 	spinlock_t uvhub_lock;
 	spinlock_t queue_lock;
+	/* tunables */
+	int max_bau_concurrent;
+	int max_bau_concurrent_constant;
+	int plugged_delay;
+	int plugsb4reset;
+	int timeoutsb4reset;
+	int ipi_reset_limit;
+	int complete_threshold;
+	int congested_response_us;
+	int congested_reps;
+	int congested_period;
+	cycles_t period_time;
+	long period_requests;
 };
 
 /*
