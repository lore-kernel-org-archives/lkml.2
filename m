Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1GLSLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:11:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18120 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab1GLSLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:11:33 -0400
Date: Tue, 12 Jul 2011 14:11:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
Message-ID: <20110712181118.GA18662@dumpdata.com>
References: <20110701104148.GA32729@aepfle.de>
 <20110712164342.GA12867@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712164342.GA12867@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4E1C8E51.009F:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 06:43:42PM +0200, Olaf Hering wrote:
> 
> Migration of pv guests fails, the guest crashes on the target host once the
> guest is unpaused after transit. It happens when the guest is started on a
> small systen, then migrated from that small system to a large system.
> If the guest is started on a large system, then migrated to a small system and
> back to the large system, the migration will be successful.
> 
> The issue is that mfn_to_pfn() makes use of machine_to_phys_order, which
> is only configured once early in the boot process. After migration to a
> large host the mfns will exceed the order from the small system and a
> wrong code path is taken.
> 
> Calling xen_setup_machphys_mapping() again in the resume path will avoid
> the crash.

Oh, duh!

Let me queue that up for 3.0-rc7 unless there are objections?

> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> ---
>  arch/x86/xen/mmu.c     |    2 +-
>  arch/x86/xen/suspend.c |    2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-3.0-rc7/arch/x86/xen/mmu.c
> ===================================================================
> --- linux-3.0-rc7.orig/arch/x86/xen/mmu.c
> +++ linux-3.0-rc7/arch/x86/xen/mmu.c
> @@ -1623,7 +1623,7 @@ static void __init xen_map_identity_earl
>  	set_page_prot(pmd, PAGE_KERNEL_RO);
>  }
>  
> -void __init xen_setup_machphys_mapping(void)
> +void xen_setup_machphys_mapping(void)
>  {
>  	struct xen_machphys_mapping mapping;
>  	unsigned long machine_to_phys_nr_ents;
> Index: linux-3.0-rc7/arch/x86/xen/suspend.c
> ===================================================================
> --- linux-3.0-rc7.orig/arch/x86/xen/suspend.c
> +++ linux-3.0-rc7/arch/x86/xen/suspend.c
> @@ -43,6 +43,8 @@ void xen_arch_hvm_post_suspend(int suspe
>  
>  void xen_arch_post_suspend(int suspend_cancelled)
>  {
> +	xen_setup_machphys_mapping();
> +
>  	xen_build_mfn_list_list();
>  
>  	xen_setup_shared_info();
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
