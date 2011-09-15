Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1IOCQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 22:16:12 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:39236 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753448Ab1IOCQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 22:16:07 -0400
Message-ID: <4E715FE2.7040004@tao.ma>
Date: Thu, 15 Sep 2011 10:16:02 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH RESEND] block: Don't check QUEUE_FLAG_SAME_COMP in __blk_complete_request.
References: <1315984992-5158-1-git-send-email-tm@tao.ma>	<1315984992-5158-2-git-send-email-tm@tao.ma> <CANejiEWa5um5LtRkL3NcbNgBnUCG1Ud8qw-hfXW3X3GPfHv4iQ@mail.gmail.com>
In-Reply-To: <CANejiEWa5um5LtRkL3NcbNgBnUCG1Ud8qw-hfXW3X3GPfHv4iQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 09:05 AM, Shaohua Li wrote:
> 2011/9/14 Tao Ma <tm@tao.ma>:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> In __blk_complete_request, we check both QUEUE_FLAG_SAME_COMP and req->cpu
>> to decide whether we should use req->cpu. Actually the user can also
>> select the complete cpu by either setting BIO_CPU_AFFINE or by calling
>> bio_set_completion_cpu. Current solution makes these 2 ways don't work
>> any more. So we'd better just check req->cpu.
>>
>> Cc: Jens Axboe <jaxboe@fusionio.com>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>> ---
>>  block/blk-softirq.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/blk-softirq.c b/block/blk-softirq.c
>> index 58340d0..1366a89 100644
>> --- a/block/blk-softirq.c
>> +++ b/block/blk-softirq.c
>> @@ -115,7 +115,7 @@ void __blk_complete_request(struct request *req)
>>        /*
>>         * Select completion CPU
>>         */
>> -       if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
>> +       if (req->cpu != -1) {
>>                ccpu = req->cpu;
>>                if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
>>                        ccpu = blk_cpu_to_group(ccpu);
> why not delete bio_set_completion_cpu()?
Not sure. It is added in commit c7c22e4d from the very beginning, and in
the commit log Jens described it as:
A bio helper (bio_set_completion_cpu()) is also added, so that queuers
can ask for completion on that specific CPU. Maybe it is obsolete.
Anyway, I am fine to generate a patch to remove it if you prefer.
> 1. nobody uses it in my search
yes, but it may be designed for someone to use it. The same goes with
BIO_CPU_AFFINE.
> 2. it's misleading. even setting the completion cpu, the bio isn't
> always to run finish in the cpu,
> it's just run in the group of the cpu.
Without this patch, it works as you said.
But with this patch, it the user uses bio_set_completion_cpu and
QUEUE_FLAG_SAME_FORCE isn't set, the completion will happen in the
req->cpu the user specified.

Jens,
	Do you have any option for it? Whether we should preserve it and make
it work or just totally remove it?

Thanks
Tao
