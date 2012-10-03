Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2JCVNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:13:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33100 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab2JCVNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <20121002212523.GA11180@beef>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
	<1347479152-588-9-git-send-email-omar.luna@linaro.org>
	<20121002212523.GA11180@beef>
Date: Wed, 3 Oct 2012 16:13:33 -0500
Message-ID: <CALLhW=4oawfGqSDHAVgh_SPqB4Ugeyw6MjoaNDVkxSJcJd4Tpg@mail.gmail.com>
Subject: Re: [PATCH v2 8/9] ARM: OMAP: iommu: add device tree support
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 2 October 2012 16:25, Matt Porter <mporter@ti.com> wrote:
...
> I can see why you went this path with the iommu driver as it already had
> some integration code present here. I have some concerns going forward
> about how this should be long-term. Take any platform booting only with
> DT populated, we'd like to avoid having to use this approach where
> platform private APIs are called via pdata. In fact, it's going to makes
> thing ugly to carry any sort of pdata for a driver that's otherwise
> driven exclusively from DT.
>
> For AM335x, I can implement this approach, but it means adding some
> pruss specific integration code just to have it create the pdata for
> reset_name and assert/deassert.

Yes I agree, it looks a bit ugly for devices that have more than one
reset line name too, but right now there is no other way to keep the
reset names and also provide flexibility to the driver to control them
in a given order.

> From reading all the threads on hardresets and OMAP, it seems we may not
> be able to come up with a generic OMAP handler for these resets and
> that's really reflected in the fact that this API exists. So given that,
> it reasons that OMAP isn't the only one needing a reset API for drivers.
> I'm thinking that (as trivial as it may seem), this support may need to
> move to a reset subsystem such that drivers have a clean way to access
> reset resources in an SoC.

Well, there was a point where the OMAP hwmod code contained the reset
code and at least for me it was working fine, with iommu and ipu
processor, just with a minor misleading warning print... however then
this code got stripped out and since there appeared to be people
needing to handle their reset lines in unknown ways it was advised
that everybody should implement their own reset functions, but in my
case I could reuse most of the disabled code at the expense of almost
duplicating _enable (omap_hwmod) function while waiting all the reset
line users started asking for changes.

> I'm curious if you or others have thought about where this needs to go
> next.

I haven't planned for a reset subsystem or a more generic
implementation, although I have been looking for a way to avoid using
the pdata function pointers.

> When I first thought about a reset subsystem it seemed to trivial
> to bother with but looking at the reasoning behind the power_seq
> subsystem, it seems to have similar justification to get this machine
> specific logic out of the platform code and under standardized control
> of the driver.

IMHO, the reset code even if made a subsystem or a library, would
still need to interface with machine specific code and definitions
(say omap_hwmod), so I don't see much difference in making the
omap_device reset handlers as exported symbols for the time being,
with acceptance of the owners of omap_device code.

And then if power_seq makes it to mainline perhaps extending it to
handle deassert, assert and softreset events, but then again this
would have the same hooks to omap_hwmod which is the one with the prcm
information.

Regards,

Omar
