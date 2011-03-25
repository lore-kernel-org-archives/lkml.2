Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934457Ab1CYKtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:49:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:54400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934195Ab1CYKty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:49:54 -0400
Date: Fri, 25 Mar 2011 10:49:19 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dvhart@linux.intel.com, peterz@infradead.org, richard@nod.at,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, peterz@infradead.org, richard@nod.at,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <20110317192208.682654502@goodmis.org>
References: <20110317192208.682654502@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Fix WARN_ON() test for UP
Message-ID: <tip-29096202176ceaa5016a17ea2dd1aea19a4e90e2@git.kernel.org>
Git-Commit-ID: 29096202176ceaa5016a17ea2dd1aea19a4e90e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Mar 2011 10:49:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29096202176ceaa5016a17ea2dd1aea19a4e90e2
Gitweb:     http://git.kernel.org/tip/29096202176ceaa5016a17ea2dd1aea19a4e90e2
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 17 Mar 2011 15:21:07 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 25 Mar 2011 11:32:11 +0100

futex: Fix WARN_ON() test for UP

An update of the futex code had a

	WARN_ON(!spin_is_locked(q->lock_ptr))

But on UP, spin_is_locked() is always false, and will
trigger this warning, and even worse, it will exit the function
without doing the necessary work.

Converting this to a WARN_ON_SMP() fixes the problem.

Reported-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Darren Hart <dvhart@linux.intel.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <20110317192208.682654502@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/futex.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index bda4157..823aae3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -782,8 +782,8 @@ static void __unqueue_futex(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
-			|| plist_node_empty(&q->list)))
+	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
+	    || WARN_ON(plist_node_empty(&q->list)))
 		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
