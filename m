Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1LTSYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:24:37 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25074 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1LTSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:24:31 -0500
Date: Tue, 20 Dec 2011 13:21:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Adin Scannell <adin@scannell.ca>
Cc: xen-devel@lists.xensource.com, konrad@darnok.org, andres@gridcentric.ca,
        adin@gridcentric.com, olaf@aepfle.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 1/3] Make xen_remap_domain_mfn_range return value
 meaningful in case of error
Message-ID: <20111220182118.GB7152@phenom.dumpdata.com>
References: <1324363013-11031-1-git-send-email-adin@scannell.ca>
 <1324363013-11031-2-git-send-email-adin@scannell.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324363013-11031-2-git-send-email-adin@scannell.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4EF0D25E.01ED,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 01:36:51AM -0500, Adin Scannell wrote:
> Original patch from Olaf Hering <ohering@novell.com>
> 
> This change fixes the xc_map_foreign_bulk interface, which would
> otherwise cause SIGBUS when pages are gone because -ENOENT is not
> returned as expected by the IOCTL_PRIVCMD_MMAPBATCH_V2 ioctl.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> This is a port to the mainline Linux tree.  Functions were refactored and
> renamed.  I believe that this is the only required change to match the
> semantics of the original patch.

Ok, this can go in on itself. Thought the title needs to be change
(to have xen/mmu in it). 

Looking at the code it looks as the IOCTL_PRIVCMD_MMAP could now return -Exx
instead of -EFAULT. Which seems to be OK with the toolstack (at least with
4.1.x).

Is this patch OK with 4.0 toolstack? Does it handle the case of getting
-EsomethingelsethanEFAULT ?

Thanks.
> 
> Signed-off-by: Adin Scannell <adin@scannell.ca>
> ---
>  arch/x86/xen/mmu.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 87f6673..288a7fc 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2350,8 +2350,8 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>  		if (err)
>  			goto out;
>  
> -		err = -EFAULT;
> -		if (HYPERVISOR_mmu_update(mmu_update, batch, NULL, domid) < 0)
> +		err = HYPERVISOR_mmu_update(mmu_update, batch, NULL, domid);
> +		if (err < 0)
>  			goto out;
>  
>  		nr -= batch;
> -- 
> 1.6.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
