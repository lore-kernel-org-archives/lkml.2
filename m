Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1JCTHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:07:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54851 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab1JCTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:07:27 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 01/10] cgroups: Add res_counter_write_u64() API
Date: Mon,  3 Oct 2011 21:07:03 +0200
Message-Id: <1317668832-10784-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the resource counter API with a mirror of
res_counter_read_u64() to make it handy to update a resource
counter value from a cgroup subsystem u64 value file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Containers <containers@lists.linux-foundation.org>
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
index 34683ef..0faafcc 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -168,12 +168,26 @@ int res_counter_memparse_write_strategy(const char *buf,
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
@@ -183,9 +197,8 @@ int res_counter_write(struct res_counter *counter, int member,
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

