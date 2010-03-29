Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0C2IkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:40:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:38402 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab0C2IkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:40:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,327,1267430400"; 
   d="scan'208";a="259752349"
Subject: Re: [PATCH] x86, MCE, fix MSR_IA32_MCI_CTL2 CMCI threshold setup
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4BB06426.7070707@jp.fujitsu.com>
References: <1269847000.1060.91.camel@yhuang-dev.sh.intel.com>
	 <4BB06426.7070707@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 16:40:15 +0800
Message-ID: <1269852015.1060.102.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Seto san,

Thanks for review.

On Mon, 2010-03-29 at 16:26 +0800, Hidetoshi Seto wrote:
> (2010/03/29 16:16), Huang Ying wrote:
> > It is reported that CMCI is not raised when number of corrected error
> > reaches preset threshold. After inspection, it is found that
> > MSR_IA32_MCI_CTL2 threshold field is not setup properly. This patch
> > fixed it.
> > 
> > Reported-by: Shaohui Zheng <shaohui.zheng@intel.com>
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > Acked-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  arch/x86/include/asm/mce.h             |    3 +++
> >  arch/x86/kernel/cpu/mcheck/mce_intel.c |    1 +
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> > index 6c3fdd6..355f298 100644
> > --- a/arch/x86/include/asm/mce.h
> > +++ b/arch/x86/include/asm/mce.h
> > @@ -38,6 +38,9 @@
> >  #define MCM_ADDR_MEM	 3	/* memory address */
> >  #define MCM_ADDR_GENERIC 7	/* generic */
> >  
> > +/* CTL2 register defines */
> > +#define MCI_CTL2_THRESHOLD_MASK	0x7fff
> > +
> >  #define MCJ_CTX_MASK		3
> >  #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
> >  #define MCJ_CTX_RANDOM		0    /* inject context: random */
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> > index d15df6e..ffe730d 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> > @@ -101,6 +101,7 @@ static void cmci_discover(int banks, int boot)
> >  			continue;
> >  		}
> >  
> > +		val &= ~MCI_CTL2_THRESHOLD_MASK;
> >  		val |= CMCI_EN | CMCI_THRESHOLD;
> >  		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
> >  		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
> 
> Hum, it seems that the CTL2 of reported environment had
> be initialized to have more than CMCI_THRESHOLD(=1) by
> BIOS etc.  Could you explain more about your inspection?

In CTL2, threshold is initialized to 10 by BIOS.

> Maybe we could handle this environment if kernel supports
> APEI's firmware-first for corrected MCE and if this is in
> that case.

I still don't know much about the details of the interaction between
BIOS and OS here.

Best Regards,
Huang Ying

