Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2EGVcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:32:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53048 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab2EGVck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:32:40 -0400
Date: Mon, 7 May 2012 13:55:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Warning in worker_enter_idle()
Message-ID: <20120507205516.GD21152@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120506153814.GA25681@linux.vnet.ibm.com>
 <20120507194042.GG19417@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507194042.GG19417@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050721-3534-0000-0000-000008299927
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 12:40:42PM -0700, Tejun Heo wrote:
> Hello, Paul.
> 
> On Sun, May 06, 2012 at 08:38:14AM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > The worker_enter_idle() is complaining that there all workers are idle,
> > but that there is work remaining:
> > 
> > 	/* sanity check nr_running */
> > 	WARN_ON_ONCE(gcwq->nr_workers == gcwq->nr_idle &&
> > 		     atomic_read(get_gcwq_nr_running(gcwq->cpu)));
> > 
> > This is running on Power, .config attached.  I must confess that I don't
> > see any sort of synchronization or memory barriers that would keep the
> > counts straight on a weakly ordered system.  Or is there some clever
> > design constraint that prevents worker_enter_idle() from accessing other
> > CPUs' gcwq_nr_running variables?
> 
> Workers are tied to global cpu workqueues (gcwqs).  There's one gcwq
> per cpu and one unbound one, so yeah, workers access these counters
> under gcwq->lock.  Atomic accesses to nr_running is depended on only
> while nr_idle is adjusted under gcwq->lock, so there shouldn't be a
> discrepancy there.  Can you reproduce the problem?  What was going on
> the system?  Was CPU being brought up or down?

I was running rcutorture with CPU hotplug operations.  It has happened
a couple of times on the .config that I attached, but never under any
of the other 13 .configs that I run.

							Thanx, Paul

