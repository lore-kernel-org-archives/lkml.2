Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab2JKAWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:22:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58994 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932910Ab2JKAPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:15:30 -0400
X-Sasl-enc: KpDV9gdRt/ZiAgfxBgU7aXpcIzHYIwBaE6/CfUzd6P+S 1349914528
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Becky Bruce <bgillbruce@gmail.com>,
        Subodh Nijsure <snijsure@grid-net.com>, Paul Walmsley <paul@pwsan.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [ 111/133] rcu: Fix day-one dyntick-idle stall-warning bug
Date: Thu, 11 Oct 2012 07:52:17 +0900
Message-Id: <20121010224914.503361999@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

commit a10d206ef1a83121ab7430cb196e0376a7145b22 upstream.

Each grace period is supposed to have at least one callback waiting
for that grace period to complete.  However, if CONFIG_NO_HZ=n, an
extra callback-free grace period is no big problem -- it will chew up
a tiny bit of CPU time, but it will complete normally.  In contrast,
CONFIG_NO_HZ=y kernels have the potential for all the CPUs to go to
sleep indefinitely, in turn indefinitely delaying completion of the
callback-free grace period.  Given that nothing is waiting on this grace
period, this is also not a problem.

That is, unless RCU CPU stall warnings are also enabled, as they are
in recent kernels.  In this case, if a CPU wakes up after at least one
minute of inactivity, an RCU CPU stall warning will result.  The reason
that no one noticed until quite recently is that most systems have enough
OS noise that they will never remain absolutely idle for a full minute.
But there are some embedded systems with cut-down userspace configurations
that consistently get into this situation.

All this begs the question of exactly how a callback-free grace period
gets started in the first place.  This can happen due to the fact that
CPUs do not necessarily agree on which grace period is in progress.
If a CPU still believes that the grace period that just completed is
still ongoing, it will believe that it has callbacks that need to wait for
another grace period, never mind the fact that the grace period that they
were waiting for just completed.  This CPU can therefore erroneously
decide to start a new grace period.  Note that this can happen in
TREE_RCU and TREE_PREEMPT_RCU even on a single-CPU system:  Deadlock
considerations mean that the CPU that detected the end of the grace
period is not necessarily officially informed of this fact for some time.

Once this CPU notices that the earlier grace period completed, it will
invoke its callbacks.  It then won't have any callbacks left.  If no
other CPU has any callbacks, we now have a callback-free grace period.

This commit therefore makes CPUs check more carefully before starting a
new grace period.  This new check relies on an array of tail pointers
into each CPU's list of callbacks.  If the CPU is up to date on which
grace periods have completed, it checks to see if any callbacks follow
the RCU_DONE_TAIL segment, otherwise it checks to see if any callbacks
follow the RCU_WAIT_TAIL segment.  The reason that this works is that
the RCU_WAIT_TAIL segment will be promoted to the RCU_DONE_TAIL segment
as soon as the CPU is officially notified that the old grace period
has ended.

This change is to cpu_needs_another_gp(), which is called in a number
of places.  The only one that really matters is in rcu_start_gp(), where
the root rcu_node structure's ->lock is held, which prevents any
other CPU from starting or completing a grace period, so that the
comparison that determines whether the CPU is missing the completion
of a grace period is stable.

Reported-by: Becky Bruce <bgillbruce@gmail.com>
Reported-by: Subodh Nijsure <snijsure@grid-net.com>
Reported-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul Walmsley <paul@pwsan.com>  # OMAP3730, OMAP4430
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcutree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -304,7 +304,9 @@ cpu_has_callbacks_ready_to_invoke(struct
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
+	return *rdp->nxttail[RCU_DONE_TAIL +
+			     ACCESS_ONCE(rsp->completed) != rdp->completed] &&
+	       !rcu_gp_in_progress(rsp);
 }
 
 /*


