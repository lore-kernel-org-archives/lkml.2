Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1EPWki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 18:40:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63753 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab1EPWkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 18:40:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QVMeJZhwM6eCVpzzSnmME9F59VaJ7bp70QBrjPkGa3Fo5RUX4scqpyM4Yg/D1utZi4
         dro9Q9t4gcZ1GuAZsZdk9NWGx1rcNYCsj0ddHhbzKppRlG4Ax6Teyf4poz9Z3/j56y8L
         9PqsYcuoI+S7JnqGhfZvYoEZL30J28/90OITk=
Date: Tue, 17 May 2011 00:40:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516224027.GB1738@nowhere>
References: <4DCB8BCD.1080607@kernel.org>
 <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <BANLkTin1haL+isnR0UUoHdNm99bnxYPt-g@mail.gmail.com>
 <20110514142621.GB2258@linux.vnet.ibm.com>
 <20110514153118.GA24311@linux.vnet.ibm.com>
 <20110514183453.GA32756@linux.vnet.ibm.com>
 <20110515220113.GA2810@nowhere>
 <20110516055615.GB2573@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516055615.GB2573@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 10:56:15PM -0700, Paul E. McKenney wrote:
> On Mon, May 16, 2011 at 12:01:17AM +0200, Frederic Weisbecker wrote:
> > On Sat, May 14, 2011 at 11:34:53AM -0700, Paul E. McKenney wrote:
> > >  rcutree.c |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++-----------
> > >  1 file changed, 75 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > index a4a2ef0..0b541bd 100644
> > > --- a/kernel/rcutree.c
> > > +++ b/kernel/rcutree.c
> > > @@ -308,23 +308,25 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
> > >  
> > >  #ifdef CONFIG_NO_HZ
> > >  
> > > -/**
> > > - * rcu_enter_nohz - inform RCU that current CPU is entering nohz
> > > +/*
> > > + * __rcu_enter_nohz - inform RCU that current CPU is entering nohz
> > >   *
> > >   * Enter nohz mode, in other words, -leave- the mode in which RCU
> > >   * read-side critical sections can occur.  (Though RCU read-side
> > >   * critical sections can occur in irq handlers in nohz mode, a possibility
> > >   * handled by rcu_irq_enter() and rcu_irq_exit()).
> > > + *
> > > + * This variant should only be called from rcu_irq_exit() because it
> > > + * assumes perfect nesting.  The caller must have irqs disabled.
> > >   */
> > > -void rcu_enter_nohz(void)
> > > +void __rcu_enter_nohz(void)
> > >  {
> > > -	unsigned long flags;
> > >  	struct rcu_dynticks *rdtp;
> > >  
> > > -	local_irq_save(flags);
> > >  	rdtp = &__get_cpu_var(rcu_dynticks);
> > > +	WARN_ON_ONCE(rdtp->dynticks_nesting <= 0);
> > 
> > But this warning will always trigger if it's called from rcu_irq_enter()
> > after rcu_enter_nohz(). Right?
> 
> Hello, Frederic,
> 
> Thank you for looking this over!
> 
> But you lost me on this one.  Isn't __rcu_enter_nohz() called from
> rcu_irq_exit() rather than from rcu_irq_enter()?

Oops, right I read it too quickly.
