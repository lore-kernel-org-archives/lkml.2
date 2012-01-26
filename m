Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab2AZJ4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:56:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60576 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AZJ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:56:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 26 Jan 2012 18:55:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Message-Id: <20120126185520.25c8f9b6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120125170416.385ee9fa.akpm@linux-foundation.org>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1327449683.14373.12.camel@edumazet-laptop>
	<20120124161221.032325d1.akpm@linux-foundation.org>
	<1327450945.14373.24.camel@edumazet-laptop>
	<20120124172732.19b3d9f4.akpm@linux-foundation.org>
	<1327469372.14373.31.camel@edumazet-laptop>
	<20120125170416.385ee9fa.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 17:04:16 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 Jan 2012 06:29:32 +0100
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Le mardi 24 janvier 2012 __ 17:27 -0800, Andrew Morton a __crit :
> > 
> > > I had a fiddle on an 8-way x86_64 machine.  I'm unable to demonstrate
> > > any improvement for either of
> > > 
> > > time (for i in $(seq 1000); do; cat /proc/self/stat > /dev/null; done)
> > > time (for i in $(seq 1000); do; cat /proc/1/stat > /dev/null; done)
> > > 
> > > oh well.
> > 
> > What size is /proc/stat ?
> 
> About 40mm, but it depends on the font size.
> 
> > wc -c /proc/stat
> > 
> > If under 4096, there is no problem with existing code.
> 
> akpm2:/home/akpm> wc -c /proc/stat 
> 2800 /proc/stat
> 
> > I had the problem on a 16-way machine.
> 
> OK..


I wrote following patch just for my fun, which makes /proc/stat twice fast.
But I'm not sure whether this kind of dirty && special printk is worth to do or not..
because I can't see /proc/stat cost at shell-scripting.

With python script test (read /proc/stat 1000times)
==
#!/usr/bin/python

num = 0

with open("/proc/stat") as f:
        while num < 1000 :
                data = f.read()
                f.seek(0, 0)
                num = num + 1
==

*Before patch
[kamezawa@bluextal test]$ time ./stat_check.py

real    0m0.154s
user    0m0.020s
sys     0m0.130s

*After patch
[kamezawa@bluextal test]$ time ./stat_check.py

real    0m0.080s
user    0m0.029s
sys     0m0.048s


For ascii interface, format_decode() and number() seems to be
very costly...

==
>From 2bd6deb7048b1e4e4d32b9fb8c6ca93259a11620 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 Jan 2012 18:57:19 +0900
Subject: [PATCH] snprintf_batch for sequence printing in /proc/stat

In /proc/stat, a sequence of numbers are printed out under the same
format. Reading /proc/stat consumes 20% of cpu just for decoding the format.
This patch adds a decode-once + print a sequence function for helping
/proc/stat.

New (special) function is snprintf_batch().

for example, Following is a function to print 0..10 in a sequence
to given buffer.

  unsigned long long my_next_val(void *iter, bool *last)
  {
       int x = *(int *)iter;
       if (x == 11) {
            last = true;
            return 0;
       }
       *(int *)iter += 1;
       return x;
  }
  {
    ...
    int iter = 0;
    snprintf_batch(buf, size, " %d", &iter, my_next_val);
  }

Using this will reduce the cost for format decoding and
make /proc/stat faster, which shows tons of numbers in ascii..

With a python script which reads /proc/stat 1000 times.

* Before Patch
[kamezawa@bluextal test]$ time ./stat_check.py
real    0m0.154s
user    0m0.020s
sys     0m0.130s

* After Patch
[kamezawa@bluextal test]$ time ./stat_check.py

real    0m0.080s
user    0m0.029s
sys     0m0.048s

In my environ, size of /proc/stat is 2700 bytes.

Above score shows that patched one is almost twice fast....but in
general, with shell-scripting, fork/exec/mmap etc...cost is much
larger than cost of reading /proc/stat, benefit for usual users is doubtful

If an admin or a program check /proc/stat periodically with his script,
this improvement will give them better latency.

Note: the added snprinf_batch() can be used for other places as
      /proc/<pid>/stat but I'm not sure whether this simple
      iterator interface is enough or not.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/stat.c           |   16 +++++++-
 fs/seq_file.c            |   18 +++++++++
 include/linux/kernel.h   |    4 ++
 include/linux/seq_file.h |    3 +
 lib/vsprintf.c           |   92 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 131 insertions(+), 2 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 121f77c..0687d45 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -49,6 +49,18 @@ static u64 get_iowait_time(int cpu)
 	return iowait;
 }
 
