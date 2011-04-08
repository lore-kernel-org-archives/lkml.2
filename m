Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1DHT3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:29:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8329 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab1DHT3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C8UE8mzby0zWmBdkF59nns49FgxypG8tTk08fKr7kcEJru4oc3wBW7352Q7O8/rWEv
         6RLHitEXcocmA2uAb8Tw==
MIME-Version: 1.0
In-Reply-To: <1302261350.9086.120.camel@twins>
References: <20110408002322.3A0D812217F@elm.corp.google.com>
	<1302261350.9086.120.camel@twins>
Date: Fri, 8 Apr 2011 12:29:33 -0700
Message-ID: <BANLkTin4aQ7Gc+h0YCPo=Eokc2iz06WNbw@mail.gmail.com>
Subject: Re: [PATCH] sched: fix sched-domain avg_load calculation.
From: Ken Chen <kenchen@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 4:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2011-04-07 at 17:23 -0700, Ken Chen wrote:
>> In function find_busiest_group(), the sched-domain avg_load isn't
>> calculated at all if there is a group imbalance within the domain.
>> This will cause erroneous imbalance calculation.  The reason is
>> that calculate_imbalance() sees sds->avg_load = 0 and it will dump
>> entire sds->max_load into imbalance variable, which is used later
>> on to migrate entire load from busiest CPU to the puller CPU. It
>> has two really bad effect:
>>
>> 1. stampede of task migration, and they won't be able to break out
>>    of the bad state because of positive feedback loop: large load
>>    delta -> heavier load migration -> larger imbalance and the cycle
>>    goes on.
>>
>> 2. severe imbalance in CPU queue depth.  This causes really long
>>    scheduling latency blip which affects badly on application that
>>    has tight latency requirement.
>>
>> The fix is to have kernel calculate domain avg_load in both cases.
>> This will ensure that imbalance calculation is always sensible and
>> the target is usually half way between busiest and puller CPU.
>
> Indeed so, it looks like I broke that in 866ab43efd32. Out of curiosity,
> what kind of workload did you observe this on?

This was observed on application that serves websearch query.  There
were uneven CPU queue depth in the system, which leads to long query
latency tail.  The latency tail were both high in occurring frequency
as well as streched out in time.

With this fix, both server throughput and latency response were improved.

- Ken
