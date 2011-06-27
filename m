Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1F0DFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 23:05:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38183 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1F0DFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 23:05:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E07F349.2040900@jp.fujitsu.com>
Date: Mon, 27 Jun 2011 12:04:41 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: andrea@betterlinux.com
CC: akpm@linux-foundation.org, minchan.kim@gmail.com, riel@redhat.com,
        peterz@infradead.org, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hughd@google.com,
        jamesjer@betterlinux.com, marcus@bluehost.com, matt@bluehost.com,
        tytso@mit.edu, shaohua.li@intel.com, P@draigBrady.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] fadvise: support POSIX_FADV_NOREUSE
References: <1308923350-7932-1-git-send-email-andrea@betterlinux.com>
In-Reply-To: <1308923350-7932-1-git-send-email-andrea@betterlinux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/24 22:49), Andrea Righi wrote:
> There were some reported problems in the past about trashing page cache
> when a backup software (i.e., rsync) touches a huge amount of pages (see
> for example [1]).
> 
> This problem has been almost fixed by the Minchan Kim's patch [2] and a
> proper use of fadvise() in the backup software. For example this patch
> set [3] has been proposed for inclusion in rsync.
> 
> However, there can be still other similar trashing problems: when the
> backup software reads all the source files, some of them may be part of
> the actual working set of the system. When a POSIX_FADV_DONTNEED is
> performed _all_ pages are evicted from pagecache, both the working set
> and the use-once pages touched only by the backup software.
> 
> A previous proposal [4] tried to resolve this problem being less
> agressive in invalidating active pages, moving them to the inactive list
> intead of just evict them from the page cache.
> 
> However, this approach changed completely the old behavior of
> invalidate_mapping_pages(), that is not only used by fadvise.
> 
> The new solution maps POSIX_FADV_NOREUSE to the less-agressive page
> invalidation policy.
> 
> With POSIX_FADV_NOREUSE active pages are moved to the tail of the
> inactive list, and pages in the inactive list are just removed from page
> cache. Pages mapped by other processes or unevictable pages are not
> touched at all.
> 
> In this way if the backup was the only user of a page, that page will be
> immediately removed from the page cache by calling POSIX_FADV_NOREUSE.
> If the page was also touched by other tasks it'll be moved to the
> inactive list, having another chance of being re-added to the working
> set, or simply reclaimed when memory is needed.
> 
> In conclusion, now userspace applications that want to drop some page
> cache pages can choose between the following advices:
> 
>  POSIX_FADV_DONTNEED = drop page cache if possible
>  POSIX_FADV_NOREUSE = reduce page cache eligibility

Eeek.

Your POSIX_FADV_NOREUSE is very different from POSIX definition.
POSIX says,

       POSIX_FADV_NOREUSE
              Specifies that the application expects to access the specified data once  and  then
              not reuse it thereafter.

IfI understand correctly, it designed for calling _before_ data access
and to be expected may prevent lru activation. But your NORESE is designed
for calling _after_ data access. Big difference might makes a chance of
portability issue.





