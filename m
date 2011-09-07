Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1IGQ3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:29:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55415 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1IGQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:29:25 -0400
Date: Wed, 7 Sep 2011 17:28:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: John Ogness <john.ogness@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dave Martin <dave.martin@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: alignment: setup alignment handler earlier
Message-ID: <20110907162857.GB2327@n2100.arm.linux.org.uk>
References: <87ehzstr07.fsf@vostro.fn.ogness.net> <20110907144016.GA30719@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907144016.GA30719@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 03:40:16PM +0100, Catalin Marinas wrote:
> On Wed, Sep 07, 2011 at 02:35:04PM +0100, John Ogness wrote:
> > From 6f3f381800367127dc6430d9b9fa9bd6fc6d8ed0 Mon Sep 17 00:00:00 2001
> > From: John Ogness <john.ogness@linutronix.de>
> > 
> > The alignment exception handler is setup fairly late in
> > the boot process (fs_initcall). However, with newer gcc
> > versions and the compiler option -fconserve-stack, code
> > accessing unaligned data is generated in functions that
> > are called earlier, for example pcpu_dump_alloc_info().
> > This results in unhandled alignment exceptions during
> > boot. By setting up the exception handler sooner, we
> > reduce the window where a compiler may generate code
> > accessing unaligned data.
> 
> While this reduces the window and fixes this particular case, it still
> doesn't solve the problem. We never know when some unaligned access
> would be generated for some earlier code.

Is the problem even solvable?  There are instructions on ARMv6+ which
always produce an alignment fault (eg, ldrd) irrespective of strict
alignment checking.

There will always be a window for those - when we don't have the
vectors setup - where we potentically could take such a fault and end
up crashing.  So I'm not sure that the right answer is what's being
proposed.

What it's saying to me is that building the kernel in a way that gcc
intentionally generates misaligned accesses _will_ bite us in random
unknown ways sooner or later.

I don't think its feasible to build some of the kernel with alignment
faults enabled and other parts with it disabled - that's going to be
very fragile and probably be hell to identify which parts should and
should not.

So I think where we're heading is to need gcc _not_ to create any code
what so ever which would create a misalignment fault.
