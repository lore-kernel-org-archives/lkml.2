Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2DCI6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:58:47 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40425 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2DCI6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:58:46 -0400
X-IronPort-AV: E=Sophos;i="4.75,362,1330923600"; 
   d="scan'208";a="23811382"
Message-ID: <4F7ABBC4.4050106@citrix.com>
Date: Tue, 3 Apr 2012 09:58:44 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 6/7] xen/setup: Make dom0_mem=XGB behavior
 be similar to classic Xen kernels.
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com> <1333139850-28456-7-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1333139850-28456-7-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/03/12 21:37, Konrad Rzeszutek Wilk wrote:
> Meaning that we will allocate up to XGB and not consider the
> rest of the memory as a possible balloon goal.

I agree with Jan when he commented on the equivalent Xen patch for this
behaviour.  The current behaviour is better than the classic one.

With your new behaviour it will no longer possible to specify an
unlimited balloon but a limited number of initial pages.  This is
behaviour that Jan said he used.

This problem is better solved by improving the documentation.  A review
of the xen.org wiki where dom0_mem is mentioned would be a good start,
and an update to the recently added section for distro developers.

David

> This results in /proc/meminfo reporting:
> 
> -MemTotal:        2845024 kB
> -MemFree:         2497716 kB
> +MemTotal:        2927192 kB
> +MemFree:         2458952 kB
>  ...
> -DirectMap4k:     8304640 kB
> +DirectMap4k:     3063808 kB
>  DirectMap2M:           0 kB
> 
> on a 8GB machine with 'dom0_mem=3GB' on the Xen hypervisor line.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/setup.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 2a12143..4e4aa8e 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -261,11 +261,27 @@ static unsigned long __init xen_get_max_pages(void)
>  	 * the current maximum rather than the static maximum. In this
>  	 * case the e820 map provided to us will cover the static
>  	 * maximum region.
> +	 *
> +	 * The dom0_mem=min:X,max:Y tweaks options differently depending
> +	 * on the version, but in general this is what we get:
> +	 *                | XENMEM_maximum_reser  | nr_pages
> +	 * --------------++-----------------------+-------------------
> +	 *  no dom0_mem   | INT_MAX               | the max_phys_pfn
> +	 *  =3G           | INT_MAX               | 786432
> +	 *  =max:3G       | 786432                | 786432
> +	 *  =min:1G,max:3G| 262144                | 786432
> +	 *
> +	 * The =3G is often used and it lead to us initially setting
> +	 * 786432 and allowing dom0 to balloon up to the max_physical_pfn.
> +	 * This is at odd with the classic XenOClassic so lets emulate
> +	 * the classic behavior.
>  	 */
>  	if (xen_initial_domain()) {
>  		ret = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
>  		if (ret > 0)
>  			max_pages = ret;
> +		if (ret == -1UL)
> +			max_pages = xen_start_info->nr_pages;
>  	}
>  
>  	return min(max_pages, MAX_DOMAIN_PAGES);

