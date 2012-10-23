Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2JWC2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:28:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:63596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab2JWC2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:28:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,633,1344236400"; 
   d="scan'208";a="209278882"
Date: Mon, 22 Oct 2012 19:28:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: mtk.manpages@gmail.com, Andi Kleen <andi@firstfloor.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
Message-ID: <20121023022844.GQ2095@tassilo.jf.intel.com>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
 <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
 <20121022132733.GQ16230@one.firstfloor.org>
 <20121022133534.GR16230@one.firstfloor.org>
 <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com>
 <20121022153633.GK2095@tassilo.jf.intel.com>
 <CAKgNAki=AL+KdYDdYnE8ZhjK-tUf5cZ163BWPe6GRM0rpi-z7w@mail.gmail.com>
 <1350956664.2728.19.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350956664.2728.19.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 12:44:24PM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2012-10-22 at 17:53 +0200, Michael Kerrisk (man-pages) wrote:
> 
> > This is all seems to make an awful muck of the API...
> 
>  .../...
> 
> > There seems to be a reasonable argument here for an mmap3() with a
> > 64-bit flags argument...
> 
> I tend to agree. There's a similar issue happening when we try to shovel

Could you comment on the expect range of page sizes on PPC?

I looked at this again and I don't think we have anywhere near true 28 flags
so far.  The man page currently only lists 16 (including MAP_UNUS^INITIALIZED)

So I don't see why I can't have 6 bits from that.

I have no idea why the MAP_UNINITIALIZED flag was put into this strange 
location anyways instead of directly after the existing flags or just
into one of the unused slots. 

I suppose I could put my bits before it, there's plenty of space.

Existing flags on x86:

#define MAP_SHARED      0x01            /* Share changes */
#define MAP_PRIVATE     0x02            /* Changes are private */

4 unused
8 unused

#define MAP_FIXED       0x10            /* Interpret addr exactly */
#define MAP_ANONYMOUS   0x20            /* don't use a file */

0x40 unused

#define MAP_GROWSDOWN   0x0100          /* stack-like segment */

0x200 unused
0x400 unused

#define MAP_DENYWRITE   0x0800          /* ETXTBSY */
#define MAP_EXECUTABLE  0x1000          /* mark it as an executable */
#define MAP_LOCKED      0x2000          /* pages are locked */
#define MAP_NORESERVE   0x4000          /* don't check for reservations */
#define MAP_POPULATE    0x8000          /* populate (prefault) pagetables */
#define MAP_NONBLOCK    0x10000         /* do not block on IO */
#define MAP_STACK       0x20000         /* give out an address that is best suited for process/thread stacks */
#define MAP_HUGETLB     0x40000         /* create a huge page mapping */

/* all free here: 6 bits for me? 0x80000..0x1000000 */

# define MAP_UNINITIALIZED 0x4000000    /* For anonymous mmap, memory could be uninitialized */

/* more free bits. */

Overall it seems there's no real shortage of bits.

> things into protection bits, like we do with SAO (strong access
> ordering) and want to do with per-page endian on embedded.

mprotect already does this.

Unless someone finds a good reason why this can't work I'll just move
the range to 0x80000..0x1000000.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
