Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab0LCOjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:39:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51212 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0LCOjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:39:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uJvSjTQDamZE9k1lnWjggVzi3GANASqYcu9Q/jo9rKDpKpByozRbVTrcg2su6x9S+j
         zBD8bYZJalnyDeD9A+MUo1R6DQq2wgbAUJFZpdt/poe/MY8UI5lelR+Aq8KiT/nyo/dw
         kidAHL+05pqKCMfgP46zFrmmYMRTB+k58xQfI=
MIME-Version: 1.0
In-Reply-To: <20101203143256.GA30407@redhat.com>
References: <AANLkTi=aqMR0uNCgz40pdUG1288CMxLRnZdVxzZuBzGw@mail.gmail.com>
	<20101130145712.GD26758@redhat.com>
	<AANLkTik_x-SSU1aazJ3ZqJdsbq11vh3+=ikwbpxNcRYh@mail.gmail.com>
	<20101201144128.GC4672@redhat.com>
	<AANLkTinGChRaNUeH+AzS+6Y3Au+0BR1Mz97W8aDSoyQf@mail.gmail.com>
	<20101203143256.GA30407@redhat.com>
Date: Fri, 3 Dec 2010 22:39:34 +0800
Message-ID: <AANLkTi=Hw7G3N2t+uE-VPXcpYsUB_2Pcgsyq71_M51_=@mail.gmail.com>
Subject: Re: [PATCH] maximize dispatching in block throttle
From: Hillf Danton <dhillf@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 3, 2010 at 10:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Dec 03, 2010 at 10:26:50PM +0800, Hillf Danton wrote:
>> On Wed, Dec 1, 2010 at 10:41 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Wed, Dec 01, 2010 at 09:30:00PM +0800, Hillf Danton wrote:
>> >> On Tue, Nov 30, 2010 at 10:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > On Fri, Nov 26, 2010 at 10:46:01PM +0800, Hillf Danton wrote:
>> >> >> When dispatching bio, the quantum is divided into read/write budgets,
>> >> >> and dispatching for write could not exceed the write budget even if
>> >> >> the read budget is not exhausted, either dispatching for read.
>> >> >>
>> >> >> It is changed to exhaust the quantum, if possible, in this work for
>> >> >> dispatching bio.
>> >> >>
>> >> >> Though it is hard to understand that 50/50 division is not selected,
>> >> >> the difference between divisions could impact little on dispatching as
>> >> >> much as quantum allows then.
>> >> >>
>> >> >> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> >> >> ---
>> >> >
>> >> > Hi Hillf,
>> >> >
>> >> > Even if there are not enough READS/WRITES to consume the quantum, I don't
>> >> > think that it changes anyting much. The next dispatch round will be
>> >>
>> >> Why not exhaust quantum this round directly if not throttled?
>> >>
>> >
>> > Yes we can do that. I am wondering what do we gain by putting extra code
>> > in?
>> >
>> >> > scheduled almost immediately (If there are bios which are ready to
>> >> > be dispatched). Look at throtl_schedule_next_dispatch().
>> >> >
>> >> > Have you noticed some issues/improvements with this patch?
>> >>
>> >> Originally I wanted to get 75/25 division parameterized through sysfs or proc,
>> >> but I changed mind since exhausting quantum is simpler and much applicable.
>> >
>> > But these are two different things isn't it?
>> >
>> > We can introduce some sysfs tunables (if need be) so that a user can decide
>> > the division of READS/WRITES.
>> >
>> >>
>> >> As you see, the application environments change from one user to another,
>> >> even though are more latency sensitive.
>> >>
>> >> It looks nicer, I think, to provide both the default division and the
>> >> methods to
>> >> change for users to play their games.
>> >
>> > Yep, tunables can help here and introducing tunables is easy. At the same
>>
>> If it is too hard, please change to what is more valuable.
>> Hillf
>
> It should not be too hard. IO schedulers already create
> /sys/block/<dev>/queue/iosched/ dir and we can create <dev>/queue/throttle/
> dir and export throttle related tunables there.

I will try along this direction, thanks.

>
> What I am not clear about is that what problem are you running into.
> Tunbales and your patch to fill the quantum are two different things. So
> how can both the things solve your problem. One of these should.

