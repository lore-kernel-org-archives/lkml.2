Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab2CIBeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:34:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35247 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab2CIBeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:34:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Mar 2012 10:32:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/7] mm: rework reclaim_stat counters
Message-Id: <20120309103231.03097798.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120308180419.27621.88710.stgit@zurg>
References: <20120308175752.27621.54781.stgit@zurg>
	<20120308180419.27621.88710.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 22:04:19 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Currently there is two types of reclaim-stat counters:
> recent_scanned (pages picked from from lru),
> recent_rotated (pages putted back to active lru).
> Reclaimer uses ratio recent_rotated / recent_scanned
> for balancing pressure between file and anon pages.
> 
> But if we pick page from lru we can either reclaim it or put it back to lru, thus:
> recent_scanned == recent_rotated[inactive] + recent_rotated[active] + reclaimed
> This can be called "The Law of Conservation of Memory" =)
> 
> Thus recent_rotated counters for each lru list is enough, reclaimed pages can be
> counted as rotatation into inactive lru. After that reclaimer can use this ratio:
> recent_rotated[active] / (recent_rotated[active] + recent_rotated[inactive])
> 
> After this patch struct zone_reclaimer_stat has only one array: recent_rotated,
> which is directly indexed by lru list index:
> 
> before patch:
> 
> LRU_ACTIVE_ANON   -> LRU_ACTIVE_ANON   : recent_scanned[ANON]++, recent_rotated[ANON]++
> LRU_INACTIVE_ANON -> LRU_ACTIVE_ANON   : recent_scanned[ANON]++, recent_rotated[ANON]++
> LRU_ACTIVE_ANON   -> LRU_INACTIVE_ANON : recent_scanned[ANON]++
> LRU_INACTIVE_ANON -> LRU_INACTIVE_ANON : recent_scanned[ANON]++
> 
> after patch:
> 
> LRU_ACTIVE_ANON   -> LRU_ACTIVE_ANON   : recent_rotated[LRU_ACTIVE_ANON]++
> LRU_INACTIVE_ANON -> LRU_ACTIVE_ANON   : recent_rotated[LRU_ACTIVE_ANON]++
> LRU_ACTIVE_ANON   -> LRU_INACTIVE_ANON : recent_rotated[LRU_INACTIVE_ANON]++
> LRU_INACTIVE_ANON -> LRU_INACTIVE_ANON : recent_rotated[LRU_INACTIVE_ANON]++
> 
> recent_scanned[ANON] === recent_rotated[LRU_ACTIVE_ANON] + recent_rotated[LRU_INACTIVE_ANON]
> recent_rotated[ANON] === recent_rotated[LRU_ACTIVE_ANON]
> 
> (and the same for FILE/LRU_ACTIVE_FILE/LRU_INACTIVE_FILE)
> 
> v5:
> * resolve conflict with "memcg: fix GPF when cgroup removal races with last exit"
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Nice description.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


