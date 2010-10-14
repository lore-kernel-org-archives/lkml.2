Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0JNPgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:36:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44496 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0JNPgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:36:23 -0400
Date: Thu, 14 Oct 2010 17:36:33 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        akpm <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] bitops.h: Widen BIT macro to support 64-bit types
Message-ID: <20101014153633.GA4261@kryptos.osrc.amd.com>
References: <20101013131057.88238be6.randy.dunlap@oracle.com>
 <20101014042409.GB29342@aftab>
 <20101014105855.GB31247@aftab>
 <AANLkTi=ZjR3bWtZ2x9wRzpzBb1K8Wst3Xg_K4mGX-b6o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ZjR3bWtZ2x9wRzpzBb1K8Wst3Xg_K4mGX-b6o@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, Oct 14, 2010 at 08:03:17AM -0700

> On Thu, Oct 14, 2010 at 3:58 AM, Borislav Petkov <bp@amd64.org> wrote:
> >>
> >> Ok, so BIT() should be fixed to work with the largest type available,
> >> IMHO. Let me cook up something.
> >
> > Maybe something like the following. Build-tested with the crosstool
> > (http://www.kernel.org/pub/tools/crosstool) on the following arches:
> > alpha blackfin cris hppa64 ia64 mips64 sparc.
> >
> > Any objections?
> 
> Yeah. I object. I have no idea what this will change for everything
> else that expects bitops to work on unsigned long values.
> 
> I really think that the bug is not in the BIT() definition, but in the
> use. If somebody wants a non-unsigned-long bit field, they had better
> not use bitops.h.
> 
> And no, just changing the BIT() macro to return a 64-bit value is
> _not_ trivially safe. Due to C type rules, now all arithmetic using
> BIT() will suddenly be 64-bit, which is often *much* slower, and can
> introduce real bugs.
> 
> On many architectures, a 64-bit non-constant shift will even end up
> being a function call. And if the thing is used in a varargs function,
> the argument layout will be totally different. We've also had several
> issues with 64-bit types and switch() statements, for example. And a
> quick grep for '\<BIT(' shows that non-constant cases are not unheard
> of, and there's a lot of random use where it is not at all obvious
> that it's safe (because it's used for defining other defines).

Concerning safety, I actually had a version which did check the bit
number supplied as an arg for overflowing but this failed when using
BIT() in struct initializers:

	.struct_member = { BIT(bla) }

But thanks for the detailed explanation! This makes perfect sense; it
was too much wishful thinking on my part to assume that a ULL BIT()
would be fine after checking that all arches support the unsigned 64-bit
type.

I'm much better off with a local BIT_64() or similar, definition.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
