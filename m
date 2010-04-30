Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab0D3Q6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:58:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147Ab0D3Q6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:58:35 -0400
Date: Fri, 30 Apr 2010 10:51:54 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, eparis@parisplace.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       eparis@parisplace.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1271880131-3951-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1271880131-3951-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix RCU lockdep splat on freezer_fork path
Message-ID: <tip-8b46f880841aac821af8efa6581bb0e46b8b9845@git.kernel.org>
Git-Commit-ID: 8b46f880841aac821af8efa6581bb0e46b8b9845
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 10:51:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b46f880841aac821af8efa6581bb0e46b8b9845
Gitweb:     http://git.kernel.org/tip/8b46f880841aac821af8efa6581bb0e46b8b9845
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 21 Apr 2010 13:02:08 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 30 Apr 2010 12:03:17 +0200

rcu: Fix RCU lockdep splat on freezer_fork path

Add an RCU read-side critical section to suppress this false
positive.

Located-by: Eric Paris <eparis@parisplace.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: eric.dumazet@gmail.com
LKML-Reference: <1271880131-3951-2-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cgroup_freezer.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index da5e139..e5c0244 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * No lock is needed, since the task isn't on tasklist yet,
 	 * so it can't be moved to another cgroup, which means the
 	 * freezer won't be removed and will be valid during this
-	 * function call.
+	 * function call.  Nevertheless, apply RCU read-side critical
+	 * section to suppress RCU lockdep false positives.
 	 */
+	rcu_read_lock();
 	freezer = task_freezer(task);
+	rcu_read_unlock();
 
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
