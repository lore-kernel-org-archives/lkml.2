Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab1KCPbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:31:21 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57402 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab1KCPbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:31:19 -0400
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.15.19
Date: Thu, 3 Nov 2011 08:31:02 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20111103153102.GC18443@leaf>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-19-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103040003.GE2042@leaf>
 <20111103115426.GD8198@somewhere.redhat.com>
 <20111103133231.GA2287@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103133231.GA2287@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 06:32:31AM -0700, Paul E. McKenney wrote:
> On Thu, Nov 03, 2011 at 12:54:33PM +0100, Frederic Weisbecker wrote:
> > On Wed, Nov 02, 2011 at 09:00:03PM -0700, Josh Triplett wrote:
> > > On Wed, Nov 02, 2011 at 01:30:40PM -0700, Paul E. McKenney wrote:
> > > > From: Frederic Weisbecker <fweisbec@gmail.com>
> > > > 
> > > > It is assumed that rcu won't be used once we switch to tickless
> > > > mode and until we restart the tick. However this is not always
> > > > true, as in x86-64 where we dereference the idle notifiers after
> > > > the tick is stopped.
> > > > 
> > > > To prepare for fixing this, add two new APIs:
> > > > tick_nohz_idle_enter_norcu() and tick_nohz_idle_exit_norcu().
> > > > 
> > > > If no use of RCU is made in the idle loop between
> > > > tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the arch
> > > > must instead call the new *_norcu() version such that the arch doesn't
> > > > need to call rcu_idle_enter() and rcu_idle_exit().
> > > 
> > > The _norcu names confused me a bit.  At first, I thought they meant
> > > "idle but not RCU idle, so you can use RCU", but from re-reading the
> > > commit message, apparently they mean "idle and RCU idle, so don't use
> > > RCU".  What about something like _forbid_rcu instead?  Or,
> > > alternatively, why not just go ahead and separate the two types of idle
> > > entirely rather than introducing the _norcu variants first?
> > 
> > Or tick_nohz_idle_enter_rcu_stop() and tick_nohz_idle_exit_rcu_restart()?
> > 
> > Sounds clear but too long. May be we can shorten the tick_nohz thing in the
> > beginning.
> 
> How about tick_nohz_rcu_idle_enter() vs. tick_nohz_idle_enter() on
> entry to the idle loop and tick_nohz_rcu_idle_exit() vs
> tick_nohz_idle_exit() on exit?
> 
> That said, I don't feel all that strongly on this naming topic.

Mostly I think that since this series tries to separate the concepts of
"idle nohz" and "rcu extended quiescent state", we should end up with
two entirely separate functions delimiting those two, without any
functions that poke both with correspondingly complex compound names.

- Josh Triplett
