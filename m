Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab1D0Qg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:36:56 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37484 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1D0Qgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:36:55 -0400
Subject: Re: [PATCH] convert parisc to sparsemem (was Re: [PATCH v3] mm:
 make expand_downwards symmetrical to expand_upwards)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1303583657.4116.11.camel@mulgrave.site>
References: <1303337718.2587.51.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104201530430.13948@chino.kir.corp.google.com>
	 <20110421221712.9184.A69D9226@jp.fujitsu.com>
	 <1303403847.4025.11.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104211328000.5741@router.home>
	 <1303411537.9048.3583.camel@nimitz>
	 <1303507985.2590.47.camel@mulgrave.site>
	 <1303583657.4116.11.camel@mulgrave.site>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 27 Apr 2011 09:36:29 -0700
Message-ID: <1303922189.9516.33.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-23 at 13:34 -0500, James Bottomley wrote: 
> This is the preliminary conversion.  It's very nasty on parisc because
> the memory allocation isn't symmetric anymore: under DISCONTIGMEM, we
> push all memory into bootmem and then let free_all_bootmem() do the
> magic for us;

Urg, that's unfortunate.  I bet we could fairly easily teach the bootmem
allocator to allow a couple of bootmem_data's to hang off of an
individual pgdat.  Put each pmem_ranges in one of those instead of a
pgdat.  That would at least help with the bitmap size explosion and
extra loops.

> now we have to do separate initialisations for ranges
> because SPARSEMEM can't do multi-range boot memory. It's also got the
> horrible hack that I only use the first found range for bootmem.  I'm
> not sure if this is correct (it won't be if the first found range can be
> under about 50MB because we'll run out of bootmem during boot) ... we
> might have to sort the ranges and use the larges, but that will involve
> us in even more hackery around the bootmem reservations code.
> 
> The boot sequence got a few seconds slower because now all of the loops
> over our pfn ranges actually have to skip through the holes (which takes
> time for 64GB).

Which iterations were these, btw?  All of the ones I saw the patch touch
seemed to be running over just a single pmem_range.

> All in all, I've not been very impressed with SPARSEMEM over
> DISCONTIGMEM.  It seems to have a lot of rough edges (necessitating
> exception code) which DISCONTIGMEM just copes with.

We definitely need to look at extending it to cover bootmem-time a bit.
Is that even worth it these days with the no-bootmem bits around?

-- Dave


