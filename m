Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1EMALf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:11:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43747 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab1EMALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:11:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 May 2011 09:04:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 3/6] mm: memcg-aware global reclaim
Message-Id: <20110513090450.3c40d2ee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1305212038-15445-4-git-send-email-hannes@cmpxchg.org>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
	<1305212038-15445-4-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 16:53:55 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> A page charged to a memcg is linked to a lru list specific to that
> memcg.  At the same time, traditional global reclaim is obvlivious to
> memcgs, and all the pages are also linked to a global per-zone list.
> 
> This patch changes traditional global reclaim to iterate over all
> existing memcgs, so that it no longer relies on the global list being
> present.
> 
> This is one step forward in integrating memcg code better into the
> rest of memory management.  It is also a prerequisite to get rid of
> the global per-zone lru lists.
> 


As I said, I don't want removing global reclaim until dirty_ratio support and
better softlimit algorithm, at least. Current my concern is dirty_ratio,
if you want to speed up, please help Greg and implement dirty_ratio first.

BTW, could you separete clean up code and your new logic ? 1st half of
codes seems to be just a clean up and seems nice. But , IIUC, someone
changed the arguments from chunk of params to be a flags....in some patch.
...
commit 75822b4495b62e8721e9b88e3cf9e653a0c85b73
Author: Balbir Singh <balbir@linux.vnet.ibm.com>
Date:   Wed Sep 23 15:56:38 2009 -0700

    memory controller: soft limit refactor reclaim flags

    Refactor mem_cgroup_hierarchical_reclaim()

    Refactor the arguments passed to mem_cgroup_hierarchical_reclaim() into
    flags, so that new parameters don't have to be passed as we make the
    reclaim routine more flexible

...

Balbir ?  Both are ok to me, please ask him.


And hmm...

+	do {
+		mem_cgroup_hierarchy_walk(root, &mem);
+		sc->current_memcg = mem;
+		do_shrink_zone(priority, zone, sc);
+	} while (mem != root);

This move hierarchy walk from memcontrol.c to vmscan.c ?

About moving hierarchy walk, I may say okay...because my patch does this, too.

But....doesn't this reclaim too much memory if hierarchy is very deep ?
Could you add some 'quit' path ?


Thanks,
-Kame

