Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0JZCO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:14:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64496 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab0JZCO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:14:56 -0400
Message-ID: <4CC639AD.6090900@cn.fujitsu.com>
Date: Tue, 26 Oct 2010 10:15:09 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Nauman Rafique <nauman@google.com>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4 v2] cfq-iosched: add cfq group hierarchical scheduling
 support
References: <4CBFA64D.6050800@cn.fujitsu.com> <4CBFA6C9.3040604@cn.fujitsu.com> <20101022205437.GI7020@redhat.com> <4CC4EFFE.8040100@cn.fujitsu.com> <20101025202010.GB23426@redhat.com>
In-Reply-To: <20101025202010.GB23426@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Oct 25, 2010 at 10:48:30AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Thu, Oct 21, 2010 at 10:34:49AM +0800, Gui Jianfeng wrote:
>>>> This patch enables cfq group hierarchical scheduling.
>>>>
>>>> With this patch, you can create a cgroup directory deeper than level 1.
>>>> Now, I/O Bandwidth is distributed in a hierarchy way. For example:
>>>> We create cgroup directories as following(the number represents weight):
>>>>
>>>>             Root grp
>>>>            /       \
>>>>        grp_1(100) grp_2(400)
>>>>        /    \ 
>>>>   grp_3(200) grp_4(300)
>>>>
>>>> If grp_2 grp_3 and grp_4 are contending for I/O Bandwidth,
>>>> grp_2 will share 80% of total bandwidth.
>>>> For sub_groups, grp_3 shares 8%(20% * 40%), grp_4 shares 12%(20% * 60%)
>>>>
>>>> Design:
>>>>   o Each cfq group has its own group service tree. 
>>>>   o Each cfq group contains a "group schedule entity" (gse) that 
>>>>     schedules on parent cfq group's service tree.
>>>>   o Each cfq group contains a "queue schedule entity"(qse), it
>>>>     represents all cfqqs located on this cfq group. It schedules
>>>>     on this group's service tree. For the time being, root group
>>>>     qse's weight is 1000, and subgroup qse's weight is 500.
>>>>   o All gses and qse which belones to a same cfq group schedules
>>>>     on the same group service tree.
>>>>   o cfq group allocates in a recursive manner, that means when a cfq 
>>>>     group needs to be allocated, the upper level cfq groups are also
>>>>     allocated.
>>>>   o When a cfq group served, not only charge this cfq group but also
>>>>     charge its ancestors.
>>> Gui,
>>>
>>> I have not been able to convince myself yet that not treating queue at
>>> same level as group is a better idea than treating queue at the same
>>> level as group. 
>>>
>>> I am again trying to put my thoughts together that why I am not convinced.
>>>
>>> - I really don't like the idea of hidden group and assumptions about the
>>>   weight of this group which user does not know or user can't control.
>>>  
>>> - Secondly I think that both the following use cases are valid use cases.
>>>
>>>
>>>   case 1:
>>>   -------
>>> 			  root
>>> 			 / | \
>>> 			q1 q2 G1
>>> 			      / \
>>> 			     q3  q4	 
>>>
>>>  In this case queues and group are treated at same level, and group G1's
>>>  share changes dynamically based on number of competiting queues. Assume
>>>  system admin has put one user's all tasks in G1, and default weight of G1
>>>  is 500, then admin might really want to keep G1's share dyanmic, so that
>>>  if root is not doing lots of IO (not many thread), then G1 gets more IO
>>>  done but if IO activity in root threads increases then G1 gets less
>>>  share. 
>>>
>>>  case 2:
>>>  -------  
>>>  The second case is where one wants a more deterministic share of a
>>>  group and does not want that share to change based on number of
>>>  processes. In that case one can simply create a child group and move
>>>  all root threads inside that group.
>>>
>>> 			  root
>>> 			   |  \
>>> 		  root-threads G1
>>> 			/ \    /\
>>> 		       q1 q2  q3 q4
>>>
>>>  So if we design in such a way so that we treat queues at same level as
>>>  group, then we are not bounding user to a specific case. case 1, will
>>>  be default in hierarchical mode and user can easily achieve case 2. Instead
>>>  of locking down user to case 2 by default from kernel implementation and
>>>  assume nobody is going to use case 1.
>>>
>>>  IOW, treating queues at group level provides more flexibility.
>>>
>>> - Treating queues at same level as groups will also help us better handle
>>>   the case of RT threads. Think of following.
>>>
>>> 			  root
>>> 			  |   \
>>> 			q1(RT) G1
>>> 			      / \
>>> 			     q3  q4	 
>>>
>>>  In this case q1 is real time prio class. Now if we treat queue at same
>>>  level group, then we can try to give 100% IO disk time to q1. But with
>>>  hardcoding of hidden group, covering such cases will be hard.
>>>
>>> - Other examples in kernel (CFS scheduler) already treat queue at same
>>>   level at group. So until and unless we have a good reason, we should
>>>   remain consistent. 
>>>
>>> - If we try to draw analogy from other subsystems like virtual machine,
>>>   where weight of a KVM machine on cpu is decided by native threads
>>>   created on host (logical cpus) and not by how many threads are running
>>>   inside the guest. And share of these logical cpu threads varies
>>>   dynamically based on how many other threads are running on system.
>>>
>>>   In a simple case of 1 logical cpu, we will create 1 thread and say there
>>>   are 10 processes running inside guest, then effectively shares of these
>>>   10 processes changes dynamically based on how many threads are running. 
>>>
>>> So I am not yet convinced that we should take the hidden group approach.
>> Hi Vivek,
>>
>> In short, All of the problems are bacause of the fixed weight "Hidden group".
>> So how about make the "hidden group" weight becoming dynamic according to
>> the cfqq number and priority. Or whether we can export an new user interface
>> to make "Hidden group" configurable. Thus, user can configure the "Hidden group".
> 
> Gui,
> 
> Even if you do that it will still not solve the problem of RT tread in
> root group getting all the disk.

