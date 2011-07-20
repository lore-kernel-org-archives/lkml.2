Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1GTNZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:25:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35129 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab1GTNZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:25:38 -0400
Date: Wed, 20 Jul 2011 06:25:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/urgent 4/7] rcu: protect __rcu_read_unlock()
 against scheduler-using irq handlers
Message-ID: <20110720132530.GF2400@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110720001738.GA16369@linux.vnet.ibm.com>
 <1311121103-16978-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <1311166467.5345.78.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311166467.5345.78.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 02:54:27PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-19 at 17:18 -0700, Paul E. McKenney wrote:
> > @@ -391,10 +400,15 @@ void __rcu_read_unlock(void)
> >         struct task_struct *t = current;
> >  
> >         barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> > -       if (--t->rcu_read_lock_nesting == 0) {
> > -               barrier();  /* decr before ->rcu_read_unlock_special load */
> > +       if (t->rcu_read_lock_nesting != 1)
> > +               --t->rcu_read_lock_nesting;
> > +       else {
> > +               t->rcu_read_lock_nesting = INT_MIN;
> > +               barrier();  /* assign before ->rcu_read_unlock_special load */
> >                 if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> >                         rcu_read_unlock_special(t);
> > +               barrier();  /* ->rcu_read_unlock_special load before assign */
> > +               t->rcu_read_lock_nesting = 0;
> >         }
> >  #ifdef CONFIG_PROVE_LOCKING
> >         WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0); 
> 
> But won't the above change make that WARN_ON_ONCE() invalid?

Yes, please see the patch I just sent.  So that warning was spurious,
and if that was the only problem...

							Thanx, Paul
