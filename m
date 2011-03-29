Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1C2QCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:02:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51943 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1C2QCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:02:19 -0400
Date: Tue, 29 Mar 2011 18:02:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/30] amd64_edac: Cleanup chipselect handling
Message-ID: <20110329160211.GC22419@aftab>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
 <1297358133-14320-6-git-send-email-bp@amd64.org>
 <4D91F31A.7040600@redhat.com>
 <20110329151643.GA22419@aftab>
 <4D91FD1D.4070508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D91FD1D.4070508@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 11:39:09AM -0400, Mauro Carvalho Chehab wrote:
> >>> + * Create a contiguous bitmask starting at bit position @lo and ending at
> >>> + * position @hi. For example
> >>> + *
> >>> + * GENMASK(21, 39) gives us the 64bit vector 0x000000ffffe00000.
> >>> + */
> >>> +#define GENMASK(lo, hi)			(((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))
> >>> +
> >>
> >> This is a nice macro that could be useful outside amd64. It is probably a good
> >> idea to move it to include/linux/bitops.h.
> > 
> > I'd suggest rather <drivers/edac/edac_core.h> if you want to use it in
> > EDAC. But if we have more users, I don't have a problem with putting
> > it there (or somewhere else generic enough if people have a better
> > suggestion).
> 
> Yeah, other edac drivers could benefit of using it, and also could benefit on a
> variant that would do an AND operation and shift it, something like (untested):
> 
> /*
>  * Create a contiguous bitmask starting at bit position @lo and ending at
>  * position @hi. For example
>  *
>  * APPLY_BITMASK(v, 21, 39) will return the result of:
>  * 	(v & 0x000000ffffe00000) >> 21
>  */
> #define APPLY_BITMASK(v, lo, hi)	(((v) & ((1ULL << ((hi) - (lo) + 1)) - 1) << (lo)) >> (lo))

The macro definition doesn't match the comment. In the comment you do a bitwise
AND first and shift the result then. The way you've written it, it does

	((v & 0x000000000007ffff << 21) >> 21)

you need to fixup the brackets:

#define APPLY_BITMASK(v, lo, hi)	(((v) & (((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))) >> (lo))

Also, this doesn't only apply it but shifts too, so it should be

#define APPLY_BITMASK_AND_SHIFT(...)

But this macro gets too special to put it in shared code.

> Almost all edac drivers do something like the above, for example, to get DIMM rows/cols/banks, etc.
> 
> Probably, the most complex part is to find a nice name for it ;)
> 
> Yet, I think non-edac drivers could also benefit of such macro, and, as this is not
> edac-specific, I think it would be better to add it at bitops.h.

No, this should go into generic code only if it has users - "it might
benefit" is not strong-enough an argument for polluting generic code.
I'd leave it in edac_core.h and push it somewhere more generic only when
I need it in other subsystems.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
