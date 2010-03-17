Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0CQS3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 14:29:15 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:61319 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0CQS3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 14:29:14 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 14:29:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jCRFu0/y42Fm+nK0+bR+L0rhkqp2NWW2Tx63zzI1kR32y8BP5bYAatmeW4w/CqErXa
         OJ9CgpCxdsLXvcFk+ILkSQoMuK7rg/HDV9lsdZWauVIE95N5+Wjrktqn6nr+RS6Di+Vm
         J/Q60wZeTIUuagWdDfzUDvTTaYPwaKj0HJ3ho=
MIME-Version: 1.0
In-Reply-To: <20100317133019.GV5768@kernel.dk>
References: <20100316025656.GA15390@sli10-desk.sh.intel.com>
	 <20100317133019.GV5768@kernel.dk>
Date: Wed, 17 Mar 2010 19:24:10 +0100
Message-ID: <4e5e476b1003171124y791a25a8n6c31368f182b52a9@mail.gmail.com>
Subject: Re: [RFC]cfq-iosched: fix a kbuild regression
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, jmoyer@redhat.com, guijianfeng@cn.fujitsu.com,
       alex.shi@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 2:30 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Mar 16 2010, Shaohua Li wrote:
>> Alex Shi reported a kbuild regression which is about 10% performance lost.
>> He bisected to this commit: 3dde36ddea3e07dd025c4c1ba47edec91606fec0.
>> The reason is cfqq_close() can't find close cooperator. If we store the seek
>> distance to the value before the commit like below, the regression fully goes
>> away. If this is too invasive, just changing the cfq_rq_close() for the
>> !for_preempt is ok too.
>
> Corrado, any objections to widening the seek threshold?

The previous seek threshold value was meant to be compared with the
average seek distance, so it was large to account for variations.
Since we handle the variations differently, we should have a smaller
value now (the 100 * 8 was the result of a benchmark run on several
disks).
I agreee, though, that for merging queues, it is now too small, so we
should have two thresholds, the current one used to determine if a
request causes a seek, and an other to be used inside cfq_close (with
the older value, regardless of for_preempt).

Corrado

>
>>
>> Reported-by: Alex Shi <alex.shi@intel.com>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index dee9d93..fcae456 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -46,7 +46,7 @@ static const int cfq_hist_divisor = 4;
>>  #define CFQ_HW_QUEUE_MIN     (5)
>>  #define CFQ_SERVICE_SHIFT       12
>>
>> -#define CFQQ_SEEK_THR                (sector_t)(8 * 100)
>> +#define CFQQ_SEEK_THR                (sector_t)(8 * 1024)
>>  #define CFQQ_SECT_THR_NONROT (sector_t)(2 * 32)
>>  #define CFQQ_SEEKY(cfqq)     (hweight32(cfqq->seek_history) > 32/8)
>>
>
> --
> Jens Axboe
>
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
