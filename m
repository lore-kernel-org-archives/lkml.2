Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1HNQGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1HNQGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:52 2011
Message-Id: <20110812210552.733620578@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Carlos ODonell <carlos@systemhalted.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [07/90] [PARISC] Fix futex support
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carlos O'Donell <carlos@systemhalted.org>

commit d9ba5fe76d604514444b1ea0a19f38c6196a46e3 upstream.

Implements futex op support and makes futex cmpxchg atomic.
Tested on 64-bit SMP kernel running on 2 x PA8700s.

[jejb: checkpatch fixes]
Signed-off-by: Carlos O'Donell <carlos@systemhalted.org>
Tested-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/futex.h |   66 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 6 deletions(-)

--- a/arch/parisc/include/asm/futex.h
+++ b/arch/parisc/include/asm/futex.h
@@ -5,11 +5,14 @@
 
 #include <linux/futex.h>
 #include <linux/uaccess.h>
+#include <asm/atomic.h>
 #include <asm/errno.h>
 
 static inline int
 futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
+	unsigned long int flags;
+	u32 val;
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
 	int oparg = (encoded_op << 8) >> 20;
@@ -18,21 +21,58 @@ futex_atomic_op_inuser (int encoded_op,
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(*uaddr)))
 		return -EFAULT;
 
 	pagefault_disable();
 
+	_atomic_spin_lock_irqsave(uaddr, flags);
+
 	switch (op) {
 	case FUTEX_OP_SET:
+		/* *(int *)UADDR2 = OPARG; */
+		ret = get_user(oldval, uaddr);
+		if (!ret)
+			ret = put_user(oparg, uaddr);
+		break;
 	case FUTEX_OP_ADD:
+		/* *(int *)UADDR2 += OPARG; */
+		ret = get_user(oldval, uaddr);
+		if (!ret) {
+			val = oldval + oparg;
+			ret = put_user(val, uaddr);
+		}
+		break;
 	case FUTEX_OP_OR:
+		/* *(int *)UADDR2 |= OPARG; */
+		ret = get_user(oldval, uaddr);
+		if (!ret) {
+			val = oldval | oparg;
+			ret = put_user(val, uaddr);
+		}
+		break;
 	case FUTEX_OP_ANDN:
+		/* *(int *)UADDR2 &= ~OPARG; */
+		ret = get_user(oldval, uaddr);
+		if (!ret) {
+			val = oldval & ~oparg;
+			ret = put_user(val, uaddr);
+		}
+		break;
 	case FUTEX_OP_XOR:
+		/* *(int *)UADDR2 ^= OPARG; */
+		ret = get_user(oldval, uaddr);
+		if (!ret) {
+			val = oldval ^ oparg;
+			ret = put_user(val, uaddr);
+		}
+		break;
 	default:
 		ret = -ENOSYS;
 	}
 
+	_atomic_spin_unlock_irqrestore(uaddr, flags);
+
 	pagefault_enable();
 
 	if (!ret) {
@@ -54,7 +94,9 @@ static inline int
 futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 			      u32 oldval, u32 newval)
 {
+	int ret;
 	u32 val;
+	unsigned long flags;
 
 	/* futex.c wants to do a cmpxchg_inatomic on kernel NULL, which is
 	 * our gateway page, and causes no end of trouble...
@@ -65,12 +107,24 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	if (get_user(val, uaddr))
-		return -EFAULT;
-	if (val == oldval && put_user(newval, uaddr))
-		return -EFAULT;
+	/* HPPA has no cmpxchg in hardware and therefore the
+	 * best we can do here is use an array of locks. The
+	 * lock selected is based on a hash of the userspace
+	 * address. This should scale to a couple of CPUs.
+	 */
+
+	_atomic_spin_lock_irqsave(uaddr, flags);
+
+	ret = get_user(val, uaddr);
+
+	if (!ret && val == oldval)
+		ret = put_user(newval, uaddr);
+
 	*uval = val;
-	return 0;
+
+	_atomic_spin_unlock_irqrestore(uaddr, flags);
+
+	return ret;
 }
 
 #endif /*__KERNEL__*/


