Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2CHWU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:20:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36042 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab2CHWUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:20:23 -0500
Message-ID: <1331245213.11248.446.camel@twins>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 23:20:13 +0100
In-Reply-To: <1331244812.25686.518.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
	 <1331232159.25686.456.camel@gandalf.stny.rr.com>
	 <1331235579.11248.402.camel@twins>
	 <1331237441.25686.469.camel@gandalf.stny.rr.com>
	 <1331238369.11248.426.camel@twins>
	 <1331240882.25686.499.camel@gandalf.stny.rr.com>
	 <1331241627.11248.430.camel@twins>
	 <1331241940.25686.502.camel@gandalf.stny.rr.com>
	 <1331242104.11248.432.camel@twins>
	 <1331242574.25686.505.camel@gandalf.stny.rr.com>
	 <1331242625.11248.433.camel@twins>
	 <1331243078.25686.510.camel@gandalf.stny.rr.com>
	 <1331243642.11248.441.camel@twins>
	 <1331244812.25686.518.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 17:13 -0500, Steven Rostedt wrote:
> > task-A (cpu0) task-B (cpu1)           task-C (cpu1)
> > 
> >               lock ->d_lock
> > lock ->i_lock
> > lock ->d_lock
> >                       <-------------- preempts B
> >               trylock ->i_lock
> > 
> > 
> > While is is perfectly normal, the result is that A stops spinning and
> > goes to sleep. Now B continues and loops ad infinitum because it keeps
> > getting ->d_lock before A because its cache hot on cpu1 and waking A
> > takes a while etc..
> 
> I'm confused? As A isn't doing a loop. B is doing the loop because it's
> trying to grab the locks in reverse order and can't take the i_lock.
> Your example above would have A go to sleep when it tries to take
> d_lock. 

Right, but what guarantees that A will ever get ->d_lock when B releases
it before B again acquires it?

B is in a very tight:

1:
 lock ->d_lock
 trylock ->i_lock
 unlock ->d_lock
 goto 1

loop, while A is doing:

1:
  trylock ->d_lock
  goto 1

and with rt-mutex having the equal priority lock stealing this reverts
to a plain test-and-set lock. There's only a tiny window in which A can
actually get the lock and that is hampered by B's cpu owning the
cacheline in exclusive mode.

I simply cannot see guaranteed progress here.
