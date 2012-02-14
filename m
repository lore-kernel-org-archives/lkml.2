Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab2BNOxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:53:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61617 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2BNOxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:53:38 -0500
MIME-Version: 1.0
In-Reply-To: <20120214074035.GA18994@zhy>
References: <1329131018-19107-1-git-send-email-tom.leiming@gmail.com>
	<20120213172311.GB12117@google.com>
	<CACVXFVMyihmG3NexXOqTUoJb8UJFa7dJqYGOr6oC_y5heFSo1A@mail.gmail.com>
	<20120214074035.GA18994@zhy>
Date: Tue, 14 Feb 2012 22:53:38 +0800
Message-ID: <CACVXFVOq5_qrhM=pdFDW+e7dsYGq25pNsbdf+vk=+LTJK-Gs5A@mail.gmail.com>
Subject: Re: [PATCH] percpu: use raw_local_irq_* in _this_cpu op
From: Ming Lei <tom.leiming@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 3:40 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Tue, Feb 14, 2012 at 11:30:06AM +0800, Ming Lei wrote:
>> Hi,
>>
>> On Tue, Feb 14, 2012 at 1:23 AM, Tejun Heo <tj@kernel.org> wrote:
>> > On Mon, Feb 13, 2012 at 07:03:38PM +0800, Ming Lei wrote:
>> >> It doesn't make sense to trace irq off or do irq flags
>> >> lock proving inside 'this_cpu' operations, so replace local_irq_*
>> >> with raw_local_irq_* in 'this_cpu' op.
>> >>
>> >> Also the patch fixes one lockdep warning[1], which is caused
>> >> by the added local_irq_save/restore(flags) in this_cpu_inc
>> >> called by __debug_atomic_inc: kernel/lockdep.c
>> >
>> > I think this isn't gonna hurt anything but I don't understand why the
>> > lockdep warning is triggering when using traced version. ?Can you
>> > please explain that in a bit more detail in the patch description?
>>
>> In trace_hardirqs_on_caller:kernel/lockdep.c, __debug_atomic_inc
>> will be called to add on 'this_cpu' variable, so may introduce recursive
>> trace_hardirqs_on|off_caller called.
>
> Don't we need to prevent this kind of recursion first?

IMO, lockdep is designed as not tracing or proving itself, and
just avoiding to trace __debug_atomic_inc is enough to fix the warning,
so it is not necessary to enlarge the protection range with
current->lockdep_recursion.

>
> UNTESTED patch, I guess it'll smooth your concern.
> ---
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 8889f7d..028b4c5 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2561,6 +2561,8 @@ void trace_hardirqs_on_caller(unsigned long ip)
>        if (unlikely(!debug_locks || current->lockdep_recursion))
>                return;
>
> +       current->lockdep_recursion = 1;
> +
>        if (unlikely(current->hardirqs_enabled)) {
>                /*
>                 * Neither irq nor preemption are disabled here
> @@ -2568,7 +2570,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
>                 * in a stat is not a big deal.
>                 */
>                __debug_atomic_inc(redundant_hardirqs_on);
> -               return;
> +               goto out;
>        }
>
>        /*
> @@ -2577,23 +2579,24 @@ void trace_hardirqs_on_caller(unsigned long ip)
>         * enabled.. someone messed up their IRQ state tracing.
>         */
>        if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
> -               return;
> +               goto out;
>
>        /*
>         * See the fine text that goes along with this variable definition.
>         */
>        if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
> -               return;
> +               goto out;
>
>        /*
>         * Can't allow enabling interrupts while in an interrupt handler,
>         * that's general bad form and such. Recursion, limited stack etc..
>         */
>        if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
> -               return;
> +               goto out;
>
> -       current->lockdep_recursion = 1;
>        __trace_hardirqs_on_caller(ip);
> +
> +out:
>        current->lockdep_recursion = 0;
>  }
>  EXPORT_SYMBOL(trace_hardirqs_on_caller);


thanks,
-- 
Ming Lei
