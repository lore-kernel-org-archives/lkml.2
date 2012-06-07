Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab2FHE2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:28:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53479 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2FHE1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:47 -0400
Date: Thu, 7 Jun 2012 15:45:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] rcu: Extended quiescent state for adaptive nohz
Message-ID: <20120607224508.GX19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
 <20120604181313.GL2490@linux.vnet.ibm.com>
 <CAFTL4hzqa1z4icSBwEqZXLjCrVsG+axm2TaGSaaMXkjazT0Qfw@mail.gmail.com>
 <20120604210709.GO2490@linux.vnet.ibm.com>
 <20120605103055.GA4553@somewhere.redhat.com>
 <20120605234640.GY2388@linux.vnet.ibm.com>
 <20120607142101.GI19842@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120607142101.GI19842@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-3534-0000-0000-0000092937BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 04:21:09PM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 05, 2012 at 04:46:40PM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 05, 2012 at 12:31:00PM +0200, Frederic Weisbecker wrote:
> > > On Mon, Jun 04, 2012 at 02:07:09PM -0700, Paul E. McKenney wrote:
> > > > On Mon, Jun 04, 2012 at 09:06:22PM +0200, Frederic Weisbecker wrote:
> > > > > 2012/6/4 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > > > > > On Mon, Jun 04, 2012 at 02:08:26PM +0200, fweisbec@gmail.com wrote:
> > > > > >> From: Frederic Weisbecker <fweisbec@gmail.com>
> > > > > >>
> > > > > >> Paul, Ingo,
> > > > > >>
> > > > > >> This is a rebase of the nohz cpusets RCU APIs on top of Paul's latest
> > > > > >> -rcu (rcu/core) branch.
> > > > > >>
> > > > > >> I have only built tested it yet, I need to do a full rebase of my
> > > > > >> tree to test it in practice. But I wanted to show you how it looks
> > > > > >> like first.
> > > > > >>
> > > > > >> I also wonder if we can set that to a tree somewhere. Ingo suggested
> > > > > >> to set up a tree on -tip to apply the uncontroversial part of nohz
> > > > > >> cpusets patches and iterate from there. I think it would accelerate
> > > > > >> everything if we start doing that.
> > > > > >
> > > > > > It would probably be best to put these two in the -rcu set in order to
> > > > > > avoid conflicts with possible further RCU_FAST_NO_HZ work.  I could
> > > > > > push this to -tip early, if that would help.
> > > > > 
> > > > > But then these APIs are going to be upstream on 3.6
> > > > > Is that ok for you even if they don't have any upstream user?
> > > > > We can ifdef it.
> > > > 
> > > > I figured on maintaining a separate rcu/idle topic branch that I would
> > > > merge locally for building and testing, but which I would not push
> > > > to rcu/next.  If Ingo agrees, I can push separately to -tip so that it
> > > > does not go upstream until you are ready, at which point I would merge
> > > > it into rcu/next.
> > > > 
> > > > Seem reasonable, or would something else work better?
> > > 
> > > Sounds very good!
> > 
> > Here you go:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/idle
> 
> Thanks!
> 
> I can see you've implemented a version for TinyRCU. Nohz cpusets only work on
> SMP right now because there must be at least one CPU running with the tick
> to maintain the timekeeping. I'm pretty confident that one day we'll remove
> the jiffies and we'll be able to do the whole timekeeping by using the TSC
> or so. There is quite a way before we reach that though.

In the meantime, would it make sense to slow the tick rate by a factor
of 10 or so on that one CPU when nothing else is going on?  Or does
timekeeping absolutely require running the tick at full speed?

							Thanx, Paul

