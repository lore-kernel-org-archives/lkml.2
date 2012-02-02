Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2BBBQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:16:18 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45739 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2BBBQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:16:17 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 17:15:52 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 05/41] rcu: Avoid waking up CPUs having
 only kfree_rcu() callbacks
Message-ID: <20120202011552.GG29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:23AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> When CONFIG_RCU_FAST_NO_HZ is enabled, RCU will allow a given CPU to
> enter dyntick-idle mode even if it still has RCU callbacks queued.
> RCU avoids system hangs in this case by scheduling a timer for several
> jiffies in the future.  However, if all of the callbacks on that CPU
> are from kfree_rcu(), there is no reason to wake the CPU up, as it is
> not a problem to defer freeing of memory.
> 
> This commit therefore tracks the number of callbacks on a given CPU
> that are from kfree_rcu(), and avoids scheduling the timer if all of
> a given CPU's callbacks are from kfree_rcu().

Minor nit: I think it would make much more sense to track the number of
"strict" callbacks *not* from kfree_rcu, and check for that number != 0,
rather than tracking the number of "lazy" callbacks from kfree_rcu and
checking for all != lazy.  You can always compute one number from the
other, but since you only ever need to know the strict count, not the
lazy count, why not directly track the thing you care about?

Also, any way this could hide the new kfree_call_rcu internally rather
than adding it as a new export?  In particular, why introduce a new
exported API only suitable for internal use or foot-shooting?

- Josh Triplett
