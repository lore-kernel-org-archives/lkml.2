Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031093Ab2CNXRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:17:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13945 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2CNXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:17:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6649"; a="170248624"
Message-ID: <4F612706.4060407@codeaurora.org>
Date: Wed, 14 Mar 2012 16:17:26 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper
 is not yet available
References: <201203032122.36745.chunkeey@googlemail.com> <4F60EFBB.5050703@codeaurora.org> <201203150004.17076.rjw@sisk.pl> <201203150013.45749.rjw@sisk.pl>
In-Reply-To: <201203150013.45749.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/12 16:13, Rafael J. Wysocki wrote:
> On Thursday, March 15, 2012, Rafael J. Wysocki wrote:
>> On Wednesday, March 14, 2012, Stephen Boyd wrote:
>>> On 03/13/12 13:14, Rafael J. Wysocki wrote:
>>>> All of those use cases are in fact of the "wait for user space to be thawed
>>>> and then load the firmware" type, which I believe may be handled without
>>>> changing that code.
>>>>
>>>> Why don't you make your kthread freezable, for one example?
>>>>
>>>> Why don't you use a freezable workqueue instead?
>>>>
>>> If we put it on the freezable workqueue or make it a freezable thread
>>> will it work?
>> That depends on what exactly you want to achieve, which isn't entirely clear
>> to me at this point.
>>
>>> In my scenario a wakeup interrupt comes in that wakes us up from
>>> suspend. Within that wakeup handler a work item is scheduled to the
>>> freezable workqueue. That work item then calls request_firmware().
>> That should work.
>>
>>> It looks like we call schedule() after thawing the workqueues and tasks
>>> so the work item could run before usermodehelpers are enabled and then
>>> request_firmware() would fail. Do we need something like this (ignore
>>> the fact that we call usermodhelper_enable() twice)?
>>>
>>> diff --git a/kernel/power/process.c b/kernel/power/process.c
>>> index 7e42645..61bfa95 100644
>>> --- a/kernel/power/process.c
>>> +++ b/kernel/power/process.c
>>> @@ -187,6 +187,7 @@ void thaw_processes(void)
>>>         } while_each_thread(g, p);
>>>         read_unlock(&tasklist_lock);
>>>  
>>> +       usermodehelper_enable();
>> That would be a reasonable change.
>>
>>>         schedule();
>>>         printk("done.\n");
>>>  }
>>>
>>>
>>> Is there a reason we disable usermodehelpers if
>>> CONFIG_SUSPEND_FREEZER=n?
>> Not really, but CONFIG_SUSPEND_FREEZER=n can only work reliably in a
>> very limited set of cases, so I don't think it's even worth making the
>> general code depend on it.
>>
>> I'd actually prefer to remove CONFIG_SUSPEND_FREEZER altogether,
>> because it's not very useful nowadays (probably isn't useful at all).
>>
>>> Should we do this instead so that
>>> usermodehelpers are only disabled if we freeze userspace? Also what is
>>> that schedule() call in thaw_kernel_threads() for? It looks like we'll
>>> call schedule between kernel thread thawing and userspace thawing.
>> Which is OK, I think.
> Moreover, thaw_kernel_threads() is _only_ called by (a) freeze_kernel_threads()
> on error and (b) user-space hibernate interface in kernel/power/user.c
> (and please read the comment in there describing what it's there for, which
> also explains why the schedule() call in there is necessary).

Exactly. So in case (a) when the error occurs we'll have this call flow:

usermodehelpers_disable()
suspend_freeze_processes()
    freeze_processes()
    freeze_kernel_threads()
        try_to_freeze_tasks() <-- returns error
        thaw_kernel_threads()
            schedule()
    thaw_processes()
usermodehelpers_enable()

Shouldn't we schedule only after we thaw all processes (not just tasks)?
Otherwise we may run a kernel thread before userspace is thawed?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

