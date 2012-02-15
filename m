Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab2BOOx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:53:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:53589 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525Ab2BOOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:52:07 -0500
Date: Wed, 15 Feb 2012 15:52:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
In-Reply-To: <20120215143710.GA10543@sgi.com>
Message-ID: <alpine.LFD.2.02.1202151547520.2794@ionos>
References: <20111108191149.GA7236@sgi.com> <alpine.LFD.2.02.1202151512420.2794@ionos> <20120215143710.GA10543@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Dimitri Sivanich wrote:

> On Wed, Feb 15, 2012 at 03:16:34PM +0100, Thomas Gleixner wrote:
> > On Tue, 8 Nov 2011, Dimitri Sivanich wrote:
> > > 
> > > Allow manual override of the tick_do_timer_cpu.
> > > 
> > > While not necessarily harmful, doing jiffies updates on an application cpu
> > > does cause some extra overhead that HPC benchmarking people notice.  They
> > > prefer to have OS activity isolated to certain cpus.  They like reproducibility
> > > of results, and having jiffies updates bouncing around introduces variability.
> > 
> > I really wonder about this changelog. The only case where jiffies
> > updates bounces around is the NOHZ case. In all other modes (periodic
> > or highres) the boot cpu gets the do_timer() duty and it's never
> > assigned to any other cpu.
> > 
> > So what's the point of this exercise? Moving it away from CPU0 for
> > acedemic reasons or what?
> >
> I wasn't specifically trying to move it away from CPU0 (having jiffies updates
> on CPU0 was and would be just fine for the nohz=off case).  The issue was
> that the tick_do_timer_cpu could be any cpu even in the nohz=off case (maybe
> something has changed that since?).  After the point of assignment it is
> static, but you never know which cpu it is.

It's always the boot cpu and that has been there from day one of that code.

tick_setup_device()
{
	/*
	 * First device setup ?
	 */
	if (!td->evtdev) {
		/*
		 * If no cpu took the do_timer update, assign it to
		 * this cpu:
		 */
		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
			tick_do_timer_cpu = cpu;

So the first CPU which registers a clock event device takes it. That's
the boot CPU, no matter what.

Thanks,

	tglx
