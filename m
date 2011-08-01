Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1HAFId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:08:33 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:55860 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1HAFI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:08:29 -0400
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1107290145080.3279@tiger>
	 <alpine.DEB.2.00.1107291002570.16178@router.home>
	 <alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com>
	 <1312145146.24862.97.camel@jaguar>
	 <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 01 Aug 2011 08:08:26 +0300
Message-ID: <1312175306.24862.103.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 14:55 -0700, David Rientjes wrote:
> On Sun, 31 Jul 2011, Pekka Enberg wrote:
> 
> > > And although slub is definitely heading in the right direction regarding 
> > > the netperf benchmark, it's still a non-starter for anybody using large 
> > > NUMA machines for networking performance.  On my 16-core, 4 node, 64GB 
> > > client/server machines running netperf TCP_RR with various thread counts 
> > > for 60 seconds each on 3.0:
> > > 
> > > 	threads		SLUB		SLAB		diff
> > > 	 16		76345		74973		- 1.8%
> > > 	 32		116380		116272		- 0.1%
> > > 	 48		150509		153703		+ 2.1%
> > > 	 64		187984		189750		+ 0.9%
> > > 	 80		216853		224471		+ 3.5%
> > > 	 96		236640		249184		+ 5.3%
> > > 	112		256540		275464		+ 7.4%
> > > 	128		273027		296014		+ 8.4%
> > > 	144		281441		314791		+11.8%
> > > 	160		287225		326941		+13.8%
> > 
> > That looks like a pretty nasty scaling issue. David, would it be
> > possible to see 'perf report' for the 160 case? [ Maybe even 'perf
> > annotate' for the interesting SLUB functions. ] 
> 
> More interesting than the perf report (which just shows kfree, 
> kmem_cache_free, kmem_cache_alloc dominating) is the statistics that are 
> exported by slub itself, it shows the "slab thrashing" issue that I 
> described several times over the past few years.  It's difficult to 
> address because it's a result of slub's design.  From the client side of 
> 160 netperf TCP_RR threads for 60 seconds:
> 
> 	cache		alloc_fastpath		alloc_slowpath
> 	kmalloc-256	10937512 (62.8%)	6490753
> 	kmalloc-1024	17121172 (98.3%)	303547
> 	kmalloc-4096	5526281			11910454 (68.3%)
> 
> 	cache		free_fastpath		free_slowpath
> 	kmalloc-256	15469			17412798 (99.9%)
> 	kmalloc-1024	11604742 (66.6%)	5819973
> 	kmalloc-4096	14848			17421902 (99.9%)
> 
> With those stats, there's no way that slub will even be able to compete 
> with slab because it's not optimized for the slowpath.

Is the slowpath being hit more often with 160 vs 16 threads? As I said,
the problem you mentioned looks like a *scaling issue* to me which is
actually somewhat surprising. I knew that the slowpaths were slow but I
haven't seen this sort of data before.

I snipped the 'SLUB can never compete with SLAB' part because I'm
frankly more interested in raw data I can analyse myself. I'm hoping to
the per-CPU partial list patch queued for v3.2 soon and I'd be
interested to know how much I can expect that to help.

			Pekka

