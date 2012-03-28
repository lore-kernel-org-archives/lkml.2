Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab2C1Ati (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:49:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:51109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab2C1Ark (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125867362"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/13] futex: Use lockdep_assert_held() for lock checking
Date: Tue, 27 Mar 2012 17:47:11 -0700
Message-Id: <1332895637-32572-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use lockdep_assert_held() for lock checking instead of a strange
homegrown variant. This removes the return for this case, but
that is unlikely to be useful anyways.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/futex.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 1614be2..a77dda7 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -823,8 +823,9 @@ static void __unqueue_futex(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
-	    || WARN_ON(plist_node_empty(&q->list)))
+	if (q->lock_ptr)
+		lockdep_assert_held(q->lock_ptr);
+	if (WARN_ON(plist_node_empty(&q->list)))
 		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
-- 
1.7.7.6

