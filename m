Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab0ESM0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab0ESM0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:26:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-4-git-send-email-walken@google.com>
References: <1274135154-24082-4-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 03/10] rwsem: lighter active count checks when waking up readers
Date: Wed, 19 May 2010 13:25:31 +0100
Message-ID: <5592.1274271931@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> ... When there are waiter threads on a rwsem and the spinlock is held, other
> threads can only increment the active count by trying to grab the rwsem in
> up_xxxx().

That's not true.  A thread attempting to get an rwsem by issuing a down_read()
or down_write() will also unconditionally increment the active count before it
considers calling out to the slow path.

Maybe what you mean is that other threads wanting to do a wake up can only
increase the active count for the processes being woken up whilst holding the
rwsem's spinlock.

> +	/* If we come here from up_xxxx(), another thread might have reached
> +	 * rwsem_down_failed_common() before we acquired the spinlock and
> +	 * woken up an active locker.

Do you mean a waiter rather than an active locker?  If a process is still
registering activity on the rwsem, then it can't be woken yet.
Michel Lespinasse <walken@google.com> wrote:

> +	 * Note that we do not need to update the rwsem count: any writer
> +	 * trying to acquire rwsem will run rwsem_down_write_failed() due
> +	 * to the waiting threads, and block trying to acquire the spinlock.

That comma shouldn't be there.

>  	/* Grant an infinite number of read locks to the readers at the front
>  	 * of the queue.  Note we increment the 'active part' of the count by

I wonder if I should've called it the 'activity part' of the count rather than
the 'active part'.

Apart from that, the patch looks fine.  That's all comment/description fixes.

David
