Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1ARTFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:05:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:52971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab1ARTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:05:42 -0500
Date: Tue, 18 Jan 2011 19:05:04 GMT
From: tip-bot for Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bharata@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110111101257.GF4772@in.ibm.com>
References: <20110111101257.GF4772@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Display autogroup names in /proc/sched_debug
Message-ID: <tip-8ecedd7a06d27a31dbb36fab88e2ba6e6edd43ca@git.kernel.org>
Git-Commit-ID: 8ecedd7a06d27a31dbb36fab88e2ba6e6edd43ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:05:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ecedd7a06d27a31dbb36fab88e2ba6e6edd43ca
Gitweb:     http://git.kernel.org/tip/8ecedd7a06d27a31dbb36fab88e2ba6e6edd43ca
Author:     Bharata B Rao <bharata@linux.vnet.ibm.com>
AuthorDate: Tue, 11 Jan 2011 15:42:57 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 15:09:40 +0100

sched: Display autogroup names in /proc/sched_debug

Add autogroup name to cfs_rq and tasks information to /proc/sched_debug.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110111101257.GF4772@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_autogroup.c |    5 +++++
 kernel/sched_debug.c     |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 32a723b..938d52f 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -231,6 +231,11 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 #ifdef CONFIG_SCHED_DEBUG
 static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	if (!enabled || !tg->autogroup)
+		return 0;
+
 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
 }
 #endif /* CONFIG_SCHED_DEBUG */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 4d36f37..e4d3725 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -93,6 +93,9 @@ static char group_path[PATH_MAX];
 
 static char *task_group_path(struct task_group *tg)
 {
+	if (autogroup_path(tg, group_path, PATH_MAX))
+		return group_path;
+
 	/*
 	 * May be NULL if the underlying cgroup isn't fully-created yet
 	 */
