Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1GAPP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:15:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:33033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab1GAPP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:15:58 -0400
Date: Fri, 1 Jul 2011 15:15:31 GMT
From: tip-bot for Mike Galbraith <mgalbraith@suse.de>
Message-ID: <tip-cd62287e364c0d15d517c6ced4e4808b54711475@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mgalbraith@suse.de, hpa@zytor.com,
        mingo@redhat.com, ncrao@google.com, a.p.zijlstra@chello.nl,
        efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, ncrao@google.com,
        efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1307192600.8618.3.camel@marge.simson.net>
References: <1307192600.8618.3.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, cgroups: Fix MIN_SHARES on 64-bit boxen
Git-Commit-ID: cd62287e364c0d15d517c6ced4e4808b54711475
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:15:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd62287e364c0d15d517c6ced4e4808b54711475
Gitweb:     http://git.kernel.org/tip/cd62287e364c0d15d517c6ced4e4808b54711475
Author:     Mike Galbraith <mgalbraith@suse.de>
AuthorDate: Sat, 4 Jun 2011 15:03:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 10:25:03 +0200

sched, cgroups: Fix MIN_SHARES on 64-bit boxen

Commit c8b28116 ("sched: Increase SCHED_LOAD_SCALE resolution")
intended to have no user-visible effect, but allows setting
cpu.shares to < MIN_SHARES, which the user then sees.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nikhil Rao <ncrao@google.com>
Link: http://lkml.kernel.org/r/1307192600.8618.3.camel@marge.simson.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3f2e502..9769c75 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -292,8 +292,8 @@ static DEFINE_SPINLOCK(task_group_lock);
  * (The default weight is 1024 - so there's no practical
  *  limitation from this.)
  */
-#define MIN_SHARES	2
-#define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))
+#define MIN_SHARES	(1UL <<  1)
+#define MAX_SHARES	(1UL << 18)
 
 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
@@ -8450,10 +8450,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	if (!tg->se[0])
 		return -EINVAL;
 
-	if (shares < MIN_SHARES)
-		shares = MIN_SHARES;
-	else if (shares > MAX_SHARES)
-		shares = MAX_SHARES;
+	shares = clamp(shares, scale_load(MIN_SHARES), scale_load(MAX_SHARES));
 
 	mutex_lock(&shares_mutex);
 	if (tg->shares == shares)
