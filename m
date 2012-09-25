Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2IYRAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:00:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49331 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2IYRAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:00:39 -0400
Date: Tue, 25 Sep 2012 19:00:58 +0200
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
Message-ID: <20120925170058.GC30158@x1.osrc.amd.com>
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
References: <1348503163.11847.97.camel@twins>
 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
 <1348505683.11847.111.camel@twins>
 <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic>
 <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120925131736.GA30652@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 03:17:36PM +0200, Borislav Petkov wrote:
> For example, I did some measurements a couple of days ago on Bulldozer
> of tbench with and without select_idle_sibling:

Here are updated benchmark results with your patch here:
http://marc.info/?l=linux-kernel&m=134850871822587

I think this pretty much confirms Mel's results.

tbench runs single-socket OR-B  (box has 8 cores, 4 CUs) (tbench_srv localhost), tbench default settings as in debian testing

# clients							1	2	4	8	12	16
3.6-rc6+tip/auto-latest						115.91	238.571	469.606	1865.77	1863.08	1851.46
3.6-rc6+tip/auto-latest-kill select_idle_sibling():		354.619	534.714	900.069	1969.35	1955.91	1940.84
3.6-rc6+tip/auto-latest-revert-the-revert			114.001	223.171	408.507	1771.48	1757.08	1736.12
3.6-rc7+tip/auto-latest-select_idle_sibling-lists		107.39  222.439 435.255 1659.42 1697.43 1685.92

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

3.6-rc6+tip/auto-latest-revert-the-revert
-----------------------------------------
Throughput 114.001 MB/sec  1 clients  1 procs  max_latency=0.352 ms
Throughput 223.171 MB/sec  2 clients  2 procs  max_latency=0.348 ms
Throughput 408.507 MB/sec  4 clients  4 procs  max_latency=0.388 ms
Throughput 1771.48 MB/sec  8 clients  8 procs  max_latency=0.280 ms
Throughput 1757.08 MB/sec  12 clients  12 procs  max_latency=3.280 ms
Throughput 1736.12 MB/sec  16 clients  16 procs  max_latency=0.333 ms

3.6-rc7+tip/auto-latest-select_idle_sibling-lists
-------------------------------------------------
Throughput 107.39 MB/sec  1 clients  1 procs  max_latency=0.372 ms
Throughput 222.439 MB/sec  2 clients  2 procs  max_latency=0.345 ms
Throughput 435.255 MB/sec  4 clients  4 procs  max_latency=0.346 ms
Throughput 1659.42 MB/sec  8 clients  8 procs  max_latency=3.497 ms
Throughput 1697.43 MB/sec  12 clients  12 procs  max_latency=3.205 ms
Throughput 1685.92 MB/sec  16 clients  16 procs  max_latency=0.331 ms

-- 
Regards/Gruss,
Boris.
