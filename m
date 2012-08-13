Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2HMQvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:51:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2HMQvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:51:36 -0400
Date: Mon, 13 Aug 2012 09:51:21 -0700
From: tip-bot for Mike Galbraith <efault@gmx.de>
Message-ID: <tip-35cf4e50b16331def6cfcbee11e49270b6db07f5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de
In-Reply-To: <1344308413.6846.7.camel@marge.simpson.net>
References: <1344308413.6846.7.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched,cgroup: Fix up task_groups list
Git-Commit-ID: 35cf4e50b16331def6cfcbee11e49270b6db07f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 09:51:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35cf4e50b16331def6cfcbee11e49270b6db07f5
Gitweb:     http://git.kernel.org/tip/35cf4e50b16331def6cfcbee11e49270b6db07f5
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 7 Aug 2012 05:00:13 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 18:41:54 +0200

sched,cgroup: Fix up task_groups list

With multiple instances of task_groups, for_each_rt_rq() is a noop,
no task groups having been added to the rt.c list instance.  This
renders __enable/disable_runtime() and print_rt_stats() noop, the
user (non) visible effect being that rt task groups are missing in
/proc/sched_debug.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: stable@kernel.org # v3.3+
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344308413.6846.7.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/sched.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e2c5841..6aa212f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7252,6 +7252,7 @@ int in_sched_functions(unsigned long addr)
 
 #ifdef CONFIG_CGROUP_SCHED
 struct task_group root_task_group;
+LIST_HEAD(task_groups);
 #endif
 
 DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 531411b..f6714d0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -80,7 +80,7 @@ extern struct mutex sched_domains_mutex;
 struct cfs_rq;
 struct rt_rq;
 
-static LIST_HEAD(task_groups);
+extern struct list_head task_groups;
 
 struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH
