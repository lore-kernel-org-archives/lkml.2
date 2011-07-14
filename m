Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1GNNTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:19:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50783 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab1GNNTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:19:14 -0400
Date: Thu, 14 Jul 2011 15:19:09 +0200
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lockdep: Clear whole lockdep_map on initialization
Message-ID: <20110714131909.GJ3455@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep_init_map() only initializes parts of lockdep_map and triggers
kmemcheck warning when it is copied as a whole.  There isn't anything
to be gained by clearing selectively.  memset() the whole structure
and remove loop for ->class_cache[] clearing.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-tested-by: Christian Casteyde <casteyde.christian@free.fr>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=35532
---
 kernel/lockdep.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 298c927..7b9b4f1 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2859,10 +2859,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
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
