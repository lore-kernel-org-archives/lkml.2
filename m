Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2LJLY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:24:29 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46252 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab2LJLY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:24:28 -0500
Date: Mon, 10 Dec 2012 11:24:08 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
Message-ID: <20121210112408.GC6988@mudshark.cambridge.arm.com>
References: <1354892111.13000.50.camel@linaro1.home>
 <1354894134.17101.44.camel@gandalf.local.home>
 <20121207162346.GW14363@n2100.arm.linux.org.uk>
 <1354898200.17101.50.camel@gandalf.local.home>
 <20121207164530.GX14363@n2100.arm.linux.org.uk>
 <1354900436.17101.58.camel@gandalf.local.home>
 <20121207181309.GY14363@n2100.arm.linux.org.uk>
 <1354905805.17101.86.camel@gandalf.local.home>
 <20121207190244.GB29618@mudshark.cambridge.arm.com>
 <1355137445.3386.7.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355137445.3386.7.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:04:05AM +0000, Jon Medhurst (Tixy) wrote:
> On Fri, 2012-12-07 at 19:02 +0000, Will Deacon wrote:
> > For ARMv7, there are small subsets of instructions for ARM and Thumb which
> > are guaranteed to be atomic wrt concurrent modification and execution of
> > the instruction stream between different processors:
> > 
> > Thumb:	The 16-bit encodings of the B, NOP, BKPT, and SVC instructions.
> > ARM:	The B, BL, NOP, BKPT, SVC, HVC, and SMC instructions.
> > 
> 
> So this means for things like kprobes which can modify arbitrary kernel
> code we are going to need to continue to always use some form of
> stop_the_whole_system() function?
> 
> Also, kprobes currently uses patch_text() which only uses stop_machine
> for Thumb2 instructions which straddle a word boundary, so this needs
> changing?

Yes; if you're modifying instructions other than those mentioned above, then
you'll need to synchronise the CPUs, update the instructions, perform
cache-maintenance on the writing CPU and then execute an isb on the
executing core (this last bit isn't needed if you're going to go through an
exception return to get back to the new code -- depends on how your
stop/resume code works).

For ftrace we can (hopefully) avoid a lot of this when we have known points
of modification.

Will
