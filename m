Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2FZAcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:32:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42852 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab2FZAcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:32:02 -0400
Date: Mon, 25 Jun 2012 17:32:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, thp: abort compaction if migration page cannot be
 charged to memcg
In-Reply-To: <4FE8CCCD.7080503@redhat.com>
Message-ID: <alpine.DEB.2.00.1206251726040.1895@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com> <4FE8CCCD.7080503@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, Rik van Riel wrote:

> The patch makes sense, however I wonder if it would make
> more sense in the long run to allow migrate/compaction to
> temporarily exceed the memcg memory limit for a cgroup,
> because the original page will get freed again soon anyway.
> 
> That has the potential to improve compaction success, and
> reduce compaction related CPU use.
> 

Yeah, Kame brought up the same point with a sample patch by allowing the 
temporary charge for the new page.  It would certainly solve this problem 
in a way that we don't have to even touch compaction, it's disappointing 
that we have to charge memory to do a page migration.  I'm not so sure 
about the approach of temporarily allowing the excess charge, however, 
since it would scale with the number of cpus doing compaction or 
migration, which could end up with PAGE_SIZE * nr_cpu_ids.

I haven't looked at it (yet), but I'm hoping that there's a way to avoid 
charging the temporary page at all until after move_to_new_page() 
succeeds, i.e. find a way to uncharge page before charging newpage.  We 
currently don't charge things like vmalloc() memory to things that call 
alloc_pages() directly so it seems like it's plausible without causing 
usage > limit.
