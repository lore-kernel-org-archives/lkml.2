Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0JVAPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:15:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0JVAPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QStDIPQxq/vcTnqBsXKK4ioPbS0+ijgV5VlTDvKNyexGBPwZK6xk3gMCN0jnxjWrrD
         7FELxM3xsuJCCG7EYu+Q==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=o63gqA+62fXQ8jwNS=t8hsSgO3DgbvPKRXD4d@mail.gmail.com>
References: <20101016044349.830426011@google.com> <1287258414.1998.133.camel@laptop>
 <AANLkTi=o63gqA+62fXQ8jwNS=t8hsSgO3DgbvPKRXD4d@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 21 Oct 2010 17:14:43 -0700
Message-ID: <AANLkTikoz3q_8AYPn1YSVfSgd7N+aL2ZpD7PQucYdrQX@mail.gmail.com>
Subject: Re: [RFC tg_shares_up improvements - v1 00/12] [RFC tg_shares_up - v1
 00/12] Reducing cost of tg->shares distribution
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 11:36 PM, Paul Turner <pjt@google.com> wrote:
> On Sat, Oct 16, 2010 at 12:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, 2010-10-15 at 21:43 -0700, pjt@google.com wrote:
>>> Hi all,
>>>
>>> Peter previously posted a patchset that attempted to improve the problem of
>>> task_group share distribution.  This is something that has been a long-time
>>> pain point for group scheduling.  The existing algorithm considers
>>> distributions on a per-cpu-per-domain basis and carries a fairly high update
>>> overhead, especially on larger machines.
>>>
>>> I was previously looking at improving this using Fenwick trees to allow a
>>> single sum without the exorbitant cost but then Peter's idea above was better :).
>>>
>>> The kernel is that by monitoring the average contribution to load on a
>>> per-cpu-per-taskgroup basis we can distribute the weight for which we are
>>> expected to consume.
>>>
>>> This set extends the original posting with a focus on increased fairness and
>>> reduced convergence (to true average) time.  In particular the case of large
>>> over-commit in the case of a distributed wake-up is a concern which is now
>>> fairly well addressed.
>>>
>>> Obviously everything's experimental but it should be stable/fair.
>>
>> I like what you've done with it, my only worry is 10/12 where you allow
>> for extra updates to the global state -- I think they should be fairly
>> limited in number, and I can see the need for the update if we get too
>> far out of whack, but it is something to look at while testing this
>> stuff.
>>
>
> So my original answer here was to only update when there was load and
> it was > n% delta which stops 1 thread waking up and sleeping from
> thrashing it, but the 2 thread case is just as obviously broken for
> any n.  It needs a rate limit but I'm sort of loathe to introduce
> _another_ set of timestamps.  I don't suppose there's much harm in
> doing so though and I don't think it's going to be clean to overload
> one of the existing ones so perhaps another counter is the answer.
>
> I'll make sure this is addressed in v2.

Ahh -- I remember my original reasoning here now:

These global updates are rate limited since they only occur when we
fold the averaging period thus are limited to occur at a rate of
period/2 (e.g. each time we fold).

One concern is we could get a local "storm" since several cgroups
could trip this limit at the same time.. but it's also obviously not
going to be any worse than an update_shares_cpu().

While there may be a concern on *giant* cpu systems, I think we
already have that problem in both the original and (to a lesser
extent) current approaches.

>
>>> TODO:
>>> - Validate any RT interaction
>>
>> I don't think there's anything to worry about there, the only
>> interaction which there is between this and the rt scheduling classes is
>> the initial sharing of the load-avg window, but you 'cure' that in 7/12.
>>
>> (I think that sysctl wants a _us postfix someplace and we thus want some
>> NSEC_PER_USEC multiplication in there).
>>
>
> Yes -- updated, thanks.
>
>>> - Continue collecting/analyzing performance and fairness data
>>
>> Yes please ;-), I'll try and run this on some machines as well.
>>
>>> - Should the shares period just be the sched_latency?
>>
>> Interesting idea.. lets keep it a separate sysctl for now for easy
>> tuning, if things settle down and we're still good in that range we can
>> consider merging them.
>>
>>
>>
>
