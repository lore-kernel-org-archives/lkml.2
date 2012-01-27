Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2A0LBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:01:34 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:40109
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752744Ab2A0LBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:01:32 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I1432N98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYGEMB-01-48B-02
X-M-MSG: 
Date: Fri, 27 Jan 2012 12:01:20 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Scott Wood <scottwood@freescale.com>
CC: Joerg Roedel <joro@8bytes.org>, Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120127110120.GL19255@amd.com>
References: <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
 <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net>
 <20120120160344.GG2205@amd.com>
 <4F219A9C.8000400@freescale.com>
 <20120126183116.GI19255@amd.com>
 <4F219E82.106@freescale.com>
 <20120126185101.GJ19255@amd.com>
 <4F21A2D5.6000204@freescale.com>
 <20120126194428.GH6269@8bytes.org>
 <4F21B152.3010103@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F21B152.3010103@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 02:02:26PM -0600, Scott Wood wrote:
> On 01/26/2012 01:44 PM, Joerg Roedel wrote:

> >>> Another reason why it must be in the generic struct is the intended
> >>> generic dma-ops layer on-top. This code can decide on this flag wheter a
> >>> address needs to be remapped at all.
> >>
> >> So the DMA API would just read this, not write it?

Yes, the dma-ops code needs this information to decide whether remapping
is required at all and where the remap window is.

> > The whole geometry thing is only implemented on the read side. There is
> > no implementation in domain_set_attr for it. So the geometry
> > information is read-only by default.
> 
> We will need to be able to set this, for some vfio+kvm uses.

That's fine. Just implement a handler for it in the driver-specific
set_attr callback then. 

> >> Still no reason why it couldn't be a separate attribute.  Then if you
> >> get a failure trying to write it, it's more obvious why.
> > 
> > This would mean iommu specific hacks, which are not necessary in this
> > case.
> 
> Why would making it a separate generic attribute require iommu specific
> hacks?

Because the dma-ops code needs something like

	iommu_domain_get_attr(domain, GART_ATTR_FORCE_APERTURE, data);

to check it. I call this a hack because the dma-ops code asks if it runs
on a specific hardware. This is not necessary here.

> 
> >>> Setting this flag wrong does not create unintended identity mappings.
> >>
> >> Failing to set it means that DMA can go through that is not limited to
> >> explicitly created mappings.  In some contexts (e.g. vfio) this is a
> >> security hole.
> > 
> > No, when the hardware does not allow this, then software can't enforce
> > it.
> 
> OK, it looked like an option that could be enabled or disabled --
> because I didn't realize you were considering geometry as read-only.

It is indeed read-only for most iommus and the dma-ops code only needs
to read this information. And it is necessary for the iommu-api user to
get this information when we want to support iommus that have a limited
remapping-window for each domain.

> So how would a vfio user set up the iommu so a kvm guest sees iova ==
> guest physical, for at least its main memory, if the default aperture
> doesn't cover it?
> 
> We also will gain performance by being able to set custom geometry,
> because we will not be as hard on the IOMMU cache if we can use fewer,
> larger subwindows.

No problem if you also implement the write-side for your implementation.

> > Which hardware capabilities besides the geometry do you mean?
> 
> Well, we have things like stash target (automatic cache prefetch after
> DMA) configuration, but in this case I was thinking about restrictions
> on what kind of aperture you can set, and what sort of mappings you can
> create with the result.

The stash target is a perfect fit for a PAMU specific domain attribute.

> On current Freescale PAMUs, the aperture must be a size-aligned
> power-of-two region, which is carved into up to 256 equal-size
> subwindows.  A mapping can be any power of 2 up to the subwindow size,
> but its iova must be the subwindow start address.
> 
> We cannot just say "oh look, an aperture from here to there, we can
> create all the mappings we want within that space", at least not with an
> aperture over 1 MiB (256 contiguous 4k subwindows).

Yes, we talked about that already. Probably we should talk about code to
make progress here. Do you have anything ready to post?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

