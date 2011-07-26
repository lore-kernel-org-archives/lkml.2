Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1GZUMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:12:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37940 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab1GZUMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <1311679697.24752.28.camel@twins>
References: <20110722125934.GA25433@elte.hu>
	<CACqU3MW-7_gCqNARdrPA5rZoZGLti+DMvkZsJN40VSDtU+VhpQ@mail.gmail.com>
	<1311679697.24752.28.camel@twins>
Date: Tue, 26 Jul 2011 16:12:35 -0400
Message-ID: <CACqU3MUghvskv4HrVn+w7rCTki0RkRwQfFUaaysHYOqB6V+q4A@mail.gmail.com>
Subject: Re: [GIT PULL] core/printk changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        SergeySenozhatsky <sergey.senozhatsky@gmail.com>,
        DaveJones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 26, 2011 at 7:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-07-25 at 14:20 -0400, Arnaud Lacombe wrote:
>
>> > Peter Zijlstra (3):
>> >      [...]
>> >      lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion
>> >
>> This commit is triggering:
>>
>> WARNING: at /src/linux/linux/kernel/lockdep.c:2529
>
> Not actually having reproduced the problem, does the below cure things?
>
> ---
> Subject: lockdep: Fix trace_hardirqs_on_caller()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Jul 26 13:13:44 CEST 2011
>
> Commit dd4e5d3ac4a ("lockdep: Fix trace_[soft,hard]irqs_[on,off]()
> recursion") made a bit of a mess of the various checks and error
> conditions.
>
> In particular it moved the check for !irqs_disabled() before the
> spurious enable test, resulting in some warnings.
>
> Reported-by: Arnaud Lacombe <lacombar@gmail.com>
> Reported-by: Dave Jones <davej@redhat.com>
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
The patch has been a bit difficult to apply[0], but the warning no
longer happen once done, thanks.

Tested-by: Arnaud Lacombe <lacombar@gmail.com>

 - Arnaud
[0]: I still have to find an easy way to transfer patch between gmail
and my tree... For now, I ruled out mutt as it mangle the patch...

> ---
>  kernel/lockdep.c |   30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -2485,23 +2485,9 @@ static void __trace_hardirqs_on_caller(u
>  {
>        struct task_struct *curr = current;
>
> -       if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
> -               return;
> -
> -       if (unlikely(curr->hardirqs_enabled)) {
> -               /*
> -                * Neither irq nor preemption are disabled here
> -                * so this is racy by nature but losing one hit
> -                * in a stat is not a big deal.
> -                */
> -               __debug_atomic_inc(redundant_hardirqs_on);
> -               return;
> -       }
>        /* we'll do an OFF -> ON transition: */
>        curr->hardirqs_enabled = 1;
>
> -       if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
> -               return;
>        /*
>         * We are going to turn hardirqs on, so set the
>         * usage bit for all held locks:
> @@ -2529,9 +2515,25 @@ void trace_hardirqs_on_caller(unsigned l
>        if (unlikely(!debug_locks || current->lockdep_recursion))
>                return;
>
> +       if (unlikely(current->hardirqs_enabled)) {
> +               /*
> +                * Neither irq nor preemption are disabled here
> +                * so this is racy by nature but losing one hit
> +                * in a stat is not a big deal.
> +                */
> +               __debug_atomic_inc(redundant_hardirqs_on);
> +               return;
> +       }
> +
>        if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
>                return;
>
> +       if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
> +               return;
> +
> +       if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
> +               return;
> +
>        current->lockdep_recursion = 1;
>        __trace_hardirqs_on_caller(ip);
>        current->lockdep_recursion = 0;
>
>