I could not work it out over one week. That is all.

Thanks again for sharing so much on the tunable.

Good weekend

Hillf

>
> So if you can explain the issue you are facing with some more details, it
> will help. I am not sure how your patch of filling the quantum with
> requests of other direction is helping you?
>
> Vivek
>
>>
>> > time I prefer to intoroduce tunables only on need basis otherwise it
>> > runs the risk of too many tunables which are not being used.
>> >
>> > So, conceptually this patch looks fine to me. Jeff Moyer also raised the
>> > same question of why not fill up the quantum if READ/WRITE are not using
>> > their quota. So I think it does not hurt to take this patch in.
>> >
>> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
>> >
>> > Thanks
>> > Vivek
>> >
>> >>
>> >> Thanks
>> >> Hillf
>> >>
>> >> >
>> >> > Generally READS are more latency sensitive as compared to WRITE hence
>> >> > I thought of dispatching more READS per quantum.
>> >> >
>> >> > Thanks
>> >> > Vivek
>> >> >
>> >> >>
>> >> >> --- a/block/blk-throttle.c    2010-11-01 19:54:12.000000000 +0800
>> >> >> +++ b/block/blk-throttle.c    2010-11-26 21:49:00.000000000 +0800
>> >> >> @@ -647,11 +647,16 @@ static int throtl_dispatch_tg(struct thr
>> >> >>       unsigned int max_nr_reads = throtl_grp_quantum*3/4;
>> >> >>       unsigned int max_nr_writes = throtl_grp_quantum - nr_reads;
>> >> >>       struct bio *bio;
>> >> >> +     int read_throttled = 0, write_throttled = 0;
>> >> >>
>> >> >>       /* Try to dispatch 75% READS and 25% WRITES */
>> >> >> -
>> >> >> + try_read:
>> >> >>       while ((bio = bio_list_peek(&tg->bio_lists[READ]))
>> >> >> -             && tg_may_dispatch(td, tg, bio, NULL)) {
>> >> >> +             && ! read_throttled) {
>> >> >> +             if (! tg_may_dispatch(td, tg, bio, NULL)) {
>> >> >> +                     read_throttled = 1;
>> >> >> +                     break;
>> >> >> +             }
>> >> >>
>> >> >>               tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
>> >> >>               nr_reads++;
>> >> >> @@ -659,9 +664,15 @@ static int throtl_dispatch_tg(struct thr
>> >> >>               if (nr_reads >= max_nr_reads)
>> >> >>                       break;
>> >> >>       }
>> >> >> -
>> >> >> +     if (! bio)
>> >> >> +             read_throttled = 1;
>> >> >> + try_write:
>> >> >>       while ((bio = bio_list_peek(&tg->bio_lists[WRITE]))
>> >> >> -             && tg_may_dispatch(td, tg, bio, NULL)) {
>> >> >> +             && ! write_throttled) {
>> >> >> +             if (! tg_may_dispatch(td, tg, bio, NULL)) {
>> >> >> +                     write_throttled = 1;
>> >> >> +                     break;
>> >> >> +             }
>> >> >>
>> >> >>               tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
>> >> >>               nr_writes++;
>> >> >> @@ -669,7 +680,23 @@ static int throtl_dispatch_tg(struct thr
>> >> >>               if (nr_writes >= max_nr_writes)
>> >> >>                       break;
>> >> >>       }
>> >> >> +     if (! bio)
>> >> >> +             write_throttled = 1;
>> >> >> +
>> >> >> +     if (write_throttled && read_throttled)
>> >> >> +             goto out;
>> >> >>
>> >> >> +     if (! (throtl_grp_quantum > nr_writes + nr_reads))
>> >> >> +             goto out;
>> >> >> +
>> >> >> +     if (read_throttled) {
>> >> >> +             max_nr_writes = throtl_grp_quantum - nr_reads;
>> >> >> +             goto try_write;
>> >> >> +     } else {
>> >> >> +             max_nr_reads = throtl_grp_quantum - nr_writes;
>> >> >> +             goto try_read;
>> >> >> +     }
>> >> >> + out:
>> >> >>       return nr_reads + nr_writes;
>> >> >>  }
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> >> Please read the FAQ at  http://www.tux.org/lkml/
>> >> >
>> >
>
