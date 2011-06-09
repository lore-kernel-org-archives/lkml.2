Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1FIJJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:09:41 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:50680 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1FIJJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:09:40 -0400
X-AuditID: c1b4fb3d-b7c17ae00000262e-dc-4df08dd2ad4e
Date: Thu, 9 Jun 2011 11:23:06 +0200
From: Nils Carlson <nils.carlson@ericsson.com>
X-X-Sender: nils@as68123.uab.ericsson.se
To: Andrew Morton <akpm@linux-foundation.org>
CC: "clemens@ladisch.de" <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix periodic-emulation in HPET for delayed interrupts
In-Reply-To: <20110608143801.f494fa3e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1106091107110.11959@as68123.uab.ericsson.se>
References: <1306929530-23771-1-git-send-email-nils.carlson@ericsson.com> <20110608143801.f494fa3e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Jun 2011, Andrew Morton wrote:

> On Wed, 1 Jun 2011 13:58:50 +0200
> Nils Carlson <nils.carlson@ericsson.com> wrote:
>
>> When interrupts are delayed due to interrupt masking or due
>> to other interrupts being serviced the HPET periodic-emuation
>> would fail. This happened because given an interval t and
>> a time for the current interrupt m we would compute the next
>> time as t + m. This works until we are delayed for > t, in
>> which case we would be writing a new value which is in fact
>> in the past.
>>
>> This can be solved by computing the next time instead as
>> (k * t) + m where k is large enough to be in the future.
>> The exact computation of k is described in a comment to
>> the code.
>>
>> ...
>>
>> +		/* The time for the next interrupt would logically be t + m,
>> +		 * however, if we are very unlucky and the interrupt is delayed
>> +		 * for longer than t then we will completely miss the next
>> +		 * interrupt if we set t + m and an application will hang.
>
> Strange.  Normally when hardware generates an interrupt it doesn't get
> "missed".  It just sits there pending until the CPU accepts it.
Maybe missed is a misnomer.

I'll try to explain. Assuming an interval of 5 between each expected 
interrupt we have a normal case of

t0: interrupt, read t0 from comparator, set next interrupt t0 + 5
t5: interrupt, read t5 from comparator, set next interrupt t5 + 5
t10: interrupt, read t10 from comparator, set next interrupt t10 + 5
...

So, what happens when the interrupt is serviced too late?

t0: interrupt, read t0 from comparator, set next interrupt t0 + 5
t11: delayed interrupt serviced, read t5 from comparator, set next 
interrupt t5 + 5, which is in the past!
... counter loops ...
t10: Much much later, get the next interrupt.

This can happen either because we have interrupts masked for too long 
(some stupid driver goes on a printk rampage) or just because we are 
pushing the limits of the interval (too small a period), or both most 
probably.

My solution is to read the main counter as well and set the next interrupt 
to occur at the right interval, for example:

t0: interrupt, read t0 from comparator, set next interrupt t0 + 5
t11: delayed interrupt serviced, read t5 from comparator, set next 
interrupt t15 as t10 has been missed.
t15: back on track.
...

I see this problem only in serious stress tests, but the fix is quite 
trivial when you understand it so I'd be happy to see it applied. Of 
course, nothing says that this is the right fix (other than me). :-)

/Nils



> What exactly causes this interrupt to be "delayed"?  Are you referring
> to the CPU disabling local interrupts for too long, or something else?
>
> And why does this delay cause the interrupt to be completely missed?
>
> IOW, is the hpet hardware as busted as it sounds? ;)
>
> And how serious is this bug?  Can the fix be delayed until 3.1, or is it
> needed in 3.0?  2.6.x.y?
>
