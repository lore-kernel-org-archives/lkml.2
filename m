Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2FNOwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:52:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13811 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab2FNOwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:52:22 -0400
X-IronPort-AV: E=Sophos;i="4.75,770,1330923600"; 
   d="scan'208";a="28090039"
Message-ID: <4FD9FAA3.6090303@citrix.com>
Date: Thu, 14 Jun 2012 15:52:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/xen: avoid updating TLS descriptors if they haven't
 changed
References: <1339088494-23528-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1339088494-23528-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/12 18:01, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> When switching tasks in a Xen PV guest, avoid updating the TLS
> descriptors if they haven't changed.  This improves the speed of
> context switches by almost 10% as much of the time the descriptors are
> the same or only one is different.
> 
> The descriptors written into the GDT by Xen are modified from the
> values passed in the update_descriptor hypercall so we keep shadow
> copies of the three TLS descriptors to compare against.
> 
> lmbench3 test     Before  After  Improvement
> --------------------------------------------
> lat_ctx -s 32 24   7.19    6.52  9%
> lat_pipe          12.56   11.66  7%
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
> I note that the comment in asm/desc_defs.h says the 'a' and 'b' fields
> in desc_struct as deprecated but there seems to be no suitable
> alternatives.

ping?  Any opinion on this patch from the x86 side?  If it's okay can we
get an ack so Konrad can take the patch via his tree.

Thanks.

David

> ---
>  arch/x86/xen/enlighten.c |   30 +++++++++++++++++++++++++++---
>  1 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index e74df95..18e14af 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -124,6 +124,19 @@ struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
>   */
>  static int have_vcpu_info_placement = 1;
>  
> +struct tls_descs {
> +	struct desc_struct desc[3];
> +};
> +
> +/*
> + * Updating the 3 TLS descriptors in the GDT on every task switch is
> + * surprisingly expensive so we avoid updating them if they haven't
> + * changed.  Since Xen writes different descriptors than the one
> + * passed in the update_descriptor hypercall we keep shadow copies to
> + * compare against.
> + */
> +static DEFINE_PER_CPU(struct tls_descs, shadow_tls_desc);
> +
>  static void clamp_max_cpus(void)
>  {
>  #ifdef CONFIG_SMP
> @@ -535,9 +548,20 @@ static void __init xen_load_gdt_boot(const struct desc_ptr *dtr)
>  static void load_TLS_descriptor(struct thread_struct *t,
>  				unsigned int cpu, unsigned int i)
>  {
> -	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
> -	xmaddr_t maddr = arbitrary_virt_to_machine(&gdt[GDT_ENTRY_TLS_MIN+i]);
> -	struct multicall_space mc = __xen_mc_entry(0);
> +	struct desc_struct *shadow = &per_cpu(shadow_tls_desc, cpu).desc[i];
> +	struct desc_struct *gdt;
> +	xmaddr_t maddr;
> +	struct multicall_space mc;
> +
> +	if (shadow->a == t->tls_array[i].a && shadow->b == t->tls_array[i].b)
> +		return;
> +
> +	shadow->a = t->tls_array[i].a;
> +	shadow->b = t->tls_array[i].b;
> +
> +	gdt = get_cpu_gdt_table(cpu);
> +	maddr = arbitrary_virt_to_machine(&gdt[GDT_ENTRY_TLS_MIN+i]);
> +	mc = __xen_mc_entry(0);
>  
>  	MULTI_update_descriptor(mc.mc, maddr.maddr, t->tls_array[i]);
>  }

