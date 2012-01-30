Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2A3UXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:23:13 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:49172
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753848Ab2A3UXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:23:11 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F26FBE1.5050006@freescale.com>
Date: Mon, 30 Jan 2012 14:21:53 -0600
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
References: <20120120160344.GG2205@amd.com> <4F219A9C.8000400@freescale.com> <20120126183116.GI19255@amd.com> <4F219E82.106@freescale.com> <20120126185101.GJ19255@amd.com> <4F21A2D5.6000204@freescale.com> <20120126194428.GH6269@8bytes.org> <4F21B152.3010103@freescale.com> <20120127110120.GL19255@amd.com> <4F2315A3.80909@freescale.com> <20120130142424.GR19255@amd.com>
In-Reply-To: <20120130142424.GR19255@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 08:24 AM, Joerg Roedel wrote:
> On Fri, Jan 27, 2012 at 03:22:43PM -0600, Scott Wood wrote:
> 
>> OK, so there's a geometry that is read-only, and potentially a
>> driver-specific geometry that is read/write.  The default config for
>> PAMU would likely be a 1 MiB aperture in which the dma api can do
>> arbitrary 4k mappings -- this fits within the get generic geometry
>> operation.
> 
> Better: There is a read-only geometry for _all_ IOMMUs. Some IOMMUs may
> also allow to write the geometry, like PAMU.

But we do not want to use this struct for writing.  We do not want
force_aperture to be settable (we could error if it's set incorrectly,
but that's unpleasant -- and what happens if another attribute is added
in the future?  There would otherwise be no reason to do a get-geometry
first).  We do want to be able to set subwindows and would prefer (but
don't insist) that it be one atomic operation to set
start/end/subwindows.  For PAMU you really shouldn't be setting
start/end if you aren't going to set the subwindow count.  I don't see
what real benefit we get by reusing the generic geometry struct here --
we're not giving up any opportunities for common code.

>> Should generic get geometry return an error if the driver-specific
>> geometry has been set to something that doesn't fit within the generic
>> geometry model?
> 
> A domain can only have one geometry. So if you set a new geometry
> subsequent calls to get_attr will return the new geometry.

But the implementation may support geometries that are not expressable
with the generic struct.  As soon as you set an aperture larger than 1
MiB we cannot support arbitrary mappings within the aperture.  If we
return a generic geometry showing the larger aperture, that would
mislead generic users.

The geometry should be reset when the iommu is taken away from one user
(e.g. vfio) and given to another (e.g. dma api), so the dma api should
never see the error unless something has gone wrong (in which case it's
better to flag the error early).

>> I said a generic attribute (not GART specific) -- but if we're never
>> going to use the generic geometry struct for a set operation, bundling
>> it should be OK.
> 
> The generic struct should be used to set the geometry. But you can read
> out the old geometry and set force_aperture to the same value in the new
> geometry. Drivers should actually return -EINVAL when the user tries to
> set an unsupported value for force_aperture.

Wouldn't errors be less likely, and easier to diagnose, if
force_aperture weren't part of the struct in the first place?

If the idea is to keep attributes as granular as practical, it seems the
bundling goes against that.  If that isn't a goal, then I don't see the
problem with the PAMU geometry bundling start/end with subwindows.

>> No, at this point I'm just trying to follow the API development while
>> tending to other tasks.  I think Varun is working on the code for now.
> 
> Okay, maybe it is better to follow a 'release early, release often'
> model here. So we can work out the issues together.

I agree, and will keep prodding coworkers in this direction.

-Scott

