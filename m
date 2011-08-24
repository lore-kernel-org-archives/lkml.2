Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1HXM23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 08:28:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47838 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1HXM21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 08:28:27 -0400
Date: Wed, 24 Aug 2011 05:27:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the rcu tree
Message-ID: <20110824122739.GB2320@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110824142337.78715e4d6f9db2de68d87fe4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824142337.78715e4d6f9db2de68d87fe4@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:23:37PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the rcu tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> kernel/rtmutex.c: In function '__rt_mutex_slowlock':
> kernel/rtmutex.c:605:3: warning: suggest parentheses around assignment used as truth value

There actually already are parentheses around it, and the first pass
through the loop it is uninitialized at that point.  But hey, that 
is gcc for you!  Does the patch below cure it?

> Introduced by commit 83841f021d4b ("rcu: Permit rt_mutex_unlock() with
> irqs disabled").

If it does, then I will fold into that commit.

							Thanx, Paul

------------------------------------------------------------------------

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 0222e34..2548f44 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -602,7 +602,8 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 		raw_spin_unlock(&lock->wait_lock);
 
-		if (was_disabled = irqs_disabled())
+		was_disabled = irqs_disabled();
+		if (was_disabled)
 			local_irq_enable();
 
 		debug_rt_mutex_print_deadlock(waiter);
