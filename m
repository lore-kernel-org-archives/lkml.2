Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1HHEdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 00:33:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35226 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1HHEdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 00:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E3F5C0E.2060207@tao.ma>
References: <1312519150-3261-1-git-send-email-tm@tao.ma>
	<4E3B9CAC.7020802@fusionio.com>
	<CANejiEVX8_2Zbd-b0WCrgoYoY88n9OzQ0s2=T5+LWH1aFd7whg@mail.gmail.com>
	<4E3F5C0E.2060207@tao.ma>
Date: Mon, 8 Aug 2011 12:33:52 +0800
X-Google-Sender-Auth: bgHQvFChsPnZQs7KV9i6GxZjbQI
Message-ID: <CANejiEVcwmhTFdjgt1OE_XNwayTfQ846tgwGUhyjujb5S4FHZA@mail.gmail.com>
Subject: Re: [PATCH] block: Make rq_affinity = 1 work as expected.
From: Shaohua Li <shli@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/8 Tao Ma <tm@tao.ma>:
> Hi Shaohua,
> On 08/08/2011 10:58 AM, Shaohua Li wrote:
>> 2011/8/5 Jens Axboe <jaxboe@fusionio.com>:
>>> On 2011-08-05 06:39, Tao Ma wrote:
>>>> From: Tao Ma <boyu.mt@taobao.com>
>>>>
>>>> Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
>>>> the request completed in the __make_request cpu. But it makes the
>>>> old rq_affinity = 1 not work any more. The root cause is that
>>>> if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
>>>> ccpu will be the same as group_cpu, so the completion will be
>>>> excuted in the 'cpu' not 'group_cpu'.
>>>>
>>>> This patch fix problem by simpling removing group_cpu and the codes
>>>> are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
>>>> we raise_blk_irq to ccpu.
>>>
>>> Thanks Tao Ma, much more readable too.
>> Hi Jens,
>> I rethought the problem when I check interrupt in my system. I thought
>> we don't need Tao's patch though it makes the code behavior like before.
>> Let's take an example. My test box has cpu 0-7, one socket. Say request
>> is added in CPU 1, blk_complete_request occurs at CPU 7. Without Tao's
>> patch, softirq will be done at CPU 7. With it, an IPI will be directed to CPU 0,
>> and softirq will be done at CPU 0. In this case, doing softirq at CPU 0 and
>> CPU 7 have no difference and we can avoid an ipi if doing it in CPU 7.
> I totally agree with your analysis, but what I am worried is that this
> does change the old system behavior.
> And without this patch actually '1' and '2' in rq_affinity has the same
> effect now in your case. If you do prefer the new codes and the new
> behavior, then '1' don't need to exist any more(since from your
> description it seems to only adds an additional IPI overhead and no
> benefit), or '2' is totally unneeded here.
with rq_affinity 2, CPU 1 will do the softirq in above case. it's
still different
like the rq_affinity 1 case.

Thanks,
Shaohua


>>
>> we don't need to worry about blk_complete_request occurs at different CPUs.
>> it's called in interrupt handler. As far as I checked, all my HBA
>> cards (several LSI)
>> and AHCI don't support multiple MSI, so I assume blk_complete_request will
>> only be called in one CPU. Sure, if the assumption is wrong, we still need
>> Tao's patch, but in most common cases my assumption is correct.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
