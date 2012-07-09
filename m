Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2GIRjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:39:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57765 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2GIRjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:39:21 -0400
Date: Mon, 9 Jul 2012 19:39:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/6] rcu: Allow rcu_user_enter()/exit() to nest
Message-ID: <20120709173910.GA8185@somewhere.redhat.com>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-3-git-send-email-fweisbec@gmail.com>
 <20120706162708.GU2522@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706162708.GU2522@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 09:27:09AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 06, 2012 at 02:00:14PM +0200, Frederic Weisbecker wrote:
> > Allow calls to rcu_user_enter() even if we are already
> > in userspace (as seen by RCU) and allow calls to rcu_user_exit()
> > even if we are already in the kernel.
> > 
> > This makes the APIs more flexible to be called from architectures.
> > Exception entries for example won't need to know if they come from
> > userspace before calling rcu_user_exit().
> 
> You lost me on this one.  As long as the nesting level stays below
> a few tens, rcu_user_enter() and rcu_user_exit() already can nest.
> 
> Or are you saying that you need to deal with duplicate rcu_user_enter()
> calls that must be matched by a single rcu_user_exit() call?

Yep, we can have that kind of thing:

in_user = 1
==== syscall
rcu_user_exit() // in_user = 0
	==== exception
	rcu_user_exit()
	==== end of exception
==== end of syscall
rcu_user_enter()

This is because when we enter an exception, we don't have a different
entry whenever we trapped/faulted in userspace or kernelspace. So it's hard
to know if we were in userspace before the exception triggered. To avoid
complication in architecture code, I'm using this kind of "in_user" state.