+static unsigned long long get_next_kstat_irq(void *iter, bool *last)
+{
+	int pos = *(int *)iter;
+
+	if (pos == nr_irqs) {
+		*last = true;
+		return 0;
+	}
+	*(int *)iter = pos + 1;
+	return kstat_irqs(pos);
+}
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -131,8 +143,8 @@ static int show_stat(struct seq_file *p, void *v)
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
-	for_each_irq_nr(j)
-		seq_printf(p, " %u", kstat_irqs(j));
+	j = 0;
+	seq_printnum_batch(p, " %u", &j, get_next_kstat_irq);
 
 	seq_printf(p,
 		"\nctxt %llu\n"
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4023d6b..fa367ce 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -386,6 +386,24 @@ int seq_printf(struct seq_file *m, const char *f, ...)
 }
 EXPORT_SYMBOL(seq_printf);
 
+int seq_printnum_batch(struct seq_file *m, const char *f, void *iter,
+			unsigned long long (*next_val)(void *, bool *))
+{
+	int len;
+
+	if (m->count < m->size) {
+		len = snprintf_batch(m->buf + m->count,
+			m->size - m->count, f, iter, next_val);
+		if (m->count + len < m->size) {
+			m->count += len;
+			return 0;
+		}
+	}
+	m->count = m->size;
+	return -1;
+}
+EXPORT_SYMBOL_GPL(seq_printnum_batch);
+
 /**
  *	mangle_path -	mangle and copy path to buffer beginning
  *	@s: buffer start
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..7306174 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -320,6 +320,10 @@ extern int sscanf(const char *, const char *, ...)
 extern int vsscanf(const char *, const char *, va_list)
 	__attribute__ ((format (scanf, 2, 0)));
 
+/* special function for printing sequence values */
+extern int snprintf_batch(char *buf, size_t size, const char *fmt,
+		void *iter, unsigned long long (*next_val)(void *, bool *));
+
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 44f1514..5ac464a 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -86,6 +86,9 @@ int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
 
+int seq_printnum_batch(struct seq_file *seq, const char *fmt, void *iter,
+		unsigned long long (*next_val)(void *, bool *));
+
 int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
 int seq_path_root(struct seq_file *m, const struct path *path,
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 8e75003..03e45cc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2038,3 +2038,95 @@ int sscanf(const char *buf, const char *fmt, ...)
 	return i;
 }
 EXPORT_SYMBOL(sscanf);
+
+/*
+ * snprintf_batch - format a string with a give array and spacer
+ * @buf : The buffer to place the result info
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt : The format for printing each numbers.(some limitations below)
+ * @iter:The array to be printed
+ * @array_size : the number of entries in array
+ *
+ * This function is for printing values given by a given function next_val()
+ * in a given format until next_val() finishes. Unlike printf, available
+ * format is very limited.  The allowed fmt for this function is
+ * "a%?b".
+ *   - a is a one charactor spacer printed before the value.
+ *   - b is a one charactor spacer printed after the value
+ *   - %? is an integer value. %d, %u, %x + other controls as 'h/hh/l/ll etc
+ *     are available. But you can specify precision and field_width as argument.
+ *
+ * This function is useful when you need to print a sequence of values of
+ * the same type. This function stops when next_val() returns 'true' in
+ * the second argument. 
+ *
+ * This function is originally designed for /proc/stat..
+ */
+
+int snprintf_batch(char *buf, size_t size, const char *fmt, void *iter,
+		unsigned long long (*next_val)(void *, bool *))
+{
+	char *str, *end;
+	struct printf_spec spec = {0};
+	unsigned long long num;
+	bool last = false;
+	char head, foot;
+	bool easy_zero_printing = false;
+	int read;
+
+       if (WARN_ON_ONCE((int) size < 0))
+                return 0;
+
+	str = buf;
+	end = buf + size;
+	 /* Make sure end is always >= buf */
+	if (end < buf) {
+		end =  ((void *)-1);
+		size = end - buf;
+	}
+
+	head = foot = 0;
+
+	if (*fmt != '%') {
+		head = *fmt;
+		fmt++;
+	}
+	/* decode happens only once */
+	read = format_decode(fmt, &spec);
+	fmt += read;
+	if (*fmt)
+		foot = *fmt;
+	/* if fmt is simple, we can show '0' easily */
+	if (spec.precision == -1 &&
+		spec.field_width == -1 &&
+		!(spec.flags & (ZEROPAD + PLUS + SPACE + SMALL + SPECIAL)))
+		easy_zero_printing = true;
+
+	while (str < end) {
+		num = next_val(iter, &last);
+		if (last)
+			break;
+		if (str < end && head != 0) {
+			*str = head;
+			str++;
+		}
+		/* optimization for /proc/stat */
+		if (num == 0 && easy_zero_printing) {
+			*str = '0';
+			str++;
+		} else
+			str = number(str, end, num, spec);
+		if (str < end && foot != 0) {
+			*str = foot;
+			str++;
+		}
+	}
+	if (size > 0) {
+		if (str < end)
+			*str = '0';
+		else
+			end[-1] = '0';
+	}
+	return str - buf;
+}
+EXPORT_SYMBOL_GPL(snprintf_batch);
-- 
1.7.4.1




