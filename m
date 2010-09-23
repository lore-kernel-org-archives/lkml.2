Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0IWOBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:01:15 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:45578 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab0IWOBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:01:11 -0400
Subject: [RFC][PATCH 03/10] taskstats: Split fill_pid function
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1285249681.1837.28.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 23 Sep 2010 16:01:07 +0200
Message-ID: <1285250467.1837.80.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] taskstats: Split fill_pid function

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Separate the finding of a task_struct by pid or tgid from filling the taskstats
data. This makes the code more readable.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 kernel/taskstats.c |   50 +++++++++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -175,22 +175,8 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
-static int fill_pid(pid_t pid, struct task_struct *tsk,
-		struct taskstats *stats)
+static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
 {
-	int rc = 0;
-
-	if (!tsk) {
-		rcu_read_lock();
-		tsk = find_task_by_vpid(pid);
-		if (tsk)
-			get_task_struct(tsk);
-		rcu_read_unlock();
-		if (!tsk)
-			return -ESRCH;
-	} else
-		get_task_struct(tsk);
-
 	memset(stats, 0, sizeof(*stats));
 	/*
 	 * Each accounting subsystem adds calls to its functions to
@@ -209,17 +195,27 @@ static int fill_pid(pid_t pid, struct ta
 
 	/* fill in extended acct fields */
 	xacct_add_tsk(stats, tsk);
+}
 
-	/* Define err: label here if needed */
-	put_task_struct(tsk);
-	return rc;
+static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
+{
+	struct task_struct *tsk;
 
+	rcu_read_lock();
+	tsk = find_task_by_vpid(pid);
+	if (tsk)
+		get_task_struct(tsk);
+	rcu_read_unlock();
+	if (!tsk)
+		return -ESRCH;
+	fill_stats(tsk, stats);
+	put_task_struct(tsk);
+	return 0;
 }
 
-static int fill_tgid(pid_t tgid, struct task_struct *first,
-		struct taskstats *stats)
+static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
 {
-	struct task_struct *tsk;
+	struct task_struct *tsk, *first;
 	unsigned long flags;
 	int rc = -ESRCH;
 
@@ -228,8 +224,7 @@ static int fill_tgid(pid_t tgid, struct 
 	 * leaders who are already counted with the dead tasks
 	 */
 	rcu_read_lock();
-	if (!first)
-		first = find_task_by_vpid(tgid);
+	first = find_task_by_vpid(tgid);
 
 	if (!first || !lock_task_sighand(first, &flags))
 		goto out;
@@ -268,7 +263,6 @@ out:
 	return rc;
 }
 
-
 static void fill_tgid_exit(struct task_struct *tsk)
 {
 	unsigned long flags;
@@ -477,7 +471,7 @@ static int cmd_attr_pid(struct genl_info
 	if (!stats)
 		goto err;
 
-	rc = fill_pid(pid, NULL, stats);
+	rc = fill_stats_for_pid(pid, stats);
 	if (rc < 0)
 		goto err;
 	return send_reply(rep_skb, info);
@@ -507,7 +501,7 @@ static int cmd_attr_tgid(struct genl_inf
 	if (!stats)
 		goto err;
 
-	rc = fill_tgid(tgid, NULL, stats);
+	rc = fill_stats_for_tgid(tgid, stats);
 	if (rc < 0)
 		goto err;
 	return send_reply(rep_skb, info);
@@ -593,9 +587,7 @@ void taskstats_exit(struct task_struct *
 	if (!stats)
 		goto err;
 
-	rc = fill_pid(-1, tsk, stats);
-	if (rc < 0)
-		goto err;
+	fill_stats(tsk, stats);
 
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving


