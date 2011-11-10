Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab1KJNd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:33:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab1KJNd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:33:56 -0500
Date: Thu, 10 Nov 2011 08:33:29 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 -next 2/2] Adding lock operations to
 kmsg_dump()/pstore_dump()
Message-ID: <20111110133329.GI5629@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A9@USINDEVS01.corp.hds.com>
 <1320929425.13800.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320929425.13800.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 01:50:25PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-10-21 at 17:21 -0400, Seiji Aguchi wrote:
> > +++ b/fs/pstore/platform.c
> > @@ -97,6 +97,17 @@ static void pstore_dump(struct kmsg_dumper *dumper,
> >         else
> >                 why = "Unknown";
> >  
> > +       /*
> > +        * pstore_dump() is called after smp_send_stop() in panic path.
> > +        * So, spin_lock should be bust for avoiding deadlock.
> > +        */
> > +       if (reason == KMSG_DUMP_PANIC)
> > +               spin_lock_init(&psinfo->buf_lock);
> > +
> > +       /*
> > +        * While a cpu is in NMI handler, other cpus may be running.
> > +        * So, trylock should be called so that lockdep checking works.
> > +        */
> 
> Don't be silly, lockdep doesn't cover NMI, in fact you shouldn't use
> locks from NMI context ever.

Heh.  I would normally agree, but in this case we have a piece of hardware
that can be accessed from normal, irq and NMI context.  I still scratch my
head for the best way to handle this.  This approach was sorta of a
bandaid effort to prevent a deadlock in the NMI panic case.

> 
> >         if (in_nmi()) {
> >                 is_locked = spin_trylock(&psinfo->buf_lock);
> >                 if (!is_locked)
> > diff --git a/kernel/printk.c b/kernel/printk.c
> > index 1455a0d..f51f547 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -1730,15 +1730,37 @@ void kmsg_dump(enum kmsg_dump_reason reason)
> >         struct kmsg_dumper *dumper;
> >         const char *s1, *s2;
> >         unsigned long l1, l2;
> > -       unsigned long flags;
> > +       unsigned long flags = 0;
> > +       int is_locked = 0;
> >  
> >         /* Theoretically, the log could move on after we do this, but
> >            there's not a lot we can do about that. The new messages
> >            will overwrite the start of what we dump. */
> > -       raw_spin_lock_irqsave(&logbuf_lock, flags);
> > +
> > +       /*
> > +        * kmsg_dump() is called after smp_send_stop() in panic path.
> > +        * So, spin_lock should be bust for avoiding deadlock.
> > +        */
> > +       if (reason == KMSG_DUMP_PANIC)
> > +               raw_spin_lock_init(&logbuf_lock); 
> 
> In both cases where you bust the spinlock at least yell loudly and
> disable lock debugging.
> 
> And I guess this is where Don wants to use NMIs for smp_send_stop() so
> what you get around the fact that this lock you're busting disabled
> IRQs?

:-)  I thought it would be safer to bust spinlocks if we could have a
better gaurantee the other cpus were not accessing the hardware at the
same time.

> 
> All in all this patch is way ugly and doesn't make me feel all warm and
> fuzzy.

I understand.

Cheers,
Don
