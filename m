Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab2JWJWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:22:40 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:28867 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2JWJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:22:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,634,1344211200"; 
   d="scan'208";a="15327914"
Message-ID: <1350984138.2237.22.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/hvm: If we fail to fetch an HVM
 parameter print out which flag it is.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Tue, 23 Oct 2012 10:22:18 +0100
In-Reply-To: <1350673381-20342-1-git-send-email-konrad.wilk@oracle.com>
References: <1350673381-20342-1-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 20:03 +0100, Konrad Rzeszutek Wilk wrote:
> Makes it easier to troubleshoot in the field.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  include/xen/hvm.h |   31 +++++++++++++++++++++++++++++--
>  1 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/include/xen/hvm.h b/include/xen/hvm.h
> index b193fa2..c2a4238 100644
> --- a/include/xen/hvm.h
> +++ b/include/xen/hvm.h
> @@ -5,6 +5,33 @@
>  #include <xen/interface/hvm/params.h>
>  #include <asm/xen/hypercall.h>
>  
> +static const char *param_name(int op)
> +{
> +	static const char *const names[] = {

#define PARAM(x) [x] = STRINGIFY(x)
would save from typos due to doubling everything up.

Or even:
#define PARAM(x) [HVM_PARAM#_x] STRINGIFY(x)

> +		[HVM_PARAM_CALLBACK_IRQ] = "HVM_PARAM_CALLBACK_IRQ",
> +		[HVM_PARAM_STORE_PFN] = "HVM_PARAM_STORE_PFN",
> +		[HVM_PARAM_STORE_EVTCHN] = "HVM_PARAM_STORE_EVTCHN",
> +		[HVM_PARAM_PAE_ENABLED] = "HVM_PARAM_PAE_ENABLED",
> +		[HVM_PARAM_IOREQ_PFN] = "HVM_PARAM_IOREQ_PFN",
> +		[HVM_PARAM_BUFIOREQ_PFN] = "HVM_PARAM_BUFIOREQ_PFN",
> +		[HVM_PARAM_TIMER_MODE] = "HVM_PARAM_TIMER_MODE",
> +		[HVM_PARAM_HPET_ENABLED] = "HVM_PARAM_HPET_ENABLED",
> +		[HVM_PARAM_IDENT_PT] = "HVM_PARAM_IDENT_PT",
> +		[HVM_PARAM_DM_DOMAIN] = "HVM_PARAM_DM_DOMAIN",
> +		[HVM_PARAM_ACPI_S_STATE] = "HVM_PARAM_ACPI_S_STATE",
> +		[HVM_PARAM_VM86_TSS] = "HVM_PARAM_VM86_TSS",
> +		[HVM_PARAM_VPT_ALIGN] = "HVM_PARAM_VPT_ALIGN",
> +		[HVM_PARAM_CONSOLE_PFN] = "HVM_PARAM_CONSOLE_PFN",
> +		[HVM_PARAM_CONSOLE_EVTCHN] = "HVM_PARAM_CONSOLE_EVTCHN" };

You probably want a , and a newline before the }.

> +
> +	if (op >= ARRAY_SIZE(names))
> +		return "unknown";
> +
> +	if (!names[op])
> +		return "reserved";
> +
> +	return names[op];
> +}
>  static inline int hvm_get_parameter(int idx, uint64_t *value)
>  {
>  	struct xen_hvm_param xhv;
> @@ -14,8 +41,8 @@ static inline int hvm_get_parameter(int idx, uint64_t *value)
>  	xhv.index = idx;
>  	r = HYPERVISOR_hvm_op(HVMOP_get_param, &xhv);
>  	if (r < 0) {
> -		printk(KERN_ERR "Cannot get hvm parameter %d: %d!\n",
> -			idx, r);
> +		printk(KERN_ERR "Cannot get hvm parameter %s (%d): %d!\n",
> +			param_name(idx), idx, r);
>  		return r;
>  	}
>  	*value = xhv.value;


