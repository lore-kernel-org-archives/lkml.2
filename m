Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1B1PBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:01:06 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59473 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1B1PBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:01:04 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] lockstat: export data in python expression
Date: Tue,  1 Mar 2011 00:00:23 +0900
Message-Id: <1298905223-1807-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4D67E286.8010907@dcl.info.waseda.ac.jp>
References: <4D67E286.8010907@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm writing the tool for parsing and arranging the data of /proc/lock_stat
in python. But I soon found that lock_stat is hard to parse, so I wrote
this patch to let lock_stat output its information in python expression.

This patch implements the ioctl() for lockstat. via this ioctl(), readers can
change the format of printing. If it is not called lockstat prints information
in traditional style. If it is called and specified cmd as 0 and arg as 1,
readers can get the information in python expression.

The big benefit of printing in pytohn expression is that it can be parsed by
eval() of python.

Sample of output:
{ 'version': 0.3,}	# header

{ 'name': 'pm_qos_lock', 'writer': [        3572153 ,       3573984,            0.11,          372.87,      3333033.22,        23292427 ,      31255420,            0.10,          291.25,     18881384.46, ], 'reader': None, 'contention': [[3573984, 0xffffffff8106e4ea, 'pm_qos_request+0x1a/0x70'], ], 'contending': [[3573984, 0xffffffff8106e4ea, 'pm_qos_request+0x1a/0x70'], ] }

{ 'name': 'xtime_lock', 'writer': [        1798546 ,       1798795,            0.27,           10.92,      4252980.74,         7116071 ,      14729524,            0.00,         1000.00,     30979660.87, ], 'reader': None, 'contention': [[1798795, 0xffffffff81077dec, 'tick_do_update_jiffies64+0x3c/0xd0'], ], 'contending': [[1798795, 0xffffffff81077dec, 'tick_do_update_jiffies64+0x3c/0xd0'], ] }

...

And,

f = open('/proc/lock_stat')
fcntl.ioctl(f.fileno(), 0, 1)	# specify format

header = eval(f.readline())	# the first line is header

for line in f.readlines():
    lock = eval(line)		# eval each line

this is the everything of parsing, really easy. I think exporting data in
eval()able style is efficient way in procfs and sysfs. How do you think?

BTW, this patch is too python centric. Exporting in more neutral style like
S-expression might be good.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep_proc.c |  213 ++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 185 insertions(+), 28 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 1969d2f..4474014 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -374,7 +374,14 @@ struct lock_stat_data {
 	struct lock_class_stats stats;
 };
 
+enum lock_stat_format {
+	lock_stat_format_normal = 0,
+	lock_stat_format_python,
+	lock_stat_format_max = lock_stat_format_python,
+};
+
 struct lock_stat_seq {
+	enum lock_stat_format format;
 	struct lock_stat_data *iter_end;
 	struct lock_stat_data stats[MAX_LOCKDEP_KEYS];
 };
@@ -417,14 +424,24 @@ static void snprint_time(char *buf, size_t bufsiz, s64 nr)
 static void seq_time(struct seq_file *m, s64 time)
 {
 	char num[15];
+	enum lock_stat_format f =
+		((struct lock_stat_seq *)m->private)->format;
 
 	snprint_time(num, sizeof(num), time);
 	seq_printf(m, " %14s", num);
+	if (f == lock_stat_format_python)
+		seq_printf(m, ", ");
 }
 
 static void seq_lock_time(struct seq_file *m, struct lock_time *lt)
 {
+	enum lock_stat_format f =
+		((struct lock_stat_seq *)m->private)->format;
+
 	seq_printf(m, "%14lu", lt->nr);
+	if (f == lock_stat_format_python)
+		seq_printf(m, ", ");
+
 	seq_time(m, lt->min);
 	seq_time(m, lt->max);
 	seq_time(m, lt->total);
@@ -436,6 +453,8 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 	struct lock_class *class;
 	struct lock_class_stats *stats;
 	int i, namelen;
+	enum lock_stat_format f =
+		((struct lock_stat_seq *)m->private)->format;
 
 	class = data->class;
 	stats = &data->stats;
@@ -465,80 +484,177 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 		namelen += 2;
 	}
 
