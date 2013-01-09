Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab3AIXUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:20:49 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:53837 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3AIXUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:20:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130109174922.GA31211@redhat.com>
References: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com>
	<20130109174922.GA31211@redhat.com>
Date: Wed, 9 Jan 2013 15:20:47 -0800
Message-ID: <CANN689FEr+vFdNekW9hm7xwji1aX4FCUQ1BS=P3FhyKiC70qjg@mail.gmail.com>
Subject: Re: rwlock_t unfairness and tasklist_lock
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 9:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/08, Michel Lespinasse wrote:
>> Like others before me, I have discovered how easy it is to DOS a
>> system by abusing the rwlock_t unfairness and causing the
>> tasklist_lock read side to be continuously held
>
> Yes. Plus it has perfomance problems.
>
> It should die. We still need the global lock to protect, say,
> init_task.tasks list, but otherwise we need the per-process locking.

To be clear: I'm not trying to defend tasklist_lock here. However,
given how long this has been a known issue, I think we should consider
attacking the problem from the lock fairness perspective first and
stop waiting for an eventual tasklist_lock death.

>> - Would there be any fundamental objection to implementing a fair
>> rwlock_t and dealing with the reentrancy issues in tasklist_lock ? My
>> proposal there would be along the lines of:
>
> I don't really understand your proposal in details, but until we kill
> tasklist_lock, perhaps it makes sense to implement something simple, say,
> write-biased rwlock and add "int task_struct->tasklist_read_lock_counter"
> to avoid the read-write-read deadlock.

Right. But one complexity that has to be dealt with, is how to handle
reentrant uses of the tasklist_lock read side, when such uses come
from a different context (say, the lock was first taken in process
context and the reentrant use is in irq or softirq context).

If in process context we take the tasklist_lock read side, and *then*
increment the tasklist_read_lock_counter, there is still the
possibility of an irq coming up in before the counter is incremented.
So to deal with that, I think we have to explicitly detect the
tasklist_lock uses that are in irq/softirq context and deal with these
differently from those in process context - we would have to either
ignore the tasklist_lock write bias when in irq/softirq context, or we
could deal with it by taking a separate lock then (as in my proposal).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
