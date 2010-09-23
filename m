Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0IWWwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:52:20 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:23889 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0IWWwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:52:20 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [tip:x86/pci] x86, pci: Ignore any PCI BARs that match an HPET we already know about
Date: Thu, 23 Sep 2010 16:51:25 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        simon@fire.lp0.eu, tglx@linutronix.de, hpa@linux.intel.com
References: <20100922201547.3197.33702.stgit@bob.kio> <tip-e72a6c8f7ac715a9cdb473afbc30743348d0a1e2@git.kernel.org> <4C9A79BC.6020305@kernel.org>
In-Reply-To: <4C9A79BC.6020305@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009231651.25976.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 03:48:44 pm Yinghai Lu wrote:
> On 09/22/2010 02:22 PM, tip-bot for Bjorn Helgaas wrote:
> > Commit-ID:  e72a6c8f7ac715a9cdb473afbc30743348d0a1e2
> > Gitweb:     http://git.kernel.org/tip/e72a6c8f7ac715a9cdb473afbc30743348d0a1e2
> > Author:     Bjorn Helgaas <bjorn.helgaas@hp.com>
> > AuthorDate: Wed, 22 Sep 2010 14:15:47 -0600
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Wed, 22 Sep 2010 13:29:39 -0700
> > 
> > x86, pci: Ignore any PCI BARs that match an HPET we already know about
> > 
> > We often discover the HPET early, via the static ACPI HPET table,
> > before enumerating PCI devices.  If the HPET is implemented as a PCI
> > function, we will discover it again during PCI device enumeration.  We
> > must ignore the PCI function so we don't inadvertently move it out
> > from under the driver.
> > 
> > I think it's better to ignore *any* PCI BAR that matches a previously
> > discovered HPET; that way we don't need platform-specific knowledge,
> > and we won't have to add more quirks for future machines.
> > 
> > This is for a regression from 2.6.34, but the reporter has been
> > unable to test it yet.
> > 
> > [ hpa: if this fixes the regression, it should be promoted to x86/urgent ]
> > 
> > Reference: https://bugzilla.kernel.org/show_bug.cgi?id=18482
> > Reported-by: Simon Arlott <simon@fire.lp0.eu>
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > LKML-Reference: <20100922201547.3197.33702.stgit@bob.kio>
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > ---
> >  arch/x86/kernel/quirks.c |   21 +++++++++++++++++++++
> >  arch/x86/pci/fixup.c     |   28 ----------------------------
> >  2 files changed, 21 insertions(+), 28 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> > index 939b9e9..99a7d4b 100644
> > --- a/arch/x86/kernel/quirks.c
> > +++ b/arch/x86/kernel/quirks.c
> > @@ -507,6 +507,27 @@ static void force_disable_hpet_msi(struct pci_dev *unused)
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
> >  			 force_disable_hpet_msi);
> >  
> > +static void disable_pci_hpet(struct pci_dev *dev)
> > +{
> > +	int i;
> > +
> > +	if (!hpet_address)
> > +		return;
> > +
> > +	for (i = 0; i < 6; i++) {
> > +		struct resource *res = &dev->resource[i];
> > +
> > +		if (resource_type(res) == IORESOURCE_MEM &&
> > +		    res->start == hpet_address) {
> > +			dev_info(&dev->dev, "BAR %d: %pR is an HPET we found earlier; ignoring this BAR\n",
> > +				 i, res);
> > +			res->flags = 0;
> > +			res->start = 0;
> > +			res->end = 0;
> > +		}
> > +	}
> > +}
> 
> It seems there is some problem here:
> 
> hpet_res is inserted to resource with late_initcall().
> so if you don't touch that hpet address in bar and not put in the resource.
> kernel could allocate that address to other devices that doesn't get resource from BIOS.

Marking the BAR as IORESOURCE_PCI_FIXED would fix part of the problem.
It would prevent us from moving the BAR, which means the HPET driver
should keep working.

And in some cases, it will let us claim the address space to keep the
kernel from putting another device there.

In other cases (like bug 18482), we won't claim the address space
because the BAR is not inside a host bridge window, and we'll return
from pci_claim_resource() before requesting the BAR because we didn't
find a parent to allocate from.  However, we will never place another
PCI device there, because we only allocate PCI space from PCI host
bridge windows.

Outside of the host bridge windows, it feels like no-man's land --
there's nothing to protect the resources used by PCI *or* ACPI devices
unless they happen to be in E820 reserved area.  I think we're just
being lucky now because we basically never move ACPI devices.

Bottom line: even though IORESOURCE_PCI_FIXED isn't perfect, I think
it's a better idea than my first patch, and I'll post a revision.

Bjorn
