Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2A3XUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:20:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2A3XUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:20:53 -0500
Date: Mon, 30 Jan 2012 15:20:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH] Add num_to_str() for speedup /proc/stat
Message-Id: <20120130152051.89024fba.akpm@linux-foundation.org>
In-Reply-To: <20120130141619.a35863e2.kamezawa.hiroyu@jp.fujitsu.com>
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
	<20120130141619.a35863e2.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 14:16:19 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Mon, 30 Jan 2012 14:15:12 +0900
> Subject: [PATCH] Add num_to_str() for speedup /proc/stat
> 
> At reading /proc/stat, most of time is consumed by vsnprintf() at el.
> 
> Here is a test script, reading /proc/stat 1000 times..
> 
> == stat_check.py
> num = 0
> with open("/proc/stat") as f:
>         while num < 1000 :
>                 data = f.read()
>                 f.seek(0, 0)
>                 num = num + 1
> ==
> 
> perf shows
> 
>     20.39%  stat_check.py  [kernel.kallsyms]    [k] format_decode
>     13.41%  stat_check.py  [kernel.kallsyms]    [k] number
>     12.61%  stat_check.py  [kernel.kallsyms]    [k] vsnprintf
>     10.85%  stat_check.py  [kernel.kallsyms]    [k] memcpy
>      4.85%  stat_check.py  [kernel.kallsyms]    [k] radix_tree_lookup
>      4.43%  stat_check.py  [kernel.kallsyms]    [k] seq_printf
> 
> This patch removes most of calls to vsnprintf() by adding
> num_to_str() and seq_print_decimal_ull(), which prints decimal numbers
> without rich functions provided by printf().
> 
> On my 8cpu box.
> == Before patch ==
> [root@bluextal test]# time ./stat_check.py
> 
> real    0m0.150s
> user    0m0.026s
> sys     0m0.121s
> 
> == After patch ==
> [root@bluextal test]# time ./stat_check.py
> 
> real    0m0.055s
> user    0m0.022s
> sys     0m0.030s
> 
> Maybe it's worth to add this simple function.

I suppose so - the new infrastructure can be used elsewhere.

I tried doing the

	if (kstst_irqs(j) == 0) {
		seq_putc(p, ' ');
		seq_putc(p, '0');

think on top of this and didn't observe any improvement.


I made some changes - please review.  I'm not sure why you did "char
tmp[66]"?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-add-num_to_str-to-speed-up-proc-stat-fix

- remove incorrect comment
- use less stack in num_to_str()
- move comment from .h to .c
- simplify seq_put_decimal_ull()

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |    5 ++---
 include/linux/kernel.h   |    6 ------
 include/linux/seq_file.h |    4 +---
 lib/vsprintf.c           |    8 +++++++-
 4 files changed, 10 insertions(+), 13 deletions(-)

diff -puN fs/proc/stat.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix fs/proc/stat.c
diff -puN fs/seq_file.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix fs/seq_file.c
--- a/fs/seq_file.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix
+++ a/fs/seq_file.c
@@ -659,14 +659,13 @@ int seq_put_decimal_ull(struct seq_file 
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
+	m->buf[m->count++] = delimiter;
+
 	if (num < 10) {
-		m->buf[m->count++] = delimiter;
 		m->buf[m->count++] = num + '0';
 		return 0;
 	}
 
-	m->buf[m->count++] = delimiter;
-
 	len = num_to_str(m->buf + m->count, m->size - m->count, num);
 	if (!len)
 		goto overflow;
diff -puN include/linux/kernel.h~procfs-add-num_to_str-to-speed-up-proc-stat-fix include/linux/kernel.h
--- a/include/linux/kernel.h~procfs-add-num_to_str-to-speed-up-proc-stat-fix
+++ a/include/linux/kernel.h
@@ -299,12 +299,6 @@ extern long long simple_strtoll(const ch
 #define strict_strtoull	kstrtoull
 #define strict_strtoll	kstrtoll
 
-/*
- * Convert passed number to decimal string.
- * returns returns the length of string. at buffer overflow, returns 0.
- *
- * If speed is not important, use snprintf(). It's easy to read the code.
- */
 extern int num_to_str(char *buf, int size, unsigned long long num);
 
 /* lib/printf utilities */
diff -puN include/linux/seq_file.h~procfs-add-num_to_str-to-speed-up-proc-stat-fix include/linux/seq_file.h
--- a/include/linux/seq_file.h~procfs-add-num_to_str-to-speed-up-proc-stat-fix
+++ a/include/linux/seq_file.h
@@ -121,10 +121,8 @@ int single_release(struct inode *, struc
 void *__seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_release_private(struct inode *, struct file *);
-
-/* defined in lib/vsprintf.c */
 int seq_put_decimal_ull(struct seq_file *m, char delimiter,
-		unsigned long long num);
+			unsigned long long num);
 
 #define SEQ_START_TOKEN ((void *)1)
 /*
diff -puN lib/vsprintf.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix lib/vsprintf.c
--- a/lib/vsprintf.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix
+++ a/lib/vsprintf.c
@@ -212,9 +212,15 @@ char *put_dec(char *buf, unsigned long l
 	}
 }
 
+/*
+ * Convert passed number to decimal string.
+ * Returns the length of string.  On buffer overflow, returns 0.
+ *
+ * If speed is not important, use snprintf(). It's easy to read the code.
+ */
 int num_to_str(char *buf, int size, unsigned long long num)
 {
-	char tmp[66];
+	char tmp[21];		/* Enough for 2^64 in decimal */
 	int idx, len;
 
 	len = put_dec(tmp, num) - tmp;
_

