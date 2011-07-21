Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1GUPYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:24:53 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:40489 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751598Ab1GUPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:24:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4gTz8VgVM1mZyd_onAwKlk.H6isJtH4mmIyYJtY76sZFqEF
 dXb83qK.1teNbPoZYFG051fo_kiCuxgT5S7jw1wydRh.H78zYoR3wDxpNTzp
 xVCkOOhsrD_ZLHQzMMqY61JJND4pO0Nttg1cbTCa8mjTZBpF7huTR2uPTILs
 q5v9URLnluFCKgh9pDQacs297rv1KC2ld2ladhdUbzKfsAE9_doNVliWq8lk
 XHxGzSdLrFL53VZqO0ZRPuduzWXtabNh8TSfk9RO7CnHXgA6NIvXF5gIF_mv
 UzUFZe75DcKU_dQmlFlUfchQcfIE6Sf6o2q5skDNWPJgyndtK_aGSirCzcw0
 0qBdYETdodOUEnbNtjbmaQ51W
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 21 Jul 2011 10:24:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
In-Reply-To: <20110720224801.GP5349@suse.de>
Message-ID: <alpine.DEB.2.00.1107211014210.3995@router.home>
References: <20110718160552.GB5349@suse.de> <alpine.DEB.2.00.1107181208050.31576@router.home> <20110718211325.GC5349@suse.de> <alpine.DEB.2.00.1107181651000.31576@router.home> <alpine.DEB.2.00.1107190901120.1199@router.home> <alpine.DEB.2.00.1107201307530.1472@router.home>
 <20110720191858.GO5349@suse.de> <alpine.DEB.2.00.1107201425200.1472@router.home> <alpine.DEB.2.00.1107201443400.1472@router.home> <alpine.DEB.2.00.1107201617050.1472@router.home> <20110720224801.GP5349@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Mel Gorman wrote:

> On Wed, Jul 20, 2011 at 04:17:41PM -0500, Christoph Lameter wrote:
> > Hmmm... Maybe we can bypass the checks?
> >
>
> Maybe we should not.
>
> Watermarks should not just be ignored. They prevent the system
> deadlocking due to an inability allocate a page needed to free more
> memory. This patch allows allocations that are not high priority
> or atomic to succeed when the buddy lists are at the min watermark
> and would normally be throttled. Minimally, this patch increasing
> the risk of the locking up due to memory expiration. For example,
> a GFP_ATOMIC allocation can refill the per-cpu list with the pages
> then consumed by GFP_KERNEL allocations, next GFP_ATOMIC allocation
> refills again, gets consumed etc. It's even worse if it's PF_MEMALLOC
> allocations that are refilling the lists as they ignore watermarks.
> If this is happening on enough CPUs, it will cause trouble.

Hmmm... True. This allocation complexity prevents effective use of caches.

> At the very least, the performance benefit of such a change should
> be illustrated. Even if it's faster (and I'd expect it to be,
> watermark checks particularly at low memory are expensive), it may
> just mean the system occasionally runs very fast into a wall. Hence,
> the patch should be accompanied with tests showing that even under
> very high stress for a long period of time that it does not lock up
> and the changelog should include a *very* convincing description
> on why PF_MEMALLOC refilling the per-cpu lists to be consumed by
> low-priority users is not a problem.

The performance of the page allocator is extremely bad at this point and
it is so because of all these checks in the critical paths. There have
been numerous ways that subsystems worked around this in the past and I
would think that there is no question that removing expensive checks from
the fastpath improves performance.

Maybe the only solution is to build a consistent second layer of
caching around the page allocator that is usable by various subsystems?

SLAB has in the past provided such a caching layer. The problem is that
people are trying to build similar complexity into the fast path of those
allocators as well now (f.e. the NFS swap patch with its ways of reserving
objects to fix the issue of objects being taken for the wrong reasons that
you mentioned above). We need some solution that allows the implementation of
fast object allocation and that means reducing the complexity of what is
going on during page alloc and free.


