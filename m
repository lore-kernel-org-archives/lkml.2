Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2KDNCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:02:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42448 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2KDNAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:13 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 04/13] HW-latency: Differentiate three modes to use CPU carry out testing
Date: Sun,  4 Nov 2012 20:59:35 -0500
Message-Id: <1352080784-30839-5-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0: all online cpus
1: any one of online cpus
2: all online cpus sequentially run test

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index 8a8c6ba..4303644 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -47,6 +47,7 @@ static unsigned long buf_size = 262144UL;
 static struct task_struct *kthread;
 
 struct sample {
+	unsigned int cpu;
 	u64	seqnum;
 	u64	duration;
 	struct timespec	timestamp;
@@ -70,6 +71,7 @@ static struct data {
 static ktime_t	now;
 struct sample_function {
 	const char *name;
+	u8	type; /* 0=all parallel, 1=anyone, 2=all sequential*/
 	struct list_head list;
 	int (*get_sample)(void *unused);
 };
@@ -186,14 +188,11 @@ static int get_freq_sample(void *unused)
 	u32	sample = 0;
 	int	ret = 1;
 	unsigned int cpu_tsc_freq;
-	static DEFINE_MUTEX(freq_pit_mutex);
 
 	start = ktime_get();
 	do {
 		t1 = ktime_get();
-		mutex_lock(&freq_pit_mutex);
 		cpu_tsc_freq = x86_platform.calibrate_tsc();
-		mutex_unlock(&freq_pit_mutex);
 		t2 = ktime_get();
 		total = ktime_to_us(ktime_sub(t2, start));
 		diff = abs(cpu_tsc_freq - tsc_khz);
@@ -249,23 +248,30 @@ out:
 
 struct sample_function tsc_sample = {
 	.name		= "tsc",
+	.type		= 0,
 	.get_sample 	= get_tsc_sample,
 };
 
 struct sample_function tsc_freq_sample = {
 	.name		= "freq",
+	.type		= 2,
 	.get_sample 	= get_freq_sample,
 };
 
 struct sample_function random_bytes_sample = {
 	.name		= "random_bytes",
+	.type		= 0,
 	.get_sample 	= get_random_bytes_sample,
 };
 
+static DECLARE_BITMAP(testing_cpu_map, NR_CPUS);
+
 static int kthread_fn(void *unused)
 {
 	int err = 0;
 	u64 interval = 0;
+	int cpu;
+	struct cpumask *testing_cpu_mask = to_cpumask(testing_cpu_map);
 	int (*get_sample)(void *unused);
 	
 	mutex_lock(&sample_function_mutex);
@@ -274,10 +280,31 @@ static int kthread_fn(void *unused)
 	else
 		goto out;
 
+	cpumask_or(testing_cpu_mask, testing_cpu_mask, cpu_online_mask);
 	while (!kthread_should_stop()) {
 		mutex_lock(&data.lock);
-	
-		err = stop_machine(get_sample, unused, cpu_online_mask);
+
+		switch (current_sample_func->type) {
+		case 0:
+			err = stop_machine(get_sample, unused, testing_cpu_mask);
+			break;
+		case 1:
+			err = stop_machine(get_sample, unused, NULL);
+			break;
+		case 2:
+			for_each_cpu(cpu, cpu_online_mask) {
+				cpumask_clear(testing_cpu_mask);
+				cpumask_set_cpu(cpu, testing_cpu_mask);
+				err = stop_machine(get_sample, unused, NULL);
+				if (err)
+					break;
+			}
+			break;
+		default:
+			mutex_unlock(&data.lock);
+			goto err_out;
+		}
+
 		if (err) {
 			mutex_unlock(&data.lock);
 			goto err_out;
-- 
1.7.12.1

