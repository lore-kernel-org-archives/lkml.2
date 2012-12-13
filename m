Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2LMPDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:03:34 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:44442 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756149Ab2LMPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:03:30 -0500
Message-ID: <1355410991.11327.12.camel@selen>
Subject: Re: [PATCHv3 0/7] Support for Tegra 2D hardware
From: Lucas Stach <dev@lynxeye.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: thierry.reding@avionic-design.de, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amerilainen@nvidia.com,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Dec 2012 16:03:11 +0100
In-Reply-To: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>
References: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Terje,

Am Donnerstag, den 13.12.2012, 16:04 +0200 schrieb Terje Bergstrom:
> This set of patches adds support for Tegra20 and Tegra30 host1x and
> 2D. It is based on linux-next.
> 
> The third version has too many changes to list all of them. Here are
> highlights:
>  * Renamed to host1x, and moved to drivers/gpu/host1x
>  * Greatly simplified the inner workings between physical and logical
>    driver
>  * Does not use AUXDATA for passing data to driver
>  * Runtime power management removed - will replace with runtime PM
>    later
>  * IOCTLs padded and use __64 for passing pointers
>  * DMABUF support removed, replaced with GEM CMA support

You are still doing the allocation the IMHO wrong way around. I thought
we agreed to do all the allocations in host1x, which obviously means not
using the cma_gem_helpers anymore, but introducing a new native host1x
object to back GEM/V4L/whatever objects. IMHO the current approach is a
clear layering violation and makes proper IOMMU support a lot harder. It
would also allow to get rid of all the indirections and ifdefs in host1x
memmgr, as host1x would only have to deal with it's native objects.

All the complexity of converting host1x to GEM objects should be located
in tegradrm and not be scattered between different modules.

Did you leave this out on purpose in this version of the patchset?

>  * host1x driver validates command streams and copies them to kernel
>    owned buffer
>  * Generic interrupt support removed - only syncpt irq remains
>  * Sync points are allocated now dynamically
>  * IO register space handling rewritten to use helper functions
>  * Other numerous fixes and simplifications to code
> 
> Some of the issues left open:
>  * Register definitions still use static inline. There has been a
>    debate about code style versus ability to use compiler type
>    checking and code coverage analysis. There was no conclusion, so
>    I left it as was.
>  * tegradrm has a global variable. Plan was to hide that behind a
>    virtual device, and use that as DRM root device. That plan went
>    bad once the FB CMA helper used the device for trying to allocate
>    memory.
See above, we should get rid of the helpers and do all allocations
within host1x.

Regards,
Lucas


