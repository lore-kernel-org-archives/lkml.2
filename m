Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2JVNf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:35:26 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:46366 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2JVNfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:35:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,629,1344211200"; 
   d="scan'208";a="15310344"
Date: Mon, 22 Oct 2012 14:34:44 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 4/6] xen/pvh: bootup and setup related changes.
In-Reply-To: <1350695882-12820-5-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1210221428050.2689@kaball.uk.xensource.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com> <1350695882-12820-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2012, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> In enlighten.c for PVH we can trap cpuid via vmexit, so don't
> need to use emulated prefix call. We also check for vector callback
> early on, as it is a required feature. PVH also runs at default kernel
> IOPL.
> 
> In setup.c, in xen_add_extra_mem() we can skip updating P2M as it's managed
> by Xen. PVH maps the entire IO space, but only RAM pages need to be repopulated.
> 
> Finally, pure PV settings are moved to a separate function that is only called
> for pure PV, ie, pv with pvmmu.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 8971a26..8cce47b 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -27,6 +27,7 @@
>  #include <xen/interface/memory.h>
>  #include <xen/interface/physdev.h>
>  #include <xen/features.h>
> +#include "mmu.h"
>  #include "xen-ops.h"
>  #include "vdso.h"
>  
> @@ -78,6 +79,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
>  
>  	memblock_reserve(start, size);
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
>  	xen_max_p2m_pfn = PFN_DOWN(start + size);
>  	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
>  		unsigned long mfn = pfn_to_mfn(pfn);
> @@ -100,6 +104,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
>  		.domid        = DOMID_SELF
>  	};
>  	unsigned long len = 0;
> +	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
>  	unsigned long pfn;
>  	int ret;
>  
> @@ -113,7 +118,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
>  				continue;
>  			frame = mfn;
>  		} else {
> -			if (mfn != INVALID_P2M_ENTRY)
> +			if (!xlated_phys && mfn != INVALID_P2M_ENTRY)
>  				continue;
>  			frame = pfn;
>  		}

Shouldn't we add a "!xlated_phys &&" to the other case as well?