+	if (f == lock_stat_format_python) {
+		seq_printf(m, "{ 'name': '%s', ", name);
+		seq_printf(m, "'writer': ");
+	}
+
 	if (stats->write_holdtime.nr) {
-		if (stats->read_holdtime.nr)
-			seq_printf(m, "%38s-W:", name);
-		else
-			seq_printf(m, "%40s:", name);
+		if (f == lock_stat_format_python)
+			seq_printf(m, "[ ");
+
+		if (f == lock_stat_format_normal) {
+			if (stats->read_holdtime.nr)
+				seq_printf(m, "%38s-W:", name);
+			else
+				seq_printf(m, "%40s:", name);
+		}
 
 		seq_printf(m, "%14lu ", stats->bounces[bounce_contended_write]);
+		if (f == lock_stat_format_python)
+			seq_printf(m, ",");
 		seq_lock_time(m, &stats->write_waittime);
+
 		seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_write]);
+		if (f == lock_stat_format_python)
+			seq_printf(m, ",");
 		seq_lock_time(m, &stats->write_holdtime);
-		seq_puts(m, "\n");
+		if (f == lock_stat_format_python)
+			seq_printf(m, "]");
+
+		if (f == lock_stat_format_normal)
+			seq_puts(m, "\n");
+	} else {
+		if (f == lock_stat_format_python)
+			seq_printf(m, "None");
 	}
 
+	if (f == lock_stat_format_python)
+		seq_printf(m, ", 'reader': ");
+
 	if (stats->read_holdtime.nr) {
-		seq_printf(m, "%38s-R:", name);
+		if (f == lock_stat_format_python)
+			seq_printf(m, "[ ");
+
+		if (f == lock_stat_format_normal)
+			seq_printf(m, "%38s-R:", name);
+
 		seq_printf(m, "%14lu ", stats->bounces[bounce_contended_read]);
+		if (f == lock_stat_format_python)
+			seq_printf(m, ",");
 		seq_lock_time(m, &stats->read_waittime);
+
 		seq_printf(m, " %14lu ", stats->bounces[bounce_acquired_read]);
+		if (f == lock_stat_format_python)
+			seq_printf(m, ",");
 		seq_lock_time(m, &stats->read_holdtime);
-		seq_puts(m, "\n");
+		if (f == lock_stat_format_python)
+			seq_printf(m, "]");
+
+		if (f == lock_stat_format_normal)
+			seq_puts(m, "\n");
+	} else {
+		if (f == lock_stat_format_python)
+			seq_printf(m, "None");
 	}
 
-	if (stats->read_waittime.nr + stats->write_waittime.nr == 0)
+	if (stats->read_waittime.nr + stats->write_waittime.nr == 0) {
+		if (f == lock_stat_format_python)
+			seq_printf(m, "}\n");
 		return;
+	}
 
 	if (stats->read_holdtime.nr)
 		namelen += 2;
 
