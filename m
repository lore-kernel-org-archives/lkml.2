Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1H2Qc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:32:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36179 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1H2QcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:32:22 -0400
Date: Mon, 29 Aug 2011 18:32:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 04/32] nohz: Separate idle sleeping time accounting from
 nohz switching
Message-ID: <20110829163212.GB8649@somewhere>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-5-git-send-email-fweisbec@gmail.com>
 <1314627800.2816.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314627800.2816.62.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:23:19PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > To prepare for having nohz mode switching independant from idle,
> > pull the idle sleeping time accounting out of the tick stop API.
> > 
> > This implies to implement some new API to call when we
> > enter/exit idle. 
> 
> I mean, I really love brevity, but you seem to just not state all the
> important bits ;-)
> 
> So the goal is to disable the tick more often (say when running 1
> userbound task), why does that need new hooks? If we already had the
> tick disabled, the tick_nohz_stop_sched_tick() call on going idle will
> simply not do anything.
> 
> If we go from idle to running something we want to enable the tick
> initially because doing the task wakeup involves RCU etc.. Once we find
> the task is indeed userbound and we've finished all our state we can
> disable the thing again.

That's because we are going to have two different sources of stop/restarting
the tick: either idle or a random task. In the case of idle we have very
specific things to handle like idle time accounting, idle stats, rcu, ...

I could do these things conditionally using a some idle_cpu() checks but
the end result would not be very proper.
