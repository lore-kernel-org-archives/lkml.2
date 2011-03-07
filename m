Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1CGCIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:08:00 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41210 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1CGCH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:07:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Kzu6O2r7fGBs1fFO+J3hVCwa+OSAdYgaMV8Q67a5iMejJU3ghM3NHj6TG6k7BgRMc9
         6/yS2v8roLszBMEcQBNQ==
Date: Sun, 6 Mar 2011 18:07:50 -0800
From: Michel Lespinasse <walken@google.com>
To: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] futex: update futex_wait_setup comments about locking
Message-ID: <20110307020750.GA31188@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviving a cleanup I had done about a year ago as part of a larger
futex_set_wait proposal. Over the years, the locking of the hashed
futex queue got improved, so that some of the "rare but normal" race
conditions described in comments can't actually happen anymore.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 kernel/futex.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b766d28..3184d3b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1781,13 +1781,14 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	 *
 	 * The basic logical guarantee of a futex is that it blocks ONLY
 	 * if cond(var) is known to be true at the time of blocking, for
-	 * any cond.  If we queued after testing *uaddr, that would open
-	 * a race condition where we could block indefinitely with
+	 * any cond.  If we locked the hash-bucket after testing *uaddr, that
+	 * would open a race condition where we could block indefinitely with
 	 * cond(var) false, which would violate the guarantee.
 	 *
-	 * A consequence is that futex_wait() can return zero and absorb
-	 * a wakeup when *uaddr != val on entry to the syscall.  This is
-	 * rare, but normal.
+	 * On the other hand, we insert q and release the hash-bucket only
+	 * after testing *uaddr.  This guarantees that futex_wait() will NOT
+	 * absorb a wakeup if *uaddr does not match the desired values
+	 * while the syscall executes.
 	 */
 retry:
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
