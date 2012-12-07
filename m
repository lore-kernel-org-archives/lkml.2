Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423668Ab2LGTDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:03:16 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61467 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756Ab2LGTDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:03:13 -0500
Date: Fri, 7 Dec 2012 19:02:44 +0000
From: Will Deacon <will.deacon@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
Message-ID: <20121207190244.GB29618@mudshark.cambridge.arm.com>
References: <1354872138.3176.15.camel@computer5.home>
 <1354888985.17101.41.camel@gandalf.local.home>
 <1354892111.13000.50.camel@linaro1.home>
 <1354894134.17101.44.camel@gandalf.local.home>
 <20121207162346.GW14363@n2100.arm.linux.org.uk>
 <1354898200.17101.50.camel@gandalf.local.home>
 <20121207164530.GX14363@n2100.arm.linux.org.uk>
 <1354900436.17101.58.camel@gandalf.local.home>
 <20121207181309.GY14363@n2100.arm.linux.org.uk>
 <1354905805.17101.86.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354905805.17101.86.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Fri, Dec 07, 2012 at 06:43:25PM +0000, Steven Rostedt wrote:
> On Fri, 2012-12-07 at 18:13 +0000, Russell King - ARM Linux wrote:
> > Even changing it to a breakpoint is potentially problematical.  So we'd
> > need to ensure that no other CPU was executing the code while we modify
> > it.
> 
> This is not the same as x86, I guess because x86 has a one byte
> breakpoint. Thus, it is stated in the x86 architecture (I believe,
> Peter, you can correct me if I'm wrong), that the only "safe" thing that
> can modify code, is a software breakpoint.
> 
> Are you saying that thumb does not guarantee even software breakpoints
> from being added atomically? Doesn't that kill the purpose of a
> breakpoint?

For ARMv7, there are small subsets of instructions for ARM and Thumb which
are guaranteed to be atomic wrt concurrent modification and execution of
the instruction stream between different processors:

Thumb:	The 16-bit encodings of the B, NOP, BKPT, and SVC instructions.
ARM:	The B, BL, NOP, BKPT, SVC, HVC, and SMC instructions.

but before your eyes light up at the presence of the BKPT instruction in
that list; we don't actually use that in Linux and instead leave it for
external (i.e. JTAG) debuggers so that they can operate without getting
tangled up with spurious traps from the OS. Linux actually picks its own
undefined instructions, which are obviously not included in the lists above.

Also note that the 16-bit limitation for Thumb instructions above can
actually be used to modify *half* of a BL instruction but, to keep things
exciting, the PC-relative immediate is split across the two halves. However,
you could in theory mess around with bottom 10 bits or so, depending on the
exact encoding...

Obviously this doesn't preclude the need for cache maintenance on both D and
I side, but the atomicity guarantees are as I've described above.

Will
