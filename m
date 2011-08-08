Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1HHC6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 22:58:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60057 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1HHC6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 22:58:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E3B9CAC.7020802@fusionio.com>
References: <1312519150-3261-1-git-send-email-tm@tao.ma>
	<4E3B9CAC.7020802@fusionio.com>
Date: Mon, 8 Aug 2011 10:58:48 +0800
X-Google-Sender-Auth: YgSiuMLL2n5qzGcSH1vRDyuNgSc
Message-ID: <CANejiEVX8_2Zbd-b0WCrgoYoY88n9OzQ0s2=T5+LWH1aFd7whg@mail.gmail.com>
Subject: Re: [PATCH] block: Make rq_affinity = 1 work as expected.
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tao Ma <tm@tao.ma>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/5 Jens Axboe <jaxboe@fusionio.com>:
> On 2011-08-05 06:39, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
>> the request completed in the __make_request cpu. But it makes the
>> old rq_affinity = 1 not work any more. The root cause is that
>> if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
>> ccpu will be the same as group_cpu, so the completion will be
>> excuted in the 'cpu' not 'group_cpu'.
>>
>> This patch fix problem by simpling removing group_cpu and the codes
>> are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
>> we raise_blk_irq to ccpu.
>
> Thanks Tao Ma, much more readable too.
Hi Jens,
I rethought the problem when I check interrupt in my system. I thought
we don't need Tao's patch though it makes the code behavior like before.
Let's take an example. My test box has cpu 0-7, one socket. Say request
is added in CPU 1, blk_complete_request occurs at CPU 7. Without Tao's
patch, softirq will be done at CPU 7. With it, an IPI will be directed to CPU 0,
and softirq will be done at CPU 0. In this case, doing softirq at CPU 0 and
CPU 7 have no difference and we can avoid an ipi if doing it in CPU 7.

we don't need to worry about blk_complete_request occurs at different CPUs.
it's called in interrupt handler. As far as I checked, all my HBA
cards (several LSI)
and AHCI don't support multiple MSI, so I assume blk_complete_request will
only be called in one CPU. Sure, if the assumption is wrong, we still need
Tao's patch, but in most common cases my assumption is correct.

Thanks,
Shaohua
