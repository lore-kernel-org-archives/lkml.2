Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2AZUCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:02:38 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:42833
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753799Ab2AZUCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:02:35 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F21B152.3010103@freescale.com>
Date: Thu, 26 Jan 2012 14:02:26 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com> <1326983405-319-3-git-send-email-joerg.roedel@amd.com> <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net> <20120120160344.GG2205@amd.com> <4F219A9C.8000400@freescale.com> <20120126183116.GI19255@amd.com> <4F219E82.106@freescale.com> <20120126185101.GJ19255@amd.com> <4F21A2D5.6000204@freescale.com> <20120126194428.GH6269@8bytes.org>
In-Reply-To: <20120126194428.GH6269@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 01:44 PM, Joerg Roedel wrote:
> On Thu, Jan 26, 2012 at 01:00:37PM -0600, Scott Wood wrote:
>> On 01/26/2012 12:51 PM, Joerg Roedel wrote:
>>> Because this is a flag that makes sense for all IOMMU. Every IOMMU
>>> either allows DMA outside its aperture or it doesn't.
>>>
>>> Another reason why it must be in the generic struct is the intended
>>> generic dma-ops layer on-top. This code can decide on this flag wheter a
>>> address needs to be remapped at all.
>>
>> So the DMA API would just read this, not write it?
> 
> The whole geometry thing is only implemented on the read side. There is
> no implementation in domain_set_attr for it. So the geometry
> information is read-only by default.

We will need to be able to set this, for some vfio+kvm uses.

>> Still no reason why it couldn't be a separate attribute.  Then if you
>> get a failure trying to write it, it's more obvious why.
> 
> This would mean iommu specific hacks, which are not necessary in this
> case.

Why would making it a separate generic attribute require iommu specific
hacks?

>>> Setting this flag wrong does not create unintended identity mappings.
>>
>> Failing to set it means that DMA can go through that is not limited to
>> explicitly created mappings.  In some contexts (e.g. vfio) this is a
>> security hole.
> 
> No, when the hardware does not allow this, then software can't enforce
> it.

OK, it looked like an option that could be enabled or disabled --
because I didn't realize you were considering geometry as read-only.

> Again, the whole geometry attribute is only for iommu drivers to
> export what the hardware can do. It is not for software to configure the
> iommu driver.

So how would a vfio user set up the iommu so a kvm guest sees iova ==
guest physical, for at least its main memory, if the default aperture
doesn't cover it?

We also will gain performance by being able to set custom geometry,
because we will not be as hard on the IOMMU cache if we can use fewer,
larger subwindows.

It's not configuring the iommu driver, just this particular domain.

>>> But I don't understand what you mean by 'restrictions on possible values'. The
>>> geometry attribute is filled by the IOMMU driver dependent on the
>>> hardware capabilities. There are no limits from the iommu-code side.
>>
>> How does the user of the iommu API discover the hardware capabilities?
> 
> Which hardware capabilities besides the geometry do you mean?

Well, we have things like stash target (automatic cache prefetch after
DMA) configuration, but in this case I was thinking about restrictions
on what kind of aperture you can set, and what sort of mappings you can
create with the result.

On current Freescale PAMUs, the aperture must be a size-aligned
power-of-two region, which is carved into up to 256 equal-size
subwindows.  A mapping can be any power of 2 up to the subwindow size,
but its iova must be the subwindow start address.

We cannot just say "oh look, an aperture from here to there, we can
create all the mappings we want within that space", at least not with an
aperture over 1 MiB (256 contiguous 4k subwindows).

-Scott

