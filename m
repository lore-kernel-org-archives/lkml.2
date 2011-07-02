Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1GBQxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:53:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54344 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1GBQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:53:49 -0400
Date: Sat, 2 Jul 2011 18:53:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Michal Marek <mmarek@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL v2] sched: Make sleep inside atomic detection work on
 !PREEMPT
Message-ID: <20110702165342.GA317@somewhere>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
 <20110622224844.GA3290@somewhere>
 <20110701123629.GA12605@elte.hu>
 <20110701125644.GD8508@somewhere>
 <20110701125926.GF12605@elte.hu>
 <20110701150517.GA24707@elte.hu>
 <20110701164425.GG8508@somewhere>
 <20110701172934.GA6240@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701172934.GA6240@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 07:29:34PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Jul 01, 2011 at 05:05:17PM +0200, Ingo Molnar wrote:
> > > 
> > > -tip testing also found that m32r fails to build:
> > > 
> > > /home/mingo/tip/kernel/sched.c: In function 'preempt_schedule':
> > > /home/mingo/tip/kernel/sched.c:4364: error: implicit declaration of function 'add_preempt_count_notrace'
> > > /home/mingo/tip/kernel/sched.c:4366: error: implicit declaration of function 'sub_preempt_count_notrace'
> > > 
> > > due to:
> > > 
> > > bdd4e85dc36cdbcfc1608a5b2a17c80a9db8986a is the first bad commit
> > > commit bdd4e85dc36cdbcfc1608a5b2a17c80a9db8986a
> > > Author: Frederic Weisbecker <fweisbec@gmail.com>
> > > Date:   Wed Jun 8 01:13:27 2011 +0200
> > > 
> > >     sched: Isolate preempt counting in its own config option
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > 
> > I have no clue how that did happen.
> > 
> > Can you send me your config?
> 
> Just the m32r defconfig: m32700ut.smp_defconfig.
> 
> My guess would be that one of these:
> 
>  include/linux/bit_spinlock.h |    2 +-
>  include/linux/hardirq.h      |    4 ++--
>  include/linux/pagemap.h      |    4 ++--
>  include/linux/preempt.h      |   26 +++++++++++++++++---------
>  include/linux/rcupdate.h     |   12 ++++++------
>  include/linux/sched.h        |    2 +-
> 
> changed/exposed some header dependency quirk on m32r, failing the 
> build. Or m32r has some strange .config combo.
> 
> Thanks,
> 
> 	Ingo

That's weird.

We have this:

	config PREEMPT
		bool
		select PREEMPT_COUNT

	config PREEMPT_COUNT
		bool

Then I run "make ARCH=m32r defconfig" that has CONFIG_PREEMPT=y
but it doesn't select PREEMPT_COUNT and happily runs to break few
times after.

Even running make ARCH=m32r oldconfig on the defconfig doesn't fix up
the issue.

I thought "select" was an unconditional action. What am I missing?

I'm adding in Cc more people who know better kconfig/kbuild than me.
Every time I finally consider I know well the Kconfig language, I quickly
get caught up by the fate...
