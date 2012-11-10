Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2KJBfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:35:24 -0500
Received: from mx2.parallels.com ([64.131.90.16]:34755 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab2KJBfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:35:21 -0500
Message-ID: <509DAF4C.702@parallels.com>
Date: Sat, 10 Nov 2012 02:35:08 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Daniel Wagner <wagi@monom.org>, <lizefan@huawei.com>, <mhocko@suse.cz>,
        <rjw@sisk.pl>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <fweisbec@gmail.com>
Subject: Re: [PATCH 1/9 v3] cgroup: add cgroup_subsys->post_create()
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-2-git-send-email-tj@kernel.org> <20121108190715.GD9672@htj.dyndns.org> <509CE472.9040504@monom.org> <20121109172211.GB2711@htj.dyndns.org>
In-Reply-To: <20121109172211.GB2711@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [80.26.129.34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 06:22 PM, Tejun Heo wrote:
> Hey, Daniel.
> 
> On Fri, Nov 09, 2012 at 12:09:38PM +0100, Daniel Wagner wrote:
>> On 08.11.2012 20:07, Tejun Heo wrote:> Subject: cgroup: add
>> cgroup_subsys->post_create()
>>>
>>> Currently, there's no way for a controller to find out whether a new
>>> cgroup finished all ->create() allocatinos successfully and is
>>> considered "live" by cgroup.
>>
>> I'd like add hierarchy support to net_prio and the first thing to
>> do is to get rid of get_prioidx(). It looks like it would be nice to
> 
> Ooh, I'm already working on it.  I *think* I should be able to post
> the patches later today or early next week.
> 
>> be able to use use_id and post_create() for this but as I read the
>> code this might not work because the netdev might access resources
>> allocated between create() and post_create(). So my question is
>> would it make sense to move
>>
>> cgroup_create():
>>
>> 		if (ss->use_id) {
>> 			err = alloc_css_id(ss, parent, cgrp);
>> 			if (err)
>> 				goto err_destroy;
>> 		}
>>
>> part before create() or add some protection between create() and
>> post_create() callback in net_prio. I have a patch but I see
>> I could drop it completely if post_create() is there.
> 
> Glauber had about similar question about css_id and I need to think
> more about it but currently I think I want to phase out css IDs.  It's
> an id of the wrong thing (CSSes don't need IDs, cgroups do) and
> unnecessarily duplicates its own hierarchy when the hierarchy of
> cgroups already exists.  Once memcontrol moves away from walking using
> css_ids, I *think* I'll try to kill it.

May I suggest doing something similar with what the scheduler does? I
had some code in the past that reused that code - but basically
duplicated it. If you want, I can try getting a version of that in
kernel/cgroup.c  that would serve as a general walker.

I like that walker a lot, because it happens in a sane order. memcg
basically walks in a random weird order, that makes hierarchical
computation of anything quite hard.

> 
> I'll add cgroup ID (no hierarchy funnies, just a single ida allocated
> number) so that it can be used for cgroup indexing.  Glauber, that
> should solve your problem too, right?
> 

Actually I went with a totally orthogonal solution. I am now using per
kmem-limited ids. Because they are not tied to the cgroup creation
workflow, I can allocate whenever it is more convenient.

I ended up liking this solution because it will do better in scenarios
where most of the memcgs are not kmem limited. So it had an edge here,
and also got rid of the create/post_create problem by breaking the
dependency.

But of course, if cgroups would gain some kind of sane indexing, it
could shift the balance towards reusing it.


