Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2KMINZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:13:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16647 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2KMINY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:13:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 13 Nov 2012 00:13:17 -0800
Message-ID: <50A201DE.9090409@nvidia.com>
Date: Tue, 13 Nov 2012 10:16:30 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de> <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de> <50A1FE01.5090808@nvidia.com> <20121113080323.GA15983@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121113080323.GA15983@avionic-0098.mockup.avionic-design.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.11.2012 10:03, Thierry Reding wrote:
> That should be fixed with v2 I posted a few hours ago.

That's true.

> Yes, Tegra30 support will follow in a separate patch. As for IOMMU
> support it should eventually be made completely transparent, but I'm not
> opposed to adding a patch with explicit IOMMU support back in if it
> turns out that it can't be done transparently.

The trouble with this is that the generic case demands that we support
each device having a separate address space. But, on Tegra30 SMMU has
only four address spaces, so in Tegra30 case we actually end up using
the same address space for multiple devices.

Second problem is trying to avoid double mapping. With 2D acceleration,
we need support for allocating buffers, and mapping them to DC, host1x
and 2D. DMA Mapping API has a problem in that it doesn't allow just
allocating - it forces mapping the buffer to a device at the same time.
So, when 2D submit contains a reference to a dma-buf, the buffer has
already been mapped to some device, but we don't have a good way of
detecting that. We end up mapping it again, which is a performance
killer and possibly a coherence problem.

Fortunately this is all related to 2D acceleration, so we can defer both
of these problems for now.

Best regards,
Terje

