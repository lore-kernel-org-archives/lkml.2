Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2AaIQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:16:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43170 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2AaIQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:16:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 31 Jan 2012 17:14:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] speed up /proc/pid/stat, statm
Message-Id: <20120131171443.567b53ad.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is based onto linux-mm
procfs-add-num_to_str-to-speed-up-proc-stat.patch +
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch

This patch is for /proc/pid/stat and you can see the effect with realisitc applications.


>From 5b9be0e1e8757af0c91cff3b6258d6663a6f9224 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 31 Jan 2012 13:31:20 +0900
Subject: [PATCH] speedup /proc/<pid>/stat, statm

Process accounting applications as top, ps visit some files under
/proc/<pid>. With seq_put_decimal_ull(), we can optimize /proc/<pid>/stat
and /proc/<pid>/statm files.

This patch adds
  - seq_put_decimal_ll() for signed values.
  - allow delimiter == 0.
  - convert seq_printf() to seq_put_decimal_ull/ll in /proc/stat, statm.

Test result on a system with 2000+ procs.

Before patch:
[kamezawa@bluextal test]$ top -b -n 1 | wc -l
2223
[kamezawa@bluextal test]$ time top -b -n 1 > /dev/null

real    0m0.675s
user    0m0.044s
sys     0m0.121s

[kamezawa@bluextal test]$ time ps -elf > /dev/null

real    0m0.236s
user    0m0.056s
sys     0m0.176s

After patch:
kamezawa@bluextal ~]$ time top -b -n 1 > /dev/null

real    0m0.657s
user    0m0.052s
sys     0m0.100s

[kamezawa@bluextal ~]$ time ps -elf > /dev/null

real    0m0.198s
user    0m0.050s
sys     0m0.145s

Considering top, ps tend to scan /proc periodically, this will
reduce cpu consumption by top/ps to some extent.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/array.c          |  119 +++++++++++++++++++++++++---------------------
 fs/seq_file.c            |   21 ++++++++-
 include/linux/seq_file.h |    2 +
 3 files changed, 86 insertions(+), 56 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c602b8d..80e6f4e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -462,59 +462,56 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
