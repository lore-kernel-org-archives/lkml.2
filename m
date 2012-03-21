Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab2CUBWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:22:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44327 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab2CUBWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120320162157.GE17071@redhat.com>
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
Date: Wed, 21 Mar 2012 09:22:46 +0800
X-Google-Sender-Auth: B9GgJ8PqJxtQUIPsdVdepA8JsmA
Message-ID: <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
Subject: Re: [patch v2 2/6] blk: dont allow discard request merge temporarily
From: Shaohua Li <shli@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
        axboe@kernel.dk, martin.petersen@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/21 Vivek Goyal <vgoyal@redhat.com>:
> On Fri, Mar 16, 2012 at 03:32:15PM +0800, Shaohua Li wrote:
>> Didn't allow discard request merge temporarily, as SCSI layer isn't ready
>> for discard merge as Martin Petersen pointed out. This isn't fair for
>> non-scsi device, but looks this is the only way I can do currently.
>>
>> We should have the same issue before, but maybe because discard merge is
>> very rare case. But now raid0/10 makes the merge quite possible, so we need
>> disable it explicitly.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>> ---
>>  include/linux/blkdev.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: linux/include/linux/blkdev.h
>> ===================================================================
>> --- linux.orig/include/linux/blkdev.h 2012-03-14 09:20:06.787261188 +0800
>> +++ linux/include/linux/blkdev.h      2012-03-14 09:20:47.797261248 +0800
>> @@ -575,7 +575,7 @@ static inline void blk_clear_queue_full(
>>   * it already be started by driver.
>>   */
>>  #define RQ_NOMERGE_FLAGS     \
>> -     (REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
>> +     (REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_DISCARD)
>>  #define rq_mergeable(rq)     \
>>       (!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
>>        (((rq)->cmd_flags & REQ_DISCARD) || \
>
> I think you will need to do little more cleanup to make discard
> unmergeable.
>
> - Change rq_mergeable(rq)
> - Change attempt_merge() and get rid of special conditions of allowing
>  discard merge.
>
> Martin had a bigger patch where he wanted to cleanup many discard specific
> condition checks.
>
> As you are just focusing on disabling merging for discard requests, you
> might as well just pick the relevant pieces from the patch.
>
> http://www.spinics.net/lists/linux-scsi/msg57779.html
Thanks for pointing out the thread. I didn't think disabling discard merging
permanently is a good idea. We can't do the merge because that code isn't
ready (actually just for driver of SCSI). Enabling discard merge is required
for device with slow discard (and very helpful for raid), so I just want a
temporarily disabling for the merge. Just changing RQ_NOMERGE_FLAGS
is an easy workaround for this goal.

Thanks,
Shaohua
