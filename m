Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1DZNv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:51:57 -0400
Received: from acsinet14.oracle.com ([141.146.126.236]:31844 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab1DZNv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:51:56 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 09:51:56 EDT
Date: Tue, 26 Apr 2011 09:42:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: stefano.stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST] pv-grub: Fix for incorrect dom->p2m_host[] list
 initialization
Message-ID: <20110426134242.GA26275@dumpdata.com>
References: <20110422212545.GA22846@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422212545.GA22846@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DB6CBDE.00C0:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 11:25:45PM +0200, Daniel Kiper wrote:
> Added missed Signed-off-by line.
> 
> After a lot of debugging and long reading of Linux Kernel and Xen code
> finally I killed deeply hidden bug in pv-grub. Details below.
> Additionally, I am CC'ing this e-mail to LKML because this issue
> looks like Linux Kernel problem, however, it is not.
> 
> This patch applies to Xen Ver. 4.0, Xen Ver. 4.1 and unstable tree.
> 
> # HG changeset patch
> # User dkiper@net-space.pl
> # Date 1303474763 -7200
> # Node ID b33bf24be129b7b9cd2248460beb1298088c6af5
> # Parent  dbf2ddf652dc3dd927447e79ef4bc586de55d708
> Introduction of Linux Kernel git commit ceefccc93932b920a8ec6f35f596db05202a12fe
> (x86: default CONFIG_PHYSICAL_START and CONFIG_PHYSICAL_ALIGN to 16 MB) revealed
> deeply hidden bug in pv-grub. During kernel load stage dom->p2m_host[] list has
> been incorrectly initialized.
> 
> At the beginning of kernel load stage dom->p2m_host[] list is populated with
> current pfn->mfn layout. Later during memory allocation (memory is allocated
> page by page in kexec_allocate()) page order is changed to establish linear
> layout in new domain. It is done by exchanging subsequent mfns with newly
> allocated mfns. dom->p2m_host[] list is indexed by currently requested pfn
> (it is incremented from 0) and pfn of newly allocated paged. If pfn of newly
> allocated page is less than currently requested pfn then relevant earlier
> allocated mfn is overwritten which leads to domain crash later. This patch
> fix that issue. If pfn of newly allocated page is less then currently
> requested pfn then relevant pfn/mfn pair is properly calculated and usual
> exchange occurs later.

Nice! I presume this fixes the issue you had at the Xen Hack-O-Thon with
your guest right?

> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> 
> diff -r dbf2ddf652dc -r b33bf24be129 stubdom/grub/kexec.c
> --- a/stubdom/grub/kexec.c	Thu Apr 07 15:26:58 2011 +0100
> +++ b/stubdom/grub/kexec.c	Fri Apr 22 14:19:23 2011 +0200
> @@ -91,6 +91,11 @@ int kexec_allocate(struct xc_dom_image *
>          new_pfn = PHYS_PFN(to_phys(pages[i]));
>          pages_mfns[i] = new_mfn = pfn_to_mfn(new_pfn);
>  
> +	if (new_pfn < i)
> +		for (new_pfn = i; new_pfn < dom->total_pages; ++new_pfn)
> +			if (dom->p2m_host[new_pfn] == new_mfn)
> +				break;
> +
>          /* Put old page at new PFN */
>          dom->p2m_host[new_pfn] = old_mfn;
>  
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
