Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688Ab2JXLBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:01:41 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:37320 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770Ab2JXLBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:01:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15355518"
Date: Wed, 24 Oct 2012 12:01:09 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>
Subject: Re: [PATCH 02/10] xen/pvh: Fix PVHVM 32-bit bootup problems.
In-Reply-To: <1351015931-16991-3-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1210241159230.2689@kaball.uk.xensource.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com> <1351015931-16991-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Konrad Rzeszutek Wilk wrote:
> With the split of the 'unsigned int space' in a 'u16 space'
> and 'u16 foreign_domid' in xen_add_to_physmap the compiler
> won't write the full 32-bit value in 'space'. Instead
> it will write a 16-bit value - which is OK. The problem
> is that we allocate the xen_add_to_physmap structure from
> the stack which can (and it has) various garbage on it.
> 
> The end result is that without this patch we end up
> providing this to the hypervisor:
> 
>    xatp.space = 0xc1310001;
> instead of:
>    xatp.space = 0x1;
> 
> Forcing the foreign_domid to 0, will over-write the garbage
> that was on the stack.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Good fix.


>  arch/x86/xen/enlighten.c  |    1 +
>  drivers/xen/grant-table.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index e3497f2..b679f86 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1509,6 +1509,7 @@ void __ref xen_hvm_init_shared_info(void)
>  	xatp.domid = DOMID_SELF;
>  	xatp.idx = 0;
>  	xatp.space = XENMAPSPACE_shared_info;
> +	xatp.foreign_domid = 0;
>  	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
>  	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
>  		BUG();
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index b2b0a37..cbfd929 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -1044,6 +1044,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  		do {
>  			xatp.domid = DOMID_SELF;
>  			xatp.idx = i;
> +			xatp.foreign_domid = 0;
>  			xatp.space = XENMAPSPACE_grant_table;
>  			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
>  			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
> -- 
> 1.7.7.6
> 
