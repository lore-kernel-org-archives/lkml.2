Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2JYJTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:19:15 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48088 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2JYJTN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 25 Oct 2012 05:19:13 -0400
Message-Id: <5089202E02000078000A45E7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 25 Oct 2012 10:19:10 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: move shared_info to
 reserved memory area
References: <1351155873-26500-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1351155873-26500-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.10.12 at 11:04, Olaf Hering <olaf@aepfle.de> wrote:
> @@ -1495,38 +1494,53 @@ asmlinkage void __init xen_start_kernel(void)
>  #endif
>  }
>  
> -void __ref xen_hvm_init_shared_info(void)

Was the __ref here in fact unnecessary (i.e. did you check that
its removal doesn't cause any section mismatch warnings)?

> +#ifdef CONFIG_XEN_PVHVM
> +#define HVM_SHARED_INFO_ADDR 0xFE700000UL
> +static struct shared_info *xen_hvm_shared_info;
> +
> +static void xen_hvm_connect_shared_info(unsigned long pfn)
>  {
> -	int cpu;
>  	struct xen_add_to_physmap xatp;
> -	static struct shared_info *shared_info_page = 0;
>  
> -	if (!shared_info_page)
> -		shared_info_page = (struct shared_info *)
> -			extend_brk(PAGE_SIZE, PAGE_SIZE);
>  	xatp.domid = DOMID_SELF;
>  	xatp.idx = 0;
>  	xatp.space = XENMAPSPACE_shared_info;
> -	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
> +	xatp.gpfn = pfn;
>  	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
>  		BUG();
>  
> -	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
> +}
> +static void xen_hvm_set_shared_info(struct shared_info *sip)

With its sole caller being __init, this should also be __init.

Jan

> +{
> +	int cpu;
> +
> +	HYPERVISOR_shared_info = sip;
>  
>  	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
>  	 * page, we use it in the event channel upcall and in some pvclock
>  	 * related functions. We don't need the vcpu_info placement
>  	 * optimizations because we don't use any pv_mmu or pv_irq op on
> -	 * HVM.
> -	 * When xen_hvm_init_shared_info is run at boot time only vcpu 0 is
> -	 * online but xen_hvm_init_shared_info is run at resume time too and
> -	 * in that case multiple vcpus might be online. */
> -	for_each_online_cpu(cpu) {
> +	 * HVM. */
> +	for_each_online_cpu(cpu)
>  		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
> -	}
>  }
>  
> -#ifdef CONFIG_XEN_PVHVM
> +/* Reconnect the shared_info pfn to a (new) mfn */
> +void xen_hvm_resume_shared_info(void)
> +{
> +	xen_hvm_connect_shared_info(HVM_SHARED_INFO_ADDR >> PAGE_SHIFT);
> +}
> +
> +/* Obtain an address to the pfn in reserved area */
> +void __init xen_hvm_init_shared_info(void)
> +{
> +	set_fixmap(FIX_PARAVIRT_BOOTMAP, HVM_SHARED_INFO_ADDR);
> +	xen_hvm_shared_info =
> +		(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
> +	xen_hvm_connect_shared_info(HVM_SHARED_INFO_ADDR >> PAGE_SHIFT);
> +	xen_hvm_set_shared_info(xen_hvm_shared_info);
> +}
> +
>  static void __init init_hvm_pv_info(void)
>  {
>  	int major, minor;


