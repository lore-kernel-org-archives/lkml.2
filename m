Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1DHNUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:20:18 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:47670 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1DHNUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:20:16 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Q. lockdep_assert_held() and lockdep_off/on()
Date: Fri, 08 Apr 2011 22:19:49 +0900
Message-ID: <9752.1302268789@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Peter Zijlstra and Ingo Molnar,

May I ask you a question about the commit
	f607c66 2009-08-02 lockdep: Introduce lockdep_assert_held()

In short, should lockdep_assert_held() support ->lockdep_recursion?

Its current definition is
#define lockdep_assert_held(l) WARN_ON(debug_locks && !lockdep_is_held(l))

When someone somewhere calls lockdep_off() and executes some memory
allocation or something, then the functions to shrink dentry cache
happens to run. And cond_resched_lock() in __shrink_dcache_sb() may
produce a false warning.

fs/dcache.c:
__shrink_dcache_sb()
{
	:::
	spin_lock(&dcache_lru_lock);
	while (...) {
		:::
		cond_resched_lock(&dcache_lru_lock);
		:::
	}
	:::
}

The function __shrink_dcache_sb() acquires dcache_lru_lock correctly and
comfirms it by cond_resched_lock() which calls lockdep_assert_held().
When the caller already called lockdep_off(), lock_is_held() always
return 0 which leads to WARN_ON(true). Obviously the warning is false
positive.

Setting FALSE to debug_locks may be one solution, but this variable
doesn't seem to expect to return to TRUE. So it is better for
lockdep_assert_held() to test ->lockdep_recursion too I think.

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 413c754..8658138 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -341,7 +341,9 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
-#define lockdep_assert_held(l)	WARN_ON_ONCE(debug_locks && !lockdep_is_held(l))
+#define lockdep_assert_held(l)	WARN_ON_ONCE(debug_locks \
+					     && !current->lockdep_recursion \
+					     && !lockdep_is_held(l))
 
 #else /* !LOCKDEP */
 

J. R. Okajima
