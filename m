Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2IYNXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:23:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab2IYNXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:23:18 -0400
Date: Tue, 25 Sep 2012 14:23:13 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120925132312.GG11266@suse.de>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de>
 <1348500647.11847.69.camel@twins>
 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
 <1348503163.11847.97.camel@twins>
 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
 <1348505683.11847.111.camel@twins>
 <1348508657.11847.114.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1348508657.11847.114.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 07:44:17PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 18:54 +0200, Peter Zijlstra wrote:
> > But let me try and come up with the list thing, I think we've
> > actually got that someplace as well. 
> 
> OK, I'm sure the below can be written better, but my brain is gone for
> the day...
> 

It crashes on boot due to the fact that you created a function-scope variable
called sd_llc in select_idle_sibling() and shadowed the actual sd_llc you
were interested in. Result: dereferenced uninitialised pointer and kaboom.
Trivial to fix so it boots at least.

This is a silly test for a scheduler patch but as "sched: Avoid SMT siblings
in select_idle_sibling() if possible" regressed 2% back in 3.2, it seemed
reasonable to retest with it.

KERNBENCH
                               3.6.0                 3.6.0                 3.6.0
                         rc6-vanilla    rc6-mikebuddy-v1r1  rc6-idlesibling-v1r1
User    min         352.47 (  0.00%)      351.77 (  0.20%)      352.30 (  0.05%)
User    mean        353.10 (  0.00%)      352.78 (  0.09%)      352.77 (  0.09%)
User    stddev        0.41 (  0.00%)        0.56 (-36.13%)        0.35 ( 15.16%)
User    max         353.55 (  0.00%)      353.43 (  0.03%)      353.31 (  0.07%)
System  min          34.86 (  0.00%)       34.83 (  0.09%)       35.37 ( -1.46%)
System  mean         35.35 (  0.00%)       35.29 (  0.16%)       35.63 ( -0.80%)
System  stddev        0.41 (  0.00%)        0.40 (  0.10%)        0.15 ( 62.26%)
System  max          35.94 (  0.00%)       36.05 ( -0.31%)       35.81 (  0.36%)
Elapsed min         110.18 (  0.00%)      109.65 (  0.48%)      110.04 (  0.13%)
Elapsed mean        110.21 (  0.00%)      109.75 (  0.42%)      110.15 (  0.06%)
Elapsed stddev        0.03 (  0.00%)        0.07 (-167.83%)        0.09 (-207.56%)
Elapsed max         110.26 (  0.00%)      109.86 (  0.36%)      110.26 (  0.00%)
CPU     min         352.00 (  0.00%)      353.00 ( -0.28%)      352.00 (  0.00%)
CPU     mean        352.00 (  0.00%)      353.00 ( -0.28%)      352.00 (  0.00%)
CPU     stddev        0.00 (  0.00%)        0.00 (  0.00%)        0.00 (  0.00%)
CPU     max         352.00 (  0.00%)      353.00 ( -0.28%)      352.00 (  0.00%)

mikebuddy-v1r1 is Mike's patch that just got reverted. idlesibling is
Peters patch. "Elapsed mean" time is the main value of interest. Mike's
patch gains 0.42% which is less than the 2% lost but at least the gain is
outside the noise. idlesibling make very little difference. "System mean"
is also interesting because even though idlesibling shows a "regression", it
also shows that the variation between runs is reduced. That might indicate
that fewer cache misses are being incurred in the select_idle_sibling()
code although that is a bit of a leap of faith.

The machine is in use at the moment but I'll queue up a test this evening to
gather a profile to confirm time is even being spent in select_idle_sibling()
Just because 2% was lost in select_idle_sibling() back in 3.2 does not
mean squat now.

-- 
Mel Gorman
SUSE Labs
