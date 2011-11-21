Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1KUB3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 20:29:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:34967 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1KUB3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 20:29:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78219522"
Subject: Re: [RFC]numa: improve I/O performance by optimizing numa
 interleave allocation
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>,
        "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>
In-Reply-To: <20111118173013.GB25022@alboin.amr.corp.intel.com>
References: <1321600332.22361.309.camel@sli10-conroe>
	 <20111118173013.GB25022@alboin.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 09:39:45 +0800
Message-ID: <1321839585.22361.328.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-19 at 01:30 +0800, Andi Kleen wrote:
> On Fri, Nov 18, 2011 at 03:12:12PM +0800, Shaohua Li wrote:
> > If mem plicy is interleaves, we will allocated pages from nodes in a round
> > robin way. This surely can do interleave fairly, but not optimal.
> > 
> > Say the pages will be used for I/O later. Interleave allocation for two pages
> > are allocated from two nodes, so the pages are not physically continuous. Later
> > each page needs one segment for DMA scatter-gathering. But maxium hardware
> > segment number is limited. The non-continuous pages will use up maxium
> > hardware segment number soon and we can't merge I/O to bigger DMA. Allocating
> > pages from one node hasn't such issue. The memory allocator pcp list makes
> > we can get physically continuous pages in several alloc quite likely.
> 
> FWIW it depends a lot on the IO hardware if the SG limitation
> really makes a measurable difference for IO performance. I saw some wins from 
> clustering using the IOMMU before, but that was a long time ago. I wouldn't 
> consider it a truth without strong numbers, and then also only
> for that particular device measured.
> 
> My understanding is that modern IO devices like NHM Express will
> be faster at large SG lists.
This is a LSI SAS1068E HBA card attaching some hard disks. The
clustering has real benefit here. I/O throughput increases 3% or so.
Not sure about NHM Express, wondering why large SG list could be faster.
doesn't large SG means large DMA descriptor?

> > So can we make both interleave fairness and continuous allocation happy?
> > Simplily we can adjust the round robin algorithm. We switch to another node
> > after several (N) allocation happens. If N isn't too big, we can still get
> > fair allocation. And we get N continuous pages. I use N=8 in below patch.
> > I thought 8 isn't too big for modern NUMA machine. Applications which use
> > interleave are unlikely run short time, so I thought fairness still works.
> 
> It depends a lot on the CPU access pattern.
> 
> Some workloads seem to do reasonable well with 2MB huge page interleaving.
> But others actually prefer the cache line interleaving supplied by 
> the BIOS.
> 
> So you can have a trade off between IO and CPU performance.
> When in doubt I usually opt for CPU performance by default.
Can you elaborate this more? the cache line interleaving can only be
supplied by BIOS. OS can provide N*PAGE_SIZE interleave. I'm wondering
what's the difference for example a 4k or 8k interleave for CPU
performance. Actually if adjacent pages interleaved in two nodes could
be in the same coloring, while two adjacent pages allocated from one
node not. So clustering could be more cache efficient from coloring
point of view.

> I definitely wouldn't make it default, but if there are workloads
> that benefits a lot it could be an additional parameter to the
> interleave policy.
Christoph suggested the same way. the problem is we need change the API,
right? And how are users supposed to use it? It would be difficult to
determine the correct parameter.

If 8 pages clustering is too big, maybe we can use small. I guess a 2
pages clustering is a big win too.

And I didn't change the allocation with a VMA case, which is supposed to
be used for anonymous pages.

Thanks,
Shaohua

