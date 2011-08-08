Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1HHF4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:56:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37425 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1HHF4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <4E3F76D7.4010708@tao.ma>
References: <1312519150-3261-1-git-send-email-tm@tao.ma>
	<4E3B9CAC.7020802@fusionio.com>
	<CANejiEVX8_2Zbd-b0WCrgoYoY88n9OzQ0s2=T5+LWH1aFd7whg@mail.gmail.com>
	<4E3F5C0E.2060207@tao.ma>
	<CANejiEVcwmhTFdjgt1OE_XNwayTfQ846tgwGUhyjujb5S4FHZA@mail.gmail.com>
	<4E3F76D7.4010708@tao.ma>
Date: Mon, 8 Aug 2011 13:56:40 +0800
X-Google-Sender-Auth: VIvxLrDjeI6YW2Fkleuyy2WEYcY
Message-ID: <CANejiEUu=x5z2r7GKXxwF-7mWsaVegbVBBjgOJKMmX7uiM_NSQ@mail.gmail.com>
Subject: Re: [PATCH] block: Make rq_affinity = 1 work as expected.
From: Shaohua Li <shli@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/8 Tao Ma <tm@tao.ma>:
> On 08/08/2011 12:33 PM, Shaohua Li wrote:
>> 2011/8/8 Tao Ma <tm@tao.ma>:
>>> Hi Shaohua,
>>> On 08/08/2011 10:58 AM, Shaohua Li wrote:
>>>> 2011/8/5 Jens Axboe <jaxboe@fusionio.com>:
>>>>> On 2011-08-05 06:39, Tao Ma wrote:
>>>>>> From: Tao Ma <boyu.mt@taobao.com>
>>>>>>
>>>>>> Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
>>>>>> the request completed in the __make_request cpu. But it makes the
>>>>>> old rq_affinity = 1 not work any more. The root cause is that
>>>>>> if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
>>>>>> ccpu will be the same as group_cpu, so the completion will be
>>>>>> excuted in the 'cpu' not 'group_cpu'.
>>>>>>
>>>>>> This patch fix problem by simpling removing group_cpu and the codes
>>>>>> are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
>>>>>> we raise_blk_irq to ccpu.
>>>>>
>>>>> Thanks Tao Ma, much more readable too.
>>>> Hi Jens,
>>>> I rethought the problem when I check interrupt in my system. I thought
>>>> we don't need Tao's patch though it makes the code behavior like before.
>>>> Let's take an example. My test box has cpu 0-7, one socket. Say request
>>>> is added in CPU 1, blk_complete_request occurs at CPU 7. Without Tao's
>>>> patch, softirq will be done at CPU 7. With it, an IPI will be directed to CPU 0,
>>>> and softirq will be done at CPU 0. In this case, doing softirq at CPU 0 and
>>>> CPU 7 have no difference and we can avoid an ipi if doing it in CPU 7.
>>> I totally agree with your analysis, but what I am worried is that this
>>> does change the old system behavior.
>>> And without this patch actually '1' and '2' in rq_affinity has the same
>>> effect now in your case. If you do prefer the new codes and the new
>>> behavior, then '1' don't need to exist any more(since from your
>>> description it seems to only adds an additional IPI overhead and no
>>> benefit), or '2' is totally unneeded here.
>> with rq_affinity 2, CPU 1 will do the softirq in above case. it's
>> still different
>> like the rq_affinity 1 case.
> OK, so let's see what's going on without the patch in case rq_affinity = 1.
> If the complete cpu and the request cpu are in the same group, the
> complete cpu will call softirq.
> If the complete cpu and the request cpu are not in the same group, the
> group cpu of the request cpu will call softirq.
>
> These behaviors are totally different. How can you tell the user what's
> going on there? And that' the reason we want 0, 1, 2 for rq_affinity. If
> the user does care about the extra IPI(in your case), fine, just set
> rq_affinty = 2.
rq_affinity=2: finish request in each cpu
rq_affinity=1: finish request in one CPU for each socket.
Even without your patch, rq_affinity=1 finish request in one CPU too.
Remember the controller only has one interrupt source. the only difference
is request isn't always finished in the first CPU of a socket. I didn't
think this is a behavior change which user even cares about.
I originally worried about blk_complete_request can be called for all
CPUs, but this isn't true.

Thanks,
Shaohua
