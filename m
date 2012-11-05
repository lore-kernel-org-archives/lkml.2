Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2KDNBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:01:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49513 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab2KDNAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:54 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 12/13] HW-latency: Add sample unit in sample data
Date: Sun,  4 Nov 2012 20:59:43 -0500
Message-Id: <1352080784-30839-13-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ns and us

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index bcce8f4..0b79b5e 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -60,6 +60,7 @@ struct sample {
 	u64	duration;
 	struct timespec	timestamp;
 	u64	addr;
+	u8	unit; /*0: ns 1:us*/
 	unsigned long	lost;
 };
 
@@ -130,7 +131,7 @@ static struct sample *buffer_get_sample(struct sample *sample)
 	return sample;
 }
 
-static int buffer_add_sample(u64 sample)
+static int buffer_add_sample(u64 sample, u8 unit)
 {
 	int ret = 0;
 	unsigned int cpu = smp_processor_id();
@@ -144,6 +145,7 @@ static int buffer_add_sample(u64 sample)
 		s.duration = sample;
 		s.timestamp = CURRENT_TIME;
 		s.addr = (u64) __start;
+		s.unit = unit;
 		ret = __buffer_add_sample(&s);
 
 		if (sample > data.max_sample)
@@ -184,7 +186,7 @@ static int get_random_bytes_sample(void *unused)
 
 	} while (total <= data.sample_width);
 
-	ret = buffer_add_sample(sample);
+	ret = buffer_add_sample(sample, 1);
 out:
 	kfree(buffer);
 	return ret;
@@ -219,7 +221,7 @@ static int get_freq_sample(void *unused)
 
 	} while (total <= data.sample_width);
 
-	ret = buffer_add_sample(sample);
+	ret = buffer_add_sample(sample, 1);
 out:
 	return ret;
 }
@@ -252,7 +254,7 @@ static int get_tsc_sample(void *unused)
 
 	} while (total <= data.sample_width);
 
-	ret = buffer_add_sample(sample);
+	ret = buffer_add_sample(sample, 0);
 out:
 	return ret;
 }
@@ -289,7 +291,7 @@ static int get_mem_sample(void *unused)
 
 	} while (total <= data.sample_width);
 
-	ret = buffer_add_sample(sample);
+	ret = buffer_add_sample(sample, 0);
 out:
 	return ret;
 }
@@ -669,11 +671,12 @@ static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
 			goto out;
 		}
 	}
-	len = snprintf(buf, sizeof(buf), "[%d]%010lu.%010lu\t%llu\t[%llx]\n",
+	len = snprintf(buf, sizeof(buf), "[%d]%010lu.%010lu\t%llu%2s\t[%llx]\n",
 			sample->cpu,
 			sample->timestamp.tv_sec,
 			sample->timestamp.tv_nsec,
 			sample->duration,
+			sample->unit ? "us":"ns",
 			sample->addr);
 	if (len > cnt)
 		goto out;
-- 
1.7.12.1

