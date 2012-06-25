Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2FYUl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:41:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab2FYUl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:41:56 -0400
Message-ID: <4FE8CCCD.7080503@redhat.com>
Date: Mon, 25 Jun 2012 16:40:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, thp: abort compaction if migration page cannot be
 charged to memcg
References: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 02:52 AM, David Rientjes wrote:
> If page migration cannot charge the new page to the memcg,
> migrate_pages() will return -ENOMEM.  This isn't considered in memory
> compaction however, and the loop continues to iterate over all pageblocks
> trying in a futile attempt to continue migrations which are only bound to
> fail.
>
> This will short circuit and fail memory compaction if migrate_pages()
> returns -ENOMEM.  COMPACT_PARTIAL is returned in case some migrations
> were successful so that the page allocator will retry.

The patch makes sense, however I wonder if it would make
more sense in the long run to allow migrate/compaction to
temporarily exceed the memcg memory limit for a cgroup,
because the original page will get freed again soon anyway.

That has the potential to improve compaction success, and
reduce compaction related CPU use.
