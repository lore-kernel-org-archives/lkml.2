Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab1DHQYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:24:52 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37475 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab1DHQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:24:51 -0400
Date: Fri, 8 Apr 2011 09:24:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: advice sought: practicality of SMP cache coherency implemented
 in assembler (and a hardware detect line)
Message-ID: <20110408162446.GC2277@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
 <AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
 <20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
 <20110328180655.GI2287@linux.vnet.ibm.com>
 <AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
 <20110328231818.2297408f@lxorguk.ukuu.org.uk>
 <AANLkTimXztH_4f1=7-Ez6j-7UESroqwBvVuDNW7Fmewb@mail.gmail.com>
 <20110329101630.1f1f0364@lxorguk.ukuu.org.uk>
 <BANLkTinrEKyYhi3ZuQz4KeA+2m6pvU4ddg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinrEKyYhi3ZuQz4KeA+2m6pvU4ddg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 01:09:29PM +0100, Luke Kenneth Casson Leighton wrote:
> alan, paul, will, apologies for not responding sooner, i've just moved
> to near stranraer, in scotland.  och-aye.  the removal lorry has been
> rescued from the mud by an 18 tonne tractor and we have not run over
> any sheep.  yet.
> 
> On Tue, Mar 29, 2011 at 10:16 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >>  hmmm, the question is, therefore: would the MOSIX DSM solution be
> >> preferable, which i presume assumes that memory cannot be shared at
> >> all, to a situation where you *could* at least get cache coherency in
> >> userspace, if you're happy to tolerate a software interrupt handler
> >> flushing the cache line manually?
> >
> > In theory DSM goes further than this. One way to think about DSM is cache
> > coherency in software with a page size granularity. So you could imagine
> > a hypothetical example where the physical MMU of each node and a memory
> > manager layer comnunicating between them implemented a virtualised
> > machine on top which was cache coherent.
> 
> > [...details of M.E.S.I ... ]
> 
>  well... the thing is that there already exists an MMU per core.
> standard page-faults occur, etc. in this instance (i think!), just as
> would occur in any much more standard SIMD architecture (with normal
> hardware-based 1st level cache coherency)
> 
>  hm - does this statement sound reasonable:  this is sort-of a
> second-tier of MMU principles, with a page size granularity of 8 bytes
> (!) with oo 4096 or 8192 such "pages" (32 or 64k or whatever of 1st
> level cache).  thus, the principles you're describing [M.E.S.I] could
> be applied, even at that rather small level of granularity.

If your MMU supports 8-byte pages, this could work.  If you are trying
to leverage the hardware caches, then you really do need hardware cache
coherence.  If there is no hardware cache coherence (which I believe
is the situation you are dealing with), then you need to implement
M.E.S.I. in software.  In this case, the hardware caches are blissfully
unaware of the "invalid" state -- instead, one core takes a page fault,
communicates its need for that page to the core that has it in either
"modified" or "exclusive" state (or to all cores that have it in "shared"
state in the case of a write).  The recipient core(s) flush that page's
memory, mark the page as "invalid" in its/their MMU(s), then respond to
the original core's message.  Once the original core has received all
the acks, it can map the page "shared" (in the case of a read access)
or "modified" (in the case of a write access).

The "exclusive" state can be used if the original core sees that no
other core has that page mapped.

Of course, updates to the shared state tracking what page is in what
state on what core must be updated carefully with appropriate cache
flushing, atomic operations (if available), and memory barriers.

>  or... wait... "invalid" is taken care of at a hardware level, isn't
> it? [this is 1st level cache]

No.  The only situation in which "invalid" is taken care of at the
hardware level (by the 1st level cache) is when the hardware implements
cache coherence, and you have stated that your hardware does not implement
cache coherence.

Now, using the DSM approach that Alan suggested -does- in fact handle
"invalid" in hardware, but it is the MMU rather than the caches that
are doing the handling.

There are a number of DSM projects out there.  The wikipedia article
lists several of them:

	http://en.wikipedia.org/wiki/Distributed_shared_memory

Of course, one of the problems with DSM is that the cache-miss penalties
are quite high.  After all, you must take a page fault, then communicate
to one (perhaps many) other cores, which must update their MMUs, flush
TLBs, and so on.  But then again, that is why hardware cache coherence
exists and why DSM has not taken over the world.

But given the hardware you are expecting to work with, if you want
reliable operation, I don't see much alternative.  And DSM can actually
perform very well, as long as your workload doesn't involve too much
high-frequency data sharing among the cores.

							Thanx, Paul

>  much appreciated the thoughts and discussion so far.
> 
>  l.
