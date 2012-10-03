Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2JCNtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:49:47 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:60901 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2JCNtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:49:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,528,1344211200"; 
   d="scan'208";a="14916789"
Message-ID: <1349272182.650.150.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen: point xen_start_info to a dummy struct
 for PV on HVM guests
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 3 Oct 2012 14:49:42 +0100
In-Reply-To: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 14:37 +0100, Stefano Stabellini wrote:
> PV on HVM guests don't have a start_info page mapped by Xen, so
> xen_start_info is just NULL for them.
> That is problem because other parts of the code expect xen_start_info to
> point to something valid, for example xen_initial_domain() is defined as
> follow:
> 
> #define xen_initial_domain()    (xen_domain() && \
>                  xen_start_info->flags & SIF_INITDOMAIN)

But anyone who calls this before xen_start_info is setup is going to get
a bogus result, specifically in this case they will think they are domU
when in reality they are dom0 -- wouldn't it be better to fix those
callsites?

Perhaps turn this into a static inline with a BUG_ON(!xen_start_info) to
make catching these cases easier?

> 
> 
> Allocate a dummy start_info struct and point xen_start_info to it, as we
> do on ARM.
> This is not going to change things for PV guests because
> xen_start_info is set by arch/x86/xen/xen-head.S:startup_xen.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index bf788d3..5f242cb 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -96,7 +96,8 @@ EXPORT_SYMBOL(machine_to_phys_mapping);
>  unsigned long  machine_to_phys_nr;
>  EXPORT_SYMBOL(machine_to_phys_nr);
>  
> -struct start_info *xen_start_info;
> +static struct start_info _xen_start_info;
> +struct start_info *xen_start_info = &_xen_start_info;
>  EXPORT_SYMBOL_GPL(xen_start_info);
>  
>  struct shared_info xen_dummy_shared_info;
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


