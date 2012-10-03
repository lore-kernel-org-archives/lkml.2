Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab2JCNy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:54:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16735 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab2JCNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:54:57 -0400
Date: Wed, 3 Oct 2012 09:43:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: point xen_start_info to a dummy struct for PV on
 HVM guests
Message-ID: <20121003134323.GA31270@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 02:37:53PM +0100, Stefano Stabellini wrote:
> PV on HVM guests don't have a start_info page mapped by Xen, so
> xen_start_info is just NULL for them.
> That is problem because other parts of the code expect xen_start_info to
> point to something valid, for example xen_initial_domain() is defined as
> follow:
> 
> #define xen_initial_domain()    (xen_domain() && \
>                  xen_start_info->flags & SIF_INITDOMAIN)
> 

.. introduced by commit 4c071ee5268f7234c3d084b6093bebccc28cdcba
("arm: initial Xen support)

> 
> Allocate a dummy start_info struct and point xen_start_info to it, as we
> do on ARM.
> This is not going to change things for PV guests because
> xen_start_info is set by arch/x86/xen/xen-head.S:startup_xen.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

And lets change that to
'xen_dummy_start_info' to keep in sync with the other dummy one.

And also add a commnt:

/*
 * Since 'xen_initial_domain' dereferences the xen_start_info we need
 * a dummy structure filled with zeros (for PVHVM guests which initialize
 * this late). For PV guests we do not have to worry about this as the first
 * few instructions (startup_xen) set it  properly.
 */
> +struct start_info *xen_start_info = &_xen_start_info;
>  EXPORT_SYMBOL_GPL(xen_start_info);
>  
>  struct shared_info xen_dummy_shared_info;
