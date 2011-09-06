Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1IFAOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 20:14:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53534 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1IFAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 20:14:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/12] cgroups: Add res counter common ancestor searching
Date: Tue,  6 Sep 2011 02:13:00 +0200
Message-Id: <1315267986-28937-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new API to find the common ancestor between two resource
counters. This includes the passed resource counter themselves.

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
---
 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 95e7756..f545548 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -146,6 +146,8 @@ static inline void res_counter_uncharge(struct res_counter *counter, unsigned lo
 	res_counter_uncharge_until(counter, NULL, val);
 }
 
+struct res_counter *res_counter_common_ancestor(struct res_counter *l, struct res_counter *r);
+
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 1185c86..67a9ae4 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -92,6 +92,25 @@ void res_counter_uncharge_until(struct res_counter *counter,
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

