Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2IEIrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:47:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55421 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2IEIre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:47:34 -0400
Message-ID: <1346834836.2600.3.camel@twins>
Subject: Re: [PATCH] perf/x86: Disable uncore on virtualized CPU.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, avi@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 05 Sep 2012 10:47:16 +0200
In-Reply-To: <20120905063524.GA20710@gmail.com>
References: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
	 <20120905063524.GA20710@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 08:35 +0200, Ingo Molnar wrote:
> * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> 
> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> > 
> > Initializing uncore PMU on virtualized CPU may hang the kernel.
> > This is because kvm does not emulate the entire hardware. Thers
> > are lots of uncore related MSRs, making kvm enumerate them all
> > is a non-trival task. So just disable uncore on virtualized CPU.
> > 
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > index 0a55710..2f005ba 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > @@ -2898,6 +2898,9 @@ static int __init intel_uncore_init(void)
> >  	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> >  		return -ENODEV;
> >  
> > +	if (cpu_has_hypervisor)
> > +		return -ENODEV;
> > +
> >  	ret = uncore_pci_init();
> >  	if (ret)
> >  		goto fail;
> 
> Cannot the presence of the uncore hardware be detected in a 
> cleaner fashion, via the PCI config space and such?

No, part of the uncore PMUs are in MSR space and aren't discoverable.
CPUID model checks + hard assumptions of presence are all that we are
left with.

Now Avi suggested we teach KVM about these MSRs and then modify the
uncore driver to test if the MSRs actually work -- as in retain values
written to them and aren't always 0.

That's a larger patch though, partly because enumerating the gazillion
MSRs consumed by the various uncore PMUs is a tedious job, and we can
always do this later.

This patch is a minimal patch to at least make things 'work' for now.

