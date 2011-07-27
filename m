Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1G0WDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:03:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:12903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1G0Vsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258233"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, ak@linux.intel.com,
        mingo@elte.hu, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [42/99] lockdep: Fix lock_is_held() on recursion
Message-Id: <20110727214841.156E72403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d upstream.

The main lock_is_held() user is lockdep_assert_held(), avoid false
assertions in lockdep_off() sections by unconditionally reporting the
lock is taken.

[ the reason this is important is a lockdep_assert_held() in ttwu()
  which triggers a warning under lockdep_off() as in printk() which
  can trigger another wakeup and lock up due to spinlock
  recursion, as reported and heroically debugged by Arne Jansen ]

Reported-and-tested-by: Arne Jansen <lists@die-jansens.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1307398759.2497.966.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/lockdep.c
===================================================================
--- linux-2.6.35.y.orig/kernel/lockdep.c
+++ linux-2.6.35.y/kernel/lockdep.c
@@ -3250,7 +3250,7 @@ int lock_is_held(struct lockdep_map *loc
 	int ret = 0;
 
 	if (unlikely(current->lockdep_recursion))
-		return ret;
+		return 1; /* avoid false negative lockdep_assert_held() */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
