Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3ACFpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 00:45:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2749 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3ACFo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 00:44:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 02 Jan 2013 21:42:13 -0800
Message-ID: <50E51C08.1020603@nvidia.com>
Date: Thu, 3 Jan 2013 07:50:00 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <50DD6311.9000002@gmail.com> <50E40106.4020406@nvidia.com> <50E4FBAF.30700@gmail.com>
In-Reply-To: <50E4FBAF.30700@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.01.2013 05:31, Mark Zhang wrote:
> Sorry I didn't get it. Yes, in current design, you can pin all mem
> handles in one time but I haven't found anything related with "locking
> only once per submit".
> 
> My idea is:
> - remove "job->addr_phys"
> - assign "job->reloc_addr_phys" & "job->gather_addr_phys" separately
> - In "pin_job_mem", just call "host1x_memmgr_pin_array_ids" twice to
> fill the "reloc_addr_phy" & "gather_addr_phys".
> 
> Anything I misunderstood?

The current design uses CMA, which makes pinning basically a no-op. When
we have IOMMU support, pinning requires calling into IOMMU. Updating
SMMU tables requires locking, and probably maintenance before SMMU code
also requires its own locked data tables. For example, preventing
duplicate pinning might require a global table of handles.

Putting all of the handles in one table allows doing duplicate detection
across cmdbuf and reloc tables. This allows pinning each buffer exactly
once, which reduces number of calls to IOMMU.

> "host1x_cma_pin_array_ids" doesn't return negative value right now, so
> maybe you need to take a look at it.

True, and also a consequence of using CMA: pinning can never fail. With
IOMMU, pinning can fail.

Terje
