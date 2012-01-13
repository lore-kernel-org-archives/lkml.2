Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab2AMSPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:15:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63931 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758681Ab2AMSPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:15:23 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <htejun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/8] cgroups: add res counter common ancestor searching
Date: Fri, 13 Jan 2012 19:13:52 +0100
Message-Id: <1326478441-3048-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

Add a new API to find the common ancestor between two resource counters.
This includes the passed resource counter themselves.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/res_counter.h |    3 +++
 kernel/res_counter.c        |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index de4ba29..558f39b 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -147,6 +147,9 @@ static inline void res_counter_uncharge(struct res_counter *counter,
 	res_counter_uncharge_until(counter, NULL, val);
 }
 
+struct res_counter *res_counter_common_ancestor(struct res_counter *l,
+						struct res_counter *r);
+
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 8ef09a4..86d72b8 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -91,6 +91,39 @@ void res_counter_uncharge_until(struct res_counter *counter,
 	local_irq_restore(flags);
 }
 
+/*
+ * Walk through r1 and r2 parents and try to find the closest common one
+ * between both. If none is found, it returns NULL.
+ */
+struct res_counter *
+res_counter_common_ancestor(struct res_counter *r1, struct res_counter *r2)
+{
+	struct res_counter *iter;
+	int r1_depth = 0, r2_depth = 0;
+
+	for (iter = r1; iter; iter = iter->parent)
+		r1_depth++;
+
+	for (iter = r2; iter; iter = iter->parent)
+		r2_depth++;
+
+	while (r1_depth > r2_depth) {
+		r1 = r1->parent;
+		r1_depth--;
+	}
+
+	while (r2_depth > r1_depth) {
+		r2 = r2->parent;
+		r2_depth--;
+	}
+
+	while (r1 != r2) {
+		r1 = r1->parent;
+		r2 = r2->parent;
+	}
+
+	return r1;
+}
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
-- 
1.7.5.4

