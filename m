Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2A0Vic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:38:32 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:7653
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752096Ab2A0Vi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:38:29 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F2315A3.80909@freescale.com>
Date: Fri, 27 Jan 2012 15:22:43 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Joerg Roedel <joro@8bytes.org>, Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
References: <1326983405-319-3-git-send-email-joerg.roedel@amd.com> <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net> <20120120160344.GG2205@amd.com> <4F219A9C.8000400@freescale.com> <20120126183116.GI19255@amd.com> <4F219E82.106@freescale.com> <20120126185101.GJ19255@amd.com> <4F21A2D5.6000204@freescale.com> <20120126194428.GH6269@8bytes.org> <4F21B152.3010103@freescale.com> <20120127110120.GL19255@amd.com>
In-Reply-To: <20120127110120.GL19255@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 05:01 AM, Joerg Roedel wrote:
> On Thu, Jan 26, 2012 at 02:02:26PM -0600, Scott Wood wrote:
>> On 01/26/2012 01:44 PM, Joerg Roedel wrote:
> 
>>>>> Another reason why it must be in the generic struct is the intended
>>>>> generic dma-ops layer on-top. This code can decide on this flag wheter a
>>>>> address needs to be remapped at all.
>>>>
>>>> So the DMA API would just read this, not write it?
> 
> Yes, the dma-ops code needs this information to decide whether remapping
> is required at all and where the remap window is.
> 
>>> The whole geometry thing is only implemented on the read side. There is
>>> no implementation in domain_set_attr for it. So the geometry
>>> information is read-only by default.
>>
>> We will need to be able to set this, for some vfio+kvm uses.
> 
> That's fine. Just implement a handler for it in the driver-specific
> set_attr callback then. 

OK, so there's a geometry that is read-only, and potentially a
driver-specific geometry that is read/write.  The default config for
PAMU would likely be a 1 MiB aperture in which the dma api can do
arbitrary 4k mappings -- this fits within the get generic geometry
operation.

Should generic get geometry return an error if the driver-specific
geometry has been set to something that doesn't fit within the generic
geometry model?

>>>> Still no reason why it couldn't be a separate attribute.  Then if you
>>>> get a failure trying to write it, it's more obvious why.
>>>
>>> This would mean iommu specific hacks, which are not necessary in this
>>> case.
>>
>> Why would making it a separate generic attribute require iommu specific
>> hacks?
> 
> Because the dma-ops code needs something like
> 
> 	iommu_domain_get_attr(domain, GART_ATTR_FORCE_APERTURE, data);
> 
> to check it. I call this a hack because the dma-ops code asks if it runs
> on a specific hardware. This is not necessary here.

I said a generic attribute (not GART specific) -- but if we're never
going to use the generic geometry struct for a set operation, bundling
it should be OK.

>>> Which hardware capabilities besides the geometry do you mean?
>>
>> Well, we have things like stash target (automatic cache prefetch after
>> DMA) configuration, but in this case I was thinking about restrictions
>> on what kind of aperture you can set, and what sort of mappings you can
>> create with the result.
> 
> The stash target is a perfect fit for a PAMU specific domain attribute.

Yes.

> Yes, we talked about that already. Probably we should talk about code to
> make progress here. Do you have anything ready to post?

No, at this point I'm just trying to follow the API development while
tending to other tasks.  I think Varun is working on the code for now.

-Scott

