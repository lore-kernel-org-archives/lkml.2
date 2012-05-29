Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2E2KgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:36:22 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47722 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2E2Kfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:35:54 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 2/4] timers: Consolidate base->next_timer update
In-Reply-To: <alpine.LFD.2.02.1205291137580.3231@ionos>
References: <20120525214617.051888729@linutronix.de> <20120525214819.189946224@linutronix.de> <87likbxzqe.fsf@abhimanyu.in.ibm.com> <alpine.LFD.2.02.1205291137580.3231@ionos>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 29 May 2012 16:05:12 +0530
Message-ID: <87fwajxokf.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12052900-7014-0000-0000-00000142A5A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012 11:38:27 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 29 May 2012, Nikunj A Dadhania wrote:
> 
> > > 
> > > -static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> > > +static void
> > > +__internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> > >  {
> > >  	unsigned long expires = timer->expires;
> > >  	unsigned long idx = expires - base->timer_jiffies;
> > > @@ -372,6 +373,17 @@ static void internal_add_timer(struct tv
> > >  	list_add_tail(&timer->entry, vec);
> > >  }
> > > 
> > > +static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> > > +{
> > > +	__internal_add_timer(base, timer);
> > > +	/*
> > > +	 * Update base->next_timer if this is the earliest one.
> > > +	 */
> > > +	if (time_before(timer->expires, base->next_timer) &&
> > > +	    !tbase_get_deferrable(timer->base))
> > > +		base->next_timer = timer->expires;
> > > +}
> > > +
> > >
> > Shouldn't this be like this?
> > 
> > +	/*
> > +	 * Update base->next_timer if this is the earliest one.
> > +	 */
> > +	if (time_before(timer->expires, base->next_timer) &&
> > +	    !tbase_get_deferrable(timer->base))
> > +		base->next_timer = timer->expires;
> > +	__internal_add_timer(base, timer);
> > 
> > As per the below code?
> 
> And why should this matter?
> 
Yes it does not matter, sorry for the noise.

Looking at the internal_add_timer(), there is no such dependency. I was
thinking that the base->next_timer is changed and would be used in
__internal_add_timer.

Nikunj



