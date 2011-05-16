Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1EPGwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:52:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1EPGwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:52:39 -0400
Date: Mon, 16 May 2011 08:52:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>,
        x86@kernel.org, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: Possible sandybridge livelock issue
Message-ID: <20110516065220.GB24836@elte.hu>
References: <1305303156.2611.51.camel@mulgrave.site>
 <m262pezhfe.fsf@firstfloor.org>
 <alpine.DEB.2.00.1105131207020.24193@router.home>
 <m21v02zch9.fsf@firstfloor.org>
 <1305312552.2611.66.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305312552.2611.66.camel@mulgrave.site>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > Can you figure out better what the kswapd is doing?
> 
> We have ... it was the thread in the first email.  We don't need a fix for 
> the kswapd issue, what we're warning about is a potential sandybridge 
> problem.
> 
> The facts are that only sandybridge systems livelocked in the kswapd problem 
> ... no other systems could reproduce it, although they did see heavy CPU time 
> accumulate to kswapd.  And this is with a gang of mm people trying to 
> reproduce the problem on non-sandybridge systems.
> 
> On the sandybridge systems that livelocked, it was sometimes possible to 
> release the lock by pushing kswapd off the cpu it was hogging.

It's not uncommon at all to see certain races (or even livelocks) only with the 
latest and greatest CPUs.

I have a first-gen CPU system that when i got it a couple of years ago 
triggered like a dozen Linux kernel races and bugs possible theoretically on 
all other CPUs but not reported on any other Linux system up to that point, 
*ever* - and some of those bugs were many years old.

> If you think the theory about why this happend to be wrong, fine ... come up 
> with another one.  The facts are as above and only sandybridge systems seem 
> to be affected.

I can see at least four other plausible hypotheses, all matching the facts as 
you laid them out:

 - i could be a bug/race in the kswapd code.

 - it could be that the race window needs a certain level of instruction 
   parallelism - which occurs with a higher likelyhood on Sandybridge.

 - it could be that Sandybridge CPUs keep dirty cachelines owned a bit longer 
   than other CPUs, making an existing livelock bug in the kernel code easier 
   to trigger.

 - a hardware bug: if cacheline ownership is not arbitrated between 
   nodes/cpus/cores fairly (enough) and a specific CPU can monopolize a 
   cacheline for a very long time if only it keeps modifying it in an 
   aggressive enough kswapd loop.

Note, since each of these hypotheses has a specific non-zero chance of being 
the objective truth, your hypothesis might in the end turn out to be the right 
one and might turn into a proven scientific theory: CPU and scheduler bugs do 
happen after all.

The other hypotheses i outlined have non-zero chances as well: kswapd bugs do 
happen as well and various CPU timing differences do tend to occur as well.

But above you seem to be confused about how supporting facts and hypotheses 
relate to each other: you seemed to imply that because your facts support your 
hypothesis the ball is somehow on the other side. As things stand now we 
clearly need more facts, to exclude more of the many possibilities.

So i wanted to clear up these basics of science first, before any of us wastes 
too much time on writing mails and such. Oh ... never mind ;-)

Thanks,

	Ingo
