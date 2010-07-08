Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0GHOiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:38:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44716 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab0GHOiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kBtvMblJ1ptNKWUrTrhu0O3pjlcYJ+h67omCjJu18mivi7MHKL5AnbxxbqHrAnJ2Bm
         09pXQCq6OHLUywzRv+JgNfwSKzV1nuFsdyREfTEI4AUxSKykqIXIXsaprR9QWCRH6q44
         AhWJYEgaB/s3FaROFMuLs/hOkRGvDhRtshNN4=
MIME-Version: 1.0
In-Reply-To: <x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 8 Jul 2010 16:38:22 +0200
Message-ID: <AANLkTilFG_nG-JHmfHK-f_9DXb7IHCbshswjHtDq9I4I@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 10:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> On Wed, Jul 7, 2010 at 7:03 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>>
>>>> Hi Jens,
>>>> patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
>>>> suspected for some regressions on high end hardware.
>>>> The two patches from this series:
>>>> - [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
>>>> - [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
>>>> fix two issues that I have identified, related to how RQ_NOIDLE is
>>>> used by the upper layers.
>>>> First patch makes sure that a RQ_NOIDLE coming after a sequence of
>>>> possibly idling requests from the same queue on the no-idle tree will
>>>> clear the noidle_tree_requires_idle flag.
>>>> Second patch enables RQ_NOIDLE for queues in the idling tree,
>>>> restoring the behaviour pre-8e55063 patch.
>>>
>>> Hi, Corrado,
>>>
>>> I ran your kernel through my tests.  Here are the results, up against
>>> vanilla, deadline, and the blk_yield patch set:
>>>
>> Hi Jeff,
>> can you also add cfq with 8e55063 reverted to the testing mix?
>
> Sure, the results now look like this:
>
>                 just    just
>                fs_mark  fio        mixed
> -------------------------------+--------------
> deadline        529.44   151.4 | 450.0    78.2
> vanilla cfq     107.88   164.4 |   6.6   137.2
> blk_yield cfq   530.82   158.7 | 113.2    78.6
> corrado cfq     110.16   220.6 |   7.0   159.8
> 8e55063 revert  559.66   198.9 |  16.1   153.3
>
> I had accidentally run your patch set (corrado cfq) on ext3, so the
> numbers were a bit off (everything else was run against ext4).  The
> corrected numbers above reflect the performance on ext4, which is much
> better for the sequential reader, but still not great for the fs_mark
> run.  Reverting 8e55063 definitely gets us into better shape.  However,
> if we care about the mixed workload, then it won't be enough.

I wonder why 8e55063 revert gives such a big improvement on fsync ops.
Maybe, before 8e55063, we ended up not idling even if
cfq_arm_slice_timer was called, due to other requests still pending?
I think your patch that allows both async and sync requests to be in
flight at the same time could help here.

>
> It's worth noting that I can't explain that jump from 151MB/s for
> deadline vs 220MB/s for corrado cfq.  I'm not sure how you can vary
> driving a single queue depth sequential read at all.  Those are the
> averages of 5 runs and this storage should be solely accessible by me,
> so I am at a loss.

I guess ext4 tries to be smart, and issues some background reads of fs
data structures needed to keep reading the sequential file without
interruption.
Those reads will be far from the current head, so if you service them
immediately (as deadline would), they can cause a degradation, while
delaying them to when you are servicing other random requests (as cfq
would) can help.

>
> Cheers,
> Jeff
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
