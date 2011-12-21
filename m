Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1LUIQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:16:53 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:56015 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752459Ab1LUIQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:16:50 -0500
Message-ID: <4EF195EE.9010409@tao.ma>
Date: Wed, 21 Dec 2011 16:16:46 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: Meelis Roos <mroos@linux.ee>, axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6>	<4EF17DC4.5010008@tao.ma>	<alpine.SOC.1.00.1112210835010.6858@math.ut.ee>	<4EF18129.7030407@tao.ma> <CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
In-Reply-To: <CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 121.0.29.114 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 03:30 PM, Williams, Dan J wrote:
> On Tue, Dec 20, 2011 at 10:48 PM, Tao Ma <tm@tao.ma> wrote:
>> On 12/21/2011 02:36 PM, Meelis Roos wrote:
>>>>> -   if (unlikely(tag >= bqt->max_depth)) {
>>>>> +   if (WARN_ONCE(tag >= bqt->real_max_depth,
>>>>> +                 "%s: tag %d greater than tag map size: %d\n",
>>>>> +                 __func__, tag, bqt->real_max_depth)) {
>>>>>             /*
>>>>>              * This can happen after tag depth has been reduced.
>>>> Please also change the comments here since it should never happen in the
>>>> right workload.
>>>
>>> What do you mean by right workload? Normal workload?
>> yeah, so real_max_depth is the maximum depth we ever have. So in normal
>> case(shrinking queue depth is also a normal user case), we should never
>> arrive here. In another word, if tag >= real_max_depth, we should have a
>> bug in the kernel.
> 
> So this is what Ed Nadolski suggested, just cut to the chase and do,
> the following.  Seems like the comment is what got us into trouble in
> the first place.
> 
> diff --git a/block/blk-tag.c b/block/blk-tag.c
> index e74d6d1..e297d9d7 100644
> --- a/block/blk-tag.c
> +++ b/block/blk-tag.c
> @@ -284,16 +284,7 @@ void blk_queue_end_tag(struct request_queue *q,
> struct request *rq)
>         struct blk_queue_tag *bqt = q->queue_tags;
>         int tag = rq->tag;
> 
> -       BUG_ON(tag == -1);
> -
> -       if (unlikely(tag >= bqt->max_depth)) {
> -               /*
> -                * This can happen after tag depth has been reduced.
> -                * But tag shouldn't be larger than real_max_depth.
> -                */
> -               WARN_ON(tag >= bqt->real_max_depth);
> -               return;
> -       }
> +       BUG_ON(tag == -1 || tag > bqt->real_max_depth);
I guess tag = bqt->real_max_depth should also be a problem.

Thanks
Tao
