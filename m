Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1CBKbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:31:10 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:46031 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1CBKbI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Wed, 2 Mar 2011 05:31:08 -0500
Message-Id: <4D6E2A7802000078000347B7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 02 Mar 2011 10:31:04 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: x86's rwlock scalability and fairness
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With RW_LOCK_BIAS being 0x01000000 and with (significantly) more
than 128 CPUs in a system, there is a non-zero probability for 129 or
more CPUs to simultaneously attempt to acquire an rwlock in write
mode, and if sufficiently many (129) of them manage to subtract the
bias from the counter subsequent attempts to acquire the lock for
reading will succeed independent of whether the lock is already being
held in write mode. The probability of this happening is obviously
larger in a virtual environment (i.e. when the time window between
the execution of two consecutive instructions can be unbounded).

Consequently I think RW_LOCK_BIAS needs to be adjusted such
that RW_LOCK_BIAS * NR_CPUS * 2 - 1 fits into the lock counter.

For 32-bits (with a limit of 512 CPUs) this can be achieved without
widening the counter (as even with a bias of 0x00400000 there's
still room for 0x2000 nested read acquires on each CPU).

For 64-bits, the counter would need to be widened at least for the
MAXSMP case - the question is whether it should be widened
unconditionally.

There's also a fairness concern (again, likely more of a problem
when running virtualized): Writers can get delayed unboundedly
as long as new readers trickle in, since all writers undo their
subtraction of the bias in __write_lock_failed. Simply blocking all
future readers can't be done with the nesting semantics Linux
uses for rwlocks, so the question is whether another scheme
could be created (or had already been proposed - I did find a
number of references, like the model sketched out by Linus at
http://lkml.indiana.edu/hypermail/linux/kernel/0808.2/2861.html,
which admittedly I'm not sure meets the nesting requirement -,
but there must be reasons none of them made it into the kernel
so far) that would allow nested acquires but disallows new CPUs
to acquire the first instance of a lock when there's a waiting writer.

One possible scheme would involve per-CPU lists of rwlocks held
in read mode - if acquiring fails, the CPU would walk that list and
decrement the counter anyway if it finds the lock already present
on that list. The first writer to come in would then no longer undo
its subtraction of the bias, thus forcing all future readers into the
__read_lock_failed path. This, however, would require changes
to all users of rwlocks as the linked list elements would need to
live on the stack (in the scope of the top-most function common
between lock and unlock), which doesn't look very nice.

Similarly of concern (for virtualization again, but presumably also
for rt) is the lack of interrupt re-enabling in the acquire-failed
paths of arch_{read,write}_lock_flags().

Jan

