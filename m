Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3AGWSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:18:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3AGWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:18:40 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=fBOmOx-NyikA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wMYYvAuhfbIA:10 a=VnNF1IyMAAAA:8 a=ayltMwLYWeDkCjR7tcgA:9 a=PUjeQqilurYA:10 a=1G1kcBpAWYgA:10 a=TUNKTOQ0hfvV3gLG:21 a=zHsAfj7gVYJ10tk_:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357597117.5190.4.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 4/6] rcu: Silence compiler array
 out-of-bounds false positive
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        markus@trippelsdorf.de
Date: Mon, 07 Jan 2013 17:18:37 -0500
In-Reply-To: <20130107171910.GA19510@linux.vnet.ibm.com>
References: <20130105170920.GA13766@linux.vnet.ibm.com>
	 <1357405778-13903-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1357405778-13903-4-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20130107155002.GA11145@leaf> <20130107171602.GI2525@linux.vnet.ibm.com>
	 <20130107171910.GA19510@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 09:19 -0800, Paul E. McKenney wrote:
> On Mon, Jan 07, 2013 at 09:16:02AM -0800, Paul E. McKenney wrote:
> > On Mon, Jan 07, 2013 at 07:50:02AM -0800, Josh Triplett wrote:
> > > On Sat, Jan 05, 2013 at 09:09:36AM -0800, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > It turns out that gcc 4.8 warns on array indexes being out of bounds
> > > > unless it can prove otherwise.  It gives this warning on some RCU
> > > > initialization code.  Because this is far from any fastpath, add
> > > > an explicit check for array bounds and panic if so.  This gives the
> > > > compiler enough information to figure out that the array index is never
> > > > out of bounds.
> > > > 
> > > > However, if a similar false positive occurs on a fastpath, it will
> > > > probably be necessary to tell the compiler to keep its array-index
> > > > anxieties to itself.  ;-)
> > > > 
> > > > Markus Trippelsdorf <markus@trippelsdorf.de>
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > ---
> > > >  kernel/rcutree.c |    4 ++++
> > > >  1 files changed, 4 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > index d145796..e0d9815 100644
> > > > --- a/kernel/rcutree.c
> > > > +++ b/kernel/rcutree.c
> > > > @@ -2938,6 +2938,10 @@ static void __init rcu_init_one(struct rcu_state *rsp,
> > > >  
> > > >  	BUILD_BUG_ON(MAX_RCU_LVLS > ARRAY_SIZE(buf));  /* Fix buf[] init! */
> > > >  
> > > > +	/* Silence gcc 4.8 warning about array index out of range. */
> > > > +	if (rcu_num_lvls > RCU_NUM_LVLS)
> > > > +		panic("rcu_init_one: rcu_num_lvls overflow");
> > > 
> > > Why not write this as BUG_ON(rcu_num_lvls > RCU_NUM_LVLS)?  Given that
> > > the condition in question can never happen, you don't really need an
> > > explanatory message.
> > 
> > Good point, will do!
> 
> Ah, wait, BUG_ON() sometimes compiles to nothingness:
> 
> #ifndef HAVE_ARCH_BUG_ON
> #define BUG_ON(condition) do { if (condition) ; } while(0)
> #endif
> 
> So I do need the explicit "if".  :-(


Bah, those archs shouldn't be bothered with. If they don't want to bug,
then that's there problem :-)

Lots of places in the kernel have BUG_ON() where they require it to
panic.

-- Steve


