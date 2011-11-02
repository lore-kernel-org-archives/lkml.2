Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300Ab1KCBj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:39:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934287Ab1KCBjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:39:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:40 2011
Message-Id: <20111102222740.239662657@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:25:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mikael Pettersson <mikpe@it.uu.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [006/101] sparc32: unbreak arch_write_unlock()
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -130,6 +130,15 @@ static inline void arch_write_lock(arch_
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
@@ -174,8 +183,6 @@ static inline int __arch_read_trylock(ar
 	res; \
 })
 
-#define arch_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
-
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 #define arch_read_lock_flags(rw, flags)   arch_read_lock(rw)
 #define arch_write_lock_flags(rw, flags)  arch_write_lock(rw)


