Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206Ab1ETS2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:28:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934869Ab1ETS2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:28:54 -0400
Date: Fri, 20 May 2011 20:28:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, adobriyan@gmail.com, penberg@kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110520182838.GA12765@elte.hu>
References: <1305292059.1949.0.camel@dan>
 <1305293345.1949.22.camel@dan>
 <20110516153527.GC21107@elte.hu>
 <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu>
 <1305896093.3005.24.camel@dan>
 <20110520131108.GA17699@elte.hu>
 <1305913261.20623.12.camel@dan>
 <BANLkTinCnqrzMyoSzS04fCAqks1bd9Y8=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinCnqrzMyoSzS04fCAqks1bd9Y8=g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> There's a *big* detail that makes it hard: there's only a few bits of 
> randomness we can add to the address. The kernel base address ends up having 
> various fundamental limitations (cacheline alignment for the code, and we 
> have several segments that require page alignment), so you really can't 
> realistically do more than something like 8-12 bits of address randomization.

Yeah, i tried to address this issue in my first mail: basically just a few bits 
would already make a big difference in practice: even a *single* bit of 
randomness makes an exploit crash 50% of the time - at which point the attack 
stops being stealth.

8 bits would be a lot.

So i think this is really realistic, even if a brute force, networked attack 
can successfully attack 1 out of 256, 512 or 1024 boxes. Even for the worm cas 
the networked attack would not scale very well.

> Regardless, the virtual mapping trick (independently of whether it's 
> read-only or not) can be used to avoid exposing the *actual* address of the 
> IDT of the kernel, and would hide the kernel load address details. However, 
> it does make traps slightly slower, if they cannot use the 1:1 mapping with 
> large pages for the IDT access and thus cause more TLB pressure. Of course, 
> in many situations we probably end up not having large pages for the kernel 
> anyway, so..

We could put per CPU IDTs into the percpu area if that improves performance.

This might help on NUMA: on NUMA only one node has the IDT local, the others 
will take a remote DRAM access every time they miss the IDT - and the IDT could 
easily be missed if there are no IRQs or traps for a long time (say CPU-bound 
user-space processing).

There may also be cases where an implicit locked access is generated to the 
IDT?

Thanks,

	Ingo
