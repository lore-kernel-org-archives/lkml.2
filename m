Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab1FFWSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1FFWSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:18:22 -0400
Subject: Re: Seeing DMAR errors after multiple load/unload with SR-IOV
From: Alex Williamson <alex.williamson@redhat.com>
To: padmanabh ratnakar <pratnakarlx@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        iommu <iommu@lists.linux-foundation.org>, dwmw2@infradead.org
Date: Mon, 06 Jun 2011 16:17:40 -0600
In-Reply-To: <BANLkTi=q0f8aYc2+fhaY5yFRRfgkOOME-g@mail.gmail.com>
References: <BANLkTi=q0f8aYc2+fhaY5yFRRfgkOOME-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1307398661.5901.14.camel@x201>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 14:39 +0530, padmanabh ratnakar wrote:
> Hi,
>         I am using linux kernel 2.6.39. I have a IBM x3650 M3 system.
> I have used following boot options -
> intel_iommu=on iommu=pt
> 
> I was loading/unloading my NIC driver(be2net) with num_vfs=7.
> 
> After some iterations I get following DMAR errors -
> Jun  4 03:50:20 rhel6 kernel: Uhhuh. NMI received for unknown reason
> 2d on CPU 0.
> Jun  4 03:50:20 rhel6 kernel: Do you have a strange power saving mode enabled?
> Jun  4 03:50:20 rhel6 kernel: Dazed and confused, but trying to continue
> Jun  4 03:50:20 rhel6 kernel: DRHD: handling fault status reg 2
> Jun  4 03:50:20 rhel6 kernel: DMAR:[DMA Read] Request device [1a:00.2]
> fault addr 78077000
> Jun  4 03:50:20 rhel6 kernel: DMAR:[fault reason 02] Present bit in
> context entry is clear
> 
> I was trying to debug this. I dont understand iommu code much.
> The physical address belongs the printed PCI function and there should
> not have been an error.
> 
> I am unable to see pci_dev(pdev) of VFs getting removed from
> si_domain->devices list(intel-iommu.c)
> when driver gets unloaded calling pci_disable_sriov() freeing VF pdevs.
> Looks like issue happens when when freed pdev is allocated again and
> as it is already in list,
> required initializations dont happen.
> 
> I dont know if my understanding is correct. Can anyone point me to
> what the issue may be?

Typically devices are removed from the domain via
drivers/pci/intel-iommu.c:device_notifier(), which is called as the
device is unbound from the driver.  However, this seems to get skipped
when running in passthrough mode, so I'm not sure where that's supposed
to occur.  Does it happen w/o passthrough?  Also note that some
intel-iommu fixes have rolled into 3.0.0-rc2, you might want to update
and see if anything is better there.  Thanks,

Alex

