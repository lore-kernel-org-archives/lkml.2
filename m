Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2HNVMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:12:08 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61944 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2HNVMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:12:06 -0400
Date: Tue, 14 Aug 2012 14:12:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] Input: Improve the events-per-packet estimate
Message-ID: <20120814211200.GA32249@core.coreip.homeip.net>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
 <1344807757-2217-3-git-send-email-rydberg@euromail.se>
 <CAF8JNhJzu9wW52PbydVuH9y8TwOs=mPO0DJn0aJBpsh-wETzuQ@mail.gmail.com>
 <2226930.JeU38gc4Sp@dtor-d630.eng.vmware.com>
 <CAF8JNh+sLixXBw7zLFnLSnhR8rq+=cxXm724yJoF9+v9-4fOyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8JNh+sLixXBw7zLFnLSnhR8rq+=cxXm724yJoF9+v9-4fOyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 01:50:38PM -0700, Ping Cheng wrote:
> On Tue, Aug 14, 2012 at 12:53 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Tuesday, August 14, 2012 12:32:21 PM Ping Cheng wrote:
> >> On Sun, Aug 12, 2012 at 2:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >> > Many MT devices send a number of keys along with the mt information.
> >> > This patch makes sure that there is room for them in the packet
> >> > buffer.
> >> >
> >> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> >> > ---
> >> >
> >> >  drivers/input/input.c | 10 +++++++---
> >> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/drivers/input/input.c b/drivers/input/input.c
> >> > index 6e90705..8ebf116 100644
> >> > --- a/drivers/input/input.c
> >> > +++ b/drivers/input/input.c
> >> > @@ -1777,6 +1777,9 @@ static unsigned int
> >> > input_estimate_events_per_packet(struct input_dev *dev)>
> >> >                 if (test_bit(i, dev->relbit))
> >> >
> >> >                         events++;
> >> >
> >> > +       /* Make room for KEY and MSC events */
> >> > +       events += 7;
> >>
> >> Hi Henrik,
> >>
> >> It is nice to get rid of the redundant pieces and to incorporate
> >> common functions. Thank you.
> >>
> >> I have a question about the code above though.  Why do we use 7
> >> instead of going through the keys like:
> >>
> >>       for (i = 0; i < KEY_MAX; i++)
> >>               if (test_bit(i, dev->keybit))
> >>                       events++;
> >
> > Because that would result in gross over-estimation for many devices -
> > my keyboard has 100+ keys but it never sends all of them in one event
> > frame, not even if I can get a cat to lay on it ;)
> 
> Thanks for the prompt reply. I thought you were on vacation ;-).

No, just generally busy ;(

> 
> So, what device are we talking about here? I thought it is a touch
> device with a few extra buttons, which are reported as key events. Am
> I missing something?

I was talking about a bog-standard computer keyboard here.

> 
> If it is a touch device, we won't have too many buttons. So,
> test_bit(i, dev->keybit) won't be true for more than the number of
> buttons that declared by __set_bit().

input_estimate_events_per_packet() is a generic routine that is used for
all devices, not only [multi]touch.

> 
> I would think we could play a keyboard (this keyboard does not have
> letters on it ;-) with ten fingers.

But even that keyboard would have more than 10 keys, right? So even
though max_events should be 10 + 10 + 1 (10 keys, 10 msc, syn) your loop
would produce what 88 + 88 + 1 for full size music keyboard?

Thanks.

-- 
Dmitry
