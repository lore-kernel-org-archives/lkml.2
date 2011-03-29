Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1C2PTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:19:41 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:10492 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1C2PTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:19:40 -0400
X-IronPort-AV: E=Sophos;i="4.63,262,1299456000"; 
   d="scan'208";a="5029830"
Date: Tue, 29 Mar 2011 16:19:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jan Beulich <JBeulich@novell.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: do not clear and mask evtchns in 
 __xen_evtchn_do_upcall
In-Reply-To: <4D9213210200007800038E2D@vpn.id2.novell.com>
Message-ID: <alpine.DEB.2.00.1103291615280.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103291505090.16492@kaball-desktop> <4D9213210200007800038E2D@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011, Jan Beulich wrote:
> >>> On 29.03.11 at 16:15, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > xen: do not clear and mask evtchns in __xen_evtchn_do_upcall
> > 
> > Switch virqs and pirqs that don't need EOI (in Xen acktype ==
> > ACKTYPE_NONE, that means the machine irq is actually edge)
> > to handle_edge_irq.
> > 
> > Use handle_fasteoi_irq for pirqs that need eoi (they generally
> > correspond to level triggered irqs), no risk in loosing interrupts
> > because we have to EOI the irq anyway.
> > 
> > This change has the following benefits:
> > 
> > - it uses the very same handlers that Linux would use on native for the
> > same irqs;
> 
> For IO-APIC IRQs this is true, but I don't think it is for MSI.

Yes it is:

static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
        int irq)
...
    irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");


> > - it uses these handlers in the same way Linux would use them: it let
> > Linux mask\unmask and ack the irq when Linux want to mask\unmask and ack
> > the irq;
> 
> Same here, plus with this you give the change the appearance as
> if Linux now suddenly had control over when the ACK happens,
> which I don't think is the case (and would be wrong in the DomU
> case at least).

>From the evtchn perspective, the ack is clearing the pending bit in the
shared_info page, so I think we are giving Linux control on when the ack
happen.
>From the pirq perspective, we are giving Linux control on when the eoi
happen.
