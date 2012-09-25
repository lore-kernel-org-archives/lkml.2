Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2IYNRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:17:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40495 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab2IYNRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:17:17 -0400
Date: Tue, 25 Sep 2012 15:17:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120925131736.GA30652@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
 <1348503163.11847.97.camel@twins>
 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
 <1348505683.11847.111.camel@twins>
 <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic>
 <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348574286.3881.40.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:58:06PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-09-24 at 19:11 -0700, Linus Torvalds wrote:
> > In the not-so-distant past, we had the intel "Dunnington" Xeon, which
> > was iirc basically three Core 2 duo's bolted together (ie three
> > clusters of two cores sharing L2, and a fully shared L3). So that was
> > a true multi-core with fairly big shared L2, and it really would be
> > sad to not use the second core aggressively. 
> 
> Ah indeed. My Core2Quad didn't have an L3 afaik (its sitting around
> without a PSU atm so checking gets a little hard) so the LLC level was
> the L2 and all worked out right (it also not having SMT helped of
> course).
> 
> But if there was a Xeon chip that did add a package L3 then yes, all
> this would become more interesting still. We'd need to extend the
> scheduler topology a bit as well, I don't think it can currently handle
> this well.
> 
> So I guess we get to do some work for steamroller.

Right, but before that we can still do some experimenting on Bulldozer
- we have the shared 2M L2 there too and it would be nice to improve
select_idle_sibling there.

For example, I did some measurements a couple of days ago on Bulldozer
of tbench with and without select_idle_sibling:

tbench runs single-socket OR-B (box has 8 cores, 4 CUs) (tbench_srv
localhost), tbench default settings as in debian testing

# clients                                                       1       2       4       8       12      16
3.6-rc6+tip/auto-latest                                         115.91  238.571 469.606 1865.77 1863.08 1851.46
3.6-rc6+tip/auto-latest-kill select_idle_sibling():             354.619 534.714 900.069 1969.35 1955.91 1940.84


3.6-rc6+tip/auto-latest
-----------------------
Throughput 115.91 MB/sec   1 clients  1 procs  max_latency=0.296 ms
Throughput 238.571 MB/sec  2 clients  2 procs  max_latency=1.296 ms
Throughput 469.606 MB/sec  4 clients  4 procs  max_latency=0.340 ms
Throughput 1865.77 MB/sec  8 clients  8 procs  max_latency=3.393 ms
Throughput 1863.08 MB/sec  12 clients  12 procs  max_latency=0.322 ms
Throughput 1851.46 MB/sec  16 clients  16 procs  max_latency=2.059 ms

3.6-rc6+tip/auto-latest-kill select_idle_sibling()
--------------------------------------------------
Throughput 354.619 MB/sec  1 clients  1 procs  max_latency=0.321 ms
Throughput 534.714 MB/sec  2 clients  2 procs  max_latency=2.651 ms
Throughput 900.069 MB/sec  4 clients  4 procs  max_latency=10.823 ms
Throughput 1969.35 MB/sec  8 clients  8 procs  max_latency=1.630 ms
Throughput 1955.91 MB/sec  12 clients  12 procs  max_latency=3.236 ms
Throughput 1940.84 MB/sec  16 clients  16 procs  max_latency=0.314 ms

So improving this select_idle_sibling thing wouldn't be such a bad
thing.

Btw, I'll run your patch at http://marc.info/?l=linux-kernel&m=134850571330618
with the same benchmark to see what it brings.

Thanks.

-- 
Regards/Gruss,
Boris.
