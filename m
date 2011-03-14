Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1CNURj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:17:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:57906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1CNURh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:17:37 -0400
Date: Mon, 14 Mar 2011 20:15:46 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
        peterz@infradead.org, cmetcalf@tilera.com, tony.luck@intel.com,
        ralf@linux-mips.org, monstr@monstr.eu, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        darren@dvhart.com, lethal@linux-sh.org, davem@davemloft.net,
        dhowells@redhat.com, benh@kernel.crashing.org, mattst88@gmail.com,
        jejb@parisc-linux.org, walken@google.com
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org,
        peterz@infradead.org, schwidefsky@de.ibm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, linux@arm.linux.org.uk, ralf@linux-mips.org,
        monstr@monstr.eu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, darren@dvhart.com, lethal@linux-sh.org,
        davem@davemloft.net, dhowells@redhat.com, benh@kernel.crashing.org,
        jejb@parisc-linux.org, mattst88@gmail.com, walken@google.com
In-Reply-To: <alpine.LFD.2.00.1103141126590.2787@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103141126590.2787@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex: Deobfuscate handle_futex_death()
Message-ID: <tip-6e0aa9f8a8190e0879a29bd67aa606b51734a122@git.kernel.org>
Git-Commit-ID: 6e0aa9f8a8190e0879a29bd67aa606b51734a122
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Mar 2011 20:15:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e0aa9f8a8190e0879a29bd67aa606b51734a122
Gitweb:     http://git.kernel.org/tip/6e0aa9f8a8190e0879a29bd67aa606b51734a122
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 14 Mar 2011 10:34:35 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Mar 2011 21:08:47 +0100

futex: Deobfuscate handle_futex_death()

handle_futex_death() uses futex_atomic_cmpxchg_inatomic() without
disabling page faults. That's ok, but totally non obvious.

We don't hold locks so we actually can and want to fault here, because
the get_user() before futex_atomic_cmpxchg_inatomic() does not
guarantee a R/W mapping.

We could just add a big fat comment to explain this, but actually
changing the code so that the functionality is entirely clear is
better.

Use the helper function which disables page faults around the
futex_atomic_cmpxchg_inatomic() and handle a fault with a call to
fault_in_user_writeable() as all other places in the futex code do as
well.

Pointed-out-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Darren Hart <darren@dvhart.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
LKML-Reference: <alpine.LFD.2.00.1103141126590.2787@localhost6.localdomain6>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c6bef6e..e9251d9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2458,9 +2458,20 @@ retry:
 		 * userspace.
 		 */
 		mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
-		if (futex_atomic_cmpxchg_inatomic(&nval, uaddr, uval, mval))
-			return -1;
-
+		/*
+		 * We are not holding a lock here, but we want to have
+		 * the pagefault_disable/enable() protection because
+		 * we want to handle the fault gracefully. If the
+		 * access fails we try to fault in the futex with R/W
+		 * verification via get_user_pages. get_user() above
+		 * does not guarantee R/W access. If that fails we
+		 * give up and leave the futex locked.
+		 */
+		if (cmpxchg_futex_value_locked(&nval, uaddr, uval, mval)) {
+			if (fault_in_user_writeable(uaddr))
+				return -1;
+			goto retry;
+		}
 		if (nval != uval)
 			goto retry;
 