Hi Vivek

Next step, whether we can enable cfq group IO Class and export it in cgroup.
So that, hidden group might boost to RT if there're RT cfqqs in it.

> 
> Secondly, somehow the idea of hidden group is just not appealing to me
> and trying to even expose it to user will make it even uglier.
> 
> I guess without going into implementation details, we need to first
> figure out what's the right thing to do from a design perspective and
> then later dive into what are the complexities involved in doing the
> right thing.
> 
>>> Now coming to the question of how to resolve conflict with the cfqq queue
>>> scheduling algorithm. Can we do following.
>>>
>>> - Give some kind of boost to queue entities based on their weight. So when
>>>   queue and group entities are hanging on a service tree, they are
>>>   scheduled according to their vdisktime, and vdisktime is calculated
>>>   based on entitie's weight and how much time entity spent on disk just
>>>   now.
>>>
>>>   Group entities can continue to follow existing method and we can try
>>>   to reduce the vdisktime of queue entities a bit based on their priority.
>>>
>>>   That way, one might see some service differentiation between ioprio
>>>   of queues and also the relative share between groups does not change.
>>>   The only problematic part is that when queue and groups are at same
>>>   level then it is not very predictable that group gets how much share
>>>   and queues get how much share. But I guess this is lesser of a problem
>>>   as compared to hidden group approach.
>>>
>>> Thoughts?
>> Do you mean that let cfqq and cfq group schedule at the same service tree. If
>> we choose a cfq queue, ok let it run. If we choose the cfq group, we should
>> continue to choose a cfq queue in that group.
>> If that's the case, I think the original CFQ logic has been broken.
>> Am I missing something?
>>
> 
> Can you give more details about what's broken in running CFQ queue and
> CFQ group on same service tree?
> 
> To me only thing which was broken is that how to take care of giving
> higher disk share to higher prio queue when idling is disabled. In that
> case we don't idle on queue and after request dispatch queue is deleted
> from service tree and when new request comes in, queue is put at the end
> of service tree (like other entities). And this happens with queues of
> all prio and hence the prio difference between queues is lost.
> 
> Currently we put all new queues at the end of service tree. If we put
> some logic to give vdisktime boost based on priority for new queues, 
> then we should be able to achieve the similar affect as current CFQ. Isn't
> it?

I'm wondering if CFQ queue and CFQ group schedule on a same service tree,
How to deal with workload type(SYNC,SYNC_NOIDLE,ASYNC) and IO Class?  
Currently, different workload type and IO Class cfqqs are put on different
trees. If they are scheduling on a same tree, we can't differentiate them.

Gui

> 
> Thanks
> Vivek 
> 
>> Thanks
>> Gui
>>
>>> Thanks
>>> Vivek
>>>
>>>
> 
> 
