Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0GHOpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:45:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65296 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0GHOpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YhhqZXKvnmXEUv6x/dXCdPh7W3qZxOeEvwP7wulHA7doQ2oxpPqy2n/YX66VaIzbMa
         TcGN2UAdCBLDCK1fOdwgV34Ay8Up/vILnepnaQh0w9BMF6oVxCScsJ53maYfzXZ01ees
         IJOoX9HajRXE26iAxBZLZOc5GyLOLrdHRTouY=
MIME-Version: 1.0
In-Reply-To: <20100708143512.GE5093@redhat.com>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<20100708143512.GE5093@redhat.com>
Date: Thu, 8 Jul 2010 16:45:10 +0200
Message-ID: <AANLkTindzlcDSA9zZBNYXv9o-RGtpysb0_IYp9UFlM2_@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 4:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jul 07, 2010 at 01:03:08PM -0400, Jeff Moyer wrote:
>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>
>> > Hi Jens,
>> > patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
>> > suspected for some regressions on high end hardware.
>> > The two patches from this series:
>> > - [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
>> > - [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
>> > fix two issues that I have identified, related to how RQ_NOIDLE is
>> > used by the upper layers.
>> > First patch makes sure that a RQ_NOIDLE coming after a sequence of
>> > possibly idling requests from the same queue on the no-idle tree will
>> > clear the noidle_tree_requires_idle flag.
>> > Second patch enables RQ_NOIDLE for queues in the idling tree,
>> > restoring the behaviour pre-8e55063 patch.
>>
>> Hi, Corrado,
>>
>> I ran your kernel through my tests.  Here are the results, up against
>> vanilla, deadline, and the blk_yield patch set:
>>
>>                  just    just
>>                 fs_mark  fio        mixed
>> -------------------------------+--------------
>> deadline        529.44   151.4 | 450.0    78.2
>> vanilla cfq     107.88   164.4 |   6.6   137.2
>> blk_yield cfq   530.82   158.7 | 113.2    78.6
>> corrado cfq      80.82   138.1 |   4.5   130.7
>>
>> fs_mark results are in files/second, fio results are in MB/s.  All
>> results are the average of 5 runs.  In order to get results for the
>> mixed workload for both vanilla and Corrado's kernels, I had to extend
>> the runtime from 30s to 300s.
>>
>> So, the changes proposed in this thread actually make performance worse
>> across the board.
>>
>> I re-ran my tests against a RHEL 5 kernel (which is based on 2.6.18),
>> and it shows that fs_mark performance is much better than stock CFQ in
>> 2.6.35-rc3, and the mixed workload results are much the same as they are
>> now (which is to say, the fs_mark process is completely starved by the
>> sequential reader).  So, that problem has existed for a long time.
>>
>> I'm still in the process of collecting data from production servers and
>> will report back with my findings there.
>
> Hi Jeff and all,
>
> How about if we simply get rid of idling on RQ_NOIDLE threads (as
> corrado's patch series does) and not try to solve the problem of fsync
> being starved in the presence of sequential readers. I mean it might just
> be a theoritical problem and not many people are running into it. That's
> how CFQ has been behaving for long-2 time and if nobody is complaining
> then we probably don't have to fix it.

8e55063 was done to fix theoretical problems as well :)
I think, instead, that Jeff's approach of yielding the queue when a
better knowledge is present is good, and this set of patches is not
intended as a replacement. It is intended just to fix some regressions
introduced by a previous commit, and I hope it could work together
with Jeff's patch.
Clearly, if RQ_NOIDLE is used only in the places that Jeff is already
handling, then it is better to completely remove RQ_NOIDLE handling,
so my patch set becomes obsolete.

Thanks,
Corrado
>
> Thanks
> Vivek
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
