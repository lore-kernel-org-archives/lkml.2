Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab1KJMux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:50:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:47684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1KJMuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:50:52 -0500
Subject: Re: [RFC][PATCH v2 -next 2/2] Adding lock operations to
 kmsg_dump()/pstore_dump()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Thu, 10 Nov 2011 13:50:25 +0100
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A9@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A9@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320929425.13800.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-21 at 17:21 -0400, Seiji Aguchi wrote:
> +++ b/fs/pstore/platform.c
> @@ -97,6 +97,17 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>         else
>                 why = "Unknown";
>  
> +       /*
> +        * pstore_dump() is called after smp_send_stop() in panic path.
> +        * So, spin_lock should be bust for avoiding deadlock.
> +        */
> +       if (reason == KMSG_DUMP_PANIC)
> +               spin_lock_init(&psinfo->buf_lock);
> +
> +       /*
> +        * While a cpu is in NMI handler, other cpus may be running.
> +        * So, trylock should be called so that lockdep checking works.
> +        */

Don't be silly, lockdep doesn't cover NMI, in fact you shouldn't use
locks from NMI context ever.

>         if (in_nmi()) {
>                 is_locked = spin_trylock(&psinfo->buf_lock);
>                 if (!is_locked)
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 1455a0d..f51f547 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1730,15 +1730,37 @@ void kmsg_dump(enum kmsg_dump_reason reason)
>         struct kmsg_dumper *dumper;
>         const char *s1, *s2;
>         unsigned long l1, l2;
> -       unsigned long flags;
> +       unsigned long flags = 0;
> +       int is_locked = 0;
>  
>         /* Theoretically, the log could move on after we do this, but
>            there's not a lot we can do about that. The new messages
>            will overwrite the start of what we dump. */
> -       raw_spin_lock_irqsave(&logbuf_lock, flags);
> +
> +       /*
> +        * kmsg_dump() is called after smp_send_stop() in panic path.
> +        * So, spin_lock should be bust for avoiding deadlock.
> +        */
> +       if (reason == KMSG_DUMP_PANIC)
> +               raw_spin_lock_init(&logbuf_lock); 

In both cases where you bust the spinlock at least yell loudly and
disable lock debugging.

And I guess this is where Don wants to use NMIs for smp_send_stop() so
what you get around the fact that this lock you're busting disabled
IRQs?

All in all this patch is way ugly and doesn't make me feel all warm and
fuzzy.
