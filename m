Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3ACLfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:35:48 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:65075 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3ACLfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:35:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130103002222.166611a8@annuminas.surriel.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
	<20130103002222.166611a8@annuminas.surriel.com>
Date: Thu, 3 Jan 2013 17:05:44 +0530
Message-ID: <CAC4Lta3D5BWnQ5vYjyZTgEvvdSiBK4=i8iaPZN6Ru+jt75hZwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] x86,smp: proportional backoff for ticket spinlocks
From: Raghavendra KT <raghavendra.kt.linux@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ccing IBM id]
On Thu, Jan 3, 2013 at 10:52 AM, Rik van Riel <riel@redhat.com> wrote:
> Simple fixed value proportional backoff for ticket spinlocks.
> By pounding on the cacheline with the spin lock less often,
> bus traffic is reduced. In cases of a data structure with
> embedded spinlock, the lock holder has a better chance of
> making progress.
>
> If we are next in line behind the current holder of the
> lock, we do a fast spin, so as not to waste any time when
> the lock is released.
>
> The number 50 is likely to be wrong for many setups, and
> this patch is mostly to illustrate the concept of proportional
> backup. The next patch automatically tunes the delay value.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  arch/x86/kernel/smp.c |   23 ++++++++++++++++++++---
>  1 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 20da354..9c56fe3 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -117,11 +117,28 @@ static bool smp_no_nmi_ipi = false;
>   */
>  void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>  {
> +       __ticket_t head = inc.head, ticket = inc.tail;
> +       __ticket_t waiters_ahead;
> +       unsigned loops;
> +
>         for (;;) {
> -               cpu_relax();
> -               inc.head = ACCESS_ONCE(lock->tickets.head);
> +               waiters_ahead = ticket - head - 1;
                                             ^^^^^^^^^^^^^^
Just wondering,
Does wraparound affects this?
