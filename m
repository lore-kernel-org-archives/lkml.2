Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031521Ab2CPU0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:26:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41516 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab2CPU0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:26:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6651"; a="170946853"
Message-ID: <4F63A1F6.7070700@codeaurora.org>
Date: Fri, 16 Mar 2012 13:26:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] firmware_class: Move request_firmware_nowait() to workqueues
References: <1331841015-26684-1-git-send-email-sboyd@codeaurora.org> <201203152331.14314.rjw@sisk.pl> <4F6299D9.9000004@codeaurora.org> <201203162119.05382.rjw@sisk.pl>
In-Reply-To: <201203162119.05382.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/12 13:19, Rafael J. Wysocki wrote:
> On Friday, March 16, 2012, Stephen Boyd wrote:
>> On 03/15/12 15:31, Rafael J. Wysocki wrote:
>>> On Thursday, March 15, 2012, Stephen Boyd wrote:
>>>> On 03/15/12 13:07, Christian Lamparter wrote:
>>>>> On Thursday, March 15, 2012 08:50:15 PM Stephen Boyd wrote:
>>>>>> Oddly enough a work_struct was already part of the firmware_work
>>>>>> structure but nobody was using it. Instead of creating a new
>>>>>> kthread for each request_firmware_nowait() just schedule the work
>>>>>> on the system workqueue. This should avoid some overhead in
>>>>>> forking new threads when they're not strictly necessary if
>>>>>> workqueues are available.
>>>>>>
>>>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>> Cc: Kay Sievers <kay.sievers@vrfy.org>
>>>>>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>>>>>> ---
>>>>>>
>>>>>> I saw this while looking at this problem we're having.
>>>>> Correct me if I'm wrong, but wouldn't that stall all other
>>>>> global workqueue tasks for up to 60 seconds [in worst case]?
>>>>>
>>>>> But I think we can get rid of the firmware_work work struct...
>>>>>
>>>> My understanding is that with concurrency managed workqueues when the
>>>> work item blocks another will be scheduled to run almost immediately. So
>>>> before that change by Tejun workqueues would have been a bad idea
>>>> because it could have blocked up to 60 second but now it should be fine
>>>> because that work item will just be put to sleep and another request
>>>> will run.
>>> Please read the description of system_wq in workqueue.h.
>>>
>>> You should have used either system_long_wq or system_nrt_wq (depending on
>>> what you really need).
>>>
>>>
>> Thanks. I think we can use system_nrt_wq then? Or maybe even the
>> unbounded workqueue system_unbound_wq?
> Hmm.  Can you please remind me what the exact role of that work item is?
>
> It loads the device's firmware, but I'm not sure in what situations that's
> supposed to happen.
>

request_firmware_nowait() is used by code that wants to get the firmware
asynchronously. Callers pass in a callback function which is called once
the firmware is retrieved. The work item will correspond to one call to
request_firmware_nowait(), where the work item will handle the sysfs
entry generation, uevent generation, and wait_for_completion() calls
that _request_firmware() does.

The work item also executes the callback function the caller passes in
which could do probably anything and could take an arbitrarily long
time. It looks like some drivers even chain request_firmware_nowait()
together by calling request_firmware_nowait() from the callback functions.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

