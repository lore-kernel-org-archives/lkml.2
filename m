Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2BBQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:29:24 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53228 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab2BBQ3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:29:22 -0500
Date: Thu, 2 Feb 2012 08:27:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 04/41] rcu: Add diagnostic for
 misaligned rcu_head structures
Message-ID: <20120202162755.GJ2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202010146.GF29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202010146.GF29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020216-7182-0000-0000-000000A689EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 05:01:46PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:22AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The push for energy efficiency will require that RCU tag rcu_head
> > structures to indicate whether or not their invocation is time critical.
> > This tagging is best carried out in the bottom bits of the ->next
> > pointers in the rcu_head structures.  This tagging requires that the
> > rcu_head structures be properly aligned, so this commit adds the required
> > diagnostics.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index d0f8e64..4655f3e 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1707,6 +1707,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
> >  	unsigned long flags;
> >  	struct rcu_data *rdp;
> >  
> > +	WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
> >  	debug_rcu_head_queue(head);
> 
> Upon further checking:
> 
> static inline void debug_rcu_head_queue(struct rcu_head *head)
> {
>         WARN_ON_ONCE((unsigned long)head & 0x3);
> 
> :)

Fair point!  I guess that we really only need one of these.  ;-)

I have kept the unconditional one and removed the one hidden under
CONFIG_DEBUG_OBJECTS_RCU_HEAD, but in a separate commit with
your Reported-by.

							Thanx, Paul

