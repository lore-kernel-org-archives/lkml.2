Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1HHDq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 23:46:27 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:52668 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753243Ab1HHDq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 23:46:26 -0400
Message-ID: <4E3F5C0E.2060207@tao.ma>
Date: Mon, 08 Aug 2011 11:46:22 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] block: Make rq_affinity = 1 work as expected.
References: <1312519150-3261-1-git-send-email-tm@tao.ma>	<4E3B9CAC.7020802@fusionio.com> <CANejiEVX8_2Zbd-b0WCrgoYoY88n9OzQ0s2=T5+LWH1aFd7whg@mail.gmail.com>
In-Reply-To: <CANejiEVX8_2Zbd-b0WCrgoYoY88n9OzQ0s2=T5+LWH1aFd7whg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.5 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,
On 08/08/2011 10:58 AM, Shaohua Li wrote:
> 2011/8/5 Jens Axboe <jaxboe@fusionio.com>:
>> On 2011-08-05 06:39, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
>>> the request completed in the __make_request cpu. But it makes the
>>> old rq_affinity = 1 not work any more. The root cause is that
>>> if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
>>> ccpu will be the same as group_cpu, so the completion will be
>>> excuted in the 'cpu' not 'group_cpu'.
>>>
>>> This patch fix problem by simpling removing group_cpu and the codes
>>> are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
>>> we raise_blk_irq to ccpu.
>>
>> Thanks Tao Ma, much more readable too.
> Hi Jens,
> I rethought the problem when I check interrupt in my system. I thought
> we don't need Tao's patch though it makes the code behavior like before.
> Let's take an example. My test box has cpu 0-7, one socket. Say request
> is added in CPU 1, blk_complete_request occurs at CPU 7. Without Tao's
> patch, softirq will be done at CPU 7. With it, an IPI will be directed to CPU 0,
> and softirq will be done at CPU 0. In this case, doing softirq at CPU 0 and
> CPU 7 have no difference and we can avoid an ipi if doing it in CPU 7.
I totally agree with your analysis, but what I am worried is that this
does change the old system behavior.
And without this patch actually '1' and '2' in rq_affinity has the same
effect now in your case. If you do prefer the new codes and the new
behavior, then '1' don't need to exist any more(since from your
description it seems to only adds an additional IPI overhead and no
benefit), or '2' is totally unneeded here.

Thanks
Tao
> 
> we don't need to worry about blk_complete_request occurs at different CPUs.
> it's called in interrupt handler. As far as I checked, all my HBA
> cards (several LSI)
> and AHCI don't support multiple MSI, so I assume blk_complete_request will
> only be called in one CPU. Sure, if the assumption is wrong, we still need
> Tao's patch, but in most common cases my assumption is correct.
