Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0ICBhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:37:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57964 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab0ICBhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:37:39 -0400
Message-ID: <4C805293.1020305@cn.fujitsu.com>
Date: Fri, 03 Sep 2010 09:42:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Herbert Xu <herbert@gondor.hengli.com.au>, Dave Jones <davej@redhat.com>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>
Subject: [PATCH v2] cls_cgroup: Fix rcu lockdep warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave reported an rcu lockdep warning on 2.6.35.4 kernel

task->cgroups and task->cgroups->subsys[i] are protected by RCU.
So we avoid accessing invalid pointers here. This might happen,
for example, when you are deref-ing those pointers while someone
move @task from one cgroup to another.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/net/cls_cgroup.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index dd1fdb8..a4dc5b0 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -27,11 +27,17 @@ struct cgroup_cls_state
 #ifdef CONFIG_NET_CLS_CGROUP
 static inline u32 task_cls_classid(struct task_struct *p)
 {
+	int classid;
+
 	if (in_interrupt())
 		return 0;
 
-	return container_of(task_subsys_state(p, net_cls_subsys_id),
-			    struct cgroup_cls_state, css)->classid;
+	rcu_read_lock();
+	classid = container_of(task_subsys_state(p, net_cls_subsys_id),
+			       struct cgroup_cls_state, css)->classid;
+	rcu_read_unlock();
+
+	return classid;
 }
 #else
 extern int net_cls_subsys_id;
-- 
1.6.3

