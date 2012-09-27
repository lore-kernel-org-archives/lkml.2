Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2I0FSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:18:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45636 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2I0FST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:18:19 -0400
Date: Thu, 27 Sep 2012 07:18:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120927051815.GA1075@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mike Galbraith <efault@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <20120926213723.GA27692@liondog.tnic>
 <1348722568.7059.115.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348722568.7059.115.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 07:09:28AM +0200, Mike Galbraith wrote:
> > The way I understand it is, you either want to share L2 with a process,
> > because, for example, both working sets fit in the L2 and/or there's
> > some sharing which saves you moving everything over the L3. This is
> > where selecting a core on the same L2 is actually a good thing.
> 
> Yeah, and if the wakee can't get to the L2 hot data instantly, it may be
> better to let wakee drag the data to an instantly accessible spot.

Yep, then moving it to another L2 is the same.

[ … ]

> > A crazy thought: one could go and sample tasks while running their
> > timeslices with the perf counters to know exactly what type of workload
> > we're looking at. I.e., do I have a large number of L2 evictions? Yes,
> > then spread them out. No, then select the other core on the L2. And so
> > on.
> 
> Hm.  That sampling better be really cheap.  Might help...

Yeah, that's why I said sampling and not run the perfcounters during
every timeslice.

But if you count the proper events, you should be able to know exactly
what the workload is doing (compute-bound, io-bound, contention, etc...)

> but how does that affect pgbench and ilk that must spread regardless
> of footprints.

Well, how do you measure latency of the 1 process in the 1:N case? Maybe
pipeline stalls of the 1 along with some way to recognize it is the 1 in
the 1:N case.

Hmm.

-- 
Regards/Gruss,
    Boris.
