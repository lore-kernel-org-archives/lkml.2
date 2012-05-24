Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab2EXOxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:53:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:53669 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab2EXOxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:53:22 -0400
Date: Thu, 24 May 2012 16:53:06 +0200 (CEST)
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
In-Reply-To: <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>
Message-ID: <alpine.LFD.2.02.1205241327471.3231@ionos>
References: <20120521164959.GE16454@sgi.com>  <alpine.LFD.2.02.1205212304580.3231@ionos> <20120521211917.GA25567@sgi.com>  <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com>  <20120523190414.GA5263@sgi.com> 
 <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>  <20120523200226.GA6936@sgi.com> <1337816970.1997.207.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Suresh Siddha wrote:
> On Wed, 2012-05-23 at 15:02 -0500, Dimitri Sivanich wrote:
> > OK.  Hopefully this covers it.
> 
> Sorry No. Now you will understand why Thomas wanted detailed changelog.
> I found one more issue with the help of your new modification to the
> changelog.
> 
> > A NULL pointer dereference can occur in smp_irq_move_cleanup_interrupt() if
> > we haven't yet setup the irq_cfg pointer in the irq_desc.irq_data.chip_data.
> > 
> > In create_irq_nr() there is a window where we have set vector_irq in
> > __assign_irq_vector(), but not yet called irq_set_chip_data() to set the
> > irq_cfg pointer.
> > 
> > Should an IRQ_MOVE_CLEANUP_VECTOR hit the cpu in question during this time,
> > smp_irq_move_cleanup_interrupt() will attempt to process the aforementioned
> > irq, but panic when accessing irq_cfg.
> > 
> > There is also a window in destroy_irq() where we've cleared the irq_cfg
> > pointer in free_irq_cfg(), but have not yet called irq_free_desc().  Note
> > that we have cleared vector_irq in __clear_irq_vector() prior to free_irq_cfg(),
> > but smp_irq_move_cleanup_interrupt() might've already referenced the irq_desc.
> 
> So, what happens if the irq_desc gets freed by the destroy_irq() in the
> sparse irq case? smp_irq_move_cleanup_interrupt() will refer to freed
> irq desc memory! Right?
>
> May we should really do something like the appended (untested patch)?
> Can you please review and give this a try? Let me review a bit more to
> see if this really fixes the issue.

It's fixing the problem.

But this move_cleanup stuff could be made less stupid.

The check for irq_desc is superflous. irq_cfg() calls
irq_get_chip_data() which will return NULL if the irq descriptor is
not there.

To avoid the lookup business completely we should really store
irq_desc instead of the irq number in the per cpu vector array, that
would also get rid of the lookup in the irq delivery path.

Now that still needs to iterate over all vectors, but this could be
optimized in a second step.

In complete_move() we send the IPI to all cpus in the old mask. We
really should set the corresponding vector bit in a per cpu bitfield
on those cpus in the mask. The cleanup can rely on the bits and avoid
looking at 200+ vectors to find a single one. 

Thoughts?

	tglx
