Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab1DXQnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 12:43:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51821 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651Ab1DXQng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 12:43:36 -0400
Date: Sun, 24 Apr 2011 09:43:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
Message-ID: <20110424164331.GN2628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110422005046.GQ2235@linux.vnet.ibm.com>
 <BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
 <20110422150222.GA2300@linux.vnet.ibm.com>
 <BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
 <20110423210539.GI2628@linux.vnet.ibm.com>
 <BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
 <BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
 <BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
 <20110424062728.GM2628@linux.vnet.ibm.com>
 <BANLkTinTd10K6Ho6FhuynROT7yDLHNLojw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinTd10K6Ho6FhuynROT7yDLHNLojw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 11:36:44AM +0200, Sedat Dilek wrote:
> On Sun, Apr 24, 2011 at 8:27 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:

[ . . . ]

> > OK, this looks unrelated, but just in case, could you please try it
> > again with the following patch?  (Not mainlinable, debug only.)
> >
> > Also, it does look like you are still seeing a grace-period hang.
> > Could you please send the output of the script?  Same one as last time.
> >
> >                                                        Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> >  debugobjects.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> > index 9d86e45..10a7c7a 100644
> > --- a/lib/debugobjects.c
> > +++ b/lib/debugobjects.c
> > @@ -289,10 +289,12 @@ static void debug_object_is_on_stack(void *addr, int onstack)
> >                return;
> >
> >        limit++;
> > -       if (is_on_stack)
> > +       if (is_on_stack) {
> > +               struct rcu_head *p = (struct rcu_head *)addr;
> >                printk(KERN_WARNING
> > -                      "ODEBUG: object is on stack, but not annotated\n");
> > -       else
> > +                      "ODEBUG: object is on stack, but not annotated: %p\n",
> > +                      p->func);
> > +       } else
> >                printk(KERN_WARNING
> >                       "ODEBUG: object is not on stack, but annotated\n");
> >        WARN_ON(1);
> >
> 
> Somehow your attached patch was not applicable.
> As the changes were a few lines I applied it by myself.
> Attached are log, dmesg and patches (orig + mine)

Hmmm...  Does 0xc10231a1 correspond to a function in your build?  If so,
could you please let me know which one?

OK, so according to "ps" the per-CPU kthread is runnable, but it appears
to never run.  You only have one CPU, so it cannot be waiting due to
running on the wrong CPU.  The only other loop is in wait_event(), and
that code looks good -- besides, if wait_event() was broken, we would
be seeing breakage everywhere.

Peter, any thoughts on what I might have done wrong to get the scheduler
into a state where it was ignoring a runnable realtime task?

							Thanx, Paul
