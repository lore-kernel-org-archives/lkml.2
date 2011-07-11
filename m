Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab1GKSKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:10:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52642 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab1GKSKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:10:42 -0400
Date: Mon, 11 Jul 2011 20:10:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/6] Check for use of RCU from dyntick-idle
 mode
Message-ID: <20110711181034.GF4109@somewhere.redhat.com>
References: <20110708154331.GA20161@linux.vnet.ibm.com>
 <20110711160330.GC4109@somewhere.redhat.com>
 <20110711163848.GF2245@linux.vnet.ibm.com>
 <20110711164405.GE4109@somewhere.redhat.com>
 <20110711170014.GI2245@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711170014.GI2245@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:00:14AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 11, 2011 at 06:44:08PM +0200, Frederic Weisbecker wrote:
> > On Mon, Jul 11, 2011 at 09:38:48AM -0700, Paul E. McKenney wrote:
> > > On Mon, Jul 11, 2011 at 06:03:32PM +0200, Frederic Weisbecker wrote:
> > > > On Fri, Jul 08, 2011 at 08:43:31AM -0700, Paul E. McKenney wrote:
> > > > > Hello!
> > > > > 
> > > > > This set of patches adds checks for use of RCU from "extended quiescent
> > > > > states" such as dyntick-idle mode.  Such use is grossly illegal because
> > > > > RCU by definition ignores CPUs that are in extended quiescent states.
> > > > > In the case of dyntick-idle mode, the only way for RCU to avoid ignoring
> > > > > such CPUs would be to wake them up periodically, which would defeat the
> > > > > whole purpose of dyntick-idle mode.
> > > > > 
> > > > > The good news is that Frederic got this effort started.  The bad news is
> > > > > that there are several cases where RCU read-side critical sections appear
> > > > > in dyntick-idle mode.
> > > > 
> > > > Ok, let me send to you the patch that splits up rcu/tickless logic and I'll try
> > > > to fix up what you reported to me in ppc.
> > > 
> > > Very good, thank you!
> > > 
> > > > BTW, are you aware of other cases? You mentioned "several" :)
> > > 
> > > PowerPC's hypercall-exit trace event will also cause this complaint.
> > 
> > Ok looking at this.
> 
> Oh, and I removed some of my RCU dyntick-idle trace events because
> they triggered this warning.  This would of course be a problem regardless
> of where the RCU dyntick-idle APIs were called from, so I just took the
> approach of more carefully placing the trace events.
> 
> > > Plus I thought you saw some others.
> > 
> > Nope, mine were spurious. In my v1 rcu_dereference_check warned if rcu read lock
> > wasn't held but didn't handle the rest of the conditional (another lock held or
> > simply 1 in rcu_dereference_raw()).
> > 
> > In the v3, the one you applied, they legitimately disappeared.
> 
> OK, good to know!

Ah, actually:

[    0.649412] WARNING: at include/linux/rcupdate.h:262 __atomic_notifier_call_chain+0xf8/0x110()
[    0.649414] Hardware name: AMD690VM-FMH
[    0.649415] Modules linked in: [<ffffffff81051ed5>] warn_slowpath_null+0x15/0x20
[    0.649420] 
[    0.649422] Pid: 0, comm: kworker/0:1 Tainted: G        W   3.0.0-rc6+ #250
[    0.649433] Call Trace:
[    0.649437]  [<ffffffff81051e8a>] warn_slowpath_common+0x7a/0xb0
[    0.649441]  [<ffffffff81051ed5>] warn_slowpath_null+0x15/0x20
[    0.649449]  [<ffffffff817da5c8>] __atomic_notifier_call_chain+0xf8/0x110
[    0.649468]  [<ffffffff817da5c8>] __atomic_notifier_call_chain+0xf8/0x110
[    0.649480]  [<ffffffff810018a0>] enter_idle+0x20/0x30
[    0.649483]  [<ffffffff817da5f1>] atomic_notifier_call_chain+0x11/0x20
[    0.649487]  [<ffffffff81001995>] cpu_idle+0xa5/0x110
[    0.649494]  [<ffffffff817ce3d5>] start_secondary+0x1df/0x1e6
[    0.649500] ---[ end trace f17e946d22a56016 ]---