-%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
-		pid_nr_ns(pid, ns),
-		tcomm,
-		state,
-		ppid,
-		pgid,
-		sid,
-		tty_nr,
-		tty_pgrp,
-		task->flags,
-		min_flt,
-		cmin_flt,
-		maj_flt,
-		cmaj_flt,
-		cputime_to_clock_t(utime),
-		cputime_to_clock_t(stime),
-		cputime_to_clock_t(cutime),
-		cputime_to_clock_t(cstime),
-		priority,
-		nice,
-		num_threads,
-		start_time,
-		vsize,
-		mm ? get_mm_rss(mm) : 0,
-		rsslim,
-		mm ? (permitted ? mm->start_code : 1) : 0,
-		mm ? (permitted ? mm->end_code : 1) : 0,
-		(permitted && mm) ? mm->start_stack : 0,
-		esp,
-		eip,
-		/* The signal information here is obsolete.
-		 * It must be decimal for Linux 2.0 compatibility.
-		 * Use /proc/#/status for real-time signals.
-		 */
-		task->pending.signal.sig[0] & 0x7fffffffUL,
-		task->blocked.sig[0] & 0x7fffffffUL,
-		sigign      .sig[0] & 0x7fffffffUL,
-		sigcatch    .sig[0] & 0x7fffffffUL,
-		wchan,
-		0UL,
-		0UL,
-		task->exit_signal,
-		task_cpu(task),
-		task->rt_priority,
-		task->policy,
-		(unsigned long long)delayacct_blkio_ticks(task),
-		cputime_to_clock_t(gtime),
-		cputime_to_clock_t(cgtime),
-		(mm && permitted) ? mm->start_data : 0,
-		(mm && permitted) ? mm->end_data : 0,
-		(mm && permitted) ? mm->start_brk : 0);
+	seq_printf(m,"%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
+	seq_put_decimal_ll(m, ' ', ppid);
+	seq_put_decimal_ll(m, ' ', pgid);
+	seq_put_decimal_ll(m, ' ', sid);
+	seq_put_decimal_ll(m, ' ', tty_nr);
+	seq_put_decimal_ll(m, ' ', tty_pgrp);
+	seq_put_decimal_ull(m, ' ', task->flags);
+	seq_put_decimal_ull(m, ' ', min_flt);
+	seq_put_decimal_ull(m, ' ', cmin_flt);
+	seq_put_decimal_ull(m, ' ', maj_flt);
+	seq_put_decimal_ull(m, ' ', cmaj_flt);
+	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(utime));
+	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(stime));
+	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cutime));
+	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cstime));
+	seq_put_decimal_ll(m, ' ', priority);
+	seq_put_decimal_ll(m, ' ', nice);
+	seq_put_decimal_ll(m, ' ', num_threads);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ull(m, ' ', start_time);
+	seq_put_decimal_ull(m, ' ', vsize);
+	seq_put_decimal_ll(m, ' ', mm ? get_mm_rss(mm) : 0);
+	seq_put_decimal_ull(m, ' ', rsslim);
+	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->start_code : 1) : 0);
+	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->end_code : 1) : 0);
+	seq_put_decimal_ull(m, ' ', (permitted && mm) ? mm->start_stack : 0);
+	seq_put_decimal_ull(m, ' ', esp);
+	seq_put_decimal_ull(m, ' ', eip);
+	/* The signal information here is obsolete.
+ 	 * It must be decimal for Linux 2.0 compatibility.
+	 * Use /proc/#/status for real-time signals.
+	 */
+	seq_put_decimal_ull(m, ' ', task->pending.signal.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, ' ', task->blocked.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, ' ', sigign.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, ' ', sigcatch.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, ' ', wchan);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ll(m, ' ', task->exit_signal);
+	seq_put_decimal_ll(m, ' ', task_cpu(task));
+	seq_put_decimal_ull(m, ' ', task->rt_priority);
+	seq_put_decimal_ull(m, ' ', task->policy);
+	seq_put_decimal_ull(m, ' ', delayacct_blkio_ticks(task));
+	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(gtime));
+	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cgtime));
+	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_data : 0);
+	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->end_data : 0);
+	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_brk : 0);
+	seq_putc(m, '\n');
 	if (mm)
 		mmput(mm);
 	return 0;
@@ -542,8 +539,20 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
 	}
-	seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
-			size, resident, shared, text, data);
+	/*
+	 * For quick read, open code by putting numbers directly
+	 * expected format is
+	 * seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
+	 *               size, resident, shared, text, data);
+	 */
+	seq_put_decimal_ull(m, 0, size);
+	seq_put_decimal_ull(m, ' ', resident);
+	seq_put_decimal_ull(m, ' ', shared);
+	seq_put_decimal_ull(m, ' ', text);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ull(m, ' ', text);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_putc(m, '\n');
 
 	return 0;
 }
diff --git a/fs/seq_file.c b/fs/seq_file.c
index bb773d5..eea2b01 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -657,7 +657,8 @@ int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	m->buf[m->count++] = delimiter;
+	if (delimiter)
+		m->buf[m->count++] = delimiter;
 
 	if (num < 10) {
 		m->buf[m->count++] = num + '0';
@@ -675,6 +676,24 @@ overflow:
 }
 EXPORT_SYMBOL(seq_put_decimal_ull);
 
+int seq_put_decimal_ll(struct seq_file *m, char delimiter,
+			long long num)
+{
+	if (num < 0) {
+		if (m->count + 3 >= m->size) {
+			m->count = m->size;
+			return -1;
+		}
+		if (delimiter)
+			m->buf[m->count++] = delimiter;
+		num = -num;
+		delimiter = '-';
+	}
+	return seq_put_decimal_ull(m, delimiter, num);
+
+}
+EXPORT_SYMBOL(seq_put_decimal_ll);
+
 /**
  * seq_write - write arbitrary data to buffer
  * @seq: seq_file identifying the buffer to which data should be written
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 5bba42c..54e5ae7 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -123,6 +123,8 @@ int seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_release_private(struct inode *, struct file *);
 int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 			unsigned long long num);
+int seq_put_decimal_ll(struct seq_file *m, char delimiter,
+			long long num);
 
 #define SEQ_START_TOKEN ((void *)1)
 /*
-- 
1.7.4.1


