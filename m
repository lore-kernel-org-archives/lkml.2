Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab2JWO6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:58:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24389 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab2JWO6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:58:31 -0400
Date: Tue, 23 Oct 2012 10:46:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        mukesh.rathor@oracle.com, Ian.Campbell@citrix.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: [PATCH 1/6] xen/pvh: Support ParaVirtualized Hardware extensions.
Message-ID: <20121023144614.GC1052@phenom.dumpdata.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
 <1350695882-12820-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350695882-12820-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index b66d04c..8beebdb 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -169,7 +169,13 @@ struct xen_add_to_physmap {
>      /* Source mapping space. */
>  #define XENMAPSPACE_shared_info 0 /* shared info page */
>  #define XENMAPSPACE_grant_table 1 /* grant table page */
> -    unsigned int space;
> +#define XENMAPSPACE_gmfn        2 /* GMFN */
> +#define XENMAPSPACE_gmfn_range  3 /* GMFN range */
> +#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another guest */
> +    uint16_t space;
> +    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
> +
> +#define XENMAPIDX_grant_table_status 0x80000000
>  
>      /* Index into source mapping space. */
>      xen_ulong_t idx;

And this breaks 32-bit PVHVM :-(

The reason being that in xen_hvm_init_shared_info we allocate the
structure on the stack, and do not clear the foreign_domid to zero.

This means we can (and do get) for the argument space, something
like this:
	xatp.space == 0xffff0001;
instead of
	xatp.space = 0x1;

This fixes it:

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e3497f2..b679f86 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1509,6 +1509,7 @@ void __ref xen_hvm_init_shared_info(void)
 	xatp.domid = DOMID_SELF;
 	xatp.idx = 0;
 	xatp.space = XENMAPSPACE_shared_info;
+	xatp.foreign_domid = 0;
 	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
 	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
 		BUG();
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index b2b0a37..cbfd929 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1044,6 +1044,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 		do {
 			xatp.domid = DOMID_SELF;
 			xatp.idx = i;
+			xatp.foreign_domid = 0;
 			xatp.space = XENMAPSPACE_grant_table;
 			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
 			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
