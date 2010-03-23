Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0CWNPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:15:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:45003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0CWNPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:15:14 -0400
Date: Tue, 23 Mar 2010 10:15:00 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
	host side
Message-ID: <20100323131500.GD4066@ghostprotocols.net>
References: <1268717232.2813.36.camel@localhost> <1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu> <1269242687.2078.25.camel@ymzhang.sh.intel.com> <20100322164437.GB4066@ghostprotocols.net> <1269314081.2078.63.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269314081.2078.63.camel@ymzhang.sh.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 23, 2010 at 11:14:41AM +0800, Zhang, Yanmin escreveu:
> On Mon, 2010-03-22 at 13:44 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Mar 22, 2010 at 03:24:47PM +0800, Zhang, Yanmin escreveu:
> > > On Fri, 2010-03-19 at 09:21 +0100, Ingo Molnar wrote:
> > > Then, perf could access all files. It's possible because guest os instance
> > > happens to be multi-threading in a process. One of the defects is the accessing to
> > > guest os becomes slow or impossible when guest os is very busy.
> > 
> > If the MMAP events on the guest included a cookie that could later be
> > used to query for the symtab of that DSO, we wouldn't need to access the
> > guest FS at all, right?

> It depends on specific sub commands. As for 'perf kvm top', developers
> want to see the profiling immediately. Even with 'perf kvm record',
> developers also want to

That is not a problem, if you have the relevant buildids in your cache
(Look in your machine at ~/.debug/), it will be as fast as ever.

If you use a distro that has its userspace with build-ids, you probably
use it always without noticing :-)

> see results quickly. At least I'm eager for the results when
> investigating a performance issue.

Sure thing.
 
> > With build-ids and debuginfo-install like tools the symbol
> > resolution could be performed by using the cookies (build-ids) as
> > keys to get to the *-debuginfo packages with matching symtabs (and
> > DWARF for source annotation, etc).

> We can't make sure guest os uses the same os images, or don't know
> where we could find the original DVD images being used to install
> guest os.

You don't have to have guest and host sharing the same OS image, you
just have to somehow populate your buildid cache with what you need, be
it using sshfs or what Ingo is suggesting once, or using what your
vendor provides (debuginfo packages). And you just have to do it once,
for the relevant apps, to have it in your buildid cache.
 
> Current perf does save build id, including both kernls's and other
> application lib/executables.

Yeah, I know, I implemented it. :-)
 
> > We have that for the kernel as:

> > [acme@doppio linux-2.6-tip]$ l /sys/kernel/notes 
> > -r--r--r-- 1 root root 36 2010-03-22 13:14 /sys/kernel/notes
> > [acme@doppio linux-2.6-tip]$ l /sys/module/ipv6/sections/.note.gnu.build-id 
> > -r--r--r-- 1 root root 4096 2010-03-22 13:38 /sys/module/ipv6/sections/.note.gnu.build-id
> > [acme@doppio linux-2.6-tip]$

> > That way we would cover DSOs being reinstalled in long running 'perf
> > record' sessions too.

> That's one of objectives of perf to support long running.

But it doesn't fully supports right now, as I explained, build-ids are
collected at the end of the record session, because we have to open the
DSOs that had hits to get the 20 bytes cookie we need, the build-id.

If we had it in the PERF_RECORD_MMAP record, we would close this race,
and the added cost at load time should be minimal, to get the ELF
section with it and put it somewhere in task struct.

If only we could coalesce it a bit to reclaim this:

[acme@doppio linux-2.6-tip]$ pahole -C task_struct ../build/v2.6.34-rc1-tip+/kernel/sched.o  | tail -5
	/* size: 5968, cachelines: 94, members: 150 */
	/* sum members: 5943, holes: 7, sum holes: 25 */
	/* bit holes: 1, sum bit holes: 28 bits */
	/* last cacheline: 16 bytes */
};
[acme@doppio linux-2.6-tip]$ 

8-)

Or at least get just one of those 4 bytes holes then we could stick it
at the end to get our build-id there, accessing it would be done only
at PERF_RECORD_MMAP injection time, i.e. close to the time when we
actually are loading the executable mmap, i.e. close to the time when
the loader is injecting the build-id, I guess the extra memory and
processing costs would be in the noise.

> > This was discussed some time ago but would require help from the bits
> > that load DSOs.

> > build-ids then would be first class citizens.

- Arnaldo
