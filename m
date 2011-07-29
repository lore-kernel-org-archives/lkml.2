Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab1G2QNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:13:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39536 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1G2QNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:13:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/8] cgroups: New resource counter inheritance API
Date: Fri, 29 Jul 2011 18:13:24 +0200
Message-Id: <1311956010-32076-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an API to inherit a counter value from a parent.
This can be useful to implement cgroup.clone_children on
a resource counter.

Still the resources of the children are limited by those
of the parent, so this is only to provide a default setting
behaviour when clone_children is set.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   12 ++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 1b3fe05..109d118 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -84,6 +84,8 @@ int res_counter_write(struct res_counter *counter, int member,
 
 void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
 
+void res_counter_inherit(struct res_counter *counter, int member);
+
 /*
  * the field descriptors. one for each member of res_counter
  */
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 806d041..10a901b 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -198,3 +198,15 @@ int res_counter_write(struct res_counter *counter, int member,
 
 	return 0;
 }
+
+void res_counter_inherit(struct res_counter *counter, int member)
+{
+	struct res_counter *parent;
+	unsigned long long val;
+
+	parent = counter->parent;
+	if (parent) {
+		val = res_counter_read_u64(parent, member);
+		res_counter_write_u64(counter, member, val);
+	}
+}
-- 
1.7.5.4

