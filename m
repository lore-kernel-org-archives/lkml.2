Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2DRLgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:36:54 -0400
Received: from ozlabs.org ([203.10.76.45]:35474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab2DRLgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:36:53 -0400
Date: Wed, 18 Apr 2012 19:58:24 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] iommu: Introduce iommu_group
Message-ID: <20120418095824.GB5387@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120402203721.28977.95285.stgit@bling.home>
 <20120402211440.28977.74440.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402211440.28977.74440.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 03:14:40PM -0600, Alex Williamson wrote:
> IOMMUs often do not have visibility of individual devices in the
> system.  Due to IOMMU design, bus topology, or device quirks, we
> can often only identify groups of devices.  Examples include
> Intel VT-d & AMD-Vi which often have function level visibility
> compared to POWER partitionable endpoints which have bridge level
> granularity.

That's a significant oversimplification of the situation on POWER,
although it doesn't really matter in this context.  On older (i.e. pre
PCI-E) hardware, PEs have either host bridge (i.e. domain)
granularity, or in IIUC in some cases p2p bridge granularity, using
special p2p bridges, since that's the only real way to do iommu
differentiation without the PCI-E requestor IDs.  This isn't as coarse
as it seems in practice, because the hardware is usually built with a
bridge per physical PCI slot.

On newer PCI-E hardware, the PE granularity is basically a firmware
decision, and can go down to function level.  I believe pHyp puts the
granularity at the bridge level.  Our non-virtualized Linux "firmware"
currently does put it at the function level, but Ben is thinking about
changing that to bridge level: again, because of the hardware design
that isn't as coarse as it seems, and at this level we can hardware
guarantee isolation to a degree that's not possible at the function
level.

>  PCIe-to-PCI bridges also often cloud the IOMMU
> visibility as it cannot distiguish devices behind the bridge.
> Devices can also sometimes hurt themselves by initiating DMA using
> the wrong source ID on a multifunction PCI device.
> 
> IOMMU groups are meant to help solve these problems and hopefully
> become the working unit of the IOMMI API.

So far, so simple.  No objections here.  I am trying to work out what
the real difference in approach is in this seriers from either your or
my earlier isolation group series.  AFAICT it's just that this
approach is explicitly only about IOMMU identity, ignoring (here) any
other factors which might affect isolation.  Or am I missing
something?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
