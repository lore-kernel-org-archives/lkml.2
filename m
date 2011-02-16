Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1BPP5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:57:17 -0500
Received: from www.tglx.de ([62.245.132.106]:42217 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1BPP5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:57:13 -0500
Date: Wed, 16 Feb 2011 16:56:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Xen and incorporating event channels in to nr_irqs
In-Reply-To: <1297868399.16356.180.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.00.1102161638320.2701@localhost6.localdomain6>
References: <1297868399.16356.180.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian,

On Wed, 16 Feb 2011, Ian Campbell wrote:
> I'd very much like to remove this workaround (better described as a hack
> I think) but in order to do so I need to make sure there are plenty of
> IRQs between nr_irqs_gsi and nr_irqs. Effectively what we would like to
> do is:
> 	nr_irqs += NR_EVENT_CHANNELS;
> somewhere, except obviously we don't want to just drop that into generic
> code!
> 
> Do you have any hints as to an appropriate existing interface which
> could Xen use here?
> 
> If not any suggestions for what sort of interface might be acceptable to
> add?
> 
> For example I was wondering about adding x86_info.irqs.probe_nr_irqs,
> which returns a platform specific additional number of IRQs, and having
> arch_probe_nr_irqs += that value into its calculations.

I'm about to remove the nr_irqs NR_IRQS limitation. It's silly when we
deal with sparse irqs. So the idea is to have the initial nr_irqs set
in early boot to have a sensible size for allocating stuff. Later on
we can expand nr_irqs when the need arises.

It's not only Xen which wants to eliminate the limitation. Think about
irq expanders which are detected late in the boot. We have no sensible
way to reserve enough numbers for them at early boot as we dont know
whether that hardware is there or not.

So my plan for .39 is to ignore the NR_IRQS limitation in the sparse
case and make nr_irqs expandable of course with a sensible upper limit
in the core code itself. It's basically the allocation bitmap which
limits it, but I doubt we'll hit 1 Million irq numbers in the
forseeable future.

Thanks,

	tglx
