Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1DEIvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:51:39 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:48677 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1DEIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:51:37 -0400
X-IronPort-AV: E=Sophos;i="4.63,303,1299456000"; 
   d="scan'208";a="5139580"
Subject: Re: [Xen-devel] Re: [PATCH] xen: do not clear and mask evtchns in
 __xen_evtchn_do_upcall
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104041521370.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103291505090.16492@kaball-desktop>
	 <20110330154630.GA17427@dumpdata.com>
	 <alpine.DEB.2.00.1104041521370.16492@kaball-desktop>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 5 Apr 2011 09:51:35 +0100
Message-ID: <1301993495.23887.128.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this patch revolves around the interaction with the irq core I
think it would be worth running it by tglx as well as xen-devel for the
next iteration.

Does something about the switch of handler type fix the issue with
drivers which call disable_irq() in their interrupt handler and leave it
disabled until a later time? (e.g. the userspace evtchn driver). I think
I know why this is the case but it would be useful to mention in the
commit message.

On Mon, 2011-04-04 at 17:46 +0100, Stefano Stabellini wrote:
> 
>     - it uses these handlers in the same way Linux would use them: it let
>     Linux mask\unmask and ack the irq when Linux want to mask\unmask and ack
>     the irq;

This code is in Linux, perhaps you mean "the same way native code would
use them" or "with the semantics which the generic code defines" or
something along those lines.

> +       pirq_query_unmask(irq);
> +       /* we try to follow the same convention as Linux on native:

That's basically a coincidence, isn't it?

What we are actually trying to do is use the handler with the
appropriate semantics for the type of interrupt, e.g. event channels are
naturally edge triggered but some event channels can be bound to pirqs
with configurations that require an EOI and therefore have a level of
levelness about them.

> +        * handle_edge_irq for edge irqs and handle_fasteoi_irq for level
> +        * irqs

should probably mention the relationship between pirq_needs_eoi=>level
triggering.

Is there any relationship between pirq_needs_eoi and the trigger value
passed to PHYSDEVOP_setup_gsi at setup time?

> , see ioapic_register_intr (handle_level_irq is not used
> +        * anymore).
> +        */
> +       if (pirq_needs_eoi(irq))
> +               irq_set_chip_and_handler_name(irq, &xen_pirq_chip,
> +                               handle_fasteoi_irq, name);
> +       else
> +               irq_set_chip_and_handler_name(irq, &xen_pirq_chip,
> +                               handle_edge_irq, name);
> +
>  out:
>         spin_unlock(&irq_mapping_update_lock);

Ian.

