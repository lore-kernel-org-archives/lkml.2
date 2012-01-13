Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab2AMSTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:19:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58301 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab2AMSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:15:12 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <htejun@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/8] cgroups: add res_counter_write_u64() API
Date: Fri, 13 Jan 2012 19:13:47 +0100
Message-Id: <1326478441-3048-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the resource counter API with a mirror of res_counter_read_u64() to
make it handy to update a resource counter value from a cgroup subsystem
u64 value file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   25 +++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index c9d625c..1b3fe05 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -82,6 +82,8 @@ int res_counter_memparse_write_strategy(const char *buf,
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buffer, write_strategy_fn write_strategy);
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
+
 /*
  * the field descriptors. one for each member of res_counter
  */
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 6d269cc..58ae85e 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -167,12 +167,26 @@ int res_counter_memparse_write_strategy(const char *buf,
 	return 0;
 }
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
+{
+	unsigned long long *target;
+	unsigned long flags;
+
+	/*
+	 * We need the lock to protect against concurrent add/dec on 32 bits.
+	 * No need to ifdef it's seldom used.
+	 */
+	spin_lock_irqsave(&counter->lock, flags);
+	target = res_counter_member(counter, member);
+	*target = val;
+	spin_unlock_irqrestore(&counter->lock, flags);
+}
+
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buf, write_strategy_fn write_strategy)
 {
 	char *end;
-	unsigned long flags;
-	unsigned long long tmp, *val;
+	unsigned long long tmp;
 
 	if (write_strategy) {
 		if (write_strategy(buf, &tmp))
@@ -182,9 +196,8 @@ int res_counter_write(struct res_counter *counter, int member,
 		if (*end != '\0')
 			return -EINVAL;
 	}
-	spin_lock_irqsave(&counter->lock, flags);
-	val = res_counter_member(counter, member);
-	*val = tmp;
-	spin_unlock_irqrestore(&counter->lock, flags);
+
+	res_counter_write_u64(counter, member, tmp);
+
 	return 0;
 }
-- 
1.7.5.4

