Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2FLEIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 00:08:16 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:58376 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab2FLEHf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 00:07:35 -0400
MIME-Version: 1.0
In-Reply-To: <4c35449ed272eb5831cf2f8765eeeb48.squirrel@www.codeaurora.org>
References: <1338576911-17089-1-git-send-email-merez@codeaurora.org>
 <1338576911-17089-2-git-send-email-merez@codeaurora.org> <007c01cd455a$56392050$02ab60f0$%jun@samsung.com>
 <780c1dad11fe08de17a3ff41b22ba3b8.squirrel@www.codeaurora.org>
 <CANfBPZ-HukGqES4eUhxfDhLy+Sj6XJEyPu9kgKCAddPnVyoqKA@mail.gmail.com> <4c35449ed272eb5831cf2f8765eeeb48.squirrel@www.codeaurora.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Tue, 12 Jun 2012 09:37:12 +0530
Message-ID: <CANfBPZ9ce-f3FSmv6sFx6-fvpipe2HvZNzWu2=iwr8PNTb7qhQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mmc: block: Add write packing control
To: merez@codeaurora.org
Cc: Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "DOCUMENTATION'" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 1:49 AM,  <merez@codeaurora.org> wrote:
>
>> On Sat, Jun 9, 2012 at 8:16 PM,  <merez@codeaurora.org> wrote:
>>>
>>>> Hi,
>>>>
>>>> How can we check the effect?
>>>> Do you have any result?
>>> We ran parallel lmdd read and write operations and found out that the
>>> write packing causes the read throughput to drop from 24MB/s to 12MB/s.
>>
>> Whoa! That's a big drop.
>> BTW, is there a problem with throughput or latency, or both ?
>> If these numbers are over long duration (>5 seconds), then where are
>> the cycles going?
>> It would be nice to see some blktrace figures for the issue, and then fix
>> it,
>> rather than apply a band aid like the write-packing-control on top..
> I believe this is because the write packing changes the dispatching policy
> of the scheduler. Without write packing only 2 write requests were
> fetched, giving the read requests a chance to be inserted into the
> scheduler while we wait for the completion of the first write request.

Which I/O scheduler are you using ? Both CFQ and deadline would do the
balancing
act to prevent writes overwhelming reads. Writes are async and reads
are sync (usually),
so this imbalance would have existed otherwise, packed command or not.

> Then when the next fetch was performed the read request would be the
> chosen one. When write packing is enabled we keep fetching all the write
> requests that are queued (assuming there are no read requests inserted
> yet) and when the read is inserted and fetched is has to wait for the
> completion of a bigger amount of write requests.
>

Yes - but that should introduce latency, not bandwidth drop - unless you are
using the no-op scheduler.

>>
>>
>>> The write packing control managed to increase the read throughput back
>>> to
>>> the original value.
>>> We also examined "real life" scenarios, such as performing a big push
>>> operation in parallel to launching several applications. We measured the
>>> read latency and found out that with the write packing control the worst
>>> case of the read latency was smaller.
>>>
>>>> Please check the several comment below.
>>>>
>>>> Maya Erez <merez@codeaurora.org> wrote:
>>>>> The write packing control will ensure that read requests latency is
>>>>> not increased due to long write packed commands.
>>>>>
>>>>> The trigger for enabling the write packing is managing to pack several
>>>>> write requests. The number of potential packed requests that will
>>>>> trigger
>>>>> the packing can be configured via sysfs by writing the required value
>>>>> to:
>>>>> /sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
>>>>> The trigger for disabling the write packing is fetching a read
>>>>> request.
>>>>>
>>
>
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>
