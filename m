Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0ECSxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:53:33 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41093 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab0ECSx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:53:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Li Zefan <lizf@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 05/10] cgroup: Fix an RCU warning in alloc_css_id()
Date: Mon,  3 May 2010 11:53:14 -0700
Message-Id: <1272912799-17859-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100503185253.GA17672@linux.vnet.ibm.com>
References: <20100503185253.GA17672@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

With CONFIG_PROVE_RCU=y, a warning can be triggered:

  # mount -t cgroup -o memory xxx /mnt
  # mkdir /mnt/0

...
kernel/cgroup.c:4442 invoked rcu_dereference_check() without protection!
...

This is a false-positive. It's safe to directly access parent_css->id.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4ca928d..3a53c77 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4561,13 +4561,13 @@ static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
 {
 	int subsys_id, i, depth = 0;
 	struct cgroup_subsys_state *parent_css, *child_css;
-	struct css_id *child_id, *parent_id = NULL;
+	struct css_id *child_id, *parent_id;
 
 	subsys_id = ss->subsys_id;
 	parent_css = parent->subsys[subsys_id];
 	child_css = child->subsys[subsys_id];
-	depth = css_depth(parent_css) + 1;
 	parent_id = parent_css->id;
+	depth = parent_id->depth;
 
 	child_id = get_new_cssid(ss, depth);
 	if (IS_ERR(child_id))
-- 
1.7.0

