Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2FUJBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:01:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42946 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2FUJBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:01:46 -0400
Date: Thu, 21 Jun 2012 02:01:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, thp: abort compaction if migration page cannot be
 charged to memcg
In-Reply-To: <alpine.DEB.2.00.1206210124380.6635@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1206210158360.10975@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com> <4FE2D73C.3060001@kernel.org> <alpine.DEB.2.00.1206210124380.6635@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, David Rientjes wrote:

> It's possible that subsequent pageblocks would contain memory allocated 
> from solely non-oom memcgs, but it's certainly not a guarantee and results 
> in terrible performance as exhibited above.  Is there another good 
> criteria to use when deciding when to stop isolating and attempting to 
> migrate all of these pageblocks?
> 
> Other ideas?
> 

The only other alternative that I can think of is to check 
mem_cgroup_margin() in isolate_migratepages_range() and return a NULL 
lruvec that would break that pageblock and return, and then set a bit in 
struct mem_cgroup that labels it as oom so we can check for it on 
subsequent pageblocks without incurring the locking to do 
mem_cgroup_margin() in res_counter, and then clear that bit on every 
uncharge to a memcg, but this still seems like a tremendous waste of cpu 
(especially if /sys/kernel/mm/transparent_hugepage/defrag == always) if 
most pageblocks contain pages from an oom memcg.
