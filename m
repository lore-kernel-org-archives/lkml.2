Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab1AKKNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:13:08 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53104 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1AKKNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:13:04 -0500
Date: Tue, 11 Jan 2011 15:42:57 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -tip 2/2] sched: Display autogroup names in /proc/sched_debug.
Message-ID: <20110111101257.GF4772@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110111101040.GD4772@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111101040.GD4772@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Display autogroup names in /proc/sched_debug.

Add autogroup name to cfs_rq and tasks information in /proc/sched_debug.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched_autogroup.c |    5 +++++
 kernel/sched_debug.c     |    3 +++
 2 files changed, 8 insertions(+)

--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -231,6 +231,11 @@ void proc_sched_autogroup_show_task(stru
 #ifdef CONFIG_SCHED_DEBUG
 static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	if (!enabled || !tg->autogroup)
+	       return 0;
+
 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
 }
 #endif /* CONFIG_SCHED_DEBUG */
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -93,6 +93,9 @@ static char group_path[PATH_MAX];
 
 static char * task_group_path(struct task_group *tg)
 {
+	if (autogroup_path(tg, group_path, PATH_MAX))
+		return group_path;
+
 	/*
 	 * May be NULL if the underlying cgroup isn't fully-created yet
 	 */
