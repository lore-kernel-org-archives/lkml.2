Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965454Ab2J3S6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:58:38 -0400
Received: from smtp.tele.fi ([192.89.123.25]:42601 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752651Ab2J3S6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:58:37 -0400
X-Greylist: delayed 2459 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 14:58:36 EDT
X-Originating-Ip: [194.89.68.22]
Date: Tue, 30 Oct 2012 20:17:32 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Olaf Hering <olaf@aepfle.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: require at least Xen 3.4 as
 dom0
Message-ID: <20121030181732.GZ8912@reaktio.net>
References: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 05:05:05PM +0100, Olaf Hering wrote:
> The XenPVHVM extensions have not been tested much on very old
> hypervisors. At least Xen 3.4 gets some testing with the pvops kernel.
> 
> Require at least Xen 3.4 for the PVonHVM extensions. If an older
> hypervisor is detected the extensions will be disabled and the guest
> will only see emulated hardware.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
>

IIRC upstream Linux PVonHVM drivers do work OK today on RHEL5 Xen, 
which advertises itself as Xen 3.1.2-based..


-- Pasi


> ---
>  arch/x86/xen/enlighten.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 0cc41f8..8566fa8 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1543,17 +1543,10 @@ static void __init xen_hvm_init_shared_info(void)
>  
>  static void __init init_hvm_pv_info(void)
>  {
> -	int major, minor;
>  	uint32_t eax, ebx, ecx, edx, pages, msr, base;
>  	u64 pfn;
>  
>  	base = xen_cpuid_base();
> -	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
> -
> -	major = eax >> 16;
> -	minor = eax & 0xffff;
> -	printk(KERN_INFO "Xen version %d.%d.\n", major, minor);
> -
>  	cpuid(base + 2, &pages, &msr, &ecx, &edx);
>  
>  	pfn = __pa(hypercall_page);
> @@ -1604,13 +1597,29 @@ static void __init xen_hvm_guest_init(void)
>  
>  static bool __init xen_hvm_platform(void)
>  {
> +	int major, minor, old = 0;
> +	uint32_t eax, ebx, ecx, edx, base;
> +	bool usable = true;
> +
>  	if (xen_pv_domain())
>  		return false;
>  
> -	if (!xen_cpuid_base())
> +	base = xen_cpuid_base();
> +	if (!base)
>  		return false;
>  
> -	return true;
> +	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
> +
> +	major = eax >> 16;
> +	minor = eax & 0xffff;
> +
> +	/* Require at least Xen 3.4 */
> +	if (major < 3 || (major == 3 && minor < 4))
> +		usable = false;
> +	printk(KERN_INFO "Xen version %d.%d.%s\n",
> +		major, minor, usable ? "" : " (too old)");
> +
> +	return usable;
>  }
>  
>  bool xen_hvm_need_lapic(void)
> -- 
> 1.8.0
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
