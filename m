Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1CJS6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:58:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:44798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab1CJS6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:58:10 -0500
Date: Thu, 10 Mar 2011 18:57:47 GMT
From: tip-bot for Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, walken@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, walken@google.com
In-Reply-To: <20110307020750.GA31188@google.com>
References: <20110307020750.GA31188@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex: Update futex_wait_setup comments about locking
Message-ID: <tip-8fe8f545c6d753ead15e1f4919d39e8f9bb49629@git.kernel.org>
Git-Commit-ID: 8fe8f545c6d753ead15e1f4919d39e8f9bb49629
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Mar 2011 18:57:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fe8f545c6d753ead15e1f4919d39e8f9bb49629
Gitweb:     http://git.kernel.org/tip/8fe8f545c6d753ead15e1f4919d39e8f9bb49629
Author:     Michel Lespinasse <walken@google.com>
AuthorDate: Sun, 6 Mar 2011 18:07:50 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Mar 2011 19:56:18 +0100

futex: Update futex_wait_setup comments about locking

Reviving a cleanup I had done about a year ago as part of a larger
futex_set_wait proposal. Over the years, the locking of the hashed
futex queue got improved, so that some of the "rare but normal" race
conditions described in comments can't actually happen anymore.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110307020750.GA31188@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
