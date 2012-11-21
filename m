Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2KURKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:10:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50740 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2KURKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:10:53 -0500
Date: Wed, 21 Nov 2012 18:10:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
Message-ID: <20121121171047.GA28875@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1211191703270.24618@chino.kir.corp.google.com>
 <20121120060014.GA14065@gmail.com>
 <alpine.DEB.2.00.1211192213420.5498@chino.kir.corp.google.com>
 <20121120074445.GA14539@gmail.com>
 <alpine.DEB.2.00.1211200001420.16449@chino.kir.corp.google.com>
 <20121120090637.GA14873@gmail.com>
 <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Nov 19, 2012 at 11:06 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Oh, finally a clue: you seem to have vsyscall emulation
> > overhead!
> 
> Ingo, stop it already!
> 
> This is *exactly* the kind of "blame everybody else than 
> yourself" behavior that I was talking about earlier.
> 
> There have been an absolute *shitload* of patches to try to 
> make up for the schednuma regressions THAT HAVE ABSOLUTELY 
> NOTHING TO DO WITH SCHEDNUMA, and are all about trying to work 
> around the fact that it regresses. The whole TLB optimization, 
> and now this kind of crap.
> 
> Ingo, look your code in the mirror some day, and ask yourself: 
> why do you think this fixes a "regression"?

Because scalability slowdowns are often non-linear.

So with CONFIG_NUMA_BALANCING=y we are taking a higher page 
fault rate, in exchange for a speedup.

But if some other factor further increases the page fault rate 
(such as vsyscall emulation) then the speedup can be 
non-linearly slower than the cost of the technique - washing it 
out or even turning it into an outright regression.

So, for example:

  - 10K page faults/sec from CONFIG_SCHED_BALANCING: 0.5% cost
  - 10K page faults/sec from vsyscall emu:           0.5% cost

If the two are mixed together the slowdown is non-linear:

  - 10K+10K page faults/sec overhead is not a linear 1%, but 
    might be 3%

So because I did not have an old-glibc system like David's, I 
did not know the actual page fault rate. If it is high enough 
then nonlinear effects might cause such effects.

This is an entirely valid line of inquiry IMO.

Thanks,

	Ingo
