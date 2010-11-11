Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0KKMbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:31:52 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33979 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab0KKMbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:31:50 -0500
Date: Thu, 11 Nov 2010 04:31:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 11/12] rcu: fix race condition in
 synchronize_sched_expedited()
Message-ID: <20101111123146.GF3134@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101107020507.GA4974@linux.vnet.ibm.com>
 <1289095532-5398-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <4CD94C0D.3030007@kernel.org>
 <4CDA5E40.3080205@cn.fujitsu.com>
 <20101111042014.GE3134@linux.vnet.ibm.com>
 <4CDBB309.9020406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDBB309.9020406@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:10:33AM +0100, Tejun Heo wrote:
> Hello, Paul, Lai.
> 
> On 11/11/2010 05:20 AM, Paul E. McKenney wrote:
> > On Wed, Nov 10, 2010 at 04:56:32PM +0800, Lai Jiangshan wrote:
> >> On 11/09/2010 09:26 PM, Tejun Heo wrote:
> >>> Hello, Paul.
> >>>
> >>>
> >>> How about something like the following?  It's slightly bigger but I
> >>> think it's a bit easier to understand.  Thanks.
> >>
> >> Hello, Paul, Tejun,
> >>
> >> I think this approach is good and much better when several tasks
> >> call synchronize_sched_expedited() at the same time.
> > 
> > I am becoming more comfortable with it as well.  Tejun, what kind of
> > testing did you do?  Lai, could you please run it on your systems?
> 
> I just compile tested it (so no SOB).  Please feel free to take it and
> shape it into a proper patch.  Oh, I think we can drop both mb()'s at
> the top and bottom as both atomic_inc_return() and atomic_cmpxchg()
> imply full memory barrier.

Actually, the memory barriers are still one source of discomfort to me.
I am concerned about the path out of the function that skips the
atomic_cmpxchg(), which seem to happen if some concurrent invocation
advances the "done" counter past us before we get around to checking it.
I agree on the atomic_inc_return() upon entry to the function, though.

And this is going to need some serious testing either way.  ;-)

							Thanx, Paul
