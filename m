Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2CGP24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:28:56 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42565 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2CGP2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:28:55 -0500
Date: Wed, 7 Mar 2012 07:27:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Andre@jasper.es
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120307152703.GD2348@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120105135432.GA31450@elte.hu>
 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124194140.GB2381@linux.vnet.ibm.com>
 <20120124232911.GA11327@linux.vnet.ibm.com>
 <20120307114410.GA4214@swordfish.minsk.epam.com>
 <CA+5PVA4CdtQYbJBvpoAa7iyWegBpJaDBcFfXpXYX=pARw_SBSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA4CdtQYbJBvpoAa7iyWegBpJaDBcFfXpXYX=pARw_SBSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030715-5930-0000-0000-000005E002B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 09:09:39AM -0500, Josh Boyer wrote:
> On Wed, Mar 7, 2012 at 6:44 AM, Sergey Senozhatsky
> <sergey.senozhatsky@gmail.com> wrote:
> > > > > ------------------------------------------------------------------------
> >> > > >
> >> > > > idle: Avoid using RCU when RCU thinks the CPU is idle
> >> > > >
> >> > > > The x86 idle loops invoke cpuidle_idle_call() which uses tracing
> >> > > > which uses RCU.  Unfortunately, these idle loops have already
> >> > > > told RCU to ignore this CPU when they call it.  This patch hacks
> >> > > > the idle loops to avoid this problem, but probably causing several
> >> > > > other problems in the process.
> >> > > >
> >> > > > Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> > > > ---
> >> > >
> >> > > Hi Paul
> >> > >
> >> > > Just tested it on my x86_64 machine, but warnings are still here
> >> > >
> >> > > Thanks !
> >> >
> >> > Gah!!!  The mwait_idle() function itself (which is the default value of
> >> > the pm_idle function pointer) uses tracing and thus RCU!  What part of
> >> > "don't use RCU from idle CPUs" was unclear, one wonders?
> >> >
> >> > Ah well, the good news is that we can now detect such abuse and fix it.
> >> >
> >> > But fixing it appears to require pushing rcu_idle_enter() and
> >> > rcu_idle_exit() pairs down to the bottom of each and every idle loop
> >> > and governor.
> >> >
> >> > So...  The cpuidle_idle_call() function has an idle loop inside of itself,
> >> > namely the ->enter() call for the desired target state.  It does tracing
> >> > on both sides of that call.  Should the ->enter() calls actually avoid
> >> > use of tracing, I could push the rcu_idle_enter() and rcu_idle_exit()
> >> > down into cpuidle_idle_call().  We seem to have a ladder_governor and
> >> > a menu_governor in 3.2, and these have states, which in turn have ->enter
> >> > functions.
> >> >
> >> > Hmmm...  Residual power dissipation is given in milliwatts.  I could
> >> > imagine some heartburn from many of the more aggressive embedded folks,
> >> > given that they might prefer microwatts -- or maybe even nanowatts,
> >> > for all I know.
> >> >
> >> > There are a bunch of states defined in drivers/idle/intel_idle.c,
> >> > and these use intel_idle() as their ->enter() states.  This one looks
> >> > to have a nice place for rcu_idle_enter() and rcu_idle_exit().
> >> >
> >> > But I also need to push rcu_idle_enter() and rcu_idle_exit() into any
> >> > function that can be assigned to pm_idle():  default_idle(), poll_idle(),
> >> > mwait_idle(), and amd_e400_idle().  OK, that is not all -that- bad,
> >> > though this must also be done for a number of other architectures as well.
> >> >
> >> > OK, will post a patch.  I will need testing -- clearly my testing on KVM
> >> > is missing a few important code paths...
> >>
> >> And here is another version of the patch.
> > Hello,
> > I just hit the same problem.
> >
> > Is this patch scheduled for 3.3 until release or will land during 3.4
> > merge window?
> 
> There are 3 patches in Paul's 3.4 queue, and another 9 of Steven Rostedt's
> that fix this.  They'll wind up in 3.4.
> 
> I looked at reverting the patch that adds this new warning and it doesn't
> trivially revert.

What are you based on?  I should be able to disable the warning for
you easily enough.

							Thanx, Paul

