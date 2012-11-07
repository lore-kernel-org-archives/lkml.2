Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2KGK0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:26:36 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7717 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2KGK0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:26:35 -0500
X-IronPort-AV: E=Sophos;i="4.80,728,1344211200"; 
   d="scan'208";a="213710349"
Date: Wed, 7 Nov 2012 10:25:49 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 2/2] xen/arm: Fix compile errors when drivers are compiled
 as modules.
In-Reply-To: <1352239982-17389-3-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1211070959150.2689@kaball.uk.xensource.com>
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com> <1352239982-17389-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.80.2.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Konrad Rzeszutek Wilk wrote:
> We end up with:
> 
> ERROR: "HYPERVISOR_event_channel_op" [drivers/xen/xen-gntdev.ko] undefined!
> ERROR: "privcmd_call" [drivers/xen/xen-privcmd.ko] undefined!
> ERROR: "HYPERVISOR_grant_table_op" [drivers/net/xen-netback/xen-netback.ko] undefined!
> 
> and this patch exports said function (which is implemented in hypercall.S).
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you very much for going out of your way to fix this issue (I am
currently at LinuxCon).


>  arch/arm/xen/enlighten.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 59bcb96..96d969d 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -166,3 +166,8 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
>  	*pages = NULL;
>  }
>  EXPORT_SYMBOL_GPL(free_xenballooned_pages);
> +
> +/* In the hypervisor.S file. */
> +EXPORT_SYMBOL_GPL(HYPERVISOR_event_channel_op);
> +EXPORT_SYMBOL_GPL(HYPERVISOR_grant_table_op);
> +EXPORT_SYMBOL_GPL(privcmd_call);
 
I think the patch is OK and I tested it: it fixes the issue reported
by Russell.
However I am wondering, does it actually make sense only to export 3
hypercalls among the set implemented in hypercall.S?
Maybe it does make sense only to export a subset, but I wouldn't
necessarly do the differentiation here, I would just export all the
hypercalls implemented in hypercalls.S.
In fact if we separate the hypercalls in two sets, I would like to
see a similar differentiation on x86 too.
