Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1JLUH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:07:26 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54508 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1JLUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:07:25 -0400
Date: Wed, 12 Oct 2011 13:07:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>,
        Francois Valenduc <francois.valenduc@tvcablenet.be>,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH][RFC] acpi: Prevent scheduling while atomic warning in
 early boot
Message-Id: <20111012130723.53880e3d.akpm@linux-foundation.org>
In-Reply-To: <1318445342.13262.54.camel@gandalf.stny.rr.com>
References: <1318445342.13262.54.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 14:49:02 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I hit the following bug:
> 
> ...
> 
> The commit 0a7992c90828a65 acpi: fix bogus preemption logic
> 
> tried again to fix the preempt logic by encapsulating the
> ACPI_PREEMPTION_POINT() with a #ifndef CONFIG_PREEMPT and only testing
> irqsoff. But when CONFIG_PREEMPT=n and CONFIG_DEBUG_ATOMIC_SLEEP=y, the
> preempt count is still active. This code is called at boot up when
> preemption is still disabled triggering the above dump.
> 
> Ideally, in_atomic() should not be used in general code, but I'm not
> sure what should be used. This does silent the warning, and it should
> not be an issue while it is still encapsulated in #ifndef CONFIG_PREEMPT
> 
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -59,6 +59,7 @@
>  #include <linux/ctype.h>
>  #include <linux/sched.h>
>  #include <asm/system.h>
> +#include <linux/hardirq.h>
>  #include <linux/atomic.h>
>  #include <asm/div64.h>
>  #include <asm/acpi.h>
> @@ -151,10 +152,14 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
>  /*
>   * Used within ACPICA to show where it is safe to preempt execution
>   * when CONFIG_PREEMPT=n
> + *
> + * Note we still test for !in_atomic() in case CONFIG_DEBUG_ATOMIC_SLEEP
> + * is set. In that case, preempt_count is still updated and scheduling
> + * here will cause a warning in early boot.
>   */
>  #define ACPI_PREEMPTION_POINT() \
>  	do { \
> -		if (!irqs_disabled()) \
> +		if (!irqs_disabled() && !in_atomic())	\
>  			cond_resched(); \
>  	} while (0)
>  #endif

This macro *cannot be implemented correctly*.

If CONFIG_PREEMPT=n && CONFIG_PREEMPT_COUNT=n then there is no
indication available anywhere to tell you whether or not it is safe to
call schedule().

Please, delete it.  Linux just doesn't work this way.  The way the
kernel is designed is that the calling code must know what its own
state is.  If you know you hold spinlocks then don't call
cond_resched().  If you know you're not holding spinlocks (or
irq_disable, etc) then it's safe to call cond_resched().


As it stands, ACPI at present might be calling schedule() while holding
spinlocks, which is deadlockable.  It cunningly arranges to only
exhibit this buggy behaviour in situations where the kernel's
self-checking code is incapable of reporting on the bug :(

