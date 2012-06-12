Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2FLQew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:34:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab2FLQeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:34:50 -0400
Subject: Re: [PATCH 0/4] PCI: PCIe capability structure related
 cleanup/fixes
From: Myron Stowe <mstowe@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xudong.hao@linux.intel.com,
        ddutile@redhat.com, yu.zhao@intel.com
In-Reply-To: <CAErSpo5yZdr4dgqjO6O9PSi3XZXfSOHmjjJRemaqAfmpv5WREA@mail.gmail.com>
References: <20120601211619.20328.36769.stgit@amt.stowe>
	 <CAErSpo5yZdr4dgqjO6O9PSi3XZXfSOHmjjJRemaqAfmpv5WREA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jun 2012 10:34:44 -0600
Message-ID: <1339518884.2415.2.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 19:52 -0700, Bjorn Helgaas wrote:
> On Fri, Jun 1, 2012 at 2:16 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> > The following series introduces PCI Express 'capability structure'
> > related cleanup, fixes, and optimizations.
> >
> > Patch 1/4 changes pci_ltr_supported() to a static routine.
> >
> > Patch 2/4 removes redundant checking in various PCI Express features as
> > suggested by Bjorn Helgaas in
> > http://marc.info/?l=linux-pci&m=130463494319762&w=2
> >
> > There is a similar idiom in use that could be similarly be re-factored:
> >    if (!pci_is_pcie(dev))
> >        return;
> >
> >    pos = pci_find_ext_capability(dev, ...);
> >    if (!pos)
> >        return;
> >
> > At first it seemed incorrect to remove the redundant call of
> > pci_is_pcie() in these cases as a PCI or PCI-X (< 2.0) device may be
> > involved.  In such cases an "extended capability" list would not exist,
> > as it was not introduced until PCI-X 2.0, and accesses outside of the
> > device's configuration space would be attempted.  However, upon further
> > review of pci_find_ext_capability() it looks as if such accesses would
> > be handled correctly due to the short-circuiting logic involved -
> >
> >    if (pci_read_config_dword(dev, pos, &header) != PCIBIOS_SUCCESSFUL)
> >        return 0;
> >
> > As such, I'll entertain comments as to whether or not we should also
> > make similar removals of pci_is_pcie() in these cases.
> >
> > Patch 3/4 introduces pci_pcie_cap2() for use in v2 capability related
> > feature code.  The makeup of Express' capability structure varies
> > substantially between v1 and v2.
> >
> > There is still some redundancy in PCIe v2 capabilities checking related
> > to the Latency Tolerance Reporting (LTR) feature routines that likely
> > could be re-factored further; please feel free to respond with ideas.
> >
> > Patch 4/4 makes a minor optimization to the saving and restoring of
> > PCI Express capability structures.
> >
> > Seems like the same type of optimization could be done to remove the
> > 'if (pcie_cap_has_lnkctl(dev->pcie_type, flags))' check.  According to
> > section 7.8 "PCI Express Capability Structure" of the PCI Express 1.0a
> > specification:
> >
> >    "Figure 7-10 details allocation of register fields in the PCI
> >     Express Capability structure. The PCI Express Capabilities,
> >     Device Capabilities, Device Status/Control, Link Capabilities,
> >     and Link Status/Control registers are required for all PCI
> >     Express devices. Endpoints are not required to implement
> >     registers other than those listed above and terminate the
> >     capability structure."
> >
> > There may have been some early Express devices that did not properly
> > follow the specification which required the introduction of
> > 'pcie_cap_has_lnkctl()' so I did not make the additional optimization.
> > ---
> >
> > Myron Stowe (4):
> >      PCI: Remove redundant capabilities checking in pci_{save,restore}_pcie_state
> >      PCI: Add pci_pcie_cap2() check for PCIe feature capabilities >= v2
> >      PCI: Remove redundant checking in PCI Express capability routines
> >      PCI: make pci_ltr_supported static.
> 
> I added Don's acks, made a couple minor changes he suggested, removed
> the static pci_ltr_supported() function declaration (unnecessary,
> AFAICS), and pushed these to:
> 
>   http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=shortlog;h=refs/heads/topic/stowe-cap-cleanup
> 
> If everything looks right to you, I'll merge it into "next" tomorrow.
> Thanks for doing this; I think it's some nice cleanup and will make
> things safer and easier to understand.

Looks good - thanks to both Don and yourself for the suggestions and
changes to make the patch headers more comprehensible with respect to
the capabilities structure versions.

Myron
> 
> Bjorn


