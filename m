Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1G0HAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 03:00:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1G0HAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 03:00:22 -0400
Date: Wed, 27 Jul 2011 08:59:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Avi Kivity <avi@redhat.com>, "Przywara, Andre" <Andre.Przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110727065932.GA16555@elte.hu>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <4E2F0068.1080001@redhat.com>
 <20110726181304.GD32536@aftab>
 <4E2F0498.8050005@zytor.com>
 <20110726183721.GF32536@aftab>
 <4E2F09BB.9060605@zytor.com>
 <4E2F1889.8030708@amd.com>
 <4E2F90A2.4030409@redhat.com>
 <20110727062120.GA5272@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727062120.GA5272@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Wed, Jul 27, 2011 at 12:14:26AM -0400, Avi Kivity wrote:
> > On 07/26/2011 10:42 PM, Andre Przywara wrote:
> > >
> > > There is no need to determine it by calculating, because it caused by 
> > > the special design of the BD L1 cache and thus fixed.
> > > And a calculation would be even more confusing:
> > >
> > > The L1I is virtually indexed, but physically tagged.
> > > 64KB L1I cache, 64 Bytes per Cacheline = 1024 cache lines
> > > 1024 lines / 2 way associative = 512 indexes
> > > 64 Bytes per Cacheline (6 bits) + 512 indexes (9 bits) = bits [14:0]
> > > virtual and physical addresses are the same for bits [11:0], which 
> > > leaves the remaining 14:12 susceptible for aliasing.
> > >
> > > So bit 12 comes from PAGESIZE and yes, the 14 could be derived from 
> > > the CPUID cache info, but I don't see much value in breaking this down 
> > > this way.
> > > But I agree that there should be some comment in the patch which at 
> > > least notes that bits [14:12] are due to the L1I design, maybe we can 
> > > copy a nicer version of the above math in the commit message for 
> > > reference.
> > >
> > 
> > If among the 12,432.8 cpuid leaves exposed by the cpu we had a bit that 
> > said L1I was shared, and another that said it was virtually indexed, and 
> > others describing the cache size, cache line size, and number of ways, 
> > then we could perform the arithmetic at runtime, yes?
> > 
> > That means that if the caches grow or increase their associativity, then 
> > we don't need to patch the kernel again.
> 
> Yeah, actually the idea is to patch the kernel only this one time 
> and never ever be needing to do this for future CPUs, for this 
> matter.

But the check you have added turns this workaround on for all family 
0x15 CPUs. If a family 0x15 CPU is built with a larger or more 
associative cache, one that does not need the workaround, we would 
still turn on the workaround.

Or is it impossible that family 0x15 CPUs will ever be fixed?

Thanks,

	Ingo
