Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2ARBUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:20:22 -0500
Received: from lo.gmane.org ([80.91.229.12]:60623 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab2ARBUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:20:20 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 2/3] block: prevent duplicated bio completion report
Date: Wed, 18 Jan 2012 10:20:03 +0900
Message-ID: <4F161E43.5040705@gmail.com>
References: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com> <1326763928-1972-2-git-send-email-namhyung.kim@lge.com> <20120117174520.GB6762@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Namhyung Kim <namhyung.kim@lge.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
In-Reply-To: <20120117174520.GB6762@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-01-18 2:45 AM, Tejun Heo wrote:
> Hello,
>
> On Tue, Jan 17, 2012 at 10:32:07AM +0900, Namhyung Kim wrote:
>> Since previous patch make block_bio_complete TP working,
>> it will generate duplicated BLK_TA_COMPLETEs for bounced
>> bios. Fix it.
>>
>> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
>> Cc: Tejun Heo <tj@kernel.org>
>
> This and the third patch should probably be merged to the first patch.
> As it currently stands, it introduces window where spurious events are
> generated.

OK, will do.


>
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 4053cbd4490e..45cd0074a1c8 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -97,6 +97,9 @@ struct bio {
>>   #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
>>   #define bio_flagged(bio, flag)	((bio)->bi_flags&  (1<<  (flag)))
>>
>> +/* masked bio's won't report its completion via tracepoint */
>> +#define BIO_COMPLETE_MASK	(1<<  BIO_BOUNCED)
>
> And, who's setting this flag?

__blk_queue_bounce() does.


>
>>   /*
>>    * top 4 bits of bio flags indicate the pool this bio came from
>>    */
>> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
>> index 96955f4828b3..72888542e186 100644
>> --- a/include/trace/events/block.h
>> +++ b/include/trace/events/block.h
>> @@ -219,7 +219,8 @@ TRACE_EVENT_CONDITION(block_bio_complete,
>>
>>   	TP_ARGS(q, bio, error),
>>
>> -	TP_CONDITION(bio->bi_bdev != NULL),
>> +	TP_CONDITION(bio->bi_bdev != NULL&&
>> +		     !(bio->bi_flags&  BIO_COMPLETE_MASK)),
>
> Bounced bio's are separate bio's too and I don't think masking its
> completion from the TP itself is a good idea.  As I wrote before, why
> not do this from blktrace code?

Because blktrace cannot know about the bi_flags, as I said before. :) 
And although the bounced bio's are separate ones, they aren't queued 
separately. They just get replaced on the way.

Besides, I think accounting wait_time of them will result in an invalid 
value unless it's handled somehow in block_bio_bounce and/or 
block_rq_issue TP.


Thanks,
Namhyung

