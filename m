Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1CNMXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:23:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1CNMXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:23:52 -0400
Date: Mon, 14 Mar 2011 13:23:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        binutils@sourceware.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314122342.GA26825@elte.hu>
References: <20110311165802.GA3508@intel.com>
 <4D7A64670200007800035F4C@vpn.id2.novell.com>
 <AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
 <4D7DE39302000078000362E6@vpn.id2.novell.com>
 <20110314095534.GB18058@elte.hu>
 <20110314104131.GG6275@bubble.grove.modra.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314104131.GG6275@bubble.grove.modra.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Modra <amodra@gmail.com> wrote:

> On Mon, Mar 14, 2011 at 10:55:34AM +0100, Ingo Molnar wrote:
> > The thing is, it is absolutely, breath-takingy incompetent for
> 
> kernel developers to write such poor asm!  And not notice the error
> for 4 years! [...]

It is not 'poor asm'.

The 'bug' is just a slight assymetry in ENTRY()/END() debug-symbols sequences, with 
lots of assembly code between the ENTRY() and the END(). Here's an example:
    
         ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
           ...
         END(do_hypervisor_callback)

Human reviewers almost never catch such small mismatches, and binutils never even 
warned about it either - for over a decade.

Now kernel bisections are insta-broken on latest binutils, and there's nothing to do 
about it on the kernel side as during bisection all later fixes are unfolded. The 
fix itself i already applied - but my argument was not about that:

> [...] Oh, and the binutils developers to write such a poor assembler in the first 
> place.  ;-)
> 
> Seriously, you are complaining because something is fixed??

No, i reported this bug because the kernel build gets broken going back 130,000 
commits, breaking bisection and causing other damage - while issuing a warning 
message would achieve the same effect of warning the developer about the mismatch.

> > The correct solution is to turn it into a warning as me and others have suggested.
> 
> I disagree.  The whole world is not the linux kernel.  I think HJ is
> bending over backwards to even offer a switch that turns the error
> into a warning.

It's not about a switch at all - it's to not break builds by default. I.e. the 
default behavior should be to issue a warning and ignore the directive.

This is a very simple concept of compatibility: the build environment should always 
be very permissive - stuff that build fine before should be allowed to build.

Also, i hope you are not suggesting to break projects just because they are not 
important to you personally? The fix is exceedingly simple to do for the binutils 
project - and impossible to do for the kernel project (because during bisection - 
which is a very powerful debugging tool - older versions of the source get checked 
out).

Thanks,

	Ingo
