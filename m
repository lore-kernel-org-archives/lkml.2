Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1HIOaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:30:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab1HIOaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:30:14 -0400
Date: Tue, 9 Aug 2011 14:30:02 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-80e0401e35410a69bfae05b454db8a7187edd6b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sergey.senozhatsky@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sergey.senozhatsky@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1312547787.28695.2.camel@twins>
References: <1312547787.28695.2.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Fix wrong assumption in match_held_lock
Git-Commit-ID: 80e0401e35410a69bfae05b454db8a7187edd6b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Aug 2011 14:30:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80e0401e35410a69bfae05b454db8a7187edd6b8
Gitweb:     http://git.kernel.org/tip/80e0401e35410a69bfae05b454db8a7187edd6b8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Aug 2011 14:26:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 9 Aug 2011 11:57:35 +0200

lockdep: Fix wrong assumption in match_held_lock

match_held_lock() was assuming it was being called on a lock class
that had already seen usage.

This condition was true for bug-free code using lockdep_assert_held(),
since you're in fact holding the lock when calling it. However the
assumption fails the moment you assume the assertion can fail, which
is the whole point of having the assertion in the first place.

Anyway, now that there's more lockdep_is_held() users, notably
__rcu_dereference_check(), its much easier to trigger this since we
test for a number of locks and we only need to hold any one of them to
be good.

Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1312547787.28695.2.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8c24294..91d67ce 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3111,7 +3111,13 @@ static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
 		if (!class)
 			class = look_up_lock_class(lock, 0);
 
-		if (DEBUG_LOCKS_WARN_ON(!class))
+		/*
+		 * If look_up_lock_class() failed to find a class, we're trying
+		 * to test if we hold a lock that has never yet been acquired.
+		 * Clearly if the lock hasn't been acquired _ever_, we're not
+		 * holding it either, so report failure.
+		 */
+		if (!class)
 			return 0;
 
 		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
