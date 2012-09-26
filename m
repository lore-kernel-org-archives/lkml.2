Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2IZOgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:36:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab2IZOgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:36:07 -0400
Message-ID: <1348670159.28860.183.camel@bling.home>
Subject: Re: 3.6-rc7 boot crash + bisection
From: Alex Williamson <alex.williamson@redhat.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Florian Dazinger <florian@dazinger.net>, linux-kernel@vger.kernel.org,
        iommu <iommu@lists.linux-foundation.org>
Date: Wed, 26 Sep 2012 08:35:59 -0600
In-Reply-To: <20120926132050.GB10549@amd.com>
References: <20120924210348.5f50677b@brain.lan>
	 <1348597970.28860.114.camel@bling.home> <20120925205420.0a07dea2@brain.lan>
	 <1348602226.28860.132.camel@bling.home> <20120926132050.GB10549@amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 15:20 +0200, Roedel, Joerg wrote:
> On Tue, Sep 25, 2012 at 01:43:46PM -0600, Alex Williamson wrote:
> > Joerg, any thoughts on a quirk for this?  Unfortunately we can't just
> > skip IOMMU groups when an alias is broken because it puts the other
> > IOMMU groups at risk that might not actually be isolated from this
> > device.  It looks like we parse the alias info before PCI is probed, so
> > maybe we'd need to call the quirk from iommu_init_device itself.
> 
> I fear that the BIOS does everything right and device 08:04.0 is indeed
> using 08:00.0 as request-id. There are a couple of devices where this
> happens, usually when the vendor just took the old 32bit PCI chip, added
> a transparent PCIe-to-PCI bridge to the device and sell it a PCIe.
> 
> So the assumption that every request-id has a corresponding pci_dev
> structure does not hold. I also had made that assumption in the
> AMD IOMMU driver but had to add code which removes that assumption. We
> should look for a way to remove that assumption from the group-code too.

Hmm, that throws a kink in iommu groups.  So perhaps we need to make an
alias interface to iommu groups.  Seems like this could just be an extra
parameter to iommu_group_get and iommu_group_add_device (empty in the
typical case).  Then we have the problem of what's the type for an
alias?  For AMI-Vi, it's a u16, but we need to be more generic than
that.  Maybe iommu groups should just treat it as a void* so iommus can
use a pointer to some structure or a fixed value like a u16 bus:slot.
Thoughts?  Thanks,

Alex

