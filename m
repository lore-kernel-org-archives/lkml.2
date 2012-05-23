Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab2EWP55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:57:57 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:61222 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2EWP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:57:56 -0400
Date: Wed, 23 May 2012 17:57:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 16/41] rcu: Restart the tick on non-responding adaptive
 nohz CPUs
Message-ID: <20120523155738.GI1663@somewhere>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-17-git-send-email-fweisbec@gmail.com>
 <20120522172050.GB8087@linux.vnet.ibm.com>
 <20120523135717.GC1663@somewhere>
 <20120523152009.GB2402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523152009.GB2402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 08:20:09AM -0700, Paul E. McKenney wrote:
> On Wed, May 23, 2012 at 03:57:24PM +0200, Frederic Weisbecker wrote:
> > On Tue, May 22, 2012 at 10:20:50AM -0700, Paul E. McKenney wrote:
> > > On Tue, May 01, 2012 at 01:54:50AM +0200, Frederic Weisbecker wrote:
> > > > When a CPU in adaptive nohz mode doesn't respond to complete
> > > > a grace period, issue it a specific IPI so that it restarts
> > > > the tick and chases a quiescent state.
> > > 
> > > Hello, Frederic,
> > > 
> > > I don't understand the need for this patch.  If the CPU is in
> > > adaptive-tick mode, RCU should see it as being in dyntick-idle mode,
> > > right?  If so, shouldn't RCU have already recognized the CPU as being
> > > in an extended quiescent state?
> > > 
> > > Or is this a belt-and-suspenders situation?
> > > 
> > > 							Thanx, Paul
> > 
> > If the tickless CPU is in userspace, it is in extended quiescent state. But
> > not if it runs tickless in the kernel. In this case we need to send it an IPI
> > so that it restarts the tick after checking rcu_pending().
> 
> But if it has registered itself with RCU as idle, for example, by calling
> rcu_user_enter(), then RCU will be ignoring that CPU, posting quiescent
> states as needed on its behalf.  So I still don't understand the need
> for this patch.

Indeed if we are going to stop the tick and enter extended quiescent state,
we can ignore this check. I can optimize that.

But if we try to stop the tick in the kernel, which means we can still meet
RCU read side critical sections, we need to prevent from stopping the tick
if there is a global grace period to complete.
