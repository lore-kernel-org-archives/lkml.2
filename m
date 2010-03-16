Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937546Ab0CPH5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:57:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48168 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937526Ab0CPH5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:57:37 -0400
Date: Tue, 16 Mar 2010 08:57:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>, penberg@cs.helsinki.fi,
       adobriyan@gmail.com
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
Message-ID: <20100316075726.GE18448@elte.hu>
References: <4B990496.4020002@kernel.org>
 <4B9F08AC.9030904@kernel.org>
 <20100316061718.GA22651@elte.hu>
 <4B9F2B0A.70507@kernel.org>
 <4B9F36C7.4020304@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F36C7.4020304@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 03/16/2010 03:54 PM, Tejun Heo wrote:
>
> > Maybe a better way is to grab for slab API usages in .c files which don't 
> > have slab.h inclusion.  If breaking the dependency is the way to go, I can 
> > definitely write up some scripts and do test builds on some archs.  There 
> > sure will be some fallouts but I think it won't be too bad.
> 
> Hmmm... here are some interesting numbers.  Not completely exact but should 
> give the general ballpark idea.
> 
> all .c files					: 13999
> .c files which use any of slab interface	:  5603
> .c files which include slab.h			:  2519
> .c files which include slab.h but don't use it	:   577
> .c files which use slab but don't include it	:  3661
> 
> .c files with k[mzc]alloc/k[z]free usage	:  5291
> .c files with other slab interface usage	:   356
> 
> C files which use k[mzc]alloc/k[z]free covers ~38% of all c files. One 
> possibility is to separate out those into kmalloc.h and make it available 
> universally via kernel.h.

Well, that's the main question: do we want all-in-one big headers like 
kernel.h (and sched.h / mm.h) or not?

If we want to avoid combo .h files then we inevitably want to go for 
finegrained, per subsystem data type and API definitions - i.e. explicit 
slab.h inclusion in the .c file.

I'm leaning towards that solution of avoiding combo .h files - even if in the 
slab.h case the concept causes us to touch quite a few .c files.

As long as it's expected to cause no shock we can do it in one big atomic 
risk-free commit: which just adds the #include slab.h's to the .c files, 
nothing else.

Look at the advantages:

 - (slightly) sped up kbuild

 - it would be immediately obvious in the future which .c file makes use of 
   SLAB facilities. We wouldnt have to guess or go to object file analysis to 
   figure out any 'true' usage.

 - [ it would be trivial in the future to actually _remove_ stale #include
     files. When there's no indirect inclusion of facilities then the lack of 
     usage can be decided based on API usage patterns in the .c files. ]

It's a much cleaner end result IMHO (which also happens to be faster to build) 
- and slab.h is definitely the worst-case, so we should not wimp out just due 
to that difficulty.

Thanks,

	Ingo
