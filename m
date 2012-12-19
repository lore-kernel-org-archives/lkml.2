Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2LSXlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:41:09 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:29593
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab2LSXlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:41:06 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MFAXS6-02-4NZ-02
X-M-MSG: 
Date: Wed, 19 Dec 2012 17:40:54 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121219234054.GA6130@jshin-Toonie>
References: <50CCF6F6.4020107@zytor.com>
 <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
 <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
 <20121219225155.GK24895@liondog.tnic>
 <20121219225941.GB2968@jshin-Toonie>
 <20121219230329.GM24895@liondog.tnic>
 <50D24C25.5050604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50D24C25.5050604@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 03:22:13PM -0800, H. Peter Anvin wrote:
> On 12/19/2012 03:03 PM, Borislav Petkov wrote:
> > On Wed, Dec 19, 2012 at 04:59:41PM -0600, Jacob Shin wrote:
> >> I can check but right, they might be used up. But even if we had slots
> >> available, the memory range that needs to be covered is in large
> >> enough address and aligned in such a way that you cannot cover it with
> >> variable range MTRRs.
> > 
> > Actually, if I'm not mistaken, you only need to cover the HT hole with
> > one MTRR - the rest remains WB. And in order the mask bits to work, we
> > could make it a little bigger - we waste some memory but that's nothing
> > in comparison to the MCE.
> > 
> > You might need to talk to hw guys about the feasibility of this deal
> > though.
> > 
> 
> Just make the hole a bit bigger, so it starts at 0xfc00000000, then you
> only need one MTRR.  This is the correct BIOS-level fix, and it really
> needs to happen.
> 
> Do these systems actually exist in the field or are they engineering
> prototypes?  In the latter case, we might be done at that point.

Yes, HP is shipping (or will ship soon) such systems.

> 
> Really, though, AMD should have added a TOM3 for memory above the 1T
> mark since they should have been able to see a 1T hole coming from the
> design of HyperTransport.  This would be the correct hardware-level fix,
> but I don't expect that to happen.
> 

I'll feed this conversation back to our hardware folks, but yes we
still need to handle today's systems.

> Now, calming down a little bit, we are definitely dealing with BIOS
> engineers and so f*ckups are going to happen, again and again.  The
> question is what to do about it.
> 
> The only truly "safe" option is to limit early mappings to 4K pages.
> This is highly undesirable for a bunch of reasons.  Reducing mapping
> granularity to 2M rather than 1G (what Yinghai is proposing) does reduce
> the exposure somewhat; it would be interesting to gather trap statistics
> and try to get a feel for if this actually changes the boot time
> measurably or not.
> 
> The other bit is that building the real kernel page tables iteratively
> (ignoring the early page tables here) is safer, since the real page
> table builder is fully aware of the memory map.  This means any
> "spillover" from the early page tables gets minimized to regions where
> there are data objects that have to be accessed early.  Since Yinghai
> already had iterative page table building working, I don't see any
> reason to not use that capability.

Yes, I'll test again with latest, but Yinghai's patchset mapping only
RAM from top down solved our problem.

Thanks,

> 
> Thoughts?
> 
> 	-hpa
> 
> 

