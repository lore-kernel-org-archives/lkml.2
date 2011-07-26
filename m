Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1GZVHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:07:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59979 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1GZVHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:07:16 -0400
Subject: per-cpu operation madness vs validation
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Jul 2011 23:06:50 +0200
Message-ID: <1311714410.24752.404.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

so recently our per-cpu ops have exploded.. who can say (without
looking) what the difference is between percpu_read() and
this_cpu_read() ?

Now Thomas recently did a fresh -rt and ran into the fun problem of
trying to reconstruct the requirements on a lot of the per-cpu grub
we've grown over the past few releases.

Does it require preempt-disable, bh disable, irq-disable, is it perhaps
covered by a lock, what!? I'm sure Thomas can point you to a few gems if
you're interested in specifics.

Now the reason is of course that -rt changes some things, even when
using migrate_disable() it might be multiple processes might try and
access the per-cpu variable, needing serialization.

The idea was to do something similar to rcu-lockdep, where each
rcu_dereference() was paired with a conditional that expresses the exact
conditions under which that dereference was good -- typically either
when holding the rcu_read_lock() or the lock used to serialize the
modifying side of things.

Even for mainline such validation is useful, suppose you intended the
variable to only be accessed by task context, and thus disabling
preemption is plenty to fully serialize things. However unbeknown to the
original author someone adds usage from IRQ context, and voila things
start breaking.

The point of course is, how are we going to go about doing this, I'm
sure adding a proper conditional to each and every per-cpu op is going
to be a herculean task, and most of it utterly boring.

One of the thing we could do is create a lock type that doesn't actually
generate any lock code on mainline (but does on rt) but is instead used
to annotate the serialization requirements of various of these things.
If such a lock isn't IRQ safe but used from IRQ context lockdep will
complain etc..


