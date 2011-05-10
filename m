Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1EJPm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:42:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37680 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab1EJPmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:42:25 -0400
Date: Tue, 10 May 2011 08:41:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc6-mmotm0506 and -next - __kfree_rcu breaks
 third-party kernel code
Message-ID: <20110510154111.GJ2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <7961.1304953500@localhost>
 <20110509091757.580f3f6c.randy.dunlap@oracle.com>
 <14010.1304960192@localhost>
 <4DC820F6.80809@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC820F6.80809@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 10:14:30AM -0700, Randy Dunlap wrote:
> On 05/09/11 09:56, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 09 May 2011 09:17:57 PDT, Randy Dunlap said:
> > 
> >> I'd be happy to see a simple fix, but we don't generally support building
> >> external modules without using the kernel kbuild infrastructure AFAIK --
> >> and when I add a Makefile along with your kernconf.c file, it builds successfully
> >> on mmotm-2011-0506-1639.
> > 
> > And in fact the module *does* use the Makefile stuff for the actual build - it
> > was just the installer's "am I looking at a sane 2.6 tree" sanity check that
> > bombed. So I go looking for what special sauce the Makefile adds to make it
> > work, and....
> > 
> > OK, *now* I'm confused.  The magic sauce appears to be "-Os". Adding that makes
> > the compile work.  And for no obvious reason - there's something in there that
> > causes indigestion, but only if the optimizer isn't invoked.
> 
> You can disable that by disabling:
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> 
> > *WTF*?
> 
> I dunno either.

It appears that some compilers at some optimization levels aren't willing
to trace build-time constants through local parameters...  Could you please
try out the following patch?

							Thanx, Paul

------------------------------------------------------------------------

rcu: avoid build error for third-party modules

The initial definition of __kfree_rcu() checked a static inline function
argument to see if it was a compile-time constant.  Apparently not all
compilers are willing to put up with this at all optimization levels.
Add a nasty comment and remove the warning, relying on the fact that
__kfree_rcu() is called only from kfree_rcu(), which always passes in
a compile-time constant.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..58b13f1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -814,13 +814,14 @@ static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
 	return offset < 4096;
 }
 
+/*
+ * Intended to be called only from the kfree_rcu() macro.
+ */
 static __always_inline
 void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 {
 	typedef void (*rcu_callback)(struct rcu_head *);
 
-	BUILD_BUG_ON(!__builtin_constant_p(offset));
-
 	/* See the kfree_rcu() header comment. */
 	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
 
