Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1I1E1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 00:27:08 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51889 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1I1E1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 00:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <201109271134.06410.philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
 <1316788285-17433-10-git-send-email-philipp.reisner@linbit.com>
 <CAGZ=bq+Ef+wy8E9taBv=vZfTdvC_VBFFD=GzNqR9Em46U-wMmg@mail.gmail.com> <201109271134.06410.philipp.reisner@linbit.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 28 Sep 2011 00:26:45 -0400
Message-ID: <CAGZ=bqL=K6v+jxZOwv-=iL=MjOpoJ4JRAPLTtwdHNW_CsFc4GA@mail.gmail.com>
Subject: Re: [PATCH 09/10] drbd: Remove volume numbers from struct p_header95
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 05:34, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> Am Freitag, 23. September 2011, 19:28:24 schrieb Kyle Moffett:
>> On Fri, Sep 23, 2011 at 10:31, Philipp Reisner <philipp.reisner@linbit.com> wrote:
>> > diff --git a/drivers/block/drbd/drbd_main.c
>> > b/drivers/block/drbd/drbd_main.c index 3310986..99b467e 100644
>> > --- a/drivers/block/drbd/drbd_main.c
>> > +++ b/drivers/block/drbd/drbd_main.c
>> > @@ -717,11 +717,11 @@ static unsigned int prepare_header80(struct
>> > p_header80 *h, enum drbd_packet cmd, return sizeof(struct p_header80);
>> >  }
>> >
>> > -static unsigned int prepare_header95(struct p_header95 *h, enum
>> > drbd_packet cmd, int size, int vnr) +static unsigned int
>> > prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int size) {
>> >        h->magic   = cpu_to_be16(DRBD_MAGIC_BIG);
>> >        h->command = cpu_to_be16(cmd);
>> > -       h->vol_n_len = cpu_to_be32(vnr << 24 | size);
>> > +       h->length = cpu_to_be32(size);
>> >        return sizeof(struct p_header95);
>> >  }
>>
>> This patch needs a commit message indicating why it does not break
>> compatibility.  If you are guaranteed that the "vnr" passed into
>> prepare_header95 is always zero, then you should indicate why that is
>> true.
>
> Here is the commit message for that one. The alternative is to merge
> that to patch 'drbd: Use new header layout, and send volume IOs'.
> ( Which is patch number 236, i.e. outside of this (10th) posting of
>  DRBD-8.4 patches. It was posted on August 25.
>  See https://lkml.org/lkml/2011/8/25/322 )
>
> Author: Andreas Gruenbacher <agruen@linbit.com>
> Date:   Tue Mar 22 13:17:47 2011 +0100
>
>    drbd: Remove volume numbers from struct p_header95
>
>    Remove the temporal 8 bit volume number form header 95. All connections
>    that support multiple volumes are new using protocol 100 with header 100.

So my concern is that this effectively ignores an old field in
header95, so an old DRBD trying to talk about multiple volumes to a
new DRBD using header95 is going to get its volume number ignored,
right?

This means that old-DRBD and new-DRBD cannot communicate about
multiple volumes over one connection at all.  That needs to be made an
explicit part of this commit message and the rationale explained in
detail.

In particular, you need to make sure to describe what negotiation
mechanism prevents multiple-volume-header95 messages from being sent
to a version of DRBD including this commit.  If that behavior (IE: a
negotiation change) is part of another commit, then this is small
enough that I would merge it with that other commit, but it still
needs comments about why version interoperability will not break.

It seems to me like DRBD has historically not been terribly strict
with backwards-compatibility to very old versions, but now that it is
in the upstream kernel that is a very serious concern.  With an
out-of-tree module you have a lot more control over exactly which
version you are running, but when it's in-tree you are stuck with
whatever your vendor's kernel version is (for the most part).  Any
time you change or break backwards compatibility there needs to be at
the very *least* a detailed comment indicating why it needs to be
broken and exactly how you avoid additional complications from that.

Cheers,
Kyle Moffett
