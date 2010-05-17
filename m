Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0EQWve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:51:34 -0400
Received: from crca.org.au ([74.207.252.120]:36757 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0EQWvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:51:33 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BF1C86B.8000203@crca.org.au>
Date: Tue, 18 May 2010 08:51:23 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Matt Reimer <mattjreimer@gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
References: <Pine.LNX.4.44L0.1005162219330.24400-100000@netrider.rowland.org> <4BF0F3FF.2010603@crca.org.au> <201005172235.37824.rjw@sisk.pl>
In-Reply-To: <201005172235.37824.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 18/05/10 06:35, Rafael J. Wysocki wrote:
> On Monday 17 May 2010, Nigel Cunningham wrote:
>> On 17/05/10 12:22, Alan Stern wrote:
>>> On Mon, 17 May 2010, Nigel Cunningham wrote:
>>>>>> I object to the patch.
>>>>>>
>>>>>> Tell the patch it ought to exit once thawed, by all means.
>>>>>
>>>>> I'm not sure what you mean.  Care to explain?
>>>>
>>>> I mean "Set up some sort of flag that it can look at once thawed at
>>>> resume time, and use that to tell it to exit at that point."
>>>
>>> Doesn't the patch do exactly that?  The "flag" is set by virtue of the
>>> fact that this is part of del_gendisk -- which means the disk is being
>>> unregistered and hence the writeback thread will exit shortly.
>>>
>>>>>> Make the patch unfreezeable to begin with, by all means.
>>>>>
>>>>> That wouldn't work.
>>>>
>>>> Why not?
>>>
>>> It would be nice to know exactly why.  Perhaps the underlying problem
>>> can be fixed.
>>>
>>>>>> If you know a disk is going to be unregistered during resume,
>>>>>
>>>>> How do we check that, exactly?
>>>>
>>>> Well, if you can figure out that you need to go down this path at this
>>>> point in the process, you must be able to apply the same logic to come
>>>> to the same conclusion earlier in the process.
>>>
>>> That's not true.  You don't know that a device is going to be unplugged
>>> until it actually _is_ unplugged.
>>
>> Sorry - I got unregistered during suspend (instead of resume) in my
>> head. That said, I'd argue that we should be...
>>
>> 1) Syncing all the data at the start of the suspend/hibernate, so
>> there's nothing for the workthread to do if we do del_gendisk.
>> 2) Telling things to exit if we do find the device is gone away at
>> resume time, but not relying on the going-away happening until post
>> process thaw, for a couple of reasons:
>> - Potential for races/confusion/mess etc in having $random process
>> thawing other processes. Only the thread doing the suspend/hibernate
>> should be freezing/thawing.
>
> I don't see a problem here, as far as kernel threads are concerned.  In this
> particular case this is a subsystem thawing a thread that belongs to it.  No
> problem.
>
>> - We're dealing with the symptom, not the cause. Almost always a bad idea.
>
> I very much prefer to have a fix for a symptom than no fix at all, which is the
> realistic alternative in this case.
>
> So, I think we should merge the patch and if someone finds the root cause
> at one point in future, then we can just use the *right* approach instead of
> the present one.
>
> The problem is real and people in the field are affected by it, so if you don't
> have a working alternative patch, please just let go.

I'm not denying that the problem is real. What I am concerned about is 
finding a real solution, not just putting a sticky plaster over the 
wound. It seems to me to be much wiser to deal with the issue properly 
now instead of doing extra work later to diagnose what might be a harder 
to reproduce symptom of the same problem. I'd happily put the time in 
now myself, but I simply don't have the time this week.

Would it be possible to apply the patch, adding some sort of new tag 
that can be used to say "This needs further attention", perhaps 
including an enduring reference to this conversation. Later, the 'real' 
fix could include another special tag that says "Proper fix for the 
symptom addressed in commit 5e94f810"?

Regards,

Nigel
