Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418Ab2EXTQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:16:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:58291 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965357Ab2EXTQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:16:35 -0400
Date: Thu, 24 May 2012 21:16:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
In-Reply-To: <1337883560.7938.9.camel@sbsiddha-desk.sc.intel.com>
Message-ID: <alpine.LFD.2.02.1205242113400.3231@ionos>
References: <20120521164959.GE16454@sgi.com>  <alpine.LFD.2.02.1205212304580.3231@ionos> <20120521211917.GA25567@sgi.com>  <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com>  <20120523190414.GA5263@sgi.com> 
 <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>  <20120523200226.GA6936@sgi.com>  <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>  <20120524143711.GA24711@sgi.com> <1337883560.7938.9.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Suresh Siddha wrote:
> On Thu, 2012-05-24 at 09:37 -0500, Dimitri Sivanich wrote:
> > And speaking of possible holes in destroy_irq()..
> > 
> > What happens if we're running __assign_irq_vector() (say we're changing irq
> > affinity), and on another cpu we had just run through __clear_irq_vector()
> > via destroy_irq().  Now destroy_irq() is going to call
> > free_irq_at()->free_irq_cfg, which will clear irq_cfg.  Then
> > __assign_irq_vector goes to access irq_cfg (cfg->vector or
> > cfg->move_in_progress, for instance), which was already freed.
> > 
> > I'm not sure if this can happen, but just eyeballing it, it does look that
> > that way.
> > 
> 
> I wanted to say, irq desc is locked when we change the irq affinity,
> which calls assign_irq_vector() and friends, so this should be fine.
> 
> BUT NO. I don't see any reference counts being maintained when we do
> irq_to_desc(). So locking/unlocking that desc pointer is bogus when
> destroy_irq() can go ahead and free the desc in parallel.
> 
> So, SPARSE_IRQ looks terribly broken! Yinghai, Thomas?

Yes, we need refcounts for that. We talked about that before, but then
the argument was against it was that all that code is serialized
already, so no need. How wrong :)

