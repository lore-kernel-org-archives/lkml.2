Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab1H3U7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 16:59:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58536 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1H3U7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 16:59:21 -0400
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Date: Tue, 30 Aug 2011 22:58:38 +0200
References: <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
	 <1314627922.2816.65.camel@twins>
	 <20110829171155.GD9748@somewhere.redhat.com>
	 <1314640155.2816.117.camel@twins>
	 <20110829175954.GF9748@somewhere.redhat.com>
	 <1314641160.2816.128.camel@twins>
	 <20110829233521.GK9748@somewhere.redhat.com>
	 <1314703315.2799.5.camel@twins>
	 <20110830143207.GP9748@somewhere.redhat.com>
	 <1314717993.5812.11.camel@twins>
	 <20110830153343.GW9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314737918.19586.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 17:42 +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 17:33 +0200, Frederic Weisbecker wrote:
> > > See all that is still kernelspace ;-) I think I know what you mean to
> > > say though, but seeing as you note there is even now a known shortcoming
> > > I'm not very confident its a solid construction. What will help us find
> > > such holes?
> > 
> > This: https://lkml.org/lkml/2011/6/23/744
> > 
> > It's in one of Paul's branches and should make it for the next merge window.
> > This should detect any of such holes. I made that on purpose for the nohz cpusets
> > when I saw how much error prone that can be with rcu :)
> 
> OK, good ;-)
> 
> > > I would much rather we not rely on such fragile things too much.. this
> > > RCU stuff wants way more thought, as it stands your patch-set doesn't do
> > > anything useful IMO.
> > 
> > Not sure what you mean. Well that Rcu thing for sure is fragile but we have
> > the tools ready to find the problems. 
> 
> Right that thing you linked above does catch abuse, still your current
> proposal means that due to RCU it will basically never disable the tick.

So how about something like:

Assuming we are in rcu_nohz state; on kernel enter we leave rcu_nohz but
don't start the tick, instead we assign another cpu to run our state
machine.

On kernel exit we 'donate' all our rcu state to a willing victim (the
same that earlier was kind enough to drive our state) and undo our
entire GP accounting and re-enter rcu_nohz state.

If between that time we did restart the tick, we take back our rcu state
and skip the donate and rcu_nohz enter on kernel exit.

I really should go read all those docs Paul send me to see how insane
the above is.
