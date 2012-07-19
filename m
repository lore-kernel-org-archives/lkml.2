Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2GSL0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:26:30 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:56712 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2GSL00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:26:26 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, mhocko@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb/cgroup: Simplify pre_destroy callback
In-Reply-To: <5007E0A2.70906@jp.fujitsu.com>
References: <1342589649-15066-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120718142628.76bf78b3.akpm@linux-foundation.org> <87hat4794l.fsf@skywalker.in.ibm.com> <5007B034.4030909@huawei.com> <87wr20f5pj.fsf@skywalker.in.ibm.com> <5007E0A2.70906@jp.fujitsu.com>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 19 Jul 2012 16:56:18 +0530
Message-ID: <87r4s8f0v9.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12071911-9574-0000-0000-000003A2C750
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

>>>>>
>>>>> We test RES_USAGE before taking hugetlb_lock.  What prevents some other
>>>>> thread from increasing RES_USAGE after that test?
>>>>>
>>>>> After walking the list we test RES_USAGE after dropping hugetlb_lock.
>>>>> What prevents another thread from incrementing RES_USAGE before that
>>>>> test, triggering the BUG?
>>>>
>>>> IIUC core cgroup will prevent a new task getting added to the cgroup
>>>> when we are in pre_destroy. Since we already check that the cgroup doesn't
>>>> have any task, the RES_USAGE cannot increase in pre_destroy.
>>>>
>>>
>>>
>>> You're wrong here. We release cgroup_lock before calling pre_destroy and retrieve
>>> the lock after that, so a task can be attached to the cgroup in this interval.
>>>
>>
>> But that means rmdir can be racy right ? What happens if the task got
>> added, allocated few pages and then moved out ? We still would have task
>> count 0 but few pages, which we missed to to move to parent cgroup.
>>
>
> That's a problem even if it's verrrry unlikely.
> I'd like to look into it and fix the race in cgroup layer.
> But I'm sorry I'm a bit busy in these days...
>

How about moving that mutex_unlock(&cgroup_mutex) to memcg callback ? That
can be a patch for 3.5 ? 

-aneesh
 

