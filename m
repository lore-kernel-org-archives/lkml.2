Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1FFWPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:15:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:49978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1FFWPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:15:49 -0400
Subject: [PATCH] lockdep: Fix lock_is_held on recursion
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 00:19:19 +0200
Message-ID: <1307398759.2497.966.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: Fix lock_is_held on recursion
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jun 06 12:32:43 CEST 2011

The main lock_is_held() user is lockdep_assert_held(), avoid false
assertions in lockdep_off() sections by unconditionally reporting the
lock is taken.

[ the reason this is important is a lockdep_assert_held() in ttwu()
  which triggers a warning under lockdep_off() as in printk() which
  can trigger another wakeup and lock up due to spinlock recursion ]

Reported-and-tested-by: Arne Jansen <lists@die-jansens.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -3426,7 +3426,7 @@ int lock_is_held(struct lockdep_map *loc
 	int ret = 0;
 
 	if (unlikely(current->lockdep_recursion))
-		return ret;
+		return 1; /* avoid false negative lockdep_assert_held */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);


