Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1DGR2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:28:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58620 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab1DGR2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:28:52 -0400
Date: Thu, 7 Apr 2011 19:28:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Lutomirski <luto@MIT.EDU>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110407172832.GA13304@elte.hu>
References: <cover.1302137785.git.luto@mit.edu>
 <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
 <20110407082550.GG24879@elte.hu>
 <20110407152354.GW21838@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407152354.GW21838@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > So the much better optimization would be to give up on exact GTOD coherency 
> > and just make sure the same task does not see time going backwards. If 
> > user-space wants precise coherency it can use synchronization primitives 
> > itsef. By default it would get the fast and possibly off by a few cycles 
> > thing instead. We'd never be seriously jump in time - only small jumps 
> > would happen in practice, depending on CPU parallelism effects.
> 
> That would be a big user visible break in compatibility.

Those are big scary words, but you really need to think this through:

Firstly, what is the user expectation? That a GTOD timestamp is provided. What 
will the user application do with that timestamp? Store it, for later use.

So there's implicit ordering all around these timestamps.

Secondly, x86 hardware never did a good job keeping our GTOD timestamps 
coherent, so while there *is* expectation for certainl behavior (Andy's for 
example), it's not widespread at all.

I bet that Linus's single-side barrier approach will be good enough in practice 
to meet Andy's needs. We might not be able to remove both barriers, but the 
tricks look really fragile ...

Andy, mind trying out Linus's suggestion? It should bring us more of a speedup 
and it would keep this code even simpler.

Thanks,

	Ingo
