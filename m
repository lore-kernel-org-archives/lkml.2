Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2LTAHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:07:37 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:35116
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab2LTAHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:07:30 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MFAZ0A-02-5MQ-02
X-M-MSG: 
Date: Wed, 19 Dec 2012 18:07:23 -0600
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
Message-ID: <20121220000723.GB6130@jshin-Toonie>
References: <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
 <20121219225155.GK24895@liondog.tnic>
 <20121219225941.GB2968@jshin-Toonie>
 <20121219230329.GM24895@liondog.tnic>
 <50D24C25.5050604@zytor.com>
 <20121219234054.GA6130@jshin-Toonie>
 <50D252B6.6050802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50D252B6.6050802@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 03:50:14PM -0800, H. Peter Anvin wrote:
> On 12/19/2012 03:40 PM, Jacob Shin wrote:
> >>
> >>Just make the hole a bit bigger, so it starts at 0xfc00000000, then you
> >>only need one MTRR.  This is the correct BIOS-level fix, and it really
> >>needs to happen.
> >>
> >>Do these systems actually exist in the field or are they engineering
> >>prototypes?  In the latter case, we might be done at that point.
> >
> >Yes, HP is shipping (or will ship soon) such systems.
> >
> 
> Can you get them to fix the BIOS first, or at least ship a BIOS
> update?  Otherwise there will be a probabilistic failure, and it
> sounds like it is your (AMD's) fault.
> 
> >>The other bit is that building the real kernel page tables iteratively
> >>(ignoring the early page tables here) is safer, since the real page
> >>table builder is fully aware of the memory map.  This means any
> >>"spillover" from the early page tables gets minimized to regions where
> >>there are data objects that have to be accessed early.  Since Yinghai
> >>already had iterative page table building working, I don't see any
> >>reason to not use that capability.
> >
> >Yes, I'll test again with latest, but Yinghai's patchset mapping only
> >RAM from top down solved our problem.
> 
> Please don't make me go Steve Ballmer on you.
> 
> We're talking about two different things... the early page tables
> versus the permanent page tables.  The permanent page tables we can
> handle because the page table creation at that point is aware of the
> memory map.

Ah okay,

> 
> The early page tables are what is used before we get to that point.
> Creating them on demand means that if there are no early-needed data
> structures near the hole, there will be no access and everything
> will be okay, but as the early page table creation *is not and
> cannot be* aware of the memory map.  Right now that simply cannot
> happen, because all such data structures are confined to 32-bit
> addresses, however *THAT WILL CHANGE AND WILL CHANGE SOON*, exactly
> because these kinds of large-memory system needs that to happen.
> You may start seeing failures at that time, and there isn't a huge
> lot we can do about it.
> 
> We are trying to discuss mitigation strategies with you, but you
> haven't really given us any useful information, e.g. what happens
> near the various boundaries of the hole, what could trigger
> prefeching into the range, and what it would take to fix the BIOSes.

>From what I remember, accessing memory around the memory hole (not
just the HT hole, but e038000000 ~ 10000000000 on our mentioned system
) generated prefetches because the memory hole was marked as WB in PAT.

I'll take a look at the system again, try the blanket MTRR covering
0xe000000000 ~ 1TB, and talk to our BIOS guys.

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> 

