Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2ACRdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:33:23 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37170 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136Ab2ACRdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:33:20 -0500
Date: Tue, 3 Jan 2012 17:32:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Rob Herring <robherring2@gmail.com>, Yang Bai <hamo.by@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: Fix linux-next compile error in
 arch/arm/common/gic.c
Message-ID: <20120103173254.GB25541@mudshark.cambridge.arm.com>
References: <1325521990-4445-1-git-send-email-joerg.roedel@amd.com>
 <CAO_0yfOzVCK8OGL5G9Aej+V4AZ12EMFKi3HafAX0JzeW9C3FtQ@mail.gmail.com>
 <4F02E377.2050409@arm.com>
 <4F03085F.4060008@gmail.com>
 <4F030B34.1090705@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F030B34.1090705@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 02:05:40PM +0000, Marc Zyngier wrote:
> On 03/01/12 13:53, Rob Herring wrote:
> >>> On Tue, Jan 3, 2012 at 12:33 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> >>>> With CONFIG_SMP=n the following compile error occurs:
> >>>>
> >>>>  CC      arch/arm/common/gic.o
> >>>> arch/arm/common/gic.c: In function 'gic_init_bases':
> >>>> arch/arm/common/gic.c:679:4: error: implicit declaration of function 'cpu_logical_map' [-Werror=implicit-function-declaration]
> >>>> cc1: some warnings being treated as errors

[...]

> > IIRC, part of the problem is asm/smp.h is only included by linux/smp.h
> > for CONFIG_SMP, so this would have to change. Doing that could easily
> > break other arches.
> 
> Ah... good point.

We could probably move smp_setup_processor_id out of smp.c if we need to as
it seems as though you can provide a definition of that function even when
!CONFIG_SMP.

> >>
> >> Well, both patches are wrong. In the UP case (and assuming we're running
> >> on physical CPU 0), offset should be 0.
> >>
> >> The second patch would be my favorite approach, except that
> >> cpu_logical_map(x) should return either "x" or 0. And I'm not sure how
> >> to handle the (unlikely?) case of running a UP kernel on a secondary CPU...
> > 
> > Wouldn't this be the case with 2 AMP instances of Linux running?

In this configuration, I think returning 0 would probably be the right thing
to do. If it's anything else, there's the implication that both of your
kernels are hanging off the same GIC distributor / SCU / L2 Cache etc. and
so you would need a single SMP kernel (or some funky message passing that we
don't yet have).

The bit we're currently missing is the notion of a cluster ID, but both CPU IDs
should be 0 for AMP.

> Yes, or kexec-ing a UP kernel on a secondary CPU. It really looks like
> we ought to make this cpu_logical_map() independent from CONFIG_SMP.

We could always prevent this from happening by hacking kexec / kexec-tools
but I think that booting a UP kernel on a CPU other than 0 is rather silly :)

So I'd be inclined to simply move the existing smp_setup_processor_id
implementation (and the map declaration) into somewhere like kernel/setup.c
and I think things should work.

Will
