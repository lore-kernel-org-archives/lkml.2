Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2DTJ62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:58:28 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1526 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab2DTJ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:58:26 -0400
X-IronPort-AV: E=Sophos;i="4.75,452,1330923600"; 
   d="scan'208";a="24358205"
Message-ID: <4F913340.4000202@citrix.com>
Date: Fri, 20 Apr 2012 10:58:24 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lin Ming <mlin@ss.pku.edu.cn>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with hypercall
References: <1334913957.2863.1.camel@hp6530s>
In-Reply-To: <1334913957.2863.1.camel@hp6530s>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/12 10:25, Lin Ming wrote:
> Implements xen_io_apic_read with hypercall, so it returns proper IO-APIC
> information instead of fabricated one.
>
> Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
> ---
>  arch/x86/xen/apic.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
> index aee16ab..f1f392d 100644
> --- a/arch/x86/xen/apic.c
> +++ b/arch/x86/xen/apic.c
> @@ -1,14 +1,20 @@
>  #include <linux/init.h>
>  #include <asm/x86_init.h>
> +#include <asm/apic.h>
> +#include <xen/interface/physdev.h>
> +#include <asm/xen/hypercall.h>
>  
>  unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
>  {
> -	if (reg == 0x1)
> -		return 0x00170020;
> -	else if (reg == 0x0)
> -		return apic << 24;
> +	struct physdev_apic apic_op;
> +	int ret;
>  
> -	return 0xff;
> +	apic_op.apic_physbase = mpc_ioapic_addr(apic);
> +	apic_op.reg = reg;
> +	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
> +	if (ret)
> +		return ret;
> +	return apic_op.value;

Hypercall ret errors are negative, yet this function is unsigned.  Given
that the previous function had no possible way to fail, perhaps on error
you should fake up the values as before.

>  }
>  
>  void __init xen_init_apic(void)

-- 
Andrew Cooper - Dom0 Kernel Engineer, Citrix XenServer
T: +44 (0)1223 225 900, http://www.citrix.com

