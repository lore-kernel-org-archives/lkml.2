Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2EZAYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 20:24:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:34741 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2EZAYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 20:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147980614"
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 25 May 2012 17:23:29 -0700
In-Reply-To: <alpine.LFD.2.02.1205242113400.3231@ionos>
References: <20120521164959.GE16454@sgi.com>
	  <alpine.LFD.2.02.1205212304580.3231@ionos>
	 <20120521211917.GA25567@sgi.com>
	  <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com>
	  <20120523190414.GA5263@sgi.com>
	  <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>
	  <20120523200226.GA6936@sgi.com>
	  <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>
	  <20120524143711.GA24711@sgi.com>
	 <1337883560.7938.9.camel@sbsiddha-desk.sc.intel.com>
	 <alpine.LFD.2.02.1205242113400.3231@ionos>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337991809.7938.36.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 21:16 +0200, Thomas Gleixner wrote:
> On Thu, 24 May 2012, Suresh Siddha wrote:
> > On Thu, 2012-05-24 at 09:37 -0500, Dimitri Sivanich wrote:
> > > And speaking of possible holes in destroy_irq()..
> > > 
> > > What happens if we're running __assign_irq_vector() (say we're changing irq
> > > affinity), and on another cpu we had just run through __clear_irq_vector()
> > > via destroy_irq().  Now destroy_irq() is going to call
> > > free_irq_at()->free_irq_cfg, which will clear irq_cfg.  Then
> > > __assign_irq_vector goes to access irq_cfg (cfg->vector or
> > > cfg->move_in_progress, for instance), which was already freed.
> > > 
> > > I'm not sure if this can happen, but just eyeballing it, it does look that
> > > that way.
> > > 
> > 
> > I wanted to say, irq desc is locked when we change the irq affinity,
> > which calls assign_irq_vector() and friends, so this should be fine.
> > 
> > BUT NO. I don't see any reference counts being maintained when we do
> > irq_to_desc(). So locking/unlocking that desc pointer is bogus when
> > destroy_irq() can go ahead and free the desc in parallel.
> > 
> > So, SPARSE_IRQ looks terribly broken! Yinghai, Thomas?
> 
> Yes, we need refcounts for that. We talked about that before, but then
> the argument was against it was that all that code is serialized
> already, so no need. How wrong :)

I looked a bit more at this and it looks like unregister_handler_proc()
(that gets called from the free_irq path) will ensure that all the
existing proc writers modifying the irq affinity from
the /proc/irq/N/smp_affinity interface will be completed. So Dimitri,
the code path changing irq affinity looks fine.

We also do synchronize_irq() in __free_irq(). Followed by
masking/shutdown the irq etc and the destroy_irq() which happens after
all this is probably getting lucky because of timing reasons (any other
cpu handling that irq would have completed the irq handling and the
corresponding reference to the 'desc' etc). But we should be also doing
synchronize_rcu()/synchronize_sched() to ensure that other cpu's are not
in the irq handling paths having a reference to the 'desc'.

There are other (not-so common) irq desc references, like in the
show_interrupts() (cat /proc/interrupts path) etc, that does things like
this in the process context:

        desc = irq_to_desc(i);
        if (!desc)
                return 0;

        raw_spin_lock_irqsave(&desc->lock, flags);

May be we should introduce something like
get_irq_desc_locked()/put_irq_desc_locked() that can safely access the
irq desc with pre-emption/irq's disabled and lock it etc. And the
synchronize_sched() will enable the destroy_irq()/free_desc() to free it
safely etc.

thanks,
suresh

