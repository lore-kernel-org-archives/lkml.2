Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1HDIgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:36:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:36330 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1HDIgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:36:04 -0400
Date: Thu, 4 Aug 2011 08:35:46 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-f59de8992aa6dc85e81aadc26b0f69e17809721d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
        casteyde.christian@free.fr, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
        casteyde.christian@free.fr, mingo@elte.hu
In-Reply-To: <20110714131909.GJ3455@htj.dyndns.org>
References: <20110714131909.GJ3455@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Clear whole lockdep_map on initialization
Git-Commit-ID: f59de8992aa6dc85e81aadc26b0f69e17809721d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Aug 2011 08:35:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f59de8992aa6dc85e81aadc26b0f69e17809721d
Gitweb:     http://git.kernel.org/tip/f59de8992aa6dc85e81aadc26b0f69e17809721d
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 14 Jul 2011 15:19:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Aug 2011 10:17:56 +0200

lockdep: Clear whole lockdep_map on initialization

lockdep_init_map() only initializes parts of lockdep_map and triggers
kmemcheck warning when it is copied as a whole.  There isn't anything
to be gained by clearing selectively.  memset() the whole structure
and remove loop for ->class_cache[] clearing.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=35532

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-tested-by: Christian Casteyde <casteyde.christian@free.fr>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=35532
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110714131909.GJ3455@htj.dyndns.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5903586..8c24294 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2874,10 +2874,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	int i;
-
-	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
-		lock->class_cache[i] = NULL;
+	memset(lock, 0, sizeof(*lock));
 
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();
