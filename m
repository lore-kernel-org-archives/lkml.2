Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1ALGZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:25:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751444Ab1ALGZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:25:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19fbaIOYuZfyeJ0r3ZOv73p7kOCdcQ8KAKxAJ0lKY
	7jCQVcYr9GSkmh
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikO8kaWk=PL5F76pUc_ihV0w-vAU2NYvPcc1XUZ@mail.gmail.com>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <AANLkTikO8kaWk=PL5F76pUc_ihV0w-vAU2NYvPcc1XUZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 07:25:26 +0100
Message-ID: <1294813526.8370.31.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 13:43 +0800, Yong Zhang wrote:
> On Tue, Jan 11, 2011 at 12:42 AM, Mike Galbraith <efault@gmx.de> wrote:
> > Index: linux-2.6/kernel/sched_autogroup.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_autogroup.c
> > +++ linux-2.6/kernel/sched_autogroup.c
> > @@ -73,6 +73,15 @@ static inline struct autogroup *autogrou
> >        ag->id = atomic_inc_return(&autogroup_seq_nr);
> >        ag->tg = tg;
> >        tg->autogroup = ag;
> > +#ifdef CONFIG_RT_GROUP_SCHED
> > +       /*
> > +        * HACK: autogroup RT tasks run in the root task group.
> > +        * This fools __sched_setscheduler() into proceeding on
> > +        * so we can move the task to the appropriate runqueue
> > +        * upon scheduling policy change.
> > +        */
> > +       tg->rt_bandwidth.rt_runtime = RUNTIME_INF;
> > +#endif
> >
> >        return ag;
> >
> > @@ -143,6 +152,15 @@ autogroup_move_group(struct task_struct
> >        autogroup_kref_put(prev);
> >  }
> >
> > +static inline void
> > +autogroup_setscheduler(struct task_struct *p, int on_rq)
> > +{
> > +       if (p->sched_class->task_move_group)
> > +               p->sched_class->task_move_group(p, on_rq);
> 
> This will be called even if we don't change the sched_class in
> which case it is not necessary.

Yes.  It'll also piddle around with tasks it shouldn't.  I sent what I
hope is a better solution a few minutes ago.  This one works, but
probably upset Peter's tummy mightily :)

	-Mike

