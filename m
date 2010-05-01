Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab0EAA0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:26:24 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54648 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073Ab0EAA0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:26:20 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Li Zefan <lizf@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 04/10] cgroup: Fix an RCU warning in cgroup_path()
Date: Fri, 30 Apr 2010 17:26:08 -0700
Message-Id: <1272673574-27797-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100501002548.GA27375@linux.vnet.ibm.com>
References: <20100501002548.GA27375@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

with CONFIG_PROVE_RCU=y, a warning can be triggered:

  # mount -t cgroup -o debug xxx /mnt
  # cat /proc/$$/cgroup

...
kernel/cgroup.c:1649 invoked rcu_dereference_check() without protection!
...

This is a false-positive, because cgroup_path() can be called
with either rcu_read_lock() held or cgroup_mutex held.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cgroup.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2769e1..4ca928d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1646,7 +1646,9 @@ static inline struct cftype *__d_cft(struct dentry *dentry)
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 {
 	char *start;
-	struct dentry *dentry = rcu_dereference(cgrp->dentry);
+	struct dentry *dentry = rcu_dereference_check(cgrp->dentry,
+						      rcu_read_lock_held() ||
+						      cgroup_lock_is_held());
 
 	if (!dentry || cgrp == dummytop) {
 		/*
@@ -1662,13 +1664,17 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 	*--start = '\0';
 	for (;;) {
 		int len = dentry->d_name.len;
+
 		if ((start -= len) < buf)
 			return -ENAMETOOLONG;
-		memcpy(start, cgrp->dentry->d_name.name, len);
+		memcpy(start, dentry->d_name.name, len);
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
-		dentry = rcu_dereference(cgrp->dentry);
+
+		dentry = rcu_dereference_check(cgrp->dentry,
+					       rcu_read_lock_held() ||
+					       cgroup_lock_is_held());
 		if (!cgrp->parent)
 			continue;
 		if (--start < buf)
-- 
1.7.0

