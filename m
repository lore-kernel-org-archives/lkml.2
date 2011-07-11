Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab1GKOPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:15:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56761 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab1GKOPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:15:30 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: [PATCH 6/7] cgroups: Add res counter common ancestor searching
Date: Mon, 11 Jul 2011 16:15:05 +0200
Message-Id: <1310393706-321-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new API to find the common ancestor between two resource
counters. This includes the passed resource counter themselves.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
---
 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 8c421ac..354ed30 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -139,6 +139,8 @@ void res_counter_uncharge_until(struct res_counter *counter, struct res_counter
 				unsigned long val);
 void res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
+struct res_counter *res_counter_common_ancestor(struct res_counter *l, struct res_counter *r);
+
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 39f2513..1b2efd6 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -102,6 +102,25 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
 	res_counter_uncharge_until(counter, NULL, val);
 }
 
+struct res_counter *
+res_counter_common_ancestor(struct res_counter *r1, struct res_counter *r2)
+{
+	struct res_counter *iter;
+
+	while (r1) {
+		iter = r2;
+		while (iter) {
+			if (iter == r1)
+				return iter;
+			iter = iter->parent;
+		}
+
+		r1 = r1->parent;
+	}
+
+	return NULL;
+}
+
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
 {
-- 
1.7.5.4

