Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2E3NIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:08:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58075 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2E3NIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:08:41 -0400
Message-ID: <4FC61B4E.2060206@parallels.com>
Date: Wed, 30 May 2012 17:06:22 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge infrastructure
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-17-git-send-email-glommer@parallels.com> <20120530130416.GD25094@somewhere.redhat.com>
In-Reply-To: <20120530130416.GD25094@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 05:04 PM, Frederic Weisbecker wrote:
> Do you think it's possible that this memcg can be destroyed (like ss->destroy())
> concurrently?
>
> Probably not because there is a synchronize_rcu() in cgroup_diput() so as long
> as we are in rcu_read_lock() we are fine.
>
> OTOH current->mm->owner can exit() right after we fetched its memcg and thus the css_set
> can be freed concurrently? And then the cgroup itself after we call rcu_read_unlock()
> due to cgroup_diput().
> And yet we are doing the mem_cgroup_get() below unconditionally assuming it's
> always fine to get a reference to it.
>
> May be I'm missing something?
When a cache is created, we grab a reference to the memcg. So after the 
cache is created, no.

When destroy is called, we flush the create queue, so if the cache is 
not created yet, it will just disappear.

I think the only problem that might happen is in the following scenario:

* cache gets created, but ref count is not yet taken
* memcg disappears
* we try to inc refcount for a non-existent memcg, and crash.

This would be trivially solvable by grabing the reference earlier.
But even then, I need to audit this further to make sure it is really an 
issue.
