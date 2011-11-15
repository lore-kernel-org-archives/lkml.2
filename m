Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab1KOSal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:30:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58475 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151Ab1KOSaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:30:39 -0500
Date: Tue, 15 Nov 2011 19:30:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH RFC tip/core/rcu 19/28] nohz: Allow rcu extended
 quiescent state handling seperately from tick stop
Message-ID: <20111115183026.GB3234@somewhere>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-19-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103040003.GE2042@leaf>
 <20111103115426.GD8198@somewhere.redhat.com>
 <20111103133231.GA2287@linux.vnet.ibm.com>
 <20111103153102.GC18443@leaf>
 <20111103160656.GC2287@linux.vnet.ibm.com>
 <20111109164804.GA17538@somewhere.redhat.com>
 <20111110172219.GC2354@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110172219.GC2354@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 09:22:19AM -0800, Paul E. McKenney wrote:
> On Wed, Nov 09, 2011 at 05:48:11PM +0100, Frederic Weisbecker wrote:
> > On Thu, Nov 03, 2011 at 09:06:56AM -0700, Paul E. McKenney wrote:
> > > On Thu, Nov 03, 2011 at 08:31:02AM -0700, Josh Triplett wrote:
> > > > On Thu, Nov 03, 2011 at 06:32:31AM -0700, Paul E. McKenney wrote:
> > > > > On Thu, Nov 03, 2011 at 12:54:33PM +0100, Frederic Weisbecker wrote:
> > > > > > On Wed, Nov 02, 2011 at 09:00:03PM -0700, Josh Triplett wrote:
> > > > > > > On Wed, Nov 02, 2011 at 01:30:40PM -0700, Paul E. McKenney wrote:
> > > > > > > > From: Frederic Weisbecker <fweisbec@gmail.com>
> > > > > > > > 
> > > > > > > > It is assumed that rcu won't be used once we switch to tickless
> > > > > > > > mode and until we restart the tick. However this is not always
> > > > > > > > true, as in x86-64 where we dereference the idle notifiers after
> > > > > > > > the tick is stopped.
> > > > > > > > 
> > > > > > > > To prepare for fixing this, add two new APIs:
> > > > > > > > tick_nohz_idle_enter_norcu() and tick_nohz_idle_exit_norcu().
> > > > > > > > 
> > > > > > > > If no use of RCU is made in the idle loop between
> > > > > > > > tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the arch
> > > > > > > > must instead call the new *_norcu() version such that the arch doesn't
> > > > > > > > need to call rcu_idle_enter() and rcu_idle_exit().
> > > > > > > 
> > > > > > > The _norcu names confused me a bit.  At first, I thought they meant
> > > > > > > "idle but not RCU idle, so you can use RCU", but from re-reading the
> > > > > > > commit message, apparently they mean "idle and RCU idle, so don't use
> > > > > > > RCU".  What about something like _forbid_rcu instead?  Or,
> > > > > > > alternatively, why not just go ahead and separate the two types of idle
> > > > > > > entirely rather than introducing the _norcu variants first?
> > > > > > 
> > > > > > Or tick_nohz_idle_enter_rcu_stop() and tick_nohz_idle_exit_rcu_restart()?
> > > > > > 
> > > > > > Sounds clear but too long. May be we can shorten the tick_nohz thing in the
> > > > > > beginning.
> > > > > 
> > > > > How about tick_nohz_rcu_idle_enter() vs. tick_nohz_idle_enter() on
> > > > > entry to the idle loop and tick_nohz_rcu_idle_exit() vs
> > > > > tick_nohz_idle_exit() on exit?
> > > > > 
> > > > > That said, I don't feel all that strongly on this naming topic.
> > > > 
> > > > Mostly I think that since this series tries to separate the concepts of
> > > > "idle nohz" and "rcu extended quiescent state", we should end up with
> > > > two entirely separate functions delimiting those two, without any
> > > > functions that poke both with correspondingly complex compound names.
> > > 
> > > Having four API members rather than the current six does seem quite
> > > attractive to me.  Frederic, any reason why this approach won't work?
> > 
> > The approach I took might sound silly but it's mostly an optimization:
> > 
> > I did the *_norcu() variant mostly to be able to keep rcu_idle_enter()
> > call under the same local_irq_disable() section.
> > 
> > This way we can't have an interrupt in between that can needlessly perform
> > RCU work (and trigger the softirq in the worst case), delaying the point
> > where we actually put the CPU to sleep.
> 
> But we have to tolerate this sort of thing on some architectures (x86
> and Power) in order to allow idle-task use of RCU read-side primitives,
> right?
> 
> So consolidating from six to four APIs doesn't expand the overall state
> space.

Well, we tolerate that, the two more APIs are there for optimization, not
to provide correctness.
But if you want me to remove the optimization and keep only the four APIs I can do it.
