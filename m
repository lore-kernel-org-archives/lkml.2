Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2EUROP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:14:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51272 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2EURON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:14:13 -0400
Message-ID: <4FBA77E2.4000409@wwwdotorg.org>
Date: Mon, 21 May 2012 11:14:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/tegra: gart: Reserve iomem resource
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>  <1337019127-6863-2-git-send-email-hdoyu@nvidia.com>  <20120521141152.GA21513@avionic-0098.mockup.avionic-design.de>  <4FBA702A.1010203@wwwdotorg.org> <1337619935.1621.13.camel@tellur>
In-Reply-To: <1337619935.1621.13.camel@tellur>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 11:05 AM, Lucas Stach wrote:
> Am Montag, den 21.05.2012, 10:41 -0600 schrieb Stephen Warren:
>> On 05/21/2012 08:11 AM, Thierry Reding wrote:
>>> * Hiroshi DOYU wrote:
>>>> GART Register/Aperture range should be reserved.
>> ...
>>>> diff --git a/drivers/iommu/tegra-gart.c
>>>> b/drivers/iommu/tegra-gart.c
>> ...
>>>> +	if (!devm_request_mem_region(dev, res_remap->start, +
>>>> resource_size(res_remap), dev_name(dev))) { +		dev_err(dev,
>>>> "failed to reserve GART aperture\n"); +		return -EBUSY; +	} +
>>>
>>> I'm not so sure that this is a good idea. If the GART driver
>>> requests the GART aperture, then users of the GART aperture (e.g.
>>> the DRM driver) will no longer be able to use it.
>>
>> Presumably the DRM driver would be obtaining access to parts of the
>> GART aperture through the GART driver, rather than just grabbing the
>> IO region and using it for itself?
> 
> With a TTM-like memory manager the DRM driver will take over the address
> space management of the GART aperture. The GART driver is only used to
> set up the mappings in the IOMMU. The DRM driver is the one that sets
> up/tears down the CPU mappings on demand, so the aperture should be
> claimed in the DRM driver.

Even if the DRM driver is managing the aperture, I still think the GART
driver should claim it. The physical address of the aperture is a
property of the GART, so only the GART's resources (and DT node) should
contain a representation of where that aperture is. The DRM driver
should call into the GART driver to find out where the aperture is, and
hence GART is able to claim it without conflict.
