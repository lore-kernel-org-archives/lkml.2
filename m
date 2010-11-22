Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab0KVFjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 00:39:53 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43618 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0KVFjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 00:39:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Nt6EseiPa4TtlwY6sLKb5AwZzKM6QRt5chSwYzXiAgenYu78CLT588rTTVegLE+dSL
         Ka4bJykJMuX6ZnWvi8V2vuAmaN1vWAp4O1FBDaGn+MCO9FrwoIW7FVEy8koPa3Dj0pmE
         g8ZYRQDnzbQDu1V8Jqiiy8zMNjxk/8gp60jXw=
MIME-Version: 1.0
In-Reply-To: <201011151425.oAFEPU3W005682@farm-0010.internal.tilera.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	<1289489007.17691.1310.camel@edumazet-laptop>
	<AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	<ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
	<4CDF1945.8090101@tilera.com>
	<AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>
	<201011151425.oAFEPU3W005682@farm-0010.internal.tilera.com>
Date: Mon, 22 Nov 2010 13:39:50 +0800
Message-ID: <AANLkTikGj+zG9OqVJseKh4fGqQNnqnJpHgcaaXOL8nNi@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: fix rwlock so would-be write lockers don't
 block new readers
From: Cypher Wu <cypher.w@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/15 Chris Metcalf <cmetcalf@tilera.com>:
> This avoids a deadlock in the IGMP code where one core gets a read
> lock, another core starts trying to get a write lock (thus blocking
> new readers), and then the first core tries to recursively re-acquire
> the read lock.
>
> We still try to preserve some degree of balance by giving priority
> to additional write lockers that come along while the lock is held
> for write, so they can all complete quickly and return the lock to
> the readers.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> This should apply relatively cleanly to 2.6.26.7 source code too.
>
>  arch/tile/lib/spinlock_32.c |   29 ++++++++++++++++++-----------
>  1 files changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/arch/tile/lib/spinlock_32.c b/arch/tile/lib/spinlock_32.c
> index 485e24d..5cd1c40 100644
> --- a/arch/tile/lib/spinlock_32.c
> +++ b/arch/tile/lib/spinlock_32.c
> @@ -167,23 +167,30 @@ void arch_write_lock_slow(arch_rwlock_t *rwlock, u32 val)
>         * when we compare them.
>         */
>        u32 my_ticket_;
> +       u32 iterations = 0;
>
> -       /* Take out the next ticket; this will also stop would-be readers. */
> -       if (val & 1)
> -               val = get_rwlock(rwlock);
> -       rwlock->lock = __insn_addb(val, 1 << WR_NEXT_SHIFT);
> +       /*
> +        * Wait until there are no readers, then bump up the next
> +        * field and capture the ticket value.
> +        */
> +       for (;;) {
> +               if (!(val & 1)) {
> +                       if ((val >> RD_COUNT_SHIFT) == 0)
> +                               break;
> +                       rwlock->lock = val;
> +               }
> +               delay_backoff(iterations++);
> +               val = __insn_tns((int *)&rwlock->lock);
> +       }
>
> -       /* Extract my ticket value from the original word. */
> +       /* Take out the next ticket and extract my ticket value. */
> +       rwlock->lock = __insn_addb(val, 1 << WR_NEXT_SHIFT);
>        my_ticket_ = val >> WR_NEXT_SHIFT;
>
> -       /*
> -        * Wait until the "current" field matches our ticket, and
> -        * there are no remaining readers.
> -        */
> +       /* Wait until the "current" field matches our ticket. */
>        for (;;) {
>                u32 curr_ = val >> WR_CURR_SHIFT;
> -               u32 readers = val >> RD_COUNT_SHIFT;
> -               u32 delta = ((my_ticket_ - curr_) & WR_MASK) + !!readers;
> +               u32 delta = ((my_ticket_ - curr_) & WR_MASK);
>                if (likely(delta == 0))
>                        break;
>
> --
> 1.6.5.2
>
>


I've finished my business trip and tested that patch for more than an
hour and it works. The test is still running now.

But it seems there still has a potential problem: we used ticket lock
for write_lock(), and if there are so many write_lock() occurred, is
256 ticket enough for 64 or even more cores to avoiding overflow?
Since is we try to write_unlock() and there's already write_lock()
waiting we'll only adding current ticket.


-- 
Cyberman Wu
http://www.meganovo.com
