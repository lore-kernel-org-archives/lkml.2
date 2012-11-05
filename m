Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2KDNAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:00:38 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49060 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2KDNAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:33 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 08/13] HW-latency: A stupid memory scanner for raw memory latency test
Date: Sun,  4 Nov 2012 20:59:39 -0500
Message-Id: <1352080784-30839-9-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's simple memory latency test without any consideration of memory
hierarchy and memory model. It just does simply scan byte by byte.

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 53 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index 78436da..f47b911 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -46,11 +46,15 @@ static DEFINE_MUTEX(ring_buffer_mutex);
 static unsigned long buf_size = 262144UL;
 static struct task_struct *kthread;
 
+static u8 *__start = (u8 *)0xffff880000000000;
+static u8 *__end = (u8 *)0xffffc7ffffffffff;
+
 struct sample {
 	unsigned int cpu;
 	u64	seqnum;
 	u64	duration;
 	struct timespec	timestamp;
+	u64	addr;
 	unsigned long	lost;
 };
 
@@ -134,6 +138,7 @@ static int buffer_add_sample(u64 sample)
 		s.seqnum = data.count;
 		s.duration = sample;
 		s.timestamp = CURRENT_TIME;
+		s.addr = (u64) __start;
 		ret = __buffer_add_sample(&s);
 
 		if (sample > data.max_sample)
@@ -247,6 +252,42 @@ out:
 	return ret;
 }
 
+static int get_mem_sample(void *unused)
+{
+	ktime_t	start, t1, t2;
+	s64	diff, total = 0;
+	u64	sample = 0;
+	int	ret = 1;
+	u8	temp;
+
+	now = start = ktime_get();
+	do {
+		t1 = now;
+		now = t2 = ktime_get();
+
+		total = ktime_to_ns(ktime_sub(t2, start));
+		temp = *__start++;
+		diff = ktime_to_ns(ktime_sub(t2, t1));
+
+		if (diff < 0) {
+			printk(KERN_ERR BANNER "time running backwards\n");
+			goto out;
+		} 
+
+		if (diff > sample)
+			sample = diff;
+
+		if (__start == __end) {
+			__start = (u8 *)0xffff880000000000;
+			printk(KERN_INFO BANNER "one pass finished, jmp to the beginning\n");
+		}
+
+	} while (total <= data.sample_width);
+
+	ret = buffer_add_sample(sample);
+out:
+	return ret;
+}
 
 struct sample_function tsc_sample = {
 	.name		= "tsc",
@@ -266,6 +307,12 @@ struct sample_function random_bytes_sample = {
 	.get_sample 	= get_random_bytes_sample,
 };
 
+struct sample_function mem_sample = {
+	.name		= "mem",
+	.type		= 1,
+	.get_sample 	= get_mem_sample,
+};
+
 static DECLARE_BITMAP(testing_cpu_map, NR_CPUS);
 
 static int kthread_fn(void *unused)
@@ -617,11 +664,12 @@ static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
 			goto out;
 		}
 	}
-	len = snprintf(buf, sizeof(buf), "[%d]%010lu.%010lu\t%llu\n",
+	len = snprintf(buf, sizeof(buf), "[%d]%010lu.%010lu\t%llu\t[%llx]\n",
 			sample->cpu,
 			sample->timestamp.tv_sec,
 			sample->timestamp.tv_nsec,
-			sample->duration);
+			sample->duration,
+			sample->addr);
 	if (len > cnt)
 		goto out;
 	if (copy_to_user(ubuf, buf,len))
@@ -827,6 +875,7 @@ static int hw_test_init(void)
 	sample_function_register(&tsc_sample);
 	sample_function_register(&tsc_freq_sample);
 	sample_function_register(&random_bytes_sample);
+	sample_function_register(&mem_sample);
 
 	ret = init_stats();
 	if (0 != ret)
-- 
1.7.12.1

