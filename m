Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0IAPtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:49:52 -0400
Received: from smtp-out.google.com ([74.125.121.35]:33166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab0IAPtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GaGguz15UJ79CVbz3VxlDwJPoDG5GCmzqG/jh1fIOYAK080vVEEEWDT8uiwn1tv84r
         gwzEhoI96U3DKje45wAw==
MIME-Version: 1.0
In-Reply-To: <4C7E13CE.7070603@cn.fujitsu.com>
References: <4C7B54C0.7080008@cn.fujitsu.com> <20100830203644.GA15903@redhat.com>
 <4C7C4CE0.5080402@cn.fujitsu.com> <20100831125737.GA2527@redhat.com>
 <AANLkTi=daFyrx+ts4DoAHwR8EHUfF0nYyv45zJkBFm--@mail.gmail.com>
 <20100831192524.GD2527@redhat.com> <4C7E13CE.7070603@cn.fujitsu.com>
From: Nauman Rafique <nauman@google.com>
Date: Wed, 1 Sep 2010 08:49:26 -0700
Message-ID: <AANLkTinKcx4hTPX3CSVor-6GwhEYrsW25jenf67ksSHp@mail.gmail.com>
Subject: Re: [RFC] [PATCH] cfq-iosched: add cfq group hierarchical scheduling support
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Divyesh Shah <dpshah@google.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 1, 2010 at 1:50 AM, Gui Jianfeng <guijianfeng@cn.fujitsu.com> wrote:
> Vivek Goyal wrote:
>> On Tue, Aug 31, 2010 at 08:40:19AM -0700, Nauman Rafique wrote:
>>> On Tue, Aug 31, 2010 at 5:57 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>>> On Tue, Aug 31, 2010 at 08:29:20AM +0800, Gui Jianfeng wrote:
>>>>> Vivek Goyal wrote:
>>>>>> On Mon, Aug 30, 2010 at 02:50:40PM +0800, Gui Jianfeng wrote:
>>>>>>> Hi All,
>>>>>>>
>>>>>>> This patch enables cfq group hierarchical scheduling.
>>>>>>>
>>>>>>> With this patch, you can create a cgroup directory deeper than level 1.
>>>>>>> Now, I/O Bandwidth is distributed in a hierarchy way. For example:
>>>>>>> We create cgroup directories as following(the number represents weight):
>>>>>>>
>>>>>>>             Root grp
>>>>>>>            /       \
>>>>>>>        grp_1(100) grp_2(400)
>>>>>>>        /    \
>>>>>>>   grp_3(200) grp_4(300)
>>>>>>>
>>>>>>> If grp_2 grp_3 and grp_4 are contending for I/O Bandwidth,
>>>>>>> grp_2 will share 80% of total bandwidth.
>>>>>>> For sub_groups, grp_3 shares 8%(20% * 40%), grp_4 shares 12%(20% * 60%)
>>>>>>>
>>>>>>> Design:
>>>>>>>   o Each cfq group has its own group service tree.
>>>>>>>   o Each cfq group contains a "group schedule entity" (gse) that
>>>>>>>     schedules on parent cfq group's service tree.
>>>>>>>   o Each cfq group contains a "queue schedule entity"(qse), it
>>>>>>>     represents all cfqqs located on this cfq group. It schedules
>>>>>>>     on this group's service tree. For the time being, root group
>>>>>>>     qse's weight is 1000, and subgroup qse's weight is 500.
>>>>>>>   o All gses and qse which belones to a same cfq group schedules
>>>>>>>     on the same group service tree.
>>>>>> Hi Gui,
>>>>>>
>>>>>> Thanks for the patch. I have few questions.
>>>>>>
>>>>>> - So how does the hierarchy look like, w.r.t root group. Something as
>>>>>>   follows?
>>>>>>
>>>>>>
>>>>>>                     root
>>>>>>                    / | \
>>>>>>                  q1  q2 G1
>>>>>>
>>>>>> Assume there are two processes doin IO in root group and q1 and q2 are
>>>>>> cfqq queues for those processes and G1 is the cgroup created by user.
>>>>>>
>>>>>> If yes, then what algorithm do you use to do scheduling between q1, q2
>>>>>> and G1? IOW, currently we have two algorithms operating in CFQ. One for
>>>>>> cfqq and other for groups. Group algorithm does not use the logic of
>>>>>> cfq_slice_offset().
>>>>> Hi Vivek,
>>>>>
>>>>> This patch doesn't break the original sheduling logic. That is cfqg => st => cfqq.
>>>>> If q1 and q2 in root group, I treat q1 and q2 bundle as a queue sched entity, and
>>>>> it will schedule on root group service with G1, as following:
>>>>>
>>>>>                          root group
>>>>>                         /         \
>>>>>                     qse(q1,q2)    gse(G1)
>>>>>
>>>> Ok. That's interesting. That raises another question that how hierarchy
>>>> should look like. IOW, how queue and groups should be treated in
>>>> hierarchy.
>>>>
>>>> CFS cpu scheduler treats queues and group at the same level. That is as
>>>> follows.
>>>>
>>>>                        root
>>>>                        / | \
>>>>                       q1 q2 G1
>>>>
>>>> In the past I had raised this question and Jens and corrado liked treating
>>>> queues and group at same level.
>>>>
>>>> Logically, q1, q2 and G1 are all children of root, so it makes sense to
>>>> treat them at same level and not group q1 and q2 in to a single entity and
>>>> group.
>>>>
>>>> One of the possible way forward could be this.
>>>>
>>>> - Treat queue and group at same level (like CFS)
>>>>
>>>> - Get rid of cfq_slice_offset() logic. That means without idling on, there
>>>>  will be no ioprio difference between cfq queues. I think anyway as of
>>>>  today that logic helps in so little situations that I would not mind
>>>>  getting rid of it. Just that Jens should agree to it.
>>>>
>>>> - With this new scheme, it will break the existing semantics of root group
>>>>  being at same level as child groups. To avoid that, we can probably
>>>>  implement two modes (flat and hierarchical), something similar to what
>>>>  memory cgroup controller has done. May be one tunable in root cgroup of
>>>>  blkio "use_hierarchy".  By default everything will be in flat mode and
>>>>  if user wants hiearchical control, he needs to set user_hierarchy in
>>>>  root group.
>>> Vivek, may be I am reading you wrong here. But you are first
>>> suggesting to add more complexity to treat queues and group at the
>>> same level. Then you are suggesting add even more complexity to fix
>>> the problems caused by that approach.
>>>
>>> Why do we need to treat queues and group at the same level? "CFS does
>>> it" is not a good argument.
>>
>> Sure it is not a very good argument but at the same time one would need
>> a very good argument that why we should do things differently.
>>
>> - If a user has mounted cpu and blkio controller together and both the
>>   controllers are viewing the same hierarchy differently, then it is
>>   odd. We need a good reason that why different arrangement makes sense.
>
> Hi Vivek，
>
> Even if we mount cpu and blkio together, to me, it's ok for cpu and blkio
> having their own logic, since they are totally different cgroup subsystems.
>
>>
>> - To me, both group and cfq queue are children of root group and it
>>   makes sense to treat them independent childrens instead of putting
>>   all the queues in one logical group which inherits the weight of
>>   parent.
>>
>> - With this new scheme, I am finding it hard to visualize the hierachy.
>>   How do you assign the weights to queue entities of a group. It is more
>>   like a invisible group with-in group. We shall have to create new
>>   tunable which can speicy the weight for this hidden group.
>
> For the time being, the root "qse" weight is 1000 and others is 500, they don't
> inherit the weight of parent. I was thinking that maybe we can determine the qse
> weight in term of the queue number and weight in this group and subgroups.
>
> Thanks,
> Gui
>
>>
>>
>> So in summary I am liking the "queue at same level as group" scheme for
>> two reasons.
>>
>> - It is more intutive to visualize and implement. It follows the true
>>   hierarchy as seen by cgroup file system.
>>
>> - CFS has already implemented this scheme. So we need a strong arguemnt
>>   to justify why we should not follow the same thing. Especially for
>>   the case where user has co-mounted cpu and blkio controller.
>>
>> - It can achieve the same goal as "hidden group" proposal just by
>>   creating a cgroup explicitly and moving all threads in that group.
>>
>> Why do you think that "hidden group" proposal is better than "treating
>> queue at same level as group" ?

There are multiple reasons for "hidden group" proposal being a better approach.

- "Hidden group" would allow us to keep scheduling queues using the
CFQ queue scheduling logic. And does not require any major changes in
CFQ. Aren't we already using that approach to deal with queues at the
root group?

- If queues and groups are treated at the same level, queues can end
up in root cgroup. And we cannot put an upper bound on the number of
those queues. Those queues can consume system resources in proportion
to their number, causing the performance of groups to suffer. If we
have "hidden group", we can configure it to a small weight, and that
would limit the impact these queues in root group can have.

>>
>> Thanks
>> Vivek
>>
>>
>
>
