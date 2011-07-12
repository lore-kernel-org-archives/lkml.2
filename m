Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1GLTA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:00:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52493 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1GLTA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:00:27 -0400
Date: Tue, 12 Jul 2011 11:59:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com,
        peterz@infradead.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712185907.GJ2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712160324.GA1186@dumpdata.com>
 <20110712163947.GF2326@linux.vnet.ibm.com>
 <20110712180151.GA18257@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712180151.GA18257@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 02:01:51PM -0400, Konrad Rzeszutek Wilk wrote:
> > > http://darnok.org/xen/loop_cnt.log
> > > 
> > > which seems to imply that we are indeed stuck in that loop
> > > forever.
> > 
> > It does indeed, thank you!  Also it looks like interrupts are
> > disabled, and that timekeeping is similarly out of action.
> 
> .. With the latest patch the time looks to be advancing.

Sounds like an improvement.  ;-)

> > Disabling CONFIG_NO_HZ would be an interesting test case.
> 
> Hadn't done that yet. Compiling a kernel with "# CONFIG_NO_HZ is not set"
> right now.
> > 
> > > > o	Problems due to portions of the code attempting to use
> > > > 	RCU read-side critical sections while in dyntick-idle mode.
> > > > 	Frederic Weisbecker has located some of these, (though not yet
> > > > 	in Xen) and he has some diagnositics which may be found at:
> > > > 
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > > > 
> > > > 	on branch eqscheck.2011.07.08a.
> > > > 
> > > > 	You need to enable CONFIG_PROVE_RCU for these diagnostics to
> > > > 	be executed.
> > > 
> > > Ok, let me try those too.
> > 
> > Thank you!
> 
> Will shortly do this.
> > 
> > > > o	As always, there might be bugs in RCU.  ;-)
> > > > 
> > > > But the loop in task_waking_fair() looks like the most prominent smoking
> > > > gun at the moment.
> > 
> > And could you also please try out the patch that I posted earlier?
> 
> With the previous patch and the .. this is getting confusing. With this patch:
> http://darnok.org/xen/loop_cnt-extra.patch

That is indeed the patch I intended.

> I get this output: http://darnok.org/xen/log.loop_cnt-extra-patch (one guest
> with 4 VCPUS) and http://darnok.org/xen/loop_cnt-extra-patch.log (the guest with 16 VCPUs)

OK, so the infinite loop in task_waking_fair() happens even if RCU callbacks
are deferred until after the scheduler is fully initialized.  Sounds like
one for the scheduler guys.  ;-)

							Thanx, Paul
