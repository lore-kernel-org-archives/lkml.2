Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1AOP7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:59:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1AOP7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:59:32 -0500
Date: Sat, 15 Jan 2011 16:59:25 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: ia64 broken by transparent huge pages - other arches too?
Message-ID: <20110115155925.GT9506@random.random>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
 <1295076096.4875.60.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295076096.4875.60.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 06:21:36PM +1100, Benjamin Herrenschmidt wrote:
> This is insane. Having such a massively invasive change to the whole mm,
> barely tested on most architecture, and last I heard still generally
> controversial being merged like that without even some integration
> testing via -next makes no sense.

This is 99% a noop for all archs but x86.. Really if you worry about
the testing you should worry about x86 only! Only x86 is affected by
the brainer part of the code, and only if TRANSPARENT_HUGEPAGE=y
(which is set to N by default).

Not x86 archs can't possibly have a regression because of this. The
reason there's this compile trouble is that I cleaned up some bad code
in include/asm-generic/pgtable.h while adding the pmd methods, and I
tried to keep everything as a static inline as requested by Mel for
better gcc compile time validation than what the preprocessor can
do. Otherwise if it was a macro I may not have had to return
anything and I could just BUG() in this pmd method that requires the
__pmd macro to be implemented by all archs (I think it's better off if
__pmd is available considering __pte seems already available).

The below can't introduce regressions, if it builds it'll work, so the
testing on -next for the other archs isn't really necessary at all. I
don't think you can worry about a one liner change to make ia64 build,
when the brainer part of the code is a noop for the other archs
(including x86 when the config option is off).
