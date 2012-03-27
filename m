Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab2C0I5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:57:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60295 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab2C0I5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:57:09 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F718081.9020906@jp.fujitsu.com>
Date: Tue, 27 Mar 2012 17:55:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [RFC] [PATCH 2/2] add /proc/stat.bin
References: <4F718007.4000401@jp.fujitsu.com>
In-Reply-To: <4F718007.4000401@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5551c12359e0069561bb507bac7454cdfd4edeaf Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 27 Mar 2012 14:17:55 +0900
Subject: [PATCH 2/2] proc: add /proc/stat.bin

Add a binary format of /proc/stat as /proc/stat.bin.
The format is seq file's binstream. The information is shown as
folllowing..

[kamezawa@bluextal linux]$ od -t x8 /proc/stat.bin
0000000 0000000400000002 0000000020757063  # string "cpu"
0000020 0000000100000004 000000000000039a  # uulong 0x39a
0000040 0000000100000001 0000000500000004  # zero, 5 ents of uulong array starts..
0000060 0000000000000551 00000000000cb2e6  # 0x551, 0xcb2e6
0000100 0000000000000bf0 0000000000000082  # 0xbf0, 0x082,
0000120 000000000000007d 0000000300000001  # 0x7d,  3 zeros
0000140 0000000400000002 0000000030757063  # string "cpu0"
...
0001540 0000000400000002 0000000072746e69  # string 'intr'
0001560 0000000300000004 000000000002d28c  # 3 ents of uulong array of values
0001600 00000000000000b6 0000000000000008  #
...
0002000 00000000000016aa 0000002f00000001  # ...47 zeros.
0002040 0000000100000001 0000000100000004  # zero, 1 ents of uulong
0002060 0000000000000004 0000043a00000001  # 0x4, 1082 of zeros..
...

In general, string and uulong values will have overheads of headers but
zeros are compressed...

[kamezawa@bluextal linux]$ wc -c /proc/stat
2817 /proc/stat
[kamezawa@bluextal linux]$ wc -c /proc/stat.bin
1392 /proc/stat.bin

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/stat.c |   79 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6a0c62d..5abcc52 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -100,7 +100,7 @@ static int show_stat(struct seq_file *p, void *v)
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
-	seq_putc(p, '\n');
+	seq_put_nl(p);
 
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -125,31 +125,42 @@ static int show_stat(struct seq_file *p, void *v)
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
-		seq_putc(p, '\n');
+		seq_put_nl(p);
 	}
-	seq_printf(p, "intr %llu", (unsigned long long)sum);
+	seq_puts(p, "intr");
+	seq_put_decimal_ull(p, ' ', sum);
 
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j)
 		seq_put_decimal_ull(p, ' ', kstat_irqs(j));
+	seq_put_nl(p);
 
-	seq_printf(p,
-		"\nctxt %llu\n"
-		"btime %lu\n"
-		"processes %lu\n"
-		"procs_running %lu\n"
-		"procs_blocked %lu\n",
-		nr_context_switches(),
-		(unsigned long)jif,
-		total_forks,
-		nr_running(),
-		nr_iowait());
+	seq_puts(p, "ctxt");
+	seq_put_decimal_ull(p, ' ', nr_context_switches());
+	seq_put_nl(p);
 
-	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
+	seq_puts(p, "btime");
+	seq_put_decimal_ull(p, ' ', (unsigned long)jif);
+	seq_put_nl(p);
+
+	seq_puts(p, "processes");
+	seq_put_decimal_ull(p, ' ', total_forks);
+	seq_put_nl(p);
+
+	seq_puts(p, "process_running");
+	seq_put_decimal_ull(p, ' ', nr_running());
+	seq_put_nl(p);
+
+	seq_puts(p, "process_blocked");
+	seq_put_decimal_ull(p, ' ', nr_iowait());
+	seq_put_nl(p);
+
+	seq_puts(p, "softirq");
+	seq_put_decimal_ull(p, ' ', sum_softirq);
 
 	for (i = 0; i < NR_SOFTIRQS; i++)
 		seq_put_decimal_ull(p, ' ', per_softirq_sums[i]);
-	seq_putc(p, '\n');
+	seq_put_nl(p);
 
 	return 0;
 }
@@ -188,9 +199,45 @@ static const struct file_operations proc_stat_operations = {
 	.release	= single_release,
 };
 
+static int statbin_open(struct inode *inode, struct file *file)
+{
+	unsigned size = 1024 + 160 * num_possible_cpus();
+	char *buf;
+	struct seq_file *m;
+	int res;
+
+	/* each uulong entries requires: 16 bytes */
+	size += 16 * nr_irqs;
+
+	/* don't ask for more than the kmalloc() max size */
+	if (size > KMALLOC_MAX_SIZE)
+		size = KMALLOC_MAX_SIZE;
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	res = single_open(file, show_stat, NULL);
+	if (!res) {
+		m = file->private_data;
+		m->buf = buf;
+		m->size = ksize(buf);
+		seq_set_binstream(m);
+	} else
+		kfree(buf);
+	return res;
+}
+
+static const struct file_operations proc_statbin_operations = {
+	.open		= statbin_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int __init proc_stat_init(void)
 {
 	proc_create("stat", 0, NULL, &proc_stat_operations);
+	proc_create("stat.bin", 0, NULL, &proc_statbin_operations);
 	return 0;
 }
 module_init(proc_stat_init);
-- 
1.7.4.1


