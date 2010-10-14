Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0JNBTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:19:16 -0400
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:45222 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753205Ab0JNBTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:19:15 -0400
From: Bruno Randolf <br1@einfach.org>
To: kevin granade <kevin.granade@gmail.com>
Subject: Re: [PATCH] Add generic exponentially weighted moving average function
Date: Thu, 14 Oct 2010 10:19:23 +0900
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        akpm <akpm@linux-foundation.org>
References: <20101006093225.8739.14012.stgit@tt-desk> <AANLkTikzq-d4s83kx-RWv5_D2TN4bEDHKUqyaLo8z=5+@mail.gmail.com>
In-Reply-To: <AANLkTikzq-d4s83kx-RWv5_D2TN4bEDHKUqyaLo8z=5+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010141019.23547.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed October 13 2010 23:01:16 kevin granade wrote:
> On Wed, Oct 6, 2010 at 4:32 AM, Bruno Randolf <br1@einfach.org> wrote:
> > This adds a generic exponentially weighted moving average function. This
> > implementation makes use of a structure which keeps a scaled up internal
> > representation to reduce rounding errors.
> > 
> > The idea for this implementation comes from the rt2x00 driver
> > (rt2x00link.c) and i would like to use it in several places in the
> > mac80211 and ath5k code.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > --
> > Is this the right place to add it? Who to CC:?
> > ---
> >  include/linux/average.h |   32 ++++++++++++++++++++++++++++++++
> >  1 files changed, 32 insertions(+), 0 deletions(-)
> >  create mode 100644 include/linux/average.h
> > 
> > diff --git a/include/linux/average.h b/include/linux/average.h
> > new file mode 100644
> > index 0000000..2a00d3d
> > --- /dev/null
> > +++ b/include/linux/average.h
> > @@ -0,0 +1,32 @@
> > +#ifndef _LINUX_AVERAGE_H
> > +#define _LINUX_AVERAGE_H
> > +
> > +#define AVG_FACTOR     1000
> 
> If this is going to be general use, wouldn't it be a good feature to
> make AVG_FACTOR adjustable?

Yes, could be, but how? Another argument to the function call?
Actually AVG_FACTOR and 'samples' should stay constant for each struct, so we 
could also store them in the struct, but that would require an inititalization 
of the struct before we can use it.

> > +
> > +struct avg_val {
> > +       int value;
> > +       int internal;
> > +};
> 
> This has a scaled up copy of the moving average, which reduces the
> available range for the average to MAX_INT/(AVG_FACTOR*num_samples)
> instead of +/- MAX_INT, is that acceptable?  Even if it is, shouldn't
> it be documented?  For example, with num_samples = 10, it will roll
> over to a negative value if the average exceeds 214,748.  This seems
> like a potentially surprising outcome.

Yes. I'll document this in the next version of the patch. Or should I use 
64bit for the internal representation?

> > +/**
> > + * moving_average -  Exponentially weighted moving average
> > + * @avg: average structure
> > + * @val: current value
> > + * @samples: number of samples
> > + *
> > + * This implementation make use of a struct avg_val to prevent rounding
> > + * errors.
> > + */
> > +static inline struct avg_val
> > +moving_average(const struct avg_val avg, const int val, const int
> > samples) +{
> > +       struct avg_val ret;
> > +       ret.internal = avg.internal  ?
> > +               (((avg.internal * (samples - 1)) +
> 
> > +                       (val * AVG_FACTOR)) / samples) :
> I'm not sure what the kernel standard is on this, but is it ok to have
> this potential div/0 in a general purpose function?

Samples should never be 0. But I can add a WARN_ON...

bruno
