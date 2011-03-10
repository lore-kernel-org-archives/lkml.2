Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab1CJAbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:31:11 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41922 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1CJAbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:31:07 -0500
Date: Wed, 9 Mar 2011 16:30:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] An RCU for SMP with a single CPU garbage collector
Message-ID: <20110310003056.GD2196@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110307210157.GG3104@linux.vnet.ibm.com>
 <20110307211613.GA26455@tsunami.ccur.com>
 <20110307225110.GA19414@tsunami.ccur.com>
 <20110308090742.GO3104@linux.vnet.ibm.com>
 <20110308155710.GA15138@tsunami.ccur.com>
 <20110308225355.GA3447@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308225355.GA3447@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 05:53:55PM -0500, Joe Korty wrote:
> On Tue, Mar 08, 2011 at 10:57:10AM -0500, Joe Korty wrote:
> > On Tue, Mar 08, 2011 at 04:07:42AM -0500, Paul E. McKenney wrote:
> >>> Thinking about it some more, the tap-into-syscall approach might
> >>> work in my implementation, in which case the tap-into-preempt-enable
> >>> code could go away.
> > > 
> >> OK, please let me know how that goes!
> >> 
> >>> Nice thing about RCU, the algorithms are infinitely mallable :)
> >> 
> >> Just trying to keep the code size finite.  ;-)
> > 
> > I hope to get to it this afternoon!  I especially like
> > the lockless nature of JRCU, and that the dedicated cpus
> > are not loaded down with callback inovcations either.
> > Not sure how to support the PREEMPT_RCU mode though; so
> > if Fredrick is planning to support that, that alone would
> > make his approach the very best.
> 
> 
> 
> Hi Paul,
> I had a brainstorm. It _seems_ that JRCU might work fine if
> all I did was remove the expensive preempt_enable() tap.
> No new taps on system calls or anywhere else.  That would
> leave only the context switch tap plus the batch start/end
> sampling that is remotely performed on each cpu by the
> garbage collector.  Not even rcu_read_unlock has a tap --
> it is just a plain-jane preempt_enable() now.
> 
> And indeed it works!  I am able to turn off the local
> timer interrupt on one (of 15) cpus and the batches
> keep flowing on.  I have two user 100%  use test apps
> (one of them does no system calls), when I run that
> on the timer-disabled cpu the batches still advance.
> Admittedly the batches do not advance as fast as before
> .. they used to advance at the max rate of 50 msecs/batch.
> Now I regularly see batch lengths approaching 400 msecs.
> 
> I plan to put some taps into some other low overhead places
> -- at all the voluntary preemption points, at might_sleep,
> at rcu_read_unlock, for safety purposes.  But it is nice
> to see a zero overhead approach that works fine without
> any of that.

If you had a user-level process that never did system calls and never
entered the scheduler, what do you do to force forward progress of the RCU
grace periods?  (This is force_quiescent_state()'s job in TREE_RCU, FYI.)

							Thanx, Paul
