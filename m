Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab2FRMjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:39:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57997 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FRMjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:39:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDF20ED.4090401@jp.fujitsu.com>
Date: Mon, 18 Jun 2012 21:37:01 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        cgroups@vger.kernel.org, devel@openvz.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 23/25] memcg: propagate kmem limiting information to
 children
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-24-git-send-email-glommer@parallels.com>
In-Reply-To: <1340015298-14133-24-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/18 19:28), Glauber Costa wrote:
> The current memcg slab cache management fails to present satisfatory hierarchical
> behavior in the following scenario:
> 
> ->  /cgroups/memory/A/B/C
> 
> * kmem limit set at A
> * A and B empty taskwise
> * bash in C does find /
> 
> Because kmem_accounted is a boolean that was not set for C, no accounting
> would be done. This is, however, not what we expect.
> 

Hmm....do we need this new routines even while we have mem_cgroup_iter() ?

Doesn't this work ?

	struct mem_cgroup {
		.....
		bool kmem_accounted_this;
		atomic_t kmem_accounted;
		....
	}

at set limit

	....set_limit(memcg) {

		if (newly accounted) {
			mem_cgroup_iter() {
				atomic_inc(&iter->kmem_accounted)
			}
		} else {
			mem_cgroup_iter() {
				atomic_dec(&iter->kmem_accounted);
			}
	}


hm ? Then, you can see kmem is accounted or not by atomic_read(&memcg->kmem_accounted);

Thanks,
-Kame


