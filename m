Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1LTQX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:23:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34604 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1LTQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:23:22 -0500
Date: Tue, 20 Dec 2011 08:23:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <20111220162315.GC10752@google.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pekka.

On Tue, Dec 20, 2011 at 11:47:26AM +0200, Pekka Enberg wrote:
> So, I actually looked into doing something like this and wasn't
> actually able to understand the purpose of the various percpu
> variants. It seems rather obvious that we can just drop the
> non-irqsafe cmpxchg() variant but what about the rest of the percpu
> ops? Why do we have preempt safe, irqsafe, and unsafe variants? How
> are they supposed to be used?
> 
> To illustrate the issue, for "per cpu add" we have:
> 
> __this_cpu_add()
> this_cpu_add()
> irqsafe_cpu_add()

Description for 7340a0b152 "this_cpu: Introduce this_cpu_ptr() and
generic this_cpu_* operations" should explain the above three.  In
short,

  __this_cpu_add()	: synchronization is caller's responsibility
  this_cpu_add()	: protected against preemption
  irqsafe_cpu_add()	: protected against irq

> percpu_add()

This is __this_cpu_add() + preemption disabled check.  Should be
removed.  Christoph, is there a use case where __this_cpu_XXX() is
used without preemption disabled?  Why doesn't it have preemption
check?

> Why do we need all of them?

It would great if we can drop the preempt safe one.  For x86, it
doesn't make any difference.  For archs which can't do it in single
instruction && irq on/off is expensive, it can be bad.  I don't know
how bad tho.

percpu API needs to be cleaned up.  There are quite a few duplicates -
some are from the days when static and dynamic percpu memories were
different, some got added during the this_cpu_*() stuff.  It has been
on the todo list for a while now but I never got around to do it.

If I'm not missing something, all we need are,

* per_cpu_ptr()

* get_cpu_var(), put_cpu_var() - it would be more consistent if
  they're get_cpu_ptr() and put_cpu_ptr().

* [__]this_cpu_ptr()

* Hopefully, smaller subset of this_cpu_XXX() ops.

Thanks.

-- 
tejun
