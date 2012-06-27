Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2F0KFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:05:51 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39366 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab2F0KFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:05:50 -0400
Message-ID: <4FEADA55.4060409@parallels.com>
Date: Wed, 27 Jun 2012 14:03:01 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252106430.26640@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206252106430.26640@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 08:09 AM, David Rientjes wrote:
> @@ -2206,7 +2214,7 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>  	 * unlikely to succeed so close to the limit, and we fall back
>>  	 * to regular pages anyway in case of failure.
>>  	 */
>>-	if (nr_pages == 1 && ret)
>>+	if (nr_pages <= NR_PAGES_TO_RETRY && ret)
>>  		return CHARGE_RETRY;

Changed to costly order.

One more thing. The original version of this patch included
a cond_resched() here, that was also removed. From my re-reading
of the code in page_alloc.c and vmscan.c now, I tend to think
this is indeed not needed, since any cond_resched()s that might
be needed to ensure the safety of the code will be properly
inserted by the reclaim code itself, so there is no need for us
to include any when we signal that a retry is needed.

Do you/others agree?


