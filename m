Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab2FAKOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:14:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35703 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab2FAKOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:14:09 -0400
Message-ID: <1338545638.28384.137.camel@twins>
Subject: Re: [PATCH 2/2] block: Convert BDI proportion calculations to
 flexible proportions
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 01 Jun 2012 12:13:58 +0200
In-Reply-To: <20120531224206.GC19050@quack.suse.cz>
References: <1337878751-22942-1-git-send-email-jack@suse.cz>
	 <1337878751-22942-3-git-send-email-jack@suse.cz>
	 <1338220185.4284.19.camel@lappy> <20120529123408.GA23991@quack.suse.cz>
	 <1338295111.26856.57.camel@twins> <20120529125452.GB23991@quack.suse.cz>
	 <20120531221146.GA19050@quack.suse.cz> <1338503165.28384.134.camel@twins>
	 <20120531224206.GC19050@quack.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 00:42 +0200, Jan Kara wrote:
> On Fri 01-06-12 00:26:05, Peter Zijlstra wrote:
> > On Fri, 2012-06-01 at 00:11 +0200, Jan Kara wrote:
> > >  bool fprop_new_period(struct fprop_global *p, int periods)
> > >  {
> > > -       u64 events = percpu_counter_sum(&p->events);
> > > +       u64 events;
> > > +       unsigned long flags;
> > >  
> > > +       local_irq_save(flags);
> > > +       events = percpu_counter_sum(&p->events);
> > > +       local_irq_restore(flags);
> > >         /*
> > >          * Don't do anything if there are no events.
> > >          */
> > > @@ -73,7 +77,9 @@ bool fprop_new_period(struct fprop_global *p, int periods)
> > >         if (periods < 64)
> > >                 events -= events >> periods;
> > >         /* Use addition to avoid losing events happening between sum and set */
> > > +       local_irq_save(flags);
> > >         percpu_counter_add(&p->events, -events);
> > > +       local_irq_restore(flags);
> > >         p->period += periods;
> > >         write_seqcount_end(&p->sequence); 
> > 
> > Uhm, why bother enabling it in between? Just wrap the whole function in
> > a single IRQ disable.
>   I wanted to have interrupts disabled for as short as possible but if you
> think it doesn't matter, I'll take your advice. The result is attached.

Thing is, disabling interrupts is quite expensive and the extra few
instructions covered isn't much.


