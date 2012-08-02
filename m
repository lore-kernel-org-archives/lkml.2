Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab2HBPCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 11:02:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:54740 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab2HBPC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:02:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192495593"
Date: Thu, 2 Aug 2012 23:02:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-alpha@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Tony Luck <tony.luck@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        John David Anglin <dave.anglin@bell.net>, Mel Gorman <mgorman@suse.de>,
        kernel-janitors@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [next:akpm 129/309] net/core/sock.c:274:36: error: initializer
 element is not constant
Message-ID: <20120802150209.GA26601@localhost>
References: <20120722163058.GB13376@localhost>
 <20120723111619.GT9222@suse.de>
 <1343042420.3027.11.camel@dabdike.int.hansenpartnership.com>
 <20120723114258.GV9222@suse.de>
 <20120723122905.GA22476@localhost>
 <BLU0-SMTP2254F8872DDE5FA6035CDE97DD0@phx.gbl>
 <20120724074844.GA9519@localhost>
 <BLU0-SMTP6C7CFCFF734FE10A39B6E97DC0@phx.gbl>
 <1343193053.3139.6.camel@dabdike>
 <CA+8MBbJkGN+zGBdD5Hg26wW_6E9L_ufoutn7wj+Y+nhtW7WKWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbJkGN+zGBdD5Hg26wW_6E9L_ufoutn7wj+Y+nhtW7WKWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 10:06:41AM -0700, Tony Luck wrote:
> On Tue, Jul 24, 2012 at 10:10 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >> Here is the line in sock.i:
> >>
> >> struct static_key memalloc_socks = ((struct static_key) { .enabled =
> >> ((atomic_t) { (0) }) });
> >
> > The above line contains two compound literals.  It also uses a designated
> > initializer to initialize the field enabled.  A compound literal is not a
> > constant expression.
> 
> Seeing the same thing on ia64 building next-20120726.  Same fix works
> for me ... so I'll steal this whole changelog and attributes.

I got the same error for alpha, the same fix applies.
---
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH] [ALPHA] Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

The following build error occurred during an alpha build:

net/core/sock.c:274:36: error: initializer element is not constant

Dave Anglin says:
> Here is the line in sock.i:
>
> struct static_key memalloc_socks = ((struct static_key) { .enabled =
> ((atomic_t) { (0) }) });

The above line contains two compound literals.  It also uses a designated
initializer to initialize the field enabled.  A compound literal is not a
constant expression.

The location of the above statement isn't fully clear, but if a compound
literal occurs outside the body of a function, the initializer list must
consist of constant expressions.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
---
 arch/alpha/include/asm/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/arch/alpha/include/asm/atomic.h	2012-05-24 19:03:06.000000000 +0800
+++ linux/arch/alpha/include/asm/atomic.h	2012-08-02 23:01:02.243224220 +0800
@@ -14,8 +14,8 @@
  */
 
 
-#define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
-#define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
+#define ATOMIC_INIT(i)		( { (i) } )
+#define ATOMIC64_INIT(i)	( { (i) } )
 
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic64_read(v)	(*(volatile long *)&(v)->counter)
