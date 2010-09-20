Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0ITPlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:41:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727Ab0ITPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:41:09 -0400
MIME-Version: 1.0
In-Reply-To: <20100920151334.569154707@chello.nl>
References: <20100920151334.569154707@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Sep 2010 08:40:16 -0700
Message-ID: <AANLkTinjVNddRYDUBnVZ67QDEPGrpj4dmW5BMwq2+ozP@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] PF_flags cleaups
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 8:13 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Because we recently ran out of PF_flags, try and clean up.
>
> Patches are on top of -tip, which already includes the PF_ALIGNWARN
> removal.

Looks ok by me conceptually, but I _really_ hate the naming of that
second patch and the pointless churn.

I also find it disgusting to have that [set_]task_type() "helper"
abstraction layer. It doesn't actually help anything at all, and just
makes it less clear what is going on.

So instead of code like this:

   if (task_type(p) >= tt_kernel)

why the heck isn't it just a much more readable old code (with just a
renamed new field) and just do

   if (task->task_type & TT_KTHREAD)

instead? Even if you were to want to use an enum rather than a set of
#define's, the all-caps thing makes it visually obvious that we're
talking about some constant rather than a variable named "tt_kernel".

I dunno. I'd personally also just keep it as a bitmask thing, if only
to make the patch more readable. IOW, the patch _should_ have just
turned

        tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;

into

        tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE;
        tsk->task_type |= TT_KSWAPD;

and then the patch would always have been an "obvious straightforward
identity transform".

For example, look at the mess you did:


-       new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
+       if (task_type(p) >= tt_kernel)
+               new_type = tt_kernel;
+       else
+               new_type = tt_user;
+
+       task_set_type(p, new_type);
+

and look how much straightforward it would have been had you just kept
the same simple semantics with just a new field:

-       new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
+       new_type &= ~(TT_SUPERPRIV | TT_WQ_WORKER);

and nobody could possibly have any objections to a straightforward
"move the task type flags into a separate field" patch.

No?

                       Linus
