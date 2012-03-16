Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2CPUOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:14:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44505 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2CPUOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:14:24 -0400
Date: Fri, 16 Mar 2012 21:14:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 11/11] checkpatch: Check for spin_is_locked
Message-ID: <20120316201422.GL22197@one.firstfloor.org>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org> <1331924464-18023-12-git-send-email-andi@firstfloor.org> <1331925755.11368.14.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331925755.11368.14.camel@joe2Laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:22:35PM -0700, Joe Perches wrote:
> On Fri, 2012-03-16 at 12:01 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > spin_is_locked is usually misused. In checkpatch.pl
> > - warn when it is used at all
> > - error out when it is asserted on free, because that's usually broken
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > +# spin_is_locked is usually misused. warn about it.
> > +		if ($line =~ /\bspin_is_locked\s*\(/) {
> > +			# BUG_ON/WARN_ON(!spin_is_locked() is generally a bug
> > +			if ($line =~ /(BUG_ON|WARN_ON|ASSERT)\s*\(!spin_is_locked/) {
> > +				ERROR("ASSERT_SPIN_IS_LOCKED",
> > +				     "Use lockdep_assert_held() instead of asserts on !spin_is_locked\n"
> > +				      . $herecurr);
> > +			} else {
> > +				WARN("SPIN_IS_LOCKED",
> > +				     "spin_is_locked is very rarely correctly used. Please reconsider\n"
> > +					. $herecurr)
> > +			}
> > +		}
> > +
> 
> I suggest you use a single --ignore string of
> "SPIN_IS_LOCKED" instead of different ones.

Done.
> 
> Grammar might be improved in the WARN.  Maybe:
> "Using spin_is_locked() is generally wrong. See [foo documentation]\n"

Done.

> 
> Also, like what was done for yield(), perhaps
> some kernel-doc content would be useful.

Added to spinlocks.txt and spinlock.h


+/**
+ * spin_is_locked() - Check if a spinlock is being held.
+ * @lock: Lock to check.
+ *
+ * This function should normally not be used. Especially using it in
+ * WARN and BUG_ONs is usually incorrect or redundant.
+ * If you want to check if a lock is held in a function
+ * use lockdep_assert_held(). A lot of other usages are racy.
+ */


+spin_is_locked is a bad idea
+
+spin_is_locked checks if a lock is currently hold.  On uniprocessor kernels
+it always returns 0. In general this function should be avoided because most 
+uses of it are either redundant or broken.
+
+People often use spin_is_locked() to check if a particular lock is hold when a function
+is called to enforce a locking discipline, like
+
+       WARN_ON(!spin_is_locked(!my_lock))
+
+or 
+
+       BUG_ON(!spin_is_locked(!my_lock))
+
+or some variant of those.
+
+This does not work on uniprocessor kernels because they will always fail.
+While there are ways around that they are ugly and not recommended.
+Better use lockdep_assert_held(). This also only checks on a lock debugging
+kernel (which you should occasionally run on your code anyways because
+it catches many more problems). 
+
+In generally this would be better done with static annotation anyways 
+(there's some support for it in sparse)
+
+       BUG_ON(spin_is_locked(obj->lock));
+       kfree(obj);
+
+Another usage is checking whether a lock is not hold when freeing an object.
+However this is redundant because lock debugging supports this anyways
+without explicit code. Just delete the BUG_ON.
+
+A third usage is to check in a console function if a lock is hold, to get
+a panic crash dump out even when some other thread died in it.
+This is better implemented with spin_try_lock() et.al. and a timeout.
+
+Other usages are usually simply races.
+
+In summary just don't use it.






-- 
ak@linux.intel.com -- Speaking for myself only.
