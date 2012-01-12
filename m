Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2ALKec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:34:32 -0500
Received: from seven.medozas.de ([188.40.89.202]:36366 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab2ALKe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:34:29 -0500
Date: Thu, 12 Jan 2012 11:34:23 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Josh Triplett <josh@joshtriplett.org>
cc: paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com, manfred@colorfullife.com,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
In-Reply-To: <20120112095257.GA2441@leaf>
Message-ID: <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de> <20120112071431.GA1896@leaf> <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr> <20120112095257.GA2441@leaf>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2012-01-12 10:52, Josh Triplett wrote:
>> +#define __kfree_rcu(head, offset) \
>> +	call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset) + \
>> +		 BUILD_BUG_ON_ZERO((offset) >= 4096))
>> +
>
>I had to stare at this for a while, and look up the definition of
>BUILD_BUG_ON_ZERO.  Naturally I assumed that BUILD_BUG_ON_ZERO(arg)
>meant BUILT_BUG_ON((arg) == 0), which would have made the logic
>backwards here.  However, per the definition it just provides a
>zero-returning version of BUILD_BUG_ON.  Ow.

Same impression here. BUILD_BUG_ON_ZERO was introduced by

commit 4552d5dc08b79868829b4be8951b29b07284753f
Author: Jan Beulich <jbeulich@novell.com>
Date:   Mon Jun 26 13:57:28 2006 +0200

while Rusty's CCAN archive calls it "BUILD_BUG_OR_ZERO" (since either 
it's a bug, or returning neutral zero).

>In any case, __kfree_rcu has void return type, so how about just using
>do { ... } while(0) and BUILD_BUG_ON instead?  That seems significantly
>clearer.

Ok. In that case, I'll allow myself to reintroduce the extra temporal 
typedef line that was there previously:

>Apart from that, I can live with this, though it seems horribly
>backwards to replace an inline with a macro rather than the other way
>around.

parent f9fab10bbd768b0e5254e53a4a8477a94bfc4b96 (v3.2-rc7-86-gf9fab10)
commit 041ac1b39390b93d8db91075aefc56b585db75cd
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jan 11 10:05:00 2012 +0100

rcu: avoid checking for constant

When compiling kernel or module code with -O0, "offset" is no longer
considered a constant, and therefore always triggers the build error
that BUILD_BUG_ON is defined to yield.

Therefore, change the innards of kfree_rcu so that the offset is not
tunneled through a function argument before checking it.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/rcupdate.h |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2cf4226..7395ab6 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -795,24 +795,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
 
-static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
-{
-	return offset < 4096;
-}
-
-static __always_inline
-void __kfree_rcu(struct rcu_head *head, unsigned long offset)
-{
-	typedef void (*rcu_callback)(struct rcu_head *);
-
-	BUILD_BUG_ON(!__builtin_constant_p(offset));
-
-	/* See the kfree_rcu() header comment. */
-	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
-
-	call_rcu(head, (rcu_callback)offset);
-}
-
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr:	pointer to kfree
@@ -835,7 +817,20 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
  *
  * Note that the allowable offset might decrease in the future, for example,
  * to allow something like kmem_cache_free_rcu().
+ *
+ * The BUILD_BUG_ON check must not involve any function calls, hence the
+ * checks are done in macros here. __is_kfree_rcu_offset is also used by
+ * kernel/rcu.h.
  */
+#define __is_kfree_rcu_offset(offset) ((offset) < 4096)
+
+#define __kfree_rcu(head, offset) \
+	do { \
+		typedef void (*rcu_callback)(struct rcu_head *); \
+		BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
+		call_rcu(head, (rcu_callback)(unsigned long)(offset)); \
+	} while (0)
+
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
-- 
