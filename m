Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1CKLcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:32:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:57415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab1CKLcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:32:42 -0500
Date: Fri, 11 Mar 2011 11:31:07 GMT
From: tip-bot for Michel Lespinasse <walken@google.com>
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
In-Reply-To: <20110311024731.GB26122@google.com>
References: <20110311024731.GB26122@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex: Remove redundant pagefault_disable in futex_atomic_cmpxchg_inatomic()
Message-ID: <tip-522d7decc0370070448a8c28982c8dfd8970489e@git.kernel.org>
Git-Commit-ID: 522d7decc0370070448a8c28982c8dfd8970489e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 11:31:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  522d7decc0370070448a8c28982c8dfd8970489e
Gitweb:     http://git.kernel.org/tip/522d7decc0370070448a8c28982c8dfd8970489e
Author:     Michel Lespinasse <walken@google.com>
AuthorDate: Thu, 10 Mar 2011 18:47:31 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 11 Mar 2011 12:23:08 +0100

futex: Remove redundant pagefault_disable in futex_atomic_cmpxchg_inatomic()

kernel/futex.c disables page faults before calling
futex_atomic_cmpxchg_inatomic(), so there is no need to do it again
within that function.
    
Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Darren Hart <darren@dvhart.com>
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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20110311024731.GB26122@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/arm/include/asm/futex.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
index b33fe70..7133a86 100644
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -95,7 +95,8 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
-	pagefault_disable();	/* implies preempt_disable() */
+	/* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
+	 * call sites. */
 
 	__asm__ __volatile__("@futex_atomic_cmpxchg_inatomic\n"
 	"1:	" T(ldr) "	%0, [%3]\n"
@@ -115,8 +116,6 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 	: "r" (oldval), "r" (newval), "r" (uaddr), "Ir" (-EFAULT)
 	: "cc", "memory");
 
-	pagefault_enable();	/* subsumes preempt_enable() */
-
 	return val;
 }
 
