Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0DVJ1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 05:27:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56858 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab0DVJ1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 05:27:38 -0400
Message-ID: <4BD016F4.8060108@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 17:29:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "containers@lists.osdl.org" <containers@lists.osdl.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] cgroup: Fix an RCU warning in cgroup_path()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with CONFIG_PROVE_RCU=y, a warning can be triggered:

  # mount -t cgroup -o debug xxx /mnt
  # cat /proc/$$/cgroup

...
kernel/cgroup.c:1649 invoked rcu_dereference_check() without protection!
...

This is a false-positive, because cgroup_path() can be called
with either rcu_read_lock() held or cgroup_mutex held.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.6.3

