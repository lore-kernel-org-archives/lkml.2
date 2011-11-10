Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1KJVMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:12:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54155 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1KJVMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:12:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6526"; a="136549424"
Message-ID: <4EBC3E20.20301@codeaurora.org>
Date: Thu, 10 Nov 2011 13:12:00 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Joerg Roedel <Joerg.Roedel@amd.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Kai Huang <mail.kai.huang@gmail.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Hiroshi Doyu <hdoyu@nvidia.com>,
        KyongHo Cho <pullip.cho@samsung.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as supported
 by the hardware
References: <1318850846-16066-1-git-send-email-ohad@wizery.com> <1318850846-16066-3-git-send-email-ohad@wizery.com> <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com> <1320938930.22195.17.camel@i7.infradead.org> <20111110170918.GE13213@amd.com>
In-Reply-To: <20111110170918.GE13213@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 9:09 AM, Joerg Roedel wrote:
> The plan is to have a single DMA-API implementation for all IOMMU 
> drivers (X86 and ARM) which just uses the IOMMU-API. But to make this 
> performing reasonalbly well a few changes to the IOMMU-API are 
> required. I already have some ideas which we can discuss if you want.

I have been experimenting with an iommu_map_range call, which maps a 
given scatterlist of discontiguous physical pages into a contiguous 
virtual region at a given IOVA. This has some performance advantages 
over just calling iommu_map iteratively. First, it reduces the amount of 
table walking / calculation needed for mapping each page, given how you 
know that all the pages will be mapped into a single 
virtually-contiguous region (so in most cases, the first-level table 
calculation can be reused). Second, it allows one to defer the TLB (and 
sometimes cache) maintenance operations until the entire scatterlist has 
been mapped, rather than doing a TLB invalidate after mapping each page, 
as would have been the case if iommu_map were just being called from 
within a loop. Granted, just using iommu_map many times may be 
acceptable on the slow path, but I have seen significant performance 
gains when using this approach on the fast path.

Steve

