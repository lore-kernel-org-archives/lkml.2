Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1CETtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 14:49:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:28693 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1CETtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 14:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=YVcLg6fZgIHqum94KXTVvB4xIgpKYPteQx3vkJeejoyq4BwGcKQ6U5eYEY6LJx/ab3
         1lY2f+UOCh6tKHN5PMNg==
Date: Sat, 5 Mar 2011 11:49:23 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Michal Nazarewicz <mina86@mina86.com>
cc: linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Vlasenko <vda.linux@googlemail.com>, e@gmail.com
Subject: Re: [PATCH mmotm] fix broken bootup on 32-bit
In-Reply-To: <AANLkTikDssqCD-f1E=i-HvKEAMnBMtD5qJq-k5Q3FJKC@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1103051123020.1872@sister.anvils>
References: <alpine.LSU.2.00.1103050436010.4098@sister.anvils> <AANLkTikDssqCD-f1E=i-HvKEAMnBMtD5qJq-k5Q3FJKC@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Mar 2011, Michal Nazarewicz wrote:
> On Mar 5, 2011 1:43 PM, "Hugh Dickins" <hughd@google.com> wrote:
> >
> > mmotm 2011-03-02-16-52 is utterly broken on 32-bit: panics at boot
> > with "Couldn't register console driver", and preceding warnings don't
> > even print their line numbers... which leads to the vsprintf changes.
> 
> Sorry. I must have submitted the wrong version of the patch. I don't know
> how that could happen.

I don't know by what route they got into mmotm:
I can't find them on LKML since last August.

> 
> > Comparing the 32-bit version of put_dec() against mod7_put_dec()
> > in tools/put-dec/put-dec-test.c (ah, it is useful after all!) shows
> > that someone has decided to invert the ordering of pairs of lines
> > in the kernel version of the algorithm, making a nonsense of it.
> 
> Again, I'm at loss of how that happened. I remember Denis pointing this out
> though and me fixing it. In some strange turn of events I must have
> submitted version without the fix.

And what other surprises may have crept in there?

I think you need to get more signoffs from competent (not me!) people,
and (at least for initial submission) a configurable test of the code
that can actually be run at startup in the kernel.

I nearly called the tools/put-dec testing worthless, since what it's
testing is divorced from and different from what's being run in the
kernel.  But that's unfair, it surely helped me to a booting system.

> 
> > Switch them back, and put in the conditionals from mod7_put_dec()
> > (absent from mod6_put_dec??): my guess is that less work is better.
> >
> > My testing has gone no further than booting up, and checking that
> > the numbers in /proc/partitions come out right (which they didn't
> > at my first attempt, when I thought just a one-liner was needed).
> >
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > ---
> > Diffed to go on the top of mmotm, but can be applied after
> > lib-vsprintf-optimised-put_dec-function-fix.patch
> >
> >  lib/vsprintf.c |   33 ++++++++++++++++++++-------------
> >  1 file changed, 20 insertions(+), 13 deletions(-)
> >
> > --- mmotm/lib/vsprintf.c        2011-03-03 15:43:57.000000000 -0800
> > +++ linux/lib/vsprintf.c        2011-03-05 03:37:14.000000000 -0800
> > @@ -310,22 +310,29 @@ char *put_dec(char *buf, unsigned long l
> >
> >        q  = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
> >
> > -       q  = q / 10000;
> >        buf = put_dec_full4(buf, q % 10000);
> > +       q  = q / 10000;
> 
> This should be enough.

Looking at it again this morning, yes, that's the only reordering that
matters, the rest just makes it more recognizably like what's tested.

> 
> >
> >        d1 = q + 7671 * d3 + 9496 * d2 + 6 * d1;
> > -       q  = d1 / 10000;
> > -       buf = put_dec_full4(buf, d1 % 10000);
> > -
> > -       d2 = q + 4749 * d3 + 42 * d2;
> > -       q  = d2 / 10000;
> > -       buf = put_dec_full4(buf, d2 % 10000);
> > -
> > -       d3 = q + 281 * d3;
> > -       q  = d3 / 10000;
> > -       buf = put_dec_full4(buf, d3 % 10000);
> > -
> > -       buf = put_dec_full4(buf, q);
> > +       if (d1) {
> > +               buf = put_dec_full4(buf, d1 % 10000);
> > +               q  = d1 / 10000;
> > +
> > +               d2 = q + 4749 * d3 + 42 * d2;
> > +               if (d2) {
> > +                       buf = put_dec_full4(buf, d2 % 10000);
> > +                       q  = d2 / 10000;
> > +
> > +                       d3 = q + 281 * d3;
> > +                       if (d3) {
> > +                               buf = put_dec_full4(buf, d3 % 10000);
> > +                               q  = d3 / 10000;
> > +
> > +                               if (q)
> > +                                       buf = put_dec_full4(buf, q);
> > +                       }
> > +               }
> > +       }
> >
> >        while (buf[-1] == '0')
> >                --buf;
> 
> Note that this loop handles zeros at the beginning so it's not necessary to
> add the ifs. As I've said, swapping the two lines at the beginning will be
> enough, and I would recommend doing only that.

I realize that zeroes are handled, but I was imagining that one branch
taken (for numbers up to 9999) is cheaper than four out-of-line function
calls, six divisions-or-modulos by constant 10000, three multiplications
by constants; oh, and a lot more once I look inside put_dec_full4().

Is that not the case?  Isn't performance the justification for this magic?

> 
> Once again, sorry about the trouble.

Hugh
