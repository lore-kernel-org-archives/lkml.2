Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab1FWJmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:42:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:55646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1FWJmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:42:23 -0400
Subject: Re: [patch 1/4] x86, mtrr: lock stop machine during MTRR
 rendezvous sequence
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
        trenn@novell.com, prarit@redhat.com, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        youquan.song@intel.com, stable@kernel.org
In-Reply-To: <alpine.LFD.2.02.1106231131300.11814@ionos>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
	 <20110622222043.862589370@sbsiddha-MOBL3.sc.intel.com>
	 <1308819905.1022.70.camel@twins>
	 <alpine.LFD.2.02.1106231131300.11814@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 11:41:23 +0200
Message-ID: <1308822083.1022.93.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 11:33 +0200, Thomas Gleixner wrote:
> On Thu, 23 Jun 2011, Peter Zijlstra wrote:
> 
> > On Wed, 2011-06-22 at 15:20 -0700, Suresh Siddha wrote:
> > > +#ifdef CONFIG_SMP
> > > +       /*
> > > +        * If we are not yet online, then there can be no stop_machine() in
> > > +        * parallel. Stop machine ensures this by using get_online_cpus().
> > > +        *
> > > +        * If we are online, then we need to prevent a stop_machine() happening
> > > +        * in parallel by taking the stop cpus mutex.
> > > +        */
> > > +       if (cpu_online(raw_smp_processor_id()))
> > > +               mutex_lock(&stop_cpus_mutex);
> > > +#endif 
> > 
> > This reads like an optimization, is it really worth-while to not take
> > the mutex in the rare offline case?
>  
> You cannot block on a mutex when you are not online, in fact you
> cannot block on it when not active, so the check is wrong anyway.

Duh, yeah. Comment totally mislead me.

On that whole active thing, so cpu_active() is brought into life to sort
an cpu-down problem, where we want the lb to stop using a cpu before we
can re-build the sched_domains.

But now we're having trouble because of that on the cpu-up part, where
we update the sched_domains too late (CPU_ONLINE) and hence also set
cpu_active() too late (again CPU_ONLINE).

Couldn't we update the sched_domain tree on CPU_PREPARE_UP to include
the new cpu and then set cpu_active() right along with cpu_online()?

That would also sort your other wait for active while bringup issue..

Note, I'll now go and have my morning juice, so the above might be total
crap.
