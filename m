Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab0KROJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:09:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:41390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291Ab0KROJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:09:24 -0500
Date: Thu, 18 Nov 2010 14:08:58 GMT
From: tip-bot for Nikhil Rao <ncrao@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ncrao@google.com, alex.shi@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ncrao@google.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        alex.shi@intel.com, mingo@elte.hu
In-Reply-To: <1290022924-3548-1-git-send-email-ncrao@google.com>
References: <1290022924-3548-1-git-send-email-ncrao@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix idle balancing
Message-ID: <tip-d5ad140bc1505a98c0f040937125bfcbb508078f@git.kernel.org>
Git-Commit-ID: d5ad140bc1505a98c0f040937125bfcbb508078f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:08:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5ad140bc1505a98c0f040937125bfcbb508078f
Gitweb:     http://git.kernel.org/tip/d5ad140bc1505a98c0f040937125bfcbb508078f
Author:     Nikhil Rao <ncrao@google.com>
AuthorDate: Wed, 17 Nov 2010 11:42:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:12:33 +0100

sched: Fix idle balancing

An earlier commit reverts idle balancing throttling reset to fix a 30%
regression in volanomark throughput. We still need to reset idle_stamp
when we pull a task in newidle balance.

Reported-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290022924-3548-1-git-send-email-ncrao@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ba0556d..00ebd76 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3215,8 +3215,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task)
+		if (pulled_task) {
+			this_rq->idle_stamp = 0;
 			break;
+		}
 	}
 
 	raw_spin_lock(&this_rq->lock);
