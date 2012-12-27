Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2L0StP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:49:15 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42662 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2L0StN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:49:13 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <50DC5CC0.6010003@redhat.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
	 <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com>
	 <1356549008.20133.20856.camel@edumazet-glaptop> <50DB5531.90500@redhat.com>
	 <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
	 <1356618448.30414.948.camel@edumazet-glaptop> <50DC5CC0.6010003@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Dec 2012 10:49:10 -0800
Message-ID: <1356634150.30414.1268.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-27 at 09:35 -0500, Rik van Riel wrote:

> 
> The lock acquisition time depends on the holder of the lock,
> and what the CPUs ahead of us in line will do with the lock,
> not on the caller IP of the spinner.
> 

That would be true only for general cases.

In network land, we do have spinlock acquisition time depending on the
context.

A garbage collector usually runs for longer time than the regular fast
path.

But even without gc, its pretty often we have consumer/producers that
don't have the same amount of work to perform per lock/unlock sections.

The socket lock per example, might be held for very small sections for
process contexts (lock_sock() / release_sock()), but longer sections
from softirq context. Of course, severe lock contention on a socket
seems unlikely in real workloads.

> Therefore, I am not convinced that hashing on the caller IP
> will add much, if anything, except increasing the chance
> that we end up not backing off when we should...
> 
> IMHO it would be good to try keeping this solution as simple
> as we can get away with.
> 

unsigned long hash = (unsigned long)lock ^
                     (unsigned long)__builtin_return_address(1);

seems simple enough to me, but I get your point.

I also recorded the max 'delay' value reached on my machine to check how
good MAX_SPINLOCK_DELAY value was :

[   89.628265] cpu 16 delay 3710
[   89.631230] cpu 6 delay 2930
[   89.634120] cpu 15 delay 3186
[   89.637092] cpu 18 delay 3789
[   89.640071] cpu 22 delay 4012
[   89.643080] cpu 11 delay 3389
[   89.646057] cpu 21 delay 3123
[   89.649035] cpu 9 delay 3295
[   89.651931] cpu 3 delay 3063
[   89.654811] cpu 14 delay 3335

Although it makes no performance difference to use a bigger/smaller one.



