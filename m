Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797Ab2JXNhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2JXNhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:37:47 -0400
Date: Wed, 24 Oct 2012 15:37:30 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: a.p.zijlstra@chello.nl, x86@kernel.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, eranian@google.com, Andi Kleen <ak@linux.intel.com>,
        avi@redhat.com
Subject: Re: [06/34] perf, kvm: Support the intx/intx_cp modifiers in KVM
 arch perfmon emulation v2
Message-ID: <20121024133730.GB29310@redhat.com>
References: <1350602382-12771-7-git-send-email-andi@firstfloor.org>
 <20121023130509.GB3654@redhat.com>
 <20121023132039.GV16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023132039.GV16230@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:20:39PM +0200, Andi Kleen wrote:
> On Tue, Oct 23, 2012 at 03:05:09PM +0200, Gleb Natapov wrote:
> > On Thu, Oct 18, 2012 at 11:19:14PM -0000, Andi Kleen wrote:
> > >  static inline u8 fixed_en_pmi(u64 ctrl, int idx)
> > > @@ -400,7 +407,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
> > >  		} else if ((pmc = get_gp_pmc(pmu, index, MSR_P6_EVNTSEL0))) {
> > >  			if (data == pmc->eventsel)
> > >  				return 0;
> > > -			if (!(data & 0xffffffff00200000ull)) {
> > > +			if (!(data & 0xfffffffc00200000ull)) {
> > >  				reprogram_gp_counter(pmc, data);
> > >  				return 0;
> > >  			}
> > 
> > Mask should depend on cpuid bits provided to a guest. SDM says TSX is
> > available if CPUID.(EAX=7, ECX=0):RTM[bit 11]=1, or  if
> > CPUID.07H.EBX.HLE [bit 4] = 1, so we need to check for this in
> > kvm_pmu_cpuid_update() and initialize mask accordingly.
> 
> I think it will still error out or do nothing.
It will drop TSX related bits without any way for guest to know and count
something else as a result.  It is true that well behaved guest will check
cpuid bits by itself before setting them, but we are trying to emulate
HW as close as possible for the sake of not so well behaved. Some crazy
guest may try to check if those bits are supported by trying to set them
and checking for the #GP for instance. (And I noticed that performance
monitoring application writers tend to not check cpuid even for those
things that can be checked and go by CPU model alone.)

> So I have doubts the explicit check is worth it.
> That should be near enough the hardware.
> 
> BTW does the PMU feature still work? I couldn't get it to work at all
> with the latest kernel, just when I originally wrote it.
> 
Works for me here with 3.6.0. Have you ran qemu with "-cpu host"?

--
			Gleb.
