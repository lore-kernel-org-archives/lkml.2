Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab0GGQEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:04:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50938 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab0GGQET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GGaFNvJRb1w+LBVt6VEe7qD45iZyg4cDSjyjHA8rYYkPVUJeT/oT+mkbj3w9+rWvPK
         pNOrUXeJpyc0GSzJO0HoOQDsl9oYx9F5XSTV/UgFOYQqE7tK0sEFLknEaBV92UDtEh6I
         UtwevEWX2gZ0B44K+GUPpHe3Pn1Yui/WBIqJc=
MIME-Version: 1.0
In-Reply-To: <20100707154631.GG2474@redhat.com>
References: <1278516227-1643-1-git-send-email-czoccolo@gmail.com>
	<1278516227-1643-2-git-send-email-czoccolo@gmail.com>
	<20100707154631.GG2474@redhat.com>
Date: Wed, 7 Jul 2010 18:04:16 +0200
Message-ID: <AANLkTik0CyuKZB7_jyxpiG1NgHs8pf8-nCxtPLHB6TZ_@mail.gmail.com>
Subject: Re: [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 5:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jul 07, 2010 at 05:23:47PM +0200, Corrado Zoccolo wrote:
>> RQ_NOIDLE flag is meaningful and should be honored for SYNC_WORKLOAD,
>> without further checks.
>> RQ_NOIDLE can be used to mark the last request of a sequence for which
>> - we want to idle between the requests of the sequence, to keep locality
>> - we don't want to idle after the sequence, because we know that no new
>>   nearby requests will follow, so we should switch servicing other
>>   queues.
>
> Corrado, in higher layers any WRITE_SYNC request currently is marked
> as RQ_NOIDLE. At that point it is just not known whether there will be
> another request after this or not. So I would not think of RQ_NOIDLE
> as being conclusively telling us that this is last request in the
> sequence.

Probably WRITE_SYNC are marked as RQ_NOIDLE because the application
can always send several write requests together (while for reads, you
usually need the result of one read to send the other). This means
that cfq will actually care only of the RQ_NOIDLE on the last request
in the queue (since, until the queue is empty, we don't even consider
idling).

>
> I think requst being WRITE_SYNC, we just don't know if the application
> is going to write more or not immediately. fsync, O_SYNC etc fall in
> this category.
>
> But in general I like the idea of getting rid of idling on as many cases
> as possiblle. Jeff's recent posting to fix fsync issue depends on idling
> even on WRITE_SYNC queues so your patch and his patchsets are
> fundamentally incompatible.

I think this can be easily fixed by removing RQ_NOIDLE from those
requests on which Jeff wants to idle. Once no more requests can ever
be marked RQ_NOIDLE, then we can remove this code completely.

>
> Whether to idle on WRITE_SYNC or not, I will leave it to Jens (I just
> don't know the answer to that question. :-)). But in general I want to
> get rid of idling as much as possible otherwise it becomes a serious
> bottleneck in any kind of performance testing on higher end storage.
>
> At the same time not idling runs the risk of process doing WRITE_SYNC
> not getting fair share in presence of sequential readers if writer does
> not keep the queue busy.
>
> I will do some testing with this patchset little later.
Thanks, I've resent the patches for 2.6.36 (this version were based on 2.6.34).
Corrado
>
> Thanks
> Vivek
>
>> This patch fixes this behaviour, making it similar to how it behaved
>> before 8e55063, but still fixing the corner cases that were the
>> motivation for it.
>>
>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>> ---
>>  block/cfq-iosched.c |   15 ++++++++++-----
>>  1 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 5ef9a5d..cac3afb 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -3356,12 +3356,17 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>>                               cfqd->noidle_tree_requires_idle |= bitmask;
>>
>>                       /*
>> -                      * Idling is enabled for SYNC_WORKLOAD.
>> -                      * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
>> -                      * only if we processed at least one !rq_noidle request
>> +                      * Idling is enabled for:
>> +                      * - the last sync queue of a group
>> +                      * - SYNC_WORKLOAD queues, for !rq_noidle requests
>> +                      * - SYNC_NOIDLE_WORKLOAD "at the end of the tree"
>> +                      *   if at least one queue sent !rq_noidle requests
>> +                      *   not followed by at least one rq_noidle request.
>>                        */
>> -                     if (cfqd->serving_type == SYNC_WORKLOAD
>> -                         || cfqd->noidle_tree_requires_idle
>> +                     if ((cfqd->serving_type == SYNC_WORKLOAD
>> +                          && !rq_noidle(rq))
>> +                         || (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
>> +                             && cfqd->noidle_tree_requires_idle)
>>                           || cfqq->cfqg->nr_cfqq == 1)
>>                               cfq_arm_slice_timer(cfqd);
>>               }
>> --
>> 1.6.4.4
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
