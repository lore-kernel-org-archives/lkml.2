Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0GITp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:45:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41185 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab0GITpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WpAKyDJow6Nq/88SPKGIqvmvK3EpQz/NRSngplBAFUedP76l61Wha86J/jrOqzgqxW
         t1GJ9o3uMy0wZn5FMsv+cvwGHZqhNossa4nDfyimZEhVAj53X7trpQs55U4pcxryq6DR
         lx1S4k3UC49Oe9P1y0pPgc1JWHidzyeMfBFZU=
MIME-Version: 1.0
In-Reply-To: <x49fwzsbvga.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
	<x49fwzsbvga.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 9 Jul 2010 21:45:22 +0200
Message-ID: <AANLkTilJFQITg7qK5gKJ9Rwt06KA6fvDr7Ed9u7cbwBX@mail.gmail.com>
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

On Fri, Jul 9, 2010 at 4:07 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> On Wed, Jul 7, 2010 at 10:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>>
>>>> On Wed, Jul 7, 2010 at 7:03 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>>>>
>>>>>> Hi Jens,
>>>>>> patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
>>>>>> suspected for some regressions on high end hardware.
>>>>>> The two patches from this series:
>>>>>> - [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
>>>>>> - [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
>>>>>> fix two issues that I have identified, related to how RQ_NOIDLE is
>>>>>> used by the upper layers.
>>>>>> First patch makes sure that a RQ_NOIDLE coming after a sequence of
>>>>>> possibly idling requests from the same queue on the no-idle tree will
>>>>>> clear the noidle_tree_requires_idle flag.
>>>>>> Second patch enables RQ_NOIDLE for queues in the idling tree,
>>>>>> restoring the behaviour pre-8e55063 patch.
>>>>>
>>>>> Hi, Corrado,
>>>>>
>>>>> I ran your kernel through my tests.  Here are the results, up against
>>>>> vanilla, deadline, and the blk_yield patch set:
>>>>>
>>>> Hi Jeff,
>>>> can you also add cfq with 8e55063 reverted to the testing mix?
>>>
>>> Sure, the results now look like this:
>>>
>>>                 just    just
>>>                fs_mark  fio        mixed
>>> -------------------------------+--------------
>>> deadline        529.44   151.4 | 450.0    78.2
>>> vanilla cfq     107.88   164.4 |   6.6   137.2
>>> blk_yield cfq   530.82   158.7 | 113.2    78.6
>>> corrado cfq     110.16   220.6 |   7.0   159.8
>>> 8e55063 revert  559.66   198.9 |  16.1   153.3
>>>
>>> I had accidentally run your patch set (corrado cfq) on ext3, so the
>>> numbers were a bit off (everything else was run against ext4).  The
>>> corrected numbers above reflect the performance on ext4, which is much
>>> better for the sequential reader, but still not great for the fs_mark
>>> run.  Reverting 8e55063 definitely gets us into better shape.  However,
>>> if we care about the mixed workload, then it won't be enough.
>>
>> Wondering why deadline performs so well in the fs_mark workload. Is it
>> because it doesn't distinguish between sync and async writes?
>
> It performs well because it doesn't do any idling.
>
>> Maybe we can achieve something similar by putting all sync writes
>> (that are marked as REQ_NOIDLE) in the noidle tree? This, coupled with
>> making jbd(2) perform sync writes, should make the yield automatic,
>> since they all live in the same tree for which we don't idle between
>> queues, and should be able to provide fairness compared to a
>> sequential reader (that lives in the other tree).
>>
>> Can you test the attached patch, where I also added your changes to
>> make jbd(2) to perform sync writes?
>
> I'm not sure what kernel you generated that patch against.  I'm working
> with 2.6.35-rc3 or later, and your patch does not apply there.
It's Jens' block/for-2.6.36 tree.

>
> Cheers,
> Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
