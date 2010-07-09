Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0GIOHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab0GIOHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:07:08 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 09 Jul 2010 10:07:01 -0400
In-Reply-To: <AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
	(Corrado Zoccolo's message of "Fri, 9 Jul 2010 12:33:36 +0200")
Message-ID: <x49fwzsbvga.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> On Wed, Jul 7, 2010 at 10:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>
>>> On Wed, Jul 7, 2010 at 7:03 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>>>
>>>>> Hi Jens,
>>>>> patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
>>>>> suspected for some regressions on high end hardware.
>>>>> The two patches from this series:
>>>>> - [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
>>>>> - [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
>>>>> fix two issues that I have identified, related to how RQ_NOIDLE is
>>>>> used by the upper layers.
>>>>> First patch makes sure that a RQ_NOIDLE coming after a sequence of
>>>>> possibly idling requests from the same queue on the no-idle tree will
>>>>> clear the noidle_tree_requires_idle flag.
>>>>> Second patch enables RQ_NOIDLE for queues in the idling tree,
>>>>> restoring the behaviour pre-8e55063 patch.
>>>>
>>>> Hi, Corrado,
>>>>
>>>> I ran your kernel through my tests.  Here are the results, up against
>>>> vanilla, deadline, and the blk_yield patch set:
>>>>
>>> Hi Jeff,
>>> can you also add cfq with 8e55063 reverted to the testing mix?
>>
>> Sure, the results now look like this:
>>
>>                 just    just
>>                fs_mark  fio        mixed
>> -------------------------------+--------------
>> deadline        529.44   151.4 | 450.0    78.2
>> vanilla cfq     107.88   164.4 |   6.6   137.2
>> blk_yield cfq   530.82   158.7 | 113.2    78.6
>> corrado cfq     110.16   220.6 |   7.0   159.8
>> 8e55063 revert  559.66   198.9 |  16.1   153.3
>>
>> I had accidentally run your patch set (corrado cfq) on ext3, so the
>> numbers were a bit off (everything else was run against ext4).  The
>> corrected numbers above reflect the performance on ext4, which is much
>> better for the sequential reader, but still not great for the fs_mark
>> run.  Reverting 8e55063 definitely gets us into better shape.  However,
>> if we care about the mixed workload, then it won't be enough.
>
> Wondering why deadline performs so well in the fs_mark workload. Is it
> because it doesn't distinguish between sync and async writes?

It performs well because it doesn't do any idling.

> Maybe we can achieve something similar by putting all sync writes
> (that are marked as REQ_NOIDLE) in the noidle tree? This, coupled with
> making jbd(2) perform sync writes, should make the yield automatic,
> since they all live in the same tree for which we don't idle between
> queues, and should be able to provide fairness compared to a
> sequential reader (that lives in the other tree).
>
> Can you test the attached patch, where I also added your changes to
> make jbd(2) to perform sync writes?

I'm not sure what kernel you generated that patch against.  I'm working
with 2.6.35-rc3 or later, and your patch does not apply there.

Cheers,
Jeff
