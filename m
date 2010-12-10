Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0LJNCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:02:45 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48380 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab0LJNCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:02:44 -0500
X-IronPort-AV: E=Sophos;i="4.59,323,1288569600"; 
   d="scan'208";a="3287003"
Date: Fri, 10 Dec 2010 13:02:52 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH] Fix when booting Xen+Linux under QEMU.
In-Reply-To: <4D01462A.4010808@goop.org>
Message-ID: <alpine.DEB.2.00.1012101225120.2390@kaball-desktop>
References: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com> <4D01462A.4010808@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010, Jeremy Fitzhardinge wrote:
>    2. kill the ioapic dummy page hack (I'm assuming that would be
>       trivial - at least to make it all zero - because the kernel won't
>       care about the number of GSIs at that point)
 
That wouldn't work: mp_register_ioapic reads the number of entries for
each ioapic and it cannot be zero, because later on mp_find_ioapic is
going to find the ioapic a particular gsi belongs to based on the
previous results.
Mp_register_ioapic also increases gsi_top that ends up influencing the
value of nr_irqs_gsi.


Considering that nr_irqs is not a real upper limit on Xen because you
usually have at least 1024 evtchns anyway, I think we should reimplement
arch_probe_nr_irqs on Xen to set nr_irqs appropriately.
Something like this:

#define NR_EVTCHNS (sizeof(unsigned long) * 8 * sizeof(unsigned long))
int __init arch_probe_nr_irqs(void)
{
	if (xen_domain())
		nr_irqs = NR_EVTCHNS;
    
    return NR_IRQS_LEGACY;
}

The problem is that #ifdef CONFIG_SPARSE_IRQ io_apic.c reimplements
arch_probe_nr_irqs too but only if CONFIG_PCI_MSI is also defined
nr_irqs is set high enough by that function.
So to work around this problem we might have to redefine
arch_probe_nr_irqs only #if !defined(CONFIG_SPARSE_IRQ) and we might also
have to automatically enable CONFIG_PCI_MSI if the user selects
CONFIG_SPARSE_IRQ on XEN somehow.
