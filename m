Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2D1AGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:06:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63726 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab2D1AGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120427103927.GA3514@somewhere.redhat.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A366E.9020307@jp.fujitsu.com>
	<20120427103927.GA3514@somewhere.redhat.com>
Date: Sat, 28 Apr 2012 09:06:20 +0900
Message-ID: <CABEgKgqVJZic-6U0YTv7u7GHe4bNOvChSUqzpb93OXU-ZPPWAQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 7/9 v2] cgroup: avoid attaching task to a cgroup
 under rmdir()
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 7:39 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Apr 27, 2012 at 03:02:22PM +0900, KAMEZAWA Hiroyuki wrote:
>> attach_task() is done under cgroup_mutex() but ->pre_destroy() callback
>> in rmdir() isn't called under cgroup_mutex().
>>
>> It's better to avoid attaching a task to a cgroup which
>> is under pre_destroy(). Considering memcg, the attached task may
>> increase resource usage after memcg's pre_destroy() confirms that
>> memcg is empty. This is not good.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  kernel/cgroup.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index ad8eae5..7a3076b 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1953,6 +1953,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>>       if (cgrp == oldcgrp)
>>               return 0;
>>
>> +     if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
>> +             return -EBUSY;
>> +
>
> You probably need to update cgroup_attach_proc() as well?
>
Ahh...I missed that. Thank you for pointing out !

Thanks,
-Kame
