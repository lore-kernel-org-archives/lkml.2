Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2F1Axj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 20:53:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33221 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab2F1Aww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 20:52:52 -0400
Date: Wed, 27 Jun 2012 17:52:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Minchan Kim <minchan@kernel.org>, Jim Schutt <jaschut@sandia.gov>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: excessive CPU utilization by isolate_freepages?
In-Reply-To: <4FEBA520.4030205@redhat.com>
Message-ID: <alpine.DEB.2.00.1206271745170.9552@chino.kir.corp.google.com>
References: <4FEB8237.6030402@sandia.gov> <4FEB9E73.5040709@kernel.org> <4FEBA520.4030205@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012, Rik van Riel wrote:

> > I doubt compaction try to migrate continuously although we have no free
> > memory.
> > Could you apply this patch and retest?
> > 
> > https://lkml.org/lkml/2012/6/21/30
> 

Not sure if Jim is using memcg; if not, then this won't be helpful.

> Another possibility is that compaction is succeeding every time,
> but since we always start scanning all the way at the beginning
> and end of each zone, we waste a lot of CPU time rescanning the
> same pages (that we just filled up with moved pages) to see if
> any are free.
> 
> In short, due to the way compaction behaves right now,
> compaction + isolate_freepages are essentially quadratic.
> 
> What we need to do is remember where we left off after a
> successful compaction, so we can continue the search there
> at the next invocation.
> 

So when the free and migration scanners meet and compact_finished() == 
COMPACT_CONTINUE, loop around to the start of the zone and continue until 
you reach the pfn that it was started at?  Seems appropriate.
