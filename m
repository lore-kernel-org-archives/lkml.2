Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3AGSn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:43:58 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:55375 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3AGSn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:43:57 -0500
Date: Mon, 7 Jan 2013 10:43:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 4/6] rcu: Silence compiler array
 out-of-bounds false positive
Message-ID: <20130107184326.GO2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130105170920.GA13766@linux.vnet.ibm.com>
 <1357405778-13903-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1357405778-13903-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130107155002.GA11145@leaf>
 <20130107171602.GI2525@linux.vnet.ibm.com>
 <20130107180855.GA233@x4>
 <20130107182417.GA10502@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107182417.GA10502@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010718-7408-0000-0000-00000BA0CFC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 10:24:17AM -0800, Josh Triplett wrote:
> On Mon, Jan 07, 2013 at 07:08:55PM +0100, Markus Trippelsdorf wrote:
> > On 2013.01.07 at 09:16 -0800, Paul E. McKenney wrote:
> > > On Mon, Jan 07, 2013 at 07:50:02AM -0800, Josh Triplett wrote:
> > > > On Sat, Jan 05, 2013 at 09:09:36AM -0800, Paul E. McKenney wrote:
> > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > It turns out that gcc 4.8 warns on array indexes being out of bounds
> > > > > unless it can prove otherwise.  It gives this warning on some RCU
> > > > > initialization code.  Because this is far from any fastpath, add
> > > > > an explicit check for array bounds and panic if so.  This gives the
> > > > > compiler enough information to figure out that the array index is never
> > > > > out of bounds.
> > > > > 
> > > > > However, if a similar false positive occurs on a fastpath, it will
> > > > > probably be necessary to tell the compiler to keep its array-index
> > > > > anxieties to itself.  ;-)
> > > > > 
> > > > > Markus Trippelsdorf <markus@trippelsdorf.de>
> > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > ---
> > > > >  kernel/rcutree.c |    4 ++++
> > > > >  1 files changed, 4 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > > index d145796..e0d9815 100644
> > > > > --- a/kernel/rcutree.c
> > > > > +++ b/kernel/rcutree.c
> > > > > @@ -2938,6 +2938,10 @@ static void __init rcu_init_one(struct rcu_state *rsp,
> > > > >  
> > > > >  	BUILD_BUG_ON(MAX_RCU_LVLS > ARRAY_SIZE(buf));  /* Fix buf[] init! */
> > > > >  
> > > > > +	/* Silence gcc 4.8 warning about array index out of range. */
> > > > > +	if (rcu_num_lvls > RCU_NUM_LVLS)
> > > > > +		panic("rcu_init_one: rcu_num_lvls overflow");
> > > 
> > > > I do find it surprising, though, that the compiler can't figure this one
> > > > out, given that rcu_num_lvls gets initialized right before this in the
> > > > same file (and likely inlined into the same function).  I wonder if it
> > > > thought some other code might change it unexpectedly, since rcu_num_lvls
> > > > doesn't get declared as static?  Unfortunately, the loop macros in
> > > > rcutree.h make it difficult to make rcu_num_lvls static, but as far as I
> > > > can tell only one use of those macros ever gets expanded outside of
> > > > rcutree.c: the one in rcutree_trace.c.  If you compile out tracing, and
> > > > declare rcu_num_lvls static, does the warning go away?
> > > 
> > > I found it quite surprising also, hence the "array-index anxieties" above.
> > 
> > Yes, declaring rcu_num_lvls static would fix the issue. See the
> > following gcc bug: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55529
> 
> Seems potentially worth restructuring the code a bit to fold in the one
> rcutree_trace.c bit that needs it and then making rcu_num_lvls static
> and internal to rcutree.c.

One thing to keep in mind...  The added "if" is in initialization code
that runs once, and whose memory is reclaimed.  Restructuring the runtime
code will increase complexity and probably result in some degradation.

So I am not convinced that a change is really needed.

							Thanx, Paul

