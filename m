Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1BZUEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 15:04:48 -0500
Received: from relais.videotron.ca ([24.201.245.36]:18203 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1BZUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 15:04:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 26 Feb 2011 15:04:45 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] msm: scm: Fix improper register assignment
In-reply-to: <8yazkpi3cfa.fsf@huya.qualcomm.com>
Message-id: <alpine.LFD.2.00.1102261452340.22034@xanadu.home>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
 <1298573085-23217-3-git-send-email-sboyd@codeaurora.org>
 <1298640219.958.74.camel@e102144-lin.cambridge.arm.com>
 <4D688AF1.1090607@codeaurora.org>
 <20110226084736.GB3640@n2100.arm.linux.org.uk>
 <8yazkpi3cfa.fsf@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Feb 2011, David Brown wrote:

> On Sat, Feb 26 2011, Russell King - ARM Linux wrote:
> 
> > On Fri, Feb 25, 2011 at 09:09:05PM -0800, Saravana Kannan wrote:
> > One way to look at it is that if you specify a value for r0, assign it,
> > and then call a function, how do you expect the r0 value to be preserved?
> > r0 will be corrupted by the called function as its used to pass arg0 and
> > the return value.
> 
> > I'm surprised the compiler didn't spit out an error.

Me too.  The compiler should have moved the content of r0 somewhere else 
before the function call, and restore it back into r0 if necessary 
before the point where the corresponding variable is used again.  Or at 
least issue a warning if it can't do that.

> The gcc docs say:
> 
>    * Local register variables in specific registers do not reserve the
>      registers, except at the point where they are used as input or
>      output operands in an `asm' statement and the `asm' statement
>      itself is not deleted.  The compiler's data flow analysis is
>      capable of determining where the specified registers contain live
>      values, and where they are available for other uses.  Stores into
>      local register variables may be deleted when they appear to be
>      dead according to dataflow analysis.  References to local register
>      variables may be deleted or moved or simplified.
> 
> which would suggest that it should at least detect that it can't keep
> the value in r0.  What it seems to do is detect that the value can't be
> in the register, so it never bothers putting it there in the first
> place.

Right.  A minimal test case may look like this if someone feels like 
filling a gcc bug report:

extern int foo(int x);

int bar(int x)
{
	register int a asm("r0") = 1;
	x = foo(x);
	asm ("add %0, %1, %2" : "=r" (x) : "r" (a), "r" (x));
	return x;
}

And the produced code is:

bar:
        stmfd   sp!, {r3, lr}
        bl      foo
#APP
        add r0, r0, r0
        ldmfd   sp!, {r3, pc}

So this is clearly bogus.

> In any case, fortunately it works with the fix.

Please add a comment in your patch to explain the issue.


Nicolas
