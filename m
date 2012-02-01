Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2BAVOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:14:17 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45010 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932644Ab2BAVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:37 -0500
X-Sasl-enc: qIkXyaJm5y68FEM1E+dkBDYxabvyMXFAejeCJIK0Oah8 1328130635
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:47 2012
Message-Id: <20120201210047.161892629@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [37/89] x86: xen: size struct xen_spinlock to always fit in arch_spinlock_t
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 7a7546b377bdaa25ac77f33d9433c59f259b9688 upstream.

If NR_CPUS < 256 then arch_spinlock_t is only 16 bits wide but struct
xen_spinlock is 32 bits.  When a spin lock is contended and
xl->spinners is modified the two bytes immediately after the spin lock
would be corrupted.

This is a regression caused by 84eb950db13ca40a0572ce9957e14723500943d6
(x86, ticketlock: Clean up types and accessors) which reduced the size
of arch_spinlock_t.

Fix this by making xl->spinners a u8 if NR_CPUS < 256.  A
BUILD_BUG_ON() is also added to check the sizes of the two structures
are compatible.

In many cases this was not noticable as there would often be padding
bytes after the lock (e.g., if any of CONFIG_GENERIC_LOCKBREAK,
CONFIG_DEBUG_SPINLOCK, or CONFIG_DEBUG_LOCK_ALLOC were enabled).

The bnx2 driver is affected. In struct bnx2, phy_lock and
indirect_lock may have no padding after them.  Contention on phy_lock
would corrupt indirect_lock making it appear locked and the driver
would deadlock.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/spinlock.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -116,9 +116,26 @@ static inline void spin_time_accum_block
 }
 #endif  /* CONFIG_XEN_DEBUG_FS */
 
+/*
+ * Size struct xen_spinlock so it's the same as arch_spinlock_t.
+ */
+#if NR_CPUS < 256
+typedef u8 xen_spinners_t;
+# define inc_spinners(xl) \
+	asm(LOCK_PREFIX " incb %0" : "+m" ((xl)->spinners) : : "memory");
+# define dec_spinners(xl) \
+	asm(LOCK_PREFIX " decb %0" : "+m" ((xl)->spinners) : : "memory");
+#else
+typedef u16 xen_spinners_t;
+# define inc_spinners(xl) \
+	asm(LOCK_PREFIX " incw %0" : "+m" ((xl)->spinners) : : "memory");
+# define dec_spinners(xl) \
+	asm(LOCK_PREFIX " decw %0" : "+m" ((xl)->spinners) : : "memory");
+#endif
+
 struct xen_spinlock {
 	unsigned char lock;		/* 0 -> free; 1 -> locked */
-	unsigned short spinners;	/* count of waiting cpus */
+	xen_spinners_t spinners;	/* count of waiting cpus */
 };
 
 static int xen_spin_is_locked(struct arch_spinlock *lock)
@@ -164,8 +181,7 @@ static inline struct xen_spinlock *spinn
 
 	wmb();			/* set lock of interest before count */
 
-	asm(LOCK_PREFIX " incw %0"
-	    : "+m" (xl->spinners) : : "memory");
+	inc_spinners(xl);
 
 	return prev;
 }
@@ -176,8 +192,7 @@ static inline struct xen_spinlock *spinn
  */
 static inline void unspinning_lock(struct xen_spinlock *xl, struct xen_spinlock *prev)
 {
-	asm(LOCK_PREFIX " decw %0"
-	    : "+m" (xl->spinners) : : "memory");
+	dec_spinners(xl);
 	wmb();			/* decrement count before restoring lock */
 	__this_cpu_write(lock_spinners, prev);
 }
@@ -373,6 +388,8 @@ void xen_uninit_lock_cpu(int cpu)
 
 void __init xen_init_spinlocks(void)
 {
+	BUILD_BUG_ON(sizeof(struct xen_spinlock) > sizeof(arch_spinlock_t));
+
 	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
 	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
 	pv_lock_ops.spin_lock = xen_spin_lock;


