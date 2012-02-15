Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab2BOPfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:35:06 -0500
Received: from relay3.sgi.com ([192.48.152.1]:35067 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750910Ab2BOPfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:35:03 -0500
Date: Wed, 15 Feb 2012 09:34:38 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20120215153438.GB11343@sgi.com>
References: <20111108191149.GA7236@sgi.com>
 <alpine.LFD.2.02.1202151512420.2794@ionos>
 <20120215143710.GA10543@sgi.com>
 <alpine.LFD.2.02.1202151547520.2794@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202151547520.2794@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:52:06PM +0100, Thomas Gleixner wrote:
> On Wed, 15 Feb 2012, Dimitri Sivanich wrote:
> 
> > On Wed, Feb 15, 2012 at 03:16:34PM +0100, Thomas Gleixner wrote:
> > > On Tue, 8 Nov 2011, Dimitri Sivanich wrote:
> > > > 
> > > > Allow manual override of the tick_do_timer_cpu.
> > > > 
> > > > While not necessarily harmful, doing jiffies updates on an application cpu
> > > > does cause some extra overhead that HPC benchmarking people notice.  They
> > > > prefer to have OS activity isolated to certain cpus.  They like reproducibility
> > > > of results, and having jiffies updates bouncing around introduces variability.
> > > 
> > > I really wonder about this changelog. The only case where jiffies
> > > updates bounces around is the NOHZ case. In all other modes (periodic
> > > or highres) the boot cpu gets the do_timer() duty and it's never
> > > assigned to any other cpu.
> > > 
> > > So what's the point of this exercise? Moving it away from CPU0 for
> > > acedemic reasons or what?
> > >
> > I wasn't specifically trying to move it away from CPU0 (having jiffies updates
> > on CPU0 was and would be just fine for the nohz=off case).  The issue was
> > that the tick_do_timer_cpu could be any cpu even in the nohz=off case (maybe
> > something has changed that since?).  After the point of assignment it is
> > static, but you never know which cpu it is.
> 
> It's always the boot cpu and that has been there from day one of that code.
> 
> tick_setup_device()
> {
> 	/*
> 	 * First device setup ?
> 	 */
> 	if (!td->evtdev) {
> 		/*
> 		 * If no cpu took the do_timer update, assign it to
> 		 * this cpu:
> 		 */
> 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
> 			tick_do_timer_cpu = cpu;
> 
> So the first CPU which registers a clock event device takes it. That's
> the boot CPU, no matter what.
>
Both kernel tracing and the original patch that I proposed for this
showed plainly (at the time) that the tick_do_timer_cpu was not always cpu 0
prior to modifying it for nohz=off.  Maybe that is no longer the case?
