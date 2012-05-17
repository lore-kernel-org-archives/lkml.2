Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449Ab2EQJX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:23:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471Ab2EQJXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:23:25 -0400
Date: Thu, 17 May 2012 02:24:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: consider all swapped back pages in used-once logic
Message-Id: <20120517022412.9175f604.akpm@linux-foundation.org>
In-Reply-To: <1337246033-13719-1-git-send-email-mhocko@suse.cz>
References: <1337246033-13719-1-git-send-email-mhocko@suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012 11:13:53 +0200 Michal Hocko <mhocko@suse.cz> wrote:

> [64574746 vmscan: detect mapped file pages used only once] made mapped pages
> have another round in inactive list because they might be just short
> lived and so we could consider them again next time. This heuristic
> helps to reduce pressure on the active list with a streaming IO
> worklods.
> This patch fixes a regression introduced by this commit for heavy shmem

A performance regression, specifically.

Are you able to quantify it?

> based workloads because unlike Anon pages, which are excluded from this
> heuristic because they are usually long lived, shmem pages are handled
> as a regular page cache.
> This doesn't work quite well, unfortunately, if the workload is mostly
> backed by shmem (in memory database sitting on 80% of memory) with a
> streaming IO in the background (backup - up to 20% of memory). Anon
> inactive list is full of (dirty) shmem pages when watermarks are
> hit. Shmem pages are kept in the inactive list (they are referenced)
> in the first round and it is hard to reclaim anything else so we reach
> lower scanning priorities very quickly which leads to an excessive swap
> out.
> 
> Let's fix this by excluding all swap backed pages (they tend to be long
> lived wrt. the regular page cache anyway) from used-once heuristic and
> rather activate them if they are referenced.
