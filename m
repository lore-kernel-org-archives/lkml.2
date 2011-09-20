Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1ITOnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:43:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab1ITOnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:43:52 -0400
Date: Tue, 20 Sep 2011 16:39:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] creds: __task_cred(current) doesn't need
	rcu_read_lock_held()
Message-ID: <20110920143959.GC15859@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110920122202.GA26504@redhat.com> <20110920124419.GA10759@hallyn.com> <20110920134108.GA30749@redhat.com> <20110920143920.GA15859@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920143920.GA15859@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change __task_cred(task) to accept "task == current" without
rcu_read_lock_held(). This is what current_cred() currently does,
and with this change __task_cred() becomes more flexible/usable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cred.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- 3.1/include/linux/cred.h~2_task_cred_ck_current	2011-09-20 16:28:47.000000000 +0200
+++ 3.1/include/linux/cred.h	2011-09-20 16:33:12.000000000 +0200
@@ -268,8 +268,7 @@ static inline void put_cred(const struct
  * Access the subjective credentials of the current task.  RCU-safe,
  * since nobody else can modify it.
  */
-#define current_cred() \
-	rcu_dereference_protected(current->cred, 1)
+#define current_cred()	__task_cred(current)
 
 /**
  * __task_cred - Access a task's objective credentials
@@ -284,7 +283,7 @@ static inline void put_cred(const struct
 #define __task_cred(task)						\
 	({								\
 		const struct task_struct *__t = (task);			\
-		rcu_dereference_check(__t->real_cred, 0);		\
+		rcu_dereference_check(__t->real_cred, (__t == current));\
 	})
 
 /**

