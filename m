Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab1EYOZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:25:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30358 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1EYOZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:25:29 -0400
Date: Wed, 25 May 2011 10:25:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        tom.goetz@virtualcomputer.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Thomas Goetz <tcgoetz@gmail.com>
Subject: Re: [PATCH] xen: use the trigger info we already have to choose the
 irq handler
Message-ID: <20110525142510.GA32231@dumpdata.com>
References: <alpine.DEB.2.00.1105251232020.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105251232020.12963@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4DDD1153.0052:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 12:33:23PM +0100, Stefano Stabellini wrote:
> Do not use pirq_needs_eoi to decide which irq handler to use because Xen
> always returns true if the guest does not support pirq_eoi_map.
> Use the trigger information we already have from MP-tables and ACPI.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reported-by: Thomas Goetz <tcgoetz@gmail.com>
> Tested-by: Thomas Goetz <tcgoetz@gmail.com>

Tom,

Do you prefer those email addresses or tom.goetz@virtualcomputer.com ?
..
> -	if (pirq_needs_eoi(irq))
> +	if (shareable)

Ok, so for dom0, the sharable flag is determined by the ACPI parsing.. good.
And for MSI/MSI-X we use xen_bind_pirq_msi_to_irq which sets it to use handle_edge_irq.

The only hazard which you asked me on IRC is for PV guests with Xen PCI front.
In those cases, we have no idea whether the "GSI" IRQ is edge or level and we
just assume that anything under 16 is edge. Which is 99% right, except if you
are to pass in the ACPI IRQ to the guest, or some other weird creature. The MSI/MSI-X
part of the PCI front are OK too - they use the xen_bind_pirq_msi_to_irq call.

So, putting on the todo list an extension to the PCI PV protocol to pass information
about the GSI's - whether they are edge or level.

Patch is on the 2.6.40-rc1 train.
