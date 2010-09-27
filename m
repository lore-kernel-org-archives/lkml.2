Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab0I0JQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:16:13 -0400
Received: from mail-db3.bigfish.com ([94.245.120.74]:18213 "EHLO
	DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759026Ab0I0JQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:16:11 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 05:16:11 EDT
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK936eK1432N98dN10d1Izz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9EEDJ-02-67M-02
X-M-MSG: 
Date: Mon, 27 Sep 2010 11:00:56 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI
 SERR error
Message-ID: <20100927090056.GJ13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-3-git-send-email-ying.huang@intel.com>
 <20100927080106.GA32222@erda.amd.com>
 <1285576760.20791.70.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285576760.20791.70.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 04:39:20, Huang Ying wrote:
> On Mon, 2010-09-27 at 16:01 +0800, Robert Richter wrote:
> > On 26.09.10 20:57:02, Huang Ying wrote:
> > > memory parity error is only valid for IBM PC-AT, newer machine use 7
> > > bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
> > > reported via MCE. So corresponding function name and kernel log string
> > > is changed.
> > > 
> > > But on some machines, PCI SERR line is still used to report memory
> > > errors. This is used by EDAC, so corresponding EDAC call is reserved.
> > > 
> > > 
> > > v2:
> > > 
> > > - EDAC call in pci_serr_error is reserved.
> > > 
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > ---
> > >  arch/x86/include/asm/mach_traps.h |    6 +++---
> > >  arch/x86/kernel/traps.c           |   21 ++++++++++-----------
> > >  2 files changed, 13 insertions(+), 14 deletions(-)
> > > 
> > > --- a/arch/x86/include/asm/mach_traps.h
> > > +++ b/arch/x86/include/asm/mach_traps.h
> > > @@ -9,11 +9,11 @@
> > >  
> > >  #define NMI_REASON_PORT		0x61
> > >  
> > > -#define NMI_REASON_MEMPAR	0x80
> > > +#define NMI_REASON_SERR		0x80
> > >  #define NMI_REASON_IOCHK	0x40
> > > -#define NMI_REASON_MASK		(NMI_REASON_MEMPAR | NMI_REASON_IOCHK)
> > > +#define NMI_REASON_MASK		(NMI_REASON_SERR | NMI_REASON_IOCHK)
> > >  
> > > -#define NMI_REASON_CLEAR_MEMPAR	0x04
> > > +#define NMI_REASON_CLEAR_SERR	0x04
> > 
> > I already commented on this, patch #1 and #3 are basically the same in
> > most parts which should be merged. What remains then in this patch is
> > the modified printk() and the comment. Both could be added to #1 too
> > which is then some sort of code cleanup patch.
> 
> Don thinks it is Ok to keep 2 patches.

I don't like reviewing new changes which are thrown away with the next
patch. I review things twice and it is much harder to see what really
changed then. Also we should have a clean history.

And with git it is fairly easy to join patches.

> 
> > >  #define NMI_REASON_CLEAR_IOCHK	0x08
> > >  #define NMI_REASON_CLEAR_MASK	0x0f
> > >  
> > > --- a/arch/x86/kernel/traps.c
> > > +++ b/arch/x86/kernel/traps.c
> > > @@ -301,15 +301,14 @@ gp_in_kernel:
> > >  }
> > >  
> > >  static notrace __kprobes void
> > > -mem_parity_error(unsigned char reason, struct pt_regs *regs)
> > > +pci_serr_error(unsigned char reason, struct pt_regs *regs)
> > >  {
> > > -	printk(KERN_EMERG
> > > -		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
> > > -			reason, smp_processor_id());
> > > -
> > > -	printk(KERN_EMERG
> > > -		"You have some hardware problem, likely on the PCI bus.\n");
> > > +	printk(KERN_EMERG "NMI: PCI system error (SERR).\n");
> > 
> > You should keep reporting the cpu id to identify the affected node and
> > also the reason.
> 
> Ok. I will add CPU ID in message. Because we know the reason, I don't
> think we need the reason in message.

You only know that bit 7 is set, not the rest. As this is an error
message we should provide as much information as possible.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

