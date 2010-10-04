Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0JDN4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:56:02 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51425 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab0JDN4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:56:00 -0400
Date: Mon, 4 Oct 2010 14:55:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] x86: Reenable the AMD IOMMU if it's mysteriously
	vanished over suspend
Message-ID: <20101004135552.GA5063@srcf.ucam.org>
References: <1285941683-7445-1-git-send-email-mjg@redhat.com> <20101004134339.GT9817@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004134339.GT9817@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 03:43:39PM +0200, Roedel, Joerg wrote:
> > +	pci_read_config_dword(iommu->dev, 0x44, &iommu->stored_addr_lo);
> > +	pci_read_config_dword(iommu->dev, 0x48, &iommu->stored_addr_hi);
> 
> Can you use iommu->cap_ptr here? This variant should be safe too but the
> magic numbers are non-descriptive.

Sure.

> > +	/* There may be one iommu per bus, so find the appropriate bridge */
> > +	while (pdev && (pdev->bus->number != iommu->dev->bus->number)) {
> > +		pci_dev_put(pdev);
> > +		pdev = pci_get_device(PCI_VENDOR_ID_ATI, device_id, pdev);
> > +	}
> 
> This does not work reliably with more than one IOMMU in the system. I
> suggest to get the NB device by using the bus/dev/fn of the IOMMU
> device. The IOMMU in RD890 is always function 2 of the NB device. So
> just take the bus/dev/fn of the IOMMU device, set fn to zero and get the
> NB device for re-enabling function two.

The docs imply that the northbridge will always be device 0 on a given 
bus, so this ought to work? On the other hand, your approach is simpler.

> >  	for_each_iommu(iommu) {
> >  		iommu_disable(iommu);
> > -		iommu_apply_quirks(iommu);
> >  		iommu_init_flags(iommu);
> >  		iommu_set_device_table(iommu);
> >  		iommu_enable_command_buffer(iommu);
> > @@ -1173,6 +1278,11 @@ static void disable_iommus(void)
> >  
> >  static int amd_iommu_resume(struct sys_device *dev)
> >  {
> > +	struct amd_iommu *iommu;
> > +
> > +	for_each_iommu(iommu)
> > +		iommu_apply_quirks(iommu);
> > +
> >  	/* re-load the hardware */
> >  	enable_iommus();
> 
> Why have you moved this out of the enable_iommus() loop?

enable_iommus() is called on init, whereas this should only be performed 
on resume.

I'll send out an updated patch later today.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
