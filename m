Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0CRQzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:55:22 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46724 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0CRQzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mke3O8/l/qkmVkUUOuI6w8UVuaaKoFneVqzdJVLEWrzlTMRucGulgMdVZTHR+3HGt4
         uEzBFUV6kg3xUj6PY04NIgFkz91AOtqERTmbscVIVSN/UOEzCrWWEmXqbM/q+uec5F+1
         cKcceBo51cQyuEXBvL+rZjUemHJOSu47ey5yc=
MIME-Version: 1.0
In-Reply-To: <20100318010459.GA26716@sli10-desk.sh.intel.com>
References: <20100316025656.GA15390@sli10-desk.sh.intel.com>
	 <20100317133019.GV5768@kernel.dk>
	 <4e5e476b1003171124y791a25a8n6c31368f182b52a9@mail.gmail.com>
	 <20100318010459.GA26716@sli10-desk.sh.intel.com>
Date: Thu, 18 Mar 2010 17:55:16 +0100
Message-ID: <4e5e476b1003180955h4cdfde92ubd0b1c6579b5338b@mail.gmail.com>
Subject: Re: [RFC]cfq-iosched: fix a kbuild regression
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
       "Shi, Alex" <alex.shi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 2:05 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Thu, Mar 18, 2010 at 02:24:10AM +0800, Corrado Zoccolo wrote:
>> On Wed, Mar 17, 2010 at 2:30 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> > On Tue, Mar 16 2010, Shaohua Li wrote:
>> >> Alex Shi reported a kbuild regression which is about 10% performance lost.
>> >> He bisected to this commit: 3dde36ddea3e07dd025c4c1ba47edec91606fec0.
>> >> The reason is cfqq_close() can't find close cooperator. If we store the seek
>> >> distance to the value before the commit like below, the regression fully goes
>> >> away. If this is too invasive, just changing the cfq_rq_close() for the
>> >> !for_preempt is ok too.
>> >
>> > Corrado, any objections to widening the seek threshold?
>>
>> The previous seek threshold value was meant to be compared with the
>> average seek distance, so it was large to account for variations.
>> Since we handle the variations differently, we should have a smaller
>> value now (the 100 * 8 was the result of a benchmark run on several
>> disks).
> Our test doesn't find any issue with the seek threshold so far, so it proberly
> is ok.
>
>> I agreee, though, that for merging queues, it is now too small, so we
>> should have two thresholds, the current one used to determine if a
>> request causes a seek, and an other to be used inside cfq_close (with
>> the older value, regardless of for_preempt).
> That makes sense. Updated patch.
>
>
> Alex Shi reported a kbuild regression which is about 10% performance lost.
> He bisected to this commit: 3dde36ddea3e07dd025c4c1ba47edec91606fec0.
> The reason is cfqq_close() can't find close cooperator. Restoring
> cfq_rq_close()'s threshold to original value makes the regression go away.
>
> Since for_preempt parameter isn't used anymore, this patch deletes it.
>
> Reported-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Corrado Zoccolo <czoccolo@gmail.com>
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index dee9d93..8d5a2f2 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -47,6 +47,7 @@ static const int cfq_hist_divisor = 4;
>  #define CFQ_SERVICE_SHIFT       12
>
>  #define CFQQ_SEEK_THR          (sector_t)(8 * 100)
> +#define CFQQ_CLOSE_THR         (sector_t)(8 * 1024)
>  #define CFQQ_SECT_THR_NONROT   (sector_t)(2 * 32)
>  #define CFQQ_SEEKY(cfqq)       (hweight32(cfqq->seek_history) > 32/8)
>
> @@ -1660,9 +1661,9 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
>  }
>
>  static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> -                              struct request *rq, bool for_preempt)
> +                              struct request *rq)
>  {
> -       return cfq_dist_from_last(cfqd, rq) <= CFQQ_SEEK_THR;
> +       return cfq_dist_from_last(cfqd, rq) <= CFQQ_CLOSE_THR;
>  }
>
>  static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
> @@ -1689,7 +1690,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>         * will contain the closest sector.
>         */
>        __cfqq = rb_entry(parent, struct cfq_queue, p_node);
> -       if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq, false))
> +       if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
>                return __cfqq;
>
>        if (blk_rq_pos(__cfqq->next_rq) < sector)
> @@ -1700,7 +1701,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>                return NULL;
>
>        __cfqq = rb_entry(node, struct cfq_queue, p_node);
> -       if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq, false))
> +       if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
>                return __cfqq;
>
>        return NULL;
> @@ -3103,7 +3104,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>         * if this request is as-good as one we would expect from the
>         * current cfqq, let it preempt
>         */
> -       if (cfq_rq_close(cfqd, cfqq, rq, true))
> +       if (cfq_rq_close(cfqd, cfqq, rq))
>                return true;
>
>        return false;
>
