Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0LMPDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:03:18 -0500
Received: from mail-iw0-f180.google.com ([209.85.214.180]:54979 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0LMPDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:03:17 -0500
X-Greylist: delayed 1487 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 10:03:16 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IsRxR8bqeajCZfMWehzekBZZKsi2Qhirtrn2kE9xhBMJsbIDzMc8GIpQo8X2fc61IF
         BFBWJBQDsrHD4KHv4uaiNhpJ36Ywew6UAmIyop7vOTyOV/JDTvjGEVGyWOHw9LiuI6kJ
         hFGTYsulQpJ/D/3BmYMvnibQ17mLggZHrq5yE=
MIME-Version: 1.0
In-Reply-To: <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	<1291851079-27061-1-git-send-email-venki@google.com>
	<1291899120.29292.7.camel@twins>
	<AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	<1291917330.6803.7.camel@twins>
	<AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
Date: Mon, 13 Dec 2010 20:03:02 +0530
Message-ID: <AANLkTi=3eFomJhT8xntZs6FxUJ9b5iKQ2x+CaDHR2Yqd@mail.gmail.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Jack Daniel <wanders.thirst@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 11:41 PM, Venkatesh Pallipadi <venki@google.com> wrote:
> On Thu, Dec 9, 2010 at 9:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Thu, 2010-12-09 at 09:43 -0800, Venkatesh Pallipadi wrote:
>>>
>>> The same problem will be there with below code, with irq_delta >
>>> delta, clock_task can go backwards which is not good.
>>> +       delta -= irq_delta;
>>> +       rq->clock_task += delta;
>>>
>>> The reason for this is rq->clock and irqtime updates kind of happen
>>> independently and specifically, if a rq->clock update happens while we
>>> are in a softirq, we may have this case of going backwards on the next
>>> update.
>>
>> But how can irq_delta > delta?, we measure it using the same clock.
>>
>
> This would be mostly a corner case like:
> - softirq start time t1
> - rq->clock updated at t2 and rq->clock_task updated at t2 without
> accounting for current softirq
> - softirq end time t3
> - cpu spends most time here in softirq or hardirq
> - next rq->clock update at t4 and rq->clock_task update, with delta =
> t4-t2 and irq_delta ~= t4 - t1
                                  ^^^
I was curious on this line. Shouldn't this be irq_delta ~= t3 - t1 ?
If so the time going backwards shouldn't happen. If it does happen
then wouldn't it be better to program irq_time_cpu(cpu_of(rq)) to
return t3 instead of t4?

Thanks,
Jack
