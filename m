Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1AUIN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:13:58 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44535 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab1AUIN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:13:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U6Kwgs7FnZGI5F9HLcvbctey0lSulU10fHBjeXcssYAeatw92K+GjOgPzqnDI6Puvd
         xe5veARvC1QY0iuDkM1vhcptAftiGqoxdWxXvrVYQuVheHNQD3wWg9mKAUl+XZCeYg7b
         OvqFXwQo66rddR5/eSBPYLRXI6kqro4d6ErQ4=
MIME-Version: 1.0
In-Reply-To: <1295596348.32373.18.camel@debian>
References: <1295402148.4773.143.camel@debian>
	<AANLkTin6M=tX+NZGstP-ZG9uSQ487XisRpMKKVKHYnQ5@mail.gmail.com>
	<1295596057.32373.16.camel@debian>
	<1295596348.32373.18.camel@debian>
Date: Fri, 21 Jan 2011 09:13:56 +0100
Message-ID: <AANLkTinyDnp1xGm1NyZVJHZdoxZOhTDJDaoLWR=9fwd-@mail.gmail.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs machine
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Jan Kara <jack@suse.cz>, "tytso@mit.edu" <tytso@mit.edu>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 8:52 AM, Alex,Shi <alex.shi@intel.com> wrote:
> Sorry for forgetting Jan and tytso. added again.
>
> On Fri, 2011-01-21 at 15:47 +0800, Alex,Shi wrote:
>> On Fri, 2011-01-21 at 15:23 +0800, Corrado Zoccolo wrote:
>> > On Wed, Jan 19, 2011 at 2:55 AM, Alex,Shi <alex.shi@intel.com> wrote:
>> > > Shaohua and I tested kernel building performance on latest kernel. and
>> > > found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
>> > > system. We find this performance dropping is due to commit
>> > > 749ef9f8423054e326f. If we revert this patch or just change the
>> > > WRITE_SYNC back to WRITE in jbd2/commit.c file. the performance can be
>> > > recovered.
>> > >
>> > > iostat report show with the commit, read request merge number increased
>> > > and write request merge dropped. The total request size increased and
>> > > queue length dropped. So we tested another patch: only change WRITE_SYNC
>> > > to WRITE_SYNC_PLUG in jbd2/commit.c, but nothing effected.
>> > >
>> > > we didn't test deadline IO mode, just test cfq. seems insert write
>> > > request into sync queue effect much read performance, but we don't know
>> > > details. What's your comments of this?
>> > >
>> > > iostat of .37 kernel:
>> > > rrqm/s   wrqm/s r/s     w/s     rMB/s  wMB/s avgrq-sz avgqu-sz   await  svctm  %util
>> > > 22.5772 96.46 92.3742 14.747  1.0048  0.439474 34.8557 0.18078 3.8076 0.30447 2.94302
>> > > iostat of commit reverted .37:
>> > > 26.6223 80.21 107.875 6.03538 1.51415 0 41.3275 0.153385 3.80569 0.377231 3.22323
>> >
>> > From these numbers, it seems to me that with the patch reverted, the
>> > write bandwidth is really low, and probably you are keeping most
>> > written files in the buffer cache during the whole compile, while the
>> > non-reverted kernel is making progress in writing out the files. So
>> > the 'improved' read bandwidth is due to unfairness w.r.t. writes.
>> > Does the result change if you add a final sync and time that as well,
>> > in order to see the full time to make it on disk?
>>
>> Agree with your guess, but kbuild is such kind of benchmark, we can not
>> change its behavior. :(
Why not? Benchmarks should try to model real workloads, and after I
build a kernel, I run lilo, that performs a sync (and typically takes
several seconds). If I used grub, I would pay the sync while
unmounting the filesystem, but I would experience the multi-second
delay anyway.

>>
>>
>> >
>> > I think that in a more extreme test where you end up filling all the
>> > buffer cache with written data, you will see much longer stalls with
>> > the revert than without.
>>
>> Have to do this? and if so, it is not kbuild. :)
It might be, on a machine with fewer ram. Can you try running with
just 1G of ram?
>>
>> BTW, the Jan's patch has a little improvement on kbuild. In many time
>> testing, it seems about 3% improving.
The fact is, does it improve (or at least is a noop) also on
constrained memory systems?

>> The average iostat output of Jan's patch:
>>  rrqm/s   wrqm/s r/s     w/s     rMB/s  wMB/s avgrq-sz avgqu-sz   await  svctm  %util
>> 23.419726 87.450685 96.164521 6.748493 1.046438 0.370137 45.182192 0.200685 6.848767 0.394110 3.072192
>>
>> >
>> > Thanks,
>> > Corrado
>> >
>> > >
>> > > vmstat report show, read bandwidth dropping:
>> > > vmstat of .37:
>> > >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>> > > 3.4 52.6 0.0 64303937.0 16466.7 121544.5 0.0 0.0 2102.7 1914.6 7414.1 3185.7 2.0 1.0 80.3 16.7 0.0
>> > > vmstat of revert all from .37
>> > > 2.2 35.8 0.0 64306767.4 17265.6 126101.2 0.0 0.0 2415.8 1619.1 8532.2 3556.2 2.5 1.1 83.0 13.3 0.0
>> > >
>> > > Regards
>> > > Alex
>> > >
>> > > ===
>> > > diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
>> > > index 34a4861..27ac2f3 100644
>> > > --- a/fs/jbd/commit.c
>> > > +++ b/fs/jbd/commit.c
>> > > @@ -294,7 +294,7 @@ void journal_commit_transaction(journal_t *journal)
>> > >        int first_tag = 0;
>> > >        int tag_flag;
>> > >        int i;
>> > > -       int write_op = WRITE_SYNC;
>> > > +       int write_op = WRITE;
>> > >
>> > >        /*
>> > >         * First job: lock down the current transaction and wait for
>> > > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
>> > > index f3ad159..69ff08e 100644
>> > > --- a/fs/jbd2/commit.c
>> > > +++ b/fs/jbd2/commit.c
>> > > @@ -329,7 +329,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>> > >        int tag_bytes = journal_tag_bytes(journal);
>> > >        struct buffer_head *cbh = NULL; /* For transactional checksums */
>> > >        __u32 crc32_sum = ~0;
>> > > -       int write_op = WRITE_SYNC;
>> > > +       int write_op = WRITE;
>> > >
>> > >        /*
>> > >         * First job: lock down the current transaction and wait for
>> > >
>> > >
>> > >
>> >
>> >
>> >
>>
>
>
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
