Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0H0WwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:52:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45072 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab0H0WwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H1e6tCp5qK/j8wbesJl3dpX0pxEWZaGPibzFhsV4BGJCc2vlSd06HUBPC4apsUVDvA
         bWeDXrEYsd3l6802t8lzQr30vnWobwvz7lI/ZbWxJIPW39UpPD0tMgKg7daoAuWdwZ4h
         p1gP9UavDTqjpPz1uAii5zFCK7grsjeoIk1HI=
MIME-Version: 1.0
In-Reply-To: <20100827223926.GB32498@bougret.hpl.hp.com>
References: <20100827210240.GC4703@outflux.net> <20100827212254.GB32275@bougret.hpl.hp.com>
 <AANLkTimeEa_=dqX5yFnYzaSaL90TfOg3=MsydG81naAC@mail.gmail.com> <20100827223926.GB32498@bougret.hpl.hp.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 27 Aug 2010 15:51:47 -0700
Message-ID: <AANLkTinZmG-bv_m0ktL+NBbtMRtHkM+urfD9M1GdLxCD@mail.gmail.com>
Subject: Re: [PATCH] wireless: fix 64K kernel heap content leak via ioctl
To: jt@hpl.hp.com
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 3:39 PM, Jean Tourrilhes <jt@hpl.hp.com> wrote:
> On Fri, Aug 27, 2010 at 03:35:19PM -0700, Luis R. Rodriguez wrote:
>> >
>> > diff -u -p wext.j2.c wext.c
>> > --- wext.j2.c   2010-08-27 14:17:26.000000000 -0700
>> > +++ wext.c      2010-08-27 14:19:33.000000000 -0700
>> > @@ -800,9 +800,12 @@ static int ioctl_standard_iw_point(struc
>> >                        goto out;
>> >                }
>> >
>> > -               if (copy_to_user(iwp->pointer, extra,
>> > -                                iwp->length *
>> > -                                descr->token_size)) {
>> > +               /* Verify how much we should return. Some driver
>> > +                * may abuse iwp->length... */
>> > +               if((iwp->length * descr->token_size) < extra_size)
>> > +                       extra_size = iwp->length * descr->token_size;
>> > +
>> > +               if (copy_to_user(iwp->pointer, extra, extra_size)) {
>> >                        err = -EFAULT;
>> >                        goto out;
>> >                }
>>
>>
>> Jean, can you submit in a new thread and right before the SOB add in
>> the commit log Cc: stable@kernel.org [2.6.32+]
>
>        The current patch was made for 2.6.27 and was only
> compiled. Someone would need to verify it works for 2.6.32. I could
> probably find some time next week.

Got it, ah so it would be Cc: stable@kernel.org [2.6.27+]. To get this
trickled in we first need it for wireless-testing.git, and provide
links / patches to the backport of the patch for each kernel. Once it
gets merged into Linus' tree the stable team can apply the respective
backported patches.

  Luis
