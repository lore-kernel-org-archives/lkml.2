Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1H3InG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 04:43:06 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:37976 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab1H3InA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 04:43:00 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Aug 2011 04:42:59 EDT
Date: Tue, 30 Aug 2011 08:37:45 +0000
From: Shen Canquan <shencanquan@huawei.com>
Subject: Re: console_cpu_notify can cause scheduling BUG during CPU hotplug
X-Originating-IP: [10.166.80.171]
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: hanweidong <hanweidong@huawei.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>
Message-id: <F1F5DF04259F1B4A82BD6BDE1C479F740981A5B4@szxeml527-mbs.china.huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Accept-Language: zh-CN, en-US
Thread-topic: console_cpu_notify can cause scheduling BUG during CPU hotplug
Thread-index: Acxm7EEaFpv/Qxa6Sb+H2bsMUBIwmQ==
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike ,
     I found the previous email about "console_cpu_notify can cause scheduling BUG during CPU hotplug" .  
Now I have the same problem . My test enviroment is the following:
I am in xen virtualization environment. and I install the lastest stable kernel(linux 3.0.3) in domU . When I use the 
xm vcpu-set <n> to test vcpu add and remove function . and when I run the above command more than 100 times. 
and use the top tool to look the cpu info. It will hang of linux.
   When I dump the core of linux kernel and analyse it , I found the reason is the same of this email.
    Can you tell me the progress of this problem. Thanks.

---------
On 4/30/2011 1:38 AM, Borislav Petkov wrote: 
> On Wed, Apr 27, 2011 at 03:12:19PM -0700, Michael Bohan wrote: 
>> On 4/27/2011 12:38 AM, Borislav Petkov wrote: 
>>> Great, whatever you guys come up with, we'd like to give it a run too. 
>>> We (AMD) hit the same issue in one of our tests but in our case we end 
>>> up in an endless loop of the state machine at stop_machine_cpu_stop() 
>>> since the core being offlined cannot ack the state transition to 
>>> STOPMACHINE_EXIT due to a similar reason. 
>>> 
>>> One possible fix is dropping CPU_DYING from console_cpu_notify() 
>>> since it is called into by the offlining path in 
>>> kernel/cpu.c::take_cpu_down(). 
>> 
>> This seems to be a different problem. Could you elaborate about why 
>> removing CPU_DYING from console_cpu_notify resolves your problem? 
> 
> Ok, I have to admit, I haven't spent a whole lot of time debugging this 
> but here's what I know: 
> 
> First of all, how we trigger this? Our crazy testers have a script that 
> takes cores off- and online in a random manner repeatedly and, if you go 
> to another tty and do 'dmesg' in the same time, you can be absolutely 
> sure that after a few times, you end up in the endless loop scenario 
> above. 
Our test scenario is similar to this. In the crash I reported, there 
needs to be contention for the console semaphore to trigger the BUG(). 
I get the impression that this sort of scenario is not tested 
extensively in Linux. Otherwise I think others would have reported the 
BUG I hit. 
> Wait... I'm looking at the code now and it looks like Tejun changed the 
> state machine implementation (3fc1f1e27a5b807791d72e5d992aa33b668a6626) 
> so we'll have to retest to see whether this still happens. 
Tejen's change (3fc1f1e27a5b807791d72e5d992aa33b668a6626) was first in 
v2.6.35, so it looks like you're using a pretty old kernel. Kevin's 
change (034260d6779087431a8b2f67589c68b919299e5c) was not in until 
v2.6.36, so therefore I'm a bit confused what code base you're running. 
You mentioned before that one possible fix is dropping CPU_DYING from 
console_cpu_notify, but based on what you said, it doesn't seem like 
your kernel should be new enough have this functionality. Did you 
cherry-pick Kevin's change on top of an older code base? If so, that is 
likely dangerous. 
Please keep me in loop with your findings on a more recent kernel. 
> Can you trigger your crash with latest kernel too? 
The latest I've tested is v2.6.38, but the code related to blocking on 
the console semaphore with preemption disabled does not appear changed 
on the most recent code base. 
Thanks, 
Mike 
