Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1IGQwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:52:22 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:40365 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1IGQwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:52:17 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 12:52:16 EDT
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        John Ogness <john.ogness@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: alignment: setup alignment handler earlier
References: <87ehzstr07.fsf@vostro.fn.ogness.net>
	<20110907144016.GA30719@e102109-lin.cambridge.arm.com>
	<20110907162857.GB2327@n2100.arm.linux.org.uk>
Date: Wed, 07 Sep 2011 17:42:19 +0100
In-Reply-To: <20110907162857.GB2327@n2100.arm.linux.org.uk> (Russell King's
	message of "Wed, 7 Sep 2011 17:28:58 +0100")
Message-ID: <yw1xipp4cnis.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Wed, Sep 07, 2011 at 03:40:16PM +0100, Catalin Marinas wrote:
>> On Wed, Sep 07, 2011 at 02:35:04PM +0100, John Ogness wrote:
>> > From 6f3f381800367127dc6430d9b9fa9bd6fc6d8ed0 Mon Sep 17 00:00:00 2001
>> > From: John Ogness <john.ogness@linutronix.de>
>> > 
>> > The alignment exception handler is setup fairly late in
>> > the boot process (fs_initcall). However, with newer gcc
>> > versions and the compiler option -fconserve-stack, code
>> > accessing unaligned data is generated in functions that
>> > are called earlier, for example pcpu_dump_alloc_info().
>> > This results in unhandled alignment exceptions during
>> > boot. By setting up the exception handler sooner, we
>> > reduce the window where a compiler may generate code
>> > accessing unaligned data.
>> 
>> While this reduces the window and fixes this particular case, it still
>> doesn't solve the problem. We never know when some unaligned access
>> would be generated for some earlier code.
>
> Is the problem even solvable?  There are instructions on ARMv6+ which
> always produce an alignment fault (eg, ldrd) irrespective of strict
> alignment checking.

There are such instructions (ldrd, ldm), but gcc will not emit those
unless the address is known to be aligned.  For ARMv6 and later, gcc 4.6
*will* emit potentially unaligned ldr and ldrh since these very clearly
allow an unaligned address and are faster than the alternatives in all
implementations to date.  This is unless strict alignment checking is
explicitly enabled, which unfortunately the Linux kernel does for no
apparent reason at all.

> There will always be a window for those - when we don't have the
> vectors setup - where we potentically could take such a fault and end
> up crashing.  So I'm not sure that the right answer is what's being
> proposed.

The right answer is to not enable strict alignment checking in the first
place.

> What it's saying to me is that building the kernel in a way that gcc
> intentionally generates misaligned accesses _will_ bite us in random
> unknown ways sooner or later.

GCC only generates unaligned accesses using instructions which support
this.

> I don't think its feasible to build some of the kernel with alignment
> faults enabled and other parts with it disabled - that's going to be
> very fragile and probably be hell to identify which parts should and
> should not.

Indeed, so the sane solution must be to not enable strict checking
anywhere.

> So I think where we're heading is to need gcc _not_ to create any code
> what so ever which would create a misalignment fault.

This is already the case provided the alignment requirements are not
artificially tightened.  What we need is to not enable strict alignment
checking in the kernel as is currently done.

-- 
Måns Rullgård
mans@mansr.com
