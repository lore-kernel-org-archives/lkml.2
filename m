Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2KMWcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:32:54 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51894 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab2KMWcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:32:51 -0500
Date: Tue, 13 Nov 2012 14:23:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121113222350.GH2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
 <20121113211602.GA30150@linux.vnet.ibm.com>
 <20121113133922.47144a50@chromoly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113133922.47144a50@chromoly>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111322-3620-0000-0000-00000058ED4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 01:39:22PM -0800, Jacob Pan wrote:
> On Tue, 13 Nov 2012 13:16:02 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > Please refer to Documentation/thermal/intel_powerclamp.txt for more
> > > details.  
> > 
> > If I read this correctly, this forces a group of CPUs into idle for
> > about 600 milliseconds at a time.  This would indeed delay grace
> > periods, which could easily result in user complaints.  Also, given
> > the default RCU_BOOST_DELAY of 500 milliseconds in kernels enabling
> > RCU_BOOST, you would see needless RCU priority boosting.
> > 
> the default idle injection duration is 6ms. we adjust the sleep
> interval to ensure idle ratio. So the idle duration stays the same once
> set. So would it be safe to delay grace period for this small amount in
> exchange for less over head in each injection period?

Ah, 6ms of delay is much better than 600ms.  Should be OK (famous last
words!).

> > Of course, if the idle period extended for longer, you would see RCU
> > CPU stall warnings.  And if the idle period extended indefinitely, you
> > could hang the system -- the RCU callbacks on the idled CPU could not
> > be invoked, and if one of those RCU callbacks was waking someone up,
> > that someone would not be woken up.
> > 
> for the same algorithm, idle duration is not extended. the injected
> idle loop also yield to pending softirqs, i guess that is what rcu
> callbacks are using?

For most kernel configuration options, it does use softirq.  And yes,
the kthread you are using would yield to softirqs -- but only as long
as softirq processing hasn't moved over to ksoftirqd.  Longer term,
RCU will be moving from softirq to kthreads, though, and these might be
prempted by your powerclamp kthread, depending on priorities.  It looks
like you use RT prio 50, which would usually preempt the RCU kthreads
(unless someone changed the priorities).

> > It looks like you could end up with part of the system powerclamped
> > in some situations, and with all of it powerclamped in other
> > situations. Is that the case, or am I confused?
> > 
> could you explain the part that is partially powerclamped?

Suppose that a given system has two sockets.  Are the two sockets
powerclamped independently, or at the same time?  My guess was the
former, but looking at the code again, it looks like the latter.
So it is a good thing I asked, I guess.  ;-)

 							Thanx, Paul

> [Jacob Pan]
> 
> -- 
> Thanks,
> 
> Jacob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

