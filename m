Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2LVEkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:40:49 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36003 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2LVEkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:40:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121221185038.43e8246c@annuminas.surriel.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	<20121221185038.43e8246c@annuminas.surriel.com>
Date: Fri, 21 Dec 2012 20:40:46 -0800
Message-ID: <CANN689GqkzUP6RsUvZYF1L=eBAwL0COnzp6jAokHABhN74tsUA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] x86,smp: move waiting on contended lock out of line
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 3:50 PM, Rik van Riel <riel@redhat.com> wrote:
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 33692ea..2a45eb0 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -34,6 +34,8 @@
>  # define UNLOCK_LOCK_PREFIX
>  #endif
>
> +extern void ticket_spin_lock_wait(arch_spinlock_t *, struct __raw_tickets);
> +
>  /*
>   * Ticket locks are conceptually two parts, one indicating the current head of
>   * the queue, and the other indicating the current tail. The lock is acquired
> @@ -53,12 +55,11 @@ static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>
>         inc = xadd(&lock->tickets, inc);
>
> -       for (;;) {
> -               if (inc.head == inc.tail)
> -                       break;
> -               cpu_relax();
> -               inc.head = ACCESS_ONCE(lock->tickets.head);
> -       }
> +       if (inc.head == inc.tail)
> +               goto out;
> +
> +       ticket_spin_lock_wait(lock, inc);
> + out:

why not just:

if (inc.head != inc.tail)
  ticket_spin_lock_wait(lock, inc)

>         barrier();              /* make sure nothing creeps before the lock is taken */
>  }
>
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 48d2b7d..20da354 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -113,6 +113,20 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
>  static bool smp_no_nmi_ipi = false;
>
>  /*
> + * Wait on a congested ticket spinlock.
> + */
> +void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
> +{
> +       for (;;) {
> +               cpu_relax();
> +               inc.head = ACCESS_ONCE(lock->tickets.head);
> +
> +               if (inc.head == inc.tail)
> +                       break;
> +       }

Why not just:

do {
  cpu_relax()
  inc.head = ...
} while (inc.head != inc.tail);


Other than that, no problems with the principle of it.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
