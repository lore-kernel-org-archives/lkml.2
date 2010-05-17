Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0EQHpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:45:18 -0400
Received: from crca.org.au ([74.207.252.120]:39180 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab0EQHpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:45:16 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BF0F3FF.2010603@crca.org.au>
Date: Mon, 17 May 2010 17:45:03 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Matt Reimer <mattjreimer@gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
References: <Pine.LNX.4.44L0.1005162219330.24400-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005162219330.24400-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 17/05/10 12:22, Alan Stern wrote:
> On Mon, 17 May 2010, Nigel Cunningham wrote:
>
>>>> I object to the patch.
>>>>
>>>> Tell the patch it ought to exit once thawed, by all means.
>>>
>>> I'm not sure what you mean.  Care to explain?
>>
>> I mean "Set up some sort of flag that it can look at once thawed at
>> resume time, and use that to tell it to exit at that point."
>
> Doesn't the patch do exactly that?  The "flag" is set by virtue of the
> fact that this is part of del_gendisk -- which means the disk is being
> unregistered and hence the writeback thread will exit shortly.
>
>>>> Make the patch unfreezeable to begin with, by all means.
>>>
>>> That wouldn't work.
>>
>> Why not?
>
> It would be nice to know exactly why.  Perhaps the underlying problem
> can be fixed.
>
>>>> If you know a disk is going to be unregistered during resume,
>>>
>>> How do we check that, exactly?
>>
>> Well, if you can figure out that you need to go down this path at this
>> point in the process, you must be able to apply the same logic to come
>> to the same conclusion earlier in the process.
>
> That's not true.  You don't know that a device is going to be unplugged
> until it actually _is_ unplugged.

Sorry - I got unregistered during suspend (instead of resume) in my 
head. That said, I'd argue that we should be...

1) Syncing all the data at the start of the suspend/hibernate, so 
there's nothing for the workthread to do if we do del_gendisk.
2) Telling things to exit if we do find the device is gone away at 
resume time, but not relying on the going-away happening until post 
process thaw, for a couple of reasons:
- Potential for races/confusion/mess etc in having $random process 
thawing other processes. Only the thread doing the suspend/hibernate 
should be freezing/thawing.
- We're dealing with the symptom, not the cause. Almost always a bad idea.

Regards,

Nigel
