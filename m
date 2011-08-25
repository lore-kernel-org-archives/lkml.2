Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1HYQ5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:57:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49996 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab1HYQ5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:57:18 -0400
MIME-Version: 1.0
Message-ID: <3aef71a8-d390-4a91-bfef-561c89edc040@default>
Date: Thu, 25 Aug 2011 09:56:38 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Cc: linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: cleancache can lead to serious performance degradation
References: <4E4C395E.20000@gmail.com 20110825041212.GA5014@dumpdata.com>
In-Reply-To: <20110825041212.GA5014@dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E567ED2.00AF:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> I've put Dan on the CC since he is the author of it.

Thanks for forwarding, Konrad (Also thanks akpm for the offlist forward).

Hi Nebojsa --

> > I've tried using cleancache on my file server and came to conclusion
> > that my Core2 Duo 4MB L2 cache 2.33GHz CPU cannot cope with the
> > amount of data it needs to compress during heavy sequential IO when
> > cleancache/zcache are enabled.
> >
> > For an example, with cleancache enabled I get 60-70MB/s from my RAID
> > arrays and both CPU cores are saturated with system (kernel) time.
> > Without cleancache, each RAID gives me more then 300MB/s of useful
> > read throughput.

Hmmm... yes, an older processor with multiple very fast storage devices
could certainly be overstressed by all the compression.

Are your measurements on a real workload or a benchmark?  Can
you describe your configuration more (e.g. number of spindles
-- or SSDs?).  Is any swapping occurring?

In any case, please see below.

> > In the scenario of sequential reading, this drop of throughput seems
> > completely normal:
> > - a lot of data gets pulled in from disks
> > - data is processed in some non CPU-intensive way
> > - page cache fills up quickly and cleancache starts compressing
> > pages (a lot of "puts" in /sys/kernel/mm/cleancache/)
> > - these compressed cleancache pages newer get read because there are
> > a whole lot of new pages coming in every second replacing old ones
> > (practically no "succ_gets" in /sys/kernel/mm/cleancache/)
> > - CPU saturates doing useless compression, and even worse:
> > - new disk read operations are waiting for CPU to finish compression
> > and make some space in memory
> >
> > So, using cleancache in scenarios with a lot of non-random data
> > throughput can lead to very bad performance degradation.

Your analysis is correct IF compression of a page is very slow
and "a lot of data" is *really* a lot.  But...

First, I don't recommend that zcache+cleancache be used without
frontswap, because the additional memory pressure from saving
compressed clean pagecache pages may sometimes result in swapping
(and frontswap will absorb much of the performance loss).  I know
frontswap isn't officially merged yet, but that's an artifact of
the process for submitting a complex patchset (transcendent memory)
that crosses multiple subsystems.  (See https://lwn.net/Articles/454795/ 
if you're not familiar with the whole transcendent memory picture.)

Second, I believe that for any cacheing mechanism -- hardware or
software -- in the history of computing, it is possible to identify
workloads or benchmarks that render the cache counter-productive.
Zcache+cleancache is not immune to that, and benchmarks that are
intended to measure sequential disk read throughput are likely to
imply that zcache is a problem.  However, Phoronix's benchmarking
(see  http://openbenchmarking.org/result/1105276-GR-CLEANCACH02)
didn't show anything like the performance degradation you observed
even though it was also run on a Core 2 Duo, albeit it looks like
with only one spindle.

Third, zcache is relatively new and can certainly benefit from
the input of other developers.  The lzo1x compression in the kernel
is fairly slow; Seth Jennings (cc'ed) is looking into alternate
compression technologies.  Perhaps there is a better compression
choice more suitable for older-slower processors, probably with a
poorer compression ratio.  Further, zcache currently does compression
and decompression with interrupts disabled, which may be a
significant factor in the slowdowns you've observed.  This should
be fixable.  Also the policies to determine acceptance and
reclaim from cleancache are still fairly primitive, but the dynamicity
of cleancache should allow some interesting heuristics to be
explored (as you suggest below).

Fourth, cleancache usually shows a fairly low "hit rate" but still
a solid performance improvement.  I've looked at improving the hit
rate by only moving to cleancache pages that had previously been on
the active list, which would likely solve your problem, but the
patch wasn't really upstreamable and may make cleancache function
less well on other workloads and in other environments (such as
in Xen where the size of transcendent memory may greatly exceed
the size of the guest's pagecache).

> > I guess that possible workaround could be to implement some kind of
> > compression throttling valve for cleancache/zcache:
> >
> > - if there's available CPU time (idle cycles or so), then compress
> > (maybe even with low CPU scheduler priority);

Agreed, and this low-priority kernel thread ideally would also
solve the "compress while irqs disabled" problem!

> > - if there's no available CPU time, just store (or throw away) to
> > avoid IO waits;

Any ideas on how to code this test (for "no available CPU time")?

> > At least, there should be a warning in kernel help about this kind of
> > situations.

That's a good point.  I'll submit a patch updating the Kconfig
and the Documentation/vm/cleancache.txt FAQ to identify the concern.
Documentation for zcache isn't in place yet because frontswap isn't
yet merged and I don't yet want to encourage zcache use without it,
but I'll ensure a warning gets added in zcache someplace also.

If you have any more comments or questions, please cc me directly
as I'm not able to keep up with all the lkml traffic, especially
when traveling... when you posted this I was at Linuxcon 2011
talking about transcendent memory!  See:
http://events.linuxfoundation.org/events/linuxcon/magenheimer 

Dan
