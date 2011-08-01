Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1HAFXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:23:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50056 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab1HAFXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:23:45 -0400
Date: Sun, 31 Jul 2011 22:23:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, shemminger@vyatta.com, mchan@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: RCU: how to suppress warnings from rcu_assign_pointer?
Message-ID: <20110801052342.GD2307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110729003843.GA2373@linux.vnet.ibm.com>
 <20110729105058.2cb9fa86@nehalam.ftrdhcpuser.net>
 <1312028225.2873.104.camel@edumazet-laptop>
 <20110730.201609.2157787571393748046.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110730.201609.2157787571393748046.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 08:16:09PM -0700, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Sat, 30 Jul 2011 14:17:05 +0200
> 
> > Le vendredi 29 juillet 2011 à 10:50 -0700, Stephen Hemminger a écrit :
> >> Gcc now generates warnings from rcu_assign_pointer when passed the
> >> address of something for example:
> >> 	rcu_assign_pointer(dev_queue->qdisc, &noop_qdisc);
> >> This warning is harmless and should be surpressed but there maybe
> >> other cases where we want that Gcc warning.
> >> 
> >> I tried various combinations of in rcu_assign_pointer macro
> >>   #pragma GCC diagnostic push
> >>   #pragma GCC diagnostic ignored "-Wlogical-op"
> >>   ...
> >>   #pragma GCC diagnostic pop
> >> but macro's and pragma's don't nest with the correct scope for
> >> this.
> >> 
> >> Maybe some one with more Gcc foo and time to waste could take
> >> a crack at it.
> > 
> > I would just remove the test from rcu_assign_pointer().
> > 
> > We now have RCU_INIT_POINTER() for places we dont want/afford the
> > smp_wmb()
> 
> Agreed:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Very good!!!  Many thanks to the three of you!

I have queued this, adding Eric's Signed-off-by.  Eric, could you please
reply either giving me explicit permission to do this or telling me that
you would rather that I apply under my own Signed-off-by?  (I would guess
that the former is OK with you, but I really do need to know for sure.)
Please see below for the current state of this commit in my on-laptop
-rcu tree.

I have also added a second commit upgrading comment headers to call out
exactly when RCU_INIT_POINTER() may be used.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Make rcu_assign_pointer() unconditionally insert a memory barrier

Recent changes to gcc give warning messages on rcu_assign_pointers()'s
checks that allow it to determine when it is OK to omit the memory
barrier.  Stephen Hemminger tried a number of gcc tricks to silence
this warning, but #pragmas and CPP macros do not work together in the
way that would be required to make this work.

However, we now have RCU_INIT_POINTER(), which already omits this
memory barrier, and which therefore may be used when assigning NULL to
an RCU-protected pointer that is accessible to readers.  This commit
therefore makes rcu_assign_pointer() unconditionally emit the memory
barrier.

Reported-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ea80396..b2e5fe8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -443,9 +443,7 @@ extern int rcu_my_thread_group_empty(void);
 	})
 #define __rcu_assign_pointer(p, v, space) \
 	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
-			smp_wmb(); \
+		smp_wmb(); \
 		(p) = (typeof(*v) __force space *)(v); \
 	})
 
