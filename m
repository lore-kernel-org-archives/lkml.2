Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1JQJ4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:56:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56608 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab1JQJ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:56:16 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <20111017092824.GF2198@amd.com>
References: <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com> <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com> <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
 <20111011103820.GF2138@amd.com> <CAK=WgbYOUZNX0OmRwZNO1mMG+3DZXwff+S60ESWixf04HOcbtw@mail.gmail.com>
 <20111014133510.GC2198@amd.com> <CAK=Wgbar+z_Nm1cDM4bJgrP5yWbjCsVBW=orfYwsZsT7uET8ng@mail.gmail.com>
 <CAK=WgbbQ9RRFmMXGOK2An7f0QkObYigv_OWXALFr+Bchw97j9Q@mail.gmail.com> <20111017092824.GF2198@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 17 Oct 2011 11:55:53 +0200
Message-ID: <CAK=WgbYnV1Ghtp0Hf71L-FYjKQ-V+vznYLw-_if=HMLbq5pxPQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:28 AM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> The patch looks good now. Please implement option a) and it should be
> fine.

Ok, will send in a few moments.

> I will test it on an AMD IOMMU platform. We still need someone to
> test it on VT-d.

That could be great, yeah.

Though by declaring variable-size page sizes support, we intentionally
take a very conservative approach which should effectively make this
whole logic transparent to both of the x86 implementations:

The ->map() handler of both of the AMD driver and the VT-d should be
invoked in the exact way it was invoked earlier (same order, same
parameters), because before this patch-set, all IOMMU users only
mapped page-ordered regions. With this patch-set in hand, the x86
drivers declare support for all possible page-ordered page sizes, so
the IOMMU core should just be a pass-through, and call ->map() with
the exact parameters that were provided to iommu_map().

Similarly, calls to ->unmap() should not change, because current
mainline x86 users (kvm..) only unmap a single page at a time. With
this patch set in hand, the iommu core will just trivially pass those
request through to the driver's ->unmap().

So I guess that if we can test this on AMD and see that indeed this
conservative approach works (the driver gets the same ->map() and
->unmap() calls it got before) then it should work exactly the same
with VT-d.

But having someone with a VT-d setup to test this can be great of course.

Thanks,
Ohad.
