Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab1CAKhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 05:37:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59712 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977Ab1CAKhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 05:37:33 -0500
Subject: Re: [PATCH 2/4] msm: scm: Fix improper register assignment
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: David Brown <davidb@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <alpine.LFD.2.00.1102261452340.22034@xanadu.home>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
	 <1298573085-23217-3-git-send-email-sboyd@codeaurora.org>
	 <1298640219.958.74.camel@e102144-lin.cambridge.arm.com>
	 <4D688AF1.1090607@codeaurora.org>
	 <20110226084736.GB3640@n2100.arm.linux.org.uk>
	 <8yazkpi3cfa.fsf@huya.qualcomm.com>
	 <alpine.LFD.2.00.1102261452340.22034@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 10:37:17 +0000
Message-ID: <1298975837.7828.9.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Sat, 2011-02-26 at 20:04 +0000, Nicolas Pitre wrote:
> > The gcc docs say:
> >
> >    * Local register variables in specific registers do not reserve the
> >      registers, except at the point where they are used as input or
> >      output operands in an `asm' statement and the `asm' statement
> >      itself is not deleted.  The compiler's data flow analysis is
> >      capable of determining where the specified registers contain live
> >      values, and where they are available for other uses.  Stores into
> >      local register variables may be deleted when they appear to be
> >      dead according to dataflow analysis.  References to local register
> >      variables may be deleted or moved or simplified.
> >
> > which would suggest that it should at least detect that it can't keep
> > the value in r0.  What it seems to do is detect that the value can't be
> > in the register, so it never bothers putting it there in the first
> > place.

I suspect it sees the function call as a write to r0 and then somehow
infers that the live range of the int r0 variable ends there. Without a
use in the live range it then decides it can optimise away the
definition. It really comes down to whether or not the variable is
characterised by its identifier or the register in which it resides.

> Right.  A minimal test case may look like this if someone feels like
> filling a gcc bug report:
> 
> extern int foo(int x);
> 
> int bar(int x)
> {
>         register int a asm("r0") = 1;
>         x = foo(x);
>         asm ("add %0, %1, %2" : "=r" (x) : "r" (a), "r" (x));
>         return x;
> }
> 
> And the produced code is:
> 
> bar:
>         stmfd   sp!, {r3, lr}
>         bl      foo
> #APP
>         add r0, r0, r0
>         ldmfd   sp!, {r3, pc}
> 
> So this is clearly bogus.
> 

I agree that this is wrong, but the compiler people may try and argue
the other way. I'll ask some of the compiler guys at ARM and see what
they think.

> > In any case, fortunately it works with the fix.
> 
> Please add a comment in your patch to explain the issue.
> 

Perhaps a more robust fix would be to remove the register int
declarations and handle the parameter marshalling in the same asm block
that contains the smc?

Will

