Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab2FUKQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:16:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44761 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab2FUKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:16:39 -0400
Date: Thu, 21 Jun 2012 03:16:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, thp: abort compaction if migration page cannot be
 charged to memcg
In-Reply-To: <4FE2F1DA.8030608@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1206210310030.15747@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com> <4FE2D73C.3060001@kernel.org> <alpine.DEB.2.00.1206210124380.6635@chino.kir.corp.google.com> <alpine.DEB.2.00.1206210158360.10975@chino.kir.corp.google.com>
 <4FE2F1DA.8030608@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, Kamezawa Hiroyuki wrote:

> I guess the best way will be never calling charge/uncharge at migration.
> ....but it has been a battle with many race conditions..
> 
> Here is an alternative way, remove -ENOMEM in mem_cgroup_prepare_migration()
> by using res_counter_charge_nofail().
> 
> Could you try this ?

I would love to be able to remove the -ENOMEM as the result of charging 
the temporary page, but what happens if all cpus are calling into 
migrate_pages() that are unmapping pages from the same memcg?  This need 
not only be happening from compaction, either.  It feels like this 
wouldn't scale appropriately and you risk going significantly over the 
limit even for a brief enough period of time.  I'd hate to be 128K over my 
limit on a machine with 32 cores.

Comments from the memcg folks on if this is acceptable?

In the interim, do you have an objection to merging this patch as bandaid 
for stable?
