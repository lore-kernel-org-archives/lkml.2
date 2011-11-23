Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1KWCw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 21:52:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62249 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab1KWCwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 21:52:54 -0500
Message-ID: <4ECC5FC8.9070500@cn.fujitsu.com>
Date: Wed, 23 Nov 2011 10:51:52 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.2-rc3] cpusets: stall when updating mems_allowed
 for mempolicy or disjoint nodemask
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com> <4EC4C603.8050704@cn.fujitsu.com> <alpine.DEB.2.00.1111171328120.15918@chino.kir.corp.google.com> <4EC62AEA.2030602@cn.fujitsu.com> <alpine.DEB.2.00.1111181545170.24487@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111181545170.24487@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-23 10:52:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-23 10:52:34,
	Serialize complete at 2011-11-23 10:52:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 15:49:22 -0800 (pst), David Rientjes wrote:
> On Fri, 18 Nov 2011, Miao Xie wrote:
> 
>>>> I find these is another problem, please take account of the following case:
>>>>
>>>>   2-3 -> 1-2 -> 0-1
>>>>
>>>> the user change mems_allowed twice continuously, the task may see the empty
>>>> mems_allowed.
>>>>
>>>> So, it is still dangerous.
>>>>
>>>
>>> With this patch, we're protected by task_lock(tsk) to determine whether we 
>>> want to take the exception, i.e. whether need_loop is false, and the 
>>> setting of tsk->mems_allowed.  So this would see the nodemask change at 
>>> the individual steps from 2-3 -> 1-2 -> 0-1, not some inconsistent state 
>>> in between or directly from 2-3 -> 0-1.  The only time we don't hold 
>>> task_lock(tsk) to change tsk->mems_allowed is when tsk == current and in 
>>> that case we're not concerned about intermediate reads to its own nodemask 
>>> while storing to a mask where MAX_NUMNODES > BITS_PER_LONG.
>>>
>>> Thus, there's no problem here with regard to such behavior if we exclude 
>>> mempolicies, which this patch does.
>>>
>>
>> No.
>> When the task does memory allocation, it access its mems_allowed without
>> task_lock(tsk), and it may be blocked after it check 0-1 bits. And then, the
>> user changes mems_allowed twice continuously(2-3(initial state) -> 1-2 -> 0-1),
>> After that, the task is woke up and it see the empty mems_allowed.
>>
> 
> I'm confused, you're concerned on a kernel where 
> MAX_NUMNODES > BITS_PER_LONG about thread A reading a partial 
> tsk->mems_allowed, being preempted, meanwhile thread B changes 
> tsk->mems_allowed by taking cgroup_mutex, taking task_lock(tsk), setting 
> the intersecting nodemask, releasing both, taking them again, changing the 
> nodemask again to be disjoint, then the thread A waking up and finishing 
> its read and seeing an intersecting nodemask because it is now disjoint 
> from the first read?
> 

(I am sorry for the late reply, I was on leave for the past few days.)

Yes, what you said is right.
But in fact, on the kernel where MAX_NUMNODES <= BITS_PER_LONG, the same problem
can also occur.
	task1			task1's mems	task2
	alloc page		2-3
	  alloc on node1? NO	2-3
				2-3		change mems from 2-3 to 1-2
				1-2		rebind task1's mpol
				1-2		  set new bits
				1-2		change mems from 0-1 to 0
				1-2		rebind task1's mpol
				0-1		  set new bits
	  alloc on node2? NO	0-1
	  ...
	can't alloc page
	  goto oom

Thanks
