Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2JOBIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 21:08:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49295 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2JOBIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 21:08:12 -0400
Date: Sun, 14 Oct 2012 18:07:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Becky Bruce <bgillbruce@gmail.com>,
        Subodh Nijsure <snijsure@grid-net.com>, Paul Walmsley <paul@pwsan.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 097/120] rcu: Fix day-one dyntick-idle stall-warning bug
Message-ID: <20121015010735.GF3288@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121011005825.364610894@linuxfoundation.org>
 <20121011005844.760264316@linuxfoundation.org>
 <1350080068.4832.35.camel@deadeye.wl.decadent.org.uk>
 <20121014233249.GB3288@linux.vnet.ibm.com>
 <1350258853.26833.31.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350258853.26833.31.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101501-7408-0000-0000-00000957D253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:54:13AM +0100, Ben Hutchings wrote:
> On Sun, 2012-10-14 at 16:32 -0700, Paul E. McKenney wrote:
> > On Fri, Oct 12, 2012 at 11:14:28PM +0100, Ben Hutchings wrote:
> > > On Thu, 2012-10-11 at 10:00 +0900, Greg Kroah-Hartman wrote:
> > > > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > > > 
> > > > commit a10d206ef1a83121ab7430cb196e0376a7145b22 upstream.
> > > [...]
> > > > This commit therefore makes CPUs check more carefully before starting a
> > > > new grace period.  This new check relies on an array of tail pointers
> > > > into each CPU's list of callbacks.  If the CPU is up to date on which
> > > > grace periods have completed, it checks to see if any callbacks follow
> > > > the RCU_DONE_TAIL segment, otherwise it checks to see if any callbacks
> > > > follow the RCU_WAIT_TAIL segment.  The reason that this works is that
> > > > the RCU_WAIT_TAIL segment will be promoted to the RCU_DONE_TAIL segment
> > > > as soon as the CPU is officially notified that the old grace period
> > > > has ended.
> > > [...]
> > > > --- a/kernel/rcutree.c
> > > > +++ b/kernel/rcutree.c
> > > > @@ -295,7 +295,9 @@ cpu_has_callbacks_ready_to_invoke(struct
> > > >  static int
> > > >  cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
> > > >  {
> > > > -	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
> > > > +	return *rdp->nxttail[RCU_DONE_TAIL +
> > > > +			     ACCESS_ONCE(rsp->completed) != rdp->completed] &&
> > > 
> > > This is a very obscurely written expression.  The array index is parsed
> > > as:
> > > 	(RCU_DONE_TAIL + ACCESS_ONCE(rsp->completed)) != rdp->completed
> > > 
> > > Since RCU_DONE_TAIL == 0 and RCU_WAIT_TAIL == 1, this is then equivalent
> > > to:
> > > 	ACCESS_ONCE(rsp->completed) != rdp->completed
> > > or:
> > > 	(ACCESS_ONCE(rsp->completed) != rdp->completed) ? RCU_WAIT_TAIL : RCU_DONE_TAIL
> > > 
> > > But whyever didn't you write that explicitly?
> > 
> > Because the way I think of it is the way that I wrote it -- you should
> > look at the value of the first pointer unless this CPU isn't up to date
> > with the latest grace period, in which case you need to go one step
> > farther up the array of tail pointers.
> 
> That is not the way you wrote it, since + has higher precedence than !=.

Color me slow and stupid!!!  Indeed, it is working by accident.  I clearly
need to either add the parentheses or use one of the other forms...

								Thanx, Paul

