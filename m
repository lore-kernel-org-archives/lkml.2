Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1I1Wir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab1I1Wim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:29 2011
Message-Id: <20110928220129.480506972@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikael Pettersson <mikpe@it.uu.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [040/244] sparc32: unbreak arch_write_unlock()
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikael Pettersson <mikpe@it.uu.se>

commit 3f6aa0b113846a8628baa649af422cfc6fb1d786 upstream.

The sparc32 version of arch_write_unlock() is just a plain assignment.
Unfortunately this allows the compiler to schedule side-effects in a
protected region to occur after the HW-level unlock, which is broken.
E.g., the following trivial test case gets miscompiled:

	#include <linux/spinlock.h>
	rwlock_t lock;
	int counter;
	void foo(void) { write_lock(&lock); ++counter; write_unlock(&lock); }

Fixed by adding a compiler memory barrier to arch_write_unlock().  The
sparc64 version combines the barrier and assignment into a single asm(),
and implements the operation as a static inline, so that's what I did too.

Compile-tested with sparc32_defconfig + CONFIG_SMP=y.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/include/asm/spinlock_32.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -131,6 +131,15 @@ static inline void arch_write_lock(arch_
 	*(volatile __u32 *)&lp->lock = ~0U;
 }
 
+static void inline arch_write_unlock(arch_rwlock_t *lock)
+{
+	__asm__ __volatile__(
+"	st		%%g0, [%0]"
+	: /* no outputs */
+	: "r" (lock)
+	: "memory");
+}
+
 static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned int val;
@@ -175,8 +184,6 @@ static inline int __arch_read_trylock(ar
 	res; \
 })
 
-#define arch_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
-
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 #define arch_read_lock_flags(rw, flags)   arch_read_lock(rw)
 #define arch_write_lock_flags(rw, flags)  arch_write_lock(rw)


