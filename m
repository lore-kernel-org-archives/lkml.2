Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab2A3FRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:17:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44381 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2A3FRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:17:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 30 Jan 2012 14:16:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: [PATCH] Add num_to_str() for speedup /proc/stat
Message-Id: <20120130141619.a35863e2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120126171800.01c2405c.akpm@linux-foundation.org>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1327449683.14373.12.camel@edumazet-laptop>
	<20120124161221.032325d1.akpm@linux-foundation.org>
	<1327450945.14373.24.camel@edumazet-laptop>
	<20120124172732.19b3d9f4.akpm@linux-foundation.org>
	<1327469372.14373.31.camel@edumazet-laptop>
	<20120125170416.385ee9fa.akpm@linux-foundation.org>
	<20120126185520.25c8f9b6.kamezawa.hiroyu@jp.fujitsu.com>
	<20120126164342.a496ded0.akpm@linux-foundation.org>
	<20120127100933.5e782a33.kamezawa.hiroyu@jp.fujitsu.com>
	<20120126171800.01c2405c.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 17:18:00 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 27 Jan 2012 10:09:33 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > I expect most of these numbers are zero.  I wonder if we would get
> > > useful speedups from
> > > 
> > > 	for_each_irq_nr(j) {
> > > 		/* Apologetic comment goes here */
> > > 		if (kstat_irqs(j))
> > > 			seq_printf(p, " %u", kstat_irqs(j));
> > > 		else
> > > 			seq_puts(p, " 0");
> > > 	}
> > 
> > Yes. This is very good optimization and shows much optimization.
> > I did this at first try  but did complicated ones because it seems
> > not interesting. (This is my bad habit...)
> > 
> > I'll try again and measure time.
> 
> seq_puts() is too slow ;)  I bet seq_putc(p, ' ');seq_putc(p, '0') will
> complete in negative time.


How about this ? I think this is simple enough.
=
>From d1f215d4279152362721fd2ca74241fe85afe2ce Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 30 Jan 2012 14:15:12 +0900
Subject: [PATCH] Add num_to_str() for speedup /proc/stat

At reading /proc/stat, most of time is consumed by vsnprintf() at el.

Here is a test script, reading /proc/stat 1000 times..

== stat_check.py
num = 0
with open("/proc/stat") as f:
        while num < 1000 :
                data = f.read()
                f.seek(0, 0)
                num = num + 1
==

perf shows

    20.39%  stat_check.py  [kernel.kallsyms]    [k] format_decode
    13.41%  stat_check.py  [kernel.kallsyms]    [k] number
    12.61%  stat_check.py  [kernel.kallsyms]    [k] vsnprintf
    10.85%  stat_check.py  [kernel.kallsyms]    [k] memcpy
     4.85%  stat_check.py  [kernel.kallsyms]    [k] radix_tree_lookup
     4.43%  stat_check.py  [kernel.kallsyms]    [k] seq_printf

This patch removes most of calls to vsnprintf() by adding
num_to_str() and seq_print_decimal_ull(), which prints decimal numbers
without rich functions provided by printf().

On my 8cpu box.
== Before patch ==
[root@bluextal test]# time ./stat_check.py

real    0m0.150s
user    0m0.026s
sys     0m0.121s

== After patch ==
[root@bluextal test]# time ./stat_check.py

real    0m0.055s
user    0m0.022s
sys     0m0.030s

Maybe it's worth to add this simple function.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/stat.c           |   55 ++++++++++++++++++++++-----------------------
 fs/seq_file.c            |   34 ++++++++++++++++++++++++++++
 include/linux/kernel.h   |    8 ++++++
 include/linux/seq_file.h |    5 +++-
 lib/vsprintf.c           |   14 +++++++++++
 5 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 121f77c..0ff3b92 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -89,18 +89,19 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	sum += arch_irq_stat();
 
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-		"%llu\n",
-		(unsigned long long)cputime64_to_clock_t(user),
-		(unsigned long long)cputime64_to_clock_t(nice),
-		(unsigned long long)cputime64_to_clock_t(system),
-		(unsigned long long)cputime64_to_clock_t(idle),
-		(unsigned long long)cputime64_to_clock_t(iowait),
-		(unsigned long long)cputime64_to_clock_t(irq),
-		(unsigned long long)cputime64_to_clock_t(softirq),
-		(unsigned long long)cputime64_to_clock_t(steal),
-		(unsigned long long)cputime64_to_clock_t(guest),
-		(unsigned long long)cputime64_to_clock_t(guest_nice));
+	seq_puts(p, "cpu ");
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+	seq_putc(p, '\n');
+
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
 		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
