Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab0JYSCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:02:20 -0400
Received: from smtp.citrix.com ([66.165.176.89]:55761 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759226Ab0JYSCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:02:19 -0400
X-IronPort-AV: E=Sophos;i="4.58,236,1286164800"; 
   d="scan'208";a="10798218"
Subject: Re: [PATCH 1/5] xen: events: use irq_alloc_desc(_at) instead of
 open-coding an IRQ allocator.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20101025173522.GA5590@dumpdata.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
	 <1288023813-31989-1-git-send-email-ian.campbell@citrix.com>
	 <20101025173522.GA5590@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Mon, 25 Oct 2010 19:02:16 +0100
Message-ID: <1288029736.10179.35.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 18:35 +0100, Konrad Rzeszutek Wilk wrote:
> So I am curious what the /proc/interrupts looks?The issue (and the reason
> for this implementation above) was that under PV with PCI devices we would
> overlap PCI devices IRQs with Xen event channels. So we could have a USB device
> at IRQ 16 _and_ also a xen_spinlock4 handler. That would throw off the system
> since the xen_spinlock4 was an edge type handler while the USB device was an
> level (at least on my box).

I suspect what we should really be doing is to segregate the different
classes of event channel in IRQ space. I _think_ this new stuff is happy
with a discontinuous (but presumably clustered) IRQ space, I should
probably check.

e.g. regular interdomain event channels, VIRQs and the like should
probably request allocations from some range higher than nr_hw_irqs,
thus avoiding conflicts with hardware PIRQ event channels which would
ask for a 1-1 mapping with the GSI (i.e. same interrupt numbers as the
device would get under native, AIUI).

We might even decide to start the interdomain event channel range even
higher than nr_hw_irqs in order to leave room for the more dynamic h/w
PIRQs (e.g. MSIs) just after nr_hw_irqs. Assuming this is consistent
with what would happen on native then it is probably worthwhile.

> But with this shinny sparse_irq rework, maybe this is not an issue anymore?
> Can we mix a level and edge chip handler under one IRQ?

I doubt the sparse irq rework had any impact on this aspect, but it does
help us more easily arrange for them not to be shared in that way in the
first place.

> What do you see when you pass in a PCI device and say give the guest 32 CPUs??

I can try tomorrow and see, based on what you say above without
implementing what I described I suspect the answer will be "carnage". 

Ian.

