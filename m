Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1GTWsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:48:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1GTWsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:48:08 -0400
Date: Wed, 20 Jul 2011 23:48:01 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
Message-ID: <20110720224801.GP5349@suse.de>
References: <20110718160552.GB5349@suse.de>
 <alpine.DEB.2.00.1107181208050.31576@router.home>
 <20110718211325.GC5349@suse.de>
 <alpine.DEB.2.00.1107181651000.31576@router.home>
 <alpine.DEB.2.00.1107190901120.1199@router.home>
 <alpine.DEB.2.00.1107201307530.1472@router.home>
 <20110720191858.GO5349@suse.de>
 <alpine.DEB.2.00.1107201425200.1472@router.home>
 <alpine.DEB.2.00.1107201443400.1472@router.home>
 <alpine.DEB.2.00.1107201617050.1472@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1107201617050.1472@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 04:17:41PM -0500, Christoph Lameter wrote:
> Hmmm... Maybe we can bypass the checks?
> 

Maybe we should not.

Watermarks should not just be ignored. They prevent the system
deadlocking due to an inability allocate a page needed to free more
memory. This patch allows allocations that are not high priority
or atomic to succeed when the buddy lists are at the min watermark
and would normally be throttled. Minimally, this patch increasing
the risk of the locking up due to memory expiration. For example,
a GFP_ATOMIC allocation can refill the per-cpu list with the pages
then consumed by GFP_KERNEL allocations, next GFP_ATOMIC allocation
refills again, gets consumed etc. It's even worse if it's PF_MEMALLOC
allocations that are refilling the lists as they ignore watermarks.
If this is happening on enough CPUs, it will cause trouble.

At the very least, the performance benefit of such a change should
be illustrated. Even if it's faster (and I'd expect it to be,
watermark checks particularly at low memory are expensive), it may
just mean the system occasionally runs very fast into a wall. Hence,
the patch should be accompanied with tests showing that even under
very high stress for a long period of time that it does not lock up
and the changelog should include a *very* convincing description
on why PF_MEMALLOC refilling the per-cpu lists to be consumed by
low-priority users is not a problem.

-- 
Mel Gorman
SUSE Labs
