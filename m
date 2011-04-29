Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab1D2Q4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:56:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab1D2Q4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cM5/SPSWpmmCDBf6wZq6uyKkvXgZvl+5BSp0JQrbMdvdFRYZQt9wWknuc+PnRKeCOn
         TM/tot33AbCxPoPkJbKw==
MIME-Version: 1.0
In-Reply-To: <BANLkTimm3xFfViZmN3=zkHLtFSNHqZ97sA@mail.gmail.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
 <m3tydi6ehc.fsf@IBM-009124035060.in.ibm.com> <m3wriey4tw.fsf@IBM-009124035060.in.ibm.com>
 <20110428121244.GA26851@linux.vnet.ibm.com> <BANLkTimKUSGU_8YzBMQcf2tH4tJ7-o6eBg@mail.gmail.com>
 <BANLkTikhAF=nzJA4qg_8By=CL6t9iFPQwg@mail.gmail.com> <BANLkTimm3xFfViZmN3=zkHLtFSNHqZ97sA@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 29 Apr 2011 09:55:30 -0700
Message-ID: <BANLkTike13kSZz=OZV-HdmzHL9v-m1evyw@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
To: Nikhil Rao <ncrao@google.com>
Cc: vatsa@linux.vnet.ibm.com, "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 2:27 PM, Nikhil Rao <ncrao@google.com> wrote:
> On Thu, Apr 28, 2011 at 11:51 AM, Paul Turner <pjt@google.com> wrote:
>> On Thu, Apr 28, 2011 at 11:33 AM, Nikhil Rao <ncrao@google.com> wrote:
>>> On Thu, Apr 28, 2011 at 5:12 AM, Srivatsa Vaddagiri
>>> <vatsa@linux.vnet.ibm.com> wrote:
>>>> On Thu, Apr 28, 2011 at 05:18:27PM +0530, Nikunj A. Dadhania wrote:
>>>>> --- kernel/sched.c.orig       2011-04-28 16:34:24.000000000 +0530
>>>>> +++ kernel/sched.c    2011-04-28 16:36:29.000000000 +0530
>>>>> @@ -1336,7 +1336,7 @@ calc_delta_mine(unsigned long delta_exec
>>>>>                       lw->inv_weight = 1 + (WMULT_CONST - w/2) / (w + 1);
>>>>>       }
>>>>>
>>>>> -     tmp = (u64)delta_exec * weight;
>>>>> +     tmp = (u64)delta_exec * (weight >> SCHED_LOAD_RESOLUTION);
>>>>
>>>> Should we be fixing inv_weight rather to account for SCHED_LOAD_RESOLUTION here?
>>>>
>>>
>>> Yes, I have been looking into fixing inv_weight and calc_delta_mine()
>>> calculations based on the assumption that we have u64 weights. IMO the
>>> function is complicated because the return value needs to be
>>> calculated to fit into unsigned long. I would like to update users of
>>> calc_delta_mine() to use u64 instead of unsigned longs and I think
>>> this can be easily done (quick inspection of the code shows two call
>>> sites that need to be updated - update_curr() and wakeup_gran()).
>>> Without the restriction to fit into unsigned long, I think we can make
>>> calc_delta_mine() and the inv_weight calculations simpler.
>>>
>>
>> I don't think you have much room to maneuver here, the calculations in
>> c_d_m() are already u64 based, even on 32bit.  Changing the external
>> load factors to 64 bit doesn't change this.
>>
>> We lose fairness in cdm beyond 32 bits, at the old LOAD_SCALE=10
>> you've got 22 bits with which you can maintain fairness. This gives
>> total accuracy in total curr on any delta <= ~4ms (for a NICE_0 task).
>>  If you bump this up (and don't downshift before computing the inverse
>> as you are) then you start introducing rounding errors beyond ~4us.
>>
>> This would also be further exacerbated in sched_period() since that's
>> using the total cfs_rq weight.
>>
>
> Hmm... yeah, I think you have nicely explained the problem at hand. As
> you said, we can't bump up inv_weight without losing accuracy. We want
> to keep the 32-bit bound because it avoids the division. I was
> exploring other optimizations in this functions, but I think what Paul
> pointed out is key here.
>

Correcting myself a tiny bit here:  the 32 bit inverse covers the load
weight, at 28 bit load weights it's this (the inverse) that goes to
hell not the numerator (time).  The end effect of mushy fairness is
the same.

> -Thanks
> Nikhil
>
>>> -Thanks,
>>> Nikhil
>>>
>>
>