@@ -113,26 +114,24 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
-		seq_printf(p,
-			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-			"%llu\n",
-			i,
-			(unsigned long long)cputime64_to_clock_t(user),
-			(unsigned long long)cputime64_to_clock_t(nice),
-			(unsigned long long)cputime64_to_clock_t(system),
-			(unsigned long long)cputime64_to_clock_t(idle),
-			(unsigned long long)cputime64_to_clock_t(iowait),
-			(unsigned long long)cputime64_to_clock_t(irq),
-			(unsigned long long)cputime64_to_clock_t(softirq),
-			(unsigned long long)cputime64_to_clock_t(steal),
-			(unsigned long long)cputime64_to_clock_t(guest),
-			(unsigned long long)cputime64_to_clock_t(guest_nice));
+		seq_printf(p, "cpu %d", i);
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+		seq_putc(p, '\n');
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j)
-		seq_printf(p, " %u", kstat_irqs(j));
+		seq_put_decimal_ull(p, ' ', kstat_irqs(j));
 
 	seq_printf(p,
 		"\nctxt %llu\n"
@@ -149,7 +148,7 @@ static int show_stat(struct seq_file *p, void *v)
 	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
 
 	for (i = 0; i < NR_SOFTIRQS; i++)
-		seq_printf(p, " %u", per_softirq_sums[i]);
+		seq_put_decimal_ull(p, ' ', per_softirq_sums[i]);
 	seq_putc(p, '\n');
 
 	return 0;
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4023d6b..a1ccb48 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -642,6 +642,40 @@ int seq_puts(struct seq_file *m, const char *s)
 }
 EXPORT_SYMBOL(seq_puts);
 
+/*
+ * A helper routine for putting decimal numbers without rich format of printf().
+ * only 'unsigned long long' is supported.
+ * This routine will put one byte delimiter + number into seq_file.
+ * This routine is very quick when you show lots of numbers.
+ * In usual cases, it will be better to use seq_printf(). It's easier to read.
+ */
+int seq_put_decimal_ull(struct seq_file *m, char delimiter, 
+			unsigned long long num)
+{
+	int len;
+
+	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
+		goto overflow;
+
+	if (num < 10) {
+		m->buf[m->count++] = delimiter;
+		m->buf[m->count++] = num + '0';
+		return 0;
+	}
+
+	m->buf[m->count++] = delimiter;
+
+	len = num_to_str(m->buf + m->count, m->size - m->count, num);
+	if (!len)
+		goto overflow;
+	m->count += len;
+	return 0;
+overflow:
+	m->count = m->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_put_decimal_ull);
+
 /**
  * seq_write - write arbitrary data to buffer
  * @seq: seq_file identifying the buffer to which data should be written
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..bb2da3f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -299,6 +299,14 @@ extern long long simple_strtoll(const char *,char **,unsigned int);
 #define strict_strtoull	kstrtoull
 #define strict_strtoll	kstrtoll
 
+/*
+ * Convert passed number to decimal string.
+ * returns returns the length of string. at buffer overflow, returns 0.
+ * 
+ * If speed is not important, use snprintf(). It's easy to read the code.
+ */
+extern int num_to_str(char *buf, int size, unsigned long long num);
+
 /* lib/printf utilities */
 
 extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 44f1514..b58a95c 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -122,8 +122,11 @@ void *__seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_release_private(struct inode *, struct file *);
 
-#define SEQ_START_TOKEN ((void *)1)
+/* defined in lib/vsprintf.c */
+int seq_put_decimal_ull(struct seq_file *m, char delimiter,
+		unsigned long long num);
 
+#define SEQ_START_TOKEN ((void *)1)
 /*
  * Helpers for iteration over list_head-s in seq_files
  */
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 8e75003..ffb81b1 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -212,6 +212,20 @@ char *put_dec(char *buf, unsigned long long num)
 	}
 }
 
+int num_to_str(char *buf, int size, unsigned long long num)
+{
+	char tmp[66];
+	int idx, len;
+
+	len = put_dec(tmp, num) - tmp;
+	
+	if (len > size)
+		return 0;
+	for (idx = 0; idx < len; ++idx)
+		buf[idx] = tmp[len - idx - 1];
+	return  len;
+}
+
 #define ZEROPAD	1		/* pad with zero */
 #define SIGN	2		/* unsigned/signed long */
 #define PLUS	4		/* show plus */
-- 
1.7.4.1


