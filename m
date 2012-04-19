Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2DSS5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:57:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33538 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab2DSS5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:57:43 -0400
Date: Thu, 19 Apr 2012 11:57:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, laijs@cn.fujitsu.com,
        manfred@colorfullife.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
Message-ID: <20120419185718.GK2472@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
 <20120112071431.GA1896@leaf>
 <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
 <20120112095257.GA2441@leaf>
 <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
 <20120112115830.GA3436@leaf>
 <alpine.LNX.2.01.1201121625060.25848@frira.zrqbmnf.qr>
 <20120112184150.GA8132@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112184150.GA8132@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041918-8974-0000-0000-0000084EE6D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:41:50AM -0800, Josh Triplett wrote:
> On Thu, Jan 12, 2012 at 04:38:52PM +0100, Jan Engelhardt wrote:
> > On Thursday 2012-01-12 12:58, Josh Triplett wrote:
> > >> Same impression here. BUILD_BUG_ON_ZERO was introduced by
> > >> 
> > >> commit 4552d5dc08b79868829b4be8951b29b07284753f
> > >> Author: Jan Beulich <jbeulich@novell.com>
> > >> Date:   Mon Jun 26 13:57:28 2006 +0200
> > >> 
> > >> while Rusty's CCAN archive calls it "BUILD_BUG_OR_ZERO" (since either 
> > >> it's a bug, or returning neutral zero).
> > >
> > >Sounds like a good target for a fix at some point.
> > 
> > What names do you propose? I have BUILD_BUG_ON_EXPR for some of my code,
> > though in the kernel, it has both _ON_ZERO and _ON_NULL.
> 
> BUILD_BUG_OR_ZERO (and BUILD_BUG_OR_NULL) seem like improvements over
> _ON_ZERO and _ON_NULL; that would remove the ambiguity we both tripped
> over.
> 
> > rcu: avoid checking for constant
> > 
> > When compiling kernel or module code with -O0, "offset" is no longer
> > considered a constant, and therefore always triggers the build error
> > that BUILD_BUG_ON is defined to yield.
> > 
> > Therefore, change the innards of kfree_rcu so that the offset is not
> > tunneled through a function argument before checking it.
> > 
> > Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

OK, a similar run-in with copy_from_user() convince me that we need
this.  (And I was even using default optimization levels!)

Queue for 3.5, with reworked comments and commit log.

						Thanx, Paul

------------------------------------------------------------------------

rcu: Make __kfree_rcu() less dependent on compiler choices

Currently, __kfree_rcu() is implemented as an inline function, and
contains a BUILD_BUG_ON() that malfunctions if __kfree_rcu() is compiled
as an out-of-line function.  Unfortunately, there are compiler settings
(e.g., -O0) that can result in __kfree_rcu() being compiled out of line,
resulting in annoying build breakage.  This commit therefore converts
both __kfree_rcu() and __is_kfree_rcu_offset() from inline functions to
macros to prevent such misbehavior on the part of the compiler.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 20fb776..d5dfb10 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -922,6 +922,21 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 	kfree_call_rcu(head, (rcu_callback)offset);
 }
 
+/*
+ * Does the specified offset indicate that the corresponding rcu_head
+ * structure can be handled by kfree_rcu()?
+ */
+#define __is_kfree_rcu_offset(offset) ((offset) < 4096)
+
+/*
+ * Helper macro for kfree_rcu() to prevent argument-expansion eyestrain.
+ */
+#define __kfree_rcu(head, offset) \
+	do { \
+		BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
+		call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset)); \
+	} while (0)
+
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr:	pointer to kfree
@@ -944,6 +959,9 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
  *
  * Note that the allowable offset might decrease in the future, for example,
  * to allow something like kmem_cache_free_rcu().
+ *
+ * The BUILD_BUG_ON check must not involve any function calls, hence the
+ * checks are done in macros here.
  */
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))

