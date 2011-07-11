Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab1GKSWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:22:32 -0400
Received: from mail-gx0-f194.google.com ([209.85.161.194]:46967 "EHLO
	mail-gx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1GKSWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:22:30 -0400
MIME-Version: 1.0
Date: Mon, 11 Jul 2011 11:04:58 -0700
Message-ID: <CAFR8ueftOQQW7+5eEYNEpfL0AxhihjXeM=AuzJ+L4RrXO_N8Ew@mail.gmail.com>
Subject: [PATCH]:Documentation/spinlocks.txt: Remove reference to sti()/cli()
From: Muthu Kumar <muthu.lkml@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
Since we removed sti()/cli() and related, how about removing it from
Documentation/spinlocks.txt?

Signed-off-by: Muthukumar R <muthur@gmail.com>

-------------------------
 Documentation/spinlocks.txt |   45 ++++++------------------------------------
 fs/mpage.c                  |    2 +
 2 files changed, 9 insertions(+), 38 deletions(-)
-------------------------
diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
index 2e3c64b..43cd060 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/spinlocks.txt
@@ -13,18 +13,8 @@ static DEFINE_SPINLOCK(xxx_lock);
 The above is always safe. It will disable interrupts _locally_, but the
 spinlock itself will guarantee the global lock, so it will guarantee that
 there is only one thread-of-control within the region(s) protected by that
-lock. This works well even under UP. The above sequence under UP
-essentially is just the same as doing
-
-	unsigned long flags;
-
-	save_flags(flags); cli();
-	 ... critical section ...
-	restore_flags(flags);
-
-so the code does _not_ need to worry about UP vs SMP issues: the spinlocks
-work correctly under both (and spinlocks are actually more efficient on
-architectures that allow doing the "save_flags + cli" in one operation).
+lock. This works well even under UP also, so the code does _not_ need to
+worry about UP vs SMP issues: the spinlocks work correctly under both.

    NOTE! Implications of spin_locks for memory are further described in:

@@ -36,27 +26,7 @@ The above is usually pretty simple (you usually
need and want only one
 spinlock for most things - using more than one spinlock can make things a
 lot more complex and even slower and is usually worth it only for
 sequences that you _know_ need to be split up: avoid it at all cost if you
-aren't sure). HOWEVER, it _does_ mean that if you have some code that does
-
-	cli();
-	.. critical section ..
-	sti();
-
-and another sequence that does
-
-	spin_lock_irqsave(flags);
-	.. critical section ..
-	spin_unlock_irqrestore(flags);
-
-then they are NOT mutually exclusive, and the critical regions can happen
-at the same time on two different CPU's. That's fine per se, but the
-critical regions had better be critical for different things (ie they
-can't stomp on each other).
-
-The above is a problem mainly if you end up mixing code - for example the
-routines in ll_rw_block() tend to use cli/sti to protect the atomicity of
-their actions, and if a driver uses spinlocks instead then you should
-think about issues like the above.
+aren't sure).

 This is really the only really hard part about spinlocks: once you start
 using spinlocks they tend to expand to areas you might not have noticed
@@ -120,11 +90,10 @@ Lesson 3: spinlocks revisited.

 The single spin-lock primitives above are by no means the only ones. They
 are the most safe ones, and the ones that work under all circumstances,
-but partly _because_ they are safe they are also fairly slow. They are
-much faster than a generic global cli/sti pair, but slower than they'd
-need to be, because they do have to disable interrupts (which is just a
-single instruction on a x86, but it's an expensive one - and on other
-architectures it can be worse).
+but partly _because_ they are safe they are also fairly slow. They are slower
+than they'd need to be, because they do have to disable interrupts
+(which is just a single instruction on a x86, but it's an expensive one -
+and on other architectures it can be worse).

 If you have a case where you have to protect a data structure across
 several CPU's and you want to use spinlocks you can potentially use
