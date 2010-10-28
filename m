Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab0J1MoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:44:15 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:11168 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0J1MoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:44:11 -0400
X-IronPort-AV: E=Sophos;i="4.58,251,1286150400"; 
   d="scan'208";a="2571193"
Date: Thu, 28 Oct 2010 13:43:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 1/5] xen: events: use irq_alloc_desc(_at)
 instead of open-coding an IRQ allocator.
In-Reply-To: <20101026170841.GA10708@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1010281303330.1407@kaball-desktop>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com> <1288023813-31989-1-git-send-email-ian.campbell@citrix.com> <20101025173522.GA5590@dumpdata.com> <4CC60CB7.3070005@goop.org> <20101026141739.GA9557@dumpdata.com> <4CC70583.2050503@goop.org>
 <20101026170841.GA10708@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Konrad Rzeszutek Wilk wrote:
> > In that case we should use dynamic allocation for everything.  Or try to
> > work out distinct irq ranges for different interrupts if you really want
> > to keep irq==gsi.
> 
> Some little alarm bells are ringing in the back of my head about irq != gsi.
> 
> I think the issue was the permission. When a PCI device is allocated to the
> PV guest, we do a bunch of xc_* calls to allow the domain to use the BARs
> and the IRQ. I believe when the guest boots and tries to map the
> event channel with the physical IRQ, one of the arguments is that GSI. And
> if we provide a bogus GSI, well, we won't get the INTx to the guest.
> 
> As you mentioned, Stefano's patch add a new element to the tuple that can
> contain the GSI value. At which point we can make the guest IRQ != GSI,
> as long as we can contain the <gsi, event channel> mapping present so
> that for the hypercalls we can give it the right GSI.
> 
> The MSI/MSI-X use a completly different mechanism that does not all
> of this complication, so we are OK with that.
> 
> .. snip ..
> 
> > d) dynamically allocate all irqs for all event channel types.
> 
> <nods> Ok, you sold me on this idea.
> 


Even though dynamic allocation might seem possible for both pirqs and
irqs, there are some severe limitations:


- Xen won't allocate pirq numbers lower than 16 (probably because it
expects pirq == gsi for the first 16 gsi), so it might run out
of pirqs if we ask Xen to always choose the pirq number for us.  As a
consequence it is safer to keep using pirq == gsi, at least for the
first 16 gsis. This limitation should probably be fixed in Xen, but we
need to support older hypervisors so we cannot rely on the fix to be
present.


- Linux expects irq == gsi, see arch/x86/kernel/acpi/boot.c:gsi_to_irq

	/* Provide an identity mapping of gsi == irq
	 * except on truly weird platforms that have
	 * non isa irqs in the first 16 gsis.
	 */

