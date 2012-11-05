Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2KEK1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:27:42 -0500
Received: from smtp.citrix.com ([66.165.176.89]:24655 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab2KEK1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:27:41 -0500
X-IronPort-AV: E=Sophos;i="4.80,714,1344211200"; 
   d="scan'208";a="43417971"
Message-ID: <1352111140.25014.97.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen/hvm: If we fail to fetch an HVM
 parameter print out which flag it is.
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 5 Nov 2012 11:25:40 +0100
In-Reply-To: <20121102163720.GA27213@konrad-lan.dumpdata.com>
References: <1350673381-20342-1-git-send-email-konrad.wilk@oracle.com>
	 <1350984138.2237.22.camel@zakaz.uk.xensource.com>
	 <20121102163720.GA27213@konrad-lan.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 16:37 +0000, Konrad Rzeszutek Wilk wrote:
> Like this?

Yup. Although I'm not sure if it really needs to be inlined. I guess
it's not an especially performance sensitve path though.

> 
> From 66705b0ff8808d86c12fcb3815d849a848b5409b Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Fri, 19 Oct 2012 15:01:46 -0400
> Subject: [PATCH] xen/hvm: If we fail to fetch an HVM parameter print out
>  which flag it is.
> 
> Makes it easier to troubleshoot in the field.
> 
> [v1: Use macro per Ian's suggestion]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> ---
>  include/xen/hvm.h | 34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/include/xen/hvm.h b/include/xen/hvm.h
> index b193fa2..13e43e4 100644
> --- a/include/xen/hvm.h
> +++ b/include/xen/hvm.h
> @@ -5,6 +5,36 @@
>  #include <xen/interface/hvm/params.h>
>  #include <asm/xen/hypercall.h>
>  
> +static const char *param_name(int op)
> +{
> +#define PARAM(x) [HVM_PARAM_##x] = #x
> +	static const char *const names[] = {
> +		PARAM(CALLBACK_IRQ),
> +		PARAM(STORE_PFN),
> +		PARAM(STORE_EVTCHN),
> +		PARAM(PAE_ENABLED),
> +		PARAM(IOREQ_PFN),
> +		PARAM(BUFIOREQ_PFN),
> +		PARAM(TIMER_MODE),
> +		PARAM(HPET_ENABLED),
> +		PARAM(IDENT_PT),
> +		PARAM(DM_DOMAIN),
> +		PARAM(ACPI_S_STATE),
> +		PARAM(VM86_TSS),
> +		PARAM(VPT_ALIGN),
> +		PARAM(CONSOLE_PFN),
> +		PARAM(CONSOLE_EVTCHN),
> +	};
> +#undef PARAM
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
> @@ -14,8 +44,8 @@ static inline int hvm_get_parameter(int idx, uint64_t *value)
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


