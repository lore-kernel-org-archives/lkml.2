Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0C2I1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:27:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47876 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0C2I1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:27:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4BB06426.7070707@jp.fujitsu.com>
Date: Mon, 29 Mar 2010 17:26:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, MCE, fix MSR_IA32_MCI_CTL2 CMCI threshold setup
References: <1269847000.1060.91.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1269847000.1060.91.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/03/29 16:16), Huang Ying wrote:
> It is reported that CMCI is not raised when number of corrected error
> reaches preset threshold. After inspection, it is found that
> MSR_IA32_MCI_CTL2 threshold field is not setup properly. This patch
> fixed it.
> 
> Reported-by: Shaohui Zheng <shaohui.zheng@intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Acked-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/mce.h             |    3 +++
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index 6c3fdd6..355f298 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -38,6 +38,9 @@
>  #define MCM_ADDR_MEM	 3	/* memory address */
>  #define MCM_ADDR_GENERIC 7	/* generic */
>  
> +/* CTL2 register defines */
> +#define MCI_CTL2_THRESHOLD_MASK	0x7fff
> +
>  #define MCJ_CTX_MASK		3
>  #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
>  #define MCJ_CTX_RANDOM		0    /* inject context: random */
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index d15df6e..ffe730d 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -101,6 +101,7 @@ static void cmci_discover(int banks, int boot)
>  			continue;
>  		}
>  
> +		val &= ~MCI_CTL2_THRESHOLD_MASK;
>  		val |= CMCI_EN | CMCI_THRESHOLD;
>  		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
>  		rdmsrl(MSR_IA32_MCx_CTL2(i), val);

Hum, it seems that the CTL2 of reported environment had
be initialized to have more than CMCI_THRESHOLD(=1) by
BIOS etc.  Could you explain more about your inspection?

Maybe we could handle this environment if kernel supports
APEI's firmware-first for corrected MCE and if this is in
that case.

Patch looks good. How about cc-ing stable?

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

