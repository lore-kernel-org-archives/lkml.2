Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1IEIfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 04:35:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:46656 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1IEIfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 04:35:31 -0400
Date: Mon, 05 Sep 2011 16:34:51 +0800
From: "canquan.shen" <shencanquan@huawei.com>
Subject: Re: console_cpu_notify can cause scheduling BUG during CPU hotplug
In-reply-to: <F1F5DF04259F1B4A82BD6BDE1C479F740981A5B4@szxeml527-mbs.china.huawei.com>
X-Originating-IP: [10.166.80.171]
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: hanweidong <hanweidong@huawei.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        mbohan@quicinc.com, petkovbb@gmail.com
Message-id: <4E6489AB.2050906@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.1) Gecko/20110830
 Thunderbird/6.0.1
X-CFilter-Loop: Reflected
References: <F1F5DF04259F1B4A82BD6BDE1C479F740981A5B4@szxeml527-mbs.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi mbohan and petkovbb,
    The dead lock scenario is the following:
    In my test enviroment. It has two cpus. cpu#0 just complete to run 
the following stack(in top tool).
  #0 [ffff880079223b68] schedule at ffffffff813acda2
  #1 [ffff880079223cb0] __cond_resched at ffffffff8104a3f5
  #2 [ffff880079223cd0] _cond_resched at ffffffff813ad56d
  #3 [ffff880079223ce0] console_conditional_schedule at ffffffff813ad5cd
  #4 [ffff880079223cf0] do_con_write at ffffffff8127ed24
  #5 [ffff880079223de0] con_write at ffffffff81281109
  #6 [ffff880079223e00] n_tty_write at ffffffff8126bd40
  #7 [ffff880079223ea0] tty_write at ffffffff81268530
  #8 [ffff880079223f10] vfs_write at ffffffff811124db
  #9 [ffff880079223f40] sys_write at ffffffff81112680
#10 [ffff880079223f80] system_call_fastpath at ffffffff813b5812
   It has locked the console_sem in console_lock function(do_con_write 
call the console_lock). and it does not unlock the  console_sem because 
it run sheduler function (because it check need_schedule flag) before unlock
   And then cpu remove has happened. all cpu execute the 
stop_machine_cpu_stop in cpu_stopper_thread. In the 
stop_machine_cpu_stop function. cpu#0 is warting cpu#1 run compelte, but 
cpu#1 has schedule because it wait for console_sem lock. please see the 
following stack.

  #0 [ffff88007afd3ae0] schedule at ffffffff813acda2
  #1 [ffff88007afd3c28] schedule_timeout at ffffffff813ad785
  #2 [ffff88007afd3cc8] __down at ffffffff813ae621
  #3 [ffff88007afd3d18] down at ffffffff81072587
  #4 [ffff88007afd3d38] console_lock at ffffffff81051977
  #5 [ffff88007afd3d48] console_cpu_notify at ffffffff813a7650
  #6 [ffff88007afd3d58] notifier_call_chain at ffffffff813b2cdf
  #7 [ffff88007afd3d98] __raw_notifier_call_chain at ffffffff810726d9
  #8 [ffff88007afd3da8] take_cpu_down at ffffffff81395a75
  #9 [ffff88007afd3dc8] stop_machine_cpu_stop at ffffffff8109df7e
#10 [ffff88007afd3df8] cpu_stopper_thread at ffffffff8109de1d
#11 [ffff88007afd3ee8] kthread at ffffffff8106cff6
#12 [ffff88007afd3f48] kernel_thread_helper at ffffffff813b6944

  However the console_sem lock is wait for cpu#0 to unlock. it cause 
dead lock.

--
canquan.shen


On 2011/8/30 16:37, Shen Canquan wrote:
> Hi Mike ,
>       I found the previous email about "console_cpu_notify can cause scheduling BUG during CPU hotplug" .
> Now I have the same problem . My test enviroment is the following:
> I am in xen virtualization environment. and I install the lastest stable kernel(linux 3.0.3) in domU . When I use the
> xm vcpu-set<n>  to test vcpu add and remove function . and when I run the above command more than 100 times.
> and use the top tool to look the cpu info. It will hang of linux.
>     When I dump the core of linux kernel and analyse it , I found the reason is the same of this email.
>      Can you tell me the progress of this problem. Thanks.
>
> ---------
> On 4/30/2011 1:38 AM, Borislav Petkov wrote:
>> On Wed, Apr 27, 2011 at 03:12:19PM -0700, Michael Bohan wrote:
>>> On 4/27/2011 12:38 AM, Borislav Petkov wrote:
>>>> Great, whatever you guys come up with, we'd like to give it a run too.
>>>> We (AMD) hit the same issue in one of our tests but in our case we end
>>>> up in an endless loop of the state machine at stop_machine_cpu_stop()
>>>> since the core being offlined cannot ack the state transition to
>>>> STOPMACHINE_EXIT due to a similar reason.
>>>>
>>>> One possible fix is dropping CPU_DYING from console_cpu_notify()
>>>> since it is called into by the offlining path in
>>>> kernel/cpu.c::take_cpu_down().
>>>
>>> This seems to be a different problem. Could you elaborate about why
>>> removing CPU_DYING from console_cpu_notify resolves your problem?
>>
>> Ok, I have to admit, I haven't spent a whole lot of time debugging this
>> but here's what I know:
>>
>> First of all, how we trigger this? Our crazy testers have a script that
>> takes cores off- and online in a random manner repeatedly and, if you go
>> to another tty and do 'dmesg' in the same time, you can be absolutely
>> sure that after a few times, you end up in the endless loop scenario
>> above.
> Our test scenario is similar to this. In the crash I reported, there
> needs to be contention for the console semaphore to trigger the BUG().
> I get the impression that this sort of scenario is not tested
> extensively in Linux. Otherwise I think others would have reported the
> BUG I hit.
>> Wait... I'm looking at the code now and it looks like Tejun changed the
>> state machine implementation (3fc1f1e27a5b807791d72e5d992aa33b668a6626)
>> so we'll have to retest to see whether this still happens.
> Tejen's change (3fc1f1e27a5b807791d72e5d992aa33b668a6626) was first in
> v2.6.35, so it looks like you're using a pretty old kernel. Kevin's
> change (034260d6779087431a8b2f67589c68b919299e5c) was not in until
> v2.6.36, so therefore I'm a bit confused what code base you're running.
> You mentioned before that one possible fix is dropping CPU_DYING from
> console_cpu_notify, but based on what you said, it doesn't seem like
> your kernel should be new enough have this functionality. Did you
> cherry-pick Kevin's change on top of an older code base? If so, that is
> likely dangerous.
> Please keep me in loop with your findings on a more recent kernel.
>> Can you trigger your crash with latest kernel too?
> The latest I've tested is v2.6.38, but the code related to blocking on
> the console semaphore with preemption disabled does not appear changed
> on the most recent code base.
> Thanks,
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> .
>


