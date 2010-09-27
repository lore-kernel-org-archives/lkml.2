Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab0I0IjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:39:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:4270 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844Ab0I0IjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:39:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,242,1283756400"; 
   d="scan'208";a="841217077"
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI
 SERR error
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927080106.GA32222@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-3-git-send-email-ying.huang@intel.com>
	 <20100927080106.GA32222@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 16:39:20 +0800
Message-ID: <1285576760.20791.70.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 16:01 +0800, Robert Richter wrote:
> On 26.09.10 20:57:02, Huang Ying wrote:
> > memory parity error is only valid for IBM PC-AT, newer machine use 7
> > bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
> > reported via MCE. So corresponding function name and kernel log string
> > is changed.
> > 
> > But on some machines, PCI SERR line is still used to report memory
> > errors. This is used by EDAC, so corresponding EDAC call is reserved.
> > 
> > 
> > v2:
> > 
> > - EDAC call in pci_serr_error is reserved.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  arch/x86/include/asm/mach_traps.h |    6 +++---
> >  arch/x86/kernel/traps.c           |   21 ++++++++++-----------
> >  2 files changed, 13 insertions(+), 14 deletions(-)
> > 
> > --- a/arch/x86/include/asm/mach_traps.h
> > +++ b/arch/x86/include/asm/mach_traps.h
> > @@ -9,11 +9,11 @@
> >  
> >  #define NMI_REASON_PORT		0x61
> >  
> > -#define NMI_REASON_MEMPAR	0x80
> > +#define NMI_REASON_SERR		0x80
> >  #define NMI_REASON_IOCHK	0x40
> > -#define NMI_REASON_MASK		(NMI_REASON_MEMPAR | NMI_REASON_IOCHK)
> > +#define NMI_REASON_MASK		(NMI_REASON_SERR | NMI_REASON_IOCHK)
> >  
> > -#define NMI_REASON_CLEAR_MEMPAR	0x04
> > +#define NMI_REASON_CLEAR_SERR	0x04
> 
> I already commented on this, patch #1 and #3 are basically the same in
> most parts which should be merged. What remains then in this patch is
> the modified printk() and the comment. Both could be added to #1 too
> which is then some sort of code cleanup patch.

Don thinks it is Ok to keep 2 patches.

> >  #define NMI_REASON_CLEAR_IOCHK	0x08
> >  #define NMI_REASON_CLEAR_MASK	0x0f
> >  
> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -301,15 +301,14 @@ gp_in_kernel:
> >  }
> >  
> >  static notrace __kprobes void
> > -mem_parity_error(unsigned char reason, struct pt_regs *regs)
> > +pci_serr_error(unsigned char reason, struct pt_regs *regs)
> >  {
> > -	printk(KERN_EMERG
> > -		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
> > -			reason, smp_processor_id());
> > -
> > -	printk(KERN_EMERG
> > -		"You have some hardware problem, likely on the PCI bus.\n");
> > +	printk(KERN_EMERG "NMI: PCI system error (SERR).\n");
> 
> You should keep reporting the cpu id to identify the affected node and
> also the reason.

Ok. I will add CPU ID in message. Because we know the reason, I don't
think we need the reason in message.

Best Regards,
Huang Ying


