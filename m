Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1AZMMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:12:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:39732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1AZMMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:12:00 -0500
Date: Wed, 26 Jan 2011 12:11:28 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110122044852.102126037@google.com>
References: <20110122044852.102126037@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Avoid expensive initial update_cfs_load()
Message-ID: <tip-f07333bf6ee66d9b49286cec4371cf375e745b7a@git.kernel.org>
Git-Commit-ID: f07333bf6ee66d9b49286cec4371cf375e745b7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:11:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f07333bf6ee66d9b49286cec4371cf375e745b7a
Gitweb:     http://git.kernel.org/tip/f07333bf6ee66d9b49286cec4371cf375e745b7a
Author:     Paul Turner <pjt@google.com>
AuthorDate: Fri, 21 Jan 2011 20:45:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:19 +0100

sched: Avoid expensive initial update_cfs_load()

Since cfs->{load_stamp,load_last} are zero-initalized the initial load update
will consider the delta to be 'since the beginning of time'.

This results in a lot of pointless divisions to bring this large period to be
within the sysctl_sched_shares_window.

Fix this by initializing load_stamp to be 1 at cfs_rq initialization, this
allows for an initial load_stamp > load_last which then lets standard idle
truncation proceed.

We avoid spinning (and slightly improve consistency) by fixing delta to be
[period - 1] in this path resulting in a slightly more predictable shares ramp.
(Previously the amount of idle time preserved by the overflow would range between
[period/2,period-1].)

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110122044852.102126037@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    2 ++
 kernel/sched_fair.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e0fa3ff..6820b5b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7796,6 +7796,8 @@ static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 	INIT_LIST_HEAD(&cfs_rq->tasks);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
+	/* allow initial update_cfs_load() to truncate */
+	cfs_rq->load_stamp = 1;
 #endif
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0c550c8..4cbc912 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -733,6 +733,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 	    now - cfs_rq->load_last > 4 * period) {
 		cfs_rq->load_period = 0;
 		cfs_rq->load_avg = 0;
+		delta = period - 1;
 	}
 
 	cfs_rq->load_stamp = now;
