Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0EUBb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:31:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab0EUBbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:31:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=KShCrltmSFyfx2w/izBgE7zAeda/kzrwd+HeYfYk/g0+N0OIo44z4qDbtr9ygiCYL
	6Rvtzw545waAJ+wQqcyGA==
Date: Thu, 20 May 2010 18:31:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Shaohua Li <shaohua.li@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at
 first
In-Reply-To: <20100519174327.9591.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.1005201822120.19421@tigran.mtv.corp.google.com>
References: <20100519174327.9591.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, KOSAKI Motohiro wrote:

> Shaohua Li reported parallel file copy on tmpfs can lead to
> OOM killer. This is regression of caused by commit 9ff473b9a7
> (vmscan: evict streaming IO first). Wow, It is 2 years old patch!
> 
> Currently, tmpfs file cache is inserted active list at first. It
> mean the insertion doesn't only increase numbers of pages in anon LRU,
> but also reduce anon scanning ratio. Therefore, vmscan will get totally
> confusion. It scan almost only file LRU even though the system have
> plenty unused tmpfs pages.
> 
> Historically, lru_cache_add_active_anon() was used by two reasons.
> 1) Intend to priotize shmem page rather than regular file cache.
> 2) Intend to avoid reclaim priority inversion of used once pages.
> 
> But we've lost both motivation because (1) Now we have separate
> anon and file LRU list. then, to insert active list doesn't help
> such priotize. (2) In past, one pte access bit will cause page
> activation. then to insert inactive list with pte access bit mean
> higher priority than to insert active list. Its priority inversion
> may lead to uninteded lru chun. but it was already solved by commit
> 645747462 (vmscan: detect mapped file pages used only once).
> (Thanks Hannes, you are great!)
> 
> Thus, now we can use lru_cache_add_anon() instead.
> 
> Reported-by: Shaohua Li <shaohua.li@intel.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Hugh Dickins <hughd@google.com>

Thanks - though I don't quite agree with your description: I can't
see why the lru_cache_add_active_anon() was ever justified - that
"active" came in along with the separate anon and file LRU lists.

Hugh
