Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0KYO62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:58:28 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40336 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0KYO61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:58:27 -0500
Date: Thu, 25 Nov 2010 06:58:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] rcu: Fix series of spurious RCU softirqs
Message-ID: <20101125145824.GD2162@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
 <4CEDDB2A.2020807@cn.fujitsu.com>
 <20101125073857.GB2538@nowhere>
 <4CEE1FD2.7040707@cn.fujitsu.com>
 <20101125092706.GH2538@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125092706.GH2538@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:27:08AM +0100, Frederic Weisbecker wrote:
> On Thu, Nov 25, 2010 at 04:35:30PM +0800, Lai Jiangshan wrote:
> > On 11/25/2010 03:38 PM, Frederic Weisbecker wrote:
> > > On Thu, Nov 25, 2010 at 11:42:34AM +0800, Lai Jiangshan wrote:
> > >> On 11/24/2010 08:31 AM, Frederic Weisbecker wrote:
> > >>> Hi,
> > >>>
> > >>> I've observed some not so unfrequent series of spurious rcu
> > >>> softirqs, sometimes happening at each ticks for a random
> > >>> while.
> > >>>
> > >>> These patches aims at fixing them.
> > >>>
> > >>> Thanks.
> > >>>
> > >>> Frederic Weisbecker (2):
> > >>>   rcu: Don't chase unnecessary quiescent states after extended grace periods
> > >>>   rcu: Stop checking quiescent states after grace period completion from remote
> > >>>
> > >>
> > >> If we ensure rdp->gpnum >= rdp->completed is always true, the problems as
> > >> you described will not be existed. Or maybe I misunderstand you.
> > >>
> > >> rdp->gpnum >= rdp->completed is a very important guarantee I think.
> > >> (In my RCURING, it is guaranteed.) I'm afraid there are some other
> > >> problems still hidden if it is not guaranteed.
> > >>
> > >> so I recommend: (code is better than words)
> > >>
> > >> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > >> index d5bc439..af4e87a 100644
> > >> --- a/kernel/rcutree.c
> > >> +++ b/kernel/rcutree.c
> > >> @@ -648,6 +648,13 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
> > >>  
> > >>  		/* Remember that we saw this grace-period completion. */
> > >>  		rdp->completed = rnp->completed;
> > >> +
> > >> +		/* Ensure ->gpnum >= ->completed after NO_HZ */
> > >> +		if (unlikely(rnp->completed - rdp->gpnum > 0
> > >> +				|| rdp->gpnum - rnp->gpnum > 0)) {
> > >> +			rdp->gpnum = rnp->completed;
> > >> +			rdp->qs_pending = 0;
> > > 
> > > 
> > > That's an alternative to my first patch yeah.
> > 
> > Since rdp->gpnum >= rdp->completed is guaranteed.
> > your second patch is not needed, the problem is also fixed.
> > 
> > if rnp->gpnum == rnp->completed, rcu_report_qs_rdp() will not be called.
> > it is because rdp->qs_pending == 0 when rnp->gpnum == rnp->completed.
> 
> 
> Aaah...
> 
> 
> > 
> > And if rdp->gpnum >= rdp->completed
> > > must be a guarantee outside the rnp lock, then it's certainly better because
> > > the lock is relaxed between rcu_process_gp_end() and note_new_gpnum(), and
> > > both values are async in this lockless frame.
> > > 
> > > But perhaps this shouldn't touch rdp->qs_pending:
> > 
> > if rdp->gpnum == rnp->completed, it means we don't need a qs for rdp->gpnum,
> > it is completed. so we must set rdp->qs_pending = 0;
> > 
> > when we really need a qs, rdp->qs_pending will be fixed in note_new_gp_new().
> 
> 
> Ok that makes all sense now!
> 
> I'm just not sure about your check above.
> 
> (rdp->gpnum - rnp->gpnum > 0) can never happen, right?
> 
> Also perhaps we should set rdp->qs_pending = 0 only if
> rnp->completed == rdp->completed?
> 
> Which in the end would be:
> 
> 	/* Remember that we saw this grace-period completion. */
> 	rdp->completed = rnp->completed;
> 
> +	if (rdp->gpnum < rdp->completed)
> +		rdp->gpnum = rdp->completed;
> +
> +	if (rdp->gpnum == rdp->completed)
> +		rdp->qs_pending = 0;
> 
> 
> And then if there is a new grace period to handle, this will
> be done through note_new_pgnum().
> 
> Hm?

Given that it is Thanksgiving holiday here in USA, I am going to give you
guys a several days to come to agreement on this.  Then I will inspect
the resulting patch.  ;-)

							Thanx, Paul
