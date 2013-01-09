Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab3AIED0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 23:03:26 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:38161 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab3AIEDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 23:03:25 -0500
MIME-Version: 1.0
Date: Tue, 8 Jan 2013 20:03:24 -0800
Message-ID: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com>
Subject: rwlock_t unfairness and tasklist_lock
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like others before me, I have discovered how easy it is to DOS a
system by abusing the rwlock_t unfairness and causing the
tasklist_lock read side to be continuously held (my abuse code makes
use of the getpriority syscall, but there are plenty of other ways
anyway).

My understanding is that the issue of rwlock_t fairness has come up
several times over the last 10 years (I first saw a fair rwlock_t
proposal by David Howells 10 years ago,
https://lkml.org/lkml/2002/11/8/102), and every time the answer has
been that we can't easily change this because tasklist_lock makes use
of the read-side reentrancy and interruptibility properties of
rwlock_t, and that we should really find something smart to do about
tasklist_lock. Yet that last part never gets done, and the problem is
still with us.

I am wondering:

- Does anyone know of any current work towards removing the
tasklist_lock use of rwlock_t ? Thomas Gleixner mentioned 3 years ago
that he'd give it a shot (https://lwn.net/Articles/364601/), did he
encounter some unforeseen difficulty that we should learn from ?

- Would there be any fundamental objection to implementing a fair
rwlock_t and dealing with the reentrancy issues in tasklist_lock ? My
proposal there would be along the lines of:

1- implement a fair rwlock_t - the ticket based idea from David
Howells seems quite appropriate to me

2- if any places use reader side reentrancy within the same context,
adjust the code as needed to get rid of that reentrancy

3- a simple way to deal with reentrancy between contexts (as in, we
take the tasklist_lock read side in process context, get interrupted,
and we now need to take it again in interrupt or softirq context)
would be to have different locks depending on context. tasklist_lock
read side in process context would work as usual, but in irq or
contexts we'd take tasklist_irq_lock instead (and, if there are any
irq handlers taking tasklist_lock read side, we'd have to disable
interrupt handling when tasklist_irq_lock is held to avoid further
nesting). tasklist_lock write side - that is, mainly fork() and exec()
- would have to take both tasklist_lock and tasklist_irq_lock, in that
order.

While it might seem to be a downside that tasklist_lock write side
would now have to take both tasklist_lock and tasklist_irq_lock, I
must note that this wouldn't increase the number of atomic operations:
the current rwlock_t implementation uses atomics on both lock and
unlock, while the ticket based one would only need atomics on the lock
side (unlock is just a regular mov instruction), so the total cost
should be comparable to what we have now.

Any comments about this proposal ?

(I should note that I haven't given much thought to tasklist_lock
before, and I'm not quite sure just from code inspection which read
locks are run in which context...)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