+	if (f == lock_stat_format_python)
+		seq_printf(m, ", 'contention': [");
 	for (i = 0; i < LOCKSTAT_POINTS; i++) {
 		char ip[32];
 
 		if (class->contention_point[i] == 0)
 			break;
 
-		if (!i)
+		if (!i && f == lock_stat_format_normal)
 			seq_line(m, '-', 40-namelen, namelen);
 
-		snprintf(ip, sizeof(ip), "[<%p>]",
+		switch (f) {
+		case lock_stat_format_python:
+			seq_printf(m, "[%lu, 0x%p, '%pS'], ",
+				stats->contention_point[i],
+				(void *)class->contention_point[i],
 				(void *)class->contention_point[i]);
-		seq_printf(m, "%40s %14lu %29s %pS\n",
-			   name, stats->contention_point[i],
-			   ip, (void *)class->contention_point[i]);
+			break;
+		default:
+			snprintf(ip, sizeof(ip), "[<%p>]",
+				(void *)class->contention_point[i]);
+			seq_printf(m, "%40s %14lu %29s %pS\n",
+				name, stats->contention_point[i],
+				ip, (void *)class->contention_point[i]);
+		break;
+		}
 	}
+
+	if (f == lock_stat_format_python)
+		seq_printf(m, "], 'contending': [");
+
 	for (i = 0; i < LOCKSTAT_POINTS; i++) {
 		char ip[32];
 
 		if (class->contending_point[i] == 0)
 			break;
 
-		if (!i)
+		if (!i && f == lock_stat_format_normal)
 			seq_line(m, '-', 40-namelen, namelen);
 
-		snprintf(ip, sizeof(ip), "[<%p>]",
+		switch (f) {
+		case lock_stat_format_python:
+			seq_printf(m, "[%lu, 0x%p, '%pS'], ",
+				stats->contention_point[i],
+				(void *)class->contending_point[i],
+				(void *)class->contending_point[i]);
+		break;
+		default:
+			snprintf(ip, sizeof(ip), "[<%p>]",
 				(void *)class->contending_point[i]);
-		seq_printf(m, "%40s %14lu %29s %pS\n",
-			   name, stats->contending_point[i],
-			   ip, (void *)class->contending_point[i]);
+			seq_printf(m, "%40s %14lu %29s %pS\n",
+				name, stats->contending_point[i],
+				ip, (void *)class->contending_point[i]);
+		break;
+		}
 	}
 	if (i) {
-		seq_puts(m, "\n");
-		seq_line(m, '.', 0, 40 + 1 + 10 * (14 + 1));
-		seq_puts(m, "\n");
+		if (f == lock_stat_format_normal) {
+			seq_puts(m, "\n");
+			seq_line(m, '.', 0, 40 + 1 + 10 * (14 + 1));
+			seq_puts(m, "\n");
+		}
 	}
+	if (f == lock_stat_format_python)
+		seq_printf(m, "] }\n");
 }
 
 static void seq_header(struct seq_file *m)
 {
-	seq_printf(m, "lock_stat version 0.3\n");
+	enum lock_stat_format format =
+		((struct lock_stat_seq *)m->private)->format;
+
+	switch (format) {
+	case lock_stat_format_python:
+		seq_printf(m, "{ 'version': 0.3,");
+		break;
+	default:		/* normal */
+		seq_printf(m, "lock_stat version 0.3\n");
+		break;
+	}
+
+	if (unlikely(!debug_locks)) {
+		const char *warning = "*WARNING* lock debugging disabled!!"
+			" - possibly due to a lockdep warning\n";
 
-	if (unlikely(!debug_locks))
-		seq_printf(m, "*WARNING* lock debugging disabled!! - possibly due to a lockdep warning\n");
+		switch (format) {
+		case lock_stat_format_python:
+			seq_printf(m, "'warning': '%s',", warning);
+			break;
+		default:		/* normal */
+			seq_printf(m, "%s\n", warning);
+			break;
+		}
+	}
 
-	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
-	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
+	if (format == lock_stat_format_normal) {
+		seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
+		seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
 			"%14s %14s\n",
 			"class name",
 			"con-bounces",
@@ -551,8 +667,17 @@ static void seq_header(struct seq_file *m)
 			"holdtime-min",
 			"holdtime-max",
 			"holdtime-total");
-	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
-	seq_printf(m, "\n");
+		seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
+	}
+
+	switch (format) {
+	case lock_stat_format_python:
+		seq_printf(m, "}\n"); /* end of header dictionary */
+		break;
+	default:		/* normal */
+		seq_printf(m, "\n");
+		break;
+	}
 }
 
 static void *ls_start(struct seq_file *m, loff_t *pos)
@@ -606,6 +731,8 @@ static int lock_stat_open(struct inode *inode, struct file *file)
 	if (!data)
 		return -ENOMEM;
 
+	data->format = lock_stat_format_normal;
+
 	res = seq_open(file, &lockstat_ops);
 	if (!res) {
 		struct lock_stat_data *iter = data->stats;
@@ -656,12 +783,42 @@ static int lock_stat_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
+static long lock_stat_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	struct lock_stat_seq *data =
+		((struct seq_file *)file->private_data)->private;
+	enum lock_stat_format new_format;
+
+	/*
+	 * currently, this ioctl doesn't provide any definition for cmd,
+	 * because main user of this ioctl is python script.
+	 */
+
+	if (cmd == 0) {
+		new_format = arg;
+		if (new_format < 0 || lock_stat_format_max < new_format) {
+			printk(KERN_INFO "lock_stat_ioctl():"
+				" invalid format: %d\n", new_format);
+			return -EINVAL;
+		}
+
+		data->format = arg;
+	} else {
+		printk(KERN_ERR "lock_stat_ioctl(): invalid cmd, %u\n", cmd);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct file_operations proc_lock_stat_operations = {
 	.open		= lock_stat_open,
 	.write		= lock_stat_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= lock_stat_release,
+	.unlocked_ioctl	= lock_stat_ioctl,
 };
 #endif /* CONFIG_LOCK_STAT */
 
-- 
1.7.3.3

