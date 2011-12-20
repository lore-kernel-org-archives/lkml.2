Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1LTBpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:45:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55209 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1LTBpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:45:15 -0500
MIME-Version: 1.0
In-Reply-To: <4EEFE0AE.7040201@tao.ma>
References: <1315984992-5158-1-git-send-email-tm@tao.ma>
	<4EA57E40.2020301@tao.ma>
	<4EA670F9.8030601@kernel.dk>
	<CAA9_cmeV7uW8Rq_Rsn156SgtT4bBHV3Zip2=NS3kq+JrLm3AEQ@mail.gmail.com>
	<4EEFE0AE.7040201@tao.ma>
Date: Mon, 19 Dec 2011 17:45:14 -0800
X-Google-Sender-Auth: jlGJT1xwp821GrqQJJyx0LP2gDk
Message-ID: <CAA9_cmfRXgwsamx2Q+Wccyfqnz3ePt60Z950pPippJuOnooJLA@mail.gmail.com>
Subject: Re: [PATCH RESEND] block: warn if tag is greater than real_max_depth.
From: Dan Williams <dan.j.williams@intel.com>
To: Tao Ma <tm@tao.ma>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "edmund.nadolski" <edmund.nadolski@intel.com>, mroos@ut.ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 5:11 PM, Tao Ma <tm@tao.ma> wrote:
>>> Looks good, better than what we had. Applied.
>>
>> This appears to interact badly with scsi_adjust_queue_depth() when the
>> tag space shrinks.  I can reproduce a similar crash as reported in
>> "3.2-rc2+git: kernel BUG at block/blk-core.c:1000!
>> (__scsi_queue_insert)" [1].
>>
>> I can hit "kernel BUG at block/blk-core.c:2268!" which is the same
>> BUG_ON(blk_queued_rq(rq)) check reliably with:
>> # for i in $(seq 0 10); do dd if=/dev/zero of=/dev/sdX & done
>> # echo 4 > /sys/class/block/sdX/device/queue_depth
>>
>> The following fixes it for me, if this looks ok (versus reverting
>> commit 5e081591) I'll roll it into a formal patch with Ed and Meelis'
>> Reported-by.
> Interesting. If I read the code correctly, real_max_depth is the maximum
> queue depth we ever have and max_depth is the current depth.
>
> In your fix, we never resize the tag size to be smaller than max_depth.
> So I think this patch does expose some problem, but not lead to the BUG.

Yes, if we keep the "if (unlikely(tag >= bqt->max_depth))" check in
blk_queue_end_tag() then the side effect is that we can never shrink
the tag depth, which I don't think was intended.

> And in your new comment, you mentioned that "request between new_depth
> and max_depth can be in-flight", but max_depth <= real_max_depth, so
> what's wrong with the comment? Sorry, but am I missing something here?

Prior to the change blk_queue_end_tag() would continue to complete
requests with a tag > max_depth, now it silently drops them on the
floor leaving BUG_ON(blk_queued_rq(rq)) to trigger when we try to end
the request

> Having said that, I have tried the test in my machine here, but have no
> luck by now. My kernel version is 3.2.0-rc5+.

What controller are you using?  I am using the isci driver with a sas
disk.  Meelis saw it with aic7xxx on a parallel scsi disk.

--
Dan
