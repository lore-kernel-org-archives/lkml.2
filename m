Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1CYFnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 01:43:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61451 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab1CYFnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 01:43:22 -0400
Message-ID: <4D8C2B90.1090800@cn.fujitsu.com>
Date: Fri, 25 Mar 2011 13:43:44 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Chad Talbott <ctalbott@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>	<20110322150905.GD3757@redhat.com>	<AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>	<20110322181231.GJ3757@redhat.com>	<AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>	<20110323204146.GK13315@redhat.com> <AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
In-Reply-To: <AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-25 13:41:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-25 13:41:45
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chad Talbott wrote:
> On Wed, Mar 23, 2011 at 1:41 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Wed, Mar 23, 2011 at 01:10:32PM -0700, Chad Talbott wrote:
>>> On Tue, Mar 22, 2011 at 11:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>>> On Tue, Mar 22, 2011 at 10:39:36AM -0700, Chad Talbott wrote:
>>>>> On Tue, Mar 22, 2011 at 8:09 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>>>>> Why not just implement simply RT class groups and always allow an RT
>>>>>> group to preempt an BE class. Same thing we do for cfq queues. I will
>>>>>> not worry too much about a run away application consuming all the
>>>>>> bandwidth. If that's a concern we could use blkio controller to limit
>>>>>> the IO rate of a latency sensitive applicaiton to make sure it does
>>>>>> not starve BE applications.
>>>>> That is not quite the same semantics. �This limited preemption patch
>>>>> is still work-conserving. �If the RT task in the only task on the
>>>>> system with IO, it will be able to use all available disk time.
>>>>>
>>>> It is not same semantics but it feels like too much of special casing
>>>> for a single use case.
>>> How are you counting use cases?
>> This is the first time I have heard this requirement. So if 2-3 different
>> folks come up with similar concern, then I have idea an idea that this
>> is a generic need.
>>
>> You also have not explained what is the workload and what are the
>> acceptable latencies etc.
>>
>>>> You are using the generic notion of a RT thread (which in general means
>>>> that it gets all the cpu or all the disk ahead of BE task). But you have
>>>> changed the definition of RT for this special use case. And also now
>>>> group RT is different from queue RT definition.
>>> Perhaps the name RT has too much of a "this group should be able to
>>> starve all other groups" connotation. �Is there a better name? �Maybe
>>> latency sensitive?
>> I think what you are trying to achieve is that you want to define an
>> additional task and group property, say latency sensitive. This is
>> third property apart from ioclass and ioprio. To me you still want
>> the task/group to be BE class so that it shares the disk in a
>> proportional weight manner but this additional property will make sure
>> that task can preempt the non latency sensitive task/group.
>>
>> We can't do this additional property for group alone because once we
>> move to hierarhical setup and everything is entity (be it task or queue)
>> and then we need to decide whether one entity can preempt another
>> entity or not. By not definining this property for tasks, latency
>> sensitive group will always preempt a task on same tree. (May be
>> that's what you want for your use case). But it is still odd to add
>> additional properties only for groups and not tasks.
> 
> You raise a good point about hierarchy.  We'd like to use Gui's
> hierarchy patches or similar functionality.  As you point out there is
> currently an asymmetry between groups and tasks.  Tasks can be RT, but
> groups cannot.  This complicates the hierarchy implementation.
> 
> How about adding a blkio.class and blkio.class_device interface to a
> truly RT service class?  This class would be able to starve a BE class
> (thus be more like the traditional RT/BE divide), and could be
> implemented similarly to RT/BE cfqqs today.  This way groups and
> queues could easily be scheduled as peers.

For the current "cfq group hierarchy" implementation, I just put cfqg on
the "BE:SYNC" workload tree for the sake of simplicity. I think we need
to implement ioclass for cfq group for supporting *fully* hierarchical
scheduling.

Gui
