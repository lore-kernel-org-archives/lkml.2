Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0LJXdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:33:38 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:45826 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0LJXdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:33:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wHwo6DjZssxI7y58bSb+Mofj7m9RXU+/SESlaJ7cUYVDtwlFHUnZd4YMok3klnOmGP
         5kkJU4i93TONt8e0mRyQY8eol8X3Gu6j9Sv+lNc4SK1p0+aswJmKQZbLhM8V0OKSoKG9
         18JNKjjR2zMFNcADIEHV+mqLYyKra81quAj0E=
Date: Sat, 11 Dec 2010 00:33:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, laijs@cn.fujitsu.com
Subject: Re: [PATCH 1/2] rcu: Stop chasing QS if another CPU did it for us
Message-ID: <20101210233329.GB1713@nowhere>
References: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
 <1292015471-19227-2-git-send-email-fweisbec@gmail.com>
 <20101210225855.GJ2125@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210225855.GJ2125@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 02:58:55PM -0800, Paul E. McKenney wrote:
> On Fri, Dec 10, 2010 at 10:11:10PM +0100, Frederic Weisbecker wrote:
> > When a CPU is idle and others CPUs handled its extended
> > quiescent state to complete grace periods on its behalf,
> > it will catch up with completed grace periods numbers
> > when it wakes up.
> > 
> > But at this point there might be no more grace period to
> > complete, but still the woken CPU always keeps its stale
> > qs_pending value and will then continue to chase quiescent
> > states even if its not needed anymore.
> > 
> > This results in clusters of spurious softirqs until a new
> > real grace period is started. Because if we continue to
> > chase quiescent states but we have completed every grace
> > periods, rcu_report_qs_rdp() is puzzled and makes that
> > state run into infinite loops.
> > 
> > As suggested by Lai Jiangshan, just reset qs_pending if
> > someone completed every grace periods on our behalf.
> 
> Nice!!!
> 
> I have queued this patch, and followed it up with a patch that changes
> the condition to "rnp->qsmask & rdp->grpmask", which indicates that RCU
> needs a quiescent state from the CPU, and is valid regardless of how
> messed up the CPU is about which grace period is which.
> 
> I am making a similar change to the check in __note_new_gpnum().
> 
> Seem reasonable?

Look good yeah.

Thanks!

> 
> 							Thanx, Paul
> 
> > Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/rcutree.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index ccdc04c..8c4ed60 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -681,6 +681,14 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
> > 
> >  		/* Remember that we saw this grace-period completion. */
> >  		rdp->completed = rnp->completed;
> > +
> > +		/*
> > +		 * If another CPU handled our extended quiescent states and
> > +		 * we have no more grace period to complete yet, then stop
> > +		 * chasing quiescent states.
> > +		 */
> > +		if (rdp->completed == rnp->gpnum)
> > +			rdp->qs_pending = 0;
> >  	}
> >  }
> > 
> > -- 
> > 1.7.3.2
> > 
