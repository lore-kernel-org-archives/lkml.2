Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2D1AUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:20:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:32847 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2D1AUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:20:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120427204035.GN26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A36DE.30301@jp.fujitsu.com>
	<20120427204035.GN26595@google.com>
Date: Sat, 28 Apr 2012 09:20:52 +0900
Message-ID: <CABEgKgrJ68wU-L17zwN4_htX948TNFnLVgts=hFeY7QG3etwCA@mail.gmail.com>
Subject: Re: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a
 cgroup being destroyed
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 5:40 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Apr 27, 2012 at 03:04:14PM +0900, KAMEZAWA Hiroyuki wrote:
>> When ->pre_destroy() is called, it should be guaranteed that
>> new child cgroup is not created under a cgroup, where pre_destroy()
>> is running. If not, ->pre_destroy() must check children and
>> return -EBUSY, which causes warning.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Hmm... I'm getting confused more.  Why do we need these cgroup changes
> at all?  cgroup still has cgrp->count check and
> cgroup_clear_css_refs() after pre_destroy() calls.  The order of
> changes should be,
>
> * Make memcg pre_destroy() not fail; however, pre_destroy() should
>  still be ready to be retried.  That's the defined interface.
>
> * cgroup core updated to drop pre_destroy() retrying and guarantee
>  that pre_destroy() invocation will happen only once.
>
> * memcg and other cgroups can update their pre_destroy() if the "won't
>  be retried" part can simplify their implementations.
>

What I thought was...
Assume a memory cgoup A, with use_hierarchy==1.

1.  thread:0   start calling pre->destroy of cgroup A
2.  thread:0   it sometimes calls cond_resched or other sleep functions.
3.  thread:1   create a cgroup B under "A"
4.  thread:1   attach a thread X to cgroup A/B
5.  res_counter of A charged up. but pre_destroy() can't find what happens
    because it scans LRU of A.

So, we have -EBUSY now. I considered some options to fix this.

option 1) just return 0 instead of -EBUSY when pre_destroy() finds a
task or a child.

There is a race....even if we return 0 here and expects cgroup code
can catch it,
the thread or a child we found may be moved to other cgroup before we check it
in cgroup's final check.
In that case, the cgroup will be freed before full-ack of
pre_destory() and the charges
will be lost.

option 2) move all codes to ->destory()
That was previous version of this set.

This is option3 that preventing creation of new child.

If you don't like this, I'll move all codes to ->destroy() and use
asynchronous again.

Thanks,
-Kame
