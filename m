Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab1ADIR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:17:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49995 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1ADIRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:17:55 -0500
Message-ID: <4D22D7BE.4070702@cn.fujitsu.com>
Date: Tue, 04 Jan 2011 16:18:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Paul Menage <menage@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] cgroups: fix incorrect using rcu_dereference() in
 cgroup_subsys_state()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:17:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:17:28,
	Serialize complete at 2011-01-04 16:17:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Mon, 25 Aug 2008 11:05:28 +0800
(Original) Subject: [PATCH] cgroup: fix wrong rcu_dereference()

It is tsk->cgroups which is protected by RCU, not ->subsys[subsys_id].

laijs: updated it(the surrounding code have been changed since these two years).

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ed4ba11..a798814 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -535,10 +535,11 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
  * cgroup_subsys::attach() methods.
  */
 #define task_subsys_state_check(task, subsys_id, __c)			\
-	rcu_dereference_check(task->cgroups->subsys[subsys_id],		\
+	rcu_dereference_check(task->cgroups,				\
 			      rcu_read_lock_held() ||			\
 			      lockdep_is_held(&task->alloc_lock) ||	\
-			      cgroup_lock_is_held() || (__c))
+			      cgroup_lock_is_held() ||			\
+			      (__c))->subsys[subsys_id]
 
 static inline struct cgroup_subsys_state *
 task_subsys_state(struct task_struct *task, int subsys_id)
