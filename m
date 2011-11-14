Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab1KNVHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:07:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43892 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab1KNVHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:07:21 -0500
MIME-Version: 1.0
In-Reply-To: <1321303871.5011.6.camel@frodo>
References: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
	<1321235083-21756-2-git-send-email-jkacur@redhat.com>
	<20111114165148.GB2372@linux.vnet.ibm.com>
	<alpine.LFD.2.00.1111141837100.6707@localhost6.localdomain6>
	<1321303871.5011.6.camel@frodo>
Date: Mon, 14 Nov 2011 22:07:20 +0100
X-Google-Sender-Auth: grClu3aeKVoAc5ki1mXIJK0LqMA
Message-ID: <CAONaPpHO8R_LJX_0AYdbUPdij_spskk3KrtegjW2QX5kKCRtdQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Compile error with allmodconfig and CONFIG_PREEMPT_RT_FULL=y
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 9:51 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 2011-11-14 at 18:39 +0100, John Kacur wrote:
> >
> > On Mon, 14 Nov 2011, Paul E. McKenney wrote:
> >
> > > On Mon, Nov 14, 2011 at 02:44:43AM +0100, John Kacur wrote:
> > > > ERROR: "in_serving_softirq" [net/sched/cls_cgroup.ko] undefined!
> > > >
> > > > The above can be fixed by exporting in_serving_softirq
> > > >
> > > > Signed-off-by: John Kacur <jkacur@redhat.com>
> > > >
> > > > The above patch was originally for 3.0.9-rt25
> > > > But I also needed to cherry-pick it for 3.2-rc1-rt1
> > > > ---
> > > >  kernel/softirq.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > > > index 3db1d6f..5452432 100644
> > > > --- a/kernel/softirq.c
> > > > +++ b/kernel/softirq.c
> > > > @@ -447,6 +447,7 @@ int in_serving_softirq(void)
> > > >   preempt_enable();
> > > >   return res;
> > > >  }
> > > > +EXPORT_SYMBOL(in_serving_softirq);
> > >
> > > Why not EXPORT_SYMBOL_GPL?
> >
> > I have no problem with that, note however that the upstream file has
> >
> > EXPORT_SYMBOL(irq_stat);
> > EXPORT_SYMBOL(local_bh_disable);
> > EXPORT_SYMBOL(_local_bh_enable);
> > EXPORT_SYMBOL(local_bh_enable);
> > EXPORT_SYMBOL(local_bh_enable_ip);
> > EXPORT_SYMBOL(__tasklet_schedule);
> > EXPORT_SYMBOL(__tasklet_hi_schedule);
> > EXPORT_SYMBOL(__tasklet_hi_schedule_first);
> > EXPORT_SYMBOL(tasklet_init);
> > EXPORT_SYMBOL(tasklet_kill);
> > EXPORT_SYMBOL(__send_remote_softirq);
> > EXPORT_SYMBOL(send_remote_softirq);
> >
> > Any reason we can't change all of those to EXPORT_SYMBOL_GPL?\\
>
> IIRC, the point behind EXPORT_SYMBOL_GPL() is that, by using the call
> you are using something that is a derivative of the code. Basically all
> new functionality of the kernel is Linux specific and symbols exported
> should be EXPORT_SYMBOL_GPL().
>
> But, I also recall that we did not want to make things that are normal
> OS operations under the EXPORT_SYMBOL_GPL(). This would include the
> local_bh_enable/disable(), or anything that is called by generic
> operations. For example, spin_lock() is not a GPL symbol, and if we add
> some new functionality that causes all spin_locks() to call foo_bar(),
> we must also make sure foo_bar() is also under just EXPORT_SYMBOL(),
> otherwise, we just forced EXPORT_SYMBOL_GPL() on spin_lock().
>
> Some of the above is probably just simple OS operations or are called by
> static OS operation functions.
>
> If we go that route, we might as well make everything
> EXPORT_SYMBOL_GPL(), and be damn to those that use nVidia.
>
> -- Steve


That's a great explanation - thanks

John Kacur
