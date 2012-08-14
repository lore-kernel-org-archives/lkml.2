Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2HNLEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:04:06 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36475 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab2HNLEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:04:04 -0400
Message-ID: <502A2FE5.4060809@parallels.com>
Date: Tue, 14 Aug 2012 15:00:53 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-7-git-send-email-glommer@parallels.com> <50254475.4000201@jp.fujitsu.com>
In-Reply-To: <50254475.4000201@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 09:27 PM, Kamezawa Hiroyuki wrote:
>> +bool __memcg_kmem_new_page(gfp_t gfp, void *_handle, int order)
>> > +{
>> > +	struct mem_cgroup *memcg;
>> > +	struct mem_cgroup **handle = (struct mem_cgroup **)_handle;
>> > +	bool ret = true;
>> > +	size_t size;
>> > +	struct task_struct *p;
>> > +
>> > +	*handle = NULL;
>> > +	rcu_read_lock();
>> > +	p = rcu_dereference(current->mm->owner);
>> > +	memcg = mem_cgroup_from_task(p);
>> > +	if (!memcg_kmem_enabled(memcg))
>> > +		goto out;
>> > +
>> > +	mem_cgroup_get(memcg);
>> > +
> This mem_cgroup_get() will be a potentioal performance problem.
> Don't you have good idea to avoid accessing atomic counter here ?
> I think some kind of percpu counter or a feature to disable "move task"
> will be a help.
> 
> 

I have just sent out a proposal to deal with this. I tried the trick of
marking only the first charge and last uncharge, and it works quite
alright at the cost of a bit test on most calls to memcg_kmem_charge.

Please let me know what you think.

