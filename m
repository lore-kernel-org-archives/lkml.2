Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2KNAD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:03:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47626 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2KNAD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:03:57 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A2DFDC.90402@jp.fujitsu.com>
Date: Wed, 14 Nov 2012 09:03:40 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 1/5] memcg: synchronize per-zone iterator access by a spinlock
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz> <1352820639-13521-2-git-send-email-mhocko@suse.cz>
In-Reply-To: <1352820639-13521-2-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/14 0:30), Michal Hocko wrote:
> per-zone per-priority iterator is aimed at coordinating concurrent
> reclaimers on the same hierarchy (or the global reclaim when all
> groups are reclaimed) so that all groups get reclaimed evenly as
> much as possible. iter->position holds the last css->id visited
> and iter->generation signals the completed tree walk (when it is
> incremented).
> Concurrent reclaimers are supposed to provide a reclaim cookie which
> holds the reclaim priority and the last generation they saw. If cookie's
> generation doesn't match the iterator's view then other concurrent
> reclaimer already did the job and the tree walk is done for that
> priority.
> 
> This scheme works nicely in most cases but it is not raceless. Two
> racing reclaimers can see the same iter->position and so bang on the
> same group. iter->generation increment is not serialized as well so a
> reclaimer can see an updated iter->position with and old generation so
> the iteration might be restarted from the root of the hierarchy.
> 
> The simplest way to fix this issue is to synchronise access to the
> iterator by a lock. This implementation uses per-zone per-priority
> spinlock which linearizes only directly racing reclaimers which use
> reclaim cookies so the effect of the new locking should be really
> minimal.
> 
> I have to note that I haven't seen this as a real issue so far. The
> primary motivation for the change is different. The following patch
> will change the way how the iterator is implemented and css->id
> iteration will be replaced cgroup generic iteration which requires
> storing mem_cgroup pointer into iterator and that requires reference
> counting and so concurrent access will be a problem.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


