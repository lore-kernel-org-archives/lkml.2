Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1LUHaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:30:20 -0500
Received: from mga06.intel.com ([134.134.136.21]:39741 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752214Ab1LUHaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:30:16 -0500
MIME-Version: 1.0
In-Reply-To: <4EF18129.7030407@tao.ma>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6>
	<4EF17DC4.5010008@tao.ma>
	<alpine.SOC.1.00.1112210835010.6858@math.ut.ee>
	<4EF18129.7030407@tao.ma>
Date: Tue, 20 Dec 2011 23:30:14 -0800
Message-ID: <CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Tao Ma <tm@tao.ma>
Cc: Meelis Roos <mroos@linux.ee>, axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 10:48 PM, Tao Ma <tm@tao.ma> wrote:
> On 12/21/2011 02:36 PM, Meelis Roos wrote:
>>>> -   if (unlikely(tag >= bqt->max_depth)) {
>>>> +   if (WARN_ONCE(tag >= bqt->real_max_depth,
>>>> +                 "%s: tag %d greater than tag map size: %d\n",
>>>> +                 __func__, tag, bqt->real_max_depth)) {
>>>>             /*
>>>>              * This can happen after tag depth has been reduced.
>>> Please also change the comments here since it should never happen in the
>>> right workload.
>>
>> What do you mean by right workload? Normal workload?
> yeah, so real_max_depth is the maximum depth we ever have. So in normal
> case(shrinking queue depth is also a normal user case), we should never
> arrive here. In another word, if tag >= real_max_depth, we should have a
> bug in the kernel.

So this is what Ed Nadolski suggested, just cut to the chase and do,
the following.  Seems like the comment is what got us into trouble in
the first place.

diff --git a/block/blk-tag.c b/block/blk-tag.c
index e74d6d1..e297d9d7 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -284,16 +284,7 @@ void blk_queue_end_tag(struct request_queue *q,
struct request *rq)
        struct blk_queue_tag *bqt = q->queue_tags;
        int tag = rq->tag;

-       BUG_ON(tag == -1);
-
-       if (unlikely(tag >= bqt->max_depth)) {
-               /*
-                * This can happen after tag depth has been reduced.
-                * But tag shouldn't be larger than real_max_depth.
-                */
-               WARN_ON(tag >= bqt->real_max_depth);
-               return;
-       }
+       BUG_ON(tag == -1 || tag > bqt->real_max_depth);
