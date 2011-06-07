Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1FGNiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:38:23 -0400
Received: from sous-sol.org ([216.99.217.87]:34910 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753640Ab1FGNiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:38:19 -0400
Date: Tue, 7 Jun 2011 06:38:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: padmanabh ratnakar <pratnakarlx@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu <iommu@lists.linux-foundation.org>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Seeing DMAR errors after multiple load/unload with SR-IOV
Message-ID: <20110607133804.GX23047@sequoia.sous-sol.org>
References: <BANLkTi=q0f8aYc2+fhaY5yFRRfgkOOME-g@mail.gmail.com>
 <1307398661.5901.14.camel@x201>
 <20110606223451.GW23047@sequoia.sous-sol.org>
 <BANLkTintUEWqwhUmR2MYC0jixqEi-wNJpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTintUEWqwhUmR2MYC0jixqEi-wNJpg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* padmanabh ratnakar (pratnakarlx@gmail.com) wrote:
> On Tue, Jun 7, 2011 at 4:04 AM, Chris Wright <chrisw@sous-sol.org> wrote:
> > * Alex Williamson (alex.williamson@redhat.com) wrote:
> >> On Mon, 2011-06-06 at 14:39 +0530, padmanabh ratnakar wrote:
> >> > Hi,
> >> >         I am using linux kernel 2.6.39. I have a IBM x3650 M3 system.
> >> > I have used following boot options -
> >> > intel_iommu=on iommu=pt
> >> >
> >> > I was loading/unloading my NIC driver(be2net) with num_vfs=7.
> >> >
> >> > After some iterations I get following DMAR errors -
> >> > Jun  4 03:50:20 rhel6 kernel: Uhhuh. NMI received for unknown reason
> >> > 2d on CPU 0.
> >> > Jun  4 03:50:20 rhel6 kernel: Do you have a strange power saving mode enabled?
> >> > Jun  4 03:50:20 rhel6 kernel: Dazed and confused, but trying to continue
> >> > Jun  4 03:50:20 rhel6 kernel: DRHD: handling fault status reg 2
> >> > Jun  4 03:50:20 rhel6 kernel: DMAR:[DMA Read] Request device [1a:00.2]
> >> > fault addr 78077000
> >> > Jun  4 03:50:20 rhel6 kernel: DMAR:[fault reason 02] Present bit in
> >> > context entry is clear
> >> >
> >> > I was trying to debug this. I dont understand iommu code much.
> >> > The physical address belongs the printed PCI function and there should
> >> > not have been an error.
> >> >
> >> > I am unable to see pci_dev(pdev) of VFs getting removed from
> >> > si_domain->devices list(intel-iommu.c)
> >> > when driver gets unloaded calling pci_disable_sriov() freeing VF pdevs.
> >> > Looks like issue happens when when freed pdev is allocated again and
> >> > as it is already in list,
> >> > required initializations dont happen.
> >> >
> >> > I dont know if my understanding is correct. Can anyone point me to
> >> > what the issue may be?
> >
> > Yes, that's correct.  The (now replaced) check identity_mapping()
> > will succeed when the pci_dev is recycled (it's freed, but never
> > removed from the list, this is an issue with passtrhough mode and device
> > creation/desctruction).  This false match happens w/ a brand new pci_dev
> > which still has default 32bit DMA mask, so it is removed from pt domain.
> > During removal domain_remove_one_dev_info() test that matches only
> > on bus/devfn (now also segment) will match despite the fact that the
> > info->pdev != pdev->dev.archdata.iommu.  Then...Oops
> >
> >> Typically devices are removed from the domain via
> >> drivers/pci/intel-iommu.c:device_notifier(), which is called as the
> >> device is unbound from the driver.  However, this seems to get skipped
> >> when running in passthrough mode, so I'm not sure where that's supposed
> >> to occur.  Does it happen w/o passthrough?
> >
> I had tried without passthrough on RHEL 6.1 GA kernel. Was seeing
> hangs and panics. Will check if non passthrough mode works on latest kernel.
> 
> > If you blacklist the driver then a create/delete may do similar (haven't
> > tested that idea).
> >
> >> Also note that some
> >> intel-iommu fixes have rolled into 3.0.0-rc2, you might want to update
> >> and see if anything is better there.  Thanks,
> >
> > The change in identity_mapping() means we won't demote to 32-bit DMA
> > (drop out of pt domain), so I don't think we'll see the same issue.
> >
> For testing I had made a hack in 2.6.39 kernel which will prevent
> demoting to 32bit DMA mask
> and thereby prevent calling of domain_remove_one_dev_info() for the
> specific VF device I was using
> and it had worked.
> So as you said I may not hit the issue in latest kernel. Will try that.

I think we still leak the list entry though.  Bottom line is that we
need to handle hotplug ADD_DEVICE and DEL_DEVICE notifications.  We
happen to pick up ADD_DEVICE by accident, but it's all pretty sloppy.

thanks,
-chris
