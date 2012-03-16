Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2CPTDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:03:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:20115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab2CPTBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="118439715"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/11] futex: Use lockdep_assert_held() for lock checking
Date: Fri, 16 Mar 2012 12:01:00 -0700
Message-Id: <1331924464-18023-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
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

