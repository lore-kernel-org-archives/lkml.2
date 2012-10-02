Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2JBLZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:25:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43041 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2JBLZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:25:30 -0400
Date: Tue, 2 Oct 2012 13:25:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 -tip 1/5] x86, MSI: Support multiple MSIs in presense
 of IRQ remapping
Message-ID: <20121002112524.GA12420@gmail.com>
References: <cover.1349074231.git.agordeev@redhat.com>
 <b15a9b5242c7de5770d2315ea8d13f4dcf63c00b.1349074231.git.agordeev@redhat.com>
 <20121002045518.GA7756@gmail.com>
 <20121002110630.GA2258@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002110630.GA2258@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> On Tue, Oct 02, 2012 at 06:55:18AM +0200, Ingo Molnar wrote:
> 
> Thanks for the review, Ingo.
> 
> > > @@ -584,8 +586,12 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
> > >  #define irq_alloc_desc_from(from, node)		\
> > >  	irq_alloc_descs(-1, from, 1, node)
> > >  
> > > +#define irq_alloc_descs_from(from, cnt, node)	\
> > > +	irq_alloc_descs(-1, from, cnt, node)
> > > +
> > 
> > Please use inlines instead of macros. Might transform the one 
> > above it as well in the process.
> 
> You mean here do not introduce irq_alloc_descs_from, but rather use
> irq_alloc_descs() directly?

My suggestion is to add irq_alloc_descs_from() as a (very 
simple) inline function and change irq_alloc_desc_from() to be 
an inline function as well.

> > > +int irq_can_alloc_irqs(unsigned int from, unsigned int cnt)
> > > +{
> > > +	unsigned int start;
> > > +	int ret = 0;
> > > +
> > > +	if (!cnt)
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&sparse_irq_lock);
> > > +	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
> > > +					   from, cnt, 0);
> > > +	mutex_unlock(&sparse_irq_lock);
> > > +	if (start + cnt > nr_irqs)
> > > +		ret = irq_can_expand_nr_irqs(start + cnt);
> > > +	return ret;
> > 
> > How is this supposed to work wrt. races?
> 
> It is not supposed. Just a quick check if there are enough bits before an
> attempt to allocate memory in __create_irqs(). Otherwise __create_irqs()
> might allocate irq_cfg's, then realize there are no bits, then deallocate
> and fail.
>
> But strictly speaking, irq_can_alloc_irqs() is unnecessary.

Why complicate it if it's unnecessary? The function is inviting 
wrong logic: it *cannot* tell whether there are enough bits, 
because the check is racy.

So I'd suggest to keep this out - this will further simplify the 
patches.

Thanks,

	Ingo
