Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0JONzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:55:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49823 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab0JONzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sxyBdpUH7UZeRzz3t6MyrVDJGUyvXoOn2941I+tzMY5WC/4XuW5xHZS2haGIu2OTjn
         tfdNFrtJX4kY8cK16t+/nrQgQajDd37tAjDCogj5Gp8aUDi+/rZez8Ev//veVebkDO93
         Db3tOO3oYPIfMMHSbhoReBhpYJuypBorhgBcY=
MIME-Version: 1.0
In-Reply-To: <201010141019.23547.br1@einfach.org>
References: <20101006093225.8739.14012.stgit@tt-desk> <AANLkTikzq-d4s83kx-RWv5_D2TN4bEDHKUqyaLo8z=5+@mail.gmail.com>
 <201010141019.23547.br1@einfach.org>
From: kevin granade <kevin.granade@gmail.com>
Date: Fri, 15 Oct 2010 08:55:23 -0500
Message-ID: <AANLkTim+wuzaak=VP3uq=SefGMq_fzr3MR0yF+PKQTdw@mail.gmail.com>
Subject: Re: [PATCH] Add generic exponentially weighted moving average function
To: Bruno Randolf <br1@einfach.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 8:19 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Wed October 13 2010 23:01:16 kevin granade wrote:
>> On Wed, Oct 6, 2010 at 4:32 AM, Bruno Randolf <br1@einfach.org> wrote:
>> > This adds a generic exponentially weighted moving average function. This
>> > implementation makes use of a structure which keeps a scaled up internal
>> > representation to reduce rounding errors.
>> >
>> > The idea for this implementation comes from the rt2x00 driver
>> > (rt2x00link.c) and i would like to use it in several places in the
>> > mac80211 and ath5k code.
>> >
>> > Signed-off-by: Bruno Randolf <br1@einfach.org>
>> >
>> > --
>> > Is this the right place to add it? Who to CC:?
>> > ---
>> >  include/linux/average.h |   32 ++++++++++++++++++++++++++++++++
>> >  1 files changed, 32 insertions(+), 0 deletions(-)
>> >  create mode 100644 include/linux/average.h
>> >
>> > diff --git a/include/linux/average.h b/include/linux/average.h
>> > new file mode 100644
>> > index 0000000..2a00d3d
>> > --- /dev/null
>> > +++ b/include/linux/average.h
>> > @@ -0,0 +1,32 @@
>> > +#ifndef _LINUX_AVERAGE_H
>> > +#define _LINUX_AVERAGE_H
>> > +
>> > +#define AVG_FACTOR     1000
>>
>> If this is going to be general use, wouldn't it be a good feature to
>> make AVG_FACTOR adjustable?
>
> Yes, could be, but how? Another argument to the function call?
> Actually AVG_FACTOR and 'samples' should stay constant for each struct, so we
> could also store them in the struct, but that would require an inititalization
> of the struct before we can use it.

That's true, I can't think of a way of adding this without
significantly dirtying the interface.  And to be honest, it isn't a,
"I might be using this, so it'd be nice to have", but rather a general
observation.  I guess if someone needs a different decay rate at some
point then they can worry about it.

>
>> > +
>> > +struct avg_val {
>> > +       int value;
>> > +       int internal;
>> > +};
>>
>> This has a scaled up copy of the moving average, which reduces the
>> available range for the average to MAX_INT/(AVG_FACTOR*num_samples)
>> instead of +/- MAX_INT, is that acceptable?  Even if it is, shouldn't
>> it be documented?  For example, with num_samples = 10, it will roll
>> over to a negative value if the average exceeds 214,748.  This seems
>> like a potentially surprising outcome.
>
> Yes. I'll document this in the next version of the patch. Or should I use
> 64bit for the internal representation?

If you don't expect the size or speed impact to be significant, it
seems like just throwing a bigger number at the problem might be the
better option.  That will move the rollover to MAX_INT/AVG_FACTOR,
unless you also make AVG_FACTOR 64bit, which will promote all of the
multiplications to 64bit and provide full MAX_INT range for input and
output.

>
>> > +/**
>> > + * moving_average -  Exponentially weighted moving average
>> > + * @avg: average structure
>> > + * @val: current value
>> > + * @samples: number of samples
>> > + *
>> > + * This implementation make use of a struct avg_val to prevent rounding
>> > + * errors.
>> > + */
>> > +static inline struct avg_val
>> > +moving_average(const struct avg_val avg, const int val, const int
>> > samples) +{
>> > +       struct avg_val ret;
>> > +       ret.internal = avg.internal  ?
>> > +               (((avg.internal * (samples - 1)) +
>>
>> > +                       (val * AVG_FACTOR)) / samples) :
>> I'm not sure what the kernel standard is on this, but is it ok to have
>> this potential div/0 in a general purpose function?
>
> Samples should never be 0. But I can add a WARN_ON...
>
> bruno
>

I couldn't find anything that clearly indicated what the expected
precaution is in this case.  It probably isn't an issue now that I
understand that samples is intended to remain constant.  I initially
thought samples would scale from 1 - n as you were initially "loading"
samples into the structure, but now I understand that samples remains
at n throughout the process.

Kevin Granade
