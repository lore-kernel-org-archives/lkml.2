Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2FNLxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:53:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36554 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab2FNLxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:53:14 -0400
From: Alexander Block <ablock84@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: jengelh@medozas.de, paulmck@linux.vnet.ibm.com,
        Alexander Block <ablock84@googlemail.com>
Subject: [PATCH] rcu: remove unused __kfree_rcu inline functions
Date: Thu, 14 Jun 2012 13:53:14 +0200
Message-Id: <1339674794-17517-1-git-send-email-ablock84@googlemail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch "rcu: Make __kfree_rcu() less dependent on compiler choice"
from Jan Engelhardt intended to replace the inline functions
__kfree_rcu and __is_kfree_rcu_offset with macros.

Unfortunately, the patch only added the new macros but did not
remove the old inline functions. This patch removes them finally.

With the unused functions still being around, module builds with
-O0 still fail.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 include/linux/rcupdate.h |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 26d1a47..0ae2c55 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -906,24 +906,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
 
-static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
-{
-	return offset < 4096;
-}
-
-static __always_inline
-void __kfree_rcu(struct rcu_head *head, unsigned long offset)
-{
-	typedef void (*rcu_callback)(struct rcu_head *);
-
-	BUILD_BUG_ON(!__builtin_constant_p(offset));
-
-	/* See the kfree_rcu() header comment. */
-	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
-
-	kfree_call_rcu(head, (rcu_callback)offset);
-}
-
 /*
  * Does the specified offset indicate that the corresponding rcu_head
  * structure can be handled by kfree_rcu()?
-- 
1.7.10

