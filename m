Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1AOQrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 11:47:33 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33346 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab1AOQrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 11:47:32 -0500
Subject: Re: ia64 broken by transparent huge pages - other arches too?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
In-Reply-To: <20110115155925.GT9506@random.random>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
	 <1295076096.4875.60.camel@pasglop>  <20110115155925.GT9506@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Jan 2011 10:47:28 -0600
Message-ID: <1295110048.5973.36.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-15 at 16:59 +0100, Andrea Arcangeli wrote:
> On Sat, Jan 15, 2011 at 06:21:36PM +1100, Benjamin Herrenschmidt wrote:
> > This is insane. Having such a massively invasive change to the whole mm,
> > barely tested on most architecture, and last I heard still generally
> > controversial being merged like that without even some integration
> > testing via -next makes no sense.
> 
> This is 99% a noop for all archs but x86.. Really if you worry about
> the testing you should worry about x86 only! Only x86 is affected by
> the brainer part of the code, and only if TRANSPARENT_HUGEPAGE=y
> (which is set to N by default).
> 
> Not x86 archs can't possibly have a regression because of this. The
> reason there's this compile trouble is that I cleaned up some bad code
> in include/asm-generic/pgtable.h while adding the pmd methods, and I
> tried to keep everything as a static inline as requested by Mel for
> better gcc compile time validation than what the preprocessor can
> do. Otherwise if it was a macro I may not have had to return
> anything and I could just BUG() in this pmd method that requires the
> __pmd macro to be implemented by all archs (I think it's better off if
> __pmd is available considering __pte seems already available).
> 
> The below can't introduce regressions, if it builds it'll work, so the
> testing on -next for the other archs isn't really necessary at all. I
> don't think you can worry about a one liner change to make ia64 build,
> when the brainer part of the code is a noop for the other archs
> (including x86 when the config option is off).

Andrea, what you say above isn't true, you're not thinking broadly
enough: the kernel is a complex set of code interactions.  For instance,
you caused this build break on parisc (which is a regression even though
parisc has no transparent huge pages at all):

http://marc.info/?l=linux-arch&m=129504371532124

That was just from a simple code rearrangement (independent of any of
the config options).

One of the points of getting stuff through linux-next is that all of
these problems get sorted out long before the code hits mainline.  This
happens because linux-next gets a wide range of config randomisation
testing plus quite a few different architecture builds and runs.

The problem is very often not in the actual code, but in the side
effects the code causes.  This is what linux-next integration helps
mitigate. So, please use it next time.  Just testing on x86 in your own
configuration isn't sufficient to pick up the problems.

James


