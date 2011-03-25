Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1CYQJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:09:04 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:59880 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1CYQJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:09:02 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2cK936eK1432N98dNzz1202hzz8275dhz32i637h668h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIMFIQ-02-HY6-02
X-M-MSG: 
Date: Fri, 25 Mar 2011 17:08:46 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "tee@sgi.com" <tee@sgi.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
Message-ID: <20110325160846.GA12393@erda.amd.com>
References: <20110324173020.GA26761@sgi.com>
 <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop>
 <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop>
 <m2oc50kxg0.fsf@firstfloor.org>
 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
 <20110324235654.GM21838@one.firstfloor.org>
 <20110325092227.GA13640@elte.hu>
 <1301048476.2250.181.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1301048476.2250.181.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.03.11 06:21:16, Peter Zijlstra wrote:
> On Fri, 2011-03-25 at 10:22 +0100, Ingo Molnar wrote:
> > * Andi Kleen <andi@firstfloor.org> wrote:

> > > For the record I don't think it's a good idea for the BIOS to do 
> > > this (and I'm not aware of any engineer who does),  
> > 
> > There's really just two sane options:
> > 
> >  - complain about the BIOS corrupting CPU state and refusing to use the PMU
> >  - complain about the BIOS corrupting CPU state and using the PMU against the BIOS
> > 
> > We went for the first one but i'll be more than glad to implement Linus's much 
> > more aggressive second option.
> > 
> > Btw., for the record, the thing you have been advocating in the past was a 
> > third option: for the kernel to step aside quietly and to let the BIOS corrupt 
> > a counter or two. You even sent us some sort of BIOS specification about how to 
> > implement that. That's pretty much the worst solution imaginable.

Option 2 wont work, I have seen BIOSes that block access to the
counter registers, then there is no way for the OS to take over
control.

So, if you want to use perf anyway on such systems, you will have to
implement option 3 to mark the counter as "reserved" ...


> Also seriously complicated by the kexec case where the previous kernel
> didn't clean up PMU state. There is simply no sane way to detect if its
> actually used and by whoem.
> 
> The whole PMU 'sharing' concept championed by Andi is utter crap.

... but this seems not to be an option.

> 
> As for simply using it despite the BIOS corrupting it, that might not
> always work, the BIOS might simply over-write your state because it
> one-sidedly declares to own the MSRs (observed behaviour).
> 
> Its all a big clusterfuck and really the best way (IMO) is what we have
> now to put pressure on and force the BIOS vendors to play nice.
> 
> I assume both HP and DELL will be seriously unhappy with the kernel
> spewing FIRMWARE BUG messages on boot on their boxen, the question is,
> will they be unhappy enough to fix it..

So, we better stick then with option 1. My experience is that new
system's bioses try not to claim perfctrs (affected systems I have
seen are about 2-3 years old), but I am not really sure here.

> Now Ingo's patch keeps the warning and lets you take the PMU back and
> live with whatever consequences that brings (incorrect counts etc), that
> might also work but puts less pressure on the vendors because things
> appear to work.

And yes, using the counter anyway may corrupt counter values.

-Robert


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

