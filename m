Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0LISLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:11:38 -0500
Received: from smtp-out.google.com ([74.125.121.35]:52386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0LISLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TnCWE7caeUrBdF9ttb7LXD6k3u9GojDHxe5q1c4V9iRiWob/Ku+DbLEM5GEXXOvqjk
         3ma7QeVTo3DTozM36Rtg==
MIME-Version: 1.0
In-Reply-To: <1291917330.6803.7.camel@twins>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	<1291851079-27061-1-git-send-email-venki@google.com>
	<1291899120.29292.7.camel@twins>
	<AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	<1291917330.6803.7.camel@twins>
Date: Thu, 9 Dec 2010 10:11:33 -0800
Message-ID: <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 9:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-12-09 at 09:43 -0800, Venkatesh Pallipadi wrote:
>>
>> The same problem will be there with below code, with irq_delta >
>> delta, clock_task can go backwards which is not good.
>> +       delta -= irq_delta;
>> +       rq->clock_task += delta;
>>
>> The reason for this is rq->clock and irqtime updates kind of happen
>> independently and specifically, if a rq->clock update happens while we
>> are in a softirq, we may have this case of going backwards on the next
>> update.
>
> But how can irq_delta > delta?, we measure it using the same clock.
>

This would be mostly a corner case like:
- softirq start time t1
- rq->clock updated at t2 and rq->clock_task updated at t2 without
accounting for current softirq
- softirq end time t3
- cpu spends most time here in softirq or hardirq
- next rq->clock update at t4 and rq->clock_task update, with delta =
t4-t2 and irq_delta ~= t4 - t1
