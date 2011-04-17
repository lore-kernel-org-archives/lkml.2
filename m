Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1DQJGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:06:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1DQJGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CK/fEfyW9l5vPyYMOMtS53xyvVPLrutf7zW5P3x9bj6bnn9Y4HyeB05+Dvo2kLea9i
         xTdeVDREFACi43KKwINQ==
MIME-Version: 1.0
In-Reply-To: <20110417084432.GM31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	<1302913676-14352-5-git-send-email-robert.richter@amd.com>
	<BANLkTikg5mJNDTqNMRz3AtjfnAa6mLdtHw@mail.gmail.com>
	<20110417084432.GM31407@erda.amd.com>
Date: Sun, 17 Apr 2011 02:05:47 -0700
Message-ID: <BANLkTik-NNny1TQroMmLKpZA-q8HshXBUg@mail.gmail.com>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 1:44 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 16.04.11 11:52:54, Stephane Eranian wrote:
>> On Fri, Apr 15, 2011 at 5:27 PM, Robert Richter <robert.richter@amd.com> wrote:
>
>> >        event code      counter         failure         possible solution
>> >
>> > 1)      0x043           PMC[2:0]        0               1
>> >        0x02E           PMC[3,0]        3               0
>> >        0x003           PMC3            FAIL            3
>> >
>> I am not sure I understand this failure case. If I recall
>> the scheduler looks at the weight of each event first:
>>
>>                                             weight
>> 1)      0x043           PMC[2:0]  3
>>         0x02E           PMC[3,0]   2
>>         0x003           PMC3        1
>>
>> Then, it schedules in increasing weight order. So it will
>> schedule weight 1, 2, 3. For weight 1, it will find counter3,
>> for weight 2, it will take counter0, for  weight 3, it will
>> take counter 1 given 0 is already used.
>>
>> Or am I reading your example the wrong way?
>
> No, I have to admit this one was taken out of my mind and I picked
> a wrong example for the special problem I was thinking about. The
> above works as you described because of the constraint's weights.
>
> I don't have an example with existing constraints, but consider the
> following (theoretical) one:
>
> counter: 3210           Failure:        Solution:
>
> e1         xx             xo              ox
> e2        xx             xo              ox
> e3       x x            o x             o x
> e4       x  x           x  F            x  o
>
> The special with the above is that two events (e1 and e2) must be
> rescheduled to schedule e4. This means that swapping counters of only
> one already scheduled event is not sufficient. A counter of a third
> event must be freed, this counter is then taken by the second event.

Ok, I understand this one better now. But you admit yourself, you made it
up. Is it even possible with Fam15h?

The thing is, I think, this is not a catastrophic problem. What will
happen is that
e4 cannot be scheduled with e1, e2, e3. In case the events are not in the same
group, e4 will eventually get a chance to be scheduled due to round-robin on
the event list. In case, the events are all in one group, then you won't be able
to add e4 to the group because of group scheduling sanity check on creation.
So either you have to shuffle your event groups or you will incur multiplexing.
It's not like e4 will be created but it will nerver be able to count anything.



>> The fact that counter have overlapping constraints
>> should not matter. In fact this is what happens with
>> counters without constraints.
>
> An event set containing constraints with following conditions is
> problematic:
>
>  (c1->weight <= c2->weight && (c1->cmask & c2->cmask != c1->cmask))
>
> Basically this means both constraints do not overlap completly. You
> can't select then the correct counter without knowing the events with
> higher weights that will be scheduled later.
>
> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
>
