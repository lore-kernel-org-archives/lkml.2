Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab0LXSde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 13:33:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab0LXSdd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 13:33:33 -0500
MIME-Version: 1.0
In-Reply-To: <20101224123742.724459093@chello.nl>
References: <20101224122338.172750730@chello.nl> <20101224123742.724459093@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Dec 2010 10:26:05 -0800
Message-ID: <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
Subject: Re: [RFC][PATCH 05/17] x86: Optimize arch_spin_unlock_wait()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 4:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Only wait for the current holder to release the lock.
>
> spin_unlock_wait() can only be about the current holder, since
> completion of this function is inherently racy with new contenders.
> Therefore, there is no reason to wait until the lock is completely
> unlocked.

Is there really any reason for this patch? I'd rather keep the simpler
and more straightforward code unless you have actual numbers.

> +static inline void __ticket_spin_unlock_wait(arch_spinlock_t *lock)
> +{
> +       int tmp = ACCESS_ONCE(lock->slock);
> +
> +       if (!(((tmp >> TICKET_SHIFT) ^ tmp) & TICKET_MASK))
> +               return; /* not locked */
> +
> +       /* wait until the current lock holder goes away */
> +       while ((lock->slock & TICKET_MASK) == (tmp & TICKET_MASK))
> +               cpu_relax();
>  }

Also, the above is just ugly. You've lost the ACCESS_ONCE() on the
lock access, and it's using another model of masking than the regular
one. Both of which may be intentional (maybe you are _trying_ to get
the compiler to just load the low bytes and avoid the 'and'), but the
whole open-coding of the logic - twice, and with different looking
masking - just makes my skin itch.

                                  Linus
