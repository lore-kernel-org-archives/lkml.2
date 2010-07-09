Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab0GIAqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:46:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35138 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab0GIAqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:46:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH v2 2/2] vmscan: shrink_slab() require number of lru_pages, not page order
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.2.00.1007081540400.15083@router.home>
References: <20100708133152.5e556508.akpm@linux-foundation.org> <alpine.DEB.2.00.1007081540400.15083@router.home>
Message-Id: <20100709092124.CD5A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Jul 2010 09:46:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Jul 2010, Andrew Morton wrote:
> 
> > > AFAICT this is not argument error but someone changed the naming of the
> > > parameter.
> >
> > It's been there since day zero:
> >
> > : commit 2a16e3f4b0c408b9e50297d2ec27e295d490267a
> > : Author:     Christoph Lameter <clameter@engr.sgi.com>
> > : AuthorDate: Wed Feb 1 03:05:35 2006 -0800
> > : Commit:     Linus Torvalds <torvalds@g5.osdl.org>
> > : CommitDate: Wed Feb 1 08:53:16 2006 -0800
> > :
> > :     [PATCH] Reclaim slab during zone reclaim
> 
> That only shows that the order parameter was passed to shrink_slab() which
> is what I remember being done intentionally.
> 
> Vaguely recall that this was necessary to avoid shrink_slab() throwing out
> too many pages for higher order allocs.

But It make opposite effect. number of scanning objects of shrink_slab() are

                          lru_scanned        max_pass
basic_scan_objects = 4 x -------------  x -----------------------------
                          lru_pages        shrinker->seeks (default:2)

scan_objects = min(basic_scan_objects, max_pass * 2)


That said, small lru_pages parameter makes too many slab dropping.
Practically, zone-reclaim always take max_pass*2. about inode, 
shrink_icache_memory() takes number of unused inode as max_pass.
It mean one shrink_slab() calling drop all icache. Is this optimal
behavior? why?

Am I missing something?

> Initially zone_reclaim was full of heuristics that later were replaced by
> counter as the new ZVCs became available and gradually better ways of
> accounting for pages became possible.


